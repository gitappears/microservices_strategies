#!/usr/bin/env bash
# Estado del NAT Gateway y rutas asociadas en una VPC (pre/post desactivación).
#
# Uso:
#   ./scripts/verify-nat-status.sh
#   ./scripts/verify-nat-status.sh vpc-04547d461f905b589 us-east-1
#
set -euo pipefail

VPC_ID="${1:-vpc-04547d461f905b589}"
REGION="${2:-us-east-1}"
BASTION_EIP_TAG="qinspecting-bastion-eip"

if ! aws sts get-caller-identity --region "$REGION" >/dev/null 2>&1; then
  echo "ERROR: credenciales AWS inválidas o expiradas."
  echo "Renueva el token (aws configure / SSO / variables de sesión) y vuelve a ejecutar."
  exit 1
fi

ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
echo "Cuenta: $ACCOUNT | VPC: $VPC_ID | Región: $REGION"
echo ""

echo "=== NAT Gateways ==="
NAT_JSON=$(aws ec2 describe-nat-gateways \
  --region "$REGION" \
  --filter "Name=vpc-id,Values=$VPC_ID" \
  --query 'NatGateways[?State!=`deleted`].[NatGatewayId,State,SubnetId,NatGatewayAddresses[0].PublicIp,NatGatewayAddresses[0].AllocationId]' \
  --output json)

if [[ "$NAT_JSON" == "[]" ]]; then
  echo "  (ninguno — NAT desactivado)"
else
  echo "$NAT_JSON" | python3 -m json.tool 2>/dev/null || echo "$NAT_JSON"
fi

echo ""
echo "=== Route tables con 0.0.0.0/0 → NAT ==="
aws ec2 describe-route-tables \
  --region "$REGION" \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query 'RouteTables[?Routes[?DestinationCidrBlock==`0.0.0.0/0` && NatGatewayId!=null]].[RouteTableId,Tags[?Key==`Name`].Value | [0],Routes[?DestinationCidrBlock==`0.0.0.0/0` && NatGatewayId!=null].[NatGatewayId,State] | [0]]' \
  --output table 2>/dev/null || echo "  (ninguna)"

echo ""
echo "=== Elastic IPs (VPC) sin asociar ==="
ORPHAN=$(aws ec2 describe-addresses \
  --region "$REGION" \
  --filters "Name=domain,Values=vpc" \
  --query "Addresses[?AssociationId==null].[AllocationId,PublicIp,Tags[?Key=='Name'].Value | [0]]" \
  --output text)

if [[ -z "$ORPHAN" ]]; then
  echo "  (ninguna huérfana)"
else
  while IFS=$'\t' read -r ALLOC IP TAG; do
    if [[ "$TAG" == "$BASTION_EIP_TAG" ]]; then
      echo "  $ALLOC  $IP  tag=$TAG  (bastión — conservar)"
    else
      echo "  $ALLOC  $IP  tag=${TAG:-sin tag}  (candidata a liberar tras delete NAT)"
    fi
  done <<< "$ORPHAN"
fi

echo ""
ACTIVE_COUNT=$(aws ec2 describe-nat-gateways \
  --region "$REGION" \
  --filter "Name=vpc-id,Values=$VPC_ID" "Name=state,Values=available,pending" \
  --query 'length(NatGateways)' \
  --output text)

if [[ "$ACTIVE_COUNT" == "0" ]]; then
  echo "Resultado: NAT desactivado en esta VPC."
else
  echo "Resultado: hay $ACTIVE_COUNT NAT Gateway(s) activo(s). Ejecuta disable-nat-existing-vpc.sh para eliminarlos."
fi
