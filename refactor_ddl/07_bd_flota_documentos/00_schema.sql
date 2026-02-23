-- =============================================================================
-- bd_flota_documentos - Esquema normalizado
-- Vehículos, remolques, cabezotes, documentos flota/conductor, firmas. id_empresa en tablas.
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Catálogo tipos vehículo (referencia; puede estar en bd_catalogos)
CREATE TABLE IF NOT EXISTS `veh_cat_tipos_vehiculos` (
  `id_tipo_vehiculo` INT(11) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `estado` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_tipo_vehiculo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `veh_cat_marca_vehiculo` (
  `id_marca` INT(20) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_marca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Flota
CREATE TABLE IF NOT EXISTS `veh_vehiculo` (
  `placa` VARCHAR(10) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `matricula` VARCHAR(50) NOT NULL,
  `fech_matricula` DATE NOT NULL,
  `color_placa` VARCHAR(10) NOT NULL,
  `fk_ciudad_matricula` INT(20) NOT NULL,
  `fk_marca` INT(20) NOT NULL,
  `modelo` INT(10) NOT NULL,
  `color_veh` VARCHAR(10) NOT NULL,
  `estado_veh` TINYINT(1) NOT NULL,
  `id_proveedor` INT(20) NOT NULL,
  `id_tipo_veh` INT(20) NOT NULL,
  `id_integracion` INT(20) NOT NULL DEFAULT 0,
  `fecha_control` DATETIME NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`placa`, `id_empresa`),
  KEY `idx_veh_veh_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `veh_cabezote_vehiculo` (
  `id_cabezote` INT(10) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `placa_cabezote` VARCHAR(10) NOT NULL,
  `cilindraje` INT(10) NOT NULL,
  `combustible` VARCHAR(50) NOT NULL,
  `numero_motor` VARCHAR(50) NOT NULL,
  `numero_serie` VARCHAR(50) NOT NULL,
  `linea_veh` VARCHAR(20) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_cabezote`, `id_empresa`),
  UNIQUE KEY `uk_veh_cabezote_placa` (`placa_cabezote`, `id_empresa`),
  KEY `idx_veh_cab_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `veh_remolque` (
  `id_remolque` INT(11) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `placa_remolque` VARCHAR(10) NOT NULL,
  `revestimiento` VARCHAR(200) NOT NULL,
  `numero_ejes_remolque` INT(11) NOT NULL,
  `capacidad_toneladas` INT(11) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_remolque`, `id_empresa`),
  UNIQUE KEY `uk_veh_remolque_placa` (`placa_remolque`, `id_empresa`),
  KEY `idx_veh_rem_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `veh_hash_binomios` (
  `id_binomio` BIGINT(15) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `placa_vehiculo` VARCHAR(10) NOT NULL,
  `placa_trailer` VARCHAR(10) NOT NULL,
  `estado_binomio` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_fin_binomio` DATETIME NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_binomio`),
  KEY `idx_veh_binom_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Documentos conductor (numero_documento referencia a bd_personal)
CREATE TABLE IF NOT EXISTS `doc_documentos_conductor` (
  `id_doc_conductor` VARCHAR(50) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `numero_documento_conductor` VARCHAR(50) NOT NULL,
  `fk_id_documento` INT(20) NOT NULL,
  `numero_registro` VARCHAR(100) DEFAULT NULL,
  `cat_lic` VARCHAR(3) DEFAULT NULL,
  `lugar_expedicion` VARCHAR(100) DEFAULT NULL,
  `fecha_vencimiento` DATE DEFAULT NULL,
  `url_documento` VARCHAR(200) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_doc_conductor`, `id_empresa`),
  KEY `idx_doc_cond_empresa` (`id_empresa`),
  KEY `idx_doc_cond_persona` (`numero_documento_conductor`, `id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Documentos flota (placa puede ser vehículo o remolque)
CREATE TABLE IF NOT EXISTS `doc_documentos_flota` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fk_placa_flota` VARCHAR(10) NOT NULL,
  `fk_id_documento` INT(20) NOT NULL,
  `numero_registro` VARCHAR(100) DEFAULT NULL,
  `fecha_vencimiento` DATE DEFAULT NULL,
  `url_documento` VARCHAR(200) DEFAULT NULL,
  `id_item` INT(20) DEFAULT 0,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_doc_flota_empresa` (`id_empresa`),
  KEY `idx_doc_flota_placa` (`fk_placa_flota`, `id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Firmas digitales (numero_documento referencia a bd_personal)
CREATE TABLE IF NOT EXISTS `doc_firmas_digitales` (
  `id_firma` INT(20) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `terminos_condiciones` VARCHAR(10) NOT NULL,
  `firma` LONGTEXT NOT NULL,
  `fk_numero_doc` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_firma`),
  KEY `idx_doc_firma_empresa` (`id_empresa`),
  KEY `idx_doc_firma_persona` (`fk_numero_doc`, `id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
