# Arquitectura AWS – Implementación

Plantillas y código de referencia para desplegar en AWS la arquitectura de microservicios QInspecting descrita en el [Plan de trabajo – Microservicios](../PLAN_TRABAJO_MICROSERVICIOS_QINSPECTING.md) (sección 11).

## Contenido de este directorio

| Archivo / carpeta | Descripción |
|-------------------|-------------|
| [lambda-authorizer/](lambda-authorizer/) | Código del **Lambda Authorizer**: valida JWT y consulta Tenancy (RDS) para permitir o denegar la petición. |
| [template-sam.yaml](template-sam.yaml) | Plantilla **AWS SAM**: API Gateway (HTTP API), Lambda Authorizer, permisos y variables. No incluye ECS/RDS (se crean aparte o en otro stack). |
| [rds-databases.yaml](rds-databases.yaml) | Plantilla **CloudFormation** para crear la instancia **RDS MySQL 8** (7 bases por sistema). Tras el deploy, crear las bases con [refactor_ddl/crear_bases_y_schema.sh](../refactor_ddl/crear_bases_y_schema.sh). |
| [rds-databases-config.yml](rds-databases-config.yml) | Configuración YAML de las 7 bases (nombre, charset, collation) para pipelines o scripts que ejecuten `CREATE DATABASE` en RDS. |
| [scripts/](scripts/) | Scripts que usan el YAML: `create-databases-from-config.py` crea las bases leyendo `rds-databases-config.yml`. |
| [bastion.yaml](bastion.yaml) | Plantilla opcional para bastión EC2 (acceso SSH y desde ahí a RDS). Si el deploy falla por hooks, ver [Acceso a RDS vía bastión](#acceso-a-rds-via-bastion). |
| [api-gateway-rutas.md](api-gateway-rutas.md) | Rutas sugeridas y configuración de API Gateway (rutas, excepciones para `/auth`). |
| [OPTIMIZACION_COSTOS_AWS.md](OPTIMIZACION_COSTOS_AWS.md) | Cómo reducir costos al máximo (RDS, bastión, backups, Lambda, etc.). |
| [RDS_UPGRADE_MYSQL_2026.md](RDS_UPGRADE_MYSQL_2026.md) | Fin de soporte MySQL 8.0 (31-jul-2026): actualizar a 8.4 LTS y pasos para instancias existentes. |

## Crear RDS y las bases de datos

1. Desplegar la plantilla RDS (requiere VPC, subnets privadas y un Security Group que permita acceso al puerto 3306 desde ECS/Lambda):

   ```bash
   aws cloudformation deploy --template-file rds-databases.yaml --stack-name qinspecting-rds \
     --parameter-overrides \
       VpcId=vpc-xxxxx \
       PrivateSubnetIds=subnet-aaaa,subnet-bbbb \
       DBSecurityGroupId=sg-xxxxx \
       MasterUserPassword='TuPasswordSeguro'
   ```

2. Tras el deploy, crear las 7 bases y aplicar los DDL de [refactor_ddl](../refactor_ddl/):

   ```bash
   ../refactor_ddl/crear_bases_y_schema.sh <RDSEndpoint> qinspect_admin '<MasterUserPassword>'
   ```

   El endpoint y el usuario se obtienen en los Outputs del stack (`RDSEndpoint`, `MasterUsername`). La lista de bases está definida en [rds-databases-config.yml](rds-databases-config.yml).

3. **Alternativa usando el YAML**: crear solo las bases (sin aplicar DDL) con el script que lee [rds-databases-config.yml](rds-databases-config.yml):

   ```bash
   cd arquitectura_aws/scripts
   pip install pyyaml   # si no lo tienes
   python3 create-databases-from-config.py <RDSEndpoint> qinspect_admin '<MasterUserPassword>'
   # Solo ver el SQL:  python3 create-databases-from-config.py --dry-run
   ```

   Luego aplica los DDL manualmente desde [refactor_ddl](../refactor_ddl/) por cada base.

## Acceso a RDS vía bastión

RDS está en subnets privadas (`PubliclyAccessible: false`). Para conectar desde tu PC se usa un **bastión EC2** (SSH o túnel). Documentación detallada: **[BASTION.md](BASTION.md)**.

### Reducir costos: apagar el bastión cuando no se use

El bastión es una instancia EC2 que cobra por horas. **Se recomienda detenerlo cuando no vayas a usarlo** y encenderlo solo cuando necesites acceso a RDS (túnel, MySQL, etc.). Al detenerlo dejas de pagar por vCPU/memoria; solo se cobra el disco EBS.

---

### Paso a paso: encender el bastión y conectarte

Si el bastión estaba apagado o no conectas, sigue estos pasos en orden.

#### 1. Comprobar estado del bastión y obtener su IP actual

Al **encender** una instancia EC2, la IP pública puede **cambiar**. Siempre verifica estado e IP antes de conectarte:

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=qinspecting-bastion" \
  --query "Reservations[].Instances[].[State.Name,PublicIpAddress,InstanceId]" \
  --output table
```

Salida esperada (ejemplo):

- `running` + una IP (ej. `3.236.168.134`) + `i-xxxxx` → anota la **PublicIpAddress** para el paso 3.
- `stopped` → hay que encender la instancia (paso 2).

#### 2. Si está apagado: encender el bastión

```bash
# Sustituir <INSTANCE_ID> por el ID que salió en el paso 1 (ej. i-0abc123def456)
aws ec2 start-instances --instance-ids <INSTANCE_ID>
```

Espera 1–2 minutos. Vuelve a ejecutar el comando del **paso 1** para obtener la **nueva IP pública** (suele ser distinta a la anterior).

#### 3. Comprobar si tu IP está permitida en el Security Group

El bastión solo acepta SSH desde **tu IP actual**. Si cambiaste de red (otro WiFi, 4G, otra ubicación), tu IP cambió y hay que actualizarla en el Security Group.

**Ver tu IP pública actual:**

```bash
curl -s ifconfig.me
```

**Añadir tu IP al Security Group del bastión** (SG: `sg-0bca7597802398cbc`):

```bash
MY_IP=$(curl -s ifconfig.me)
aws ec2 authorize-security-group-ingress --group-id sg-0bca7597802398cbc --protocol tcp --port 22 --cidr ${MY_IP}/32
```

Si ya había una regla para otra IP y quieres dejar solo la actual, puedes revocar la antigua (opcional):

```bash
aws ec2 revoke-security-group-ingress --group-id sg-0bca7597802398cbc --protocol tcp --port 22 --cidr IP_VIEJA/32
```

#### 4. Conectarte: túnel SSH o SSH directo

Usa la **IP del bastión** que obtuviste en el paso 1 (y, si lo encendiste, la nueva IP del paso 2).

**Desde la raíz del repo `bases_qinspecting`:**

- **Túnel** (para que tu API local use RDS vía `127.0.0.1:3306`):

  ```bash
  ssh -i arquitectura_aws/qinspecting-bastion.pem -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 ec2-user@<IP_BASTION>
  ```

- **SSH directo** (para usar MySQL desde el bastión):

  ```bash
  ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@<IP_BASTION>
  ```

Sustituye `<IP_BASTION>` por la IP que devolvió el `describe-instances` (ej. `3.236.168.134`). Si la IP cambió al encender el bastión, **usa siempre la IP actual**, no una IP antigua guardada en documentación.

---

### Opción A – Túnel para APIs locales (qinspecting_api_nest, etc.)

Si quieres que una API que corre en tu PC se conecte a RDS, abre el **túnel SSH** (comando anterior con `-L 3306:...`) y configura la API para usar `127.0.0.1:3306`. Detalle en **[BASTION.md – Túnel SSH para APIs locales](BASTION.md#túnel-ssh-para-apis-locales-qinspecting_api_nest-etc)**.

En el `.env` de la API: `DATABASE_HOST=127.0.0.1`, `DATABASE_PORT=3306`, `DATABASE_SSL=false` y credenciales del RDS.

### Opción B – SSH al bastión y MySQL desde ahí

1. Conéctate por SSH (comando del paso 4).
2. En el bastión, instalar MySQL client (solo la primera vez): `sudo yum install -y mysql`
3. Conectar a RDS: `mysql -h qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com -u qinspect_admin -p`

O copiar los scripts al bastión (scp) y ejecutar `crear_bases_y_schema.sh` desde ahí. Ver [BASTION.md](BASTION.md) para más comandos.

---

**Resumen:** Bastión SG `sg-0bca7597802398cbc`. SSH (22) solo desde IPs que hayas añadido al SG. RDS (3306) solo desde el SG del bastión. Para recrear el bastión en otra cuenta/región: [bastion.yaml](bastion.yaml).

## Prerrequisitos

- Cuenta AWS y AWS CLI configurado.
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) instalado (para desplegar la plantilla).
- RDS MySQL ya creado con las 7 bases y esquemas de [refactor_ddl](../refactor_ddl/) (usar [rds-databases.yaml](rds-databases.yaml) y luego `refactor_ddl/crear_bases_y_schema.sh`).
- Secret en Secrets Manager con: `JWT_SECRET`, y opcionalmente `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` para la conexión a `bd_tenancy_planes` desde el Authorizer (o usar el secret generado por RDS y añadir `JWT_SECRET` en otro secret).

## Despliegue rápido (SAM)

```bash
cd arquitectura_aws
sam build --template template-sam.yaml
sam deploy
```

Si es la primera vez o no tienes `samconfig.toml`, usa `sam deploy --guided` y indica: stack name, región, y **SecretArn** (ARN del secret en Secrets Manager con `JWT_SECRET` y opcionalmente `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`).

**Despliegue ya realizado (referencia):**
- **API (HTTP):** `https://tmm12v9odf.execute-api.us-east-1.amazonaws.com/prod`
- **Stack:** `qinspecting-api` (us-east-1)
- **Secret usado:** `qinspecting/api/jwt-and-db` — **importante:** en producción actualiza el valor de `JWT_SECRET` en ese secret (por ejemplo con `aws secretsmanager put-secret-value`).

La plantilla despliega solo API Gateway + Lambda Authorizer; el ALB y los servicios ECS se despliegan por separado (ECS CLI, Terraform, o consola).

## Flujo

1. El cliente envía una petición a la URL de API Gateway con header `Authorization: Bearer <JWT>`.
2. API Gateway invoca el **Lambda Authorizer** con el token.
3. El Authorizer valida el JWT, consulta `bd_tenancy_planes` y devuelve Allow (con context `id_empresa`) o Deny (403).
4. Si Allow, API Gateway reenvía la petición a la integración configurada (por ejemplo, URL del ALB que apunta a los servicios ECS).

## Enlace al plan general

- [Plan de trabajo: Microservicios y normalización QInspecting](../PLAN_TRABAJO_MICROSERVICIOS_QINSPECTING.md) – Sección **11. Arquitectura AWS al detalle**.
