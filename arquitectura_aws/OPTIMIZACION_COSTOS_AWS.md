# Optimización de costos – Arquitectura AWS QInspecting

Este documento describe cómo **reducir al máximo** el costo de la arquitectura AWS cuando el uso es bajo o en fases tempranas, y cómo escalar de forma controlada después.

---

## 1. De dónde viene el gasto (y qué duele cuando casi no se usa)

Cuando el uso es bajo, la mayor parte del costo **no** viene del tráfico, sino de **recursos que están encendidos 24/7**:

| Componente | Comportamiento | Costo aproximado (us-east-1, bajo uso) |
|------------|----------------|----------------------------------------|
| **RDS MySQL** | Siempre encendido (instancia reservada de tiempo) | **~USD 15–25/mes** (db.t3.micro, 20 GB) |
| **Bastión EC2** | Siempre encendido si está desplegado | **~USD 8–10/mes** (t3.micro) |
| **API Gateway HTTP API** | Pago por millón de solicitudes | Muy bajo con poco tráfico |
| **Lambda (Authorizer)** | Pago por invocación + tiempo | Muy bajo con poco tráfico |
| **Secrets Manager** | Por secret/mes | ~USD 0,40/secret/mes |
| **ALB** (si lo usas) | Por hora + LCU | **~USD 16–22/mes** aunque no haya tráfico |
| **ECS Fargate** (si lo usas) | Por vCPU/hora y GB/hora | Depende de tareas y tiempo encendidas |

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
- **Tamaño:** `t3.micro` ya es el tamaño mínimo razonable; no bajar más.
- **Eliminar el bastión si no lo necesitan:** Si solo acceden a RDS desde una API desplegada en ECS/Lambda dentro de la VPC, pueden **no desplegar el bastión** y ahorrarse ese costo por completo. El bastión solo es necesario para acceso humano (SSH/túnel) a RDS.

**Resumen bastión:** Apagar cuando no se use; o no desplegar el stack del bastión si no hay acceso humano a RDS.

---

### 2.3 API Gateway + Lambda Authorizer

- **API Gateway HTTP API:** Cobran por millón de solicitudes; con poco tráfico el costo es despreciable. No hace falta cambiar nada por costo en esta fase.
- **Lambda Authorizer:**  
  - Timeout 10 s y 256 MB está bien.  
  - Si el Authorizer **no** consulta RDS (solo valida JWT), se puede bajar memoria a **128 MB** para ahorrar unos céntimos en duración; el impacto es mínimo.  
  - Evitar poner la Lambda en VPC si no necesita hablar con RDS; si la Lambda está en VPC y sí consulta RDS, el diseño actual es correcto pero añade algo de cold start.

**Resumen:** Dejar API Gateway y Lambda como están; solo bajar memoria del Authorizer a 128 MB si no usa RDS.

---

### 2.4 Secrets Manager

- Un secret por entorno suele ser suficiente. Cada secret tiene un costo mensual; no crear secrets duplicados por proyecto si pueden reutilizar uno (por ejemplo, mismo secret para JWT + DB en un entorno).

---

### 2.5 ECS Fargate + ALB (cuando los usen)

- **ALB:** Cobra por hora aunque no haya tráfico. Si despliegan ECS detrás de un ALB, ese costo es fijo cada mes.  
  - Alternativa más barata para **poco tráfico:** exponer los servicios con **API Gateway HTTP API → integración HTTP directa** a la IP pública del servicio (menos ideal para producción) o usar un **Network Load Balancer** solo si les encaja el modelo; en muchos casos el ALB sigue siendo la opción estándar, pero conviene tener **una sola ALB** para todos los servicios y no una por entorno de bajo uso.
- **Fargate:** Cobran por vCPU y memoria por tiempo de ejecución.  
  - Usar **tareas con tamaño mínimo** (0,25 vCPU, 0,5 GB) en desarrollo/staging.  
  - Apagar servicios (escala mínima 0) cuando no se usen, si su pipeline lo permite (por ejemplo, escala a 0 por la noche en staging).

---

### 2.6 CloudFront (opcional)

- Si no lo han desplegado, no añadirlo hasta que necesiten CDN o HTTPS centralizado. Si lo usan solo para una API, a menudo API Gateway basta y CloudFront añade costo y complejidad.

---

## 3. Cambios concretos en las plantillas (bajo uso)

Se pueden aplicar estos ajustes en los archivos de `arquitectura_aws/` para entornos de bajo uso o desarrollo:

### 3.1 `rds-databases.yaml`

- **Default de clase:** Usar `db.t4g.micro` como default (más barata que t3 en muchas regiones).
- **Retención de backups:** Añadir un parámetro opcional, por ejemplo `BackupRetentionPeriod`, con default **1** para no pagar 7 días de backups cuando no hace falta (en prod se puede pasar 7).

En la plantilla actual ya está `DBInstanceClass` con default `db.t3.micro`; se puede cambiar el default a `db.t4g.micro` y añadir un parámetro para la retención (ver sección 4).

### 3.2 `template-sam.yaml` (Lambda Authorizer)

- Si el Authorizer **no** consulta RDS (solo JWT), bajar `MemorySize` en `Globals.Function` a **128**.

### 3.3 Bastión

- No cambiar el tamaño; en la documentación (README/BASTION) dejar claro: **“Apagar la instancia cuando no se use para reducir costos”** y los comandos `stop-instances` / `start-instances`.

---

## 4. Resumen de acciones recomendadas (ordenadas por impacto)

| Prioridad | Acción | Ahorro estimado |
|-----------|--------|------------------|
| 1 | **Apagar el bastión EC2** cuando no se use (o no desplegar bastión si no hace falta) | ~USD 8–10/mes |
| 2 | **RDS:** Usar `db.t4g.micro`, retención de backup **1 día** en dev/staging | Varios USD/mes en almacenamiento de backups |
| 3 | **RDS:** No activar Multi-AZ en bajo uso (ya está en false) | Evita duplicar costo de instancia |
| 4 | Revisar si tienen **ALB o ECS** desplegados sin uso; si sí, apagar o escala 0 | Hasta USD 16–22/mes (ALB) |
| 5 | Lambda Authorizer a 128 MB si no usa RDS | Muy bajo, pero sin downside |
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

Si quieres, en el siguiente paso puedo proponerte los **diffs concretos** para `rds-databases.yaml` (parámetro de retención, default t4g) y para `template-sam.yaml` (128 MB), y un párrafo listo para pegar en `README.md` o `BASTION.md` sobre apagar el bastión.
