-- =============================================================================
-- bd_inspecciones — esquema sincronizado desde RDS (bastión) 2026-09-29
-- Fuente: SHOW CREATE TABLE sobre qinspecting-prod vía túnel bastión.
-- Incluye todas las tablas base presentes en el bastión (excepto se omiten vistas).
-- Charset: utf8mb4 / utf8mb4_unicode_ci (según definición real de cada tabla).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- -----------------------------------------------------------------------------
-- bd_inspecciones.fes_formato_especiales_cat
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fes_formato_especiales_cat` (
  `id` int NOT NULL,
  `id_empresa` int NOT NULL,
  `nombre` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_formato` int NOT NULL,
  `visible` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `segmento` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`id_empresa`),
  KEY `idx_fes_cat_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.fes_formato_especiales_cat_item
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fes_formato_especiales_cat_item` (
  `id` int NOT NULL,
  `id_format_cat` int NOT NULL,
  `nombre` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imagen` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `tp_pregunta` enum('UNICO','MULTIPLE','F/V') COLLATE utf8mb4_unicode_ci NOT NULL,
  `puntaje` float(4,3) DEFAULT NULL,
  `rta_vp` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `visible` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fes_cat_item_cat` (`id_format_cat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.fes_formato_especiales_enca
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fes_formato_especiales_enca` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_formato` int NOT NULL,
  `placa_v` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `placa_r` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_realiza` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `u_operador` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fech_firma_op` datetime DEFAULT NULL,
  `u_evaluador` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fech_firma_ev` datetime DEFAULT NULL,
  `poseedor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N/A',
  `calificacion` float(5,3) DEFAULT NULL,
  `periodo_evaluado` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tp_evaluacion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tp_vinculacion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comentarios` mediumtext COLLATE utf8mb4_unicode_ci,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_fes_enca_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.fes_formato_especiales_enca_det
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fes_formato_especiales_enca_det` (
  `id_f_especial` int NOT NULL,
  `id_item_esp` int NOT NULL,
  `rta` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_f_especial`,`id_item_esp`),
  KEY `idx_fes_det_enc` (`id_f_especial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.fes_formato_especiales_enca_exp
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fes_formato_especiales_enca_exp` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_f_especial` int NOT NULL,
  `operacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tiempo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tp_carga` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_fes_exp_enc` (`id_f_especial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.fes_formato_especiales_user_realiza
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fes_formato_especiales_user_realiza` (
  `usuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_f_especial` int NOT NULL,
  `visible` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`usuario`,`id_f_especial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.insp_adjuntos_inspeccion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `insp_adjuntos_inspeccion` (
  `id_adjunto` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `url_adjunto` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `obs_adjunto` varchar(10000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_rta_inspeccion` int NOT NULL,
  PRIMARY KEY (`id_adjunto`),
  KEY `idx_insp_adj_empresa` (`id_empresa`),
  KEY `idx_insp_adj_rta` (`id_rta_inspeccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.insp_inspeccion_llantas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `insp_inspeccion_llantas` (
  `id_enc_insp` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_enc_insp`),
  KEY `idx_insp_llantas_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.insp_item_has_fv_remolque
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `insp_item_has_fv_remolque` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_item_inspeccion` int NOT NULL,
  `placa_remolque` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_insp_fv_rem_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.insp_item_has_fv_vehiculo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `insp_item_has_fv_vehiculo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_item_inspeccion` int NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_insp_fv_veh_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.insp_item_inspeccion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `insp_item_inspeccion` (
  `id_item_inspeccion` int NOT NULL,
  `id_empresa` int NOT NULL,
  `nombre_item` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_categoria_item` int DEFAULT NULL,
  `prioridad` tinyint(1) DEFAULT NULL,
  `categoria_rv` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_item_inspeccion`,`id_empresa`),
  KEY `idx_insp_item_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.insp_item_tipo_vehiculo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `insp_item_tipo_vehiculo` (
  `id_item_tipo_vehiculo` int NOT NULL,
  `id_item` int NOT NULL,
  `id_empresa` int NOT NULL,
  `id_tipo_vehiculo` int NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_item_tipo_vehiculo`),
  KEY `idx_insp_item_tpv_item` (`id_item`),
  KEY `idx_insp_item_tpv_tipo` (`id_tipo_vehiculo`),
  KEY `idx_insp_item_tpv_empresa_item` (`id_empresa`,`id_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_cat_tipo_desgaste
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_cat_tipo_desgaste` (
  `id` int NOT NULL,
  `rango_inicial` int NOT NULL,
  `rango_final` int NOT NULL,
  `url_llanta` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Rangos de desgaste para visualización de llantas (origen: tipoDesgaste)';

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_cat_tipo_llantas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_cat_tipo_llantas` (
  `id_tipo_llantas` int NOT NULL,
  `nombre_tipo_llantas` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_tipo_llantas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tipos de llantas (origen: tipoLlantas)';

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_cat_tipo_rin
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_cat_tipo_rin` (
  `id_tipo_rin` int NOT NULL,
  `nombre_tipo_rin` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_tipo_rin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tipos de rin (origen: tipoRin)';

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_correctivas_llantas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_correctivas_llantas` (
  `id` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_producto` int NOT NULL,
  `serial_llanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posicion` int NOT NULL,
  `fecha_control` datetime NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correctivas` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observacion` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_lla_corr_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_desmontes_llantas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_desmontes_llantas` (
  `id` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_producto` int NOT NULL,
  `serial_llanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posicion` int NOT NULL,
  `fecha_control` datetime NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_lla_desm_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_det_inspeccion_llantas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_det_inspeccion_llantas` (
  `id_detalle` bigint NOT NULL,
  `id_enc_insp` bigint NOT NULL,
  `externa` float(7,1) NOT NULL,
  `central` float(7,1) NOT NULL,
  `interna` float(7,1) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `idx_lla_det_enc` (`id_enc_insp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_disposicion_final_llantas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_disposicion_final_llantas` (
  `id_disp_final_llanta` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_producto` int NOT NULL,
  `serial_llanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posicion` int NOT NULL,
  `num_cert_disp_final` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `img_acta_disp_final` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL,
  PRIMARY KEY (`id_disp_final_llanta`),
  KEY `idx_lla_disp_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_estados_llantas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_estados_llantas` (
  `id_estado_llanta` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `nombre_estado` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion_estado` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `porcentaje_min` decimal(5,2) DEFAULT NULL,
  `porcentaje_max` decimal(5,2) DEFAULT NULL,
  `descripcion_rango` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `color_hex` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '#4caf50',
  `clase_nivel` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `icono_url` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `orden_visual` int NOT NULL DEFAULT '1',
  `es_activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_estado_llanta`),
  KEY `idx_lla_est_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_historico_procedimientos_llanta
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_historico_procedimientos_llanta` (
  `id_his_proc_llanta` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_producto` int NOT NULL,
  `serial_llanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posicion` int NOT NULL,
  `id_procedimiento` int NOT NULL,
  `tipo_procedimiento` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_his_proc_llanta`),
  KEY `idx_lla_hist_empresa` (`id_empresa`),
  KEY `idx_lla_hist_placa_serial` (`placa`,`serial_llanta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Historial de procedimientos aplicados a cada llanta';

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_inspeccion_llanta_item
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_inspeccion_llanta_item` (
  `id_enc_insp` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_producto` int NOT NULL,
  `serial_llanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `json_informacion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_url_llanta` int NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_enc_insp`,`serial_llanta`),
  KEY `idx_lla_inspeccion_item_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Una fila por llanta en la inspección (JSON + URL imagen); origen: inspeccionLlantas';

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_reencauchadoras
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_reencauchadoras` (
  `id_reencauchadora` int NOT NULL,
  `id_empresa` int NOT NULL,
  `nombre_reencauchadora` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reencauchadora`,`id_empresa`),
  KEY `idx_lla_reenc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Reencauchadoras (origen: reencauchadoras)';

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_referencias_llanta
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_referencias_llanta` (
  `id_referencia` int unsigned NOT NULL,
  `id_empresa` int NOT NULL,
  `codigo_referencia` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ancho_banda_mm` decimal(6,2) NOT NULL COMMENT 'Anchura banda de rodadura mm',
  `altura_perfil` decimal(5,2) NOT NULL COMMENT 'Relación altura/ancho %',
  `tipo_construccion` enum('R','B','D') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'R' COMMENT 'R: radial, B: belted bias, D: diagonal',
  `diametro_rin_pulg` decimal(5,2) NOT NULL COMMENT 'Diámetro interior rin pulgadas',
  `descripcion` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_referencia`),
  KEY `idx_lla_ref_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_registro_kilometraje_llantas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_registro_kilometraje_llantas` (
  `id_registro` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `id_producto` int NOT NULL,
  `serial_llanta` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placa_remolque` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `placa_cabezote` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `km_inicial` bigint NOT NULL,
  `km_final` bigint DEFAULT NULL,
  `km_tramo` bigint DEFAULT NULL COMMENT 'Calculado: km_final - km_inicial cuando se cierra tramo',
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_registro`),
  KEY `idx_lla_km_empresa` (`id_empresa`),
  KEY `idx_lla_km_serial` (`serial_llanta`,`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Registro de kilometraje por tramo por llanta';

-- -----------------------------------------------------------------------------
-- bd_inspecciones.lla_trazabilidad_reencauches
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lla_trazabilidad_reencauches` (
  `id_trazabilidad` int NOT NULL,
  `id_empresa` int NOT NULL,
  `serial_original` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `serial_actual` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_producto` int NOT NULL,
  `ciclo_reencauche` enum('R1','R2','R3') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_bodega_origen` int DEFAULT NULL,
  `id_bodega_destino` int NOT NULL,
  `id_reencauchadora` int DEFAULT NULL,
  `fecha_movimiento` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_movimiento` enum('EN_PROSPECTO','EN_REENCAUCHADORA','REENCAUCHADA','RECHAZADA','EN_OPERACION') COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_trazabilidad`),
  KEY `idx_lla_traz_empresa` (`id_empresa`),
  KEY `idx_lla_traz_serial` (`serial_actual`,`serial_original`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Trazabilidad de reencauches por llanta';

-- -----------------------------------------------------------------------------
-- bd_inspecciones.migrations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.preop_fallas_solucionadas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `preop_fallas_solucionadas` (
  `id_fallas_solucionadas` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `rdp_id` int NOT NULL,
  `id_resumen_preoperacional` int NOT NULL,
  `id_item_malo` int NOT NULL,
  `fecha_reporte_falla` date NOT NULL,
  `fecha_reporte_solucion` date NOT NULL,
  `foto` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `persona_documento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_fallas_solucionadas`),
  KEY `idx_preop_fallas_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.preop_fotos_preoperacional_ultimate
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `preop_fotos_preoperacional_ultimate` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_resumen` int NOT NULL,
  `foto_cabina` longtext COLLATE utf8mb4_unicode_ci,
  `foto_ld` longtext COLLATE utf8mb4_unicode_ci,
  `foto_li` longtext COLLATE utf8mb4_unicode_ci,
  `foto_pd` longtext COLLATE utf8mb4_unicode_ci,
  `foto_pt` longtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `idx_preop_fotos_resumen` (`id_resumen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.preop_resumen_preoperacional
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `preop_resumen_preoperacional` (
  `id_resumen` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fecha_preoperacional` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ciudad_gps` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `kilometraje` int NOT NULL DEFAULT '0',
  `cant_tanqueo_galones` int DEFAULT NULL,
  `url_foto_km` longtext COLLATE utf8mb4_unicode_ci,
  `usuario_preoperacional` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_guia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_foto_guia` longtext COLLATE utf8mb4_unicode_ci,
  `placa_vehiculo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placa_remolque` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_ciudad` int NOT NULL,
  `foto_cabezote` longtext COLLATE utf8mb4_unicode_ci,
  `foto_trailer` longtext COLLATE utf8mb4_unicode_ci,
  `tipo_preope` enum('G','I') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'G',
  `id_rol` int DEFAULT NULL,
  `position_gps` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_resumen`),
  KEY `idx_preop_resumen_empresa` (`id_empresa`),
  KEY `idx_preop_resumen_placas` (`placa_vehiculo`,`placa_remolque`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inspecciones.preop_rta_preoperacional
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `preop_rta_preoperacional` (
  `id_rta_preop` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `rta_usuario` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_preoperacional` int NOT NULL,
  `id_item_inps` int NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  PRIMARY KEY (`id_rta_preop`),
  KEY `idx_preop_rta_empresa` (`id_empresa`),
  KEY `idx_preop_rta_preop` (`id_preoperacional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
