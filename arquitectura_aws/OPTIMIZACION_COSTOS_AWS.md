# Optimización de costos – Arquitectura AWS QInspecting

Este documento describe cómo **reducir al máximo** el costo de la arquitectura AWS cuando el uso es bajo o en fases tempranas, y cómo escalar de forma controlada después.

---

## 0. Mapeo: tu factura ↔ plantillas en `arquitectura_aws/`

Las plantillas de esta carpeta **no crean la VPC ni el NAT Gateway**; solo **RDS** (`rds-databases.yaml`), **bastión** (`bastion.yaml`) y **API + Lambda Authorizer** (`template-sam.yaml`). Si en Cost Explorer ves líneas como las siguientes (ejemplo ~17 USD/mes, pre-producción):

| Partida aprox. | Origen habitual | Qué tocar |
|----------------|-----------------|------------|
| **Relational Database Service** | Instancia MySQL 24/7 del stack `rds-databases.yaml` (`QInspectingDB`) | Clase mínima (`db.t4g.micro`), `BackupRetentionPeriod` 0 o 1, sin Multi-AZ (ya en plantilla). RDS **no se apaga** solo: sigue cobrando aunque no haya tráfico. |
| **EC2 – Instancias** | Sobre todo **bastión** (`bastion.yaml`) si está **running** | **`Stop` cuando no uses SSH/túnel** (sigues pagando EBS). Opción: `InstanceType` **t3.nano** (default en plantilla) o bajar tamaño al actualizar el stack. |
| **VPC** | **No** sale de `rds-databases.yaml` / `bastion.yaml` solos | Suele ser **NAT Gateway** (~32 USD/mes si está encendido), **Elastic IPs** asociados, **VPC endpoints** o **cargo por IPv4 público**. Revisa en Cost Explorer **por recurso** o **Cost allocation tags** qué stack (ECS, etc.) creó la VPC/NAT. |
| **Elastic Load Balancing + ECS** | Stacks **fuera** de esta carpeta (ALB + Fargate) | **ALB:** coste **fijo por hora** mientras exista (~**USD 15–22/mes** solo ese cargo en muchas regiones; revisa [precios ELB](https://aws.amazon.com/elasticloadbalancing/pricing/)) **+ LCU** con tráfico. **Fargate:** cobra **vCPU y GB por segundo** de tarea encendida; una tarea mínima 24/7 suele ser **varios USD/mes** aparte del ALB. En pre-prod: bajar réplicas, tareas pequeñas, o **Lambda** sin ALB. |
| **Secrets Manager** | Secret del Authorizer / credenciales | Unificar en **un secret** por entorno; no duplicar. |

**Checklist rápido (pre-producción):**

1. Bastión EC2 → `aws ec2 stop-instances --instance-ids <id>` (o consola) cuando no trabajes con RDS desde tu PC.  
2. RDS → confirmar `DBInstanceClass` y `BackupRetentionPeriod` en el stack (parámetros de `rds-databases.yaml`).  
3. **NAT Gateway en dev:** usar [scripts/disable-nat-existing-vpc.sh](scripts/disable-nat-existing-vpc.sh) o desplegar [network/vpc-network.yaml](network/vpc-network.yaml) con `EnableNatGateway=false`. Prod conserva NAT vía [network/parameters-prod.json](network/parameters-prod.json). Guía: [network/README-NETWORK.md](network/README-NETWORK.md).  
4. Revisar **ALB + ECS** si el coste de ELB/ECS aparece: son candidatos a apagar hasta producción.

---

## 1. De dónde viene el gasto (y qué duele cuando casi no se usa)

Cuando el uso es bajo, la mayor parte del costo **no** viene del tráfico, sino de **recursos que están encendidos 24/7**:

| Componente | Comportamiento | Costo aproximado (us-east-1, bajo uso) |
|------------|----------------|----------------------------------------|
| **RDS MySQL** | Siempre encendido (instancia reservada de tiempo) | **~USD 12–25/mes** según clase (`db.t4g.micro` suele estar en el rango bajo) y almacenamiento |
| **Bastión EC2** | Siempre encendido si está desplegado | **~USD 3–8/mes** (t3.nano) a **~USD 8–10/mes** (t3.micro), según horas encendido |
| **API Gateway HTTP API** | Pago por millón de solicitudes | Muy bajo con poco tráfico |
| **Lambda (Authorizer)** | Pago por invocación + tiempo | Muy bajo con poco tráfico |
| **Secrets Manager** | Por secret/mes | ~USD 0,40/secret/mes |
| **ALB** (si lo usas) | **Cargo por hora** (ALB “provisionado”) **+ LCU** | **~USD 15–22/mes** típico **solo por tener el ALB encendido** (casi sin tráfico); los **LCU** suben el total cuando hay peticiones SSL, reglas, bytes procesados. **Precio exacto depende de la región** → [Calculadora AWS](https://calculator.aws/). |
| **ECS Fargate** (si lo usas) | **vCPU-segundo + GB-segundo** por cada tarea | **No** es solo “por tráfico HTTP”: si **desired count ≥ 1**, pagas **24/7**. Ejemplo orientativo (orden de magnitud, us-east-1): una tarea **0,25 vCPU / 0,5 GB** continua puede rondar **unos pocos a ~10+ USD/mes** **por servicio** además del ALB; más vCPU/RAM o más réplicas = más. Usa la calculadora con tu región y tamaño de tarea. |

**Conclusión:** Si ya les han cobrado una suma alta (ej. ~15 M COP) con poco uso, lo más probable es que la mayoría venga de **RDS + Bastión (+ quizá ALB/ECS si están desplegados)**. Optimizar significa: reducir o eliminar lo que está “siempre encendido” y usar alternativas más baratas donde sea posible.

---

## 2. Estrategias por componente

### 2.1 RDS MySQL (el mayor impacto)

- **Clase de instancia:** Ya usan `db.t3.micro` o `db.t4g.micro`. Mantener la **más barata** que les permita la región (`db.t4g.micro` suele ser algo más económica que `db.t3.micro`).
- **Almacenamiento:** 20 GB está bien para arranque; no subir de 20 GB hasta que sea necesario.
- **Multi-AZ:** Debe estar en **false** en entornos de bajo uso (ya está así en la plantilla). No activar Multi-AZ hasta que tengan requisitos de alta disponibilidad.
- **Backups:**  
  - `BackupRetentionPeriod: 7` implica 7 días de backups (almacenamiento extra).  
  - Para **desarrollo/bajo uso** se puede bajar a **1 día** (mínimo permitido) o 0 si aceptan no tener backup automático en ese entorno.  
  - Reducir retención en el template cuando el stack sea solo de bajo uso (ver sección 3).
- **Parar la instancia cuando no se use (desarrollo/staging):**  
  - RDS **no** se puede “pausar” como Aurora Serverless v2.  
  - Opciones:  
    - **Entorno de desarrollo:** Si no necesitan la base 24/7, usar una base gestionada más barata en otro lado (p. ej. **PlanetScale**, **Railway**, **Render**) solo para dev y dejar RDS solo para staging/prod cuando vayan a usarlo.  
    - **Staging:** Crear/destruir el stack de RDS solo cuando vayan a hacer pruebas fuertes (menos recomendable si ya tienen datos que quieran conservar).

**Resumen RDS:** Mantener instancia mínima (t4g.micro), 20 GB, Multi-AZ false, retención de backup 1 en bajo uso. Si pueden, mover “desarrollo” a un MySQL gestionado externo más barato y dejar RDS para entornos que sí necesiten estar siempre disponibles.

---

### 2.2 Bastión EC2

- **Encendido solo cuando haga falta:**  
  - Si no están haciendo SSH ni túneles a RDS a diario, **apagar la instancia** (Stop) cuando no la usen y **volver a encenderla** (Start) cuando necesiten conectarse.  
  - Siguen pagando el EBS (disco), pero dejan de pagar el costo de la instancia (vCPU/RAM) mientras está parada.  
  - Comando útil:  
    - Parar: `aws ec2 stop-instances --instance-ids <INSTANCE_ID>`  
    - Iniciar: `aws ec2 start-instances --instance-ids <INSTANCE_ID>`  
  - La IP pública puede cambiar al reiniciar; si usan túnel, actualizar el host en el comando `ssh -L` o en la documentación interna.
- **Tamaño:** En `bastion.yaml` el default es **`t3.nano`** (suficiente para SSH/túnel); `t3.micro` solo si necesitas más RAM.
- **Eliminar el bastión si no lo necesitan:** Si solo acceden a RDS desde una API desplegada en ECS/Lambda dentro de la VPC, pueden **no desplegar el bastión** y ahorrarse ese costo por completo. El bastión solo es necesario para acceso humano (SSH/túnel) a RDS.

**Resumen bastión:** Apagar cuando no se use; o no desplegar el stack del bastión si no hay acceso humano a RDS.

---

### 2.3 API NestJS (qinspecting_api_nest) — EC2 en lugar de Lambda

Desde 2026-06 el backend Nest principal corre en **EC2 t4g.micro** (~USD 6–8/mes fijo) con API Gateway HTTP como proxy. Evita el límite de 250 MB descomprimido de Lambda y el pipeline CodeBuild de zip S3.

Detalle: [API_EC2.md](API_EC2.md).

### 2.4 API Gateway + Lambda Authorizer

- **API Gateway HTTP API:** Cobran por millón de solicitudes; con poco tráfico el costo es despreciable. No hace falta cambiar nada por costo en esta fase.
- **Lambda Authorizer:**  
  - En `template-sam.yaml` ya está **`MemorySize: 128`** MB en `Globals` (adecuado para bajo coste).  
  - Evitar poner la Lambda en **VPC** si no necesita RDS: en VPC los cold starts suelen ser mayores y puede implicar **NAT** u otros costes de red.

**Resumen:** HTTP API + Lambda con poca memoria y sin VPC innecesaria = coste marginal frente a ALB/ECS.

---

### 2.4 Secrets Manager

- Un secret por entorno suele ser suficiente. Cada secret tiene un costo mensual; no crear secrets duplicados por proyecto si pueden reutilizar uno (por ejemplo, mismo secret para JWT + DB en un entorno).

---

### 2.5 ECS Fargate + ALB (cuando los usen)

**Application Load Balancer (ALB)**

- **Dos componentes de facturación:**  
  1. **Hora de ALB** — se paga por cada hora (o fracción) que el balanceador exista; **es el coste fijo** que ves aunque no entre ni una petición.  
  2. **LCU (Load Balancer Capacity Units)** — según conexiones nuevas, peticiones, bytes y reglas evaluadas; con **tráfico casi nulo** suele ser **mucho menor** que la línea de “hora de ALB”.
- **Orden de magnitud:** en muchas regiones el cargo por hora del ALB equivale a **~USD 15–22/mes** por un solo ALB 24/7 (redondeando; **ver precio actual** en [Elastic Load Balancing pricing](https://aws.amazon.com/elasticloadbalancing/pricing/) o [AWS Pricing Calculator](https://calculator.aws/)).
- **Ahorro en pre-producción:** eliminar el ALB si no lo necesitas; usar **un solo ALB** compartido por varios target groups en lugar de uno por entorno; para APIs HTTP de bajo tráfico valorar **API Gateway + Lambda** (p. ej. `api_flutter_v2/sam`) **sin** ALB.
- **NLB:** también tiene cargo por hora + unidades de capacidad; no asumas que “cambia” el coste fijo de forma drástica sin comparar en la calculadora.

**ECS Fargate**

- **Modelo:** facturación por **vCPU-segundo** y **GB-segundo** de las tareas en ejecución (Linux/x86 o ARM según plataforma).
- **Importante:** una **ECS Service** con `desiredCount: 1` implica **una tarea encendida todo el mes** salvo que automatices lo contrario; no es como Lambda.
- **Reducir coste:** definición de tarea **mínima** (p. ej. **0,25 vCPU** y **0,5 GB** si la app lo tolera), **menos réplicas** en staging, o **detener** el servicio / bajar `desiredCount` a **0** en entornos de dev cuando no prueben (la consola o `aws ecs update-service --desired-count 0`).
- **“Escala a 0”:** el servicio ECS clásico no escala solo a 0 por defecto; hay que **bajar desired count manualmente**, con eventos (EventBridge + Lambda), o diseños alternativos (p. ej. tareas programadas en lugar de servicio siempre encendido).

**Resumen:** ALB ≈ coste fijo mensual notable; Fargate ≈ coste por **tiempo de CPU/RAM** de cada tarea. En pre-prod, lo más efectivo suele ser **no dejar ALB + Fargate encendidos** si ya tienes camino **Lambda** o no estás probando el contenedor.

---

### 2.6 CloudFront (opcional)

- Si no lo han desplegado, no añadirlo hasta que necesiten CDN o HTTPS centralizado. Si lo usan solo para una API, a menudo API Gateway basta y CloudFront añade costo y complejidad.

---

## 3. Cambios concretos en las plantillas (bajo uso)

Se pueden aplicar estos ajustes en los archivos de `arquitectura_aws/` para entornos de bajo uso o desarrollo:

### 3.1 `rds-databases.yaml`

- **Default de clase:** La plantilla ya usa **`db.t4g.micro`** por defecto (más barata que `t3.micro` en muchas regiones). Si el stack se creó antes, actualiza el parámetro `DBInstanceClass` en CloudFormation.
- **Retención de backups:** Ya existe el parámetro **`BackupRetentionPeriod`** (default **1**). Para máximo ahorro en dev puedes pasar **0** (sin backup automático; solo con snapshot manual o antes de borrar).
- **Almacenamiento:** `AllocatedStorage` default 20 GB; no subir hasta que lo necesites.

### 3.2 `template-sam.yaml` (Lambda Authorizer)

- **`MemorySize`:** Ya está en **128 MB** en `Globals.Function`. Si en el futuro subes memoria, hazlo solo si hace falta (más memoria = más coste por ms).

### 3.3 `bastion.yaml`

- **Tipo de instancia:** Parámetro **`InstanceType`** con default **`t3.nano`** (más barato que `t3.micro` para SSH/túnel). Al **actualizar** un stack que ya tenía `t3.micro`, CloudFormation puede **reemplazar** la instancia (nueva IP, revisar SG).
- **Operación:** Apagar la instancia cuando no se use (`stop-instances` / `start-instances`); ver README y BASTION.md.

---

## 4. Resumen de acciones recomendadas (ordenadas por impacto)

| Prioridad | Acción | Ahorro estimado |
|-----------|--------|------------------|
| 1 | **Apagar el bastión EC2** cuando no se use (o no desplegar bastión si no hace falta) | ~USD 4–8/mes según tamaño y horas encendido |
| 2 | **RDS:** `db.t4g.micro`, retención **0–1 día** en dev/staging (parámetros del stack) | Varios USD/mes (instancia + almacenamiento de backups) |
| 1b | **Bastión:** `t3.nano` (plantilla actual) en lugar de `t3.micro` | ~20–30 % menos por hora de instancia |
| 3 | **RDS:** No activar Multi-AZ en bajo uso (ya está en false) | Evita duplicar costo de instancia |
| 4 | **ALB:** eliminar o no desplegar si no hace falta; **un solo ALB** si varios servicios | A menudo **~USD 15–22/mes** solo por el ALB + LCU con uso |
| 4b | **ECS Fargate:** `desiredCount` 0 en dev cuando no prueben; tareas **0,25 vCPU / 0,5 GB** si aplica | Variable (varios USD a decenas USD/mes **por tarea** 24/7) |
| 5 | Lambda Authorizer ya en **128 MB** en `template-sam.yaml` | Mantener; evitar VPC si no consulta RDS |
| 6 | Un solo secret en Secrets Manager por entorno | Pequeño |
| 7 | Para “desarrollo” puro: valorar **MySQL gestionado externo** (Railway, Render, PlanetScale) y usar RDS solo para staging/prod | Depende del uso |

---

## 5. Costo objetivo “mínimo” con esta arquitectura en AWS

Si solo tienen:

- **RDS:** 1 instancia db.t4g.micro, 20 GB, 1 día de backup, sin Multi-AZ  
- **Bastión:** Apagado cuando no se use (o no desplegado)  
- **API Gateway + Lambda Authorizer:** Desplegados, poco tráfico  
- **Secrets Manager:** 1 secret  

El costo mensual razonable en us-east-1 sería del orden de **USD 15–20/mes** (fundamentalmente RDS + algo de Secrets Manager y datos). Cualquier cosa por encima de eso suele ser: bastión encendido, ALB, ECS, backups largos o datos/transfer.

---

## 6. Escalado futuro sin disparar costos

- **Cuando el uso crezca:**  
  - Subir retención de backups de RDS (ej. 7 días).  
  - Valorar instancia RDS mayor (db.t3.small) solo cuando vean CPU/IOPS limitados.  
  - Mantener un solo ALB para todos los servicios.  
  - Fargate con tamaño mínimo por tarea y escala automática por demanda.  
- **Alertas de costo:** Configurar **AWS Budgets** con alerta (ej. 50 USD o el equivalente en COP) para detectar picos y revisar qué recurso los causa.

Para cifras exactas en tu región, usa siempre la **[AWS Pricing Calculator](https://calculator.aws/)** (ELB + Fargate + RDS por separado).
