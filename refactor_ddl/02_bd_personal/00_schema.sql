-- =============================================================================
-- bd_personal - Esquema normalizado
-- Origen: personal + catálogos (departamento, ciudad, area, cargos, tipoDocumento)
-- de cada qinspect_new*. Personal consolidado en una sola tabla con id_empresa.
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- Catálogos (sin id_empresa: compartidos entre todas las empresas)
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `cat_departamento` (
  `id_departamento` INT(20) NOT NULL,
  `nombre_dpto` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_departamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Departamentos (origen: departamento/Departamento)';

CREATE TABLE IF NOT EXISTS `cat_ciudad` (
  `id_ciudad` INT(20) NOT NULL,
  `nombre_ciudad` VARCHAR(50) NOT NULL,
  `fk_id_departamento` INT(20) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_ciudad`),
  KEY `idx_cat_ciudad_dpto` (`fk_id_departamento`),
  CONSTRAINT `fk_cat_ciudad_departamento` FOREIGN KEY (`fk_id_departamento`) REFERENCES `cat_departamento` (`id_departamento`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Ciudades (origen: ciudad/Ciudad)';

CREATE TABLE IF NOT EXISTS `cat_area` (
  `id_area` INT(11) NOT NULL,
  `nombre_area` VARCHAR(200) DEFAULT NULL,
  `estado_area` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_area`),
  KEY `idx_cat_area_estado` (`estado_area`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Áreas (origen: area)';

CREATE TABLE IF NOT EXISTS `cat_cargos` (
  `id_cargo` INT(20) NOT NULL,
  `nombre_cargo` VARCHAR(50) NOT NULL,
  `estado_cargo` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=Activo, 0=Inactivo',
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_cargo`),
  KEY `idx_cat_cargos_estado` (`estado_cargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Cargos (origen: cargos/Cargos)';

CREATE TABLE IF NOT EXISTS `cat_tipo_documento` (
  `id_tipo_documento` INT(20) NOT NULL,
  `nombre_tipo_documento` VARCHAR(50) NOT NULL,
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`id_tipo_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Tipos de documento (origen: tipoDocumento/Tipo_Documento)';

-- -----------------------------------------------------------------------------
-- Personal (una sola tabla para todas las empresas; id_empresa = tenant)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `per_personal` (
  `numero_documento` VARCHAR(50) NOT NULL,
  `id_empresa` INT(11) NOT NULL COMMENT 'Tenant; referencia a bd_tenancy_planes.ten_empresas',
  `lugar_exp_documento` INT(20) NOT NULL COMMENT 'id_ciudad expedición',
  `fecha_nacimiento` DATE NOT NULL,
  `genero` VARCHAR(15) NOT NULL,
  `rh` VARCHAR(5) NOT NULL,
  `arl` VARCHAR(50) NOT NULL,
  `eps` VARCHAR(50) NOT NULL,
  `afp` VARCHAR(50) NOT NULL,
  `numero_celular` VARCHAR(15) NOT NULL,
  `direccion` VARCHAR(50) NOT NULL,
  `nombres` VARCHAR(50) NOT NULL,
  `apellidos` VARCHAR(50) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `url_foto` VARCHAR(150) NOT NULL DEFAULT '',
  `estado_personal` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=activo, 0=inactivo',
  `fk_id_tipo_documento` INT(20) NOT NULL,
  `fk_id_cargo` INT(20) NOT NULL,
  `fk_id_rol` INT(20) DEFAULT NULL COMMENT 'Rol por defecto en el sistema',
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) NOT NULL DEFAULT 'system',
  PRIMARY KEY (`numero_documento`, `id_empresa`),
  KEY `idx_per_personal_empresa` (`id_empresa`),
  KEY `idx_per_personal_estado` (`estado_personal`),
  KEY `idx_per_personal_tipo_doc` (`fk_id_tipo_documento`),
  KEY `idx_per_personal_cargo` (`fk_id_cargo`),
  CONSTRAINT `fk_per_personal_tipo_documento` FOREIGN KEY (`fk_id_tipo_documento`) REFERENCES `cat_tipo_documento` (`id_tipo_documento`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_per_personal_cargo` FOREIGN KEY (`fk_id_cargo`) REFERENCES `cat_cargos` (`id_cargo`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Personal consolidado de todas las empresas. Origen: personal (cada qinspect_new*)';

-- -----------------------------------------------------------------------------
-- Nota: No hay FK a ten_empresas porque esta BD puede estar en otro servidor.
-- La aplicación garantiza que id_empresa exista en bd_tenancy_planes.
-- fkIdRol referencia bd_tenancy.rol (otra BD); no se define FK cross-database.

SET FOREIGN_KEY_CHECKS = 1;
