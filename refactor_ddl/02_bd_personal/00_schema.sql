-- =============================================================================
-- bd_personal — esquema sincronizado desde RDS (bastión) 2026-09-29
-- Fuente: SHOW CREATE TABLE sobre qinspecting-prod vía túnel bastión.
-- Incluye todas las tablas base presentes en el bastión (excepto se omiten vistas).
-- Charset: utf8mb4 / utf8mb4_unicode_ci (según definición real de cada tabla).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- -----------------------------------------------------------------------------
-- bd_personal.cat_area
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_area` (
  `id_area` int NOT NULL,
  `nombre_area` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_area` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_area`),
  KEY `idx_cat_area_estado` (`estado_area`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Áreas (origen: area)';

-- -----------------------------------------------------------------------------
-- bd_personal.cat_cargos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_cargos` (
  `id_cargo` int NOT NULL,
  `nombre_cargo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado_cargo` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=Activo, 0=Inactivo',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_cargo`),
  KEY `idx_cat_cargos_estado` (`estado_cargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cargos (origen: cargos/Cargos)';

-- -----------------------------------------------------------------------------
-- bd_personal.cat_ciudad
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_ciudad` (
  `id_ciudad` int NOT NULL,
  `nombre_ciudad` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fk_id_departamento` int NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_ciudad`),
  KEY `idx_cat_ciudad_dpto` (`fk_id_departamento`),
  CONSTRAINT `fk_cat_ciudad_departamento` FOREIGN KEY (`fk_id_departamento`) REFERENCES `cat_departamento` (`id_departamento`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ciudades (origen: ciudad/Ciudad)';

-- -----------------------------------------------------------------------------
-- bd_personal.cat_departamento
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_departamento` (
  `id_departamento` int NOT NULL,
  `nombre_dpto` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_departamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Departamentos (origen: departamento/Departamento)';

-- -----------------------------------------------------------------------------
-- bd_personal.cat_tipo_documento
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cat_tipo_documento` (
  `id_tipo_documento` int NOT NULL,
  `nombre_tipo_documento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_tipo_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tipos de documento (origen: tipoDocumento/Tipo_Documento)';

-- -----------------------------------------------------------------------------
-- bd_personal.migrations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_personal.per_personal
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `per_personal` (
  `numero_documento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_empresa` int NOT NULL COMMENT 'Tenant; referencia a bd_tenancy_planes.ten_empresas',
  `lugar_exp_documento` int NOT NULL COMMENT 'id_ciudad expedición',
  `fecha_nacimiento` date NOT NULL,
  `genero` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rh` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `arl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eps` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `afp` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numero_celular` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombres` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url_foto` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `estado_personal` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=activo, 0=inactivo',
  `fk_id_tipo_documento` int NOT NULL,
  `fk_id_cargo` int NOT NULL,
  `fk_id_rol` int DEFAULT NULL COMMENT 'Rol por defecto en el sistema',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'system',
  PRIMARY KEY (`numero_documento`,`id_empresa`),
  KEY `idx_per_personal_empresa` (`id_empresa`),
  KEY `idx_per_personal_estado` (`estado_personal`),
  KEY `idx_per_personal_tipo_doc` (`fk_id_tipo_documento`),
  KEY `idx_per_personal_cargo` (`fk_id_cargo`),
  CONSTRAINT `fk_per_personal_cargo` FOREIGN KEY (`fk_id_cargo`) REFERENCES `cat_cargos` (`id_cargo`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_per_personal_tipo_documento` FOREIGN KEY (`fk_id_tipo_documento`) REFERENCES `cat_tipo_documento` (`id_tipo_documento`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Personal consolidado de todas las empresas. Origen: personal (cada qinspect_new*)';

-- -----------------------------------------------------------------------------
-- bd_personal.per_rol
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `per_rol` (
  `idRol` int NOT NULL,
  `nombreRol` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcionRol` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idRol`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Roles del sistema. Usado por per_personal.fk_id_rol y Usuario.';

SET FOREIGN_KEY_CHECKS = 1;
