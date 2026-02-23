# Lambda Authorizer – QInspecting

Valida JWT y opcionalmente consulta `bd_tenancy_planes` para autorizar o denegar la petición en API Gateway.

## Variables de entorno (desde SAM/consola)

| Variable | Descripción |
|----------|-------------|
| `SECRET_ARN` | ARN del secret en Secrets Manager que contiene `JWT_SECRET` y, si la Lambda consulta RDS, `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`. |
| `TENANCY_DB_NAME` | Nombre de la base de tenancy (por defecto `bd_tenancy_planes`). |
| `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_PORT` | Opcional si están dentro del secret; si la Lambda no está en VPC, no use RDS aquí. |

## Formato del secret (Secrets Manager)

JSON con al menos:

```json
{
  "JWT_SECRET": "tu-clave-secreta-jwt"
}
```

Si la Lambda consulta RDS (Lambda en VPC):

```json
{
  "JWT_SECRET": "tu-clave-secreta-jwt",
  "DB_HOST": "qinspecting.xxxx.us-east-1.rds.amazonaws.com",
  "DB_USER": "admin",
  "DB_PASSWORD": "***",
  "DB_NAME": "bd_tenancy_planes"
}
```

## Respuesta (HTTP API)

- **Autorizado:** `{ "isAuthorized": true, "context": { "id_empresa": "5", "numero_documento": "123456" } }`
- **No autorizado:** `{ "isAuthorized": false, "context": { "reason": "missing_token" } }` (o `invalid_token`, `empresa_suspendida`, etc.)

API Gateway reenvía `context` a la integración (p. ej. como headers `X-Id-Empresa`, `X-Numero-Documento`).

## Build y deploy

Desde esta carpeta:

```bash
npm install
cd .. && sam build && sam deploy
```

La plantilla SAM empaqueta esta carpeta como el código del Lambda Authorizer.
