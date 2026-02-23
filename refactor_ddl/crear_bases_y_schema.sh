#!/usr/bin/env bash
# =============================================================================
# Crear bases de datos y aplicar DDL refactorizado (7 bases por sistema)
# Uso: ./crear_bases_y_schema.sh [host] [user] [password]
# Por defecto: host=localhost, user=root, password=''
# =============================================================================

set -e
MYSQL_HOST="${1:-localhost}"
MYSQL_USER="${2:-root}"
MYSQL_PWD="${3:-}"
DIR_SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -n "$MYSQL_PWD" ]; then
  export MYSQL_PWD
fi

echo "Creando bases en $MYSQL_HOST como $MYSQL_USER..."

mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" -e "
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
  mysql -h "$MYSQL_HOST" -u "$MYSQL_USER" "${name#*_}" < "$DIR_SCRIPT/$name/00_schema.sql"
done

echo "Listo. Para cargar datos:"
echo "  - bd_tenancy_planes: restaurar qinspect_planesQi.sql y ejecutar 01_bd_tenancy_planes/01_migrate_from_planesQi.sql"
echo "  - Resto: ver MAPEO_ORIGEN.md en cada carpeta (inyectar id_empresa desde ten_empresas.base_legacy)."
