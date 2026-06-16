-- =============================================================================
-- Migra filas de cap_capacitacion → capacitaciones (LMS canónico) y enlaza lms_capacitacion_id
-- Idempotente: no duplica si ya existe enlace.
-- Requiere: instructores/personas con numero_documento = cap_capacitacion.idCapacitador
-- =============================================================================

SET NAMES utf8mb4;

-- Instructor por defecto (primer instructor activo) si no hay match por documento
SET @default_instructor_id := (
  SELECT i.id FROM instructores i WHERE i.activo = 1 ORDER BY i.id LIMIT 1
);

INSERT INTO `capacitaciones` (
  `titulo`,
  `descripcion`,
  `tipo_capacitacion_id`,
  `modalidad_id`,
  `instructor_id`,
  `duracion_horas`,
  `duracion_vigencia_dias`,
  `capacidad_maxima`,
  `imagen_portada_url`,
  `video_promocional_url`,
  `minimo_aprobacion`,
  `porcentaje_eficacia`,
  `estado`,
  `usuario_creacion`
)
SELECT
  COALESCE(NULLIF(TRIM(c.titulo), ''), CONCAT('Curso ', c.idCapacitacion)),
  c.descripcion,
  GREATEST(1, LEAST(COALESCE(c.tipoCapacitacion, 1), (SELECT COUNT(*) FROM tipos_capacitacion))),
  (SELECT id FROM modalidades_capacitacion ORDER BY id LIMIT 1),
  COALESCE(
    (
      SELECT i.id
      FROM instructores i
      INNER JOIN personas p ON p.id = i.persona_id
      WHERE p.numero_documento = c.idCapacitador
      LIMIT 1
    ),
    @default_instructor_id,
    1
  ),
  c.duracion_horas,
  c.duracion_vigencia_dias,
  c.capacidad_maxima,
  c.imagen_portada_url,
  c.video_promocional_url,
  c.minAprobacion,
  c.porcentajeEficacia,
  CASE c.estadoCapacitacion
    WHEN 0 THEN 'borrador'
    WHEN 1 THEN 'publicada'
    WHEN 2 THEN 'en_curso'
    WHEN 3 THEN 'finalizada'
    WHEN 4 THEN 'cancelada'
    ELSE 'publicada'
  END,
  COALESCE(NULLIF(TRIM(c.usuarioControl), ''), c.idCapacitador, 'migration')
FROM `cap_capacitacion` c
WHERE c.lms_capacitacion_id IS NULL
  AND NOT EXISTS (
    SELECT 1 FROM `capacitaciones` lms WHERE lms.id = c.idCapacitacion
  );

-- Enlazar por título+fecha si se insertó fila nueva (sin id coincidente)
UPDATE `cap_capacitacion` c
INNER JOIN `capacitaciones` lms
  ON lms.titulo = COALESCE(NULLIF(TRIM(c.titulo), ''), CONCAT('Curso ', c.idCapacitacion))
  AND lms.usuario_creacion = COALESCE(NULLIF(TRIM(c.usuarioControl), ''), c.idCapacitador, 'migration')
SET c.lms_capacitacion_id = lms.id
WHERE c.lms_capacitacion_id IS NULL;

-- Asignación tenant: id_empresa legacy → capacitaciones_empresas (si existe empresas.id = id_empresa)
INSERT IGNORE INTO `capacitaciones_empresas` (`empresa_id`, `capacitacion_id`, `permite_descarga_certificado`)
SELECT c.id_empresa, c.lms_capacitacion_id, 1
FROM `cap_capacitacion` c
WHERE c.lms_capacitacion_id IS NOT NULL
  AND EXISTS (SELECT 1 FROM `empresas` e WHERE e.id = c.id_empresa);
