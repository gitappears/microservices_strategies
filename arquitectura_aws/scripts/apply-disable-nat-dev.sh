#!/usr/bin/env bash
# Flujo completo: verificar → simular → aplicar → verificar (VPC dev documentada).
#
# Uso:
#   ./scripts/apply-disable-nat-dev.sh              # solo simulación + estado actual
#   APPLY=true ./scripts/apply-disable-nat-dev.sh   # aplica desactivación real
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VPC_ID="${VPC_ID:-vpc-04547d461f905b589}"
REGION="${AWS_REGION:-us-east-1}"
APPLY="${APPLY:-false}"

echo "========== 1/4 — Credenciales AWS =========="
if ! aws sts get-caller-identity --region "$REGION" >/dev/null 2>&1; then
  echo "ERROR: credenciales expiradas o no configuradas."
  echo "Renueva sesión y repite. Ejemplo:"
  echo "  aws sts get-caller-identity"
  exit 1
fi
aws sts get-caller-identity --output table

echo ""
echo "========== 2/4 — Estado actual =========="
"$SCRIPT_DIR/verify-nat-status.sh" "$VPC_ID" "$REGION"

echo ""
echo "========== 3/4 — Simulación (DRY_RUN) =========="
DRY_RUN=true "$SCRIPT_DIR/disable-nat-existing-vpc.sh" "$VPC_ID" "$REGION"

if [[ "$APPLY" != "true" ]]; then
  echo ""
  echo "Simulación completada. Para aplicar en AWS:"
  echo "  APPLY=true $0"
  echo "  # o:"
  echo "  DRY_RUN=false $SCRIPT_DIR/disable-nat-existing-vpc.sh $VPC_ID $REGION"
  exit 0
fi

echo ""
echo "========== 4/4 — Aplicando desactivación =========="
DRY_RUN=false "$SCRIPT_DIR/disable-nat-existing-vpc.sh" "$VPC_ID" "$REGION"

echo ""
echo "========== Verificación final =========="
"$SCRIPT_DIR/verify-nat-status.sh" "$VPC_ID" "$REGION"
