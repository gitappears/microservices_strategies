# API Gateway – Rutas e integraciones

Rutas sugeridas para el HTTP API de QInspecting y cómo configurar las integraciones al ALB (backend ECS).

## Rutas que no llevan authorizer

Estas rutas **no** deben usar el Lambda Authorizer (el cliente aún no tiene token):

| Método | Ruta | Integración | Descripción |
|--------|------|-------------|-------------|
| POST | `/auth/login` | HTTP → ALB `/auth/login` | Login; devuelve JWT. |
| POST | `/auth/refresh` | HTTP → ALB `/auth/refresh` | Renovar token. |

En API Gateway (consola o CLI), configurar estas rutas con **Auth = NONE** (sin authorizer).

## Rutas con authorizer (resto)

Todas las demás rutas usan el **Lambda Authorizer** por defecto. El backend recibe el header inyectado `X-Id-Empresa` (y opcionalmente `X-Numero-Documento`) desde el context del authorizer.

| Prefijo path | Target group / servicio ECS | Base de datos |
|--------------|-----------------------------|---------------|
| `/personal/*` | Personal | bd_personal |
| `/inspecciones/*` | Inspecciones | bd_inspecciones |
| `/mantenimientos/*` | Mantenimientos | bd_mantenimientos |
| `/inventario/*` | Inventario | bd_inventario |
| `/capacitaciones/*` | Capacitaciones | bd_capacitaciones |
| `/flota/*` | Flota/Documentos | bd_flota_documentos |
| `/tenancy/*` o `/health` | Tenancy (o health del ALB) | bd_tenancy_planes |

La integración es **HTTP proxy** a la URL del ALB, reenviando path y query. Ejemplo de URL de integración:

- `https://qinspecting-alb-xxx.us-east-1.elb.amazonaws.com/{proxy}`  
  o la ruta concreta, ej. `https://.../personal/{proxy}` si el ALB enruta por path.

## Cómo añadir las rutas (consola AWS)

1. **API Gateway** → Tu HTTP API → **Routes**.
2. **Create route**:
   - Route key: `POST /auth/login` → Integration: HTTP URL del ALB (ej. `http://ALB/auth/login`), **Attach authorization**: No.
   - Route key: `POST /auth/refresh` → Igual, sin authorizer.
   - Route key: `ANY /{proxy+}` → Integration: HTTP URL `http://ALB/{proxy}` (o la base del ALB), **Attach authorization**: JwtTenancyAuthorizer (default).
3. En la integración HTTP, configurar **Parameter mapping** para pasar el context del authorizer como headers:
   - `overwrite:request.header.X-Id-Empresa` = `context.id_empresa`
   - `overwrite:request.header.X-Numero-Documento` = `context.numero_documento`

## OpenAPI (para importar o automatizar)

Fragmento de ejemplo para integración HTTP al ALB (reemplazar `ALB_URL` por la URL real):

```yaml
paths:
  /auth/login:
    post:
      security: []
      x-amazon-apigateway-integration:
        Type: HTTP_PROXY
        HttpMethod: POST
        Uri: "ALB_URL/auth/login"
        PayloadFormatVersion: '1.0'
  /auth/refresh:
    post:
      security: []
      x-amazon-apigateway-integration:
        Type: HTTP_PROXY
        HttpMethod: POST
        Uri: "ALB_URL/auth/refresh"
        PayloadFormatVersion: '1.0'
  /{proxy+}:
    x-amazon-apigateway-any-method:
      security:
        - JwtTenancyAuthorizer: []
      x-amazon-apigateway-integration:
        Type: HTTP_PROXY
        HttpMethod: ANY
        Uri: "ALB_URL/{proxy}"
        PayloadFormatVersion: '1.0'
        RequestParameters:
          overwrite:path: "method.request.path.proxy"
          overwrite:request.header.X-Id-Empresa: "context.id_empresa"
          overwrite:request.header.X-Numero-Documento: "context.numero_documento"
```

## Throttling

En **Stages** → tu stage (ej. `prod`) → **Default route settings**: configurar throttling (ej. 10 000 req/s, burst 5 000) y logging.
