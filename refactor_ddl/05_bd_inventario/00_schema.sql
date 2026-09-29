-- =============================================================================
-- bd_inventario — esquema sincronizado desde RDS (bastión) 2026-09-29
-- Fuente: SHOW CREATE TABLE sobre qinspecting-prod vía túnel bastión.
-- Incluye todas las tablas base presentes en el bastión (excepto se omiten vistas).
-- Charset: utf8mb4 / utf8mb4_unicode_ci (según definición real de cada tabla).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- -----------------------------------------------------------------------------
-- bd_inventario.inv_almacen_inventario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_almacen_inventario` (
  `id_producto` int NOT NULL,
  `id_empresa` int NOT NULL,
  `id_almacen` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_tipo_reserva` int NOT NULL,
  `cantidad` float(20,2) NOT NULL,
  `val_unitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  PRIMARY KEY (`id_producto`,`id_empresa`,`id_almacen`,`id_lote`,`id_tipo_reserva`),
  KEY `idx_inv_alm_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_det_dev_inventario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_det_dev_inventario` (
  `id_dev_inventario` bigint NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_reserva` int NOT NULL,
  `cantidad_ent_cons` float(20,2) NOT NULL,
  `observacion` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_dev_inventario`,`id_producto`,`id_lote`,`id_reserva`),
  KEY `idx_inv_detdev_enc` (`id_dev_inventario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_det_entrada_inv
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_det_entrada_inv` (
  `id_enc_entrada_inv` int NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_reserva` int NOT NULL,
  `cantidad` float(20,2) NOT NULL,
  `val_unitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  PRIMARY KEY (`id_enc_entrada_inv`,`id_producto`,`id_lote`,`id_reserva`),
  KEY `idx_inv_detent_enc` (`id_enc_entrada_inv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_det_inventarios
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_det_inventarios` (
  `id_inventario` int NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_reserva` int NOT NULL,
  `cantidad_sistema` int NOT NULL,
  `cantidad_inventario` int NOT NULL,
  `cantidad_devuelta` int NOT NULL,
  `cantidad_recibida` int NOT NULL,
  `observacion_detalle` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_inventario`,`id_producto`,`id_lote`,`id_reserva`),
  KEY `idx_inv_det_enc` (`id_inventario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_det_salida_proveedor
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_det_salida_proveedor` (
  `id_enc_salida_prov` int NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote_salida` int NOT NULL,
  `id_reserva_almacen` int NOT NULL,
  `cantidad_salida` float(20,2) NOT NULL,
  `val_unitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `obs_salida_prove` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_enc_salida_prov`,`id_producto`,`id_lote_salida`,`id_reserva_almacen`),
  KEY `idx_inv_detsalprov_enc` (`id_enc_salida_prov`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_det_solicitud_mat
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_det_solicitud_mat` (
  `id_det_solicitud` int NOT NULL,
  `id_solicitud_mat` int NOT NULL,
  `id_producto` int NOT NULL,
  `cantidad` float(20,2) NOT NULL,
  `obs_solicitud` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_det_solicitud`,`id_solicitud_mat`),
  KEY `idx_inv_detsolic_enc` (`id_solicitud_mat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_det_tranfer_em
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_det_tranfer_em` (
  `id_salida_material` bigint NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_reserva` int NOT NULL,
  `cantidad_ent_cons` float(20,2) NOT NULL,
  `val_unitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `observacion_salida` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_salida_material`,`id_producto`,`id_lote`,`id_reserva`),
  KEY `idx_inv_dettran_enc` (`id_salida_material`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_det_traslado_moviles
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_det_traslado_moviles` (
  `id_traslado_movil` int NOT NULL,
  `id_reserva` int NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote_traslado` int NOT NULL,
  `cantidad_trasladar` float(20,2) NOT NULL,
  `obs_traslado` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_traslado_movil`,`id_reserva`,`id_producto`,`id_lote_traslado`),
  KEY `idx_inv_dettras_enc` (`id_traslado_movil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_det_traslado_reservas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_det_traslado_reservas` (
  `id_traslado_reserva` int NOT NULL,
  `id_old_rese` int NOT NULL,
  `id_new_rese` int NOT NULL,
  `id_pro_tras_rese` int NOT NULL,
  `id_lote_tras_rese` int NOT NULL,
  `cant_tras_reserva` float(20,2) NOT NULL,
  `val_unitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `obs_tras_reversa` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_traslado_reserva`,`id_old_rese`,`id_new_rese`,`id_pro_tras_rese`,`id_lote_tras_rese`),
  KEY `idx_inv_dettrasres_enc` (`id_traslado_reserva`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_dev_inventario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_dev_inventario` (
  `id_dev_inventario` bigint NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `usuario_autoriza` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_devuelve` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_bodega` int NOT NULL,
  `id_em` int NOT NULL DEFAULT '0',
  `id_proyecto` int NOT NULL DEFAULT '0',
  `id_movil` int NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_dev_inventario`),
  KEY `idx_inv_dev_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_entrada_inventario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_entrada_inventario` (
  `id_enc_entrada_inv` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_solicitud_mat` int NOT NULL,
  `recibe_bodega` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `num_comprobante` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_enc_entrada_inv`),
  KEY `idx_inv_entrada_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_inventarios
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_inventarios` (
  `id_enc_inventario` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_bodega` int NOT NULL,
  `id_movil` int NOT NULL DEFAULT '0',
  `id_usuario_movil` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_usuario_inventario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `id_usuario_bodega` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `observaciones` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_inventario` tinyint(1) NOT NULL DEFAULT '0',
  `estado_conciliacion` tinyint(1) NOT NULL DEFAULT '0',
  `id_usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_inventario` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_enc_inventario`),
  KEY `idx_inv_enc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_orden_compra
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_orden_compra` (
  `id_enc_orden_compra` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fecha_hora_oc` datetime NOT NULL,
  `id_bodega` int NOT NULL,
  `id_proveedor` int NOT NULL,
  `condi_comercial` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sitio_entrega` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_oc` tinyint(1) NOT NULL,
  PRIMARY KEY (`id_enc_orden_compra`),
  KEY `idx_inv_oc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_salida_proveedor
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_salida_proveedor` (
  `id_enc_salida_prov` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_bodega` int NOT NULL,
  `cedula_autoriza` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `autoriza_cliente` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_sucursal` int NOT NULL,
  `nombre_recibe` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_enc_salida_prov`),
  KEY `idx_inv_salprov_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_solicitud_mat
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_solicitud_mat` (
  `id_solicitud_mat` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_sucursal` int NOT NULL,
  `id_almacen` int NOT NULL,
  `observaciones` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_enc_solic_mat` tinyint(1) NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_solicitud_mat`),
  KEY `idx_inv_solic_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_tranfer_em
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_tranfer_em` (
  `id_sal_mat_consumo` bigint NOT NULL,
  `id_empresa` int NOT NULL,
  `obs_sal_consum` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_em` int NOT NULL,
  `id_proyecto` int NOT NULL,
  `estado` enum('PENDIENTE','ACEPTADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sal_mat_consumo`),
  KEY `idx_inv_tranfer_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_traslado_moviles
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_traslado_moviles` (
  `id_traslado_movil` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_bodega` int NOT NULL,
  `id_movil_entrega` int NOT NULL,
  `id_usuario_entrega` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_movil_recibe` int NOT NULL,
  `id_usuario_recibe` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_enc_tras_moviles` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cedula_aprobado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_traslado_movil`),
  KEY `idx_inv_trasmov_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_enc_traslado_reservas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_enc_traslado_reservas` (
  `id_traslado_reserva` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_bodega` int NOT NULL,
  `id_reserva_origen` int NOT NULL,
  `id_reserva_destino` int NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_traslado_reserva`),
  KEY `idx_inv_trasres_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_has_articulo_almacen
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_has_articulo_almacen` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_articulo` int NOT NULL,
  `id_almacen` int NOT NULL,
  `serial_si_no` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_inv_has_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_inventario_vehiculo
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_inventario_vehiculo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_producto` int NOT NULL,
  `cantidad` float(20,2) NOT NULL DEFAULT '0.00',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_inv_invveh_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_serial_ejecutor_m
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_serial_ejecutor_m` (
  `id_empleado` int NOT NULL,
  `id_proyecto` int NOT NULL DEFAULT '0',
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_tipo_reserva` int NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `val_unitario` float(20,2) NOT NULL DEFAULT '0.00',
  `iva` float(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_empleado`,`id_proyecto`,`id_producto`,`id_lote`,`id_tipo_reserva`,`serial`),
  KEY `idx_inv_serial_em_empleado` (`id_empleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_serial_entrada_inventario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_serial_entrada_inventario` (
  `id_enc_entrada_inv` int NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_reserva` int NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `val_unitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `fecha_fabricacion` date NOT NULL,
  PRIMARY KEY (`id_enc_entrada_inv`,`id_producto`,`serial`),
  KEY `idx_inv_ser_ent_enc` (`id_enc_entrada_inv`),
  KEY `idx_inv_ser_ent_producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Seriales registrados en entrada a almacén (proveedor); origen: serialEntradaInventario';

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_serial_instalar
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_serial_instalar` (
  `id_empresa` int NOT NULL,
  `id_producto` int NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_bodega` int NOT NULL,
  `id_lote_serial` int NOT NULL COMMENT 'referencia categoría',
  `id_tipo_reserva` int NOT NULL COMMENT 'referencia propósito',
  `val_unitario` float(20,2) NOT NULL,
  `mm_actual` float(7,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `km_presuntivo` bigint NOT NULL,
  `km_total` bigint NOT NULL,
  `placa_veh_seri` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 si no está asignado',
  `id_ejecutor_m` int NOT NULL DEFAULT '0',
  `id_proy` int NOT NULL DEFAULT '0',
  `id_posicion` int NOT NULL DEFAULT '0' COMMENT '0 si no está asignado',
  `fecha_fabricacion` date NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_id_estado_llanta` bigint DEFAULT NULL COMMENT 'FK estados llanta (03)',
  `serial_original` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ciclo_reencauche` enum('NUEVA','R1','R2','R3') COLLATE utf8mb4_unicode_ci DEFAULT 'NUEVA',
  `id_reencauchadora` int DEFAULT NULL,
  PRIMARY KEY (`id_empresa`,`id_producto`,`serial`),
  KEY `idx_inv_serial_empresa` (`id_empresa`),
  KEY `idx_inv_serial_placa` (`placa_veh_seri`),
  KEY `idx_inv_serial_producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Serial instalado en vehículo (TireCheck); origen: serialInstalar';

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_serial_sal_proveedor
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_serial_sal_proveedor` (
  `id_enc_salida_prov` int NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_reserva` int NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `val_unitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  PRIMARY KEY (`id_enc_salida_prov`,`id_producto`,`serial`),
  KEY `idx_inv_ser_sal_enc` (`id_enc_salida_prov`),
  KEY `idx_inv_ser_sal_producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Seriales registrados en salida a proveedor; origen: serialSalProveedor';

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_serial_tranfer_em
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_serial_tranfer_em` (
  `id_enc_tranfer` int NOT NULL COMMENT 'FK inv_enc_tranfer_em.id_sal_mat_consumo',
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_tipo_reserva` int NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `val_unitario` float(20,2) NOT NULL DEFAULT '0.00',
  `iva` float(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_enc_tranfer`,`id_producto`,`id_lote`,`id_tipo_reserva`,`serial`),
  KEY `idx_inv_ser_tras_em_enc` (`id_enc_tranfer`),
  KEY `idx_inv_ser_tras_em_producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Seriales entregados en requisición EM; origen: serialTranferEm';

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_serial_tranfer_reserva
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_serial_tranfer_reserva` (
  `id_traslado_reserva` int NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_old_reserva` int NOT NULL,
  `id_new_reserva` int NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `val_unitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  PRIMARY KEY (`id_traslado_reserva`,`id_producto`,`serial`),
  KEY `idx_inv_ser_tras_res_enc` (`id_traslado_reserva`),
  KEY `idx_inv_ser_tras_res_producto` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Seriales registrados en traslado entre reservas; origen: serialTranferReserva';

-- -----------------------------------------------------------------------------
-- bd_inventario.inv_serial_tranfer_return
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inv_serial_tranfer_return` (
  `id_dev_inventario` bigint NOT NULL,
  `id_producto` int NOT NULL,
  `id_lote` int NOT NULL,
  `id_tipo_reserva` int NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `val_unitario` float(20,2) NOT NULL DEFAULT '0.00',
  `iva` float(20,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id_dev_inventario`,`id_producto`,`id_lote`,`id_tipo_reserva`,`serial`),
  KEY `idx_inv_serial_return_dev` (`id_dev_inventario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.migrations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_inventario.prov_det_evaluacion_proveedor
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prov_det_evaluacion_proveedor` (
  `id_enc_evaluacion` int NOT NULL,
  `id_criterio` int NOT NULL COMMENT 'cat_criterio_evaluacion_em.id',
  `calificacion` float(5,2) NOT NULL,
  PRIMARY KEY (`id_enc_evaluacion`,`id_criterio`),
  KEY `idx_prov_det_enc` (`id_enc_evaluacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detalle evaluación por criterio';

-- -----------------------------------------------------------------------------
-- bd_inventario.prov_evaluacion_proveedor_enc
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prov_evaluacion_proveedor_enc` (
  `id_enc_evaluacion` int NOT NULL,
  `id_empresa` int NOT NULL,
  `id_proveedor` int NOT NULL,
  `id_sucursal` int DEFAULT NULL,
  `fecha_evaluacion` date NOT NULL,
  `ciclo` int DEFAULT NULL,
  `id_criticidad` int DEFAULT NULL,
  `fecha_reevaluacion` date DEFAULT NULL,
  `calificacion_final` float(5,2) NOT NULL,
  `estado_calificacion` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_enc_evaluacion`),
  KEY `idx_prov_eval_empresa` (`id_empresa`),
  KEY `idx_prov_eval_proveedor` (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Encabezado evaluación de proveedores';

-- -----------------------------------------------------------------------------
-- bd_inventario.prov_proveedor
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prov_proveedor` (
  `id_prov` int NOT NULL,
  `id_empresa` int NOT NULL,
  `nombre_prov` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_doc_prov` int NOT NULL,
  `celular_prov` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_prov` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_prov` tinyint NOT NULL DEFAULT '1',
  `tipo_doc_id` int NOT NULL,
  `tipo_cliente_prov` enum('PROVEEDOR','CLIENTE','EM') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PROVEEDOR',
  `tipo_provee` enum('BIENES','SERVICIOS') COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_regimen` int NOT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_prov`,`id_empresa`),
  KEY `idx_prov_empresa` (`id_empresa`),
  KEY `idx_prov_estado` (`estado_prov`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Proveedores (dominio inventario)';

-- -----------------------------------------------------------------------------
-- bd_inventario.prov_sucursales_prov
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prov_sucursales_prov` (
  `id_sucursal` int NOT NULL,
  `id_empresa` int NOT NULL,
  `id_prov_sucursal` int NOT NULL COMMENT 'prov_proveedor.id_prov',
  `id_ciudad` int NOT NULL,
  `direccion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_contacto_sucursal` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono_contacto_sucursal` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_sucursal` tinyint(1) NOT NULL DEFAULT '1',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id_sucursal`,`id_empresa`),
  KEY `idx_prov_suc_empresa` (`id_empresa`),
  KEY `idx_prov_suc_proveedor` (`id_prov_sucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sucursales de proveedores';

SET FOREIGN_KEY_CHECKS = 1;
