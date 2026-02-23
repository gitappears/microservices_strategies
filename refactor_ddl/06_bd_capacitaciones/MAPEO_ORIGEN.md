# bd_capacitaciones – Origen

| Origen | Destino |
|--------|---------|
| capacitacion | cap_capacitacion |
| adjuntosCapacitacion / adjunto_capacitacion | cap_adjuntos_capacitacion |
| cursosCertificadosCapacitacion / cursos_certificados_has_capacitacion | cap_cursos_certificados_capacitacion |
| cursosCertificadosConductor / cursos_certificados_has_conductor | cap_cursos_certificados_conductor |
| evidencias | cap_evidencias |
| vigenciaCapacitacion | cap_vigencia_capacitacion |

Referencias: `numero_documento_conductor` / `id_capacitador` apuntan a bd_personal.per_personal (numero_documento + id_empresa). Catálogo cursosCertificados puede vivir en bd_catalogos o replicado aquí.
