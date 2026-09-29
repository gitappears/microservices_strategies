-- =============================================================================
-- bd_flota_documentos — esquema sincronizado desde RDS (bastión) 2026-09-29
-- Fuente: SHOW CREATE TABLE sobre qinspecting-prod vía túnel bastión.
-- Incluye todas las tablas base presentes en el bastión (excepto se omiten vistas).
-- Charset: utf8mb4 / utf8mb4_unicode_ci (según definición real de cada tabla).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- -----------------------------------------------------------------------------
-- bd_flota_documentos.doc_documentos_conductor
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `doc_documentos_conductor` (
  `id_doc_conductor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_empresa` int NOT NULL,
  `numero_documento_conductor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_id_documento` int NOT NULL,
  `numero_registro` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cat_lic` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lugar_expedicion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `url_documento` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_doc_conductor`,`id_empresa`),
  KEY `idx_doc_cond_empresa` (`id_empresa`),
  KEY `idx_doc_cond_persona` (`numero_documento_conductor`,`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.doc_documentos_flota
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `doc_documentos_flota` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fk_placa_flota` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_id_documento` int NOT NULL,
  `numero_registro` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `url_documento` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_item` int DEFAULT '0',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_doc_flota_empresa` (`id_empresa`),
  KEY `idx_doc_flota_placa` (`fk_placa_flota`,`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.doc_firmas_digitales
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `doc_firmas_digitales` (
  `id_firma` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `terminos_condiciones` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `firma` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_numero_doc` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_firma`),
  KEY `idx_doc_firma_empresa` (`id_empresa`),
  KEY `idx_doc_firma_persona` (`fk_numero_doc`,`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.migrations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.veh_cabezote_vehiculo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veh_cabezote_vehiculo` (
  `id_cabezote` int NOT NULL,
  `id_empresa` int NOT NULL,
  `placa_cabezote` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cilindraje` int NOT NULL,
  `combustible` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_motor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_serie` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `linea_veh` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_cabezote`,`id_empresa`),
  UNIQUE KEY `uk_veh_cabezote_placa` (`placa_cabezote`,`id_empresa`),
  KEY `idx_veh_cab_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.veh_cat_marca_vehiculo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veh_cat_marca_vehiculo` (
  `id_marca` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_marca`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.veh_cat_tipos_vehiculos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veh_cat_tipos_vehiculos` (
  `id_tipo_vehiculo` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `es_traccion` tinyint(1) NOT NULL DEFAULT '0',
  `cantidad_llantas` int NOT NULL DEFAULT '0',
  `tiene_llanta_repuesto` tinyint(1) NOT NULL DEFAULT '0',
  `aplica_remolque` tinyint(1) NOT NULL DEFAULT '0',
  `tipo_enganche` json DEFAULT NULL,
  `peso_max_remolque` decimal(8,2) DEFAULT NULL,
  `longitud_max_remolque` decimal(5,2) DEFAULT NULL,
  `url_img_chasis` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `icon_ref` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_tipo_vehiculo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.veh_hash_binomios
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veh_hash_binomios` (
  `id_binomio` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `placa_vehiculo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placa_trailer` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_binomio` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_fin_binomio` datetime NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_binomio`),
  KEY `idx_veh_binom_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.veh_remolque
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veh_remolque` (
  `id_remolque` int NOT NULL,
  `id_empresa` int NOT NULL,
  `placa_remolque` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revestimiento` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_ejes_remolque` int NOT NULL,
  `capacidad_toneladas` int NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_remolque`,`id_empresa`),
  UNIQUE KEY `uk_veh_remolque_placa` (`placa_remolque`,`id_empresa`),
  KEY `idx_veh_rem_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_flota_documentos.veh_vehiculo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `veh_vehiculo` (
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_empresa` int NOT NULL,
  `matricula` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fech_matricula` date NOT NULL,
  `color_placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_ciudad_matricula` int NOT NULL,
  `fk_marca` int NOT NULL,
  `modelo` int NOT NULL,
  `color_veh` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_veh` tinyint(1) NOT NULL,
  `id_proveedor` int NOT NULL,
  `id_tipo_veh` int NOT NULL,
  `km_actual` bigint NOT NULL DEFAULT '0' COMMENT 'Odómetro cabezote; equivalente legacy Veh_KmActual (RF-TC-056/057)',
  `id_integracion` int NOT NULL DEFAULT '0',
  `fecha_control` datetime NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`placa`,`id_empresa`),
  KEY `idx_veh_veh_empresa` (`id_empresa`),
  KEY `idx_veh_veh_km_actual` (`id_empresa`,`km_actual`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
