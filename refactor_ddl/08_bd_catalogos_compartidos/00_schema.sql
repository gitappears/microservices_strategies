-- =============================================================================
-- bd_catalogos_compartidos - Catálogos compartidos entre dominios
-- Origen: maestras/catálogos legacy (categoriaItems, tipoReserva, lote, etc.)
-- Sin id_empresa: compartidos. Sin FK a otras bases (personal, mantenimiento).
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- cat_categoria_items (origen: categoriaItems)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_categoria_items` (
  `id_categoria_item` INT(11) NOT NULL,
  `nombre_categoria_item` VARCHAR(100) NOT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_categoria_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Categorías de ítems (inspección/inventario)';

-- -----------------------------------------------------------------------------
-- cat_categoria_licencias (origen: categoriaLicencias)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_categoria_licencias` (
  `id_categoria_licencia` VARCHAR(4) NOT NULL,
  `nombre_cat_licencia` VARCHAR(800) NOT NULL,
  `estado_cat_licencia` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_categoria_licencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Categorías de licencias de conducción';

-- -----------------------------------------------------------------------------
-- cat_calificacion_em (origen: calificacionEm)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_calificacion_em` (
  `id` INT(11) NOT NULL,
  `valor_minimo` INT(3) NOT NULL,
  `valor_maximo` INT(3) NOT NULL,
  `adjetivo` VARCHAR(50) NOT NULL,
  `tipo_mostrar` SMALLINT(1) NOT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Calificaciones para evaluación de ejecutores de mantenimiento';

-- -----------------------------------------------------------------------------
-- cat_criterio_evaluacion_em (origen: criterioEvaluacionEm)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_criterio_evaluacion_em` (
  `id` INT(11) NOT NULL,
  `nombre` VARCHAR(50) NOT NULL,
  `peso` INT(3) NOT NULL,
  `tipo_mostrar` SMALLINT(1) NOT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Criterios de evaluación EM (proveedores/ejecutores)';

-- -----------------------------------------------------------------------------
-- cat_criticidad_em (origen: criticidadEm)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_criticidad_em` (
  `id` INT(11) NOT NULL,
  `adjetivo` VARCHAR(50) NOT NULL,
  `observacion` VARCHAR(500) NOT NULL,
  `tipo_mostrar` SMALLINT(1) NOT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Niveles de criticidad EM';

-- -----------------------------------------------------------------------------
-- cat_cursos_certificados (origen: cursosCertificados - maestra de cursos)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_cursos_certificados` (
  `id_curso` INT(11) NOT NULL,
  `curso` VARCHAR(500) NOT NULL,
  `empresa` VARCHAR(200) NOT NULL,
  `horas` INT(3) NOT NULL,
  `estado_certificado` TINYINT(1) NOT NULL DEFAULT 1,
  `certificado` TINYINT(1) NOT NULL DEFAULT 1,
  `formato_fondo` VARCHAR(60) DEFAULT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_curso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Maestra de cursos certificados (capacitación)';

-- -----------------------------------------------------------------------------
-- cat_tipo_reserva (origen: tipoReserva)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_tipo_reserva` (
  `id_reserva` INT(11) NOT NULL,
  `nombre_reserva` VARCHAR(64) NOT NULL,
  `estado_reserva` ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_reserva`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Tipos de reserva en inventario';

-- -----------------------------------------------------------------------------
-- cat_lote (origen: lote)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_lote` (
  `id_lote` INT(2) NOT NULL,
  `nombre_lote` VARCHAR(24) NOT NULL,
  `estado_lote` ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Lotes de inventario';

-- -----------------------------------------------------------------------------
-- cat_maestra_venc_docs (origen: maestraVencDocs)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_maestra_venc_docs` (
  `id_documento` INT(11) NOT NULL,
  `nombre_documento` VARCHAR(250) NOT NULL,
  `fk_id_cat_documento` TINYINT(1) NOT NULL COMMENT '1=vehiculo, 2=remolque, 3=conductor',
  `vencimiento` TINYINT(1) NOT NULL,
  `estado_mvd` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Maestra de documentos con vencimiento (flota/conductor)';

-- -----------------------------------------------------------------------------
-- cat_tipo_adjuntos (origen: tipoAdjuntos)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_tipo_adjuntos` (
  `id_tipo_adjunto` INT(25) NOT NULL,
  `tipo_adjunto` VARCHAR(45) DEFAULT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_tipo_adjunto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Tipos de adjuntos (capacitación, inspección)';

-- -----------------------------------------------------------------------------
-- cat_acciones_sistema_usuario (origen: accionesSistemaUsuario)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_acciones_sistema_usuario` (
  `id_accion` INT(20) NOT NULL,
  `acciones` JSON NOT NULL,
  PRIMARY KEY (`id_accion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Acciones/permisos del sistema por rol o usuario';

-- -----------------------------------------------------------------------------
-- cat_cedulas_autoriza_almacen (origen: cedulasAutorizaAlmacen)
-- id_almacen referencia lógica a man_bodegas (otra base), sin FK
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_cedulas_autoriza_almacen` (
  `id_autoriza` INT(11) NOT NULL,
  `cc_usuario` VARCHAR(50) NOT NULL COMMENT 'Referencia a per_personal.numero_documento',
  `id_almacen` INT(11) NOT NULL COMMENT 'Referencia lógica a man_bodegas',
  `estado_autoriza` ENUM('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_autoriza`),
  KEY `idx_cat_ced_cc` (`cc_usuario`),
  KEY `idx_cat_ced_almacen` (`id_almacen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Cédulas autorizadas por almacén';

-- -----------------------------------------------------------------------------
-- cat_especialidades_em (origen: especialidadesEm)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_especialidades_em` (
  `id` INT(11) NOT NULL,
  `descripcion` VARCHAR(100) NOT NULL,
  `tipo_mostrar` SMALLINT(1) NOT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Especialidades de ejecutores de mantenimiento';

-- -----------------------------------------------------------------------------
-- cat_hash_tipo_vehiculo_css (origen: hashTipoVehiculoCss)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_hash_tipo_vehiculo_css` (
  `id_tipo_vehiculo` INT(11) NOT NULL,
  `id_ubicacion` INT(11) NOT NULL,
  `id_css` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_tipo_vehiculo`, `id_ubicacion`),
  KEY `idx_cat_hash_tipo_veh` (`id_tipo_vehiculo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Hash CSS por tipo de vehículo y ubicación (frontend)';

SET FOREIGN_KEY_CHECKS = 1;
