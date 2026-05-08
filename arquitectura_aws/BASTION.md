# Bastión QInspecting – Acceso a RDS

Bastión EC2 para conectarte a RDS (en subnets privadas) por SSH y desde ahí ejecutar MySQL.

<a id="flujo-bastion-tunel"></a>

## Flujo completo (bastión y túnel)

Sigue estos pasos **en orden** cada vez que el bastión estuviera apagado o hayas cambiado de red (Wi‑Fi, oficina, datos móviles). Necesitas **AWS CLI** configurado (`aws sts get-caller-identity` debe funcionar) y la clave **`qinspecting-bastion.pem`** en `arquitectura_aws/` o en la raíz de `microservices_strategies/`.

### Paso 1: Comprobar estado, `InstanceId` e IP pública del bastión

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=qinspecting-bastion" \
  --query "Reservations[].Instances[].[State.Name,PublicIpAddress,InstanceId]" \
  --output table
```

- Si **State** es **`stopped`**, enciende y espera 1–2 minutos hasta que pase a **`running`**:

```bash
aws ec2 start-instances --instance-ids <INSTANCE_ID>
# Repetir describe-instances hasta ver running y PublicIpAddress
```

- Anota la columna **PublicIpAddress** (con Elastic IP suele coincidir con la tabla [Datos actuales](#datos-actuales)). Úsala en los comandos siguientes como **`BASTION_IP`**.

<a id="paso-sg-ssh"></a>

### Paso 2: Permitir SSH (puerto 22) desde tu IP pública actual

El security group del bastión solo acepta SSH desde IPs que hayas autorizado explícitamente. **Si tu IP cambió**, verás `Connection timed out` al puerto 22 hasta que ejecutes esto.

**Importante (zsh/bash):** el nombre de la variable debe ser un identificador válido (por ejemplo `MY_IP`). No uses la IP como nombre de variable (`186.x.x.x=...` o `107.x=...` falla con *command not found*).

```bash
MY_IP=$(curl -s ifconfig.me)
echo "Mi IP pública: ${MY_IP}"

aws ec2 authorize-security-group-ingress \
  --group-id sg-0bca7597802398cbc \
  --protocol tcp \
  --port 22 \
  --cidr "${MY_IP}/32"
```

Si AWS responde que la regla **ya existe**, no hay problema. Para quitar una IP que ya no uses, usa `revoke-security-group-ingress` con el mismo `--cidr`.

### Paso 3 (opcional): Probar SSH al bastión sin túnel

Sustituye la ruta al `.pem` y la IP si difieren de las tuyas.

```bash
ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@<BASTION_IP>
```

Si entras, puedes salir con `exit` y seguir con el túnel.

### Paso 4: Abrir el túnel SSH (dejar la terminal abierta)

Desde el repo, carpeta de scripts:

```bash
cd microservices_strategies/arquitectura_aws/scripts
export BASTION_IP=<PublicIpAddress>   # opcional si AWS CLI devuelve bien la instancia running
./start-rds-tunnel.sh
```

El script imprime algo como `Túnel: 127.0.0.1:3306 -> <RDS>:3306 via ec2-user@<BASTION_IP>`. **No cierres esta terminal** mientras uses el túnel. `Ctrl+C` lo cierra.

Equivalente manual (desde la raíz de `microservices_strategies` si el `.pem` está ahí):

```bash
ssh -N -i qinspecting-bastion.pem \
  -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 \
  ec2-user@<BASTION_IP>
