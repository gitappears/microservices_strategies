#!/usr/bin/env bash
# Crea VPC interface endpoint com.amazonaws.<region>.cognito-idp para compute en VPC sin NAT.
# Historico: Lambda backend. Actual: EC2 API (qinspecting-api-ec2-*) si se mueve a subnet privada.
#
# Uso:
#   aws sts get-caller-identity   # renovar credenciales si ExpiredToken
#   ./scripts/deploy-cognito-vpc-endpoint.sh dev
#   ./scripts/deploy-cognito-vpc-endpoint.sh dev <instance-id-o-sg-ec2-api>
#   EC2_API_SG=sg-015ad3b3b0d117e67 ./scripts/deploy-cognito-vpc-endpoint.sh dev
#
set -euo pipefail

ENV="${1:-dev}"
LAMBDA_FN="${2:-man-qinspecting-backend-api-dev-handler}"
EC2_API_SG="${EC2_API_SG:-${3:-}}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REGION="${AWS_REGION:-us-east-1}"
STACK_NAME="qinspecting-vpc-endpoint-cognito-${ENV}"
DEFAULT_VPC_ID="${QINSPECTING_VPC_ID:-vpc-04547d461f905b589}"

echo "==> Región: $REGION | Lambda: $LAMBDA_FN | Stack: $STACK_NAME"

aws sts get-caller-identity --output text >/dev/null

read -r VPC_ID SUBNET_CSV LAMBDA_SG <<< "$(
  aws lambda get-function-configuration \
    --region "$REGION" \
    --function-name "$LAMBDA_FN" \
    --query '[VpcConfig.VpcId, join(`,`, VpcConfig.SubnetIds), VpcConfig.SecurityGroupIds[0]]' \
    --output text 2>/dev/null || echo 'None None None'
)"

if [[ -z "$VPC_ID" || "$VPC_ID" == "None" ]]; then
  echo "==> Lambda sin VPC config; usando VPC por defecto $DEFAULT_VPC_ID"
  VPC_ID="$DEFAULT_VPC_ID"
fi

if [[ -z "$SUBNET_CSV" || "$SUBNET_CSV" == "None" ]]; then
  echo "==> Descubriendo subnets privadas en $VPC_ID (MapPublicIpOnLaunch=false)..."
  SUBNET_CSV="$(
    aws ec2 describe-subnets \
      --region "$REGION" \
      --filters "Name=vpc-id,Values=$VPC_ID" "Name=map-public-ip-on-launch,Values=false" \
      --query 'Subnets[*].SubnetId' \
      --output text | tr '\t' ','
  )"
fi

if [[ -z "$LAMBDA_SG" || "$LAMBDA_SG" == "None" ]]; then
  echo "==> Descubriendo security group de Lambda por tag/name..."
  LAMBDA_SG="$(
    aws ec2 describe-security-groups \
      --region "$REGION" \
      --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=*lambda*" \
      --query 'SecurityGroups[0].GroupId' \
      --output text 2>/dev/null || echo 'None'
  )"
fi

if [[ -z "$SUBNET_CSV" || "$SUBNET_CSV" == "None" ]]; then
  echo "ERROR: No se encontraron subnets privadas. Pasa QINSPECTING_VPC_ID y revisa la VPC."
  exit 1
fi

if [[ -z "$LAMBDA_SG" || "$LAMBDA_SG" == "None" ]]; then
  echo "ERROR: No se encontró security group de Lambda. Asigna VpcConfig a la función o exporta LAMBDA_SG."
  exit 1
fi

echo "==> VPC:        $VPC_ID"
echo "==> Subnets:    $SUBNET_CSV"
echo "==> Lambda SG:  $LAMBDA_SG"

EXISTING="$(
  aws ec2 describe-vpc-endpoints \
    --region "$REGION" \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=service-name,Values=com.amazonaws.${REGION}.cognito-idp" \
    --query 'VpcEndpoints[?State!=`deleted`].VpcEndpointId' \
    --output text
)"

