#!/usr/bin/env bash
# Despliega la VPC QInspecting (nuevos entornos).
#
# Uso:
#   ./scripts/deploy-network.sh dev     # sin NAT (~32 USD/mes menos)
#   ./scripts/deploy-network.sh prod    # con NAT Gateway
#
set -euo pipefail

ENV="${1:-dev}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REGION="${AWS_REGION:-us-east-1}"

case "$ENV" in
  dev|staging)
    PARAM_FILE="$ROOT_DIR/network/parameters-dev.json"
    STACK_NAME="qinspecting-network-dev"
    ;;
  prod)
    PARAM_FILE="$ROOT_DIR/network/parameters-prod.json"
    STACK_NAME="qinspecting-network-prod"
    ;;
  *)
    echo "Entorno no válido: $ENV (usa dev, staging o prod)"
    exit 1
    ;;
esac

echo "Desplegando stack $STACK_NAME en $REGION con $PARAM_FILE"

aws cloudformation deploy \
  --region "$REGION" \
  --template-file "$ROOT_DIR/network/vpc-network.yaml" \
  --stack-name "$STACK_NAME" \
  --parameter-overrides file://"$PARAM_FILE" \
  --no-fail-on-empty-changeset

echo ""
echo "Outputs:"
aws cloudformation describe-stacks \
  --region "$REGION" \
  --stack-name "$STACK_NAME" \
  --query 'Stacks[0].Outputs' \
  --output table