```

### Paso 5: Configurar la API local y arrancarla en otra terminal

Con el túnel activo, el host de la base es **tu máquina**:

| Variable / concepto | Valor |
|---------------------|--------|
| Host | `127.0.0.1` |
| Puerto MySQL | `3306` |
| Usuario | `qinspect_admin` (u el definido en RDS) |
| Contraseña | La del RDS / secret (no vacía) |

Ejemplo mínimo en `.env` (ver detalle en [Configurar la API para usar el túnel](#config-api-tunel) más abajo):

```env
DATABASE_HOST=127.0.0.1
DATABASE_PORT=3306
DATABASE_USER=qinspect_admin
DATABASE_PASSWORD=<tu_password_rds>
```

En **otra** terminal, arranca la API (Nest, etc.).

### Paso 6: Al terminar, cerrar túnel y (opcional) apagar el bastión

1. En la terminal del túnel: `Ctrl+C`.
2. Para dejar de pagar cómputo del bastión: [Apagar el bastión](#apagar-bastion).

---

<a id="apagar-bastion"></a>

## Reducir costos: apagar el bastión cuando no se use

El bastión es una instancia EC2 que cobra por horas de uso. **Se recomienda apagarlo cuando no lo vayas a usar** y encenderlo solo cuando necesites acceso a RDS. Así dejas de pagar por vCPU/memoria (solo se cobra el disco EBS, mucho menor).

**Apagar el bastión:**

```bash
# Obtener el InstanceId (consola EC2 o):
aws ec2 describe-instances --filters "Name=tag:Name,Values=qinspecting-bastion" --query "Reservations[].Instances[].InstanceId" --output text

# Apagar
aws ec2 stop-instances --instance-ids <INSTANCE_ID>
```

**Cuando vuelvas a necesitar acceso:** sigue el [Flujo completo (bastión y túnel)](#flujo-bastion-tunel) de arriba (encender → IP en el SG → túnel). También puedes revisar el [README – Acceso a RDS vía bastión](README.md#acceso-a-rds-vía-bastión) si enlaza contexto adicional.

Resumen mínimo solo para encender:

```bash
aws ec2 start-instances --instance-ids <INSTANCE_ID>
# Esperar 1–2 min, luego comprobar estado e IP:
aws ec2 describe-instances --filters "Name=tag:Name,Values=qinspecting-bastion" --query "Reservations[].Instances[].[State.Name,PublicIpAddress]" --output table
```

<a id="datos-actuales"></a>

## Datos actuales

| Dato | Valor |
|------|--------|
| **IP pública (Elastic IP)** | `107.23.150.14` (estable entre stop/start de la instancia; liberar la EIP en AWS si ya no la usas) |
| **Usuario SSH** | `ec2-user` |
| **Clave privada** | `arquitectura_aws/qinspecting-bastion.pem` |
| **Security Group bastión** | `sg-0bca7597802398cbc` |
| **RDS endpoint** | `qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com` |

## Elastic IP (IP pública estable)

- La IP efímera **cambia** al parar/iniciar la instancia. Una **Elastic IP** asociada **sí se mantiene** entre stop/start (sigue habiendo cargo por IPv4 pública según precios actuales de VPC).
- **Nuevo despliegue o actualización del stack:** la plantilla [`bastion.yaml`](bastion.yaml) crea `BastionElasticIp` + `BastionEipAssociation` y el output `BastionPublicIp` muestra la EIP.
- **Bastión ya existente (sin redesplegar todo):** desde `arquitectura_aws/scripts/` ejecuta `./associate-bastion-elastic-ip.sh` (requiere AWS CLI y permisos `ec2:AllocateAddress` / `ec2:AssociateAddress`). Después **actualiza la IP** en esta tabla y en variables como `BASTION_IP`.

## Conexión

```bash
# 1. SSH al bastión (desde la carpeta del repo)
ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@107.23.150.14

# 2. En el bastión: instalar MySQL client (solo la primera vez)
sudo yum install -y mysql

