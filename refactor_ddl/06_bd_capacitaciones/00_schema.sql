-- =============================================================================
-- bd_capacitaciones - Esquema normalizado
-- Capacitaciones, adjuntos, cursos certificados, evidencias. id_empresa en tablas.
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `cap_capacitacion` (
  `id_capacitacion` INT(25) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `titulo` VARCHAR(500) DEFAULT NULL,
  `enunciado` VARCHAR(2000) DEFAULT NULL,
  `estado_capacitacion` TINYINT(1) NOT NULL DEFAULT 1,
  `id_capacitador` VARCHAR(50) NOT NULL,
  `fecha_creacion` DATE NOT NULL,
  `min_aprobacion` INT(11) NOT NULL,
  `porcentaje_eficacia` INT(11) NOT NULL,
  `tipo_capacitacion` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=capacitación, 2=certificación',
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_capacitacion`, `id_empresa`),
  KEY `idx_cap_cap_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cap_adjuntos_capacitacion` (
  `id_adjunto` INT(25) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_capacitacion` INT(25) NOT NULL,
  `nombre_adjunto` VARCHAR(200) DEFAULT NULL,
  `id_tipo_adjunto` INT(25) NOT NULL,
  `url_adjunto` VARCHAR(500) DEFAULT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_adjunto`),
  KEY `idx_cap_adj_empresa` (`id_empresa`),
  KEY `idx_cap_adj_cap` (`id_capacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cap_cursos_certificados_capacitacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_curso_certificado` INT(11) NOT NULL,
  `id_capacitacion` INT(25) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cap_ccc_empresa` (`id_empresa`),
  UNIQUE KEY `uk_cap_ccc_curso_cap` (`id_curso_certificado`, `id_capacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cap_cursos_certificados_conductor` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `numero_documento_conductor` VARCHAR(50) NOT NULL,
  `id_curso_certificado` INT(11) NOT NULL,
  `fecha_obtencion` DATE DEFAULT NULL,
  `fecha_vencimiento` DATE DEFAULT NULL,
  `url_documento` VARCHAR(500) DEFAULT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cap_cccond_empresa` (`id_empresa`),
  KEY `idx_cap_cccond_conductor` (`numero_documento_conductor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cap_evidencias` (
  `id_evidencia` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_capacitacion` INT(25) NOT NULL,
  `numero_documento_usuario` VARCHAR(50) NOT NULL,
  `fecha_realizacion` DATETIME NOT NULL,
  `puntaje` FLOAT(10,2) DEFAULT NULL,
  `url_evidencia` VARCHAR(500) DEFAULT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_evidencia`),
  KEY `idx_cap_ev_empresa` (`id_empresa`),
  KEY `idx_cap_ev_cap` (`id_capacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cap_vigencia_capacitacion` (
  `id_vigencia` INT(25) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fecha_inicio` DATE DEFAULT NULL,
  `fecha_fin` DATE DEFAULT NULL,
  `fk_id_capacitacion` INT(25) NOT NULL,
  PRIMARY KEY (`id_vigencia`),
  KEY `idx_cap_vig_empresa` (`id_empresa`),
  KEY `idx_cap_vig_cap` (`fk_id_capacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
