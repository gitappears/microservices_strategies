-- =============================================================================
-- bd_inspecciones - Esquema normalizado
-- Inspecciones, preoperacional, llantas, formatos especiales. Todas con id_empresa.
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Catálogos mínimos (o referenciar bd_catalogos / bd_personal)
-- Si se usan solo IDs de otras bases, no hace falta duplicar tablas.

-- Insp: ítem inspección
CREATE TABLE IF NOT EXISTS `insp_item_inspeccion` (
  `id_item_inspeccion` INT(20) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `nombre_item` VARCHAR(250) DEFAULT NULL,
  `descripcion` VARCHAR(500) DEFAULT NULL,
  `estado` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_item_inspeccion`, `id_empresa`),
  KEY `idx_insp_item_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insp: adjuntos inspección
CREATE TABLE IF NOT EXISTS `insp_adjuntos_inspeccion` (
  `id_adjunto` INT(20) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `url_adjunto` VARCHAR(500) DEFAULT NULL,
  `obs_adjunto` VARCHAR(10000) DEFAULT NULL,
  `id_rta_inspeccion` INT(20) NOT NULL,
  PRIMARY KEY (`id_adjunto`),
  KEY `idx_insp_adj_empresa` (`id_empresa`),
  KEY `idx_insp_adj_rta` (`id_rta_inspeccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insp: inspección llantas (encabezado)
CREATE TABLE IF NOT EXISTS `insp_inspeccion_llantas` (
  `id_enc_insp` BIGINT(15) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `placa` VARCHAR(10) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_enc_insp`),
  KEY `idx_insp_llantas_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Lla: detalle inspección llantas
CREATE TABLE IF NOT EXISTS `lla_det_inspeccion_llantas` (
  `id_detalle` BIGINT(15) NOT NULL,
  `id_enc_insp` BIGINT(15) NOT NULL,
  `externa` FLOAT(7,1) NOT NULL,
  `central` FLOAT(7,1) NOT NULL,
  `interna` FLOAT(7,1) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `idx_lla_det_enc` (`id_enc_insp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Preop: resumen preoperacional
CREATE TABLE IF NOT EXISTS `preop_resumen_preoperacional` (
  `id_resumen` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fecha_preoperacional` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ciudad_gps` VARCHAR(200) DEFAULT NULL,
  `kilometraje` INT(11) NOT NULL DEFAULT 0,
  `cant_tanqueo_galones` INT(11) DEFAULT NULL,
  `url_foto_km` LONGTEXT,
  `usuario_preoperacional` VARCHAR(50) NOT NULL,
  `numero_guia` VARCHAR(100) DEFAULT NULL,
  `url_foto_guia` LONGTEXT,
  `placa_vehiculo` VARCHAR(10) NOT NULL,
  `placa_remolque` VARCHAR(10) DEFAULT NULL,
  `id_ciudad` INT(20) NOT NULL,
  `foto_cabezote` LONGTEXT,
  `foto_trailer` LONGTEXT,
  `tipo_preope` ENUM('G','I') NOT NULL DEFAULT 'G',
  `id_rol` INT(20) DEFAULT NULL,
  `position_gps` TEXT,
  PRIMARY KEY (`id_resumen`),
  KEY `idx_preop_resumen_empresa` (`id_empresa`),
  KEY `idx_preop_resumen_placas` (`placa_vehiculo`, `placa_remolque`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Preop: respuestas preoperacional
CREATE TABLE IF NOT EXISTS `preop_rta_preoperacional` (
  `id_rta_preop` INT(20) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `rta_usuario` VARCHAR(10) NOT NULL,
  `id_preoperacional` INT(11) NOT NULL,
  `id_item_inps` INT(20) NOT NULL,
  `fecha_vencimiento` DATE DEFAULT NULL,
  PRIMARY KEY (`id_rta_preop`),
  KEY `idx_preop_rta_empresa` (`id_empresa`),
  KEY `idx_preop_rta_preop` (`id_preoperacional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Preop: fallas solucionadas
CREATE TABLE IF NOT EXISTS `preop_fallas_solucionadas` (
  `id_fallas_solucionadas` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `rdp_id` INT(11) NOT NULL,
  `id_resumen_preoperacional` INT(20) NOT NULL,
  `id_item_malo` INT(11) NOT NULL,
  `fecha_reporte_falla` DATE NOT NULL,
  `fecha_reporte_solucion` DATE NOT NULL,
  `foto` VARCHAR(500) DEFAULT NULL,
  `observaciones` VARCHAR(2000) NOT NULL,
  `persona_documento` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_fallas_solucionadas`),
  KEY `idx_preop_fallas_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Preop: fotos preoperacional ultimate
CREATE TABLE IF NOT EXISTS `preop_fotos_preoperacional_ultimate` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_resumen` INT(11) NOT NULL,
  `foto_cabina` LONGTEXT,
  `foto_ld` LONGTEXT,
  `foto_li` LONGTEXT,
  `foto_pd` LONGTEXT,
  `foto_pt` LONGTEXT,
  PRIMARY KEY (`id`),
  KEY `idx_preop_fotos_resumen` (`id_resumen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Lla: correctivas, desmontes, disposición final, histórico, estados (resumen)
CREATE TABLE IF NOT EXISTS `lla_correctivas_llantas` (
  `id` BIGINT(15) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `placa` VARCHAR(10) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `serial_llanta` VARCHAR(36) NOT NULL,
  `posicion` INT(2) NOT NULL,
  `fecha_control` DATETIME NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_lla_corr_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lla_desmontes_llantas` (
  `id` BIGINT(15) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `placa` VARCHAR(10) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `serial_llanta` VARCHAR(36) NOT NULL,
  `posicion` INT(2) NOT NULL,
  `fecha_control` DATETIME NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_lla_desm_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lla_disposicion_final_llantas` (
  `id_disp_final_llanta` BIGINT(15) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `placa` VARCHAR(10) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `serial_llanta` VARCHAR(36) NOT NULL,
  `posicion` INT(2) NOT NULL,
  `num_cert_disp_final` VARCHAR(36) NOT NULL,
  `img_acta_disp_final` LONGTEXT NOT NULL,
  `observacion` LONGTEXT NOT NULL,
  `user_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL,
  PRIMARY KEY (`id_disp_final_llanta`),
  KEY `idx_lla_disp_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lla_estados_llantas` (
  `id_estado_llanta` BIGINT(11) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_estado_llanta`),
  KEY `idx_lla_est_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Fes: formatos especiales
CREATE TABLE IF NOT EXISTS `fes_formato_especiales_cat` (
  `id` INT(11) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `nombre` VARCHAR(500) NOT NULL,
  `id_formato` INT(11) NOT NULL,
  `visible` ENUM('SI','NO') NOT NULL,
  `segmento` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`, `id_empresa`),
  KEY `idx_fes_cat_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `fes_formato_especiales_cat_item` (
  `id` INT(11) NOT NULL,
  `id_format_cat` INT(11) NOT NULL,
  `nombre` VARCHAR(250) NOT NULL,
  `imagen` MEDIUMTEXT NOT NULL,
  `tp_pregunta` ENUM('UNICO','MULTIPLE','F/V') NOT NULL,
  `puntaje` FLOAT(4,3) DEFAULT NULL,
  `rta_vp` VARCHAR(10) NOT NULL,
  `visible` ENUM('SI','NO') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fes_cat_item_cat` (`id_format_cat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `fes_formato_especiales_enca` (
  `id` INT(20) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_formato` INT(11) NOT NULL,
  `placa_v` VARCHAR(10) DEFAULT NULL,
  `placa_r` VARCHAR(10) DEFAULT NULL,
  `user_realiza` VARCHAR(50) NOT NULL,
  `u_operador` VARCHAR(50) NOT NULL,
  `fech_firma_op` DATETIME DEFAULT NULL,
  `u_evaluador` VARCHAR(50) NOT NULL,
  `fech_firma_ev` DATETIME DEFAULT NULL,
  `poseedor` VARCHAR(100) NOT NULL,
  `estado` VARCHAR(50) NOT NULL DEFAULT 'N/A',
  `calificacion` FLOAT(5,3) DEFAULT NULL,
  `periodo_evaluado` VARCHAR(10) DEFAULT NULL,
  `tp_evaluacion` VARCHAR(50) NOT NULL,
  `tp_vinculacion` VARCHAR(50) NOT NULL,
  `comentarios` MEDIUMTEXT,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fes_enca_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `fes_formato_especiales_enca_det` (
  `id_f_especial` INT(20) NOT NULL,
  `id_item_esp` INT(20) NOT NULL,
  `rta` VARCHAR(10) NOT NULL,
  `observacion` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_f_especial`, `id_item_esp`),
  KEY `idx_fes_det_enc` (`id_f_especial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `fes_formato_especiales_enca_exp` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_f_especial` INT(20) NOT NULL,
  `operacion` VARCHAR(100) NOT NULL,
  `tiempo` VARCHAR(50) NOT NULL,
  `tp_carga` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fes_exp_enc` (`id_f_especial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `fes_formato_especiales_user_realiza` (
  `usuario` VARCHAR(50) NOT NULL,
  `id_f_especial` INT(11) NOT NULL,
  `visible` ENUM('SI','NO') NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`usuario`, `id_f_especial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Relaciones item_has_fv (vehículo / remolque)
CREATE TABLE IF NOT EXISTS `insp_item_has_fv_vehiculo` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_item_inspeccion` INT(20) NOT NULL,
  `placa` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_insp_fv_veh_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `insp_item_has_fv_remolque` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_item_inspeccion` INT(20) NOT NULL,
  `placa_remolque` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_insp_fv_rem_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