# 3. Conectar a RDS
mysql -h qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com -u qinspect_admin -p
```

## Túnel SSH para APIs locales (qinspecting_api_nest, etc.)

Para que una API que corre en tu PC (por ejemplo `qinspecting_api_nest`) se conecte a RDS, RDS no es accesible directamente desde internet. Hay que abrir un **túnel SSH con redirección de puerto** (`-L`) desde tu máquina al bastión y de ahí al RDS (MySQL puerto **3306**).

El orden recomendado está en [Flujo completo (bastión y túnel)](#flujo-bastion-tunel). Aquí se amplía con checklist y opciones.

### Checklist antes del túnel

1. **Bastión en ejecución** y **PublicIpAddress** actual (compruébalo con `describe-instances`; la tabla «Datos actuales» puede desfasarse).
2. **Security group del bastión** (`sg-0bca7597802398cbc`): entrada **TCP 22** desde **tu IP pública** en **`${MY_IP}/32`** (ver [Paso 2: permitir SSH](#paso-sg-ssh)). Si cambias de red, SSH hará *timeout* hasta que autorices la nueva IP.
3. **Clave `.pem`** accesible (p. ej. `microservices_strategies/qinspecting-bastion.pem`).

### 1. Abrir el túnel (dejar esta terminal abierta)

**Opción A – script (recomendado)** desde `microservices_strategies/arquitectura_aws/scripts/`:

```bash
cd arquitectura_aws/scripts
export BASTION_IP=107.23.150.14   # o la IP actual del bastión
./start-rds-tunnel.sh
```

Por defecto redirige **`127.0.0.1:3306`** → RDS MySQL documentado. Variables útiles: `RDS_HOST`, `LOCAL_PORT`, `REMOTE_PORT`, `BASTION_KEY_PATH`.

**Opción B – comando SSH manual** (desde la raíz del repo `microservices_strategies`):

```bash
ssh -i qinspecting-bastion.pem -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 ec2-user@107.23.150.14
```

Con eso, **localhost:3306** en tu PC redirige al puerto 3306 del RDS. No hace falta ejecutar nada dentro del bastión; la sesión debe permanecer abierta.

<a id="config-api-tunel"></a>

### 2. Configurar la API para usar el túnel

En el `.env` del proyecto de la API (ej. `qinspecting_api_nest`), con **`STAGE=dev`** y TypeORM **MySQL**:

- **Host:** `127.0.0.1`
- **Puerto:** `3306`
- **Usuario y contraseña:** los del RDS (`qinspect_admin` y la contraseña maestra / secret)
- **Obligatorio:** `DATABASE_PASSWORD` no vacía (sin eso MySQL responde `using password: NO`).
- **Cognito:** `COGNITO_REGION`, `COGNITO_USER_POOL_ID`, `COGNITO_CLIENT_ID` para autenticación.

Ejemplo mínimo:

```env
STAGE=dev
DATABASE_HOST=127.0.0.1
DATABASE_PORT=3306
DATABASE_USER=qinspect_admin
DATABASE_PASSWORD=tu_password_rds
DATABASE_NAME=bd_tenancy_planes
```

Si la API usa varias bases (tenancy, personal, mantenimientos, etc.), define cada una según el proyecto.

### Resumen

| Paso | Acción |
|------|--------|
| 1 | Abrir túnel (`./start-rds-tunnel.sh` o `ssh -L 3306:...`) y **no cerrar** esa terminal |
| 2 | En `.env` de la API: `DATABASE_*` hacia `127.0.0.1:3306` y credenciales RDS |
| 3 | Arrancar la API en **otra** terminal |

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
scp -i arquitectura_aws/qinspecting-bastion.pem -r refactor_ddl ec2-user@107.23.150.14:~
# En el bastión
cd refactor_ddl && ./crear_bases_y_schema.sh qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com qinspect_admin '<password>'
```

## Actualizar tablas en RDS (aplicar DDL)

Cuando cambies los archivos `refactor_ddl/*/00_schema.sql` en tu PC, así aplicas los cambios en RDS desde el bastión.

### 1. Copiar la carpeta DDL al bastión

Desde tu PC (en la raíz del repo `microservices_strategies`, o donde tengas `refactor_ddl`):

```bash
scp -i arquitectura_aws/qinspecting-bastion.pem -r refactor_ddl ec2-user@107.23.150.14:~
```

### 2. Conectarte al bastión y aplicar el esquema

**Opción A – Actualizar una sola base desde tu PC** (túnel SSH abierto en otra terminal):

```bash
# Terminal 1: deja el túnel abierto (o usa arquitectura_aws/scripts/start-rds-tunnel.sh)
cd /ruta/al/repo/microservices_strategies
ssh -i qinspecting-bastion.pem -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 ec2-user@107.23.150.14

# Terminal 2: aplica el schema (usa 127.0.0.1 porque el túnel redirige al RDS)
cd /ruta/al/repo/microservices_strategies
mysql -h 127.0.0.1 -P 3306 -u qinspect_admin -p bd_capacitaciones < refactor_ddl/06_bd_capacitaciones/00_schema.sql
```

**Opción A2 – Actualizar una base desde el bastión** (después de copiar refactor_ddl al bastión):

