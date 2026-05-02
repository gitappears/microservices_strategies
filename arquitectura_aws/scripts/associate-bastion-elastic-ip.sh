#!/usr/bin/env bash
# Asocia una Elastic IP nueva a la instancia del bastión (sin redesplegar CloudFormation).
# Requisitos: AWS CLI, permisos ec2:AllocateAddress, ec2:AssociateAddress; bastión en subnet pública.
#
# Uso:
#   export AWS_REGION=us-east-1   # opcional
#   ./associate-bastion-elastic-ip.sh
#
# O indica la instancia:
#   BASTION_INSTANCE_ID=i-xxxxxxxx ./associate-bastion-elastic-ip.sh
#
# Si la instancia ya tiene una Elastic IP asociada, el script sale sin crear otra.

set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
INSTANCE_ID="${BASTION_INSTANCE_ID:-}"

if [[ -z "${INSTANCE_ID}" ]]; then
  INSTANCE_ID="$(aws ec2 describe-instances --region "${REGION}" \
    --filters "Name=tag:Name,Values=qinspecting-bastion" "Name=instance-state-name,Values=running,pending,stopped" \
    --query "Reservations[0].Instances[0].InstanceId" --output text 2>/dev/null || true)"
fi

if [[ -z "${INSTANCE_ID}" || "${INSTANCE_ID}" == "None" ]]; then
  echo "No se encontró instancia tag Name=qinspecting-bastion. Exporta BASTION_INSTANCE_ID=i-..."
  exit 1
fi

echo "Instancia: ${INSTANCE_ID}"

EXISTING_EIP="$(aws ec2 describe-addresses --region "${REGION}" \
  --filters "Name=instance-id,Values=${INSTANCE_ID}" \
  --query "Addresses[0].AllocationId" --output text 2>/dev/null || true)"

if [[ -n "${EXISTING_EIP}" && "${EXISTING_EIP}" != "None" ]]; then
  aws ec2 describe-addresses --region "${REGION}" --allocation-ids "${EXISTING_EIP}" \
    --query "Addresses[0].[PublicIp,AllocationId]" --output text
  echo "Ya hay Elastic IP asociada a esta instancia (arriba). No se creó otra."
  exit 0
fi

ALLOC_ID="$(aws ec2 allocate-address --domain vpc --region "${REGION}" \
  --tag-specifications "ResourceType=elastic-ip,Tags=[{Key=Name,Value=qinspecting-bastion-eip}]" \
  --query AllocationId --output text)"

echo "AllocationId: ${ALLOC_ID}"

aws ec2 associate-address --region "${REGION}" \
  --instance-id "${INSTANCE_ID}" \
  --allocation-id "${ALLOC_ID}"

PUBLIC_IP="$(aws ec2 describe-addresses --region "${REGION}" --allocation-ids "${ALLOC_ID}" \
  --query "Addresses[0].PublicIp" --output text)"

echo "Elastic IP pública: ${PUBLIC_IP}"
echo "Actualiza la documentación / BASTION_IP en scripts con esta IP."
