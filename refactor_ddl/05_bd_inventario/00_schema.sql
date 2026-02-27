-- =============================================================================
-- bd_inventario - Esquema normalizado
-- Almacenes, movimientos, traslados, solicitudes, devoluciones. id_empresa en tablas.
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `inv_almacen_inventario` (
  `id_producto` INT(11) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `id_almacen` INT(2) NOT NULL,
  `id_lote` INT(2) NOT NULL,
  `id_tipo_reserva` INT(2) NOT NULL,
  `cantidad` FLOAT(20,2) NOT NULL,
  `val_unitario` FLOAT(20,2) NOT NULL,
  `iva` FLOAT(20,2) NOT NULL,
  PRIMARY KEY (`id_producto`, `id_empresa`, `id_almacen`, `id_lote`, `id_tipo_reserva`),
  KEY `idx_inv_alm_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_inventarios` (
  `id_enc_inventario` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_bodega` INT(11) NOT NULL,
  `id_movil` INT(11) NOT NULL DEFAULT 0,
  `id_usuario_movil` VARCHAR(50) NOT NULL,
  `id_usuario_inventario` VARCHAR(50) NOT NULL DEFAULT '0',
  `id_usuario_bodega` VARCHAR(50) NOT NULL DEFAULT '0',
  `observaciones` VARCHAR(500) NOT NULL,
  `estado_inventario` TINYINT(1) NOT NULL DEFAULT 0,
  `estado_conciliacion` TINYINT(1) NOT NULL DEFAULT 0,
  `id_usuario_control` VARCHAR(50) NOT NULL,
  `fecha_inventario` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_enc_inventario`),
  KEY `idx_inv_enc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_det_inventarios` (
  `id_inventario` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `id_lote` INT(2) NOT NULL,
  `id_reserva` INT(2) NOT NULL,
  `cantidad_sistema` INT(11) NOT NULL,
  `cantidad_inventario` INT(11) NOT NULL,
  `cantidad_devuelta` INT(11) NOT NULL,
  `cantidad_recibida` INT(11) NOT NULL,
  `observacion_detalle` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id_inventario`, `id_producto`, `id_lote`, `id_reserva`),
  KEY `idx_inv_det_enc` (`id_inventario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_entrada_inventario` (
  `id_enc_entrada_inv` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_solicitud_mat` INT(11) NOT NULL,
  `recibe_bodega` VARCHAR(50) NOT NULL,
  `num_comprobante` VARCHAR(150) NOT NULL,
  `observaciones` VARCHAR(500) DEFAULT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_enc_entrada_inv`),
  KEY `idx_inv_entrada_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_det_entrada_inv` (
  `id_enc_entrada_inv` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `id_lote` INT(2) NOT NULL,
  `id_reserva` INT(2) NOT NULL,
  `cantidad` FLOAT(20,2) NOT NULL,
  `val_unitario` FLOAT(20,2) NOT NULL,
  `iva` FLOAT(20,2) NOT NULL,
  PRIMARY KEY (`id_enc_entrada_inv`, `id_producto`, `id_lote`, `id_reserva`),
  KEY `idx_inv_detent_enc` (`id_enc_entrada_inv`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_solicitud_mat` (
  `id_solicitud_mat` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_sucursal` INT(11) NOT NULL,
  `id_almacen` INT(11) NOT NULL,
  `observaciones` VARCHAR(500) DEFAULT NULL,
  `estado_enc_solic_mat` TINYINT(1) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_solicitud_mat`),
  KEY `idx_inv_solic_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_det_solicitud_mat` (
  `id_det_solicitud` INT(11) NOT NULL,
  `id_solicitud_mat` INT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `cantidad` FLOAT(20,2) NOT NULL,
  `obs_solicitud` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY (`id_det_solicitud`, `id_solicitud_mat`),
  KEY `idx_inv_detsolic_enc` (`id_solicitud_mat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_dev_inventario` (
  `id_dev_inventario` BIGINT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `usuario_autoriza` VARCHAR(50) NOT NULL,
  `usuario_devuelve` VARCHAR(50) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `observacion` VARCHAR(128) DEFAULT NULL,
  `id_bodega` INT(2) NOT NULL,
  `id_movil` INT(5) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_dev_inventario`),
  KEY `idx_inv_dev_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_det_dev_inventario` (
  `id_dev_inventario` BIGINT(11) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `id_lote` INT(2) NOT NULL,
  `id_reserva` INT(2) NOT NULL,
  `cantidad_ent_cons` FLOAT(20,2) NOT NULL,
  `observacion` VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (`id_dev_inventario`, `id_producto`, `id_lote`, `id_reserva`),
  KEY `idx_inv_detdev_enc` (`id_dev_inventario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_tranfer_em` (
  `id_sal_mat_consumo` BIGINT(12) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `obs_sal_consum` VARCHAR(1000) DEFAULT NULL,
  `id_em` INT(11) NOT NULL,
  `id_proyecto` INT(11) NOT NULL,
  `estado` ENUM('PENDIENTE','ACEPTADO') NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_sal_mat_consumo`),
  KEY `idx_inv_tranfer_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_det_tranfer_em` (
  `id_salida_material` BIGINT(12) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `id_lote` INT(2) NOT NULL,
  `id_reserva` INT(2) NOT NULL,
  `cantidad_ent_cons` FLOAT(20,2) NOT NULL,
  `val_unitario` FLOAT(20,2) NOT NULL,
  `iva` FLOAT(20,2) NOT NULL,
  `observacion_salida` VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (`id_salida_material`, `id_producto`, `id_lote`, `id_reserva`),
  KEY `idx_inv_dettran_enc` (`id_salida_material`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_traslado_moviles` (
  `id_traslado_movil` INT(9) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_bodega` INT(2) NOT NULL,
  `id_movil_entrega` INT(11) NOT NULL,
  `id_usuario_entrega` VARCHAR(50) NOT NULL,
  `id_movil_recibe` INT(11) NOT NULL,
  `id_usuario_recibe` VARCHAR(50) DEFAULT NULL,
  `observaciones` VARCHAR(1000) DEFAULT NULL,
  `estado_enc_tras_moviles` VARCHAR(1) NOT NULL,
  `cedula_aprobado` VARCHAR(50) DEFAULT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_traslado_movil`),
  KEY `idx_inv_trasmov_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_det_traslado_moviles` (
  `id_traslado_movil` INT(9) NOT NULL,
  `id_reserva` INT(2) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `id_lote_traslado` INT(2) NOT NULL,
  `cantidad_trasladar` FLOAT(20,2) NOT NULL,
  `obs_traslado` VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (`id_traslado_movil`, `id_reserva`, `id_producto`, `id_lote_traslado`),
  KEY `idx_inv_dettras_enc` (`id_traslado_movil`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_traslado_reservas` (
  `id_traslado_reserva` INT(8) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_bodega` INT(2) NOT NULL,
  `id_reserva_origen` INT(2) NOT NULL,
  `id_reserva_destino` INT(2) NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_traslado_reserva`),
  KEY `idx_inv_trasres_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_det_traslado_reservas` (
  `id_traslado_reserva` INT(8) NOT NULL,
  `id_old_rese` INT(11) NOT NULL,
  `id_new_rese` INT(11) NOT NULL,
  `id_pro_tras_rese` INT(11) NOT NULL,
  `id_lote_tras_rese` INT(2) NOT NULL,
  `cant_tras_reserva` FLOAT(20,2) NOT NULL,
  `val_unitario` FLOAT(20,2) NOT NULL,
  `iva` FLOAT(20,2) NOT NULL,
  `obs_tras_reversa` VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY (`id_traslado_reserva`, `id_old_rese`, `id_new_rese`, `id_pro_tras_rese`, `id_lote_tras_rese`),
  KEY `idx_inv_dettrasres_enc` (`id_traslado_reserva`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_salida_proveedor` (
  `id_enc_salida_prov` INT(5) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_bodega` INT(11) NOT NULL,
  `cedula_autoriza` VARCHAR(50) NOT NULL,
  `autoriza_cliente` VARCHAR(150) NOT NULL,
  `id_sucursal` INT(11) NOT NULL,
  `nombre_recibe` VARCHAR(150) DEFAULT NULL,
  `observacion` VARCHAR(500) DEFAULT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_enc_salida_prov`),
  KEY `idx_inv_salprov_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_det_salida_proveedor` (
  `id_enc_salida_prov` INT(5) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `id_lote_salida` INT(2) NOT NULL,
  `id_reserva_almacen` INT(2) NOT NULL,
  `cantidad_salida` FLOAT(20,2) NOT NULL,
  `val_unitario` FLOAT(20,2) NOT NULL,
  `iva` FLOAT(20,2) NOT NULL,
  `obs_salida_prove` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY (`id_enc_salida_prov`, `id_producto`, `id_lote_salida`, `id_reserva_almacen`),
  KEY `idx_inv_detsalprov_enc` (`id_enc_salida_prov`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_enc_orden_compra` (
  `id_enc_orden_compra` INT(6) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fecha_hora_oc` DATETIME NOT NULL,
  `id_bodega` INT(11) NOT NULL,
  `id_proveedor` INT(20) NOT NULL,
  `condi_comercial` VARCHAR(1000) NOT NULL,
  `sitio_entrega` VARCHAR(1000) NOT NULL,
  `observaciones` VARCHAR(1000) DEFAULT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_oc` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id_enc_orden_compra`),
  KEY `idx_inv_oc_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_inventario_vehiculo` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `placa` VARCHAR(10) NOT NULL,
  `id_producto` INT(11) NOT NULL,
  `cantidad` FLOAT(20,2) NOT NULL DEFAULT 0,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_inv_invveh_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inv_has_articulo_almacen` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_articulo` INT(11) NOT NULL,
  `id_almacen` INT(1) NOT NULL,
  `serial_si_no` ENUM('SI','NO') NOT NULL,
  `estado` ENUM('ACTIVO','INACTIVO') NOT NULL,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_inv_has_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Proveedores (dominio inventario/compras; id_empresa = tenant)
-- Referencia: inv_enc_orden_compra.id_proveedor -> prov_proveedor.id_prov
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `prov_proveedor` (
  `id_prov` INT(20) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `nombre_prov` VARCHAR(50) NOT NULL,
  `numero_doc_prov` INT(20) NOT NULL,
  `celular_prov` VARCHAR(15) NOT NULL,
  `email_prov` VARCHAR(200) DEFAULT NULL,
  `estado_prov` TINYINT(2) NOT NULL DEFAULT 1,
  `tipo_doc_id` INT(20) NOT NULL,
  `tipo_cliente_prov` ENUM('PROVEEDOR','CLIENTE','EM') NOT NULL DEFAULT 'PROVEEDOR',
  `tipo_provee` ENUM('BIENES','SERVICIOS') NOT NULL,
  `id_regimen` INT(11) NOT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_prov`, `id_empresa`),
  KEY `idx_prov_empresa` (`id_empresa`),
  KEY `idx_prov_estado` (`estado_prov`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Proveedores (dominio inventario)';

CREATE TABLE IF NOT EXISTS `prov_sucursales_prov` (
  `id_sucursal` INT(11) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `id_prov_sucursal` INT(20) NOT NULL COMMENT 'prov_proveedor.id_prov',
  `id_ciudad` INT(11) NOT NULL,
  `direccion` VARCHAR(500) NOT NULL,
  `nombre_contacto_sucursal` VARCHAR(100) NOT NULL,
  `telefono_contacto_sucursal` VARCHAR(15) NOT NULL,
  `estado_sucursal` TINYINT(1) NOT NULL DEFAULT 1,
  `usuario_control` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id_sucursal`, `id_empresa`),
  KEY `idx_prov_suc_empresa` (`id_empresa`),
  KEY `idx_prov_suc_proveedor` (`id_prov_sucursal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Sucursales de proveedores';

CREATE TABLE IF NOT EXISTS `prov_evaluacion_proveedor_enc` (
  `id_enc_evaluacion` INT(11) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `id_proveedor` INT(20) NOT NULL,
  `fecha_evaluacion` DATE NOT NULL,
  `calificacion_final` FLOAT(5,2) NOT NULL,
  `observaciones` VARCHAR(1000) DEFAULT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id_enc_evaluacion`),
  KEY `idx_prov_eval_empresa` (`id_empresa`),
  KEY `idx_prov_eval_proveedor` (`id_proveedor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Encabezado evaluación de proveedores';

CREATE TABLE IF NOT EXISTS `prov_det_evaluacion_proveedor` (
  `id_enc_evaluacion` INT(11) NOT NULL,
  `id_criterio` INT(11) NOT NULL COMMENT 'cat_criterio_evaluacion_em.id',
  `calificacion` FLOAT(5,2) NOT NULL,
  PRIMARY KEY (`id_enc_evaluacion`, `id_criterio`),
  KEY `idx_prov_det_enc` (`id_enc_evaluacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Detalle evaluación por criterio';

SET FOREIGN_KEY_CHECKS = 1;
