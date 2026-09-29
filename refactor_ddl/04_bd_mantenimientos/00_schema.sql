-- =============================================================================
-- bd_mantenimientos — esquema sincronizado desde RDS (bastión) 2026-09-29
-- Fuente: SHOW CREATE TABLE sobre qinspecting-prod vía túnel bastión.
-- Incluye todas las tablas base presentes en el bastión (excepto se omiten vistas).
-- Charset: utf8mb4 / utf8mb4_unicode_ci (según definición real de cada tabla).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- -----------------------------------------------------------------------------
-- bd_mantenimientos.ejm_ejecutores_mtto_especialidades
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ejm_ejecutores_mtto_especialidades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_ejecutor_interno` int DEFAULT NULL,
  `id_ejecutor_externo` int DEFAULT NULL,
  `id_especialidad` int NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ejm_esp_int` (`id_ejecutor_interno`),
  KEY `idx_ejm_esp_ext` (`id_ejecutor_externo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.ejm_ejecutores_mtto_externo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ejm_ejecutores_mtto_externo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `nit_razon_social` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_prov` int DEFAULT NULL COMMENT 'FK lógica prov_proveedor.id_prov (bd_inventario)',
  `id_sucursal` int DEFAULT NULL COMMENT 'FK lógica prov_sucursales_prov.id_sucursal (bd_inventario)',
  `codigo_externo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Código operativo del EM externo',
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT 'Observaciones operativas',
  `tipo_mostrar` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Visible en listas de selección (legacy show)',
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ejm_ext_empresa` (`id_empresa`),
  KEY `idx_ejm_ext_prov` (`id_empresa`,`id_prov`),
  KEY `idx_ejm_ext_sucursal` (`id_sucursal`),
  KEY `idx_ejm_ext_tipo_mostrar` (`tipo_mostrar`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.ejm_ejecutores_mtto_interno
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ejm_ejecutores_mtto_interno` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `numero_documento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_bodega` int DEFAULT NULL COMMENT 'FK man_bodegas',
  `codigo_interno` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `tipo_mostrar` tinyint(1) NOT NULL DEFAULT '1',
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ejm_int_empresa` (`id_empresa`),
  KEY `idx_ejm_int_bodega` (`id_bodega`),
  KEY `idx_ejm_int_tipo_mostrar` (`tipo_mostrar`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.ejm_em_inventario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ejm_em_inventario` (
  `id_producto` int NOT NULL,
  `id_empleado` int NOT NULL,
  `id_proyecto` int NOT NULL DEFAULT '0',
  `id_lote` int NOT NULL,
  `id_tipo_reserva` int NOT NULL,
  `cantidad` float(20,2) NOT NULL,
  `val_unitario` float(20,2) NOT NULL DEFAULT '0.00',
  `iva` float(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_producto`,`id_empleado`,`id_proyecto`,`id_lote`,`id_tipo_reserva`),
  KEY `idx_ejm_em_inv_empleado` (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.ejm_em_proyectos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ejm_em_proyectos` (
  `idProyecto` int NOT NULL,
  `idEmpleado` int NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaApertura` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `fechaCierre` timestamp(6) NULL DEFAULT NULL,
  `estado` enum('ABIERTO','CERRADO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ABIERTO',
  `fechaControl` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idProyecto`),
  KEY `idx_ejm_em_proy_empleado` (`idEmpleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_add_enc_orden_servicio
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_add_enc_orden_servicio` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fk_id_enc_ord_servicio` int NOT NULL,
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_man_add_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_articulos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_articulos` (
  `id_articulo` int NOT NULL,
  `id_empresa` int NOT NULL,
  `codigo_articulo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `diseno` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dimension` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_articulo` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `serial_si_no` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `mm_original` float(7,2) DEFAULT NULL,
  `vida_util_km` int DEFAULT NULL,
  `fk_id_tipo_articulo` int NOT NULL,
  `fk_id_catg_articulo` int NOT NULL,
  `fk_und_empaque_compra` int NOT NULL,
  `fk_und_empaque_entrega` int NOT NULL,
  `fk_id_marca_articulos` int NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_articulo`,`id_empresa`),
  KEY `idx_man_art_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_bodegas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_bodegas` (
  `id_bodega` int NOT NULL,
  `id_empresa` int NOT NULL,
  `nombre_bodega` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_ciudad_bodega` int NOT NULL,
  `estado_bodega` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_bodega`,`id_empresa`),
  KEY `idx_man_bod_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_categoria_articulos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_categoria_articulos` (
  `id_categoria_articulos` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `descripcion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_cat` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_categoria_articulos`),
  KEY `idx_man_cat_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_causas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_causas` (
  `id` int NOT NULL,
  `id_empresa` int NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mostrar` tinyint(1) NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`id_empresa`),
  KEY `idx_man_causas_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Causas mantenimiento; origen: manCausas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_det_solucion_orden_servicio
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_det_solucion_orden_servicio` (
  `id_det_solucion` bigint NOT NULL AUTO_INCREMENT,
  `fk_id_solucion_orden_servicio` int NOT NULL,
  `fk_id_articulo` int NOT NULL,
  `cantidad` int NOT NULL,
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_det_solucion`),
  KEY `idx_man_detsol_enc` (`fk_id_solucion_orden_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_detalle_orden_servicio
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_detalle_orden_servicio` (
  `id_detalle_orden_servicio` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fk_id_encab_ord_servicio` int NOT NULL,
  `fk_id_falla_has_item` int NOT NULL,
  `observacion_falla` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `foto_falla` mediumtext COLLATE utf8mb4_unicode_ci,
  `responsable` bigint NOT NULL,
  `ejecutor` bigint NOT NULL,
  `supervisor` bigint NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `hora_inicio` time DEFAULT NULL,
  `estado_det_orden` tinyint(1) NOT NULL,
  `fk_id_shr` int NOT NULL,
  PRIMARY KEY (`id_detalle_orden_servicio`),
  KEY `idx_man_det_empresa` (`id_empresa`),
  KEY `idx_man_det_enc` (`fk_id_encab_ord_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_enc_solucion_orden_servicio
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_enc_solucion_orden_servicio` (
  `id_solucion_orden_servicio` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fk_id_deta_orden_servicio` int NOT NULL,
  `observacion_solucion` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_ini` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `estado_enc` tinyint(1) NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_solucion_orden_servicio`),
  KEY `idx_man_sol_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_encabezado_orden_servicio
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_encabezado_orden_servicio` (
  `id_enc_ord_servicio` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `placa_vehiculo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `placa_remolque` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `tip_mtto` tinyint(1) DEFAULT NULL,
  `tipo_prioridad` tinyint(1) DEFAULT NULL,
  `fecha_programacion` date DEFAULT NULL,
  `observaciones` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `foto_general` mediumtext COLLATE utf8mb4_unicode_ci,
  `id_user_autoriza` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_control` datetime DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_enc_ord_ser` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_enc_ord_servicio`),
  KEY `idx_man_enc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_fallas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_fallas` (
  `id_fallas` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `descripcion_falla` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_falla` tinyint(1) NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_fallas`),
  KEY `idx_man_fallas_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_fallas_has_item
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_fallas_has_item` (
  `id_fallas_has_item` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fk_id_falla` int NOT NULL,
  `fk_id_item` int NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_fallas_has_item`),
  KEY `idx_man_fhi_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_frecuencias
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_frecuencias` (
  `id` int NOT NULL,
  `id_empresa` int NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sigla` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `habilitado` tinyint NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`id_empresa`),
  KEY `idx_man_frec_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Frecuencias mantenimiento; origen: manFrecuencias';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_marca_articulos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_marca_articulos` (
  `id_marca_articulos` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `descripcion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_marca` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `aplica_llantas` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_marca_articulos`),
  KEY `idx_man_marca_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_modulos_frontend
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_modulos_frontend` (
  `id_modulo` int NOT NULL AUTO_INCREMENT,
  `label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `label_flutter` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_flutter` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active_item` tinyint(1) NOT NULL,
  PRIMARY KEY (`id_modulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_prog_test
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_prog_test` (
  `plate` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `initial_date` date NOT NULL,
  `finish_date` date NOT NULL,
  PRIMARY KEY (`plate`,`initial_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Pruebas programación por placa; origen: manProgTest';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_prorroga_mtto_prog
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_prorroga_mtto_prog` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fk_id_programacion` int NOT NULL,
  `fecha_prorroga` date NOT NULL,
  `motivo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_man_pror_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_rutinas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_rutinas` (
  `id_rutina` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_id_sistema` int NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_rutina`),
  KEY `idx_man_rut_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_rutinas_tareas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_rutinas_tareas` (
  `id` int NOT NULL,
  `id_rutina` int NOT NULL,
  `id_tarea` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_man_rt_rutina` (`id_rutina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tareas por rutina; origen: manRutinasTareas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_seri_solu_os
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_seri_solu_os` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fk_id_det_solucion` bigint NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_man_seri_det` (`fk_id_det_solucion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_sistemas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_sistemas` (
  `id_sistema` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mostrar` tinyint(1) NOT NULL DEFAULT '1',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sistema`),
  KEY `idx_man_sist_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_sistemas_has_rutinas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_sistemas_has_rutinas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fk_id_sistema` int NOT NULL,
  `fk_id_rutina` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_man_shr_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_tareas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_tareas` (
  `id` int NOT NULL,
  `id_empresa` int NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `frecuencia` int NOT NULL,
  `tipo_frecuencia` int NOT NULL,
  `sistema` int NOT NULL,
  `tipo_mostrar` tinyint NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`id_empresa`),
  KEY `idx_man_tareas_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tareas mantenimiento; origen: manTareas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_tipo_articulos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_tipo_articulos` (
  `id_tipo_articulo` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `descripcion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_tipo_articulo` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_articulo`),
  KEY `idx_man_tipo_empresa` (`id_empresa`),
  KEY `idx_man_tipo_estado` (`estado_tipo_articulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_tipo_comprobante
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_tipo_comprobante` (
  `id_tipo_comprobante` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `descripcion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_tipo_comprobante`),
  KEY `idx_man_tc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.man_unidad_medida
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `man_unidad_medida` (
  `id_unidad_medida` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `descripcion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_unidad` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_unidad_medida`),
  KEY `idx_man_um_empresa` (`id_empresa`),
  KEY `idx_man_um_estado` (`estado_unidad`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.migrations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_historial_estados_asignacion_em_tareas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_historial_estados_asignacion_em_tareas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_asignacion` int NOT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_prog_hist_asig` (`id_asignacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto` (
  `id` int NOT NULL,
  `id_empresa` int NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reprogramado` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cambia si fecha_inicio difiere a la nueva',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_empresa` (`id_empresa`),
  KEY `idx_prog_mtto_placa` (`placa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cabecera programación mantenimiento; origen: programacion_mtto';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_asignacion_em_tareas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_asignacion_em_tareas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_programacion_mtto` int NOT NULL,
  `id_tarea` int DEFAULT NULL COMMENT 'FK man_tareas.id',
  `type_tarea` enum('TASK','ROUTINE','FAILURE_TASK','FAILURE_ROUTINE') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Origen de la tarea en programación',
  `id_rt` int NOT NULL DEFAULT '0' COMMENT 'id_rutina cuando type_tarea incluye ROUTINE',
  `id_em` int DEFAULT NULL COMMENT 'FK ejecutor interno/externo',
  `tipo_em` enum('INTERNAL','EXTERNAL') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `documento_conductor` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Documento conductor (vista conductor); opcional en asignación por tarea',
  `status` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'TO_BE_APPROVED',
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_asignacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_prog_asig_empresa` (`id_empresa`),
  KEY `idx_prog_asig_prog` (`id_programacion_mtto`),
  KEY `idx_prog_asig_tarea` (`id_tarea`),
  KEY `idx_prog_asig_ejecutor` (`id_em`,`tipo_em`),
  KEY `idx_prog_asig_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_fallas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_fallas` (
  `id` int NOT NULL,
  `id_programacion` int NOT NULL,
  `id_item_falla` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_fallas_prog` (`id_programacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Fallas por programación mtto; origen: programacion_mtto_fallas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_fallas_causas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_fallas_causas` (
  `id` int NOT NULL,
  `id_mtto_falla` int NOT NULL,
  `id_causa` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_fallas_causas_falla` (`id_mtto_falla`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Causas por falla programación; origen: programacion_mtto_fallas_causas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_fallas_rutinas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_fallas_rutinas` (
  `id` int NOT NULL,
  `id_falla_program` int NOT NULL,
  `id_rutina` int NOT NULL,
  `tipo_mtto` enum('PREVENTIVO','PREDICTIVO','CORRECTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_fallas_rut_falla` (`id_falla_program`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Rutinas por falla programación; origen: programacion_mtto_fallas_rutinas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_fallas_tareas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_fallas_tareas` (
  `id` int NOT NULL,
  `id_falla_program` int NOT NULL,
  `id_tarea` int NOT NULL,
  `tipo_mtto` enum('PREVENTIVO','PREDICTIVO','CORRECTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_fallas_tareas_falla` (`id_falla_program`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tareas por falla programación; origen: programacion_mtto_fallas_tareas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_rutinas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_rutinas` (
  `id` int NOT NULL,
  `id_programacion` int NOT NULL,
  `id_rutina` int NOT NULL,
  `tipo_mtto` enum('PREVENTIVO','PREDICTIVO','CORRECTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_rutinas_prog` (`id_programacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Rutinas por programación mtto; origen: programacion_mtto_rutinas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_rutinas_causas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_rutinas_causas` (
  `id` int NOT NULL,
  `id_mtto_rutina` int NOT NULL,
  `id_causa` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_rutinas_causas_rutina` (`id_mtto_rutina`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Causas por rutina programación; origen: programacion_mtto_rutinas_causas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_tareas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_tareas` (
  `id` int NOT NULL,
  `id_programacion` int NOT NULL,
  `id_tarea` int NOT NULL,
  `tipo_mtto` enum('PREVENTIVO','PREDICTIVO','CORRECTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_tareas_prog` (`id_programacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tareas por programación mtto; origen: programacion_mtto_tareas';

-- -----------------------------------------------------------------------------
-- bd_mantenimientos.prog_programacion_mtto_tareas_causas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prog_programacion_mtto_tareas_causas` (
  `id` int NOT NULL,
  `id_mtto_tarea` int NOT NULL,
  `id_causa` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_prog_mtto_tareas_causas_tarea` (`id_mtto_tarea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Causas por tarea programación; origen: programacion_mtto_tareas_causas';

SET FOREIGN_KEY_CHECKS = 1;
