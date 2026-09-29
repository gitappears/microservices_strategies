-- =============================================================================
-- bd_capacitaciones — esquema sincronizado desde RDS (bastión) 2026-09-29
-- Fuente: SHOW CREATE TABLE sobre qinspecting-prod vía túnel bastión.
-- Incluye todas las tablas base presentes en el bastión (excepto se omiten vistas).
-- Charset: utf8mb4 / utf8mb4_unicode_ci (según definición real de cada tabla).
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;
-- -----------------------------------------------------------------------------
-- bd_capacitaciones.aceptaciones_politicas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `aceptaciones_politicas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `documento_legal_id` int NOT NULL,
  `version` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `firma_digital` text COLLATE utf8mb4_unicode_ci,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_aceptacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_documento` (`usuario_id`,`documento_legal_id`),
  KEY `idx_acep_documento` (`documento_legal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.alertas_vencimiento
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `alertas_vencimiento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `certificado_id` int NOT NULL,
  `dias_restantes` int NOT NULL,
  `fecha_envio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `enviado` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_vencimiento` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_alert_certificado` (`certificado_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.alumnos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `alumnos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `codigo_estudiante` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `es_externo` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_ingreso` date DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_alumnos_persona` (`persona_id`),
  UNIQUE KEY `uk_alumnos_codigo` (`codigo_estudiante`),
  CONSTRAINT `fk_alumnos_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.assistant_empresa_quota
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `assistant_empresa_quota` (
  `empresa_id` int NOT NULL,
  `token_quota_monthly` int unsigned NOT NULL DEFAULT '0',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`empresa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.assistant_empresa_usage
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `assistant_empresa_usage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `month` varchar(7) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokens_used` int unsigned NOT NULL DEFAULT '0',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_assistant_empresa_month` (`empresa_id`,`month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.auditoria_certificados_retroactivos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `auditoria_certificados_retroactivos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `certificado_id` int NOT NULL,
  `fecha_aprobacion_real` datetime NOT NULL,
  `fecha_retroactiva` datetime NOT NULL,
  `justificacion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `emitido_por` int NOT NULL,
  `fecha_emision` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_aud_certificado` (`certificado_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_adjuntos_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_adjuntos_capacitacion` (
  `idAdjCapacitacion` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `nombreAdjunto` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fkIdCapacitacion` int NOT NULL,
  `fkIdTipoAdjunto` int NOT NULL,
  `urlAdjunto` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`idAdjCapacitacion`),
  KEY `idx_cap_adj_empresa` (`id_empresa`),
  KEY `idx_cap_adj_capacitacion` (`fkIdCapacitacion`),
  KEY `idx_cap_adj_tipo` (`fkIdTipoAdjunto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_area
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_area` (
  `idArea` int NOT NULL,
  `nombreArea` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estadoArea` int NOT NULL DEFAULT '1',
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_capacitacion` (
  `idCapacitacion` int NOT NULL,
  `lms_capacitacion_id` int DEFAULT NULL COMMENT 'FK lógica → capacitaciones.id (curso LMS canónico)',
  `id_empresa` int NOT NULL,
  `titulo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enunciado` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estadoCapacitacion` tinyint(1) NOT NULL DEFAULT '1',
  `idCapacitador` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaCreacion` date NOT NULL,
  `minAprobacion` int NOT NULL,
  `porcentajeEficacia` int NOT NULL,
  `tipoCapacitacion` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1=capacitacion, 2=certificacion',
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `duracion_horas` decimal(5,2) DEFAULT NULL,
  `duracion_vigencia_dias` int DEFAULT NULL,
  `imagen_portada_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video_promocional_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capacidad_maxima` int DEFAULT NULL,
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788',
  PRIMARY KEY (`idCapacitacion`),
  KEY `idx_cap_cap_empresa` (`id_empresa`),
  KEY `idx_cap_cap_capacitador` (`idCapacitador`),
  KEY `idx_cap_cap_lms` (`lms_capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_cursos_certificados
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_cursos_certificados` (
  `idCurso` int NOT NULL,
  `id_empresa` int NOT NULL DEFAULT '1',
  `curso` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `empresa` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `horas` int NOT NULL,
  `estadoCertificado` int NOT NULL,
  `certificado` int NOT NULL DEFAULT '1',
  `formatoFondo` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788',
  PRIMARY KEY (`idCurso`),
  KEY `idx_curso_cert_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_cursos_certificados_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_cursos_certificados_capacitacion` (
  `idCertificado` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fkIdCurso` int NOT NULL,
  `fkIdCapacitacion` int NOT NULL,
  `idUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaIni` date NOT NULL,
  `fechaFin` date DEFAULT NULL,
  `aprobado` int NOT NULL DEFAULT '0',
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `facturaCobro` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaCobro` date DEFAULT NULL,
  `pagoRealizado` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaPagoFactura` date DEFAULT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788',
  PRIMARY KEY (`idCertificado`),
  KEY `idx_cap_ccc_empresa` (`id_empresa`),
  KEY `idx_cap_ccc_curso` (`fkIdCurso`),
  KEY `idx_cap_ccc_capacitacion` (`fkIdCapacitacion`),
  KEY `idx_cap_ccc_usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_cursos_certificados_conductor
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_cursos_certificados_conductor` (
  `idUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkIdCurso` int NOT NULL,
  `id_empresa` int NOT NULL,
  `fechaVencimiento` date NOT NULL,
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788',
  PRIMARY KEY (`idUsuario`,`fkIdCurso`),
  KEY `idx_cap_cccond_empresa` (`id_empresa`),
  KEY `idx_cap_cccond_curso` (`fkIdCurso`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_evidencias
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_evidencias` (
  `idEvidencia` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `observaciones` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rutaArchivo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fkIdCapacitacion` int NOT NULL,
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idEvidencia`),
  KEY `idx_cap_ev_empresa` (`id_empresa`),
  KEY `idx_cap_ev_capacitacion` (`fkIdCapacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_inscripcion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_inscripcion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `capacitacion_id` int NOT NULL,
  `numero_documento_estudiante` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Referencia a bd_personal',
  `fecha_inscripcion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_finalizacion` datetime DEFAULT NULL,
  `progreso_porcentaje` decimal(5,2) NOT NULL DEFAULT '0.00',
  `estado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'inscrito' COMMENT 'inscrito|en_progreso|completado|abandonado',
  `calificacion_final` decimal(5,2) DEFAULT NULL,
  `aprobado` tinyint(1) DEFAULT NULL,
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cap_insc_cap_est` (`capacitacion_id`,`numero_documento_estudiante`,`id_empresa`),
  KEY `idx_cap_insc_empresa` (`id_empresa`),
  KEY `idx_cap_insc_estudiante` (`numero_documento_estudiante`),
  KEY `idx_cap_insc_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_leccion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_leccion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `seccion_id` int NOT NULL,
  `titulo` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `contenido` longtext COLLATE utf8mb4_unicode_ci,
  `video_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duracion_minutos` int DEFAULT NULL,
  `orden` int NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cap_lec_empresa` (`id_empresa`),
  KEY `idx_cap_lec_seccion` (`seccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_material_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_material_capacitacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `capacitacion_id` int NOT NULL,
  `tipo_material_id` int DEFAULT NULL COMMENT 'Catálogo local o bd_catalogos',
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `orden` int NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cap_mat_empresa` (`id_empresa`),
  KEY `idx_cap_mat_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_preguntas_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_preguntas_capacitacion` (
  `idPreguntaCapacitacion` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `descripcionPregunta` varchar(15000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fkIdTipoPregunta` int NOT NULL,
  `fkIdCapacitacion` int NOT NULL,
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idPreguntaCapacitacion`),
  KEY `idx_cap_pre_empresa` (`id_empresa`),
  KEY `idx_cap_pre_capacitacion` (`fkIdCapacitacion`),
  KEY `idx_cap_pre_tipo` (`fkIdTipoPregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_preguntas_has_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_preguntas_has_capacitacion` (
  `preguntaId` int NOT NULL,
  `fkIdCapacitacion` int NOT NULL,
  PRIMARY KEY (`preguntaId`,`fkIdCapacitacion`),
  KEY `idx_cap_phc_capacitacion` (`fkIdCapacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_profesional_area
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_profesional_area` (
  `usuarioCapacitador` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idArea` int NOT NULL,
  `id_empresa` int NOT NULL DEFAULT '1',
  `opcionProfesionalArea` tinyint NOT NULL DEFAULT '1' COMMENT '1=capacitador, 2=responsable, 3=ejecutor, 4=supervisor',
  PRIMARY KEY (`usuarioCapacitador`,`idArea`),
  KEY `idx_cap_pa_empresa` (`id_empresa`),
  KEY `idx_cap_pa_area` (`idArea`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_progreso_leccion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_progreso_leccion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `inscripcion_id` int NOT NULL,
  `leccion_id` int NOT NULL,
  `completada` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_completada` datetime DEFAULT NULL,
  `tiempo_dedicado_minutos` int NOT NULL DEFAULT '0',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cap_prog_insc_lec` (`inscripcion_id`,`leccion_id`),
  KEY `idx_cap_prog_leccion` (`leccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_respuestas_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_respuestas_capacitacion` (
  `idRespuestas` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `respuestas` varchar(450) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `puntaje` float(25,2) DEFAULT NULL,
  `fkIdPreguntaCapacitacion` int NOT NULL,
  `fechaControl` datetime NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idRespuestas`),
  KEY `idx_cap_resp_empresa` (`id_empresa`),
  KEY `idx_cap_resp_pregunta` (`fkIdPreguntaCapacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_respuestas_usuario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_respuestas_usuario` (
  `idRespuestaUsuario` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL DEFAULT '1',
  `fechaRealizacion` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuarioRealiza` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idRespuestas` int NOT NULL,
  PRIMARY KEY (`idRespuestaUsuario`),
  KEY `idx_cap_ru_empresa` (`id_empresa`),
  KEY `idx_cap_ru_respuestas` (`idRespuestas`),
  KEY `idx_cap_ru_usuario` (`usuarioRealiza`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_seccion_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_seccion_capacitacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `capacitacion_id` int NOT NULL COMMENT 'cap_capacitacion.idCapacitacion',
  `titulo` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `orden` int NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_control` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_cap_sec_empresa` (`id_empresa`),
  KEY `idx_cap_sec_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_tipo_adjuntos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_tipo_adjuntos` (
  `idTipoAdjunto` int NOT NULL,
  `id_empresa` int NOT NULL DEFAULT '1',
  `tipoAdjunto` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idTipoAdjunto`),
  KEY `idx_tipo_adj_empresa` (`id_empresa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_tipo_pregunta
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_tipo_pregunta` (
  `idTipoPregunta` int NOT NULL,
  `nombreTipoPregunta` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaControl` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idTipoPregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.cap_vigencia_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cap_vigencia_capacitacion` (
  `vigenciaId` int NOT NULL AUTO_INCREMENT,
  `id_empresa` int NOT NULL,
  `fechaInicio` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `capacitacionId` int NOT NULL,
  PRIMARY KEY (`vigenciaId`),
  KEY `idx_cap_vig_empresa` (`id_empresa`),
  KEY `idx_cap_vig_capacitacion` (`capacitacionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.capacitaciones
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `capacitaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titulo` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `tipo_capacitacion_id` int NOT NULL,
  `modalidad_id` int NOT NULL,
  `instructor_id` int NOT NULL,
  `ente_certificador_id` int DEFAULT NULL,
  `area_id` int DEFAULT NULL,
  `publico_objetivo` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `duracion_horas` decimal(5,2) DEFAULT NULL,
  `duracion_vigencia_dias` int DEFAULT NULL,
  `tipo_certificado` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `capacidad_maxima` int DEFAULT NULL,
  `imagen_portada_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `video_promocional_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `minimo_aprobacion` decimal(5,2) NOT NULL DEFAULT '70.00',
  `porcentaje_eficacia` decimal(5,2) DEFAULT NULL,
  `estado` enum('borrador','publicada','en_curso','finalizada','cancelada','archivada') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'borrador',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `usuario_creacion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_actualizacion` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_capacitaciones_titulo` (`titulo`),
  KEY `idx_capacitaciones_tipo` (`tipo_capacitacion_id`),
  KEY `idx_capacitaciones_modalidad` (`modalidad_id`),
  KEY `idx_capacitaciones_instructor` (`instructor_id`),
  KEY `idx_capacitaciones_ente` (`ente_certificador_id`),
  KEY `idx_capacitaciones_estado` (`estado`),
  CONSTRAINT `fk_capacitaciones_instructor` FOREIGN KEY (`instructor_id`) REFERENCES `instructores` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_capacitaciones_modalidad` FOREIGN KEY (`modalidad_id`) REFERENCES `modalidades_capacitacion` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_capacitaciones_tipo` FOREIGN KEY (`tipo_capacitacion_id`) REFERENCES `tipos_capacitacion` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.capacitaciones_empresas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `capacitaciones_empresas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `empresa_id` int NOT NULL,
  `capacitacion_id` int NOT NULL,
  `permite_descarga_certificado` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_asignacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cap_empresa_curso` (`empresa_id`,`capacitacion_id`),
  KEY `idx_cap_emp_capacitacion` (`capacitacion_id`),
  CONSTRAINT `fk_cap_emp_capacitacion` FOREIGN KEY (`capacitacion_id`) REFERENCES `capacitaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cap_emp_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.certificados
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `certificados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `inscripcion_id` int NOT NULL,
  `numero_certificado` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_emision` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_aprobacion_real` datetime DEFAULT NULL,
  `fecha_retroactiva` datetime DEFAULT NULL,
  `es_retroactivo` tinyint(1) NOT NULL DEFAULT '0',
  `justificacion_retroactiva` text COLLATE utf8mb4_unicode_ci,
  `fecha_vencimiento` date DEFAULT NULL,
  `url_certificado` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `url_verificacion_publica` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `hash_verificacion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_qr` text COLLATE utf8mb4_unicode_ci,
  `firma_digital` text COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_num_certificado` (`numero_certificado`),
  KEY `idx_cert_inscripcion` (`inscripcion_id`),
  KEY `idx_cert_hash` (`hash_verificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.certificate_formats
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `certificate_formats` (
  `id` int NOT NULL AUTO_INCREMENT,
  `config` json DEFAULT NULL,
  `fondo_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_certificate_formats_activo` (`activo`,`fecha_actualizacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.configuracion_alertas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `configuracion_alertas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dias_antes_vencimiento` int NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dias_alerta` (`dias_antes_vencimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.configuracion_sesion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `configuracion_sesion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tiempo_inactividad_minutos` int DEFAULT NULL,
  `tiempo_maximo_sesion_minutos` int DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creado_por` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.device_tokens
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `device_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `token` varchar(512) COLLATE utf8mb4_unicode_ci NOT NULL,
  `platform` enum('android','ios','web') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'web',
  `device_info` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint NOT NULL DEFAULT '1',
  `fecha_creacion` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `fecha_actualizacion` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_device_tokens_persona_token` (`persona_id`,`token`),
  KEY `idx_device_tokens_persona_activo` (`persona_id`,`activo`),
  CONSTRAINT `fk_device_tokens_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.documentos_legales
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `documentos_legales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `titulo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `contenido` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '1.0',
  `requiere_firma_digital` tinyint(1) NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creado_por` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_doc_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.empresas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `empresas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero_documento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'NIT; mapear a ten_empresas.nit',
  `tipo_documento` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NIT',
  `razon_social` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` text COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminada` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_empresas_num_doc` (`numero_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.enc_encuesta
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `enc_encuesta` (
  `id_encuesta` int NOT NULL,
  `tema` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enunciado` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `creado` int NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `fk_id_capacitacion` int NOT NULL DEFAULT '0' COMMENT '0=no vinculada a curso; si >0 -> cap_capacitacion.idCapacitacion',
  `requiere_inicio` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_encuesta`),
  KEY `idx_enc_enc_capacitacion` (`fk_id_capacitacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Encuestas; opcionalmente asociadas a un curso (cualquier curso puede tener una)';

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.enc_preguntas_encuesta
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `enc_preguntas_encuesta` (
  `id_pregunta` int NOT NULL,
  `id_encuesta` int NOT NULL,
  `descripcion` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_pregunta` int NOT NULL,
  PRIMARY KEY (`id_pregunta`),
  KEY `idx_enc_pre_encuesta` (`id_encuesta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Preguntas de la encuesta';

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.enc_respuestas_encuesta
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `enc_respuestas_encuesta` (
  `id_respuesta` int NOT NULL,
  `id_pregunta` int NOT NULL,
  `descripcion_respuesta` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_respuesta`),
  KEY `idx_enc_res_pregunta` (`id_pregunta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Opciones de respuesta por pregunta';

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.entes_certificadores
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `entes_certificadores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `informacion_contacto` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `logo_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `certificate_format_id` int DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_entes_codigo` (`codigo`),
  KEY `idx_entes_formato` (`certificate_format_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.evaluaciones
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `evaluaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `capacitacion_id` int NOT NULL,
  `titulo` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `tiempo_limite_minutos` int DEFAULT NULL,
  `intentos_permitidos` int NOT NULL DEFAULT '1',
  `mostrar_resultados` tinyint(1) NOT NULL DEFAULT '1',
  `mostrar_respuestas_correctas` tinyint(1) NOT NULL DEFAULT '0',
  `puntaje_total` decimal(10,2) NOT NULL DEFAULT '100.00',
  `minimo_aprobacion` decimal(5,2) NOT NULL DEFAULT '70.00',
  `orden` int NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_eval_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.inscripciones
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `inscripciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `capacitacion_id` int NOT NULL,
  `estudiante_id` int NOT NULL COMMENT 'FK personas.id (proyección local)',
  `pago_id` int DEFAULT NULL,
  `fecha_inscripcion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_finalizacion` datetime DEFAULT NULL,
  `progreso_porcentaje` decimal(5,2) NOT NULL DEFAULT '0.00',
  `estado` enum('inscrito','en_progreso','completado','abandonado') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'inscrito',
  `calificacion_final` decimal(5,2) DEFAULT NULL,
  `aprobado` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_insc_cap_est` (`capacitacion_id`,`estudiante_id`),
  KEY `idx_insc_estudiante` (`estudiante_id`),
  KEY `idx_insc_pago` (`pago_id`),
  CONSTRAINT `fk_inscripciones_capacitacion` FOREIGN KEY (`capacitacion_id`) REFERENCES `capacitaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_inscripciones_estudiante` FOREIGN KEY (`estudiante_id`) REFERENCES `alumnos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.instructores
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `instructores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `especialidad` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tarjeta_profesional` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `licencia` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `biografia` text COLLATE utf8mb4_unicode_ci,
  `calificacion_promedio` decimal(3,2) DEFAULT NULL,
  `total_capacitaciones` int NOT NULL DEFAULT '0',
  `total_estudiantes` int NOT NULL DEFAULT '0',
  `firma_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instructores_persona` (`persona_id`),
  CONSTRAINT `fk_instructores_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.intentos_evaluacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `intentos_evaluacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evaluacion_id` int NOT NULL,
  `inscripcion_id` int NOT NULL,
  `numero_intento` int NOT NULL DEFAULT '1',
  `fecha_inicio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_finalizacion` datetime DEFAULT NULL,
  `puntaje_obtenido` decimal(10,2) NOT NULL DEFAULT '0.00',
  `puntaje_total` decimal(10,2) DEFAULT NULL,
  `porcentaje` decimal(5,2) DEFAULT NULL,
  `aprobado` tinyint(1) DEFAULT NULL,
  `tiempo_utilizado_minutos` int DEFAULT NULL,
  `estado` enum('en_progreso','completado','abandonado') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'en_progreso',
  PRIMARY KEY (`id`),
  KEY `idx_intento_evaluacion` (`evaluacion_id`),
  KEY `idx_intento_inscripcion` (`inscripcion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.lecciones
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `lecciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `seccion_id` int NOT NULL,
  `titulo` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `contenido` longtext COLLATE utf8mb4_unicode_ci,
  `video_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duracion_minutos` int DEFAULT NULL,
  `orden` int NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_lecciones_seccion` (`seccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.materiales_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `materiales_capacitacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `capacitacion_id` int NOT NULL,
  `tipo_material_id` int NOT NULL,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `orden` int NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_mat_capacitacion` (`capacitacion_id`),
  KEY `idx_mat_tipo` (`tipo_material_id`),
  CONSTRAINT `fk_mat_capacitacion` FOREIGN KEY (`capacitacion_id`) REFERENCES `capacitaciones` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.migrations
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.modalidades_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `modalidades_capacitacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_modalidades_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.notificaciones
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `notificaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `tipo` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'GENERIC',
  `titulo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cuerpo` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` json DEFAULT NULL,
  `leida` tinyint NOT NULL DEFAULT '0',
  `fecha_lectura` datetime DEFAULT NULL,
  `fecha_creacion` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`),
  KEY `idx_notificaciones_persona_leida` (`persona_id`,`leida`),
  KEY `idx_notificaciones_fecha` (`fecha_creacion`),
  CONSTRAINT `fk_notificaciones_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.opciones_respuesta
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `opciones_respuesta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pregunta_id` int NOT NULL,
  `texto` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imagen_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `es_correcta` tinyint(1) NOT NULL DEFAULT '0',
  `puntaje_parcial` decimal(10,2) NOT NULL DEFAULT '0.00',
  `orden` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_opc_pregunta` (`pregunta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.pagos
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `pagos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `estudiante_id` int NOT NULL,
  `capacitacion_id` int NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `metodo_pago` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numero_comprobante` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_pago` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` int NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pago_estudiante` (`estudiante_id`),
  KEY `idx_pago_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.password_reset_tokens
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `usuario_id` int NOT NULL,
  `token_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `used` tinyint(1) NOT NULL DEFAULT '0',
  `expires_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_token_hash` (`token_hash`),
  KEY `idx_usuario_expiry` (`usuario_id`,`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.persona_roles
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `persona_roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `rol_id` int NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_asignacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_persona_rol` (`persona_id`,`rol_id`),
  KEY `idx_persona_roles_rol` (`rol_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.personas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `personas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero_documento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mapear a per_personal.numero_documento',
  `tipo_documento` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'CC',
  `tipo_persona` enum('NATURAL','JURIDICA') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NATURAL',
  `nombres` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `empresa_id` int DEFAULT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `genero` enum('M','F','O') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` text COLLATE utf8mb4_unicode_ci,
  `biografia` text COLLATE utf8mb4_unicode_ci,
  `foto_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_personas_num_doc` (`numero_documento`),
  KEY `idx_personas_empresa` (`empresa_id`),
  CONSTRAINT `fk_personas_empresa` FOREIGN KEY (`empresa_id`) REFERENCES `empresas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.preguntas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `preguntas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evaluacion_id` int NOT NULL,
  `tipo_pregunta_id` int NOT NULL,
  `enunciado` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `imagen_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `puntaje` decimal(10,2) NOT NULL DEFAULT '1.00',
  `orden` int NOT NULL DEFAULT '0',
  `requerida` tinyint(1) NOT NULL DEFAULT '1',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_preg_evaluacion` (`evaluacion_id`),
  KEY `idx_preg_tipo` (`tipo_pregunta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.progreso_lecciones
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `progreso_lecciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `inscripcion_id` int NOT NULL,
  `leccion_id` int NOT NULL,
  `completada` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_inicio` datetime DEFAULT NULL,
  `fecha_completada` datetime DEFAULT NULL,
  `tiempo_dedicado_minutos` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_prog_insc_lec` (`inscripcion_id`,`leccion_id`),
  KEY `idx_prog_leccion` (`leccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.representantes
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `representantes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ente_certificador_id` int DEFAULT NULL,
  `nombre` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cargo` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firma_path` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_representantes_ente` (`ente_certificador_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.resenas
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `resenas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `inscripcion_id` int NOT NULL,
  `calificacion` tinyint(1) NOT NULL,
  `comentario` text COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resena_inscripcion` (`inscripcion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.respuestas_estudiante
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `respuestas_estudiante` (
  `id` int NOT NULL AUTO_INCREMENT,
  `intento_evaluacion_id` int NOT NULL,
  `pregunta_id` int NOT NULL,
  `opcion_respuesta_id` int DEFAULT NULL,
  `texto_respuesta` text COLLATE utf8mb4_unicode_ci,
  `puntaje_obtenido` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fecha_respuesta` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_rta_intento` (`intento_evaluacion_id`),
  KEY `idx_rta_pregunta` (`pregunta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.respuestas_multiples
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `respuestas_multiples` (
  `id` int NOT NULL AUTO_INCREMENT,
  `respuesta_estudiante_id` int NOT NULL,
  `opcion_respuesta_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_rta_opc` (`respuesta_estudiante_id`,`opcion_respuesta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.roles
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_roles_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.secciones_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `secciones_capacitacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `capacitacion_id` int NOT NULL,
  `titulo` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `orden` int NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `idx_sec_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.tipos_capacitacion
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tipos_capacitacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tipos_cap_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.tipos_material
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tipos_material` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tipos_material_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.tipos_pregunta
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `tipos_pregunta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `permite_multiple_respuesta` tinyint(1) NOT NULL DEFAULT '0',
  `requiere_texto_libre` tinyint(1) NOT NULL DEFAULT '0',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tipos_pregunta_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- bd_capacitaciones.usuarios
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `username` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `rol_principal_id` int DEFAULT NULL,
  `habilitado` tinyint(1) NOT NULL DEFAULT '1',
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `debe_cambiar_password` tinyint(1) NOT NULL DEFAULT '0',
  `ultimo_acceso` datetime DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuarios_username` (`username`),
  UNIQUE KEY `uk_usuarios_persona` (`persona_id`),
  KEY `idx_usuarios_rol` (`rol_principal_id`),
  CONSTRAINT `fk_usuarios_persona` FOREIGN KEY (`persona_id`) REFERENCES `personas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_usuarios_rol` FOREIGN KEY (`rol_principal_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
