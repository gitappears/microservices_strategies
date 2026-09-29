-- =============================================================================
-- bd_tenancy_planes — esquema sincronizado desde RDS (bastión) 2026-09-29
-- Fuente: SHOW CREATE TABLE sobre qinspecting-prod vía túnel bastión.
-- Incluye todas las tablas base presentes en el bastión (excepto se omiten vistas).
-- Charset: utf8mb4 / utf8mb4_unicode_ci (según definición real de cada tabla).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.migrations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_empleados_qi
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_empleados_qi` (
  `cedula` int NOT NULL,
  `primer_nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `segundo_nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `primer_apellido` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `segundo_apellido` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cargo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_corporativo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email_personal` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion_cargo` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `celular` bigint NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `rh` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_contrato` tinyint(1) NOT NULL,
  `fecha_expedicion` date NOT NULL,
  `fecha_vigencia` date NOT NULL,
  `departamento_area` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cedula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Empleados de QInspecting. Origen: planesQi.Empleados';

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_empresa_capacidades
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_empresa_capacidades` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `codigo_capacidad` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ej: reporte_llantas_avanzado, alertas_mtto_custom',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_desde` date DEFAULT NULL,
  `fecha_hasta` date DEFAULT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ten_ec_empresa_codigo` (`id_empresa`,`codigo_capacidad`),
  KEY `idx_ten_ec_activo` (`activo`),
  CONSTRAINT `fk_ten_ec_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `ten_empresas` (`id_empresa`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Capacidades/features habilitados por empresa';

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_empresas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_empresas` (
  `id_empresa` int NOT NULL AUTO_INCREMENT,
  `razon_social` varchar(450) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nit` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `digito_verificacion` tinyint(1) NOT NULL DEFAULT '0',
  `direccion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre_qi` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre mostrado en QI',
  `url_qi` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ruta_logo` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `descripcion_logo` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `base_legacy` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre base por empresa (legacy) para migración',
  `estado` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_empresa`),
  UNIQUE KEY `uk_ten_empresas_base_legacy` (`base_legacy`),
  KEY `idx_ten_empresas_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Empresas (tenants). Origen: qinspect_planesQi.Empresas';

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_mensajes
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_mensajes` (
  `id_mensaje` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mensaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Origen: planesQi.mensajes';

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_plan_capacidades
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_plan_capacidades` (
  `id_plan` int NOT NULL,
  `codigo_capacidad` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'platform_develop | platform_mantenimiento | modulo_capacitaciones_empresa',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_plan`,`codigo_capacidad`),
  CONSTRAINT `fk_ten_pc_plan` FOREIGN KEY (`id_plan`) REFERENCES `ten_planes` (`id_plan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Capacidades/plataformas habilitadas por plan';

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_planes
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_planes` (
  `id_plan` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(450) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vh_desde` int NOT NULL COMMENT 'Vehículos desde',
  `vh_hasta` int NOT NULL COMMENT 'Vehículos hasta',
  `precio` int NOT NULL,
  `max_inspecciones` int NOT NULL,
  `max_capacitaciones` int NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_plan`),
  KEY `idx_ten_planes_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de planes. Origen: planesQi.planes';

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_planes_empresas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_planes_empresas` (
  `id_llave` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `id_plan` int NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_facturacion` date NOT NULL,
  `vigente_hasta` date DEFAULT NULL COMMENT 'Hasta cuándo tiene servicio por pago',
  `estado_pago` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=al día, 2=vencido, 3=suspendido, 4=cancelado',
  `estado` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Estado general del registro',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_llave`),
  KEY `idx_ten_pe_empresa` (`id_empresa`),
  KEY `idx_ten_pe_plan` (`id_plan`),
  KEY `idx_ten_pe_estado_pago` (`estado_pago`),
  KEY `idx_ten_pe_vigente_hasta` (`vigente_hasta`),
  CONSTRAINT `fk_ten_pe_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `ten_empresas` (`id_empresa`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ten_pe_plan` FOREIGN KEY (`id_plan`) REFERENCES `ten_planes` (`id_plan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Suscripción empresa-plan. Origen: Planes_empresas + estado_pago/vigente_hasta';

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_regimen_tributario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_regimen_tributario` (
  `id` int NOT NULL,
  `descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mostrar` bigint NOT NULL DEFAULT '1',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ten_rt_usuario` (`usuario_control`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de regímenes tributarios';

-- -----------------------------------------------------------------------------
-- bd_tenancy_planes.ten_terminos_condiciones
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_terminos_condiciones` (
  `id_termino` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'firma-digital, registro, etc.',
  `titulo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contenido_json` longtext COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '{"intro":"...","sections":[...]}',
  `version` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1.0',
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_termino`),
  UNIQUE KEY `uk_ten_terminos_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Términos y condiciones versionados por código funcional';

SET FOREIGN_KEY_CHECKS = 1;