```bash
ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@107.23.150.14

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

<a id="troubleshooting-ssh-timeout"></a>

## Troubleshooting: "Connection timed out" al hacer SSH

Si `ssh ... ec2-user@<IP_BASTION>` devuelve **Connection timed out**, suele ser por:

1. **Bastión apagado** → no hay SSH hasta que la instancia esté en `running`.
2. **Tu IP pública cambió** → el Security Group solo permite SSH desde los CIDR que hayas añadido (`/32` por máquina). Si cambiaste de red (Wi‑Fi, 4G, otra casa), autoriza de nuevo con `MY_IP` como en el [Paso 2 del flujo completo](#paso-sg-ssh).

### 1. Comprobar estado del bastión y su IP actual

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=qinspecting-bastion" \
  --query "Reservations[].Instances[].[State.Name,PublicIpAddress,InstanceId]" \
  --output table
```

- Si **State** es `stopped`: enciende la instancia con `aws ec2 start-instances --instance-ids <INSTANCE_ID>` y espera 1–2 minutos. Vuelve a ejecutar la query para obtener la **nueva** `PublicIpAddress` y usa esa IP en el comando `ssh`.
- Si **State** es `running` y **PublicIpAddress** no coincide con la IP que tenías en documentación o scripts, usa siempre la IP que devuelva este comando (la tabla «Datos actuales» puede quedar desactualizada hasta que la actualices).

### 2. Ver tu IP pública actual

```bash
curl -s ifconfig.me
```

Compara con las reglas **SSH (22)** del SG en la consola EC2. Si tu IP actual no está en ningún `/32` que uses, añade una regla nueva.

### 3. Actualizar el Security Group con tu IP actual

Añadir tu IP actual (usa siempre una variable con nombre válido, p. ej. `MY_IP`; no uses la IP como nombre de variable):

```bash
MY_IP=$(curl -s ifconfig.me)
aws ec2 authorize-security-group-ingress \
  --group-id sg-0bca7597802398cbc \
  --protocol tcp --port 22 --cidr "${MY_IP}/32"
```

Para quitar una IP que ya no uses (sustituye el CIDR exacto de la regla antigua):

```bash
aws ec2 revoke-security-group-ingress \
  --group-id sg-0bca7597802398cbc \
  --protocol tcp --port 22 --cidr 203.0.113.50/32
```

Después de esto, prueba de nuevo el SSH (con la IP del bastión que obtuviste en el paso 1).

## Troubleshooting: "channel X: open failed: administratively prohibited"

Si al usar el **túnel** (`ssh -i ... -L 3306:... ec2-user@...`) ves **"channel 3: open failed: administratively prohibited"**, el servidor SSH del bastión tiene deshabilitado el reenvío TCP (port forwarding). Hay que habilitarlo **una vez en el bastión actual**:

1. Conéctate al bastión **sin** túnel (solo SSH normal):
   ```bash
   ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@107.23.150.14
   ```
2. En el bastión, edita la configuración de SSH y habilita el reenvío:
   ```bash
   sudo sed -i 's/^#*AllowTcpForwarding.*/AllowTcpForwarding yes/' /etc/ssh/sshd_config
   grep -q '^AllowTcpForwarding' /etc/ssh/sshd_config || echo 'AllowTcpForwarding yes' | sudo tee -a /etc/ssh/sshd_config
   sudo systemctl restart sshd
   ```
3. Sal del bastión (`exit`) y vuelve a abrir el túnel desde tu PC:
   ```bash
   ssh -i arquitectura_aws/qinspecting-bastion.pem -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 ec2-user@107.23.150.14
   ```

En futuros despliegues con la plantilla `bastion.yaml` (CloudFormation), el UserData ya habilita `AllowTcpForwarding yes` al arrancar la instancia, así que no tendrás que hacer este paso manual.

---

## Seguridad

- SSH (22) debe estar permitido **solo desde IPs que controles** (típicamente `TU_IP/32`). Si tu IP cambia, actualiza el SG `sg-0bca7597802398cbc` (ver [Troubleshooting: timeout SSH](#troubleshooting-ssh-timeout) y [Paso 2 del flujo](#paso-sg-ssh)).
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
aws ec2 run-instances --image-id ami-0199fa5fada510433 --instance-type t3.nano --key-name qinspecting-bastion \
  --subnet-id subnet-0b22e33560b7e6b8a --security-group-ids sg-XXXXX --associate-public-ip-address
```
