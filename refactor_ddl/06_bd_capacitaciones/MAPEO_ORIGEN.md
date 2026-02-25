# bd_capacitaciones – Origen y alineación con API

El esquema está alineado con las entidades TypeORM de **qinspecting_api_nest**. **Nombres de tablas en snake_case**; columnas en camelCase (mapeo con `@Column({ name: '...' })`). Se añade `id_empresa` en tablas transaccionales para multi-tenancy.

- **00_schema.sql**: solo tablas de dominio (cap_*). Sin duplicar catálogos.
- **01_catalogos.sql**: catálogos (tipo_adjuntos, cursos_certificados, tipo_pregunta, area). Opcional si ya existen en bd_personal.

En las entidades NestJS usar `@Entity('nombre_snake_case')` para que coincida con la BD.

## Tablas de dominio (00_schema.sql)

| Origen legacy (qinspect_new*) | Tabla en BD (snake_case)     | Entidad NestJS |
|------------------------------|------------------------------|----------------|
| capacitacion                 | cap_capacitacion             | Capacitacion   |
| adjuntosCapacitacion         | cap_adjuntos_capacitacion    | AdjuntosCapacitacion |
| evidencias                   | cap_evidencias               | Evidencias    |
| cursosCertificadosCapacitacion | cap_cursos_certificados_capacitacion | CursosCertificadosCapacitacion |
| cursosCertificadosConductor  | cap_cursos_certificados_conductor | CursosCertificadosConductor |
| vigenciaCapacitacion         | cap_vigencia_capacitacion    | VigenciaCapacitacion |
| preguntasCapacitacion        | cap_preguntas_capacitacion   | PreguntasCapacitacion |
| preguntasHasCapacitacion     | cap_preguntas_has_capacitacion | PreguntasHasCapacitacion |
| respuestasCapacitacion       | cap_respuestas_capacitacion  | RespuestasCapacitacion |
| respuestasUsuario            | cap_respuestas_usuario       | RespuestasUsuario |
| profesionalArea              | cap_profesional_area         | ProfesionalArea |

**Inscripción / alumnos por curso:** solo **cap_inscripcion** (progreso tipo Udemy). La tabla legacy `cap_q_realizan_capacitacion` fue eliminada del esquema; definir después estrategia de migración de datos legacy.

**Progreso tipo Udemy (misma capacidad que training_api):** ver [MODELO_PROGRESO_UDEMY.md](MODELO_PROGRESO_UDEMY.md).

| Concepto training_api | Tabla en bd_capacitaciones |
|------------------------|----------------------------|
| secciones_capacitacion | cap_seccion_capacitacion   |
| lecciones              | cap_leccion                |
| inscripciones          | cap_inscripcion (numero_documento_estudiante → bd_personal) |
| progreso_lecciones     | cap_progreso_leccion       |
| materiales_capacitacion| cap_material_capacitacion  |

Empresas y personal se gestionan en **bd_tenancy_planes** y **bd_personal**; en esta BD solo referencias por `id_empresa` y `numero_documento`.

## Catálogos (01_catalogos.sql, opcional)

| Tabla en BD (snake_case) | Entidad NestJS   |
|--------------------------|------------------|
| tipo_adjuntos            | TipoAdjuntos     |
| cursos_certificados      | CursosCertificados |
| tipo_pregunta            | TipoPregunta     |
| area                     | Area             |

Si estos catálogos ya viven en bd_personal, no ejecutes 01_catalogos.sql en bd_capacitaciones (evita tablas repetidas entre bases).

Referencias a **bd_personal**: `idCapacitador`, `usuarioControl`, `numeroDocumento`/`idUsuario`/`qrUsuario`/`usuarioRealiza` referencian personal por documento; las FK lógicas se resuelven por aplicación. Catálogos `tipoPregunta` y `area` pueden vivir también en bd_personal/bd_catalogos según diseño del microservicio.
