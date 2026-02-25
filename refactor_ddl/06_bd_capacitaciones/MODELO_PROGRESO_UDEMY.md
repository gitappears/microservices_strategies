# Progreso tipo Udemy y autonomía del módulo de capacitaciones

Este documento describe cómo el esquema de **bd_capacitaciones** alcanza la misma **capacidad de escalado y autonomía** que el módulo **training_api** (progreso por alumno, secciones, lecciones, inscripción con estado) manteniendo **empresas y personal en otras bases**.

## Comparación con training_api

| Capacidad             | training_api                                                         | bd_capacitaciones (este esquema)                                                                     |
| --------------------- | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| Curso con estructura  | capacitaciones → secciones → lecciones                               | cap_capacitacion + cap_seccion_capacitacion + cap_leccion                                            |
| Alumnos por curso     | inscripciones (capacitacion_id + estudiante_id)                      | cap_inscripcion (capacitacion_id + numero_documento_estudiante)                                      |
| Progreso % por alumno | inscripciones.progreso_porcentaje                                    | cap_inscripcion.progreso_porcentaje                                                                  |
| Estado del alumno     | inscripciones.estado (inscrito, en_progreso, completado, abandonado) | cap_inscripcion.estado                                                                               |
| Progreso por lección  | progreso_lecciones (inscripcion + leccion, completada, tiempo)       | cap_progreso_leccion                                                                                 |
| Materiales del curso  | materiales_capacitacion                                              | cap_material_capacitacion                                                                            |
| Empresa / Persona     | Tablas locales (empresas, personas)                                  | **Referencias por id_empresa y numero_documento** (sin FK; datos en bd_tenancy_planes y bd_personal) |

## Referencias a otras bases (sin FK)

- **Empresas:** en todas las tablas transaccionales existe `id_empresa` (INT). La fuente de verdad es **bd_tenancy_planes** (ten_empresas). El servicio de capacitaciones recibe `id_empresa` en el token/contexto y filtra por él; no hay FK física.
- **Personal (alumnos, capacitadores):** se referencian por **numero_documento** (VARCHAR), que es la clave en **bd_personal** (per_personal). Ejemplos:
  - cap_inscripcion.numero_documento_estudiante
  - cap_capacitacion.idCapacitador  
    La validación y datos del personal se obtienen vía API del servicio de Personal o por consulta a bd_personal.

Con esto el **módulo de capacitaciones** es autónomo (toda la lógica de curso, secciones, lecciones, inscripción y progreso vive en bd_capacitaciones) y escalable, sin duplicar empresas ni personal.

## Tablas del modelo tipo Udemy (en 00_schema.sql)

| Tabla                         | Rol                                                                                                                                                                                                                                                       |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **cap_seccion_capacitacion**  | Secciones de un curso (orden, titulo, descripcion). FK lógica a cap_capacitacion.idCapacitacion vía capacitacion_id.                                                                                                                                      |
| **cap_leccion**               | Lecciones dentro de una sección (titulo, contenido, video_url, duracion_minutos, orden). FK lógica a cap_seccion_capacitacion.                                                                                                                            |
| **cap_inscripcion**           | Inscripción de un alumno (numero_documento_estudiante) en una capacitación. Incluye progreso_porcentaje, estado, fecha_inicio, fecha_finalizacion, calificacion_final, aprobado. Una fila por (capacitacion_id, numero_documento_estudiante, id_empresa). |
| **cap_progreso_leccion**      | Progreso por lección por inscripción: completada, fecha_inicio, fecha_completada, tiempo_dedicado_minutos. UNIQUE(inscripcion_id, leccion_id).                                                                                                            |
| **cap_material_capacitacion** | Materiales adjuntos del curso (nombre, url, tipo, orden). Opcional.                                                                                                                                                                                       |

## Flujo de progreso (tipo Udemy)

1. **Curso:** cap_capacitacion (una por curso).
2. **Contenido:** cap_seccion_capacitacion → cap_leccion (y opcionalmente cap_material_capacitacion).
3. **Inscripción:** al inscribir un alumno se crea cap_inscripcion (estado = inscrito; progreso_porcentaje = 0).
4. **Avance:** cuando el alumno completa una lección se inserta/actualiza cap_progreso_leccion (completada = 1, fecha_completada, tiempo_dedicado_minutos). El servicio puede recalcular cap_inscripcion.progreso_porcentaje (lecciones completadas / total) y actualizar estado a en_progreso o completado.
5. **Evaluación / aprobado:** si aplica, se actualiza cap_inscripcion.calificacion_final y aprobado (y estado = completado).

## Otras tablas del dominio

- **cap*evidencias, cap_respuestas*_, cap*preguntas*_:** evidencias y respuestas por capacitación/usuario; compatibles con el modelo de progreso (evidencias por lección o por curso según uso).
- **cap*cursos_certificados*\*** y **cap_vigencia_capacitacion:** certificados y vigencia; el servicio puede vincular certificado a una cap_inscripcion completada y aprobada.

La tabla legacy **cap_q_realizan_capacitacion** fue eliminada del esquema; el único registro de alumno en curso es **cap_inscripcion**. La estrategia de migración de datos legacy se definirá después.

## Columnas de cap_capacitacion

En **cap_capacitacion** están definidas: `descripcion` (TEXT), `duracion_horas` (DECIMAL(5,2)), `duracion_vigencia_dias` (INT), `imagen_portada_url`, `video_promocional_url` (VARCHAR(500)), `capacidad_maxima` (INT). Así el módulo de capacitaciones queda con la misma capacidad de manejo de progreso tipo Udemy que training_api, manteniendo empresas y personal en sus propias bases.
