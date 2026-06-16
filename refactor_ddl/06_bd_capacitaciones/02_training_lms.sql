-- =============================================================================
-- bd_capacitaciones — Dominio Training LMS (Formar360 / training_api)
-- Convive con tablas legacy cap_* (00_schema.sql). Identidad multitenant:
-- ten_empresas + per_personal (Cognito) son fuente de verdad; tablas
-- empresas/personas/usuarios aquí son proyección local para FKs del LMS.
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE IF NOT EXISTS `roles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `codigo` VARCHAR(50) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_roles_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tipos_capacitacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `codigo` VARCHAR(20) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tipos_cap_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `modalidades_capacitacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(50) NOT NULL,
  `codigo` VARCHAR(20) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_modalidades_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tipos_pregunta` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `codigo` VARCHAR(50) NOT NULL,
  `permite_multiple_respuesta` TINYINT(1) NOT NULL DEFAULT 0,
  `requiere_texto_libre` TINYINT(1) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tipos_pregunta_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `tipos_material` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `codigo` VARCHAR(50) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tipos_material_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `empresas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `numero_documento` VARCHAR(50) NOT NULL COMMENT 'NIT; mapear a ten_empresas.nit',
  `tipo_documento` VARCHAR(20) NOT NULL DEFAULT 'NIT',
  `razon_social` VARCHAR(500) NOT NULL,
  `email` VARCHAR(255) DEFAULT NULL,
  `telefono` VARCHAR(50) DEFAULT NULL,
  `direccion` TEXT DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `eliminada` TINYINT(1) NOT NULL DEFAULT 0,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_empresas_num_doc` (`numero_documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `personas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `numero_documento` VARCHAR(50) NOT NULL COMMENT 'Mapear a per_personal.numero_documento',
  `tipo_documento` VARCHAR(20) NOT NULL DEFAULT 'CC',
  `tipo_persona` ENUM('NATURAL', 'JURIDICA') NOT NULL DEFAULT 'NATURAL',
  `nombres` VARCHAR(200) NOT NULL,
  `apellidos` VARCHAR(200) DEFAULT NULL,
  `empresa_id` INT(11) DEFAULT NULL,
  `email` VARCHAR(255) DEFAULT NULL,
  `telefono` VARCHAR(50) DEFAULT NULL,
  `fecha_nacimiento` DATE DEFAULT NULL,
  `genero` ENUM('M', 'F', 'O') DEFAULT NULL,
  `direccion` TEXT DEFAULT NULL,
  `biografia` TEXT DEFAULT NULL,
  `foto_url` VARCHAR(500) DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_personas_num_doc` (`numero_documento`),
  KEY `idx_personas_empresa` (`empresa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `usuarios` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `persona_id` INT(11) NOT NULL,
  `username` VARCHAR(100) NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL DEFAULT '',
  `rol_principal_id` INT(11) DEFAULT NULL,
  `habilitado` TINYINT(1) NOT NULL DEFAULT 1,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `debe_cambiar_password` TINYINT(1) NOT NULL DEFAULT 0,
  `ultimo_acceso` DATETIME DEFAULT NULL,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuarios_username` (`username`),
  UNIQUE KEY `uk_usuarios_persona` (`persona_id`),
  KEY `idx_usuarios_rol` (`rol_principal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `persona_roles` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `persona_id` INT(11) NOT NULL,
  `rol_id` INT(11) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_asignacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_persona_rol` (`persona_id`, `rol_id`),
  KEY `idx_persona_roles_rol` (`rol_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `alumnos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `persona_id` INT(11) NOT NULL,
  `codigo_estudiante` VARCHAR(50) DEFAULT NULL,
  `es_externo` TINYINT(1) NOT NULL DEFAULT 0,
  `fecha_ingreso` DATE DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_alumnos_persona` (`persona_id`),
  UNIQUE KEY `uk_alumnos_codigo` (`codigo_estudiante`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `instructores` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `persona_id` INT(11) NOT NULL,
  `especialidad` VARCHAR(200) DEFAULT NULL,
  `rol` VARCHAR(200) DEFAULT NULL,
  `tarjeta_profesional` VARCHAR(200) DEFAULT NULL,
  `licencia` VARCHAR(200) DEFAULT NULL,
  `biografia` TEXT DEFAULT NULL,
  `calificacion_promedio` DECIMAL(3,2) DEFAULT NULL,
  `total_capacitaciones` INT(11) NOT NULL DEFAULT 0,
  `total_estudiantes` INT(11) NOT NULL DEFAULT 0,
  `firma_path` VARCHAR(500) DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_instructores_persona` (`persona_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `certificate_formats` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `config` JSON DEFAULT NULL,
  `fondo_path` VARCHAR(500) DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_certificate_formats_activo` (`activo`, `fecha_actualizacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `entes_certificadores` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(200) NOT NULL,
  `codigo` VARCHAR(50) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `informacion_contacto` VARCHAR(500) DEFAULT NULL,
  `logo_path` VARCHAR(500) DEFAULT NULL,
  `certificate_format_id` INT(11) DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_entes_codigo` (`codigo`),
  KEY `idx_entes_formato` (`certificate_format_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `representantes` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `ente_certificador_id` INT(11) DEFAULT NULL,
  `nombre` VARCHAR(200) NOT NULL,
  `cargo` VARCHAR(200) DEFAULT NULL,
  `firma_path` VARCHAR(500) DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_representantes_ente` (`ente_certificador_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `capacitaciones` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(500) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `tipo_capacitacion_id` INT(11) NOT NULL,
  `modalidad_id` INT(11) NOT NULL,
  `instructor_id` INT(11) NOT NULL,
  `ente_certificador_id` INT(11) DEFAULT NULL,
  `area_id` INT(11) DEFAULT NULL,
  `publico_objetivo` VARCHAR(200) DEFAULT NULL,
  `fecha_inicio` DATE DEFAULT NULL,
  `fecha_fin` DATE DEFAULT NULL,
  `duracion_horas` DECIMAL(5,2) DEFAULT NULL,
  `duracion_vigencia_dias` INT(11) DEFAULT NULL,
  `tipo_certificado` VARCHAR(20) DEFAULT NULL,
  `capacidad_maxima` INT(11) DEFAULT NULL,
  `imagen_portada_url` VARCHAR(500) DEFAULT NULL,
  `video_promocional_url` VARCHAR(500) DEFAULT NULL,
  `minimo_aprobacion` DECIMAL(5,2) NOT NULL DEFAULT 70.00,
  `porcentaje_eficacia` DECIMAL(5,2) DEFAULT NULL,
  `estado` ENUM('borrador', 'publicada', 'en_curso', 'finalizada', 'cancelada') NOT NULL DEFAULT 'borrador',
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `usuario_creacion` VARCHAR(50) NOT NULL,
  `usuario_actualizacion` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_capacitaciones_tipo` (`tipo_capacitacion_id`),
  KEY `idx_capacitaciones_modalidad` (`modalidad_id`),
  KEY `idx_capacitaciones_instructor` (`instructor_id`),
  KEY `idx_capacitaciones_ente` (`ente_certificador_id`),
  KEY `idx_capacitaciones_estado` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `capacitaciones_empresas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `empresa_id` INT(11) NOT NULL,
  `capacitacion_id` INT(11) NOT NULL,
  `permite_descarga_certificado` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_asignacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_cap_empresa_curso` (`empresa_id`, `capacitacion_id`),
  KEY `idx_cap_emp_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `materiales_capacitacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `capacitacion_id` INT(11) NOT NULL,
  `tipo_material_id` INT(11) NOT NULL,
  `nombre` VARCHAR(200) NOT NULL,
  `url` VARCHAR(1000) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_mat_capacitacion` (`capacitacion_id`),
  KEY `idx_mat_tipo` (`tipo_material_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `secciones_capacitacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `capacitacion_id` INT(11) NOT NULL,
  `titulo` VARCHAR(300) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_sec_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `lecciones` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `seccion_id` INT(11) NOT NULL,
  `titulo` VARCHAR(300) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `contenido` LONGTEXT DEFAULT NULL,
  `video_url` VARCHAR(500) DEFAULT NULL,
  `duracion_minutos` INT(11) DEFAULT NULL,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_lecciones_seccion` (`seccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `evaluaciones` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `capacitacion_id` INT(11) NOT NULL,
  `titulo` VARCHAR(300) NOT NULL,
  `descripcion` TEXT DEFAULT NULL,
  `tiempo_limite_minutos` INT(11) DEFAULT NULL,
  `intentos_permitidos` INT(11) NOT NULL DEFAULT 1,
  `mostrar_resultados` TINYINT(1) NOT NULL DEFAULT 1,
  `mostrar_respuestas_correctas` TINYINT(1) NOT NULL DEFAULT 0,
  `puntaje_total` DECIMAL(10,2) NOT NULL DEFAULT 100.00,
  `minimo_aprobacion` DECIMAL(5,2) NOT NULL DEFAULT 70.00,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_eval_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `preguntas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `evaluacion_id` INT(11) NOT NULL,
  `tipo_pregunta_id` INT(11) NOT NULL,
  `enunciado` TEXT NOT NULL,
  `imagen_url` VARCHAR(500) DEFAULT NULL,
  `puntaje` DECIMAL(10,2) NOT NULL DEFAULT 1.00,
  `orden` INT(11) NOT NULL DEFAULT 0,
  `requerida` TINYINT(1) NOT NULL DEFAULT 1,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_preg_evaluacion` (`evaluacion_id`),
  KEY `idx_preg_tipo` (`tipo_pregunta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `opciones_respuesta` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `pregunta_id` INT(11) NOT NULL,
  `texto` VARCHAR(1000) NOT NULL,
  `es_correcta` TINYINT(1) NOT NULL DEFAULT 0,
  `puntaje_parcial` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `orden` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_opc_pregunta` (`pregunta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pagos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `estudiante_id` INT(11) NOT NULL,
  `capacitacion_id` INT(11) NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `metodo_pago` VARCHAR(50) DEFAULT NULL,
  `numero_comprobante` VARCHAR(100) DEFAULT NULL,
  `fecha_pago` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` INT(11) NOT NULL,
  `observaciones` TEXT DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_pago_estudiante` (`estudiante_id`),
  KEY `idx_pago_capacitacion` (`capacitacion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `inscripciones` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `capacitacion_id` INT(11) NOT NULL,
  `estudiante_id` INT(11) NOT NULL COMMENT 'FK personas.id (proyección local)',
  `pago_id` INT(11) DEFAULT NULL,
  `fecha_inscripcion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_inicio` DATETIME DEFAULT NULL,
  `fecha_finalizacion` DATETIME DEFAULT NULL,
  `progreso_porcentaje` DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  `estado` ENUM('inscrito', 'en_progreso', 'completado', 'abandonado') NOT NULL DEFAULT 'inscrito',
  `calificacion_final` DECIMAL(5,2) DEFAULT NULL,
  `aprobado` TINYINT(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_insc_cap_est` (`capacitacion_id`, `estudiante_id`),
  KEY `idx_insc_estudiante` (`estudiante_id`),
  KEY `idx_insc_pago` (`pago_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `progreso_lecciones` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `inscripcion_id` INT(11) NOT NULL,
  `leccion_id` INT(11) NOT NULL,
  `completada` TINYINT(1) NOT NULL DEFAULT 0,
  `fecha_inicio` DATETIME DEFAULT NULL,
  `fecha_completada` DATETIME DEFAULT NULL,
  `tiempo_dedicado_minutos` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_prog_insc_lec` (`inscripcion_id`, `leccion_id`),
  KEY `idx_prog_leccion` (`leccion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `intentos_evaluacion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `evaluacion_id` INT(11) NOT NULL,
  `inscripcion_id` INT(11) NOT NULL,
  `numero_intento` INT(11) NOT NULL DEFAULT 1,
  `fecha_inicio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_finalizacion` DATETIME DEFAULT NULL,
  `puntaje_obtenido` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `puntaje_total` DECIMAL(10,2) DEFAULT NULL,
  `porcentaje` DECIMAL(5,2) DEFAULT NULL,
  `aprobado` TINYINT(1) DEFAULT NULL,
  `tiempo_utilizado_minutos` INT(11) DEFAULT NULL,
  `estado` ENUM('en_progreso', 'completado', 'abandonado') NOT NULL DEFAULT 'en_progreso',
  PRIMARY KEY (`id`),
  KEY `idx_intento_evaluacion` (`evaluacion_id`),
  KEY `idx_intento_inscripcion` (`inscripcion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `respuestas_estudiante` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `intento_evaluacion_id` INT(11) NOT NULL,
  `pregunta_id` INT(11) NOT NULL,
  `opcion_respuesta_id` INT(11) DEFAULT NULL,
  `texto_respuesta` TEXT DEFAULT NULL,
  `puntaje_obtenido` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `fecha_respuesta` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_rta_intento` (`intento_evaluacion_id`),
  KEY `idx_rta_pregunta` (`pregunta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `respuestas_multiples` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `respuesta_estudiante_id` INT(11) NOT NULL,
  `opcion_respuesta_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_rta_opc` (`respuesta_estudiante_id`, `opcion_respuesta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `certificados` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `inscripcion_id` INT(11) NOT NULL,
  `numero_certificado` VARCHAR(100) NOT NULL,
  `fecha_emision` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_aprobacion_real` DATETIME DEFAULT NULL,
  `fecha_retroactiva` DATETIME DEFAULT NULL,
  `es_retroactivo` TINYINT(1) NOT NULL DEFAULT 0,
  `justificacion_retroactiva` TEXT DEFAULT NULL,
  `fecha_vencimiento` DATE DEFAULT NULL,
  `url_certificado` VARCHAR(500) DEFAULT NULL,
  `url_verificacion_publica` VARCHAR(500) DEFAULT NULL,
  `hash_verificacion` VARCHAR(255) DEFAULT NULL,
  `codigo_qr` TEXT DEFAULT NULL,
  `firma_digital` TEXT DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_num_certificado` (`numero_certificado`),
  KEY `idx_cert_inscripcion` (`inscripcion_id`),
  KEY `idx_cert_hash` (`hash_verificacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `auditoria_certificados_retroactivos` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `certificado_id` INT(11) NOT NULL,
  `fecha_aprobacion_real` DATETIME NOT NULL,
  `fecha_retroactiva` DATETIME NOT NULL,
  `justificacion` TEXT NOT NULL,
  `emitido_por` INT(11) NOT NULL,
  `fecha_emision` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_aud_certificado` (`certificado_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `configuracion_alertas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `dias_antes_vencimiento` INT(11) NOT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dias_alerta` (`dias_antes_vencimiento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `alertas_vencimiento` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `certificado_id` INT(11) NOT NULL,
  `dias_restantes` INT(11) NOT NULL,
  `fecha_envio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `enviado` TINYINT(1) NOT NULL DEFAULT 0,
  `fecha_vencimiento` DATE NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_alert_certificado` (`certificado_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `documentos_legales` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `tipo` VARCHAR(50) NOT NULL,
  `titulo` VARCHAR(200) NOT NULL,
  `contenido` LONGTEXT NOT NULL,
  `version` VARCHAR(20) NOT NULL DEFAULT '1.0',
  `requiere_firma_digital` TINYINT(1) NOT NULL DEFAULT 0,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creado_por` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_doc_tipo` (`tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `aceptaciones_politicas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` INT(11) NOT NULL,
  `documento_legal_id` INT(11) NOT NULL,
  `version` VARCHAR(20) NOT NULL,
  `firma_digital` TEXT DEFAULT NULL,
  `ip_address` VARCHAR(45) DEFAULT NULL,
  `user_agent` VARCHAR(500) DEFAULT NULL,
  `fecha_aceptacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_usuario_documento` (`usuario_id`, `documento_legal_id`),
  KEY `idx_acep_documento` (`documento_legal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `resenas` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `inscripcion_id` INT(11) NOT NULL,
  `calificacion` TINYINT(1) NOT NULL,
  `comentario` TEXT DEFAULT NULL,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resena_inscripcion` (`inscripcion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `configuracion_sesion` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `tiempo_inactividad_minutos` INT(11) DEFAULT NULL,
  `tiempo_maximo_sesion_minutos` INT(11) DEFAULT NULL,
  `activo` TINYINT(1) NOT NULL DEFAULT 1,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `creado_por` INT(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `usuario_id` INT(11) NOT NULL,
  `token_hash` VARCHAR(255) NOT NULL,
  `used` TINYINT(1) NOT NULL DEFAULT 0,
  `expires_at` DATETIME NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_token_hash` (`token_hash`),
  KEY `idx_usuario_expiry` (`usuario_id`, `expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `assistant_empresa_quota` (
  `empresa_id` INT(11) NOT NULL,
  `token_quota_monthly` INT(11) UNSIGNED NOT NULL DEFAULT 0,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`empresa_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `assistant_empresa_usage` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `empresa_id` INT(11) NOT NULL,
  `month` VARCHAR(7) NOT NULL,
  `tokens_used` INT(11) UNSIGNED NOT NULL DEFAULT 0,
  `fecha_creacion` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_assistant_empresa_month` (`empresa_id`, `month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
