-- =============================================================================
-- bd_capacitaciones — Puente legacy cap_capacitacion ↔ LMS capacitaciones
-- Ejecutar después de 00_schema.sql y 02_training_lms.sql
-- Compatible MySQL 5.7+ / MariaDB (sin ADD COLUMN IF NOT EXISTS)
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Enlace explícito: un curso legacy puede apuntar al curso LMS canónico (Formar360)
SET @col_exists := (
  SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'cap_capacitacion'
    AND COLUMN_NAME = 'lms_capacitacion_id'
);
SET @ddl := IF(
  @col_exists = 0,
  'ALTER TABLE `cap_capacitacion` ADD COLUMN `lms_capacitacion_id` INT(11) NULL COMMENT ''FK lógica → capacitaciones.id (curso LMS canónico)'' AFTER `idCapacitacion`',
  'SELECT ''lms_capacitacion_id ya existe'' AS info'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(*) FROM information_schema.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'cap_capacitacion'
    AND INDEX_NAME = 'idx_cap_cap_lms'
);
SET @ddl := IF(
  @idx_exists = 0,
  'ALTER TABLE `cap_capacitacion` ADD KEY `idx_cap_cap_lms` (`lms_capacitacion_id`)',
  'SELECT ''idx_cap_cap_lms ya existe'' AS info'
);
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- FKs LMS (integridad referencial del dominio Formar360)
-- Ejecutar solo si las tablas LMS existen y aún no tienen la constraint.

ALTER TABLE `personas`
  ADD CONSTRAINT `fk_personas_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_usuarios_rol` FOREIGN KEY (`rol_principal_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `instructores`
  ADD CONSTRAINT `fk_instructores_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `alumnos`
  ADD CONSTRAINT `fk_alumnos_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `capacitaciones`
  ADD CONSTRAINT `fk_capacitaciones_tipo` FOREIGN KEY (`tipo_capacitacion_id`) REFERENCES `tipos_capacitacion` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_capacitaciones_modalidad` FOREIGN KEY (`modalidad_id`) REFERENCES `modalidades_capacitacion` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_capacitaciones_instructor` FOREIGN KEY (`instructor_id`) REFERENCES `instructores` (`id`) ON UPDATE CASCADE;

ALTER TABLE `capacitaciones_empresas`
  ADD CONSTRAINT `fk_cap_emp_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cap_emp_capacitacion` FOREIGN KEY (`capacitacion_id`) REFERENCES `capacitaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `inscripciones`
  ADD CONSTRAINT `fk_inscripciones_capacitacion` FOREIGN KEY (`capacitacion_id`) REFERENCES `capacitaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inscripciones_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `alumnos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `materiales_capacitacion`
  ADD CONSTRAINT `fk_mat_capacitacion` FOREIGN KEY (`capacitacion_id`) REFERENCES `capacitaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS = 1;
