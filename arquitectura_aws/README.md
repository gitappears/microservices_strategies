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

RDS está en subnets privadas (`PubliclyAccessible: false`). Para conectar desde tu PC tienes dos opciones:

### Opción A – Túnel para APIs locales (qinspecting_api_nest, etc.)

Si quieres que una API que corre en tu PC se conecte a RDS, abre un **túnel SSH con redirección de puerto** y configura la API para usar `127.0.0.1:3306`. Los pasos detallados están en **[BASTION.md – Túnel SSH para APIs locales](BASTION.md#túnel-ssh-para-apis-locales-qinspecting_api_nest-etc)**.

Resumen: en una terminal ejecutar `ssh -i arquitectura_aws/qinspecting-bastion.pem -L 3306:qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com:3306 ec2-user@3.236.168.134` y en el `.env` de la API usar `DATABASE_HOST=127.0.0.1`, `DATABASE_PORT=3306`, `DATABASE_SSL=false` y las credenciales del RDS.

### Opción B – SSH al bastión y MySQL desde ahí

1. **Conectarte por SSH al bastión** (usa la clave `arquitectura_aws/qinspecting-bastion.pem`):

   ```bash
   ssh -i arquitectura_aws/qinspecting-bastion.pem ec2-user@<BASTION_IP>
   ```

2. **En el bastión, instalar el cliente MySQL** (solo la primera vez):

   ```bash
   sudo yum install -y mysql
   ```

3. **Desde el bastión, conectar a RDS y crear las bases**:

   ```bash
   mysql -h qinspecting-prod.cmb8y2g0mlda.us-east-1.rds.amazonaws.com -u qinspect_admin -p
   # Pegar los CREATE DATABASE (o ejecutar crear_bases_y_schema.sh si subes el repo al bastión)
   ```

   O copiar los scripts al bastión (scp) y ejecutar `crear_bases_y_schema.sh` desde ahí con el endpoint de RDS.

**Bastión actual:** IP pública `3.236.168.134`, SG `sg-0bca7597802398cbc`. SSH permitido solo desde tu IP; el SG de RDS permite 3306 desde el SG del bastión. La plantilla [bastion.yaml](bastion.yaml) sirve para recrear el bastión en otra cuenta/región (si el deploy falla por validación, crear el bastión con la CLI como en la sección anterior).

## Prerrequisitos

- Cuenta AWS y AWS CLI configurado.
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) instalado (para desplegar la plantilla).
- RDS MySQL ya creado con las 7 bases y esquemas de [refactor_ddl](../refactor_ddl/) (usar [rds-databases.yaml](rds-databases.yaml) y luego `refactor_ddl/crear_bases_y_schema.sh`).
- Secret en Secrets Manager con: `JWT_SECRET`, y opcionalmente `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` para la conexión a `bd_tenancy_planes` desde el Authorizer (o usar el secret generado por RDS y añadir `JWT_SECRET` en otro secret).

## Despliegue rápido (SAM)

```bash
cd arquitectura_aws
sam build
sam deploy --guided
```

En `--guided` indicar: stack name, región, parámetros (nombre del secret, ARN de RDS si se usa). La plantilla despliega solo API Gateway + Lambda Authorizer; el ALB y los servicios ECS se despliegan por separado (ECS CLI, Terraform, o consola).

## Flujo

1. El cliente envía una petición a la URL de API Gateway con header `Authorization: Bearer <JWT>`.
2. API Gateway invoca el **Lambda Authorizer** con el token.
3. El Authorizer valida el JWT, consulta `bd_tenancy_planes` y devuelve Allow (con context `id_empresa`) o Deny (403).
4. Si Allow, API Gateway reenvía la petición a la integración configurada (por ejemplo, URL del ALB que apunta a los servicios ECS).

## Enlace al plan general

- [Plan de trabajo: Microservicios y normalización QInspecting](../PLAN_TRABAJO_MICROSERVICIOS_QINSPECTING.md) – Sección **11. Arquitectura AWS al detalle**.
