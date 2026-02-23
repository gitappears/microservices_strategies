-- =============================================================================
-- bd_mantenimientos - Esquema normalizado
-- Órdenes de servicio, rutinas, fallas, programación mtto, ejecutores. id_empresa en tablas transaccionales.
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- Catálogos mantenimiento
CREATE TABLE IF NOT EXISTS `man_bodegas` (
  `id_bodega` INT(3) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `nombre_bodega` VARCHAR(200) NOT NULL,
  `id_ciudad_bodega` INT(11) NOT NULL,
  `estado_bodega` ENUM('ACTIVO','INACTIVO') NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_bodega`, `id_empresa`),
  KEY `idx_man_bod_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_categoria_articulos` (
  `id_categoria_articulos` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `descripcion` VARCHAR(200) NOT NULL,
  `estado_cat` ENUM('ACTIVO','INACTIVO') NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_categoria_articulos`),
  KEY `idx_man_cat_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_marca_articulos` (
  `id_marca_articulos` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `descripcion` VARCHAR(200) NOT NULL,
  `estado_marca` ENUM('ACTIVO','INACTIVO') NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `aplica_llantas` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_marca_articulos`),
  KEY `idx_man_marca_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_tipo_articulos` (
  `id_tipo_articulo` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `descripcion` VARCHAR(200) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_articulo`),
  KEY `idx_man_tipo_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_unidad_medida` (
  `id_unidad_medida` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_unidad_medida`),
  KEY `idx_man_um_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_tipo_comprobante` (
  `id_tipo_comprobante` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_comprobante`),
  KEY `idx_man_tc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_articulos` (
  `id_articulo` INT(11) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `codigo_articulo` VARCHAR(200) NOT NULL,
  `descripcion` VARCHAR(500) NOT NULL,
  `referencia` VARCHAR(100) NOT NULL,
  `diseno` VARCHAR(50) DEFAULT NULL,
  `dimension` VARCHAR(50) DEFAULT NULL,
  `estado_articulo` ENUM('ACTIVO','INACTIVO') NOT NULL,
  `serial_si_no` ENUM('SI','NO') NOT NULL,
  `mm_original` FLOAT(7,2) DEFAULT NULL,
  `vida_util_km` INT(11) DEFAULT NULL,
  `fk_id_tipo_articulo` INT(11) NOT NULL,
  `fk_id_catg_articulo` INT(11) NOT NULL,
  `fk_und_empaque_compra` INT(11) NOT NULL,
  `fk_und_empaque_entrega` INT(11) NOT NULL,
  `fk_id_marca_articulos` INT(11) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_articulo`, `id_empresa`),
  KEY `idx_man_art_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_fallas` (
  `id_fallas` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `descripcion_falla` VARCHAR(300) NOT NULL,
  `estado_falla` TINYINT(1) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_fallas`),
  KEY `idx_man_fallas_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_fallas_has_item` (
  `id_fallas_has_item` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fk_id_falla` INT(11) NOT NULL,
  `fk_id_item` INT(11) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_fallas_has_item`),
  KEY `idx_man_fhi_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_sistemas` (
  `id_sistema` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `nombre` VARCHAR(200) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sistema`),
  KEY `idx_man_sist_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_rutinas` (
  `id_rutina` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `nombre` VARCHAR(200) NOT NULL,
  `fk_id_sistema` INT(11) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_rutina`),
  KEY `idx_man_rut_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_sistemas_has_rutinas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fk_id_sistema` INT(11) NOT NULL,
  `fk_id_rutina` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_man_shr_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Órdenes de servicio
