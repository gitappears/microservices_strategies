# Mapeo Training LMS ↔ Multitenant QInspecting

Una sola base: **`bd_capacitaciones`**. Conviven dos dominios de cursos:

| Grupo | Tablas | Uso actual |
|-------|--------|------------|
| Legacy QI | `cap_capacitacion`, `cap_inscripcion`, `cap_preguntas_*`, … | Inspecciones / certificación histórica |
| Training LMS (canónico) | `capacitaciones`, `inscripciones`, `evaluaciones`, … | App Training (Formar360) + API `/trainings` |

## Por qué existen `cap_capacitacion` y `capacitaciones`

Son **dos modelos distintos** que crecieron en paralelo:

- **`cap_capacitacion`**: modelo multitenant QInspecting (`id_empresa`, `idCapacitador` como documento string, default `123456788`).
- **`capacitaciones`**: modelo LMS con FKs normalizadas (`instructor_id` → `instructores` → `personas.numero_documento`).

**No deben mezclarse IDs** entre tablas. El puente es la columna `cap_capacitacion.lms_capacitacion_id` → `capacitaciones.id`.

```
cap_capacitacion (legacy)          capacitaciones (LMS canónico)
├── idCapacitacion                 ├── id
├── id_empresa                     ├── instructor_id → instructores → personas
├── idCapacitador (doc string)     ├── tipo_capacitacion_id
└── lms_capacitacion_id ──────────►└── capacitaciones_empresas (tenant)
```

## API Nest `/trainings`

Desde la unificación, el módulo `modules/trainings` lee y escribe **`capacitaciones`** (LMS), no `cap_capacitacion`.

Filtros por rol:

| Rol | Criterio en LMS |
|-----|-----------------|
| ADMIN | Sin filtro |
| INSTRUCTOR | `capacitaciones.instructor_id` vía `instructores.persona_id` / `personas.numero_documento` |
| CLIENTE | `capacitaciones_empresas.empresa_id` |
| ALUMNO | `inscripciones` → `alumnos` → `personas` |

## Identidad (no duplicar en otras BDs)

| Training LMS (`bd_capacitaciones`) | Fuente de verdad QInspecting | Notas |
|-----------------------------------|------------------------------|-------|
| `empresas` | `ten_empresas` (`bd_tenancy_planes`) | Proyección local; enlazar por NIT / `numero_documento` |
| `personas` | `per_personal` (`bd_personal`) | Proyección local; PK surrogate `id` para FKs LMS |
| `usuarios` | Cognito + `per_personal` | `password_hash` vacío con SSO; resolver vía `TrainingUserProvisionerService` |
| `roles` / `persona_roles` | Cognito groups + `per_rol` | Mapeo ADMIN→admin, ALUMNO→driver, INSTRUCTOR→manager |

**Importante:** el grupo Cognito `admin` **no** debe promover a ADMIN en LMS si el usuario ya tiene rol operativo (`INSTRUCTOR`, `CLIENTE`, `ALUMNO`) en `usuarios.rol_principal_id`.

## Dominio académico

| Formar360 / training_api | `bd_capacitaciones` | DDL |
|--------------------------|---------------------|-----|
| Cursos | `capacitaciones` | `02_training_lms.sql` |
| Asignación tenant | `capacitaciones_empresas` | idem |
| Inscripciones | `inscripciones` | idem |
| Evaluaciones | `evaluaciones`, `intentos_evaluacion`, … | idem |
| Certificados | `certificados` | idem |
| Cursos legacy QI | `cap_capacitacion` | `00_schema.sql` (solo lectura/migración) |

## Migraciones DDL (orden)

```bash
# 1. Esquema legacy
mysql bd_capacitaciones < 00_schema.sql

# 2. Esquema LMS
mysql bd_capacitaciones < 02_training_lms.sql

# 3. Puente + FKs LMS
mysql bd_capacitaciones < 03_unify_capacitaciones_bridge.sql

# 4. Copiar filas legacy → LMS (idempotente)
mysql bd_capacitaciones < 04_migrate_cap_legacy_to_lms.sql
```

O vía TypeORM:

```bash
cd qinspecting_api_nest
DATABASE_TARGET=capacitaciones yarn migration:run
```

## Post-migración: asignar instructores

Los cursos legacy con `idCapacitador = 123456788` (placeholder) deben reasignarse:

```sql
-- Ver cursos sin instructor real
SELECT c.id, c.titulo, i.id AS instructor_id, p.numero_documento
FROM capacitaciones c
JOIN instructores i ON i.id = c.instructor_id
JOIN personas p ON p.id = i.persona_id
WHERE p.numero_documento = '123456788';

-- Actualizar instructor de un curso
UPDATE capacitaciones
SET instructor_id = (
  SELECT i.id FROM instructores i
  INNER JOIN personas p ON p.id = i.persona_id
  WHERE p.numero_documento = '12312312123'
  LIMIT 1
)
WHERE id = ?;
```
