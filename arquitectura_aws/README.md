# Arquitectura AWS – Implementación

Plantillas y código de referencia para desplegar en AWS la arquitectura de microservicios QInspecting descrita en el [Plan de trabajo – Microservicios](../PLAN_TRABAJO_MICROSERVICIOS_QINSPECTING.md) (sección 11).

## Contenido de este directorio

| Archivo / carpeta | Descripción |
|-------------------|-------------|
| [lambda-authorizer/](lambda-authorizer/) | Código del **Lambda Authorizer**: valida JWT y consulta Tenancy (RDS) para permitir o denegar la petición. |
| [template-sam.yaml](template-sam.yaml) | Plantilla **AWS SAM**: API Gateway (HTTP API), Lambda Authorizer, permisos y variables. No incluye ECS/RDS (se crean aparte o en otro stack). |
| [api-gateway-rutas.md](api-gateway-rutas.md) | Rutas sugeridas y configuración de API Gateway (rutas, excepciones para `/auth`). |

## Prerrequisitos

- Cuenta AWS y AWS CLI configurado.
- [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) instalado (para desplegar la plantilla).
- RDS MySQL ya creado con la base `bd_tenancy_planes` y tabla `ten_planes_empresas` (esquema de [refactor_ddl](../refactor_ddl/)).
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