if [[ -n "$EXISTING" && "$EXISTING" != "None" ]]; then
  echo "==> Ya existe endpoint cognito-idp en la VPC: $EXISTING (se actualizará vía CloudFormation si aplica)"
fi

aws cloudformation deploy \
  --region "$REGION" \
  --template-file "$ROOT_DIR/network/vpc-endpoint-cognito.yaml" \
  --stack-name "$STACK_NAME" \
  --parameter-overrides \
    "EnvironmentName=$ENV" \
    "VpcId=$VPC_ID" \
    "PrivateSubnetIds=$SUBNET_CSV" \
    "LambdaSecurityGroupId=$LAMBDA_SG" \
  --no-fail-on-empty-changeset

# Lambda puede tener varios SG; asegurar ingress 443 desde todos
LAMBDA_ALL_SGS="$(
  aws lambda get-function-configuration \
    --region "$REGION" \
    --function-name "$LAMBDA_FN" \
    --query 'VpcConfig.SecurityGroupIds' \
    --output text 2>/dev/null || true
)"
ENDPOINT_SG="$(
  aws cloudformation describe-stacks \
    --region "$REGION" \
    --stack-name "$STACK_NAME" \
    --query 'Stacks[0].Outputs[?OutputKey==`EndpointSecurityGroupId`].OutputValue' \
    --output text
)"
for SG in $LAMBDA_ALL_SGS; do
  [[ -z "$SG" || "$SG" == "None" ]] && continue
  aws ec2 authorize-security-group-ingress \
    --region "$REGION" \
    --group-id "$ENDPOINT_SG" \
    --ip-permissions "IpProtocol=tcp,FromPort=443,ToPort=443,UserIdGroupPairs=[{GroupId=$SG,Description='Lambda SG to Cognito endpoint'}]" \
    2>/dev/null || true
done

if [[ -n "$EC2_API_SG" && "$EC2_API_SG" != "None" ]]; then
  aws ec2 authorize-security-group-ingress \
    --region "$REGION" \
    --group-id "$ENDPOINT_SG" \
    --ip-permissions "IpProtocol=tcp,FromPort=443,ToPort=443,UserIdGroupPairs=[{GroupId=$EC2_API_SG,Description='EC2 API to Cognito endpoint'}]" \
    2>/dev/null || true
  echo "==> EC2 API SG autorizado en endpoint: $EC2_API_SG"
fi

echo ""
echo "==> Outputs del stack:"
aws cloudformation describe-stacks \
  --region "$REGION" \
  --stack-name "$STACK_NAME" \
  --query 'Stacks[0].Outputs' \
  --output table

ENDPOINT_STATE="$(
  aws ec2 describe-vpc-endpoints \
    --region "$REGION" \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=service-name,Values=com.amazonaws.${REGION}.cognito-idp" \
    --query 'VpcEndpoints[0].State' \
    --output text
)"
echo ""
echo "==> Estado endpoint: $ENDPOINT_STATE (available = listo)"

API_URL="${QINSPECTING_DEV_API_URL:-https://ed64jjgsc2.execute-api.us-east-1.amazonaws.com/dev/api/auth/login}"
echo ""
echo "==> Prueba login (esperado: 401/400, NO 503 de red):"
echo "    curl -X POST '$API_URL' -H 'Content-Type: application/json' -d '{\"usuario\":\"test\",\"password\":\"test\"}'"
HTTP_CODE="$(
  curl -sS -o /tmp/cognito-login-test.json -w '%{http_code}' \
    -X POST "$API_URL" \
    -H 'Content-Type: application/json' \
    -d '{"usuario":"test","password":"test"}' || true
)"
echo "    HTTP $HTTP_CODE — $(head -c 200 /tmp/cognito-login-test.json 2>/dev/null || true)"
if [[ "$HTTP_CODE" == "503" ]]; then
  echo "    AVISO: sigue 503; espera 1-2 min a que el endpoint esté 'available' y reintenta."
  exit 1
fi

echo ""
echo "Listo. Cognito accesible desde Lambda vía VPC endpoint (sin NAT)."