CREATE TABLE IF NOT EXISTS `man_encabezado_orden_servicio` (
  `id_enc_ord_servicio` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `placa_vehiculo` VARCHAR(10) NOT NULL DEFAULT '0',
  `placa_remolque` VARCHAR(10) NOT NULL DEFAULT '0',
  `tip_mtto` TINYINT(1) DEFAULT NULL,
  `tipo_prioridad` TINYINT(1) DEFAULT NULL,
  `fecha_programacion` DATE DEFAULT NULL,
  `observaciones` VARCHAR(2000) DEFAULT NULL,
  `foto_general` MEDIUMTEXT,
  `id_user_autoriza` VARCHAR(50) DEFAULT NULL,
  `fecha_control` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  `estado_enc_ord_ser` TINYINT(1) DEFAULT NULL,
  PRIMARY KEY (`id_enc_ord_servicio`),
  KEY `idx_man_enc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_detalle_orden_servicio` (
  `id_detalle_orden_servicio` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fk_id_encab_ord_servicio` INT(11) NOT NULL,
  `fk_id_falla_has_item` INT(11) NOT NULL,
  `observacion_falla` VARCHAR(1000) DEFAULT NULL,
  `foto_falla` MEDIUMTEXT,
  `responsable` BIGINT(12) NOT NULL,
  `ejecutor` BIGINT(12) NOT NULL,
  `supervisor` BIGINT(12) NOT NULL,
  `fecha_inicio` DATE DEFAULT NULL,
  `hora_inicio` TIME DEFAULT NULL,
  `estado_det_orden` TINYINT(1) NOT NULL,
  `fk_id_shr` INT(11) NOT NULL,
  PRIMARY KEY (`id_detalle_orden_servicio`),
  KEY `idx_man_det_empresa` (`id_empresa`),
  KEY `idx_man_det_enc` (`fk_id_encab_ord_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_enc_solucion_orden_servicio` (
  `id_solucion_orden_servicio` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fk_id_deta_orden_servicio` INT(11) NOT NULL,
  `observacion_solucion` VARCHAR(1000) DEFAULT NULL,
  `fecha_ini` DATETIME NOT NULL,
  `fecha_fin` DATETIME DEFAULT NULL,
  `estado_enc` TINYINT(1) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_solucion_orden_servicio`),
  KEY `idx_man_sol_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_det_solucion_orden_servicio` (
  `id_det_solucion` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `fk_id_solucion_orden_servicio` INT(11) NOT NULL,
  `fk_id_articulo` INT(11) NOT NULL,
  `cantidad` INT(11) NOT NULL,
  `observacion` VARCHAR(500) NOT NULL,
  PRIMARY KEY (`id_det_solucion`),
  KEY `idx_man_detsol_enc` (`fk_id_solucion_orden_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_add_enc_orden_servicio` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fk_id_enc_ord_servicio` INT(11) NOT NULL,
  `observacion` VARCHAR(500) DEFAULT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_man_add_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_prorroga_mtto_prog` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fk_id_programacion` INT(11) NOT NULL,
  `fecha_prorroga` DATE NOT NULL,
  `motivo` VARCHAR(500) DEFAULT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_man_pror_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_seri_solu_os` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `fk_id_det_solucion` BIGINT(20) NOT NULL,
  `serial` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_man_seri_det` (`fk_id_det_solucion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Programación mtto (si existe en origen)
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_asignacion_em_tareas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_programacion_mtto` INT(11) NOT NULL,
  `documento_conductor` VARCHAR(50) NOT NULL,
  `status` VARCHAR(30) NOT NULL DEFAULT 'TO_BE_APPROVED',
  `fecha_asignacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_asig_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `prog_historial_estados_asignacion_em_tareas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_asignacion` INT(11) NOT NULL,
  `status` VARCHAR(30) NOT NULL,
  `observacion` VARCHAR(500) DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_control` VARCHAR(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_prog_hist_asig` (`id_asignacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ejecutores mantenimiento
CREATE TABLE IF NOT EXISTS `ejm_ejecutores_mtto_interno` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `numero_documento` VARCHAR(50) NOT NULL,
  `nombre` VARCHAR(200) NOT NULL,
  `estado` TINYINT(1) NOT NULL DEFAULT 1,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ejm_int_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `ejm_ejecutores_mtto_externo` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `nit_razon_social` VARCHAR(200) NOT NULL,
  `estado` TINYINT(1) NOT NULL DEFAULT 1,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ejm_ext_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `ejm_ejecutores_mtto_especialidades` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_ejecutor_interno` INT(11) DEFAULT NULL,
  `id_ejecutor_externo` INT(11) DEFAULT NULL,
  `id_especialidad` INT(11) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ejm_esp_int` (`id_ejecutor_interno`),
  KEY `idx_ejm_esp_ext` (`id_ejecutor_externo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `man_modulos_frontend` (
  `id_modulo` INT(11) NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(500) NOT NULL,
  `icon` VARCHAR(100) NOT NULL,
  `type` VARCHAR(15) NOT NULL,
  `label_flutter` VARCHAR(100) NOT NULL,
  `icon_flutter` VARCHAR(100) NOT NULL,
  `active_item` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id_modulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
