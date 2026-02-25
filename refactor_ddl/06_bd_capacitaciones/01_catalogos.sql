-- =============================================================================
-- bd_capacitaciones - Catálogos usados por las entidades de capacitación
-- Opcional: si tipo_adjuntos, cursos_certificados, tipo_pregunta y area ya existen
-- en bd_personal o bd_catalogos_compartidos, no ejecutes este archivo.
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `cap_tipo_adjuntos` (
    `idTipoAdjunto` INT(25) NOT NULL,
    `id_empresa` INT(11) NOT NULL DEFAULT 1,
    `tipoAdjunto` VARCHAR(45) DEFAULT NULL,
    `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `usuarioControl` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`idTipoAdjunto`),
    KEY `idx_tipo_adj_empresa` (`id_empresa`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cap_cursos_certificados` (
    `idCurso` INT(11) NOT NULL,
    `id_empresa` INT(11) NOT NULL DEFAULT 1,
    `curso` VARCHAR(500) NOT NULL,
    `empresa` VARCHAR(200) NOT NULL,
    `horas` INT(3) NOT NULL,
    `estadoCertificado` INT(1) NOT NULL,
    `certificado` INT(1) NOT NULL DEFAULT 1,
    `formatoFondo` VARCHAR(60) DEFAULT NULL,
    `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `usuarioControl` VARCHAR(50) NOT NULL DEFAULT '123456788',
    PRIMARY KEY (`idCurso`),
    KEY `idx_curso_cert_empresa` (`id_empresa`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cap_tipo_pregunta` (
    `idTipoPregunta` INT(11) NOT NULL,
    `nombreTipoPregunta` VARCHAR(100) DEFAULT NULL,
    `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `usuarioControl` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`idTipoPregunta`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `cap_area` (
    `idArea` INT(11) NOT NULL,
    `nombreArea` VARCHAR(200) DEFAULT NULL,
    `estadoArea` INT(1) NOT NULL DEFAULT 1,
    `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    `usuarioControl` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`idArea`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;