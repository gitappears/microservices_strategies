# Bastión QInspecting – Acceso a RDS

Bastión EC2 para conectarte a RDS (en subnets privadas) por SSH y desde ahí ejecutar MySQL.

## Datos actuales

| Dato | Valor |
|------|--------|
| **IP pública** | `3.236.168.134` |
| **Usuario SSH** | `ec2-user` |
| **Clave privada** | `arquitectura_aws/qinspecting-bastion.pem` |
| **Security Group bastión** | `sg-0bca7597802398cbc` |
| **RDS endpoint** | `qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com` |

## Conexión

```bash
# 1. SSH al bastión (desde la carpeta del repo)
ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@3.236.168.134

# 2. En el bastión: instalar MySQL client (solo la primera vez)
sudo yum install -y mysql

# 3. Conectar a RDS
mysql -h qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com -u qinspect_admin -p
```

## Crear las 7 bases desde el bastión

Opción A – Ejecutar SQL a mano (después de conectar con `mysql`):

```sql
CREATE DATABASE IF NOT EXISTS bd_tenancy_planes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS bd_personal CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS bd_inspecciones CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS bd_mantenimientos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS bd_inventario CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS bd_capacitaciones CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS bd_flota_documentos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Opción B – Copiar el repo al bastión y ejecutar el script:

```bash
# Desde tu PC: copiar scripts y DDL al bastión
scp -i arquitectura_aws/qinspecting-bastion.pem -r refactor_ddl ec2-user@3.236.168.134:~
# En el bastión
cd refactor_ddl && ./crear_bases_y_schema.sh qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com qinspect_admin '<password>'
```

## Seguridad

- SSH (22) está permitido **solo desde tu IP** (`191.107.171.174/32`). Si tu IP cambia, actualiza la regla en el SG `sg-0bca7597802398cbc`.
- RDS (3306) acepta tráfico **solo desde el SG del bastión**, no desde internet.
- El archivo `.pem` está en `.gitignore`; no lo subas al repositorio.

## Recrear el bastión (CLI)

Si eliminas la instancia y quieres crear otra con la misma lógica (sin CloudFormation):

```bash
# Crear SG
aws ec2 create-security-group --group-name qinspecting-bastion-sg --description "SSH for QInspecting bastion" --vpc-id vpc-04547d461f905b589

# Permitir SSH desde tu IP (sustituir TU_IP/32)
aws ec2 authorize-security-group-ingress --group-id sg-XXXXX --protocol tcp --port 22 --cidr TU_IP/32

# Permitir 3306 en el SG de RDS desde el SG del bastión
aws ec2 authorize-security-group-ingress --group-id sg-0b80ffe46c23fef46 --protocol tcp --port 3306 --source-group sg-XXXXX

# Lanzar instancia (sustituir sg-XXXXX y subnet por tus valores)
aws ec2 run-instances --image-id ami-0199fa5fada510433 --instance-type t3.micro --key-name qinspecting-bastion \
  --subnet-id subnet-0b22e33560b7e6b8a --security-group-ids sg-XXXXX --associate-public-ip-address
```
