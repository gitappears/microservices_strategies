# Red VPC — dev sin NAT / prod con NAT

Plantilla condicional para evitar **~32 USD/mes** de NAT Gateway en desarrollo, manteniendo la variante con NAT para producción.

## Modos

| Modo | `EnableNatGateway` | Uso |
|------|-------------------|-----|
| **no-nat** | `false` | Dev/staging: RDS + bastión + API Gateway/Lambda sin VPC |
| **with-nat** | `true` | Prod: ECS Fargate en subnet privada con salida IPv4 a internet |

## VPC actual (migración, sin recrear)

La VPC de desarrollo documentada en [BASTION.md](../BASTION.md) (`vpc-04547d461f905b589`) se creó **fuera** de esta plantilla. Para desactivar NAT **sin borrar RDS ni bastión**:

```bash
cd arquitectura_aws

# 0. Renovar credenciales AWS (obligatorio si ves ExpiredToken)
aws sts get-caller-identity

# 1. Estado actual
./scripts/verify-nat-status.sh

# 2. Flujo completo (simulación por defecto)
./scripts/apply-disable-nat-dev.sh

# 3. Aplicar en AWS (~32 USD/mes de ahorro)
APPLY=true ./scripts/apply-disable-nat-dev.sh

# Alternativa manual:
# DRY_RUN=true  ./scripts/disable-nat-existing-vpc.sh
# DRY_RUN=false ./scripts/disable-nat-existing-vpc.sh vpc-04547d461f905b589 us-east-1
# ./scripts/verify-nat-status.sh
```

### Inventario típico (referencia)

| Recurso | ID / notas |
|---------|------------|
| VPC dev | `vpc-04547d461f905b589` |
| NAT | **Eliminado** — sin `NatGateway` activo en la VPC (verificado con `verify-nat-status.sh`) |
| Route table privada | `rtb-0a252651a43199619` — sin ruta `0.0.0.0/0` → NAT |
| EIP bastión (conservar) | tag `qinspecting-bastion-eip` → `107.23.150.14` |
| EIP NAT | Liberada (no hay EIPs huérfanas) |

## Nuevos entornos (CloudFormation)

```bash
# Dev — sin NAT
./scripts/deploy-network.sh dev

# Prod — con NAT
./scripts/deploy-network.sh prod
```

Outputs útiles para otros stacks:

- `VpcId`, `PublicSubnetIds`, `PrivateSubnetIds`, `NetworkMode`

### Encadenar con RDS y bastión

```bash
# Tras deploy-network dev
VPC=$(aws cloudformation describe-stacks --stack-name qinspecting-network-dev \
  --query 'Stacks[0].Outputs[?OutputKey==`VpcId`].OutputValue' --output text)
PRIV=$(aws cloudformation describe-stacks --stack-name qinspecting-network-dev \
  --query 'Stacks[0].Outputs[?OutputKey==`PrivateSubnetIds`].OutputValue' --output text)
PUB1=$(aws cloudformation describe-stacks --stack-name qinspecting-network-dev \
  --query 'Stacks[0].Outputs[?OutputKey==`PublicSubnet1Id`].OutputValue' --output text)

aws cloudformation deploy --template-file rds-databases.yaml --stack-name qinspecting-rds \
  --parameter-overrides VpcId=$VPC PrivateSubnetIds=$PRIV ...

aws cloudformation deploy --template-file bastion.yaml --stack-name qinspecting-bastion \
  --parameter-overrides VpcId=$VPC PublicSubnetId=$PUB1 ...
```

## API (ECS) sin NAT en dev

Si despliegas Nest en ECS **sin** NAT:

- **Opción A:** tareas en **subnet pública** con `assignPublicIp: ENABLED`.
- **Opción B:** subnet privada + **VPC endpoints** (ECR, Secrets Manager, CloudWatch Logs, S3 gateway).

Lambda Authorizer: mantener **sin** `VpcConfig` en [template-sam.yaml](../template-sam.yaml).

### Lambda backend en VPC + Cognito (sin NAT)

Si la API Nest corre en **Lambda dentro de la VPC** (para RDS) y la VPC **no tiene NAT**, Cognito falla con HTTP 503 (*"No se pudo contactar Amazon Cognito"*).

**Solución:** interface endpoint `com.amazonaws.us-east-1.cognito-idp` con Private DNS:

```bash
cd arquitectura_aws
aws sts get-caller-identity   # renovar credenciales si ExpiredToken
./scripts/deploy-cognito-vpc-endpoint.sh dev
```

Plantilla: [network/vpc-endpoint-cognito.yaml](vpc-endpoint-cognito.yaml)  
Stack: `qinspecting-vpc-endpoint-cognito-dev`

Requiere permisos **EC2/VPC** (cuenta admin; el usuario `github-qinspecting-cicd` no los tiene).

Tras desplegar, `POST /api/auth/login` debe responder **401/400**, no **503**.

**Limitación AWS:** si el user pool tiene **dominio Managed Login** (`CreateUserPoolDomain`), Cognito **rechaza** las llamadas API vía PrivateLink con HTTP 400 (*"PrivateLink access is disabled for the user pool that has ManagedLogin configured"*). Opciones:

| Enfoque | Coste | Managed Login / OAuth hosted UI |
|---------|-------|----------------------------------|
| VPC endpoint + **sin dominio** en el pool | ~7 USD/mes endpoint | No (login vía `InitiateAuth` en API Nest sí funciona) |
| **NAT Gateway** + endpoint opcional | ~32+ USD/mes NAT | Sí |

En dev se eliminó el dominio `us-east-1i2ha3rvmz` para compatibilizar con PrivateLink. El admin (`qinspecting_v2`) autentica vía `POST /api/auth/login`, no usa Hosted UI.

El script añade ingress 443 al endpoint desde **todos** los security groups de la Lambda (p. ej. `lambda-rds-1` y `rds-lambda-1`).

### Lambda + S3 (upload de archivos)

Con `FILES_STORAGE=s3`, la Lambda necesita:

1. **Variables de entorno** (consola Lambda o GitHub Environment): `S3_BUCKET`, `S3_KEY_PREFIX`, `FILES_BASE_URL` (CloudFront del bucket), `FILES_STORAGE=s3`.
2. **IAM en el rol de ejecución**: `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject` sobre el bucket.
3. **VPC gateway endpoint S3** en la route table privada (sin NAT): plantilla [vpc-endpoint-s3.yaml](vpc-endpoint-s3.yaml).

No hace falta `AWS_ACCESS_KEY_ID` en Lambda: el SDK usa el rol IAM automáticamente.

## Prod

No modificar la VPC de prod con el script de migración. Desplegar `parameters-prod.json` (`EnableNatGateway=true`) en cuenta/región de producción.

Ver también [OPTIMIZACION_COSTOS_AWS.md](../OPTIMIZACION_COSTOS_AWS.md).
