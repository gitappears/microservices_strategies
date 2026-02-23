-- =============================================================================
-- bd_tenancy_planes - Esquema normalizado
-- Origen: qinspect_planesQi + extensiones para planes, estado de pago y capacidades
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- Empresas (tenant). Fuente: Empresas (planesQi) + datos operativos de empresa
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_empresas` (
  `id_empresa` INT(11) NOT NULL AUTO_INCREMENT,
  `razon_social` VARCHAR(450) NOT NULL,
  `nit` VARCHAR(30) NOT NULL,
  `digito_verificacion` TINYINT(1) NOT NULL DEFAULT 0,
  `direccion` VARCHAR(300) NOT NULL,
  `nombre_qi` VARCHAR(200) NOT NULL COMMENT 'Nombre mostrado en QI',
  `url_qi` VARCHAR(500) NOT NULL,
  `ruta_logo` VARCHAR(500) NOT NULL DEFAULT '',
  `descripcion_logo` VARCHAR(1000) DEFAULT NULL,
  `base_legacy` VARCHAR(100) NOT NULL COMMENT 'Nombre base por empresa (legacy) para migración',
  `estado` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=activo, 0=inactivo',
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_empresa`),
  UNIQUE KEY `uk_ten_empresas_base_legacy` (`base_legacy`),
  KEY `idx_ten_empresas_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Empresas (tenants). Origen: qinspect_planesQi.Empresas';

-- -----------------------------------------------------------------------------
-- Planes (catálogo de productos)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_planes` (
  `id_plan` INT(11) NOT NULL AUTO_INCREMENT,
  `descripcion` VARCHAR(450) NOT NULL,
  `vh_desde` INT(11) NOT NULL COMMENT 'Vehículos desde',
  `vh_hasta` INT(11) NOT NULL COMMENT 'Vehículos hasta',
  `precio` INT(11) NOT NULL,
  `max_inspecciones` INT(11) NOT NULL,
  `max_capacitaciones` INT(11) NOT NULL,
  `estado` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_plan`),
  KEY `idx_ten_planes_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Catálogo de planes. Origen: planesQi.planes';

-- -----------------------------------------------------------------------------
-- Planes por empresa (suscripción) + estado de pago y vigencia
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_planes_empresas` (
  `id_llave` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `id_plan` INT(11) NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_facturacion` DATE NOT NULL,
  `vigente_hasta` DATE DEFAULT NULL COMMENT 'Hasta cuándo tiene servicio por pago',
  `estado_pago` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=al día, 2=vencido, 3=suspendido, 4=cancelado',
  `estado` TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Estado general del registro',
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_llave`),
  KEY `idx_ten_pe_empresa` (`id_empresa`),
  KEY `idx_ten_pe_plan` (`id_plan`),
  KEY `idx_ten_pe_estado_pago` (`estado_pago`),
  KEY `idx_ten_pe_vigente_hasta` (`vigente_hasta`),
  CONSTRAINT `fk_ten_pe_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `ten_empresas` (`id_empresa`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ten_pe_plan` FOREIGN KEY (`id_plan`) REFERENCES `ten_planes` (`id_plan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Suscripción empresa-plan. Origen: Planes_empresas + estado_pago/vigente_hasta';

-- -----------------------------------------------------------------------------
-- Capacidades por empresa (para desarrollos personalizados y features por plan)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_empresa_capacidades` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `codigo_capacidad` VARCHAR(80) NOT NULL COMMENT 'ej: reporte_llantas_avanzado, alertas_mtto_custom',
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_desde` DATE DEFAULT NULL,
  `fecha_hasta` DATE DEFAULT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_ten_ec_empresa_codigo` (`id_empresa`, `codigo_capacidad`),
  KEY `idx_ten_ec_activo` (`activo`),
  CONSTRAINT `fk_ten_ec_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `ten_empresas` (`id_empresa`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Capacidades/features habilitados por empresa';

-- -----------------------------------------------------------------------------
-- Empleados QI (personal interno de QInspecting, no de clientes)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_empleados_qi` (
  `cedula` INT(11) NOT NULL,
  `primer_nombre` VARCHAR(50) NOT NULL,
  `segundo_nombre` VARCHAR(50) NOT NULL,
  `primer_apellido` VARCHAR(50) NOT NULL,
  `segundo_apellido` VARCHAR(50) NOT NULL,
  `cargo` VARCHAR(50) NOT NULL,
  `email_corporativo` VARCHAR(50) DEFAULT NULL,
  `email_personal` VARCHAR(50) DEFAULT NULL,
  `descripcion_cargo` VARCHAR(500) NOT NULL,
  `celular` BIGINT(20) NOT NULL,
  `fecha_nacimiento` DATE NOT NULL,
  `rh` VARCHAR(10) NOT NULL,
  `estado_contrato` TINYINT(1) NOT NULL,
  `fecha_expedicion` DATE NOT NULL,
  `fecha_vigencia` DATE NOT NULL,
  `departamento_area` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cedula`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Empleados de QInspecting. Origen: planesQi.Empleados';

-- -----------------------------------------------------------------------------
-- Mensajes del sistema (ej. mensaje de suspensión)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ten_mensajes` (
  `id_mensaje` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(15) NOT NULL,
  `mensaje` VARCHAR(250) NOT NULL,
  `estado` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mensaje`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Origen: planesQi.mensajes';

SET FOREIGN_KEY_CHECKS = 1;
