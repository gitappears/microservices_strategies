#!/usr/bin/env python3
# =============================================================================
# Crea las bases de datos leyendo rds-databases-config.yml
# Uso:
#   Solo SQL (--dry-run):  python3 create-databases-from-config.py --dry-run
#   Ejecutar en MySQL:     python3 create-databases-from-config.py [host] [user] [password]
#   Por defecto: host=localhost, user=root, password=''
# =============================================================================

import argparse
import os
import subprocess
import sys

try:
    import yaml
except ImportError:
    print("Necesitas PyYAML: pip install pyyaml", file=sys.stderr)
    sys.exit(1)

DIR_SCRIPT = os.path.dirname(os.path.abspath(__file__))
# Config en el mismo nivel que la carpeta scripts/
CONFIG_PATH = os.path.normpath(os.path.join(DIR_SCRIPT, "..", "rds-databases-config.yml"))


def load_config():
    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)


def main():
    parser = argparse.ArgumentParser(description="Crear bases de datos desde rds-databases-config.yml")
    parser.add_argument("--dry-run", action="store_true", help="Solo imprimir SQL, no ejecutar")
    parser.add_argument("host", nargs="?", default="localhost", help="Host MySQL (ej. endpoint RDS)")
    parser.add_argument("user", nargs="?", default="root", help="Usuario MySQL")
    parser.add_argument("password", nargs="?", default="", help="Contraseña MySQL")
    args = parser.parse_args()

    config = load_config()
    defaults = config.get("defaults", {})
    charset = defaults.get("charset", "utf8mb4")
    collation = defaults.get("collation", "utf8mb4_unicode_ci")
    databases = config.get("databases", [])

    statements = []
    for db in databases:
        name = db.get("name")
        if not name:
            continue
        stmt = f"CREATE DATABASE IF NOT EXISTS `{name}` CHARACTER SET {charset} COLLATE {collation};"
        statements.append(stmt)

    sql = "\n".join(statements)
    if args.dry_run:
        print("-- Generado desde rds-databases-config.yml")
        print(sql)
        return

    env = os.environ.copy()
    if args.password:
        env["MYSQL_PWD"] = args.password
    try:
        subprocess.run(
            ["mysql", "-h", args.host, "-u", args.user, "-e", sql],
            env=env,
            check=True,
        )
        print(f"Bases creadas en {args.host}: {', '.join(d.get('name') for d in databases)}")
    except FileNotFoundError:
        print("No se encontró el cliente 'mysql'. Instálalo o usa --dry-run y ejecuta el SQL a mano.", file=sys.stderr)
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print(f"Error ejecutando MySQL: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
