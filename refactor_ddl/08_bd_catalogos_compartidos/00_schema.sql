-- =============================================================================
-- bd_catalogos_compartidos — esquema sincronizado desde RDS (bastión) 2026-09-29
-- Fuente: SHOW CREATE TABLE sobre qinspecting-prod vía túnel bastión.
-- Incluye todas las tablas base presentes en el bastión (excepto se omiten vistas).
-- Charset: utf8mb4 / utf8mb4_unicode_ci (según definición real de cada tabla).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_acciones_sistema_usuario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_acciones_sistema_usuario` (
  `id_accion` int NOT NULL,
  `acciones` json NOT NULL,
  PRIMARY KEY (`id_accion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Acciones/permisos del sistema por rol o usuario';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_calificacion_em
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_calificacion_em` (
  `id` int NOT NULL,
  `valor_minimo` int NOT NULL,
  `valor_maximo` int NOT NULL,
  `adjetivo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mostrar` smallint NOT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Calificaciones para evaluación de ejecutores de mantenimiento';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_categoria_items
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_categoria_items` (
  `id_categoria_item` int NOT NULL,
  `nombre_categoria_item` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_categoria_item`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Categorías de ítems (inspección/inventario)';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_categoria_licencias
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_categoria_licencias` (
  `id_categoria_licencia` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_cat_licencia` varchar(800) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_cat_licencia` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_categoria_licencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Categorías de licencias de conducción';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_cedulas_autoriza_almacen
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_cedulas_autoriza_almacen` (
  `id_autoriza` int NOT NULL,
  `cc_usuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Referencia a per_personal.numero_documento',
  `id_almacen` int NOT NULL COMMENT 'Referencia lógica a man_bodegas',
  `estado_autoriza` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_autoriza`),
  KEY `idx_cat_ced_cc` (`cc_usuario`),
  KEY `idx_cat_ced_almacen` (`id_almacen`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cédulas autorizadas por almacén';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_criterio_evaluacion_em
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_criterio_evaluacion_em` (
  `id` int NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `peso` int NOT NULL,
  `tipo_mostrar` smallint NOT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Criterios de evaluación EM (proveedores/ejecutores)';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_criticidad_em
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_criticidad_em` (
  `id` int NOT NULL,
  `adjetivo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mostrar` smallint NOT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Niveles de criticidad EM';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_cursos_certificados
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_cursos_certificados` (
  `id_curso` int NOT NULL,
  `curso` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `empresa` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `horas` int NOT NULL,
  `estado_certificado` tinyint(1) NOT NULL DEFAULT '1',
  `certificado` tinyint(1) NOT NULL DEFAULT '1',
  `formato_fondo` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_curso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Maestra de cursos certificados (capacitación)';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_especialidades_em
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_especialidades_em` (
  `id` int NOT NULL,
  `descripcion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mostrar` smallint NOT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Especialidades de ejecutores de mantenimiento';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_hash_tipo_vehiculo_css
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_hash_tipo_vehiculo_css` (
  `id_tipo_vehiculo` int NOT NULL,
  `id_ubicacion` int NOT NULL,
  `id_css` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_tipo_vehiculo`,`id_ubicacion`),
  KEY `idx_cat_hash_tipo_veh` (`id_tipo_vehiculo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Hash CSS por tipo de vehículo y ubicación (frontend)';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_lote
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_lote` (
  `id_lote` int NOT NULL,
  `nombre_lote` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_lote` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lotes de inventario';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_maestra_venc_docs
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_maestra_venc_docs` (
  `id_documento` int NOT NULL,
  `nombre_documento` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_id_cat_documento` tinyint(1) NOT NULL COMMENT '1=vehiculo, 2=remolque, 3=conductor',
  `vencimiento` tinyint(1) NOT NULL,
  `estado_mvd` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Maestra de documentos con vencimiento (flota/conductor)';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_tipo_adjuntos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_tipo_adjuntos` (
  `id_tipo_adjunto` int NOT NULL,
  `tipo_adjunto` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_tipo_adjunto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tipos de adjuntos (capacitación, inspección)';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.cat_tipo_reserva
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_tipo_reserva` (
  `id_reserva` int NOT NULL,
  `nombre_reserva` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_reserva` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_reserva`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tipos de reserva en inventario';

-- -----------------------------------------------------------------------------
-- bd_catalogos_compartidos.migrations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
