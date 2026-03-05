# Bastión QInspecting – Acceso a RDS

Bastión EC2 para conectarte a RDS (en subnets privadas) por SSH y desde ahí ejecutar MySQL.

## Reducir costos: apagar el bastión cuando no se use

El bastión es una instancia EC2 que cobra por horas de uso. **Se recomienda apagarlo cuando no lo vayas a usar** y encenderlo solo cuando necesites acceso a RDS. Así dejas de pagar por vCPU/memoria (solo se cobra el disco EBS, mucho menor).

**Apagar el bastión:**

```bash
# Obtener el InstanceId (consola EC2 o):
aws ec2 describe-instances --filters "Name=tag:Name,Values=qinspecting-bastion" --query "Reservations[].Instances[].InstanceId" --output text

# Apagar
aws ec2 stop-instances --instance-ids <INSTANCE_ID>
```

**Cuando vuelvas a necesitar acceso:** encender el bastión, comprobar si la IP cambió y, si tu IP pública cambió, actualizar el Security Group. El **paso a paso completo** (encender → comprobar estado e IP → configurar tu IP en el SG → conectar) está en el [README – Acceso a RDS vía bastión](README.md#acceso-a-rds-vía-bastión).

Resumen rápido para encender:

```bash
aws ec2 start-instances --instance-ids <INSTANCE_ID>
# Esperar 1–2 min, luego obtener la nueva IP:
aws ec2 describe-instances --filters "Name=tag:Name,Values=qinspecting-bastion" --query "Reservations[].Instances[].[State.Name,PublicIpAddress]" --output table
```

## Datos actuales

| Dato | Valor |
|------|--------|
| **IP pública** | `3.236.168.134` (puede cambiar si el bastión se apagó y se volvió a encender; ver [Troubleshooting](#troubleshooting-connection-timed-out-al-hacer-ssh)) |
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

## Túnel SSH para APIs locales (qinspecting_api_nest, etc.)

Para que una API que corre en tu PC (por ejemplo `qinspecting_api_nest`) se conecte a RDS, RDS no es accesible directamente desde internet. Hay que abrir un **túnel SSH con redirección de puerto** (-L) desde tu máquina al bastión y de ahí al RDS.

### 1. Abrir el túnel (dejar esta terminal abierta)

Desde la raíz del repo `bases_qinspecting`:

```bash
ssh -i arquitectura_aws/qinspecting-bastion.pem -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 ec2-user@3.236.168.134
```

Con eso, **localhost:3306** en tu PC redirige al puerto 3306 del RDS. No hace falta ejecutar nada dentro del bastión; la sesión puede quedar abierta.

### 2. Configurar la API para usar el túnel

En el `.env` del proyecto de la API (ej. `qinspecting_api_nest`):

- **Host:** `127.0.0.1` (o `localhost`)
- **Puerto:** `3306`
- **Usuario y contraseña:** los del RDS (`qinspect_admin` y la contraseña del stack)
- **SSL:** desactivado al usar túnel (`DATABASE_SSL=false`)

Ejemplo mínimo:

```env
DATABASE_HOST=127.0.0.1
DATABASE_PORT=3306
DATABASE_USER=qinspect_admin
DATABASE_PASSWORD=tu_password_rds
DATABASE_NAME=bd_tenancy_planes
DATABASE_SSL=false
```

Si la API usa varias bases (tenancy, personal, mantenimientos, etc.), define cada una con `DATABASE_NAME_TENANCY`, `DATABASE_NAME_PERSONAL`, etc., según el proyecto.

### Resumen

| Paso | Acción |
|------|--------|
| 1 | Abrir túnel: `ssh -i arquitectura_aws/qinspecting-bastion.pem -L 3306:qinspecting-prod....rds.amazonaws.com:3306 ec2-user@3.236.168.134` |
| 2 | En `.env` de la API: `DATABASE_HOST=127.0.0.1`, `DATABASE_PORT=3306`, usuario/contraseña RDS, `DATABASE_SSL=false` |
| 3 | Arrancar la API en otra terminal; se conectará a RDS a través del túnel |

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

## Actualizar tablas en RDS (aplicar DDL)

Cuando cambies los archivos `refactor_ddl/*/00_schema.sql` en tu PC, así aplicas los cambios en RDS desde el bastión.

### 1. Copiar la carpeta DDL al bastión

Desde tu PC (en la raíz del repo `bases_qinspecting`):

```bash
scp -i arquitectura_aws/qinspecting-bastion.pem -r refactor_ddl ec2-user@3.236.168.134:~
```

### 2. Conectarte al bastión y aplicar el esquema

**Opción A – Actualizar una sola base desde tu PC** (túnel SSH abierto en otra terminal):

```bash
# Terminal 1: deja el túnel abierto
cd ~/Documents/projects/appears/bases_qinspecting
ssh -i arquitectura_aws/qinspecting-bastion.pem -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 ec2-user@3.236.168.134

# Terminal 2: aplica el schema (usa 127.0.0.1 porque el túnel redirige al RDS)
cd ~/Documents/projects/appears/bases_qinspecting
mysql -h 127.0.0.1 -P 3306 -u qinspect_admin -p bd_capacitaciones < refactor_ddl/06_bd_capacitaciones/00_schema.sql
```

**Opción A2 – Actualizar una base desde el bastión** (después de copiar refactor_ddl al bastión):

```bash
ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@3.236.168.134

mysql -h qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com -u qinspect_admin -p bd_capacitaciones < ~/refactor_ddl/06_bd_capacitaciones/00_schema.sql
```

**Opción B – Actualizar todas las bases** (vuelve a aplicar cada `00_schema.sql`):

```bash
RDS="qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com"
USER="qinspect_admin"
# Pide la contraseña una vez
read -s PASS && export MYSQL_PWD="$PASS"

for dir in ~/refactor_ddl/01_bd_tenancy_planes ~/refactor_ddl/02_bd_personal ~/refactor_ddl/03_bd_inspecciones ~/refactor_ddl/04_bd_mantenimientos ~/refactor_ddl/05_bd_inventario ~/refactor_ddl/06_bd_capacitaciones ~/refactor_ddl/07_bd_flota_documentos; do
  base=$(basename "$dir" | sed 's/^[0-9]*_//')
  echo "Aplicando $base..."
  mysql -h "$RDS" -u "$USER" "$base" < "$dir/00_schema.sql"
done
unset MYSQL_PWD
```

**Opción C – Recrear bases y esquemas desde cero** (borra datos de esas bases):

```bash
cd ~/refactor_ddl && ./crear_bases_y_schema.sh qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com qinspect_admin '<password>'
```

### Nota

Los `00_schema.sql` usan **CREATE TABLE IF NOT EXISTS**: se crean tablas nuevas que falten, pero **no se modifican tablas ya existentes** (no se añaden columnas ni se cambian tipos). Si necesitas cambiar la estructura de una tabla ya creada, tienes que:

- escribir y ejecutar **ALTER TABLE** a mano en esa base, o  
- **borrar esa base**, crearla de nuevo y volver a ejecutar su `00_schema.sql` (solo si puedes perder los datos de esa base).

## Troubleshooting: "Connection timed out" al hacer SSH

Si `ssh ... ec2-user@3.236.168.134` devuelve **Connection timed out**, suele ser por:

1. **Bastión apagado** → la IP pública se pierde o cambia al encender de nuevo.
2. **Tu IP pública cambió** → el Security Group solo permite SSH desde una IP concreta (`191.107.171.174/32`). Si cambiaste de red (Wi‑Fi, 4G, otra casa), tu IP ya no coincide.

### 1. Comprobar estado del bastión y su IP actual

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=qinspecting-bastion" \
  --query "Reservations[].Instances[].[State.Name,PublicIpAddress,InstanceId]" \
  --output table
```

- Si **State** es `stopped`: enciende la instancia con `aws ec2 start-instances --instance-ids <INSTANCE_ID>` y espera 1–2 minutos. Vuelve a ejecutar la query para obtener la **nueva** `PublicIpAddress` y usa esa IP en el comando `ssh`.
- Si **State** es `running` y **PublicIpAddress** es distinta de `3.236.168.134`, usa la IP que salga en el comando SSH.

### 2. Ver tu IP pública actual

```bash
curl -s ifconfig.me
```

Compara con la IP permitida en el SG (`191.107.171.174`). Si es distinta, hay que actualizar la regla.

### 3. Actualizar el Security Group con tu IP actual

Permitir SSH solo desde tu IP actual (reemplaza `TU_IP_ACTUAL` por la que devolvió `curl -s ifconfig.me`):

```bash
# Quitar la regla antigua (opcional, si quieres dejar solo una IP)
aws ec2 revoke-security-group-ingress --group-id sg-0bca7597802398cbc --protocol tcp --port 22 --cidr 191.107.171.174/32

# Añadir tu IP actual
aws ec2 authorize-security-group-ingress --group-id sg-0bca7597802398cbc --protocol tcp --port 22 --cidr TU_IP_ACTUAL/32
```

O en un solo paso (añade la nueva IP sin borrar la anterior, por si usas varias redes):

```bash
MY_IP=$(curl -s ifconfig.me)
aws ec2 authorize-security-group-ingress --group-id sg-0bca7597802398cbc --protocol tcp --port 22 --cidr ${MY_IP}/32
```

Después de esto, prueba de nuevo el SSH (con la IP del bastión que obtuviste en el paso 1).

## Troubleshooting: "channel X: open failed: administratively prohibited"

Si al usar el **túnel** (`ssh -i ... -L 3306:... ec2-user@...`) ves **"channel 3: open failed: administratively prohibited"**, el servidor SSH del bastión tiene deshabilitado el reenvío TCP (port forwarding). Hay que habilitarlo **una vez en el bastión actual**:

1. Conéctate al bastión **sin** túnel (solo SSH normal):
   ```bash
   ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@3.236.168.134
   ```
2. En el bastión, edita la configuración de SSH y habilita el reenvío:
   ```bash
   sudo sed -i 's/^#*AllowTcpForwarding.*/AllowTcpForwarding yes/' /etc/ssh/sshd_config
   grep -q '^AllowTcpForwarding' /etc/ssh/sshd_config || echo 'AllowTcpForwarding yes' | sudo tee -a /etc/ssh/sshd_config
   sudo systemctl restart sshd
   ```
3. Sal del bastión (`exit`) y vuelve a abrir el túnel desde tu PC:
   ```bash
   ssh -i arquitectura_aws/qinspecting-bastion.pem -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 ec2-user@3.236.168.134
   ```

En futuros despliegues con la plantilla `bastion.yaml` (CloudFormation), el UserData ya habilita `AllowTcpForwarding yes` al arrancar la instancia, así que no tendrás que hacer este paso manual.

---

## Seguridad

- SSH (22) está permitido **solo desde tu IP** (p. ej. `191.107.171.174/32`). Si tu IP cambia (otra red, otro lugar), actualiza la regla en el SG `sg-0bca7597802398cbc` (ver [Troubleshooting](#troubleshooting-connection-timed-out-al-hacer-ssh)).
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
