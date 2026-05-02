#!/usr/bin/env bash
# Túnel SSH: localhost:LOCAL_PORT -> RDS:REMOTE_PORT vía bastión EC2.
# Documentación: ../BASTION.md
#
# Uso típico (MySQL RDS, puerto 3306):
#   cd microservices_strategies/arquitectura_aws && ./scripts/start-rds-tunnel.sh
#
# Postgres local (API Nest en STAGE=dev apunta a 127.0.0.1:5432):
#   LOCAL_PORT=5432 REMOTE_PORT=5432 RDS_HOST=tu-cluster.region.rds.amazonaws.com ./scripts/start-rds-tunnel.sh
#
# Variables opcionales:
#   BASTION_KEY_PATH  ruta al .pem (default: qinspecting-bastion.pem en arquitectura_aws/ o en microservices_strategies/)
#   BASTION_IP        si está vacío, intenta obtenerla con AWS CLI (instancia tag Name=qinspecting-bastion)
#   RDS_HOST          host del RDS (sin puerto)
#   LOCAL_PORT        puerto en tu Mac (ej. 3306 MySQL, 5432 Postgres)
#   REMOTE_PORT       puerto en el RDS (3306 / 5432)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARQ_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$ARQ_ROOT/.." && pwd)"

# Clave: env > arquitectura_aws/ > carpeta microservices_strategies (repo)
DEFAULT_KEY=""
for candidate in "$ARQ_ROOT/qinspecting-bastion.pem" "$REPO_ROOT/qinspecting-bastion.pem"; do
  if [[ -f "$candidate" ]]; then
    DEFAULT_KEY="$candidate"
    break
  fi
done

KEY="${BASTION_KEY_PATH:-$DEFAULT_KEY}"
RDS_HOST="${RDS_HOST:-qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com}"
LOCAL_PORT="${LOCAL_PORT:-3306}"
REMOTE_PORT="${REMOTE_PORT:-3306}"
BASTION_IP="${BASTION_IP:-}"
# Si AWS CLI no devuelve IP (sin credenciales / bastión apagado): última Elastic IP documentada en BASTION.md
BASTION_IP_FALLBACK="${BASTION_IP_FALLBACK:-107.23.150.14}"

if [[ -z "$KEY" || ! -f "$KEY" ]]; then
  echo "No se encontró la clave SSH (probado arquitectura_aws/ y microservices_strategies/)."
  echo "Exporta BASTION_KEY_PATH=/ruta/completa.pem"
  exit 1
fi

chmod 600 "$KEY" 2>/dev/null || true

if [[ -z "${BASTION_IP}" ]]; then
  echo "Obteniendo IP pública del bastión (tag Name=qinspecting-bastion, estado running)..."
  BASTION_IP="$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=qinspecting-bastion" "Name=instance-state-name,Values=running" \
    --query "Reservations[].Instances[].PublicIpAddress | [0]" \
    --output text 2>/dev/null || true)"
fi

if [[ -z "${BASTION_IP}" || "${BASTION_IP}" == "None" ]]; then
  BASTION_IP="${BASTION_IP_FALLBACK}"
  echo "AVISO: usando BASTION_IP_FALLBACK=${BASTION_IP} (export BASTION_IP=... o AWS CLI para la IP real)."
fi

echo "Túnel: 127.0.0.1:${LOCAL_PORT} -> ${RDS_HOST}:${REMOTE_PORT} via ec2-user@${BASTION_IP}"
echo "Deja esta terminal abierta. Ctrl+C cierra el túnel."

exec ssh -N \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o ExitOnForwardFailure=yes \
  -o StrictHostKeyChecking=accept-new \
  -i "$KEY" \
  -L "${LOCAL_PORT}:${RDS_HOST}:${REMOTE_PORT}" \
  "ec2-user@${BASTION_IP}"
