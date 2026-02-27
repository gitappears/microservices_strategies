-- =============================================================================
-- bd_capacitaciones - Tablas de dominio (cap*)
-- Alineado con entidades qinspecting_api_nest/src/entities/capacitacion/
-- Catálogos (tipo_adjuntos, cursos_certificados, tipo_pregunta, area) en 01_catalogos.sql
-- Charset: utf8mb4, collation: utf8mb4_unicode_ci
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------------------------
-- cap_capacitacion (Entity: Capacitacion)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_capacitacion` (
  `idCapacitacion` INT(25) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `titulo` VARCHAR(500) DEFAULT NULL,
  `enunciado` VARCHAR(2000) DEFAULT NULL,
  `estadoCapacitacion` TINYINT(1) NOT NULL DEFAULT 1,
  `idCapacitador` VARCHAR(50) NOT NULL,
  `fechaCreacion` DATE NOT NULL,
  `minAprobacion` INT(11) NOT NULL,
  `porcentajeEficacia` INT(11) NOT NULL,
  `tipoCapacitacion` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1=capacitacion, 2=certificacion',
  `descripcion` TEXT DEFAULT NULL,
  `duracion_horas` DECIMAL(5,2) DEFAULT NULL,
  `duracion_vigencia_dias` INT(11) DEFAULT NULL,
  `imagen_portada_url` VARCHAR(500) DEFAULT NULL,
  `video_promocional_url` VARCHAR(500) DEFAULT NULL,
  `capacidad_maxima` INT(11) DEFAULT NULL,
  `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` VARCHAR(50) NOT NULL DEFAULT '123456788',
  PRIMARY KEY (`idCapacitacion`),
  KEY `idx_cap_cap_empresa` (`id_empresa`),
  KEY `idx_cap_cap_capacitador` (`idCapacitador`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_adjuntos_capacitacion (Entity: AdjuntosCapacitacion)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_adjuntos_capacitacion` (
  `idAdjCapacitacion` INT(25) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `nombreAdjunto` VARCHAR(200) DEFAULT NULL,
  `fkIdCapacitacion` INT(25) NOT NULL,
  `fkIdTipoAdjunto` INT(25) NOT NULL,
  `urlAdjunto` VARCHAR(500) DEFAULT NULL,
  `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`idAdjCapacitacion`),
  KEY `idx_cap_adj_empresa` (`id_empresa`),
  KEY `idx_cap_adj_capacitacion` (`fkIdCapacitacion`),
  KEY `idx_cap_adj_tipo` (`fkIdTipoAdjunto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_evidencias (Entity: Evidencias)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_evidencias` (
  `idEvidencia` INT(25) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `observaciones` VARCHAR(1000) DEFAULT NULL,
  `rutaArchivo` VARCHAR(500) DEFAULT NULL,
  `fkIdCapacitacion` INT(25) NOT NULL,
  `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idEvidencia`),
  KEY `idx_cap_ev_empresa` (`id_empresa`),
  KEY `idx_cap_ev_capacitacion` (`fkIdCapacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_cursos_certificados_capacitacion (Entity: CursosCertificadosCapacitacion)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_cursos_certificados_capacitacion` (
  `idCertificado` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fkIdCurso` INT(11) NOT NULL,
  `fkIdCapacitacion` INT(25) NOT NULL,
  `idUsuario` VARCHAR(50) NOT NULL,
  `fechaIni` DATE NOT NULL,
  `fechaFin` DATE DEFAULT NULL,
  `aprobado` INT(11) NOT NULL DEFAULT 0,
  `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `facturaCobro` VARCHAR(50) DEFAULT NULL,
  `fechaCobro` DATE DEFAULT NULL,
  `pagoRealizado` VARCHAR(2) DEFAULT NULL,
  `fechaPagoFactura` DATE DEFAULT NULL,
  `usuarioControl` VARCHAR(50) NOT NULL DEFAULT '123456788',
  PRIMARY KEY (`idCertificado`),
  KEY `idx_cap_ccc_empresa` (`id_empresa`),
  KEY `idx_cap_ccc_curso` (`fkIdCurso`),
  KEY `idx_cap_ccc_capacitacion` (`fkIdCapacitacion`),
  KEY `idx_cap_ccc_usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_cursos_certificados_conductor (Entity: CursosCertificadosConductor)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_cursos_certificados_conductor` (
  `idUsuario` VARCHAR(50) NOT NULL,
  `fkIdCurso` INT(11) NOT NULL,
  `id_empresa` INT(11) NOT NULL,
  `fechaVencimiento` DATE NOT NULL,
  `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` VARCHAR(50) NOT NULL DEFAULT '123456788',
  PRIMARY KEY (`idUsuario`, `fkIdCurso`),
  KEY `idx_cap_cccond_empresa` (`id_empresa`),
  KEY `idx_cap_cccond_curso` (`fkIdCurso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_vigencia_capacitacion (Entity: VigenciaCapacitacion)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_vigencia_capacitacion` (
  `vigenciaId` INT(25) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `fechaInicio` DATE DEFAULT NULL,
  `fechaFin` DATE DEFAULT NULL,
  `capacitacionId` INT(25) NOT NULL,
  PRIMARY KEY (`vigenciaId`),
  KEY `idx_cap_vig_empresa` (`id_empresa`),
  KEY `idx_cap_vig_capacitacion` (`capacitacionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_preguntas_capacitacion (Entity: PreguntasCapacitacion)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_preguntas_capacitacion` (
  `idPreguntaCapacitacion` INT(25) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `descripcionPregunta` VARCHAR(15000) DEFAULT NULL,
  `fkIdTipoPregunta` INT(11) NOT NULL,
  `fkIdCapacitacion` INT(11) NOT NULL,
  `fechaControl` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idPreguntaCapacitacion`),
  KEY `idx_cap_pre_empresa` (`id_empresa`),
  KEY `idx_cap_pre_capacitacion` (`fkIdCapacitacion`),
  KEY `idx_cap_pre_tipo` (`fkIdTipoPregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_preguntas_has_capacitacion (Entity: PreguntasHasCapacitacion) - enlace N:M
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_preguntas_has_capacitacion` (
  `preguntaId` INT(25) NOT NULL,
  `fkIdCapacitacion` INT(25) NOT NULL,
  PRIMARY KEY (`preguntaId`, `fkIdCapacitacion`),
  KEY `idx_cap_phc_capacitacion` (`fkIdCapacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_respuestas_capacitacion (Entity: RespuestasCapacitacion)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_respuestas_capacitacion` (
  `idRespuestas` INT(25) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `respuestas` VARCHAR(450) DEFAULT NULL,
  `puntaje` FLOAT(25,2) DEFAULT NULL,
  `fkIdPreguntaCapacitacion` INT(25) NOT NULL,
  `fechaControl` DATETIME NOT NULL,
  `usuarioControl` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idRespuestas`),
  KEY `idx_cap_resp_empresa` (`id_empresa`),
  KEY `idx_cap_resp_pregunta` (`fkIdPreguntaCapacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_respuestas_usuario (Entity: RespuestasUsuario)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_respuestas_usuario` (
  `idRespuestaUsuario` INT(25) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL DEFAULT 1,
  `fechaRealizacion` VARCHAR(45) DEFAULT NULL,
  `usuarioRealiza` VARCHAR(50) NOT NULL,
  `idRespuestas` INT(25) NOT NULL,
  PRIMARY KEY (`idRespuestaUsuario`),
  KEY `idx_cap_ru_empresa` (`id_empresa`),
  KEY `idx_cap_ru_respuestas` (`idRespuestas`),
  KEY `idx_cap_ru_usuario` (`usuarioRealiza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_profesional_area (Entity: ProfesionalArea)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_profesional_area` (
  `usuarioCapacitador` VARCHAR(50) NOT NULL,
  `idArea` INT(25) NOT NULL,
  `id_empresa` INT(11) NOT NULL DEFAULT 1,
  `opcionProfesionalArea` TINYINT(2) NOT NULL DEFAULT 1 COMMENT '1=capacitador, 2=responsable, 3=ejecutor, 4=supervisor',
  PRIMARY KEY (`usuarioCapacitador`, `idArea`),
  KEY `idx_cap_pa_empresa` (`id_empresa`),
  KEY `idx_cap_pa_area` (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- Modelo tipo Udemy / training_api: secciones, lecciones, inscripción, progreso
-- Empresas y personal se gestionan en bd_tenancy_planes y bd_personal;
-- aquí solo id_empresa y numero_documento (referencia lógica, sin FK).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- cap_seccion_capacitacion (curso -> secciones)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_seccion_capacitacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `capacitacion_id` INT(25) NOT NULL COMMENT 'cap_capacitacion.idCapacitacion',
  `titulo` VARCHAR(300) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cap_sec_empresa` (`id_empresa`),
  KEY `idx_cap_sec_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_leccion (sección -> lecciones; contenido, video, duración)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_leccion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `seccion_id` INT(11) NOT NULL,
  `titulo` VARCHAR(300) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `contenido` LONGTEXT DEFAULT NULL,
  `video_url` VARCHAR(500) DEFAULT NULL,
  `duracion_minutos` INT(11) DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cap_lec_empresa` (`id_empresa`),
  KEY `idx_cap_lec_seccion` (`seccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_inscripcion (alumno en curso; progreso tipo Udemy)
-- estudiante = numero_documento (bd_personal), sin FK
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_inscripcion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `capacitacion_id` INT(25) NOT NULL,
  `numero_documento_estudiante` VARCHAR(50) NOT NULL COMMENT 'Referencia a bd_personal',
  `fecha_inscripcion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_inicio` DATETIME DEFAULT NULL,
  `fecha_finalizacion` DATETIME DEFAULT NULL,
  `progreso_porcentaje` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'inscrito' COMMENT 'inscrito|en_progreso|completado|abandonado',
  `calificacion_final` DECIMAL(5,2) DEFAULT NULL,
  `aprobado` TINYINT(1) DEFAULT NULL,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cap_insc_cap_est` (`capacitacion_id`, `numero_documento_estudiante`, `id_empresa`),
  KEY `idx_cap_insc_empresa` (`id_empresa`),
  KEY `idx_cap_insc_estudiante` (`numero_documento_estudiante`),
  KEY `idx_cap_insc_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_progreso_leccion (progreso por lección por inscripción)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_progreso_leccion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `inscripcion_id` INT(11) NOT NULL,
  `leccion_id` INT(11) NOT NULL,
  `completada` TINYINT(1) NOT NULL DEFAULT 0,
  `fecha_inicio` DATETIME DEFAULT NULL,
  `fecha_completada` DATETIME DEFAULT NULL,
  `tiempo_dedicado_minutos` INT(11) NOT NULL DEFAULT 0,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cap_prog_insc_lec` (`inscripcion_id`, `leccion_id`),
  KEY `idx_cap_prog_leccion` (`leccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- cap_material_capacitacion (materiales del curso, opcional)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_material_capacitacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `id_empresa` INT(11) NOT NULL,
  `capacitacion_id` INT(25) NOT NULL,
  `tipo_material_id` INT(11) DEFAULT NULL COMMENT 'Catálogo local o bd_catalogos',
  `nombre` VARCHAR(200) NOT NULL,
  `url` VARCHAR(1000) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_control` DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cap_mat_empresa` (`id_empresa`),
  KEY `idx_cap_mat_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- Encuestas: cualquier curso puede tener una encuesta (fk_id_capacitacion)
-- 0 = encuesta no vinculada a curso; si > 0 referencia cap_capacitacion.idCapacitacion
-- =============================================================================

CREATE TABLE IF NOT EXISTS `enc_encuesta` (
  `id_encuesta` INT(19) NOT NULL,
  `tema` VARCHAR(500) NOT NULL,
  `enunciado` VARCHAR(2000) NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_fin` DATE NOT NULL,
  `creado` INT(20) NOT NULL,
  `estado` TINYINT(1) NOT NULL DEFAULT 1,
  `fk_id_capacitacion` INT(11) NOT NULL DEFAULT 0 COMMENT '0=no vinculada a curso; si >0 -> cap_capacitacion.idCapacitacion',
  `requiere_inicio` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_encuesta`),
  KEY `idx_enc_enc_capacitacion` (`fk_id_capacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Encuestas; opcionalmente asociadas a un curso (cualquier curso puede tener una)';

CREATE TABLE IF NOT EXISTS `enc_preguntas_encuesta` (
  `id_pregunta` INT(19) NOT NULL,
  `id_encuesta` INT(19) NOT NULL,
  `descripcion` VARCHAR(2000) NOT NULL,
  `tipo_pregunta` INT(11) NOT NULL,
  PRIMARY KEY (`id_pregunta`),
  KEY `idx_enc_pre_encuesta` (`id_encuesta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Preguntas de la encuesta';

CREATE TABLE IF NOT EXISTS `enc_respuestas_encuesta` (
  `id_respuesta` INT(19) NOT NULL,
  `id_pregunta` INT(19) NOT NULL,
  `descripcion_respuesta` VARCHAR(2000) NOT NULL,
  PRIMARY KEY (`id_respuesta`),
  KEY `idx_enc_res_pregunta` (`id_pregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Opciones de respuesta por pregunta';

SET FOREIGN_KEY_CHECKS = 1;
