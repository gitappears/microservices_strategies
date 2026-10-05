#!/usr/bin/env bash
# Túnel SSH: localhost:LOCAL_PORT -> RDS:REMOTE_PORT vía bastión EC2.
# Documentación: ../BASTION.md
#
# Uso típico (MySQL RDS, puerto 3306):
#   cd microservices_strategies/arquitectura_aws/scripts && ./start-rds-tunnel.sh
#
# Si no tienes qinspecting-bastion.pem, el script usa EC2 Instance Connect
# (clave temporal ~60s) siempre que AWS CLI tenga permisos.
#
# Variables opcionales:
#   BASTION_KEY_PATH     ruta al .pem
#   BASTION_IP           IP pública del bastión
#   BASTION_INSTANCE_ID  id de instancia (si no, busca tag Name=qinspecting-bastion)
#   BASTION_SG_ID        security group para autorizar tu IP (default documentado)
#   SKIP_SG_AUTHORIZE=1  no tocar el security group
#   RDS_HOST             host del RDS (sin puerto)
#   LOCAL_PORT           puerto local (default 3306)
#   REMOTE_PORT          puerto remoto en RDS (default 3306)
#   AWS_REGION           región (default us-east-1)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARQ_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$ARQ_ROOT/.." && pwd)"

AWS_REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-us-east-1}}"
export AWS_DEFAULT_REGION="$AWS_REGION"

RDS_HOST="${RDS_HOST:-qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com}"
LOCAL_PORT="${LOCAL_PORT:-3306}"
REMOTE_PORT="${REMOTE_PORT:-3306}"
BASTION_IP="${BASTION_IP:-}"
BASTION_INSTANCE_ID="${BASTION_INSTANCE_ID:-}"
BASTION_SG_ID="${BASTION_SG_ID:-sg-0bca7597802398cbc}"
BASTION_IP_FALLBACK="${BASTION_IP_FALLBACK:-107.23.150.14}"

TMP_KEY=""
cleanup() {
  if [[ -n "${TMP_KEY}" ]]; then
    rm -f "${TMP_KEY}" "${TMP_KEY}.pub"
  fi
}
trap cleanup EXIT

# --- Clave PEM (si existe) ---
DEFAULT_KEY=""
for candidate in \
  "${BASTION_KEY_PATH:-}" \
  "$ARQ_ROOT/qinspecting-bastion.pem" \
  "$REPO_ROOT/qinspecting-bastion.pem" \
  "$HOME/.ssh/qinspecting-bastion.pem"
do
  [[ -n "$candidate" && -f "$candidate" ]] || continue
  DEFAULT_KEY="$candidate"
  break
done
KEY="${BASTION_KEY_PATH:-$DEFAULT_KEY}"

resolve_instance() {
  if [[ -n "${BASTION_INSTANCE_ID}" ]]; then
    return 0
  fi
  BASTION_INSTANCE_ID="$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=qinspecting-bastion" "Name=instance-state-name,Values=running,pending,stopped" \
    --query "Reservations[].Instances[].InstanceId | [0]" \
    --output text 2>/dev/null || true)"
  if [[ -z "${BASTION_INSTANCE_ID}" || "${BASTION_INSTANCE_ID}" == "None" ]]; then
    echo "No se encontró instancia tag Name=qinspecting-bastion."
    echo "Exporta BASTION_INSTANCE_ID=i-..."
    exit 1
  fi
}

ensure_bastion_running() {
  resolve_instance
  local state
  state="$(aws ec2 describe-instances \
    --instance-ids "$BASTION_INSTANCE_ID" \
    --query "Reservations[0].Instances[0].State.Name" \
    --output text)"
  if [[ "$state" == "stopped" ]]; then
    echo "Bastión detenido. Encendiendo ${BASTION_INSTANCE_ID}..."
    aws ec2 start-instances --instance-ids "$BASTION_INSTANCE_ID" >/dev/null
    aws ec2 wait instance-running --instance-ids "$BASTION_INSTANCE_ID"
    echo "Bastión en running."
  elif [[ "$state" == "pending" ]]; then
    echo "Esperando a que el bastión pase a running..."
    aws ec2 wait instance-running --instance-ids "$BASTION_INSTANCE_ID"
  elif [[ "$state" != "running" ]]; then
    echo "Estado inesperado del bastión: ${state}"
    exit 1
  fi
}

