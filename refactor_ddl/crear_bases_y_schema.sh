#!/usr/bin/env bash
# =============================================================================
# Crear bases de datos y aplicar DDL refactorizado (7 bases por sistema)
# Uso: ./crear_bases_y_schema.sh [host] [user] [password] [port]
# Por defecto: host=localhost, user=root, password='', port=3306
# Con túnel SSH: ssh -L 3306:RDS_ENDPOINT:3306 -i key.pem ec2-user@BASTION_IP
#               luego ./crear_bases_y_schema.sh 127.0.0.1 qinspect_admin 'password'
# =============================================================================

set -e
MYSQL_HOST="${1:-localhost}"
MYSQL_USER="${2:-root}"
MYSQL_PWD="${3:-}"
MYSQL_PORT="${4:-3306}"
DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "$MYSQL_PWD" ]; then
  export MYSQL_PWD
fi

echo "Creando bases en $MYSQL_HOST:$MYSQL_PORT como $MYSQL_USER..."

mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -e "
  CREATE DATABASE IF NOT EXISTS bd_tenancy_planes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS bd_personal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS bd_inspecciones CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS bd_mantenimientos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS bd_inventario CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS bd_capacitaciones CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
  CREATE DATABASE IF NOT EXISTS bd_flota_documentos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
"

for name in 01_bd_tenancy_planes 02_bd_personal 03_bd_inspecciones 04_bd_mantenimientos 05_bd_inventario 06_bd_capacitaciones 07_bd_flota_documentos; do
  echo "Aplicando $name/00_schema.sql..."
  mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" "${name#*_}" < "$DIR_SCRIPT/$name/00_schema.sql"
  if [ -f "$DIR_SCRIPT/$name/01_catalogos.sql" ]; then
    echo "Aplicando $name/01_catalogos.sql..."
    mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" "${name#*_}" < "$DIR_SCRIPT/$name/01_catalogos.sql"
  fi
done

echo "Listo. Para cargar datos:"
echo "  - bd_tenancy_planes: restaurar qinspect_planesQi.sql y ejecutar 01_bd_tenancy_planes/01_migrate_from_planesQi.sql"
echo "  - Resto: ver MAPEO_ORIGEN.md en cada carpeta (inyectar id_empresa desde ten_empresas.base_legacy)."
