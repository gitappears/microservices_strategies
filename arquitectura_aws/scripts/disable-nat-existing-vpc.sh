#!/usr/bin/env bash
# Elimina NAT Gateway y rutas 0.0.0.0/0 → NAT en una VPC existente (migración dev).
# NO libera la EIP del bastión (tag Name=qinspecting-bastion-eip).
#
# Uso:
#   DRY_RUN=true  ./scripts/disable-nat-existing-vpc.sh                    # solo muestra acciones
#   DRY_RUN=false ./scripts/disable-nat-existing-vpc.sh                    # aplica cambios
#   DRY_RUN=false ./scripts/disable-nat-existing-vpc.sh vpc-04547d461f905b589 us-east-1
#
set -euo pipefail

VPC_ID="${1:-vpc-04547d461f905b589}"
REGION="${2:-us-east-1}"
DRY_RUN="${DRY_RUN:-true}"
BASTION_EIP_TAG="qinspecting-bastion-eip"

if ! aws sts get-caller-identity --region "$REGION" >/dev/null 2>&1; then
  echo "ERROR: credenciales AWS inválidas o expiradas (RequestExpired / ExpiredToken)."
  echo "Renueva la sesión antes de desactivar el NAT:"
  echo "  aws sts get-caller-identity"
  exit 1
fi

echo "VPC: $VPC_ID | Region: $REGION | DRY_RUN: $DRY_RUN"
echo ""

NAT_IDS=$(aws ec2 describe-nat-gateways \
  --region "$REGION" \
  --filter "Name=vpc-id,Values=$VPC_ID" "Name=state,Values=available,pending,deleting" \
  --query 'NatGateways[?State==`available`].NatGatewayId' \
  --output text)

if [[ -z "$NAT_IDS" || "$NAT_IDS" == "None" ]]; then
  echo "No hay NAT Gateway disponible en esta VPC. Nada que hacer."
  exit 0
fi

for NAT_ID in $NAT_IDS; do
  echo "=== NAT: $NAT_ID ==="

  RTB_IDS=$(aws ec2 describe-route-tables \
    --region "$REGION" \
    --filters "Name=vpc-id,Values=$VPC_ID" \
    --query "RouteTables[?Routes[?NatGatewayId=='$NAT_ID']].RouteTableId" \
    --output text)

  for RTB_ID in $RTB_IDS; do
    echo "  Eliminar ruta 0.0.0.0/0 en route table $RTB_ID"
    if [[ "$DRY_RUN" == "false" ]]; then
      aws ec2 delete-route \
        --region "$REGION" \
        --route-table-id "$RTB_ID" \
        --destination-cidr-block 0.0.0.0/0
    fi
  done

  echo "  Eliminar NAT Gateway $NAT_ID"
  if [[ "$DRY_RUN" == "false" ]]; then
    aws ec2 delete-nat-gateway --region "$REGION" --nat-gateway-id "$NAT_ID"
    echo "  Esperando eliminación del NAT..."
    aws ec2 wait nat-gateway-deleted --region "$REGION" --nat-gateway-ids "$NAT_ID"
  fi
done

if [[ "$DRY_RUN" == "false" ]]; then
  echo ""
  echo "=== Revisar EIPs huérfanas (excluyendo bastión) ==="
  aws ec2 describe-addresses --region "$REGION" --filters "Name=domain,Values=vpc" \
    --query 'Addresses[?AssociationId==null].[AllocationId,PublicIp,Tags]' --output table

  ORPHAN_EIPS=$(aws ec2 describe-addresses --region "$REGION" --filters "Name=domain,Values=vpc" \
    --query "Addresses[?AssociationId==null].AllocationId" --output text)

  for ALLOC in $ORPHAN_EIPS; do
    TAG_NAME=$(aws ec2 describe-addresses --region "$REGION" --allocation-ids "$ALLOC" \
      --query 'Addresses[0].Tags[?Key==`Name`].Value | [0]' --output text)
    if [[ "$TAG_NAME" == "$BASTION_EIP_TAG" ]]; then
      echo "  Omitir $ALLOC (EIP del bastión)"
      continue
    fi
    echo "  Liberar EIP huérfana $ALLOC"
    aws ec2 release-address --region "$REGION" --allocation-id "$ALLOC"
  done
fi

echo ""
if [[ "$DRY_RUN" == "true" ]]; then
  echo "Modo simulación. Para aplicar: DRY_RUN=false $0 $VPC_ID $REGION"
else
  echo "NAT desactivado en $VPC_ID. Ahorro estimado: ~32 USD/mes por NAT eliminado."
fi