authorize_my_ip() {
  if [[ "${SKIP_SG_AUTHORIZE:-0}" == "1" ]]; then
    return 0
  fi
  local my_ip
  my_ip="$(curl -fsS --max-time 10 ifconfig.me || true)"
  if [[ -z "$my_ip" ]]; then
    echo "AVISO: no se pudo obtener IP pública; omitiendo authorize SG."
    return 0
  fi
  echo "Mi IP pública: ${my_ip}"
  if aws ec2 authorize-security-group-ingress \
    --group-id "$BASTION_SG_ID" \
    --protocol tcp \
    --port 22 \
    --cidr "${my_ip}/32" 2>/dev/null; then
    echo "SSH autorizado desde ${my_ip}/32 en ${BASTION_SG_ID}."
  else
    echo "SG ya permite ${my_ip}/32 (o sin permiso para autorizar). Continuando..."
  fi
}

resolve_bastion_ip() {
  if [[ -n "${BASTION_IP}" && "${BASTION_IP}" != "None" ]]; then
    return 0
  fi
  resolve_instance
  BASTION_IP="$(aws ec2 describe-instances \
    --instance-ids "$BASTION_INSTANCE_ID" \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text 2>/dev/null || true)"
  if [[ -z "${BASTION_IP}" || "${BASTION_IP}" == "None" ]]; then
    BASTION_IP="${BASTION_IP_FALLBACK}"
    echo "AVISO: usando BASTION_IP_FALLBACK=${BASTION_IP}"
  fi
}

prepare_ssh_key() {
  if [[ -n "$KEY" && -f "$KEY" ]]; then
    chmod 600 "$KEY" 2>/dev/null || true
    echo "Usando clave PEM: $KEY"
    return 0
  fi

  echo "No hay qinspecting-bastion.pem; usando EC2 Instance Connect (clave temporal)..."
  resolve_instance
  local az
  az="$(aws ec2 describe-instances \
    --instance-ids "$BASTION_INSTANCE_ID" \
    --query "Reservations[0].Instances[0].Placement.AvailabilityZone" \
    --output text)"

  TMP_KEY="$(mktemp -t qinspecting-bastion-eic)"
  rm -f "$TMP_KEY"
  ssh-keygen -t rsa -f "$TMP_KEY" -N "" -q
  aws ec2-instance-connect send-ssh-public-key \
    --instance-id "$BASTION_INSTANCE_ID" \
    --availability-zone "$az" \
    --instance-os-user ec2-user \
    --ssh-public-key "file://${TMP_KEY}.pub" >/dev/null
  KEY="$TMP_KEY"
  echo "Clave temporal inyectada (válida ~60s para abrir la sesión)."
}

authorize_my_ip
ensure_bastion_running
resolve_bastion_ip
prepare_ssh_key

echo "Túnel: 127.0.0.1:${LOCAL_PORT} -> ${RDS_HOST}:${REMOTE_PORT} via ec2-user@${BASTION_IP}"
echo "Deja esta terminal abierta. Ctrl+C cierra el túnel."

# Sin exec: el trap limpia la clave temporal de Instance Connect al salir.
ssh -N \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=3 \
  -o ExitOnForwardFailure=yes \
  -o StrictHostKeyChecking=accept-new \
  -i "$KEY" \
  -L "${LOCAL_PORT}:${RDS_HOST}:${REMOTE_PORT}" \
  "ec2-user@${BASTION_IP}"