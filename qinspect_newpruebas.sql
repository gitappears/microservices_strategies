-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 23-02-2026 a las 10:04:22
-- Versión del servidor: 5.7.42
-- Versión de PHP: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `qinspect_newpruebas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `accionesSistemaUsuario`
--

CREATE TABLE `accionesSistemaUsuario` (
  `idAccion` int(20) NOT NULL,
  `acciones` json NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `adjuntosCapacitacion`
--

CREATE TABLE `adjuntosCapacitacion` (
  `idAdjCapacitacion` int(25) NOT NULL COMMENT 'id ajunto capacitación',
  `nombreAdjunto` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fkIdCapacitacion` int(25) NOT NULL COMMENT 'foreing key de id capacitación',
  `fkIdTipoAdjunto` int(25) NOT NULL COMMENT 'foreing key de tipo de archivo/adjunto'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `adjuntosInspeccion`
--

CREATE TABLE `adjuntosInspeccion` (
  `idAdjunto` int(20) NOT NULL,
  `urlAdjunto` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `obsAdjunto` varchar(10000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'observación adjunto',
  `idRtaInspeccion` int(20) NOT NULL COMMENT 'id de la respuesta de la inspección'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `adjunto_capacitacion`
--

CREATE TABLE `adjunto_capacitacion` (
  `id_Adj_Capacitacion` int(25) NOT NULL,
  `Nombre_Adjunto` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_Capacitacion1` int(25) NOT NULL,
  `id_Tipo_Adjunto1` int(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertasMantenimiento`
--

CREATE TABLE `alertasMantenimiento` (
  `id` int(11) NOT NULL,
  `tipo` enum('TAREA_SIN_EJECUTOR_24H','REEVALUACION_EM_VENCIDA','REEVALUACION_EM_URGENTE','REEVALUACION_EM_PROXIMA') COLLATE utf8mb4_unicode_ci NOT NULL,
  `prioridad` enum('BAJA','MEDIA','ALTA','CRITICA') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'MEDIA',
  `titulo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mensaje` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_referencia` int(11) DEFAULT NULL COMMENT 'ID de la entidad relacionada (tarea, evaluación, etc.)',
  `tipo_referencia` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo de entidad (tarea, evaluacion, etc.)',
  `base_datos` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Base de datos donde se generó la alerta',
  `leida` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_leida` datetime DEFAULT NULL,
  `usuario_leida` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tabla de alertas del sistema de mantenimiento';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alertasMantenimientoDestinatarios`
--

CREATE TABLE `alertasMantenimientoDestinatarios` (
  `id` int(11) NOT NULL,
  `id_alerta` int(11) NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rol` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Rol del destinatario',
  `enviado` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_envio` datetime DEFAULT NULL,
  `error_envio` text COLLATE utf8mb4_unicode_ci,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Destinatarios de alertas por email';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacenInventario`
--

CREATE TABLE `almacenInventario` (
  `idProducto` int(11) NOT NULL,
  `idAlmacen` int(2) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idTipoReserva` int(2) NOT NULL,
  `cantidad` float(20,2) NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apilog`
--

CREATE TABLE `apilog` (
  `apiConsecutivo` int(11) NOT NULL,
  `funcionApiName` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sqlRequest` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `checkIn` tinyint(1) DEFAULT '0',
  `checkOut` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `area`
--

CREATE TABLE `area` (
  `idArea` int(11) NOT NULL,
  `nombreArea` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estadoArea` int(1) NOT NULL DEFAULT '1',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `binomio_logs`
--

CREATE TABLE `binomio_logs` (
  `id` bigint(20) NOT NULL,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `level` enum('DEBUG','INFO','WARN','ERROR') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'INFO',
  `operation` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'CREATE_BINOMIO, UPDATE_BINOMIO, DEACTIVATE_BINOMIO, VALIDATION_ERROR',
  `user` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Usuario que realiza la operación',
  `base` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Base de datos donde se ejecutó la operación',
  `data` json DEFAULT NULL COMMENT 'Datos estructurados de la operación (placas, kilometrajes, tramos, etc.)',
  `result` enum('SUCCESS','FAILURE') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Resultado de la operación',
  `error_message` text COLLATE utf8mb4_unicode_ci COMMENT 'Mensaje de error si result=FAILURE',
  `error_stack` text COLLATE utf8mb4_unicode_ci COMMENT 'Stack trace del error si aplica',
  `duration_ms` int(11) DEFAULT NULL COMMENT 'Tiempo de ejecución en milisegundos',
  `metadata` json DEFAULT NULL COMMENT 'Metadatos adicionales (requestId, ipAddress, userAgent, etc.)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Logs estructurados de operaciones de binomios para auditoría y monitoreo';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cabezoteVehiculo`
--

CREATE TABLE `cabezoteVehiculo` (
  `idCabezote` int(10) NOT NULL,
  `cilindraje` int(10) NOT NULL,
  `combustible` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numeroMotor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numeroSerie` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lineaVeh` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placaCabezote` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificacionEm`
--

CREATE TABLE `calificacionEm` (
  `id` int(11) NOT NULL,
  `valorMinimo` int(3) NOT NULL,
  `valorMaximo` int(3) NOT NULL,
  `adjetivo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipoMostrar` tinyint(1) NOT NULL,
  `usuarioControl` bigint(20) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificacionesServicioConductor`
--

CREATE TABLE `calificacionesServicioConductor` (
  `id` int(11) NOT NULL,
  `id_programacion_mtto` int(11) NOT NULL COMMENT 'Relación lógica a programacion_mtto',
  `documento_conductor` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Documento del conductor que califica',
  `nombre_conductor` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre completo del conductor',
  `calificacion_general` tinyint(4) NOT NULL COMMENT 'Calificación general de 1 a 5 estrellas',
  `comentarios` text COLLATE utf8mb4_unicode_ci COMMENT 'Comentarios adicionales del conductor',
  `fecha_calificacion` datetime NOT NULL COMMENT 'Fecha y hora en que se realizó la calificación',
  `usuario_control` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Usuario que registró la calificación',
  `fecha_control` datetime NOT NULL COMMENT 'Fecha de registro en el sistema'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Calificaciones de servicio de mantenimiento por conductores (RF-MT-029)';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `calificacionesServicioConductorDetalle`
--

CREATE TABLE `calificacionesServicioConductorDetalle` (
  `id` int(11) NOT NULL,
  `id_calificacion` int(11) NOT NULL COMMENT 'Relación lógica a calificacionesServicioConductor',
  `criterio` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre del criterio calificado',
  `calificacion` tinyint(4) NOT NULL COMMENT 'Calificación del criterio de 1 a 5 estrellas',
  `fecha_control` datetime NOT NULL COMMENT 'Fecha de registro'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Detalle de calificaciones por criterios específicos (RF-MT-029)';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `capacitacion`
--

CREATE TABLE `capacitacion` (
  `idCapacitacion` int(25) NOT NULL,
  `titulo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `enunciado` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estadoCapacitacion` int(1) NOT NULL DEFAULT '1',
  `idCapacitador` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaCreacion` date NOT NULL,
  `minAprobacion` int(11) NOT NULL,
  `porcentajeEficacia` int(11) NOT NULL,
  `tipoCapacitacion` int(1) NOT NULL DEFAULT '1' COMMENT '1 capacitación, 2 certificación',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `capacitacion_v2`
--

CREATE TABLE `capacitacion_v2` (
  `id_Capacitacion` int(25) NOT NULL,
  `Tiutlo_Capacitacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Enunciado_Capacitacion` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Estado_Capacitacion` int(1) NOT NULL DEFAULT '1',
  `id_Capacitador` bigint(20) NOT NULL,
  `Fecha_creacion` date NOT NULL,
  `min_aprobacion` int(11) NOT NULL,
  `porc_eficacia` int(11) NOT NULL,
  `tipo_capacitacion` int(1) NOT NULL DEFAULT '1' COMMENT '1 capacitación, 2 certificación'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargos`
--

CREATE TABLE `cargos` (
  `idCargo` int(20) NOT NULL,
  `nombreCargo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoCargo` enum('ACTIVO','INACTIVO','','') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '1 = Activo - 0 = Inactivo',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cargos de la empresa para identificar mejor los roles';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Cargos`
--

CREATE TABLE `Cargos` (
  `Carg_id` int(20) NOT NULL,
  `Carg_Descripcion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Carg_estado` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Cargos de la empresa para identificar mejor los roles';

--
-- Disparadores `Cargos`
--
DELIMITER $$
CREATE TRIGGER `actuCargos` BEFORE INSERT ON `Cargos` FOR EACH ROW INSERT INTO `cargos`(`idCargo`, `nombreCargo`, `estadoCargo`, `usuarioControl`) VALUES (new.`Carg_id`, new.`Carg_Descripcion`,new.`Carg_estado`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoriaItems`
--

CREATE TABLE `categoriaItems` (
  `idCategoriaItem` int(20) NOT NULL,
  `nombreCategoriaItem` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoriaLicencias`
--

CREATE TABLE `categoriaLicencias` (
  `idCategoriaLicencia` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombreCatLicencia` varchar(800) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoCatLicencia` int(1) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Categoria_item`
--

CREATE TABLE `Categoria_item` (
  `Cat_Item_Id` int(20) NOT NULL,
  `Cat_Item_Descripcion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `Categoria_item`
--
DELIMITER $$
CREATE TRIGGER `actuCatItem` BEFORE INSERT ON `Categoria_item` FOR EACH ROW INSERT INTO `categoriaItems`(`idCategoriaItem`, `nombreCategoriaItem`,  `usuarioControl`) VALUES (new.`Cat_Item_Id`, new.`Cat_Item_Descripcion`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Categoria_licencias`
--

CREATE TABLE `Categoria_licencias` (
  `Cat_lic_id` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Cat_lic_descripcion` varchar(800) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `Categoria_licencias`
--
DELIMITER $$
CREATE TRIGGER `actuCatLicencia` BEFORE INSERT ON `Categoria_licencias` FOR EACH ROW INSERT INTO `categoriaLicencias`(`idCategoriaLicencia`, `nombreCatLicencia`, `estadoCatLicencia`, `usuarioControl`) VALUES (new.`Cat_lic_id`, new.`Cat_lic_descripcion`, new.`Estado`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cedulasAutorizaAlmacen`
--

CREATE TABLE `cedulasAutorizaAlmacen` (
  `idAutoriza` int(11) NOT NULL,
  `CcUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idAlmacen` int(11) NOT NULL,
  `estadoAutoriza` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `UduarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ciudad`
--

CREATE TABLE `ciudad` (
  `idCiudad` int(20) NOT NULL,
  `nombreCiudad` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkIdDepartamento` int(1) NOT NULL COMMENT 'foreing key de id departamentos',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='lista de todas la ciudades de colombia';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Ciudad`
--

CREATE TABLE `Ciudad` (
  `Ciu_Id` int(20) NOT NULL,
  `Ciu_Nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Dpt_Id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='lista de todas la ciudades de colombia';

--
-- Disparadores `Ciudad`
--
DELIMITER $$
CREATE TRIGGER `actuCiudad` BEFORE INSERT ON `Ciudad` FOR EACH ROW INSERT INTO `ciudad`(`idCiudad`, `nombreCiudad`, `fkIdDepartamento`, `usuarioControl`) VALUES ( new.`Ciu_Id`, new.`Ciu_Nombre`, new.`Dpt_Id`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `configuracionAlertasMantenimiento`
--

CREATE TABLE `configuracionAlertasMantenimiento` (
  `id` int(11) NOT NULL,
  `tipo_alerta` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activa` tinyint(1) NOT NULL DEFAULT '1',
  `notificacion_interna` tinyint(1) NOT NULL DEFAULT '1',
  `notificacion_email` tinyint(1) NOT NULL DEFAULT '1',
  `dias_anticipacion` int(3) DEFAULT NULL COMMENT 'Días de anticipación para alertas',
  `horas_anticipacion` int(3) DEFAULT NULL COMMENT 'Horas de anticipación para alertas',
  `roles_notificar` text COLLATE utf8mb4_unicode_ci COMMENT 'JSON array de roles a notificar',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Configuración de alertas del sistema';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `correctivasLLantas`
--

CREATE TABLE `correctivasLLantas` (
  `idCorrectivasLlanta` bigint(15) NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idProducto` int(11) NOT NULL,
  `serialLlanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posicion` int(2) NOT NULL,
  `correctivas` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rotacionLlanta` tinyint(1) NOT NULL,
  `userControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `criterioEvaluacionEm`
--

CREATE TABLE `criterioEvaluacionEm` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `peso` int(3) NOT NULL,
  `tipoMostrar` tinyint(1) NOT NULL,
  `usuarioControl` bigint(20) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `criticidadEm`
--

CREATE TABLE `criticidadEm` (
  `id` int(11) NOT NULL,
  `adjetivo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipoMostrar` tinyint(1) NOT NULL,
  `usuarioControl` bigint(20) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursosCertificados`
--

CREATE TABLE `cursosCertificados` (
  `idCurso` int(11) NOT NULL,
  `curso` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `empresa` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `horas` int(3) NOT NULL,
  `estadoCertificado` int(1) NOT NULL,
  `certificado` int(1) NOT NULL DEFAULT '1',
  `formatoFondo` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursosCertificadosCapacitacion`
--

CREATE TABLE `cursosCertificadosCapacitacion` (
  `idCertificado` int(11) NOT NULL,
  `idCurso` int(11) NOT NULL,
  `idCapacitacion` int(25) NOT NULL,
  `idUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaIni` date NOT NULL,
  `fechaFin` date DEFAULT NULL,
  `aprobado` int(11) NOT NULL DEFAULT '0',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `facturaCobro` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'solo aplica para appear cobro de los cursos',
  `fechaCobro` date DEFAULT NULL COMMENT 'solo aplica para appear cobro de los cursos',
  `pagoRealizado` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'solo aplica para appear pago de los cursos',
  `fechaPagoFactura` date DEFAULT NULL COMMENT 'solo aplica para appear pago de los cursos',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursosCertificadosConductor`
--

CREATE TABLE `cursosCertificadosConductor` (
  `idUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idCurso` int(11) NOT NULL,
  `fechaVencimiento` date NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos_certificados`
--

CREATE TABLE `cursos_certificados` (
  `id_Curso` int(11) NOT NULL,
  `Curso` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Empresa` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Horas` int(11) NOT NULL,
  `Status` int(11) NOT NULL,
  `certificado` int(11) NOT NULL DEFAULT '1',
  `formato_fondo` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos_certificados_has_capacitacion`
--

CREATE TABLE `cursos_certificados_has_capacitacion` (
  `id_Certificado` int(11) NOT NULL,
  `id_Curso` int(11) NOT NULL,
  `id_Capacitacion` int(11) NOT NULL,
  `id_Usuario` bigint(20) NOT NULL,
  `Fecha` date NOT NULL,
  `fecha_fin` date DEFAULT NULL,
  `paso_curso` int(11) NOT NULL DEFAULT '0',
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `factura_cobro` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'solo aplica para appear cobro de los cursos',
  `fecha_cobro` date DEFAULT NULL COMMENT 'solo aplica para appear cobro de los cursos',
  `pago_realizado` varchar(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'solo aplica para appear pago de los cursos',
  `fecha_pago_factura` date DEFAULT NULL COMMENT 'solo aplica para appear pago de los cursos'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `cursos_certificados_has_capacitacion`
--
DELIMITER $$
CREATE TRIGGER `actualizacion_curso` AFTER UPDATE ON `cursos_certificados_has_capacitacion` FOR EACH ROW REPLACE INTO `cursos_certificados_has_conductor`(`id_Usuario`, `id_Curso`, `fecha_vencimiento`) VALUES (New.id_Usuario,New.id_Curso, DATE_ADD(CURDATE(), INTERVAL 1 YEAR))
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_notificacion` AFTER INSERT ON `cursos_certificados_has_capacitacion` FOR EACH ROW UPDATE `Notificaciones`  SET `newcertificado`=newcertificado+1  WHERE idusuario=New.id_Usuario
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cursos_certificados_has_conductor`
--

CREATE TABLE `cursos_certificados_has_conductor` (
  `id_Usuario` bigint(20) NOT NULL,
  `id_Curso` int(11) NOT NULL,
  `fecha_vencimiento` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Departamento`
--

CREATE TABLE `Departamento` (
  `Dpt_Id` int(20) NOT NULL,
  `Dpt_Nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='lista de todos los departamentos del pais';

--
-- Disparadores `Departamento`
--
DELIMITER $$
CREATE TRIGGER `actuDepartment` BEFORE INSERT ON `Departamento` FOR EACH ROW INSERT INTO `departamento`(`idDepartamento`, `nombreDpto`, `usuarioControl`) VALUES (new.`Dpt_Id`, new.`Dpt_Nombre`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `departamento`
--

CREATE TABLE `departamento` (
  `idDepartamento` int(20) NOT NULL,
  `nombreDpto` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='lista de todos los departamentos del pais';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `desmontesLlantas`
--

CREATE TABLE `desmontesLlantas` (
  `idDesmonteLlanta` bigint(15) NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idProducto` int(11) NOT NULL,
  `serialLlanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posicion` int(2) NOT NULL,
  `idSede` int(11) NOT NULL,
  `idBodega` int(11) NOT NULL,
  `observacion` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detDevInventario`
--

CREATE TABLE `detDevInventario` (
  `idDevInventario` bigint(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idReserva` int(2) NOT NULL,
  `cantidadEntCons` float(20,2) NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `observacion` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detEntradaInv`
--

CREATE TABLE `detEntradaInv` (
  `idEncEntradaInv` int(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL COMMENT 'hace referencia al status de vida',
  `idReserva` int(2) NOT NULL COMMENT 'hace referencia al proposito',
  `cantidadIngresar` float(20,2) NOT NULL,
  `valUnitario` float(20,2) NOT NULL DEFAULT '0.00',
  `iva` float(4,2) NOT NULL COMMENT 'porcentaje de iva',
  `observacionEntrada` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detEvaluacionProveedor`
--

CREATE TABLE `detEvaluacionProveedor` (
  `idEncEvaluacion` int(11) NOT NULL,
  `idCriterio` int(11) NOT NULL,
  `validacion` enum('C','NC','CP','NA') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'c=cumple, nc=no cumple, cp=cumple parcial,na=no aplica'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detInspeccionLlantas`
--

CREATE TABLE `detInspeccionLlantas` (
  `idDetalle` bigint(15) NOT NULL,
  `idEncInsp` bigint(15) NOT NULL,
  `externa` float(7,1) NOT NULL,
  `central` float(7,1) NOT NULL,
  `interna` float(7,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detInventarios`
--

CREATE TABLE `detInventarios` (
  `idInventario` int(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idReserva` int(2) NOT NULL,
  `cantidadSistema` int(11) NOT NULL COMMENT 'cantidad que tiene en sistema en el momento de realizar el inventario físico',
  `cantidadInventario` int(11) NOT NULL COMMENT 'cantidad real del inventario en el momento',
  `cantidadDevuelta` int(11) NOT NULL COMMENT 'cantidad que devuelve a bodega por ajuste de stock',
  `cantidadRecibida` int(11) NOT NULL COMMENT 'cantidad que recibe de bodega por ajuste de stock',
  `observacionDetalle` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'observación para detalle del inventario'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detSalidaProveedor`
--

CREATE TABLE `detSalidaProveedor` (
  `idEncSalidaProv` int(5) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLoteSalida` int(2) NOT NULL,
  `idReservaAlmacen` int(2) NOT NULL,
  `cantidadSalida` float(20,2) NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `obsSalidaProve` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `detSalidaProveedor`
--
DELIMITER $$
CREATE TRIGGER `updateInvSalPro` BEFORE INSERT ON `detSalidaProveedor` FOR EACH ROW UPDATE `almacenInventario` SET `cantidad`=`cantidad`-NEW.cantidadSalida WHERE `idProducto`=NEW.idProducto AND `idAlmacen`=(SELECT idBodega FROM encSalidaProveedor WHERE idEncSalidaProv=NEW.idEncSalidaProv) AND `idLote`=NEW.idLoteSalida AND `idTipoReserva`=NEW.idReservaAlmacen AND `valUnitario`=NEW.valUnitario AND `iva`=NEW.iva
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detSolicitudMat`
--

CREATE TABLE `detSolicitudMat` (
  `idDetSolicitud` int(1) NOT NULL,
  `idSolicitudMat` int(6) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `cantidad` float(20,2) NOT NULL,
  `obsSolicitud` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detTranferEm`
--

CREATE TABLE `detTranferEm` (
  `idSalidaMaterial` bigint(12) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idReserva` int(2) NOT NULL,
  `cantidadEntCons` float(20,2) NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `observacionSalida` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detTrasladoMoviles`
--

CREATE TABLE `detTrasladoMoviles` (
  `idTrasladoMovil` int(9) NOT NULL,
  `idReserva` int(2) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLoteTraslado` int(2) NOT NULL,
  `cantidadTrasladar` float(20,2) NOT NULL,
  `obsTraslado` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detTrasladoReservas`
--

CREATE TABLE `detTrasladoReservas` (
  `idTrasladoReserva` int(8) NOT NULL,
  `idOldRese` int(11) NOT NULL,
  `idNewRese` int(11) NOT NULL,
  `idProTrasRese` int(11) NOT NULL COMMENT 'id producto traslado reserva',
  `idLoteTrasRese` int(2) NOT NULL COMMENT 'id lote traslado reserva',
  `cantTrasReserva` float(20,2) NOT NULL COMMENT 'cantidad traslado reserva',
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `obsTrasReversa` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'observación traslado reserva'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `detTrasladoReservas`
--
DELIMITER $$
CREATE TRIGGER `updateInvTranferNew` BEFORE INSERT ON `detTrasladoReservas` FOR EACH ROW INSERT INTO `almacenInventario`(`idProducto`, `idAlmacen`, `idLote`, `idTipoReserva`, `cantidad`) VALUES (NEW.idProTrasRese,(SELECT idBodega FROM encTrasladoReservas WHERE idTrasladoReserva=NEW.idTrasladoReserva),New.idLoteTrasRese,New.idNewRese,New.cantTrasReserva)on duplicate KEY UPDATE cantidad=cantidad+New.cantTrasReserva
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateInvTranferOld` BEFORE INSERT ON `detTrasladoReservas` FOR EACH ROW UPDATE `almacenInventario` SET `cantidad`=cantidad-New.cantTrasReserva WHERE `idProducto`=NEW.idProTrasRese AND `idAlmacen`=(SELECT idBodega FROM encTrasladoReservas WHERE idTrasladoReserva=NEW.idTrasladoReserva) AND `idLote`=New.idLoteTrasRese AND `idTipoReserva`=New.idOldRese AND `valUnitario`=New.valUnitario AND `iva`=New.iva
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `disposicionFinalLlantas`
--

CREATE TABLE `disposicionFinalLlantas` (
  `idDispFinalLlanta` int(15) NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idProducto` int(11) NOT NULL,
  `serialLlanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posicion` int(2) NOT NULL,
  `numCertDispFinal` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imgActaDispFinal` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `userControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentosConductor`
--

CREATE TABLE `documentosConductor` (
  `idDocConductor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkIdDocumento` int(20) NOT NULL,
  `numeroRegistro` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `catLic` varchar(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'cat licencia',
  `lugarExpedicion` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaVencimiento` date DEFAULT NULL,
  `urlDocumento` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Dcocumentacion del conductor de la empresa';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentosFlota`
--

CREATE TABLE `documentosFlota` (
  `fkPlacaFlota` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkIdDocumento` int(20) NOT NULL COMMENT 'id del documento de vencimiento',
  `numeroRegistro` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Fecha final Certificado de tradicion y libertad del remolque',
  `fechaVencimiento` date DEFAULT NULL,
  `urlDocumento` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idItem` int(20) DEFAULT '0' COMMENT ' si aplica para item de inspeccion de lo contrario iria 0',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'fecha control del movimiento',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'usuario que realiza el movimiento'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Documentacion de toda la flota';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Documentos_conductor`
--

CREATE TABLE `Documentos_conductor` (
  `DocCond_Id` int(20) NOT NULL,
  `DocCond_Lice_Cond` int(20) NOT NULL,
  `DocCond_CatLiceCond` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_NumeroDoc` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Dcocumentacion del conductor de la empresa';

--
-- Disparadores `Documentos_conductor`
--
DELIMITER $$
CREATE TRIGGER `actuDocumentoConduct` BEFORE UPDATE ON `Documentos_conductor` FOR EACH ROW INSERT INTO `documentosConductor`(`idDocConductor`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `usuarioControl`) VALUES ( new.`Pers_NumeroDoc`,1,new.`DocCond_Lice_Cond`,null,'','123456788' )on duplicate key UPDATE `numeroRegistro`=new.`DocCond_Lice_Cond`
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertDocumentosConduct` BEFORE INSERT ON `Documentos_conductor` FOR EACH ROW INSERT INTO `documentosConductor`(`idDocConductor`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`,  `usuarioControl`) VALUES ( new.`Pers_NumeroDoc`,1,new.`DocCond_Lice_Cond`,null,'','123456788' )on duplicate key UPDATE `numeroRegistro`=new.`DocCond_Lice_Cond`
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Documentos_Remolque`
--

CREATE TABLE `Documentos_Remolque` (
  `DocRemol_Id` int(11) NOT NULL,
  `DocRemol_CltNumero` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Certificado de tradicion y libertad del remolque',
  `DocRemol_CltFecha` date DEFAULT NULL COMMENT 'Fecha inicial Certificado de tradicion y libertad del remolque',
  `DocRemol_CltFechaFinal` date DEFAULT NULL COMMENT 'Fecha final Certificado de tradicion y libertad del remolque',
  `DocRemol_RegNumero` int(20) DEFAULT NULL,
  `DocRemol_RegFecha` date DEFAULT NULL,
  `DocRemol_RegFechaFinal` date DEFAULT NULL,
  `DocRemol_CertLineaNumero` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Certificado de lineas de vida',
  `DocRemol_CertLineaFecha` date DEFAULT NULL COMMENT 'Fecha inicial Certificado de lineas de vida',
  `DocRemol_CertLineaFechaFin` date DEFAULT NULL COMMENT 'Fecha final Certificado de lineas de vida',
  `DocRemol_TarProNumero` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'numero Tarjeta de propiedad del remolque',
  `DocRemol_TarProFecha` date DEFAULT NULL COMMENT 'Fecha inicial Tarjeta de propiedad del remolque',
  `DocRemol_TarProFechaFin` date DEFAULT NULL COMMENT 'Fecha final Tarjeta de propiedad del remolque',
  `DocRemol_TAforoNumero` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Numero Tabla de Aforo',
  `DocRemol_TAforoFecha` date DEFAULT NULL COMMENT 'Fecha inicial Tabla de Aforo',
  `DocRemol_TAforoFechaFin` date DEFAULT NULL COMMENT 'Fecha Final Tabla de Aforo',
  `DocRemol_CertPruHidroNumero` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Numero Certificado Prueba Hidrostática (vigencia 2 años)',
  `DocRemol_CertProHidroFecha` date DEFAULT NULL COMMENT 'Fecha incial Certificado Prueba Hidrostática (vigencia 2 años)',
  `DocRemol_CertProHidroFechaFin` date DEFAULT NULL COMMENT 'Fecha Final Certificado Prueba Hidrostática (vigencia 2 años)',
  `DocRemol_CertKingPinNumero` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Certificado de luz negra para la quinta rueda Y King Pin  (vigencia máxima 6 meses)',
  `DocRemol_CertKingPinFecha` date DEFAULT NULL COMMENT 'F I Certificado de luz negra para la quinta rueda Y King Pin  (vigencia máxima 6 meses)',
  `DocRemol_CertKingPinFechaFin` date DEFAULT NULL COMMENT 'F F Certificado de luz negra para la quinta rueda Y King Pin  (vigencia máxima 6 meses)',
  `Remol_Id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Documentacion del remolque para el control del preoperaciona';

--
-- Disparadores `Documentos_Remolque`
--
DELIMITER $$
CREATE TRIGGER `actuCkinpingRemol` BEFORE UPDATE ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 13, new.`DocRemol_CertKingPinNumero`, new.DocRemol_CertKingPinFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_CertKingPinNumero` ,fechaVencimiento=new.DocRemol_CertKingPinFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actuCltRemol` BEFORE UPDATE ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 9, new.`DocRemol_CltNumero`, new.DocRemol_CltFechaFinal, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_CltNumero` ,fechaVencimiento=new.DocRemol_CltFechaFinal, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actuCphRemol` BEFORE UPDATE ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 12, new.`DocRemol_CertPruHidroNumero`, new.DocRemol_CertProHidroFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_CertPruHidroNumero` ,fechaVencimiento=new.DocRemol_CertProHidroFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actuTablaforoRemol` BEFORE UPDATE ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 11, new.`DocRemol_TarProNumero`, new.DocRemol_TarProFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_TarProNumero` ,fechaVencimiento=new.DocRemol_TarProFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_faforo` AFTER UPDATE ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `item_has_fv_remolque`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (9,New.Remol_Id,new.DocRemol_TAforoFechaFin) on duplicate key update fecha_vencimiento=new.DocRemol_TAforoFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_fcertlineavida` AFTER UPDATE ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `item_has_fv_remolque`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (119,New.Remol_Id,new.DocRemol_CertLineaFechaFin) on duplicate key update fecha_vencimiento=new.DocRemol_CertLineaFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_fhidrostatica` AFTER UPDATE ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `item_has_fv_remolque`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (8,New.Remol_Id,new.DocRemol_CertProHidroFechaFin) on duplicate key update fecha_vencimiento=new.DocRemol_CertProHidroFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actutLinevidaRemol` BEFORE UPDATE ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 10, new.`DocRemol_CertLineaNumero`, new.DocRemol_CertLineaFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_CertLineaNumero` ,fechaVencimiento=new.DocRemol_CertLineaFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ingresar_fcertlineavida` AFTER INSERT ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `item_has_fv_remolque`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (119,New.Remol_Id,new.DocRemol_CertLineaFechaFin) on duplicate key update fecha_vencimiento=new.DocRemol_CertLineaFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertCkinpingRemol` BEFORE INSERT ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 13, new.`DocRemol_CertKingPinNumero`, new.DocRemol_CertKingPinFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_CertKingPinNumero` ,fechaVencimiento=new.DocRemol_CertKingPinFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertCltRemol` BEFORE INSERT ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 9, new.`DocRemol_CltNumero`, new.DocRemol_CltFechaFinal, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_CltNumero` ,fechaVencimiento=new.DocRemol_CltFechaFinal, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertCphRemol` BEFORE INSERT ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 12, new.`DocRemol_CertPruHidroNumero`, new.DocRemol_CertProHidroFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_CertPruHidroNumero` ,fechaVencimiento=new.DocRemol_CertProHidroFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertLinevidaRemol` BEFORE INSERT ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 10, new.`DocRemol_CertLineaNumero`, new.DocRemol_CertLineaFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_CertLineaNumero` ,fechaVencimiento=new.DocRemol_CertLineaFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertTablaforoRemol` BEFORE INSERT ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Remol_Placa` FROM `Remolque` WHERE Remolque.`Remol_Id`=new.Remol_Id), 11, new.`DocRemol_TarProNumero`, new.DocRemol_TarProFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocRemol_TarProNumero` ,fechaVencimiento=new.DocRemol_TarProFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertar_faforo` AFTER INSERT ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `item_has_fv_remolque`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (9,New.Remol_Id,new.DocRemol_TAforoFechaFin) on duplicate key update fecha_vencimiento=new.DocRemol_TAforoFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertar_fhidrostatica` AFTER INSERT ON `Documentos_Remolque` FOR EACH ROW INSERT INTO `item_has_fv_remolque`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (8,New.Remol_Id,new.DocRemol_CertProHidroFechaFin) on duplicate key update fecha_vencimiento=new.DocRemol_CertProHidroFechaFin
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Documentos_Vehiculo`
--

CREATE TABLE `Documentos_Vehiculo` (
  `DocVeh_Id` int(20) NOT NULL,
  `DocVeh_CltNumero` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Numero Certificado de tradicion y libertad  del cabezote',
  `DocVeh_CltFecha` date DEFAULT NULL COMMENT 'Fecha I Certificado de tradicion y libertad  del cabezote',
  `DocVeh_CltFechaFin` date DEFAULT NULL COMMENT 'Fecha F Certificado de tradicion y libertad  del cabezote',
  `DocVeh_LicTranNumero` bigint(20) NOT NULL,
  `DocVeh_LicTranFecha` date DEFAULT NULL,
  `DocVeh_LicTranFechaFin` date DEFAULT NULL,
  `DocVeh_SoatNumero` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DocVeh_SoatFecha` date DEFAULT NULL,
  `DocVeh_SoatFechaFin` date DEFAULT NULL,
  `DocVeh_ReTecNumero` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Numero Certificado Revisión Tecnicomecánica ',
  `DocVeh_ReTecFecha` date DEFAULT NULL COMMENT 'Fecha I Certificado Revisión  Tecnicomecánica ',
  `DocVeh_ReTecFechaFin` date DEFAULT NULL COMMENT 'Fecha F Certificado Revisión  Tecnicomecánica ',
  `DocVeh_PoExtraNumero` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Numero Póliza de Responsabilidad Civil y Extracontractual',
  `DocVeh_PoExtraFecha` date DEFAULT NULL COMMENT 'Fecha I Póliza de Responsabilidad Civil y Extracontractual',
  `DocVeh_PoExtraFechaFin` date DEFAULT NULL COMMENT 'FEcha F Póliza de Responsabilidad Civil y Extracontractual',
  `DocVeh_RCHidroNumero` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Numero Póliza RC Hidrocarburos',
  `DocVeh_RCHidroFecha` date DEFAULT NULL COMMENT 'Fecha Póliza RC Hidrocarburos',
  `DocVeh_RCHidroFechaFin` date DEFAULT NULL,
  `DocVeh_CertQRNumero` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `DocVeh_CertQRFecha` date DEFAULT NULL,
  `DocVeh_CertQRFechaFin` date DEFAULT NULL,
  `Veh_Id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Documentacion del Vehiculo';

--
-- Disparadores `Documentos_Vehiculo`
--
DELIMITER $$
CREATE TRIGGER `actCltVehiculo` BEFORE UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 5, new.`DocVeh_CltNumero`, new.DocVeh_CltFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_CltNumero` ,fechaVencimiento=new.DocVeh_CltFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actuTecnicomeVehiculo` BEFORE UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 3, new.`DocVeh_ReTecNumero`, new.DocVeh_ReTecFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_ReTecNumero` ,fechaVencimiento=new.DocVeh_ReTecFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_fPCA` AFTER UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `item_has_fv_vehiculo`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (4,new.Veh_Id,new.DocVeh_PoExtraFechaFin) on duplicate key update fecha_vencimiento=new.DocVeh_PoExtraFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_fPRCH` AFTER UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `item_has_fv_vehiculo`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (5,new.Veh_Id,new.DocVeh_RCHidroFechaFin) on duplicate key update fecha_vencimiento=new.DocVeh_RCHidroFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_fsoat` AFTER UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `item_has_fv_vehiculo`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (3,new.Veh_Id,new.DocVeh_SoatFechaFin) on duplicate key update fecha_vencimiento=new.DocVeh_SoatFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actualizar_ftecno` AFTER UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `item_has_fv_vehiculo`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (6,new.Veh_Id,new.DocVeh_ReTecFechaFin) on duplicate key update fecha_vencimiento=new.DocVeh_ReTecFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actutCqrVehiculo` BEFORE INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 8, new.`DocVeh_CertQRNumero`, new.DocVeh_CertQRFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_CertQRNumero` ,fechaVencimiento=new.DocVeh_CertQRFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actutPrcVehiculo` BEFORE UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 7, new.`DocVeh_RCHidroNumero`, new.DocVeh_RCHidroFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_RCHidroNumero` ,fechaVencimiento=new.DocVeh_RCHidroFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actutPrceVehiculo` BEFORE UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 6, new.`DocVeh_PoExtraNumero`, new.DocVeh_PoExtraFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_PoExtraNumero` ,fechaVencimiento=new.DocVeh_PoExtraFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actutSoatVehiculo` BEFORE UPDATE ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 4, new.`DocVeh_SoatNumero`, new.DocVeh_SoatFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_SoatNumero` ,fechaVencimiento=new.DocVeh_SoatFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ingresar_fPCA` AFTER INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `item_has_fv_vehiculo`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (4,new.Veh_Id,new.DocVeh_PoExtraFechaFin) on duplicate key update fecha_vencimiento=new.DocVeh_PoExtraFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ingresar_fPRCH` AFTER INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `item_has_fv_vehiculo`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (5,new.Veh_Id,new.DocVeh_RCHidroFechaFin) on duplicate key update fecha_vencimiento=new.DocVeh_RCHidroFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ingresar_fsoat` AFTER INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `item_has_fv_vehiculo`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (3,new.Veh_Id,new.DocVeh_SoatFechaFin) on duplicate key update fecha_vencimiento=new.DocVeh_SoatFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ingresar_ftecno` AFTER INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `item_has_fv_vehiculo`(`id_item`, `id_vehiculo`, `fecha_vencimiento`) VALUES (6,new.Veh_Id,new.DocVeh_ReTecFechaFin) on duplicate key update fecha_vencimiento=new.DocVeh_ReTecFechaFin
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertCltVehiculo` BEFORE INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 5, new.`DocVeh_CltNumero`, new.DocVeh_CltFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_CltNumero` ,fechaVencimiento=new.DocVeh_CltFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertCqrVehiculo` BEFORE INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 8, new.`DocVeh_CertQRNumero`, new.DocVeh_CertQRFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_CertQRNumero` ,fechaVencimiento=new.DocVeh_CertQRFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertPrcVehiculo` BEFORE INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 7, new.`DocVeh_RCHidroNumero`, new.DocVeh_RCHidroFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_RCHidroNumero` ,fechaVencimiento=new.DocVeh_RCHidroFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertPrceVehiculo` BEFORE INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 6, new.`DocVeh_PoExtraNumero`, new.DocVeh_PoExtraFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_PoExtraNumero` ,fechaVencimiento=new.DocVeh_PoExtraFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertSoatVehiculo` BEFORE INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 4, new.`DocVeh_SoatNumero`, new.DocVeh_SoatFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_SoatNumero` ,fechaVencimiento=new.DocVeh_SoatFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertTecnicoVehiculo` BEFORE INSERT ON `Documentos_Vehiculo` FOR EACH ROW INSERT INTO `documentosFlota`(`fkPlacaFlota`, `fkIdDocumento`, `numeroRegistro`, `fechaVencimiento`, `urlDocumento`, `idItem`, `usuarioControl`) VALUES ((SELECT  `Veh_Placa` FROM `Vehiculo` WHERE Vehiculo.`Veh_Id`=new.Veh_Id), 3, new.`DocVeh_ReTecNumero`, new.DocVeh_ReTecFechaFin, '', 0, '123456788')  on duplicate key update `numeroRegistro`=new.`DocVeh_ReTecNumero` ,fechaVencimiento=new.DocVeh_ReTecFechaFin, `fechaControl`=CURRENT_TIMESTAMP
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejecutoresMantenimiento`
--

CREATE TABLE `ejecutoresMantenimiento` (
  `id` int(11) NOT NULL,
  `ccEjecutor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigoInterno` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipoMostrar` tinyint(1) NOT NULL,
  `observacion` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejecutores_mtto_especialidades`
--

CREATE TABLE `ejecutores_mtto_especialidades` (
  `id` int(11) NOT NULL,
  `idEjecutor` int(11) NOT NULL,
  `idEspecialidad` int(11) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejecutores_mtto_externo`
--

CREATE TABLE `ejecutores_mtto_externo` (
  `id` int(11) NOT NULL,
  `id_sucursal` int(11) NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `show` tinyint(1) NOT NULL,
  `comment` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ejecutores_mtto_interno`
--

CREATE TABLE `ejecutores_mtto_interno` (
  `id` int(11) NOT NULL,
  `id_bodega` int(3) NOT NULL,
  `document` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `comment` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `show` tinyint(4) NOT NULL DEFAULT '1',
  `user_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `date_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emInventario`
--

CREATE TABLE `emInventario` (
  `idProducto` int(11) NOT NULL,
  `idEm` int(11) NOT NULL,
  `idProy` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idTipoReserva` int(2) NOT NULL,
  `cantidad` float(20,2) NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Empresa`
--

CREATE TABLE `Empresa` (
  `Emp_Id` int(20) NOT NULL,
  `Emp_Nit` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_Razonsocial` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_Nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_InFacturacion` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_Contacto1` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_Telefono1` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_Email1` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_Contacto2` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Emp_Telefono2` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Emp_Email2` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Emp_DirEmpresa` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_SitioWeb` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_RutaLogo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_ciudad` int(11) NOT NULL DEFAULT '0',
  `Foto_portada` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Nombre_formato_preope` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Cod_formt_preope` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Version_formt_preope` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Id_emp_plan` int(11) NOT NULL,
  `carpeta` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='informacion de la empresa en general';

--
-- Disparadores `Empresa`
--
DELIMITER $$
CREATE TRIGGER `updateEmpresa` BEFORE UPDATE ON `Empresa` FOR EACH ROW UPDATE `empresa` SET `idEmpresa`= New.`Emp_Id`,`nit`=New.Emp_Nit,`razonSocial`=New.Emp_Razonsocial,`nombreEmpresa`=New.Emp_Nombre,`inicialFacturacion`=New.Emp_InFacturacion,`personaContacto`=New.Emp_Contacto1,`telefonoPrincipal`=New.Emp_Telefono1,`emailEmpresa`=New.Emp_Email1,`personaContactoSeg`=New.Emp_Contacto2,`telefonoSegundario`=New.Emp_Telefono2,`emialSegundario`=New.Emp_Email2,`direccionEmpresa`=New.Emp_DirEmpresa,`sitioWeb`=New.Emp_SitioWeb,`rutaLogo`=New.Emp_RutaLogo,`fkIdCiudad`=New.Id_ciudad,`fotoPortada`=New.Foto_portada,`nombreFormatoPreope`=New.Nombre_formato_preope,`codFormtPreope`=New.Cod_formt_preope,`versionFormtPreope`=New.Version_formt_preope,`fkIdPlanQi`=New.Id_emp_plan,`carpeta`=New.carpeta WHERE 1
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresa`
--

CREATE TABLE `empresa` (
  `idEmpresa` int(20) NOT NULL,
  `nit` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `razonSocial` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombreEmpresa` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inicialFacturacion` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personaContacto` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'persona principal a contactar en la empresa',
  `telefonoPrincipal` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emailEmpresa` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personaContactoSeg` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'persona segundaria a contactar en la empresa',
  `telefonoSegundario` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `emialSegundario` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccionEmpresa` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sitioWeb` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rutaLogo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkIdCiudad` int(20) NOT NULL DEFAULT '0' COMMENT 'foreing key de id ciudad',
  `fotoPortada` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombreFormatoPreope` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codFormtPreope` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `versionFormtPreope` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fkIdPlanQi` int(11) NOT NULL,
  `carpeta` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='informacion de la empresa en general';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `emProyectos`
--

CREATE TABLE `emProyectos` (
  `id_proy` int(11) NOT NULL,
  `idEm` int(11) NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_apertura` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_cierre` datetime DEFAULT NULL,
  `estado` enum('ABIERTO','CERRADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encDevInventario`
--

CREATE TABLE `encDevInventario` (
  `idDevInventario` bigint(11) NOT NULL,
  `id_em` int(11) NOT NULL,
  `id_proyecto` int(11) NOT NULL DEFAULT '0',
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos de Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encEntradaInventario`
--

CREATE TABLE `encEntradaInventario` (
  `idEncEntradaInv` int(11) NOT NULL,
  `idSolicitudMat` int(11) NOT NULL COMMENT 'Solicitud de material',
  `recibeBodega` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numComprobante` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos del Usuario Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos fecha Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encInventarios`
--

CREATE TABLE `encInventarios` (
  `idEncInventario` int(11) NOT NULL,
  `idBodega` int(11) NOT NULL,
  `idMovil` int(11) NOT NULL DEFAULT '0' COMMENT 'id de la movil que se hace inventarios o 0 si el inventario es en bodega.',
  `idUsuarioMovil` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'firma de quien esta como representante de la movil para el inventario',
  `idUsuarioInventario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'firma de validacion de quien realiza el inventario',
  `idUsuarioBodega` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'firma de validacion de quien entrega o recibe material de la movil en el inventario',
  `observaciones` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoInventario` tinyint(1) NOT NULL COMMENT 'permanecera en 0 hasta que confirme las 3 firmas de validacion luego alli pasar a a1',
  `estadoConciliacion` tinyint(1) NOT NULL COMMENT 'dicho estado permanecera en 0 hasta que se concilie todos los materiales entregados sea justificado o descontado',
  `idUsuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'id del ultimo que realizo el movimiento de actualizacion',
  `fechaInventario` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'fecha inamovible de inventario se crea y jamas se debe actualizar'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encOrdenCompra`
--

CREATE TABLE `encOrdenCompra` (
  `idEncOrdenCompra` int(6) NOT NULL,
  `fechaHoraOc` datetime NOT NULL,
  `idBodega` int(11) NOT NULL,
  `idProveedor` int(20) NOT NULL,
  `condiComercial` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Condiciones Comerciales',
  `sitioEntrega` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estadoOC` int(1) NOT NULL COMMENT '0=INACTIVO, 1=ACTIVO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encSalidaProveedor`
--

CREATE TABLE `encSalidaProveedor` (
  `idEncSalidaProv` int(5) NOT NULL,
  `idBodega` int(11) NOT NULL,
  `cedulaAutoriza` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Cedula de quien autoriza',
  `autorizaCliente` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre de quien autoriza por parte del cliente',
  `idSucursal` int(11) NOT NULL,
  `nombreRecibe` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'nombre de quien puede recibir la salida',
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos de Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encSolicitudMat`
--

CREATE TABLE `encSolicitudMat` (
  `idSolicitudMat` int(1) NOT NULL,
  `idSucursal` int(11) NOT NULL,
  `idAlmacen` int(11) NOT NULL,
  `observaciones` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estadoEncSolicMat` int(1) NOT NULL COMMENT '0=editable o temporal / 1= finalizado',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos de Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encTranferEm`
--

CREATE TABLE `encTranferEm` (
  `idSalMatConsumo` bigint(12) NOT NULL,
  `obsSalConsum` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_em` int(11) NOT NULL,
  `id_proyecto` int(11) NOT NULL,
  `estado` enum('PENDIENTE','ACEPTADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos de Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encTrasladoMoviles`
--

CREATE TABLE `encTrasladoMoviles` (
  `idTrasladoMovil` int(9) NOT NULL,
  `idBodega` int(2) NOT NULL,
  `idMovilEntrega` int(11) NOT NULL,
  `idUsuarioEntrega` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idMovilRecibe` int(11) NOT NULL,
  `idUsuarioRecibe` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'va 0 o null mientras el usuario acepta el recibido',
  `observaciones` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estadoEncTrasMoviles` varchar(1) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '1: Aprobado, 0: Pendiente',
  `cedulaAprobado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'va 0 o null mientras se aprueba',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de Control',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encTrasladoReservas`
--

CREATE TABLE `encTrasladoReservas` (
  `idTrasladoReserva` int(8) NOT NULL,
  `idBodega` int(11) NOT NULL,
  `rAutorizacion` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'siempre se vlaida si requiere o no, si es no el estado es ejecutado',
  `movimiento` enum('EJECUTADO','PENDIENTE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `cedulautoriza` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notasAutoriza` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'solo aplican cuando requiere el auditor',
  `observacion` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cedulaUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos de Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `encuesta`
--

CREATE TABLE `encuesta` (
  `idEncuesta` int(19) NOT NULL,
  `tema` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `enunciadoEncuesta` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaInicio` date NOT NULL,
  `fechaFin` date NOT NULL,
  `creadorEncuesta` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoEncuesta` int(1) NOT NULL,
  `fkIdCapacitacion` int(11) NOT NULL COMMENT '0= si no esta relacionado con la capacitacion de lo contrario lleva el id de capacitacion ',
  `isRequired` int(1) NOT NULL DEFAULT '0' COMMENT 'es requerido al inicio de sesión',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Encuesta`
--

CREATE TABLE `Encuesta` (
  `Idencuesta` int(19) NOT NULL,
  `Tema` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Enunciado` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Fehca_in` date NOT NULL,
  `Fecha_fin` date NOT NULL,
  `Creado` int(20) NOT NULL,
  `Estado` int(1) NOT NULL,
  `llave_id_cap` int(11) NOT NULL COMMENT '0= si no esta relacionado con la capacitacion de lo contrario lleva el id de capacitacion ',
  `require_ini` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Enc_Preguntas`
--

CREATE TABLE `Enc_Preguntas` (
  `Id_pre` int(19) NOT NULL,
  `Id_encuesta` int(19) NOT NULL,
  `Descr_pregunta` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_pregunta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Enc_Respuestas`
--

CREATE TABLE `Enc_Respuestas` (
  `Id_resp` int(19) NOT NULL,
  `Id_preg` int(19) NOT NULL,
  `Descripcion_resp` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `especialidadesEm`
--

CREATE TABLE `especialidadesEm` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipoMostrar` tinyint(1) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadosLlantas`
--

CREATE TABLE `estadosLlantas` (
  `idEstadoLlanta` bigint(11) NOT NULL,
  `nombreEstado` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'título visible, p. ej. “Media vida”',
  `descripcionEstado` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'copy corto que acompaña al nombre',
  `porcentajeMin` decimal(5,2) DEFAULT NULL COMMENT 'límite inferior del rango de desgaste',
  `porcentajeMax` decimal(5,2) DEFAULT NULL COMMENT 'límite superior del rango',
  `descripcionRango` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'texto listo para mostrar, p. ej. “desgaste (21% - 75%)”',
  `colorHex` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'color principal (progress bars, badges)',
  `claseNivel` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'clase CSS o identificador para temas visuales (level_condition_3, etc.)',
  `iconoUrl` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ruta de la imagen/ícono del estado',
  `ordenVisual` int(11) NOT NULL COMMENT 'permite ordenar las tarjetas',
  `esActivo` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'habilitar/deshabilitar sin eliminar',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `evaluacionProveedorEnc`
--

CREATE TABLE `evaluacionProveedorEnc` (
  `id` int(11) NOT NULL,
  `idSucursal` int(11) NOT NULL,
  `fechaEvaluacion` date NOT NULL,
  `ciclo` int(3) NOT NULL,
  `calificacion` int(30) NOT NULL,
  `estadoCalificacion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idCriticidad` int(11) NOT NULL,
  `fechaReevaluacion` date NOT NULL,
  `observacion` varchar(300) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `evidencias`
--

CREATE TABLE `evidencias` (
  `idEvidencia` int(25) NOT NULL,
  `observaciones` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `rutaArchivo` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idCapacitacion` int(25) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fallasSolucionadas`
--

CREATE TABLE `fallasSolucionadas` (
  `idFallasSolcionadas` int(11) NOT NULL,
  `rdpId` int(11) NOT NULL,
  `idResumenPreoperacional` int(20) NOT NULL,
  `idItemMalo` int(11) NOT NULL,
  `fechaReporteFalla` date NOT NULL COMMENT 'fecha en la que se reporta la falla, por lo general es del preoperacional',
  `fechaReporteSolucion` date NOT NULL COMMENT 'fecha indicada pro el usuario de cuando soluciona la falla',
  `foto` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `personaDocumento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'quien indica el usuario que soluciono la falla',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'fecha automatica por sistema',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'usuario de inicio de sesion "control"'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fallas_solucionadas`
--

CREATE TABLE `fallas_solucionadas` (
  `idFallasSolcionadas` int(11) NOT NULL,
  `Rdp_Id` int(11) NOT NULL,
  `idresumenpreoperacional` int(11) NOT NULL,
  `idItemMalo` int(11) NOT NULL,
  `fechaReporteFalla` date NOT NULL,
  `fechaReporteSolucion` date NOT NULL,
  `Foto` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Observaciones` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Persona_Documento` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `firmasDigitales`
--

CREATE TABLE `firmasDigitales` (
  `idFirma` int(20) NOT NULL,
  `terminosCondiciones` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(politica tratamiento de datos)',
  `firma` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkNumeroDoc` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'foreing key de numero documento persona',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Captura de firma del personal para llenar el preoperacional';

--
-- Disparadores `firmasDigitales`
--
DELIMITER $$
CREATE TRIGGER `actuFirma` BEFORE INSERT ON `firmasDigitales` FOR EACH ROW INSERT INTO `Firmas_Digitales`( `Firma_fecha`, `Firma_acep_Ptd`, `Firma_Firma`, `Pers_NumeroDoc`) VALUES (cast(CURRENT_TIME as date),new.`terminosCondiciones`, new.`firma`, new.`fkNumeroDoc`)on duplicate key UPDATE `Firma_acep_Ptd`=new.`terminosCondiciones`, `Firma_Firma`=new.`firma`, `Pers_NumeroDoc`=new.`fkNumeroDoc`,Firma_fecha=cast(CURRENT_TIME as date)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Firmas_Digitales`
--

CREATE TABLE `Firmas_Digitales` (
  `Firma_Id` int(20) NOT NULL,
  `Firma_fecha` date NOT NULL,
  `Firma_acep_Ptd` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '(politica tratamiento de datos)',
  `Firma_Firma` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_NumeroDoc` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Captura de firma del personal para llenar el preoperacional';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formatoEspecialesCat`
--

CREATE TABLE `formatoEspecialesCat` (
  `id` int(11) NOT NULL,
  `nombre` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idFormato` int(11) NOT NULL,
  `visible` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `segmento` int(1) NOT NULL DEFAULT '1' COMMENT '1=conductor 2=Vehiculo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='solo aplican p ara los formatos especiales';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formatoEspecialesCatItem`
--

CREATE TABLE `formatoEspecialesCatItem` (
  `id` int(11) NOT NULL,
  `idFormatCat` int(11) NOT NULL,
  `nombre` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `imagen` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `tpPregunta` enum('UNICO','MULTIPLE','F/V') COLLATE utf8mb4_unicode_ci NOT NULL,
  `puntaje` float(4,3) DEFAULT NULL,
  `rtaVp` enum('V','F','A','B','C','D','E','G','H','I','J','K','L','M','S','CS','N','SI','NO','N/A','1','2','3') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'rtaverdaderamente posible',
  `visible` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formatoEspecialesEnca`
--

CREATE TABLE `formatoEspecialesEnca` (
  `id` int(20) NOT NULL,
  `fechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idFormato` int(11) NOT NULL,
  `placaV` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `placaR` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `userRealiza` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uOperador` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechFirmaOp` datetime DEFAULT NULL,
  `uEvaluador` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechFirmaEv` datetime DEFAULT NULL,
  `poseedor` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('APTO','NO APTO','APRUEBA','REPRUEBA','N/A','CONFIABLE','MEDIANAMENTE CONFIABLE','NO CONFIABLE') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'N/A',
  `calificacion` float(5,3) DEFAULT NULL,
  `periodoEvaluado` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'se extrae 3 iniciales del mes 1 y 2 y se concatena con " - "',
  `tpEvluacion` enum('INDUCCIÓN','REINDUCCIÓN','EPP','DOTACION','EPP Y DOTACION','N/A') COLLATE utf8mb4_unicode_ci NOT NULL,
  `tpVinculacion` enum('TERCERO','CONTRATISTA','N/A') COLLATE utf8mb4_unicode_ci NOT NULL,
  `comentarios` mediumtext COLLATE utf8mb4_unicode_ci,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tabla especial para control de formatos';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formatoEspecialesEnca_det`
--

CREATE TABLE `formatoEspecialesEnca_det` (
  `idFEspecial` int(20) NOT NULL,
  `iditemEsp` int(20) NOT NULL,
  `rta` enum('V','F','A','B','C','D','E','G','H','I','J','K','L','M','S','CS','N','SI','NO','N/A','1','2','3') COLLATE utf8mb4_unicode_ci NOT NULL,
  `observacion` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='se utiliza solo para formatos especiales';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formatoEspecialesEnca_exp`
--

CREATE TABLE `formatoEspecialesEnca_exp` (
  `id` int(11) NOT NULL,
  `idFEspecial` int(20) NOT NULL,
  `operacion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tiempo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tpCarga` enum('CARGA SECA','MASIVO','PAQUETEO','LIQUIDOS','OTROS','N/A') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='se utiliza solo para formatos especiales';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `formatoEspecialesUserRealiza`
--

CREATE TABLE `formatoEspecialesUserRealiza` (
  `usuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idFEspecial` int(11) NOT NULL,
  `visible` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuariocontrol` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='para controlar quiens realizan o no el formato';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `fotosPreoperacionalUltimate`
--

CREATE TABLE `fotosPreoperacionalUltimate` (
  `id` int(11) NOT NULL,
  `idResumen` int(11) NOT NULL,
  `fotoCabina` longtext COLLATE utf8mb4_unicode_ci,
  `fotoLd` longtext COLLATE utf8mb4_unicode_ci,
  `fotoLi` longtext COLLATE utf8mb4_unicode_ci,
  `fotoPd` longtext COLLATE utf8mb4_unicode_ci,
  `fotoPt` longtext COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hasArticuloAlmacen`
--

CREATE TABLE `hasArticuloAlmacen` (
  `id` int(11) NOT NULL,
  `id_articulo` int(11) NOT NULL,
  `id_almacen` int(1) NOT NULL,
  `serialSiNo` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hashBinomios`
--

CREATE TABLE `hashBinomios` (
  `idBinomio` bigint(15) NOT NULL,
  `placaVehiculo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placaTrailer` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoBinomio` tinyint(1) NOT NULL DEFAULT '1',
  `fechaFinBinomio` datetime NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UserControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hashTipoVehiculoCss`
--

CREATE TABLE `hashTipoVehiculoCss` (
  `idTipoVehiculo` int(11) NOT NULL,
  `idUbicacion` int(11) NOT NULL,
  `idCss` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_estados_asignacion_em_tareas`
--

CREATE TABLE `historial_estados_asignacion_em_tareas` (
  `id` int(11) NOT NULL,
  `id_asignacion` int(11) NOT NULL,
  `status` enum('EXPIRED','REJECTED','TO_BE_APPROVED','APPROVED','IN_ACTION','COMPLETED') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Los valores de esta columna deben ser los mismos valores de la columna ''status'' de la tabla programacion_mtto_asignacion_em_tareas',
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historicoProcedimientosLlanta`
--

CREATE TABLE `historicoProcedimientosLlanta` (
  `idHisProcLlanta` bigint(15) NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idProducto` int(11) NOT NULL,
  `serialLlanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `posicion` int(11) NOT NULL,
  `idProcedimiento` int(11) NOT NULL,
  `tipoProcedimiento` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `userControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inspeccionLlantas`
--

CREATE TABLE `inspeccionLlantas` (
  `idEncInspLl` bigint(15) NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idProducto` int(11) NOT NULL,
  `serialLlanta` varchar(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jsonInformacion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `idUrlLlanta` int(11) NOT NULL,
  `userControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventarioVehiculo`
--

CREATE TABLE `inventarioVehiculo` (
  `placaInv` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idAlmacen` int(2) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idTipoReserva` int(2) NOT NULL,
  `cantidadInv` float(20,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `itemInspeccion`
--

CREATE TABLE `itemInspeccion` (
  `idItemInsp` int(20) NOT NULL,
  `descripcionItem` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idCatItem` int(20) NOT NULL,
  `PrioridadInsp` int(11) NOT NULL,
  `iinspCatRV` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'C',
  `fechaVencimiento` int(11) NOT NULL DEFAULT '0' COMMENT '0=no contiene fecha, 1=si contiene fecha',
  `estadoItem` int(11) NOT NULL DEFAULT '1',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `itemModuloFrontend`
--

CREATE TABLE `itemModuloFrontend` (
  `idItemModulo` int(11) NOT NULL,
  `labelItemModulo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcionItemModulo` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `routerItemModulo` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idModulo` int(11) NOT NULL,
  `labelFluter` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `routerFluter` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `EstadoItemModulo` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='maestra de items que van en cada modulo';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `item_has_fv_remolque`
--

CREATE TABLE `item_has_fv_remolque` (
  `id_item` int(11) NOT NULL,
  `id_vehiculo` int(11) NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `item_has_fv_vehiculo`
--

CREATE TABLE `item_has_fv_vehiculo` (
  `id_item` int(11) NOT NULL,
  `id_vehiculo` int(11) NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Item_Inspeccion`
--

CREATE TABLE `Item_Inspeccion` (
  `IInsp_Id` int(20) NOT NULL,
  `IInsp_descripcion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Cat_Item_Id` int(20) NOT NULL,
  `IInsp_Prioridad` int(11) NOT NULL,
  `IInsp_catRV` varchar(2) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'C',
  `fecha_vencimiento` int(11) NOT NULL DEFAULT '0' COMMENT '0=no contiene fecha, 1=si contiene fecha',
  `Status` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `Item_Inspeccion`
--
DELIMITER $$
CREATE TRIGGER `actuinspnuevo` BEFORE INSERT ON `Item_Inspeccion` FOR EACH ROW INSERT INTO `itemInspeccion`(`descripcionItem`, `idCatItem`, `PrioridadInsp`, `iinspCatRV`, `fechaVencimiento`, `estadoItem`, `usuarioControl`) VALUES ( new.`IInsp_descripcion`, new.`Cat_Item_Id`, new.`IInsp_Prioridad`, new.`IInsp_catRV`, new.`fecha_vencimiento`, new.`Status`,123456788)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateiteminspeccion` BEFORE UPDATE ON `Item_Inspeccion` FOR EACH ROW UPDATE `Item_Inspeccion` INNER JOIN itemInspeccion  on Item_Inspeccion.IInsp_Id=itemInspeccion.idItemInsp SET `descripcionItem`= new.`IInsp_descripcion`,`idCatItem`=new.`Cat_Item_Id`,`PrioridadInsp`=new.`IInsp_Prioridad`,`iinspCatRV`= new.`IInsp_catRV`,`fechaVencimiento`= new.`fecha_vencimiento`,`estadoItem`=new.`Status`,`fechaControl`=CURRENT_TIME WHERE idItemInsp=new.IInsp_Id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `llaveItemTpv`
--

CREATE TABLE `llaveItemTpv` (
  `idLlave` int(11) NOT NULL,
  `idItem` int(11) NOT NULL,
  `idTpVehiculo` int(11) NOT NULL,
  `estadoLlave` int(1) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `llave_item_tpv`
--

CREATE TABLE `llave_item_tpv` (
  `id_llave` int(11) NOT NULL,
  `id_item` int(11) NOT NULL,
  `id_tp_vehiculo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `llave_item_tpv`
--
DELIMITER $$
CREATE TRIGGER `actullaveitemnuevo` BEFORE INSERT ON `llave_item_tpv` FOR EACH ROW INSERT INTO `llaveItemTpv`( `idItem`, `idTpVehiculo`, `estadoLlave`, `usuarioControl`) VALUES(new.`id_item`, new.`id_tp_vehiculo`,1,123456788 )
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateactullavetp` BEFORE UPDATE ON `llave_item_tpv` FOR EACH ROW UPDATE `llaveItemTpv` SET `idItem`=new.id_item,`idTpVehiculo`=new.id_tp_vehiculo,`fechaControl`=CURRENT_TIME WHERE `idLlave`=new.id_llave
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_trigger_debug`
--

CREATE TABLE `log_trigger_debug` (
  `id` bigint(20) NOT NULL,
  `idRegistro` bigint(20) DEFAULT NULL,
  `serialLlanta` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idProducto` int(11) DEFAULT NULL,
  `placaCabezote` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `placaRemolque` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `llanta_posicion` int(11) DEFAULT NULL,
  `cantidad_llantas` int(11) DEFAULT NULL,
  `es_repuesto` tinyint(1) DEFAULT NULL,
  `km_tramo` bigint(20) DEFAULT NULL,
  `mensaje` text COLLATE utf8mb4_unicode_ci,
  `fecha` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lote`
--

CREATE TABLE `lote` (
  `idLote` int(2) NOT NULL,
  `nombreLote` varchar(24) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoLote` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos de usuario Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de fecha Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `maestraVencDocs`
--

CREATE TABLE `maestraVencDocs` (
  `idDocumento` int(11) NOT NULL,
  `nombreDocumento` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkIdCatDocumento` int(1) NOT NULL COMMENT '1=vehiculo, 2=remolque y 3=conductor',
  `vencimiento` int(1) NOT NULL,
  `estadoMVD` int(1) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='maestra de todos los documentos de vencimientos';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manAddEncOrdenServicio`
--

CREATE TABLE `manAddEncOrdenServicio` (
  `Id_aeos` int(11) NOT NULL,
  `idEncOrdServicio` int(11) NOT NULL,
  `observacion` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='add comentario encabe orden de servi';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manArticulos`
--

CREATE TABLE `manArticulos` (
  `idArticulo` int(11) NOT NULL,
  `codigoArticulo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referencia` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `diseno` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dimension` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estadoArticulo` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `serialSiNo` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '0=No,1=Si',
  `mmOriginal` float(7,2) DEFAULT NULL,
  `vidaUtilKm` int(11) DEFAULT NULL,
  `fkIdTipoArticulo` int(11) NOT NULL,
  `fkIdCatgArticulo` int(11) NOT NULL,
  `fkUndEmpaqueCompra` int(11) NOT NULL,
  `fkUndEmpaqueEntrega` int(11) NOT NULL,
  `fkIdMarcaArticulos` int(11) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UsuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manBodegas`
--

CREATE TABLE `manBodegas` (
  `idBodega` int(3) NOT NULL,
  `nombreBodega` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idCiudadBodega` int(11) NOT NULL,
  `estadoBodega` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos de Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manCategoriaArticulos`
--

CREATE TABLE `manCategoriaArticulos` (
  `idCategoriaArticulos` int(11) NOT NULL,
  `descripcion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoCat` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manCausas`
--

CREATE TABLE `manCausas` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo_mostrar` tinyint(1) NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manDetalleOrdenServicio`
--

CREATE TABLE `manDetalleOrdenServicio` (
  `idDetalleOrdenServicio` int(11) NOT NULL,
  `fkIdEncabOrdServicio` int(11) NOT NULL,
  `fkIdFallaHasItem` int(11) NOT NULL,
  `observacionFalla` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fotoFalla` mediumtext COLLATE utf8mb4_unicode_ci,
  `responsable` bigint(12) NOT NULL,
  `ejecutor` bigint(12) NOT NULL,
  `supervisor` bigint(12) NOT NULL,
  `fechaInicio` date DEFAULT NULL,
  `horaInicio` time DEFAULT NULL,
  `estadoDetOrden` int(1) NOT NULL COMMENT '0=por ejecutar,1=solucionado, 2=en ejecucion, 3=sin solucion',
  `fkIdShr` int(11) NOT NULL COMMENT 'id donde relaciona el hash de los sistemas y rutinas para dicha orden '
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manDetSolucionOrdenServicio`
--

CREATE TABLE `manDetSolucionOrdenServicio` (
  `idDetSolucion` bigint(20) NOT NULL,
  `fkIdSolucionOrdenServicio` int(11) NOT NULL,
  `fkIdArticulo` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manEncabezadoOrdenServicio`
--

CREATE TABLE `manEncabezadoOrdenServicio` (
  `idEncOrdServicio` int(11) NOT NULL,
  `placavehiculo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'se toma el id de la placa de la tabla vehiculos',
  `placaRemolque` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT 'se toma el ID de la tabla remolques',
  `tipMtto` int(1) DEFAULT NULL COMMENT '1=PREDICT, 2=PREVENT, 3=CORRECT',
  `tipoPrioridad` int(1) DEFAULT NULL COMMENT '1=RIGUROSA, 2=MODERADA',
  `fechaProgramacion` date DEFAULT NULL COMMENT 'fecha en la cual se proyecta a realizar el servicio',
  `observaciones` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fotoGeneral` mediumtext COLLATE utf8mb4_unicode_ci,
  `idUserAutoriza` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'usuario que autoriza, mientras se valida por defecto va 0',
  `fechaControl` datetime DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Id del usuario que esta realizando la orden',
  `estadoEncOrdSer` int(1) DEFAULT NULL COMMENT '0=BORRADOR, 1=TERMINADA, 2=POR APROBAR, 3= EN EJECUCIONC'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manEncSolucionOrdenServicio`
--

CREATE TABLE `manEncSolucionOrdenServicio` (
  `idSolucionOrdenServicio` int(11) NOT NULL,
  `fkIdDetaOrdenServicio` int(11) NOT NULL,
  `observacionSolucion` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaIni` datetime NOT NULL,
  `fechaFin` datetime DEFAULT NULL,
  `estadoEnc` int(1) NOT NULL COMMENT '0=proceso,1=cerrada',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manFallas`
--

CREATE TABLE `manFallas` (
  `idFallas` int(11) NOT NULL,
  `descripcionFalla` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoFalla` int(1) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manFallasHasItem`
--

CREATE TABLE `manFallasHasItem` (
  `idFallasHasItem` int(11) NOT NULL,
  `fkIdFalla` int(11) NOT NULL,
  `fkIdItem` int(11) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manFrecuencias`
--

CREATE TABLE `manFrecuencias` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sigla` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `habilitado` tinyint(4) NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manMarcaArticulos`
--

CREATE TABLE `manMarcaArticulos` (
  `idMarcaArticulos` int(11) NOT NULL,
  `descripcion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoMarca` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `aplicaLlantas` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manModulosFrontend`
--

CREATE TABLE `manModulosFrontend` (
  `idModulo` int(11) NOT NULL,
  `label` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `labelFluter` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `iconFluter` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `activeItem` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='modulos del fronet solo consulta user';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manProgTest`
--

CREATE TABLE `manProgTest` (
  `plate` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `initial_date` date NOT NULL,
  `finish_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manProrrogaMttoProg`
--

CREATE TABLE `manProrrogaMttoProg` (
  `idProrrogaMttoProg` int(11) NOT NULL,
  `fkIdEncaOrdenServicio` int(11) NOT NULL,
  `fechAnterior` date NOT NULL,
  `fechActualizada` date NOT NULL,
  `observaciones` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manReferenciasLlanta`
--

CREATE TABLE `manReferenciasLlanta` (
  `idReferencia` int(10) UNSIGNED NOT NULL,
  `codigoReferencia` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `anchoBandaMM` decimal(6,2) NOT NULL COMMENT 'Anchura de la banda de rodadura en mm (ej. 295)',
  `alturaPerfil` decimal(5,2) NOT NULL COMMENT 'Relación altura/ancho expresada como porcentaje (ej. 80)',
  `tipoConstruccion` enum('R','B','D') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'R' COMMENT 'R: radial, B: belted bias, D: diagonal',
  `diametroRinPulg` decimal(5,2) NOT NULL COMMENT 'Diámetro interior del rin en pulgadas (ej. 22.5)',
  `descripcion` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Descripción amigable o notas',
  `estado` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVO',
  `usuarioControl` int(10) UNSIGNED DEFAULT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manRutinas`
--

CREATE TABLE `manRutinas` (
  `id` int(11) NOT NULL,
  `codigo` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idSistema` int(11) NOT NULL,
  `tipoMostrar` tinyint(1) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manRutinasTareas`
--

CREATE TABLE `manRutinasTareas` (
  `id` int(11) NOT NULL,
  `idRutina` int(11) NOT NULL,
  `idTarea` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manSeriSoluOS`
--

CREATE TABLE `manSeriSoluOS` (
  `idSerSolucion` int(11) NOT NULL,
  `fkIdSolucionOrdenServicio` int(11) NOT NULL,
  `fkIdArticulo` int(11) NOT NULL,
  `serial` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='seriales que se dan solucion a las ordenes de servicio';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manSistemas`
--

CREATE TABLE `manSistemas` (
  `idSistemas` int(11) NOT NULL,
  `descripcionSistemas` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoSistemas` int(1) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manSistemasHhasRutinas`
--

CREATE TABLE `manSistemasHhasRutinas` (
  `id_shr` int(11) NOT NULL,
  `fkIdSistemas` int(11) NOT NULL,
  `fkIdRutinas` int(11) NOT NULL,
  `fkIdTipoVeh` int(11) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manTareas`
--

CREATE TABLE `manTareas` (
  `id` int(11) NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `frecuencia` int(10) NOT NULL,
  `tipo_frecuencia` int(11) NOT NULL,
  `sistema` int(11) NOT NULL,
  `tipo_mostrar` tinyint(4) NOT NULL,
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manTipoArticulos`
--

CREATE TABLE `manTipoArticulos` (
  `idTipoArticulos` int(11) NOT NULL,
  `descripcionTipoArt` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime DEFAULT CURRENT_TIMESTAMP,
  `estadoTipoArt` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manTipoComprobante`
--

CREATE TABLE `manTipoComprobante` (
  `idTipoComp` int(20) NOT NULL,
  `descripcionTipoComp` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estadoTipoComp` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `manUnidadMedida`
--

CREATE TABLE `manUnidadMedida` (
  `idUnidadMedida` int(11) NOT NULL,
  `abreviaturaUnd` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcionUnidad` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoUnidad` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcaVehiculo`
--

CREATE TABLE `marcaVehiculo` (
  `idMarca` int(11) NOT NULL,
  `nombreMarca` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoMarca` int(1) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marca_vehiculo_remolque`
--

CREATE TABLE `marca_vehiculo_remolque` (
  `marca_id` int(11) NOT NULL,
  `marca_descripcion` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `marca_estado` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `marca_vehiculo_remolque`
--
DELIMITER $$
CREATE TRIGGER `actuMarcasVehiculo` BEFORE INSERT ON `marca_vehiculo_remolque` FOR EACH ROW INSERT INTO `marcaVehiculo`(`idMarca`, `nombreMarca`, `estadoMarca`, `usuarioControl`) VALUES (new.`marca_id`, new.`marca_descripcion`, new.`marca_estado` ,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Notificaciones`
--

CREATE TABLE `Notificaciones` (
  `id_notificacion` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `newcapacitacion` int(11) NOT NULL,
  `newinspeccion` int(11) NOT NULL,
  `newcertificado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificacionesCorreo`
--

CREATE TABLE `notificacionesCorreo` (
  `idCorreo` int(11) NOT NULL,
  `emailNotiCorreo` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoNotiCorreo` int(1) NOT NULL DEFAULT '1',
  `tipoNotificacion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'DCV= doc conduc, DVV= DOC VEHI Y TRAILER, PAN= PREOPE APRO NO ABRO',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificacionesGeneral`
--

CREATE TABLE `notificacionesGeneral` (
  `ntId` bigint(20) NOT NULL,
  `ntTitulo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ntDescripcion` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `ntUsuarioNotificado` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ntEstado` int(1) NOT NULL,
  `ntFechaNotify` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'datos de control',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788' COMMENT 'datos de control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificacionesInspec`
--

CREATE TABLE `notificacionesInspec` (
  `idNotificacion` int(11) NOT NULL,
  `idUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `newCapacitacion` int(3) NOT NULL COMMENT 'cantidad de las capacitaciones donde aparece ',
  `newInspeccion` int(3) NOT NULL COMMENT 'cantidad de inspecciones realizadas',
  `newCertificado` int(3) NOT NULL COMMENT 'cantidad de certificados'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notify_correo`
--

CREATE TABLE `notify_correo` (
  `id_correo` int(11) NOT NULL,
  `idusuario` int(20) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `tiponotificacion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notify_correo2`
--

CREATE TABLE `notify_correo2` (
  `id_correo` int(11) NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` int(11) NOT NULL DEFAULT '1',
  `tiponotificacion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'DCV= doc conduc, DVV= DOC VEHI Y TRAILER, PAN= PREOPE APRO NO ABRO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Permisos`
--

CREATE TABLE `Permisos` (
  `Permiso_Id` int(20) NOT NULL,
  `Permiso_Modulo` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Permiso_Descripcion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tabla con los diferentes formularios para asignacion de perm';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisosRol`
--

CREATE TABLE `permisosRol` (
  `fkIdRol` int(11) NOT NULL,
  `fkIdItemModulo` int(11) NOT NULL,
  `estadoPermisoBasico` int(11) NOT NULL,
  `idAcciones` int(20) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='permisos basicos de control por rol';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisoUsuario`
--

CREATE TABLE `permisoUsuario` (
  `idUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idItem` int(11) NOT NULL,
  `idAccionesUsuario` int(20) NOT NULL,
  `estadoPermiso` int(1) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '123456788',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Personal`
--

CREATE TABLE `Personal` (
  `id_Auto_increment` int(11) NOT NULL,
  `Pers_NumeroDoc` bigint(20) NOT NULL,
  `Pers_LugarExpDoc` int(20) NOT NULL,
  `Pers_FechaNaci` date NOT NULL,
  `Pers_Genero` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Rh` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Arl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Eps` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Afp` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Celular` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Direccion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Nombres` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Apellidos` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pers_Imagen` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Emp_Id` int(20) NOT NULL,
  `TipoDoc_Id` int(20) NOT NULL,
  `Carg_id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Datos personal del personal que labora en la empresa';

--
-- Disparadores `Personal`
--
DELIMITER $$
CREATE TRIGGER `actuPersonal` BEFORE UPDATE ON `Personal` FOR EACH ROW INSERT INTO `personal`(`numeroDocumento`, `lugarExpDocumento`, `fechaNacimiento`, `genero`, `rh`, `arl`, `eps`, `afp`, `numeroCelular`, `direccion`, `nombres`, `apellidos`, `email`, `urlFoto`, `password`, `estadoPersonal`, `fkIdEmpresa`, `fkIdTIpoDocumento`, `fkIdCargo`, `fkIdRol`, `usuarioControl`) VALUES (new.`Pers_NumeroDoc`, new.`Pers_LugarExpDoc`, new.`Pers_FechaNaci`, new.`Pers_Genero`, new.`Pers_Rh`, new.`Pers_Arl`, new.`Pers_Eps`, new.`Pers_Afp`, new.`Pers_Celular`, new.`Pers_Direccion`, new.`Pers_Nombres`, new.`Pers_Apellidos`, new.`Pers_Email`, new.`Pers_Imagen`,'xxxx',1, new.`Emp_Id`, new.`TipoDoc_Id`, new.`Carg_id`,2,123456788) on duplicate KEY UPDATE   lugarExpDocumento=new.`Pers_LugarExpDoc`, fechaNacimiento=new.`Pers_FechaNaci`, genero=new.`Pers_Genero`, rh=new.`Pers_Rh`, arl=new.`Pers_Arl`, eps=new.`Pers_Eps`, afp=new.`Pers_Afp`, numeroCelular=new.`Pers_Celular`, direccion=new.`Pers_Direccion`, nombres=new.`Pers_Nombres`, apellidos=new.`Pers_Apellidos`, email=new.`Pers_Email`, urlFoto=new.`Pers_Imagen`
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertPersonal` BEFORE INSERT ON `Personal` FOR EACH ROW INSERT INTO `personal`(`numeroDocumento`, `lugarExpDocumento`, `fechaNacimiento`, `genero`, `rh`, `arl`, `eps`, `afp`, `numeroCelular`, `direccion`, `nombres`, `apellidos`, `email`, `urlFoto`, `password`, `estadoPersonal`, `fkIdEmpresa`, `fkIdTIpoDocumento`, `fkIdCargo`, `fkIdRol`, `usuarioControl`) VALUES (new.`Pers_NumeroDoc`, new.`Pers_LugarExpDoc`, new.`Pers_FechaNaci`, new.`Pers_Genero`, new.`Pers_Rh`, new.`Pers_Arl`, new.`Pers_Eps`, new.`Pers_Afp`, new.`Pers_Celular`, new.`Pers_Direccion`, new.`Pers_Nombres`, new.`Pers_Apellidos`, new.`Pers_Email`, new.`Pers_Imagen`,'xxxx',1, new.`Emp_Id`, new.`TipoDoc_Id`, new.`Carg_id`,2,123456788) on duplicate KEY UPDATE   lugarExpDocumento=new.`Pers_LugarExpDoc`, fechaNacimiento=new.`Pers_FechaNaci`, genero=new.`Pers_Genero`, rh=new.`Pers_Rh`, arl=new.`Pers_Arl`, eps=new.`Pers_Eps`, afp=new.`Pers_Afp`, numeroCelular=new.`Pers_Celular`, direccion=new.`Pers_Direccion`, nombres=new.`Pers_Nombres`, apellidos=new.`Pers_Apellidos`, email=new.`Pers_Email`, urlFoto=new.`Pers_Imagen`
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal`
--

CREATE TABLE `personal` (
  `numeroDocumento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lugarExpDocumento` int(20) NOT NULL COMMENT 'lugar de expedición del documento',
  `fechaNacimiento` date NOT NULL,
  `genero` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rh` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `arl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `eps` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `afp` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numeroCelular` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombres` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `urlFoto` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoPersonal` int(1) NOT NULL,
  `fkIdEmpresa` int(20) NOT NULL COMMENT 'foreing key de id empresa',
  `id_sucursal` int(11) NOT NULL DEFAULT '1',
  `fkIdTIpoDocumento` int(20) NOT NULL COMMENT 'foreing key de id tipo documento',
  `fkIdCargo` int(20) NOT NULL COMMENT 'foreing key de id cargo',
  `fkIdRol` int(20) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Datos personal del personal que labora en la empresa';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preguntasCapacitacion`
--

CREATE TABLE `preguntasCapacitacion` (
  `idPreguntaCap` int(25) NOT NULL,
  `descipcionPreguntaCap` varchar(15000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idTipoPregunta` int(11) NOT NULL,
  `idCapPregunta` int(11) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preguntasEncuesta`
--

CREATE TABLE `preguntasEncuesta` (
  `idPregunta` int(11) NOT NULL,
  `idEncuesta` int(11) NOT NULL,
  `descrPregunta` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipoPregunta` int(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `preguntas_has_capacitacion`
--

CREATE TABLE `preguntas_has_capacitacion` (
  `id_Pregunta1` int(25) NOT NULL,
  `id_Capacitacion1` int(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Preguntas_v2`
--

CREATE TABLE `Preguntas_v2` (
  `id_Pregunta` int(25) NOT NULL,
  `Pregunta` varchar(15000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_TipoPregunta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesionalArea`
--

CREATE TABLE `profesionalArea` (
  `usuarioCapacitador` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idArea` int(25) NOT NULL,
  `opcionProfesionalArea` int(2) NOT NULL DEFAULT '1' COMMENT '1=capacitador, 2=responsable (directorman ot ), 3=jecutor, 4=supervisor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `profesional_area`
--

CREATE TABLE `profesional_area` (
  `id_Capacitador` bigint(20) NOT NULL,
  `id_area` int(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `profesional_area`
--
DELIMITER $$
CREATE TRIGGER `actuProfeArea` BEFORE INSERT ON `profesional_area` FOR EACH ROW INSERT INTO `profesionalArea`(`usuarioCapacitador`, `idArea`, `opcionProfesionalArea`) VALUES (new.`id_Capacitador`, new.`id_area`,1)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto`
--

CREATE TABLE `programacion_mtto` (
  `id` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reprogramado` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'solo cambia si o si la fecha de inicio es diferente a la nueva',
  `usuario_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `programacion_mtto`
--
DELIMITER $$
CREATE TRIGGER `actualizar_reprogramado` BEFORE UPDATE ON `programacion_mtto` FOR EACH ROW BEGIN
    IF NEW.fecha_inicio <> OLD.fecha_inicio OR NEW.fecha_fin <> OLD.fecha_fin THEN
        SET NEW.reprogramado = 1;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_asignacion_em_tareas`
--

CREATE TABLE `programacion_mtto_asignacion_em_tareas` (
  `id` int(11) NOT NULL,
  `id_programacion_mtto` int(11) NOT NULL,
  `id_tarea` int(11) NOT NULL,
  `type_tarea` enum('TASK','ROUTINE','FAILURE_TASK','FAILURE_ROUTINE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_rt` int(11) NOT NULL,
  `id_em` int(11) NOT NULL,
  `tipo_em` enum('INTERNAL','EXTERNAL') COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('EXPIRED','REJECTED','TO_BE_APPROVED','APPROVED','IN_ACTION','COMPLETED') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'TO_BE_APPROVED' COMMENT 'En caso de cambiar los valores de esta columna. Recordar cambiar los de la tabla de historial_estados_asignacion_em_tareas',
  `observacion` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `assign_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_control` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_control` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_fallas`
--

CREATE TABLE `programacion_mtto_fallas` (
  `id` int(11) NOT NULL,
  `id_programacion` int(11) NOT NULL,
  `id_item_falla` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_fallas_causas`
--

CREATE TABLE `programacion_mtto_fallas_causas` (
  `id` int(11) NOT NULL,
  `id_mtto_falla` int(11) NOT NULL,
  `id_causa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_fallas_rutinas`
--

CREATE TABLE `programacion_mtto_fallas_rutinas` (
  `id` int(11) NOT NULL,
  `id_falla_program` int(11) NOT NULL,
  `id_rutina` int(11) NOT NULL,
  `tipo_mtto` enum('PREVENTIVO','PREDICTIVO','CORRECTIVO') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_fallas_tareas`
--

CREATE TABLE `programacion_mtto_fallas_tareas` (
  `id` int(11) NOT NULL,
  `id_falla_program` int(11) NOT NULL,
  `id_tarea` int(11) NOT NULL,
  `tipo_mtto` enum('PREVENTIVO','PREDICTIVO','CORRECTIVO') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_rutinas`
--

CREATE TABLE `programacion_mtto_rutinas` (
  `id` int(11) NOT NULL,
  `id_programacion` int(11) NOT NULL,
  `id_rutina` int(11) NOT NULL,
  `tipo_mtto` enum('PREVENTIVO','PREDICTIVO','CORRECTIVO') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_rutinas_causas`
--

CREATE TABLE `programacion_mtto_rutinas_causas` (
  `id` int(11) NOT NULL,
  `id_mtto_rutina` int(11) NOT NULL,
  `id_causa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_tareas`
--

CREATE TABLE `programacion_mtto_tareas` (
  `id` int(11) NOT NULL,
  `id_programacion` int(11) NOT NULL,
  `id_tarea` int(11) NOT NULL,
  `tipo_mtto` enum('PREVENTIVO','PREDICTIVO','CORRECTIVO') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `programacion_mtto_tareas_causas`
--

CREATE TABLE `programacion_mtto_tareas_causas` (
  `id` int(11) NOT NULL,
  `id_mtto_tarea` int(11) NOT NULL,
  `id_causa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Proveedor`
--

CREATE TABLE `Proveedor` (
  `Prov_Id` int(20) NOT NULL,
  `Prov_Nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Prov_NumeroDoc` int(20) NOT NULL,
  `Prov_LugarExpDoc` int(20) NOT NULL,
  `Prov_Celular` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Prov_Email` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Prov_estado` int(2) NOT NULL,
  `TipoDoc_Id` int(20) NOT NULL,
  `tipo_c_p` int(11) NOT NULL COMMENT 'identificar si es cliente o proveedor 1=proveedor 2=cliente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='datos del proveedor en general';

--
-- Disparadores `Proveedor`
--
DELIMITER $$
CREATE TRIGGER `actuProveedor` BEFORE INSERT ON `Proveedor` FOR EACH ROW INSERT INTO `proveedor`(`idProv`, `nombreProv`, `numeroDocProv`, `celularProv`, `emailProv`, `estadoProv`, `tipoDocId`, `tipoClienteProv`, `usuarioControl`) VALUES (new.`Prov_Id`, new.`Prov_Nombre`, new.`Prov_NumeroDoc`, new.`Prov_Celular`, new.`Prov_Email`, new.`Prov_estado`, new.`TipoDoc_Id`, new.`tipo_c_p`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `idProv` int(20) NOT NULL,
  `nombreProv` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numeroDocProv` int(20) NOT NULL,
  `celularProv` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `emailProv` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estadoProv` int(2) NOT NULL,
  `tipoDocId` int(20) NOT NULL,
  `tipoClienteProv` enum('PROVEEDOR','CLIENTE','EM') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'EM= EJECUTOR DE MANTENIMIENTO',
  `tipoProvee` enum('BIENES','SERVICIOS') COLLATE utf8mb4_unicode_ci NOT NULL,
  `idRegimen` int(11) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='datos del proveedor en general';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `qRealizanCapacitacion`
--

CREATE TABLE `qRealizanCapacitacion` (
  `qRIdCap` int(20) NOT NULL,
  `qRUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `oportunidades` int(11) NOT NULL DEFAULT '3',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Qrealizan_capacitacion`
--

CREATE TABLE `Qrealizan_capacitacion` (
  `id_qrealiza` int(11) NOT NULL,
  `Qr_idcap` int(20) NOT NULL,
  `Qr_Usuario` int(11) NOT NULL,
  `Oportunidades` int(11) NOT NULL DEFAULT '4'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `Qrealizan_capacitacion`
--
DELIMITER $$
CREATE TRIGGER `sumar_capacitacion` BEFORE INSERT ON `Qrealizan_capacitacion` FOR EACH ROW UPDATE `Notificaciones` SET `newcapacitacion`=newcapacitacion+1 WHERE `idusuario`=New.Qr_Usuario
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Qrencuestas`
--

CREATE TABLE `Qrencuestas` (
  `id_qrealiza` int(11) NOT NULL,
  `Usuario` int(20) NOT NULL,
  `Id_encuesta` int(19) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `qREncuestas`
--

CREATE TABLE `qREncuestas` (
  `idQRealiza` int(11) NOT NULL,
  `cedulaUsuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idEncuestaUser` int(19) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reencauchadoras`
--

CREATE TABLE `reencauchadoras` (
  `idReencauchadora` int(11) NOT NULL,
  `nombreReencauchadora` varchar(200) NOT NULL,
  `estado` enum('ACTIVO','INACTIVO') NOT NULL DEFAULT 'ACTIVO',
  `usuarioControl` varchar(50) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `regimenTributario`
--

CREATE TABLE `regimenTributario` (
  `id` int(11) NOT NULL,
  `descripcion` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipoMostrar` bigint(20) NOT NULL,
  `usuairoControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registroKilometrajeLlantas`
--

CREATE TABLE `registroKilometrajeLlantas` (
  `idRegistro` bigint(20) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `serialLlanta` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placaRemolque` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `placaCabezote` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `kmInicial` bigint(20) NOT NULL,
  `kmFinal` bigint(20) DEFAULT NULL,
  `kmTramo` bigint(20) GENERATED ALWAYS AS ((`kmFinal` - `kmInicial`)) STORED,
  `fechaInicio` datetime NOT NULL,
  `fechaFin` datetime DEFAULT NULL,
  `activo` tinyint(1) DEFAULT '1',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `registroKilometrajeLlantas`
--
DELIMITER $$
CREATE TRIGGER `trg_actualiza_km_llanta` AFTER UPDATE ON `registroKilometrajeLlantas` FOR EACH ROW BEGIN
  -- Solo acumular cuando el tramo se cierra (activo cambia de 1 a 0)
  -- y tiene un kmFinal válido
  IF OLD.activo = 1 AND NEW.activo = 0 AND NEW.kmFinal IS NOT NULL THEN
    -- Calcular kmTramo
    SET @km_tramo = NEW.kmFinal - NEW.kmInicial;
    
    -- Verificar si la llanta está en posición de repuesto
    -- LÓGICA SIMPLIFICADA:
    -- 1. El repuesto siempre es la última posición (idPosicion = cantidadLlantas)
    -- 2. Si cantidadLlantas es impar → hay repuesto
    -- 3. Si idPosicion = cantidadLlantas Y cantidadLlantas es impar → es repuesto
    -- 4. A esa posición no se le suma el km
    -- 
    -- ESTRATEGIA:
    -- 1. Obtener la posición de la llanta desde serialInstalar
    -- 2. Usar la información del tramo para determinar si es remolque o cabezote
    -- 3. Obtener cantidadLlantas del tipo de vehículo desde tiposVehiculos
    -- 4. Validar que esTraccion = 0 para remolque, esTraccion = 1 para cabezote
    -- 5. Verificar si idPosicion = cantidadLlantas Y cantidadLlantas es impar
    SET @es_repuesto = 0;
    SET @llanta_posicion = NULL;
    
    -- Obtener la posición de la llanta desde serialInstalar
    -- Nota: La llanta puede estar desmontada (placaVehSeri = '0'), pero la posición se mantiene
    SELECT si.idPosicion
    INTO @llanta_posicion
    FROM `qinspect_newpruebas`.`serialInstalar` si
    WHERE si.idProducto = NEW.idProducto 
      AND si.serial = NEW.serialLlanta
    LIMIT 1;
    
    -- Si encontramos la llanta y tiene posición válida (idPosicion > 0)
    IF @llanta_posicion IS NOT NULL AND @llanta_posicion > 0 THEN
      -- Verificar si es remolque (prioridad: primero remolque)
      -- Nota: esTraccion = 0 significa remolque, esTraccion = 1 significa cabezote
      IF NEW.placaRemolque IS NOT NULL AND NEW.placaRemolque != '' THEN
        -- Obtener cantidadLlantas del remolque desde tiposVehiculos
        -- Intentar primero con Remolque (mayúscula), luego con remolque (minúscula)
        SELECT tv.cantidadLlantas
        INTO @remolque_cantidad_llantas
        FROM `qinspect_newpruebas`.`Remolque` r
        INNER JOIN `qinspect_newpruebas`.`tiposVehiculos` tv ON tv.idTipVeh = r.Tv_Id
        WHERE r.Remol_Placa = NEW.placaRemolque
          AND tv.esTraccion = 0  -- Validar que es remolque
        LIMIT 1;
        
        -- Si no se encontró con Remolque, intentar con remolque (minúscula)
        IF @remolque_cantidad_llantas IS NULL THEN
          SELECT tv.cantidadLlantas
          INTO @remolque_cantidad_llantas
          FROM `qinspect_newpruebas`.`remolque` r
          INNER JOIN `qinspect_newpruebas`.`tiposVehiculos` tv ON tv.idTipVeh = r.Tv_Id
          WHERE r.placaRemolque = NEW.placaRemolque
            AND tv.esTraccion = 0
          LIMIT 1;
        END IF;
        
        -- Verificar si es repuesto: posición = cantidadLlantas Y cantidadLlantas es impar
        IF @remolque_cantidad_llantas IS NOT NULL 
           AND @llanta_posicion = @remolque_cantidad_llantas 
           AND @remolque_cantidad_llantas % 2 != 0 THEN
          SET @es_repuesto = 1;
        END IF;
      END IF;
      
      -- Verificar si es cabezote (solo si no es repuesto en remolque)
      -- Nota: esTraccion = 1 significa cabezote
      IF @es_repuesto = 0 AND NEW.placaCabezote IS NOT NULL AND NEW.placaCabezote != '' THEN
        -- Obtener cantidadLlantas del cabezote desde tiposVehiculos
        -- Nota: La tabla correcta es 'vehiculo' en minúscula con campo 'placa'
        SELECT tv.cantidadLlantas
        INTO @cabezote_cantidad_llantas
        FROM `qinspect_newpruebas`.`vehiculo` v
        INNER JOIN `qinspect_newpruebas`.`tiposVehiculos` tv ON tv.idTipVeh = v.idTipoVeh
        WHERE v.placa = NEW.placaCabezote
          AND tv.esTraccion = 1  -- Validar que es cabezote
        LIMIT 1;
        
        -- Verificar si es repuesto: posición = cantidadLlantas Y cantidadLlantas es impar
        IF @cabezote_cantidad_llantas IS NOT NULL 
           AND @llanta_posicion = @cabezote_cantidad_llantas 
           AND @cabezote_cantidad_llantas % 2 != 0 THEN
          SET @es_repuesto = 1;
        END IF;
      END IF;
    END IF;
    
    -- Solo acumular si NO es repuesto
    -- Si @es_repuesto = 0, significa que no es repuesto o no se encontró información
    -- En ese caso, acumulamos normalmente (por seguridad)
    -- IMPORTANTE: Si @es_repuesto = 1, NO acumulamos (es repuesto)
    IF @es_repuesto = 0 AND @km_tramo > 0 THEN
      -- Acumular en kmTotal de serialInstalar
      UPDATE `qinspect_newpruebas`.`serialInstalar`
      SET `kmTotal` = COALESCE(`kmTotal`, 0) + @km_tramo
      WHERE `idProducto` = NEW.idProducto 
        AND `serial` = NEW.serialLlanta;
      
      -- Log: se acumuló kilometraje
      SET @mensaje_log = CONCAT(
        'ACUMULADO - Posición: ', COALESCE(@llanta_posicion, 'NULL'),
        ', Cantidad: ', COALESCE(@remolque_cantidad_llantas, @cabezote_cantidad_llantas, 'NULL'),
        ', Es repuesto: ', @es_repuesto
      );
    ELSE
      -- Log: NO se acumuló (es repuesto o km_tramo <= 0)
      SET @mensaje_log = CONCAT(
        'NO ACUMULADO - Posición: ', COALESCE(@llanta_posicion, 'NULL'),
        ', Cantidad: ', COALESCE(@remolque_cantidad_llantas, @cabezote_cantidad_llantas, 'NULL'),
        ', Es repuesto: ', @es_repuesto,
        ', km_tramo: ', @km_tramo
      );
    END IF;
    
    -- Log para debugging (temporal, eliminar después de verificar)
    INSERT INTO `qinspect_newpruebas`.`log_trigger_debug` 
      (idRegistro, serialLlanta, idProducto, placaCabezote, placaRemolque, 
       llanta_posicion, cantidad_llantas, es_repuesto, km_tramo, mensaje)
    VALUES (
      NEW.idRegistro,
      NEW.serialLlanta,
      NEW.idProducto,
      NEW.placaCabezote,
      NEW.placaRemolque,
      @llanta_posicion,
      COALESCE(@remolque_cantidad_llantas, @cabezote_cantidad_llantas),
      @es_repuesto,
      @km_tramo,
      @mensaje_log
    );
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `remolque`
--

CREATE TABLE `remolque` (
  `idRemolque` int(11) NOT NULL,
  `placaRemolque` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revestimiento` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numeroEjesRemolque` int(11) NOT NULL,
  `capacidadToneladas` int(11) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Remolque`
--

CREATE TABLE `Remolque` (
  `Remol_Id` int(20) NOT NULL,
  `Remol_Placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remol_Color_Placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remol_LugarPlaca` int(20) NOT NULL,
  `Remol_Fech_Matricula` date NOT NULL,
  `Remol_Color` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remol_Marca` int(20) NOT NULL,
  `Remol_Linea` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'se remplazara por revestimiento',
  `Remol_Modelo` int(10) NOT NULL,
  `Remol_NumMatricula` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Remol_Numejes` int(11) NOT NULL,
  `Remol_CapTon` int(11) NOT NULL,
  `Remol_Estado` int(10) NOT NULL,
  `Prov_Id` int(20) NOT NULL,
  `Tv_Id` int(20) NOT NULL,
  `id_integracion` int(20) NOT NULL DEFAULT '0' COMMENT 'aca va el id del cliente al cual esta integrando el vehiculo, si no lleva siempre va 0 y si es tercero va 1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `Remolque`
--
DELIMITER $$
CREATE TRIGGER `actuRemolqueAdcional` BEFORE UPDATE ON `Remolque` FOR EACH ROW INSERT INTO `remolque`(`placaRemolque`, `revestimiento`, `numeroEjesRemolque`, `capacidadToneladas`, `usuarioControl`) VALUES (new.`Remol_Placa`, new.`Remol_Linea`,new.`Remol_Numejes`, new.`Remol_CapTon`, '123456788')on duplicate key UPDATE `revestimiento`= new.`Remol_Linea`, `numeroEjesRemolque`=new.`Remol_Numejes`, `capacidadToneladas`=new.`Remol_CapTon`
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actuVehiculoRemol` BEFORE UPDATE ON `Remolque` FOR EACH ROW INSERT INTO `vehiculo`(`placa`, `matricula`, `fechMatricula`, `colorPlaca`, `fkCiudadMatricula`, `fkMarca`, `modelo`, `colorVeh`, `estadoVeh`, `idProveedor`, `idTipoVeh`, `idIntegracion`, `usuarioControl`) VALUES ( new.`Remol_Placa`,new.`Remol_NumMatricula`,new.`Remol_Fech_Matricula`, new.`Remol_Color_Placa`, new.`Remol_LugarPlaca`,  new.`Remol_Marca`,new.`Remol_Modelo`,  new.`Remol_Color`,  new.`Remol_Estado`, new.`Prov_Id`, new.`Tv_Id`,new.id_integracion,'123456788') on duplicate KEY UPDATE  `matricula`=new.`Remol_NumMatricula`,  `fechMatricula`=new.`Remol_NumMatricula`, `colorPlaca`=new.`Remol_Placa`, `fkCiudadMatricula`=new.`Remol_LugarPlaca`, `fkMarca`=new.`Remol_Marca`, `modelo`=new.`Remol_Modelo`, `colorVeh`=new.`Remol_Color`, `estadoVeh`=new.`Remol_Estado`, `idProveedor`=new.`Prov_Id`, `idTipoVeh`=new.`Tv_Id`,idIntegracion=new.id_integracion
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertRemolAdicional` BEFORE INSERT ON `Remolque` FOR EACH ROW INSERT INTO `remolque`(`placaRemolque`, `revestimiento`, `numeroEjesRemolque`, `capacidadToneladas`, `usuarioControl`) VALUES (new.`Remol_Placa`, new.`Remol_Linea`,new.`Remol_Numejes`, new.`Remol_CapTon`, '123456788')on duplicate key UPDATE `revestimiento`= new.`Remol_Linea`, `numeroEjesRemolque`=new.`Remol_Numejes`, `capacidadToneladas`=new.`Remol_CapTon`
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertVehiRemol` BEFORE INSERT ON `Remolque` FOR EACH ROW INSERT INTO `vehiculo`(`placa`, `matricula`, `fechMatricula`, `colorPlaca`, `fkCiudadMatricula`, `fkMarca`, `modelo`, `colorVeh`, `estadoVeh`, `idProveedor`, `idTipoVeh`, `idIntegracion`, `usuarioControl`) VALUES ( new.`Remol_Placa`,new.`Remol_NumMatricula`,new.`Remol_Fech_Matricula`, new.`Remol_Color_Placa`, new.`Remol_LugarPlaca`,  new.`Remol_Marca`,new.`Remol_Modelo`,  new.`Remol_Color`,  new.`Remol_Estado`, new.`Prov_Id`, new.`Tv_Id`,new.id_integracion,'123456788') on duplicate KEY UPDATE  `matricula`=new.`Remol_NumMatricula`,  `fechMatricula`=new.`Remol_NumMatricula`, `colorPlaca`=new.`Remol_Placa`, `fkCiudadMatricula`=new.`Remol_LugarPlaca`, `fkMarca`=new.`Remol_Marca`, `modelo`=new.`Remol_Modelo`, `colorVeh`=new.`Remol_Color`, `estadoVeh`=new.`Remol_Estado`, `idProveedor`=new.`Prov_Id`, `idTipoVeh`=new.`Tv_Id`, idIntegracion=new.id_integracion
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reporteAuditoria`
--

CREATE TABLE `reporteAuditoria` (
  `idReporteAuditoria` int(11) NOT NULL,
  `observaciones` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `foto` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaAuditoria` datetime NOT NULL,
  `idResumenPreoperacional` int(11) NOT NULL,
  `personaDocumento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Reporte_Auditoria`
--

CREATE TABLE `Reporte_Auditoria` (
  `idReporte_Auditoria` int(11) NOT NULL,
  `Observaciones` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `Foto` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_auditoria` datetime NOT NULL,
  `idResumen_Preoperacional` int(11) NOT NULL,
  `Persona_Documento` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuestasCapacitacion`
--

CREATE TABLE `respuestasCapacitacion` (
  `idRespuestas` int(25) NOT NULL,
  `respuestas` varchar(450) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `puntaje` float(25,2) DEFAULT NULL,
  `idPregunta` int(25) NOT NULL,
  `fechaControl` datetime NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuestasEncuesta`
--

CREATE TABLE `respuestasEncuesta` (
  `idResp` int(19) NOT NULL,
  `idPregRta` int(19) NOT NULL,
  `descripcionResp` varchar(2000) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuestasEncuestasOk`
--

CREATE TABLE `respuestasEncuestasOk` (
  `idRespencUser` int(11) NOT NULL,
  `usuarioUser` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `respuestaSeleccionada` int(11) NOT NULL,
  `fechaCencuesta` datetime NOT NULL,
  `justificacion` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Respuestasencuestasok`
--

CREATE TABLE `Respuestasencuestasok` (
  `IdRespencUser` int(11) NOT NULL,
  `UsuarioUser` int(20) NOT NULL,
  `RespuestaSeleccionada` int(11) NOT NULL,
  `FechaCencuesta` datetime NOT NULL,
  `Justificacion` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuestasUsuario`
--

CREATE TABLE `respuestasUsuario` (
  `idRespuestaUsuario` int(25) NOT NULL,
  `fechaRealizacion` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuarioRealiza` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idRespuestas` int(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Respuestasv2`
--

CREATE TABLE `Respuestasv2` (
  `id_Respuestas` bigint(25) NOT NULL,
  `Respuestas` varchar(450) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Puntaje` float(25,2) DEFAULT NULL,
  `id_Pregunta` int(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuestas_usuario`
--

CREATE TABLE `respuestas_usuario` (
  `id_Respuesta_Usuario` int(25) NOT NULL,
  `Fecha_Realizacion` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_Realiza` int(25) NOT NULL,
  `id_Respuestas` bigint(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `respuestas_usuario`
--
DELIMITER $$
CREATE TRIGGER `actualizacion_notificacion_capacitacion` AFTER INSERT ON `respuestas_usuario` FOR EACH ROW UPDATE `Notificaciones` SET `newcapacitacion`=((SELECT COUNT(*) FROM `Qrealizan_capacitacion` INNER JOIN capacitacion_v2 on capacitacion_v2.id_Capacitacion=Qrealizan_capacitacion.Qr_idcap WHERE Qr_Usuario=new.id_Realiza  AND capacitacion_v2.Estado_Capacitacion=1)-(SELECT COUNT( DISTINCT id_Capacitacion) FROM `capacitacion_v2` INNER JOIN preguntas_has_capacitacion on preguntas_has_capacitacion.id_Capacitacion1=capacitacion_v2.id_Capacitacion INNER JOIN Preguntas_v2 on preguntas_has_capacitacion.id_Pregunta1=Preguntas_v2.id_Pregunta INNER JOIN Respuestasv2 on Respuestasv2.id_Pregunta=Preguntas_v2.id_Pregunta INNER JOIN respuestas_usuario on respuestas_usuario.id_Respuestas=Respuestasv2.id_Respuestas WHERE respuestas_usuario.id_Realiza=new.id_Realiza AND capacitacion_v2.Estado_Capacitacion=1))  WHERE idusuario=new.id_Realiza
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `resumenPreoperacional`
--

CREATE TABLE `resumenPreoperacional` (
  `idResumen` int(11) NOT NULL,
  `fechaPreoperacional` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ciudadGps` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Ubicación gps del preoperacional',
  `kilometraje` int(11) NOT NULL DEFAULT '0',
  `cantTanqueoGalones` int(11) DEFAULT NULL,
  `urlFotoKm` longtext COLLATE utf8mb4_unicode_ci,
  `usuarioPreoperacional` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `numeroGuia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `urlFotoGuia` longtext COLLATE utf8mb4_unicode_ci,
  `placaVehiculo` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placaRemolque` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idCiudad` int(20) NOT NULL,
  `fotoCabezote` longtext COLLATE utf8mb4_unicode_ci,
  `fotoTrailer` longtext COLLATE utf8mb4_unicode_ci,
  `tipoPreope` enum('G','I') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'G',
  `idrol` int(20) DEFAULT NULL,
  `positionGps` text CHARACTER SET armscii8 COLLATE armscii8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='parte ppl del preoperacional';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Rol`
--

CREATE TABLE `Rol` (
  `Rol_Id` int(20) NOT NULL,
  `Rol_Nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Rol_Descripcion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='lista de los roles con su especificacion';

--
-- Disparadores `Rol`
--
DELIMITER $$
CREATE TRIGGER `actuRol` BEFORE INSERT ON `Rol` FOR EACH ROW INSERT INTO `rol`(`rolId`, `rolNombre`, `rolDescripcion`, `usuarioControl`) VALUES (new.`Rol_Id`, new.`Rol_Nombre`, new.`Rol_Descripcion`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `rolId` int(20) NOT NULL,
  `rolNombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rolDescripcion` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='lista de los roles con su especificacion';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rtaPreoperacional`
--

CREATE TABLE `rtaPreoperacional` (
  `idRtaPreop` int(20) NOT NULL,
  `rtaUsuario` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idPreoperacional` int(11) NOT NULL,
  `idItemInps` int(20) NOT NULL,
  `fechaVencimiento` date DEFAULT NULL COMMENT 'si aplica en el item de lo contrario va null'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='respuestas del preoperacional en general';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serialEjecutorM`
--

CREATE TABLE `serialEjecutorM` (
  `idEjecutorM` int(11) NOT NULL,
  `idProy` int(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idReservEm` int(11) NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `serialEjecutorM`
--
DELIMITER $$
CREATE TRIGGER `updateTranferEm` BEFORE INSERT ON `serialEjecutorM` FOR EACH ROW UPDATE `serialInstalar` SET `idEjecutorM`=NEW.idEjecutorM,`idProy`=NEW.idProy WHERE `idProducto`=NEW.idProducto AND `serial`=NEW.serial
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serialEntradaInventario`
--

CREATE TABLE `serialEntradaInventario` (
  `idEncEntradaInv` int(6) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idReserva` int(2) NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `fechaFabricacion` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serialInstalar`
--

CREATE TABLE `serialInstalar` (
  `idProducto` int(11) NOT NULL,
  `idBodega` int(11) NOT NULL,
  `idLoteSerial` int(2) NOT NULL COMMENT 'hace referencia acategoria',
  `idTipoReserva` int(11) NOT NULL COMMENT 'hace referencia a proposito',
  `valUnitario` float(20,2) NOT NULL,
  `mmActual` float(7,2) NOT NULL,
  `iva` float(20,2) NOT NULL,
  `kmPresuntivo` bigint(20) NOT NULL,
  `kmTotal` bigint(20) NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `placaVehSeri` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0' COMMENT '0 0 si no está asignado',
  `idEjecutorM` int(11) NOT NULL DEFAULT '0',
  `idProy` int(11) NOT NULL DEFAULT '0',
  `idPosicion` int(4) NOT NULL DEFAULT '0' COMMENT '0 0 si no está asignado',
  `fechaFabricacion` date NOT NULL COMMENT 'esta es inmodificable',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de Control',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkIdEstadoLlanta` bigint(11) DEFAULT NULL COMMENT 'FK a estadosLlantas.idEstadoLlanta',
  `serialOriginal` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Serial original sin prefijos',
  `cicloReencauche` enum('NUEVA','R1','R2','R3') COLLATE utf8mb4_unicode_ci DEFAULT 'NUEVA',
  `idReencauchadora` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serialSalProveedor`
--

CREATE TABLE `serialSalProveedor` (
  `idEncSalProv` int(6) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idReserva` int(2) NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `serialSalProveedor`
--
DELIMITER $$
CREATE TRIGGER `delInvSalProvSerial` BEFORE INSERT ON `serialSalProveedor` FOR EACH ROW DELETE FROM serialInstalar
    WHERE idProducto = NEW.idProducto
    AND serial = NEW.serial
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serialTranferEm`
--

CREATE TABLE `serialTranferEm` (
  `idEncTranfer` int(6) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idReservEm` int(11) NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serialTranferReserva`
--

CREATE TABLE `serialTranferReserva` (
  `idEncTranfer` int(6) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idOldReserva` int(11) NOT NULL,
  `idNewReserva` int(11) NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `serialTranferReserva`
--
DELIMITER $$
CREATE TRIGGER `updatesSerialTranfer` BEFORE INSERT ON `serialTranferReserva` FOR EACH ROW UPDATE `serialInstalar` SET `idTipoReserva`=NEW.idNewReserva  WHERE serial=NEW.serial AND idProducto=NEW.idProducto
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `serialTranferReturn`
--

CREATE TABLE `serialTranferReturn` (
  `idEncTranfer` bigint(11) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `idLote` int(2) NOT NULL,
  `idReservEm` int(11) NOT NULL,
  `serial` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valUnitario` float(20,2) NOT NULL,
  `iva` float(20,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `serialTranferReturn`
--
DELIMITER $$
CREATE TRIGGER `updateTranferReturn` BEFORE INSERT ON `serialTranferReturn` FOR EACH ROW UPDATE `serialInstalar` SET `idEjecutorM`=0,`idProy`=0 WHERE `idProducto`=NEW.idProducto AND `serial`=NEW.serial
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursalesProv`
--

CREATE TABLE `sucursalesProv` (
  `idSucursal` int(11) NOT NULL,
  `idProvSucursal` int(20) NOT NULL,
  `idCiudad` int(11) NOT NULL,
  `direccion` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombreContactoSucursal` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefonoContactoSucursal` varchar(15) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoSucursal` int(1) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticketsSoporte`
--

CREATE TABLE `ticketsSoporte` (
  `idTicket` int(11) NOT NULL,
  `asunto` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Asunto del ticket',
  `categoria` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Categoría: error_sistema, consulta_funcionalidad, solicitud_mejora, problema_rendimiento, problema_acceso, otro',
  `prioridad` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Prioridad: baja, media, alta, critica',
  `modulo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Módulo relacionado: tirecheck, inventario, mantenimiento, inspeccion, integridad, maestras, otro',
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Descripción detallada del problema o consulta',
  `pasosReproducir` text COLLATE utf8mb4_unicode_ci COMMENT 'Pasos para reproducir el problema (si aplica)',
  `estado` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Abierto' COMMENT 'Estado: Abierto, En Proceso, Resuelto, Cerrado',
  `usuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Documento del usuario que crea el ticket',
  `usuarioAsignado` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Documento del usuario de soporte asignado',
  `fechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaActualizacion` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `fechaResolucion` datetime DEFAULT NULL COMMENT 'Fecha en que se resolvió el ticket'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tickets de soporte técnico';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticketsSoporteArchivos`
--

CREATE TABLE `ticketsSoporteArchivos` (
  `idArchivo` int(11) NOT NULL,
  `idTicket` int(11) NOT NULL COMMENT 'ID del ticket al que pertenece el archivo',
  `nombreArchivo` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Nombre original del archivo',
  `rutaArchivo` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Ruta donde se almacena el archivo',
  `tipoArchivo` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tipo MIME del archivo',
  `tamanoArchivo` bigint(20) DEFAULT NULL COMMENT 'Tamaño del archivo en bytes',
  `fechaSubida` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Archivos adjuntos a tickets de soporte';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ticketsSoporteRespuestas`
--

CREATE TABLE `ticketsSoporteRespuestas` (
  `idRespuesta` int(11) NOT NULL,
  `idTicket` int(11) NOT NULL COMMENT 'ID del ticket al que pertenece la respuesta',
  `mensaje` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mensaje de la respuesta',
  `usuario` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Documento del usuario que responde',
  `esUsuario` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = respuesta del soporte, 1 = respuesta del usuario',
  `fechaRespuesta` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Respuestas a tickets de soporte';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoAdjuntos`
--

CREATE TABLE `tipoAdjuntos` (
  `idTipoAdjuntos` int(25) NOT NULL,
  `tipoAdjunto` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoDesgaste`
--

CREATE TABLE `tipoDesgaste` (
  `id` int(11) NOT NULL,
  `rangoInicial` int(11) NOT NULL,
  `rangoFinal` int(11) NOT NULL,
  `urlLlanta` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estado` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoDocumento`
--

CREATE TABLE `tipoDocumento` (
  `idTipoDocumento` int(20) NOT NULL,
  `nombreTipoDocumento` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lista de todos los documentos existentes';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoLlantas`
--

CREATE TABLE `tipoLlantas` (
  `idTipoLlantas` int(20) NOT NULL,
  `nombreTipoLlantas` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lista de todos los dotipos de llantas existentes';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoPregunta`
--

CREATE TABLE `tipoPregunta` (
  `idTipoPregunta` int(11) NOT NULL,
  `nombreTipoPregunta` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoReserva`
--

CREATE TABLE `tipoReserva` (
  `idReserva` int(11) NOT NULL,
  `nombreReserva` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoReserva` enum('ACTIVO','INACTIVO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Datos de Control',
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Datos de usuario Control'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipoRin`
--

CREATE TABLE `tipoRin` (
  `idTipoRin` int(20) NOT NULL,
  `nombreTipoRin` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lista de todos los dotipos de Rin existentes';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tiposVehiculos`
--

CREATE TABLE `tiposVehiculos` (
  `idTipVeh` int(20) NOT NULL,
  `descripcionTipVeh` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `esTraccion` tinyint(1) NOT NULL,
  `estadoTipVeh` int(11) NOT NULL DEFAULT '1',
  `cantidadLlantas` int(11) NOT NULL,
  `tieneLlantaRepuesto` int(1) NOT NULL DEFAULT '0',
  `aplicaRemolque` int(1) NOT NULL DEFAULT '0',
  `tipoEnganche` json NOT NULL,
  `pesoMaxRemolque` decimal(8,2) DEFAULT NULL,
  `longitudMaxRemolque` decimal(5,2) DEFAULT NULL,
  `urlImgChasis` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tipos de vehiculo que existen';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Tipos_Vehiculos`
--

CREATE TABLE `Tipos_Vehiculos` (
  `Tv_Id` int(20) NOT NULL,
  `Tv_descripcion` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Tv_estado` int(11) NOT NULL DEFAULT '1',
  `aplica_remolque` int(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='tipos de vehiculo que existen';

--
-- Disparadores `Tipos_Vehiculos`
--
DELIMITER $$
CREATE TRIGGER `actuTipoVehiculo` BEFORE INSERT ON `Tipos_Vehiculos` FOR EACH ROW INSERT INTO `tiposVehiculos`(`idTipVeh`, `descripcionTipVeh`, `estadoTipVeh`, `aplicaRemolque`, `usuarioControl`) VALUES (new.`Tv_Id`, new.`Tv_descripcion`, new.`Tv_estado`, new.`aplica_remolque`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_adjuntos`
--

CREATE TABLE `tipo_adjuntos` (
  `id_Tipo_Adjuntos` int(25) NOT NULL,
  `Tipo_Adjunto` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `tipo_adjuntos`
--
DELIMITER $$
CREATE TRIGGER `actuTipoAdjunto` BEFORE INSERT ON `tipo_adjuntos` FOR EACH ROW INSERT INTO `tipoAdjuntos`(`idTipoAdjuntos`, `tipoAdjunto`, `usuarioControl`) VALUES (new.`id_Tipo_Adjuntos`, new.`Tipo_Adjunto`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Tipo_Documento`
--

CREATE TABLE `Tipo_Documento` (
  `TipoDoc_Id` int(20) NOT NULL,
  `TipoDoc_Descrip` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Lista de todos los documentos existentes';

--
-- Disparadores `Tipo_Documento`
--
DELIMITER $$
CREATE TRIGGER `actuTpDoc` BEFORE INSERT ON `Tipo_Documento` FOR EACH ROW INSERT INTO `tipoDocumento`(`idTipoDocumento`, `nombreTipoDocumento`,  `usuarioControl`) VALUES (new.`TipoDoc_Id`, new.`TipoDoc_Descrip`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_pregunta`
--

CREATE TABLE `tipo_pregunta` (
  `id_TipoPregunta` int(11) NOT NULL,
  `Tipo_Pregunta` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Disparadores `tipo_pregunta`
--
DELIMITER $$
CREATE TRIGGER `actuTpPregun` BEFORE INSERT ON `tipo_pregunta` FOR EACH ROW INSERT INTO `tipoPregunta`(`idTipoPregunta`, `nombreTipoPregunta`, `usuarioControl`) VALUES (new.`id_TipoPregunta`, new.`Tipo_Pregunta`,123456788)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trazabilidadReencauches`
--

CREATE TABLE `trazabilidadReencauches` (
  `idTrazabilidad` int(11) NOT NULL,
  `serialOriginal` varchar(100) NOT NULL,
  `serialActual` varchar(100) NOT NULL,
  `idProducto` int(11) NOT NULL,
  `cicloReencauche` enum('R1','R2','R3') DEFAULT NULL,
  `idBodegaOrigen` int(11) DEFAULT NULL,
  `idBodegaDestino` int(11) NOT NULL,
  `idReencauchadora` int(11) DEFAULT NULL,
  `fechaMovimiento` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estadoMovimiento` enum('EN_PROSPECTO','EN_REENCAUCHADORA','REENCAUCHADA','RECHAZADA','EN_OPERACION') NOT NULL,
  `observaciones` text,
  `usuarioControl` varchar(50) NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Usuario`
--

CREATE TABLE `Usuario` (
  `Usuario_Id` int(20) NOT NULL,
  `UsuarioUser` bigint(20) NOT NULL,
  `Usuario_Contra` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Usuario_Estado` tinyint(1) NOT NULL COMMENT 'es para identificar si esta activo o retirado de la compañia',
  `Rol_Id` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='lista de uduarios que pueden ingresar a la base de datos';

--
-- Disparadores `Usuario`
--
DELIMITER $$
CREATE TRIGGER `actuPersoUserActuUser` BEFORE UPDATE ON `Usuario` FOR EACH ROW UPDATE `personal` SET `password`=new.`Usuario_Contra`,`estadoPersonal`=new.`Usuario_Estado`,`fkIdRol`=new.`Rol_Id` WHERE numeroDocumento= new.`UsuarioUser`
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actuPersoUserInsertUser` BEFORE INSERT ON `Usuario` FOR EACH ROW UPDATE `personal` SET `password`=new.`Usuario_Contra`,`estadoPersonal`=new.`Usuario_Estado`,`fkIdRol`=new.`Rol_Id` WHERE numeroDocumento= new.`UsuarioUser`
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `nuevo_usuario_notificacion` BEFORE INSERT ON `Usuario` FOR EACH ROW REPLACE INTO `Notificaciones`( `idusuario`, `newcapacitacion`, `newinspeccion`) VALUES (NEW.UsuarioUser,0,0)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarioPermisoBodega`
--

CREATE TABLE `usuarioPermisoBodega` (
  `usuarioPermiso` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `idBodegaPermiso` int(11) NOT NULL,
  `estadoPermiso` int(1) NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechaControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='relacion de permisos a entrar a las diferentes bodega';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Vehiculo`
--

CREATE TABLE `Vehiculo` (
  `Veh_Id` int(20) NOT NULL,
  `Veh_Placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Veh_KmActual` int(10) DEFAULT NULL,
  `Veh_Fech_Matricula` date NOT NULL,
  `Veh_Color_Placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Veh_LugarPlaca` int(20) NOT NULL,
  `Veh_Marca` int(20) NOT NULL,
  `Veh_Linea` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Veh_Modelo` int(10) NOT NULL,
  `Veh_Cilindraje` int(10) NOT NULL,
  `Veh_Color` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Veh_Combustible` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Veh_Motor` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Veh_Serie` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Veh_Estado` int(2) NOT NULL,
  `Prov_Id` int(20) NOT NULL,
  `Tv_Id` int(20) NOT NULL,
  `id_integracion` int(20) NOT NULL DEFAULT '0' COMMENT 'aca va el id del cliente al cual esta integrando el vehiculo, si no lleva siempre va 0',
  `fechaActualizacion` datetime DEFAULT NULL COMMENT 'Fecha de última actualización del kilometraje'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Datos de vehiculo general';

--
-- Disparadores `Vehiculo`
--
DELIMITER $$
CREATE TRIGGER `actuVehiculoCabeAdicional` BEFORE UPDATE ON `Vehiculo` FOR EACH ROW UPDATE `cabezoteVehiculo` SET `cilindraje`=new.`Veh_Cilindraje`,`combustible`=new.`Veh_Combustible`,`numeroMotor`=new.`Veh_Motor`,`numeroSerie`=new.`Veh_Serie`,`lineaVeh`=new.`Veh_Linea`,`fechaControl`=CURRENT_TIMESTAMP WHERE `placaCabezote`=new.`Veh_Placa`
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `actuVehiculoCabezote` BEFORE UPDATE ON `Vehiculo` FOR EACH ROW UPDATE `vehiculo` SET  `fechMatricula`=NEW.`Veh_Fech_Matricula`, `colorPlaca`=NEW.`Veh_Color_Placa`, `fkCiudadMatricula`=new.`Veh_LugarPlaca`, `fkMarca`=new.`Veh_Marca`, `modelo`=new.`Veh_Modelo`, `colorVeh`=NEW.`Veh_Color`, `estadoVeh`=NEW.`Veh_Estado`, `idProveedor`=NEW.`Prov_Id`, `idTipoVeh`=NEW.`Tv_Id`, `idIntegracion`=NEW.`id_integracion`,`fechaControl`= CURRENT_TIMESTAMP WHERE `placa`=NEW.`Veh_Placa`
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertVehiCabe` BEFORE INSERT ON `Vehiculo` FOR EACH ROW INSERT INTO `vehiculo`(`placa`, `matricula`, `fechMatricula`, `colorPlaca`, `fkCiudadMatricula`, `fkMarca`, `modelo`, `colorVeh`, `estadoVeh`, `idProveedor`, `idTipoVeh`, `idIntegracion`, `usuarioControl`) VALUES ( new.`Veh_Placa`,'',new.`Veh_Fech_Matricula`, new.`Veh_Color_Placa`, new.`Veh_LugarPlaca`, new.`Veh_Marca`,new.`Veh_Modelo`, new.`Veh_Color`, new.`Veh_Estado`, new.`Prov_Id`, new.`Tv_Id`,0,'123456788')on duplicate key UPDATE usuarioControl='123456788'
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insertVehiCabeAdic` BEFORE INSERT ON `Vehiculo` FOR EACH ROW INSERT INTO `cabezoteVehiculo`( `cilindraje`, `combustible`, `numeroMotor`, `numeroSerie`, `lineaVeh`, `placaCabezote`, `usuarioControl`) VALUES (new.`Veh_Cilindraje`, new.`Veh_Combustible`, new.`Veh_Motor`, new.`Veh_Serie`, new.`Veh_Linea`,new.`Veh_Placa`,'123456788')on duplicate key UPDATE usuarioControl='123456788'
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vehiculo`
--

CREATE TABLE `vehiculo` (
  `placa` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `matricula` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechMatricula` date NOT NULL,
  `colorPlaca` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fkCiudadMatricula` int(20) NOT NULL,
  `fkMarca` int(20) NOT NULL,
  `modelo` int(10) NOT NULL,
  `colorVeh` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `estadoVeh` int(1) NOT NULL,
  `idProveedor` int(20) NOT NULL,
  `idTipoVeh` int(20) NOT NULL,
  `idIntegracion` int(20) NOT NULL DEFAULT '0' COMMENT 'aca va el id del cliente al cual esta integrando el vehiculo, si no lleva siempre va 0',
  `fechaControl` datetime NOT NULL,
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Datos de vehiculo general';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `versionFormatos`
--

CREATE TABLE `versionFormatos` (
  `idVersion` int(11) NOT NULL,
  `nombreFormato` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pertenece` enum('Preoperacional','Capacitaciones','Encuestas','Especial') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'a que tipo de formato pertenece, para asi mismo mostrar en los pdf',
  `idEmpresaFormato` int(20) NOT NULL,
  `paginacion` enum('NO','SI') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `fPredefinida` enum('NO','SI') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `usuarioFirma` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visible` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SI',
  `iniciaAdmin` enum('NO','SI') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'si= diferente a conductor; no para el conductor',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `version_formatos`
--

CREATE TABLE `version_formatos` (
  `Id_version` int(11) NOT NULL,
  `Nombre_formato` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pertenece` enum('Preoperacional','Capacitaciones','Encuestas','Especial') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'a que tipo de formato pertenece, para asi mismo mostrar en los pdf',
  `id_empresa` int(20) NOT NULL,
  `paginacion` enum('NO','SI') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `fPredefinida` enum('NO','SI') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'NO',
  `usuarioFirma` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `visible` enum('SI','NO') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'SI',
  `iniciaAdmin` enum('NO','SI') COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'si= diferente a conductor; no para el conductor',
  `usuarioControl` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fechControl` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vigencia`
--

CREATE TABLE `vigencia` (
  `id_Vigencia` int(25) NOT NULL,
  `Fecha_Inico` date DEFAULT NULL,
  `Fecha_Fin` date DEFAULT NULL,
  `id_Capacitacion1` int(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vigenciaCapacitacion`
--

CREATE TABLE `vigenciaCapacitacion` (
  `idVigencia` int(25) NOT NULL,
  `fechaInico` date DEFAULT NULL,
  `fechaFin` date DEFAULT NULL,
  `fkIdCapacitacion` int(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vistaControlLlantas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vistaControlLlantas` (
`codigoLlanta` varchar(100)
,`remolqueActual` varchar(10)
,`kmAcumulado` bigint(20)
,`vidaUtilKm` int(11)
,`porcentajeVida` decimal(25,2)
,`descripcionLlanta` varchar(500)
,`marca` varchar(200)
,`placaCabezote` varchar(10)
,`kmTramo` bigint(20)
,`fechaFin` datetime
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_estadisticas_satisfaccion_conductor`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_estadisticas_satisfaccion_conductor` (
`id_programacion_mtto` int(11)
,`documento_conductor` varchar(20)
,`nombre_conductor` varchar(200)
,`placa` varchar(10)
,`vehiculo_nombre` varchar(10)
,`calificacion_general` tinyint(4)
,`fecha_calificacion` datetime
,`calidad_promedio` decimal(7,4)
,`puntualidad_promedio` decimal(7,4)
,`limpieza_promedio` decimal(7,4)
,`comunicacion_promedio` decimal(7,4)
,`profesionalismo_promedio` decimal(7,4)
,`promedio_criterios` decimal(7,4)
,`comentarios` text
,`ejecutor_principal` varchar(101)
,`nivel_satisfaccion` varchar(10)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_satisfaccion_por_ejecutor`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_satisfaccion_por_ejecutor` (
`ejecutor_nombre` varchar(101)
,`tipo_ejecutor` varchar(7)
,`total_calificaciones` bigint(21)
,`promedio_calificacion` decimal(7,4)
,`calidad_promedio` decimal(7,4)
,`puntualidad_promedio` decimal(7,4)
,`limpieza_promedio` decimal(7,4)
,`comunicacion_promedio` decimal(7,4)
,`profesionalismo_promedio` decimal(7,4)
,`porcentaje_satisfaccion` decimal(9,2)
,`nivel_satisfaccion` varchar(10)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `v_satisfaccion_por_vehiculo`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `v_satisfaccion_por_vehiculo` (
`placa` varchar(10)
,`vehiculo_nombre` varchar(10)
,`total_calificaciones` bigint(21)
,`promedio_calificacion` decimal(7,4)
,`calificacion_minima` tinyint(4)
,`calificacion_maxima` tinyint(4)
,`calificaciones_5_estrellas` decimal(23,0)
,`calificaciones_4_estrellas` decimal(23,0)
,`calificaciones_3_estrellas` decimal(23,0)
,`calificaciones_2_estrellas` decimal(23,0)
,`calificaciones_1_estrella` decimal(23,0)
,`porcentaje_satisfaccion` decimal(9,2)
,`ultima_calificacion` datetime
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vistaControlLlantas`
--
DROP TABLE IF EXISTS `vistaControlLlantas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`qinspect`@`localhost` SQL SECURITY DEFINER VIEW `vistaControlLlantas`  AS SELECT `si`.`serial` AS `codigoLlanta`, `si`.`placaVehSeri` AS `remolqueActual`, `si`.`kmTotal` AS `kmAcumulado`, `ma`.`vidaUtilKm` AS `vidaUtilKm`, (case when (`ma`.`vidaUtilKm` > 0) then round(((`si`.`kmTotal` / `ma`.`vidaUtilKm`) * 100),2) else 0 end) AS `porcentajeVida`, `ma`.`descripcion` AS `descripcionLlanta`, (select `manMarcaArticulos`.`descripcion` from `manMarcaArticulos` where (`manMarcaArticulos`.`idMarcaArticulos` = `ma`.`fkIdMarcaArticulos`)) AS `marca`, `rk`.`placaCabezote` AS `placaCabezote`, `rk`.`kmTramo` AS `kmTramo`, `rk`.`fechaFin` AS `fechaFin` FROM ((`serialInstalar` `si` join `manArticulos` `ma` on((`si`.`idProducto` = `ma`.`idArticulo`))) left join `registroKilometrajeLlantas` `rk` on(((`si`.`idProducto` = `rk`.`idProducto`) and (`si`.`serial` = `rk`.`serialLlanta`) and (`rk`.`activo` = 0)))) ORDER BY `rk`.`fechaFin` DESC ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_estadisticas_satisfaccion_conductor`
--
DROP TABLE IF EXISTS `v_estadisticas_satisfaccion_conductor`;

CREATE ALGORITHM=UNDEFINED DEFINER=`qinspect`@`localhost` SQL SECURITY DEFINER VIEW `v_estadisticas_satisfaccion_conductor`  AS SELECT `csc`.`id_programacion_mtto` AS `id_programacion_mtto`, `csc`.`documento_conductor` AS `documento_conductor`, `csc`.`nombre_conductor` AS `nombre_conductor`, `pm`.`placa` AS `placa`, `pm`.`placa` AS `vehiculo_nombre`, `csc`.`calificacion_general` AS `calificacion_general`, `csc`.`fecha_calificacion` AS `fecha_calificacion`, avg((case when (`cscd`.`criterio` = 'quality') then `cscd`.`calificacion` end)) AS `calidad_promedio`, avg((case when (`cscd`.`criterio` = 'punctuality') then `cscd`.`calificacion` end)) AS `puntualidad_promedio`, avg((case when (`cscd`.`criterio` = 'cleanliness') then `cscd`.`calificacion` end)) AS `limpieza_promedio`, avg((case when (`cscd`.`criterio` = 'communication') then `cscd`.`calificacion` end)) AS `comunicacion_promedio`, avg((case when (`cscd`.`criterio` = 'professionalism') then `cscd`.`calificacion` end)) AS `profesionalismo_promedio`, avg(`cscd`.`calificacion`) AS `promedio_criterios`, `csc`.`comentarios` AS `comentarios`, coalesce(concat(`p`.`nombres`,' ',`p`.`apellidos`),`prov`.`nombreProv`,'Sin ejecutor') AS `ejecutor_principal`, (case when (`csc`.`calificacion_general` >= 4.5) then 'Excelente' when (`csc`.`calificacion_general` >= 3.5) then 'Bueno' when (`csc`.`calificacion_general` >= 2.5) then 'Regular' else 'Deficiente' end) AS `nivel_satisfaccion` FROM ((((((((`calificacionesServicioConductor` `csc` join `programacion_mtto` `pm` on((`csc`.`id_programacion_mtto` = `pm`.`id`))) left join `calificacionesServicioConductorDetalle` `cscd` on((`csc`.`id` = `cscd`.`id_calificacion`))) left join `programacion_mtto_asignacion_em_tareas` `pmat` on((`pm`.`id` = `pmat`.`id_programacion_mtto`))) left join `ejecutores_mtto_interno` `emi` on(((`pmat`.`id_em` = `emi`.`id`) and (`pmat`.`tipo_em` = 'interno')))) left join `personal` `p` on((`emi`.`document` = `p`.`numeroDocumento`))) left join `ejecutores_mtto_externo` `eme` on(((`pmat`.`id_em` = `eme`.`id`) and (`pmat`.`tipo_em` = 'externo')))) left join `sucursalesProv` `sp` on((`eme`.`id_sucursal` = `sp`.`idSucursal`))) left join `proveedor` `prov` on((`sp`.`idProvSucursal` = `prov`.`idProv`))) GROUP BY `csc`.`id`, `csc`.`id_programacion_mtto`, `csc`.`documento_conductor`, `csc`.`nombre_conductor`, `pm`.`placa`, `csc`.`calificacion_general`, `csc`.`fecha_calificacion`, `csc`.`comentarios`, `p`.`nombres`, `p`.`apellidos`, `prov`.`nombreProv` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_satisfaccion_por_ejecutor`
--
DROP TABLE IF EXISTS `v_satisfaccion_por_ejecutor`;

CREATE ALGORITHM=UNDEFINED DEFINER=`qinspect`@`localhost` SQL SECURITY DEFINER VIEW `v_satisfaccion_por_ejecutor`  AS SELECT coalesce(concat(`p`.`nombres`,' ',`p`.`apellidos`),`prov`.`nombreProv`,'Sin ejecutor') AS `ejecutor_nombre`, (case when (`pmat`.`tipo_em` = 'interno') then 'Interno' when (`pmat`.`tipo_em` = 'externo') then 'Externo' else 'N/A' end) AS `tipo_ejecutor`, count(distinct `csc`.`id`) AS `total_calificaciones`, avg(`csc`.`calificacion_general`) AS `promedio_calificacion`, avg((case when (`cscd`.`criterio` = 'quality') then `cscd`.`calificacion` end)) AS `calidad_promedio`, avg((case when (`cscd`.`criterio` = 'punctuality') then `cscd`.`calificacion` end)) AS `puntualidad_promedio`, avg((case when (`cscd`.`criterio` = 'cleanliness') then `cscd`.`calificacion` end)) AS `limpieza_promedio`, avg((case when (`cscd`.`criterio` = 'communication') then `cscd`.`calificacion` end)) AS `comunicacion_promedio`, avg((case when (`cscd`.`criterio` = 'professionalism') then `cscd`.`calificacion` end)) AS `profesionalismo_promedio`, round(((avg(`csc`.`calificacion_general`) / 5) * 100),2) AS `porcentaje_satisfaccion`, (case when (avg(`csc`.`calificacion_general`) >= 4.5) then 'Excelente' when (avg(`csc`.`calificacion_general`) >= 3.5) then 'Bueno' when (avg(`csc`.`calificacion_general`) >= 2.5) then 'Regular' else 'Deficiente' end) AS `nivel_satisfaccion` FROM ((((((((`programacion_mtto` `pm` join `calificacionesServicioConductor` `csc` on((`pm`.`id` = `csc`.`id_programacion_mtto`))) left join `calificacionesServicioConductorDetalle` `cscd` on((`csc`.`id` = `cscd`.`id_calificacion`))) left join `programacion_mtto_asignacion_em_tareas` `pmat` on((`pm`.`id` = `pmat`.`id_programacion_mtto`))) left join `ejecutores_mtto_interno` `emi` on(((`pmat`.`id_em` = `emi`.`id`) and (`pmat`.`tipo_em` = 'interno')))) left join `personal` `p` on((`emi`.`document` = `p`.`numeroDocumento`))) left join `ejecutores_mtto_externo` `eme` on(((`pmat`.`id_em` = `eme`.`id`) and (`pmat`.`tipo_em` = 'externo')))) left join `sucursalesProv` `sp` on((`eme`.`id_sucursal` = `sp`.`idSucursal`))) left join `proveedor` `prov` on((`sp`.`idProvSucursal` = `prov`.`idProv`))) GROUP BY `ejecutor_nombre`, `tipo_ejecutor` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `v_satisfaccion_por_vehiculo`
--
DROP TABLE IF EXISTS `v_satisfaccion_por_vehiculo`;

CREATE ALGORITHM=UNDEFINED DEFINER=`qinspect`@`localhost` SQL SECURITY DEFINER VIEW `v_satisfaccion_por_vehiculo`  AS SELECT `pm`.`placa` AS `placa`, `pm`.`placa` AS `vehiculo_nombre`, count(distinct `csc`.`id`) AS `total_calificaciones`, avg(`csc`.`calificacion_general`) AS `promedio_calificacion`, min(`csc`.`calificacion_general`) AS `calificacion_minima`, max(`csc`.`calificacion_general`) AS `calificacion_maxima`, sum((case when (`csc`.`calificacion_general` = 5) then 1 else 0 end)) AS `calificaciones_5_estrellas`, sum((case when (`csc`.`calificacion_general` = 4) then 1 else 0 end)) AS `calificaciones_4_estrellas`, sum((case when (`csc`.`calificacion_general` = 3) then 1 else 0 end)) AS `calificaciones_3_estrellas`, sum((case when (`csc`.`calificacion_general` = 2) then 1 else 0 end)) AS `calificaciones_2_estrellas`, sum((case when (`csc`.`calificacion_general` = 1) then 1 else 0 end)) AS `calificaciones_1_estrella`, round(((avg(`csc`.`calificacion_general`) / 5) * 100),2) AS `porcentaje_satisfaccion`, max(`csc`.`fecha_calificacion`) AS `ultima_calificacion` FROM (`programacion_mtto` `pm` left join `calificacionesServicioConductor` `csc` on((`pm`.`id` = `csc`.`id_programacion_mtto`))) WHERE (`csc`.`id` is not null) GROUP BY `pm`.`placa` ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `accionesSistemaUsuario`
--
ALTER TABLE `accionesSistemaUsuario`
  ADD PRIMARY KEY (`idAccion`);

--
-- Indices de la tabla `adjuntosCapacitacion`
--
ALTER TABLE `adjuntosCapacitacion`
  ADD PRIMARY KEY (`idAdjCapacitacion`,`fkIdCapacitacion`,`fkIdTipoAdjunto`),
  ADD KEY `fk_adjunto_capacitacion_capacitacion1_idx` (`fkIdCapacitacion`),
  ADD KEY `fk_adjunto_capacitacion_tipo_adjuntos1_idx` (`fkIdTipoAdjunto`);

--
-- Indices de la tabla `adjuntosInspeccion`
--
ALTER TABLE `adjuntosInspeccion`
  ADD PRIMARY KEY (`idAdjunto`),
  ADD UNIQUE KEY `uk_adj_rta` (`idRtaInspeccion`),
  ADD KEY `Rdp_Id` (`idRtaInspeccion`);

--
-- Indices de la tabla `adjunto_capacitacion`
--
ALTER TABLE `adjunto_capacitacion`
  ADD PRIMARY KEY (`id_Adj_Capacitacion`,`id_Capacitacion1`,`id_Tipo_Adjunto1`),
  ADD KEY `fk_adjunto_capacitacion_capacitacion1_idx` (`id_Capacitacion1`),
  ADD KEY `fk_adjunto_capacitacion_tipo_adjuntos1_idx` (`id_Tipo_Adjunto1`);

--
-- Indices de la tabla `alertasMantenimiento`
--
ALTER TABLE `alertasMantenimiento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tipo` (`tipo`),
  ADD KEY `idx_prioridad` (`prioridad`),
  ADD KEY `idx_leida` (`leida`),
  ADD KEY `idx_fecha_control` (`fecha_control`),
  ADD KEY `idx_base_datos` (`base_datos`);

--
-- Indices de la tabla `alertasMantenimientoDestinatarios`
--
ALTER TABLE `alertasMantenimientoDestinatarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_alerta` (`id_alerta`),
  ADD KEY `idx_enviado` (`enviado`);

--
-- Indices de la tabla `almacenInventario`
--
ALTER TABLE `almacenInventario`
  ADD PRIMARY KEY (`idProducto`,`idAlmacen`,`idLote`,`idTipoReserva`,`valUnitario`,`iva`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `ID_Almacen` (`idAlmacen`),
  ADD KEY `ID_Lote` (`idLote`),
  ADD KEY `ID_Tipo_Reserva` (`idTipoReserva`);

--
-- Indices de la tabla `apilog`
--
ALTER TABLE `apilog`
  ADD PRIMARY KEY (`apiConsecutivo`);

--
-- Indices de la tabla `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`idArea`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `binomio_logs`
--
ALTER TABLE `binomio_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_timestamp` (`timestamp`),
  ADD KEY `idx_operation` (`operation`),
  ADD KEY `idx_user` (`user`),
  ADD KEY `idx_level` (`level`),
  ADD KEY `idx_result` (`result`),
  ADD KEY `idx_base` (`base`),
  ADD KEY `idx_timestamp_operation` (`timestamp`,`operation`),
  ADD KEY `idx_user_timestamp` (`user`,`timestamp`);

--
-- Indices de la tabla `cabezoteVehiculo`
--
ALTER TABLE `cabezoteVehiculo`
  ADD PRIMARY KEY (`idCabezote`),
  ADD UNIQUE KEY `placaCabezote` (`placaCabezote`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `vehPlaca` (`placaCabezote`);

--
-- Indices de la tabla `calificacionEm`
--
ALTER TABLE `calificacionEm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `calificacionesServicioConductor`
--
ALTER TABLE `calificacionesServicioConductor`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_programacion_conductor` (`id_programacion_mtto`,`documento_conductor`),
  ADD KEY `idx_programacion_mtto` (`id_programacion_mtto`),
  ADD KEY `idx_conductor` (`documento_conductor`),
  ADD KEY `idx_fecha_calificacion` (`fecha_calificacion`),
  ADD KEY `idx_calificacion_general` (`calificacion_general`);

--
-- Indices de la tabla `calificacionesServicioConductorDetalle`
--
ALTER TABLE `calificacionesServicioConductorDetalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_calificacion` (`id_calificacion`),
  ADD KEY `idx_criterio` (`criterio`);

--
-- Indices de la tabla `capacitacion`
--
ALTER TABLE `capacitacion`
  ADD PRIMARY KEY (`idCapacitacion`,`idCapacitador`),
  ADD KEY `fk_capacitacion_v2_capacitador1_idx` (`idCapacitador`),
  ADD KEY `idCapacitador` (`idCapacitador`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `capacitacion_v2`
--
ALTER TABLE `capacitacion_v2`
  ADD PRIMARY KEY (`id_Capacitacion`,`id_Capacitador`),
  ADD KEY `fk_capacitacion_v2_capacitador1_idx` (`id_Capacitador`);

--
-- Indices de la tabla `cargos`
--
ALTER TABLE `cargos`
  ADD PRIMARY KEY (`idCargo`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `Cargos`
--
ALTER TABLE `Cargos`
  ADD PRIMARY KEY (`Carg_id`);

--
-- Indices de la tabla `categoriaItems`
--
ALTER TABLE `categoriaItems`
  ADD PRIMARY KEY (`idCategoriaItem`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `categoriaLicencias`
--
ALTER TABLE `categoriaLicencias`
  ADD PRIMARY KEY (`idCategoriaLicencia`),
  ADD UNIQUE KEY `Cat_lic_id` (`idCategoriaLicencia`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `Categoria_item`
--
ALTER TABLE `Categoria_item`
  ADD PRIMARY KEY (`Cat_Item_Id`);

--
-- Indices de la tabla `Categoria_licencias`
--
ALTER TABLE `Categoria_licencias`
  ADD PRIMARY KEY (`Cat_lic_id`),
  ADD UNIQUE KEY `Cat_lic_id` (`Cat_lic_id`);

--
-- Indices de la tabla `cedulasAutorizaAlmacen`
--
ALTER TABLE `cedulasAutorizaAlmacen`
  ADD PRIMARY KEY (`idAutoriza`),
  ADD KEY `CcUsuario` (`CcUsuario`),
  ADD KEY `idAlmacen` (`idAlmacen`),
  ADD KEY `UduarioControl` (`UduarioControl`);

--
-- Indices de la tabla `ciudad`
--
ALTER TABLE `ciudad`
  ADD PRIMARY KEY (`idCiudad`),
  ADD KEY `Dpt_Id` (`fkIdDepartamento`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `Ciudad`
--
ALTER TABLE `Ciudad`
  ADD PRIMARY KEY (`Ciu_Id`),
  ADD KEY `Dpt_Id` (`Dpt_Id`);

--
-- Indices de la tabla `configuracionAlertasMantenimiento`
--
ALTER TABLE `configuracionAlertasMantenimiento`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_tipo_alerta` (`tipo_alerta`);

--
-- Indices de la tabla `correctivasLLantas`
--
ALTER TABLE `correctivasLLantas`
  ADD PRIMARY KEY (`idCorrectivasLlanta`),
  ADD KEY `placa` (`placa`),
  ADD KEY `idProducto` (`idProducto`),
  ADD KEY `userControl` (`userControl`);

--
-- Indices de la tabla `criterioEvaluacionEm`
--
ALTER TABLE `criterioEvaluacionEm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `criticidadEm`
--
ALTER TABLE `criticidadEm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `cursosCertificados`
--
ALTER TABLE `cursosCertificados`
  ADD PRIMARY KEY (`idCurso`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `cursosCertificadosCapacitacion`
--
ALTER TABLE `cursosCertificadosCapacitacion`
  ADD PRIMARY KEY (`idCertificado`),
  ADD KEY `id_Capacitacion` (`idCapacitacion`),
  ADD KEY `id_Usuario` (`idUsuario`),
  ADD KEY `id_Curso` (`idCurso`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `cursosCertificadosConductor`
--
ALTER TABLE `cursosCertificadosConductor`
  ADD PRIMARY KEY (`idUsuario`,`idCurso`),
  ADD KEY `id_Curso` (`idCurso`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `cursos_certificados`
--
ALTER TABLE `cursos_certificados`
  ADD PRIMARY KEY (`id_Curso`);

--
-- Indices de la tabla `cursos_certificados_has_capacitacion`
--
ALTER TABLE `cursos_certificados_has_capacitacion`
  ADD PRIMARY KEY (`id_Certificado`),
  ADD KEY `id_Capacitacion` (`id_Capacitacion`),
  ADD KEY `id_Usuario` (`id_Usuario`),
  ADD KEY `id_Curso` (`id_Curso`);

--
-- Indices de la tabla `cursos_certificados_has_conductor`
--
ALTER TABLE `cursos_certificados_has_conductor`
  ADD PRIMARY KEY (`id_Usuario`,`id_Curso`),
  ADD KEY `id_Curso` (`id_Curso`);

--
-- Indices de la tabla `Departamento`
--
ALTER TABLE `Departamento`
  ADD PRIMARY KEY (`Dpt_Id`);

--
-- Indices de la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD PRIMARY KEY (`idDepartamento`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `desmontesLlantas`
--
ALTER TABLE `desmontesLlantas`
  ADD PRIMARY KEY (`idDesmonteLlanta`),
  ADD KEY `placa` (`placa`),
  ADD KEY `idProducto` (`idProducto`),
  ADD KEY `idSede` (`idSede`),
  ADD KEY `idBodega` (`idBodega`),
  ADD KEY `userControl` (`userControl`);

--
-- Indices de la tabla `detDevInventario`
--
ALTER TABLE `detDevInventario`
  ADD PRIMARY KEY (`idDevInventario`,`idProducto`,`idLote`,`idReserva`,`valUnitario`,`iva`),
  ADD KEY `ID_Dev_Inventario1` (`idDevInventario`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `Id_Reserva` (`idReserva`),
  ADD KEY `ID_Lote` (`idLote`) USING BTREE;

--
-- Indices de la tabla `detEntradaInv`
--
ALTER TABLE `detEntradaInv`
  ADD PRIMARY KEY (`idEncEntradaInv`,`idProducto`,`idLote`,`idReserva`,`valUnitario`,`iva`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `Id_Reserva` (`idReserva`),
  ADD KEY `ID_Enc_Entrada_Inv` (`idEncEntradaInv`),
  ADD KEY `ID_Lote` (`idLote`);

--
-- Indices de la tabla `detEvaluacionProveedor`
--
ALTER TABLE `detEvaluacionProveedor`
  ADD PRIMARY KEY (`idEncEvaluacion`,`idCriterio`),
  ADD KEY `idCRiterio` (`idCriterio`);

--
-- Indices de la tabla `detInspeccionLlantas`
--
ALTER TABLE `detInspeccionLlantas`
  ADD PRIMARY KEY (`idDetalle`),
  ADD KEY `Id_enc_insp_ll` (`idEncInsp`);

--
-- Indices de la tabla `detInventarios`
--
ALTER TABLE `detInventarios`
  ADD PRIMARY KEY (`idInventario`,`idProducto`,`idLote`,`idReserva`),
  ADD KEY `idLote` (`idLote`),
  ADD KEY `idProducto` (`idProducto`),
  ADD KEY `idReserva` (`idReserva`);

--
-- Indices de la tabla `detSalidaProveedor`
--
ALTER TABLE `detSalidaProveedor`
  ADD PRIMARY KEY (`idEncSalidaProv`,`idProducto`,`idLoteSalida`,`idReservaAlmacen`,`valUnitario`,`iva`),
  ADD KEY `ID_Enc_Salida_Prov` (`idEncSalidaProv`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `ID_Lote` (`idLoteSalida`),
  ADD KEY `idTipoReserva` (`idReservaAlmacen`);

--
-- Indices de la tabla `detSolicitudMat`
--
ALTER TABLE `detSolicitudMat`
  ADD PRIMARY KEY (`idDetSolicitud`),
  ADD KEY `ID_Solicitud_Mat` (`idSolicitudMat`),
  ADD KEY `ID_Producto` (`idProducto`);

--
-- Indices de la tabla `detTranferEm`
--
ALTER TABLE `detTranferEm`
  ADD PRIMARY KEY (`idSalidaMaterial`,`idProducto`,`idLote`,`idReserva`,`valUnitario`,`iva`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `ID_Lote` (`idLote`),
  ADD KEY `Id_Reserva` (`idReserva`),
  ADD KEY `ID_Sal_Mat_Consumo` (`idSalidaMaterial`);

--
-- Indices de la tabla `detTrasladoMoviles`
--
ALTER TABLE `detTrasladoMoviles`
  ADD PRIMARY KEY (`idTrasladoMovil`,`idReserva`,`idProducto`,`idLoteTraslado`),
  ADD KEY `ID_Traslado_Movil` (`idTrasladoMovil`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `ID_Lote` (`idLoteTraslado`),
  ADD KEY `Id_reserva` (`idReserva`);

--
-- Indices de la tabla `detTrasladoReservas`
--
ALTER TABLE `detTrasladoReservas`
  ADD PRIMARY KEY (`idTrasladoReserva`,`idNewRese`,`idProTrasRese`,`idLoteTrasRese`,`valUnitario`,`iva`),
  ADD KEY `ID_Producto` (`idProTrasRese`),
  ADD KEY `ID_Lote` (`idLoteTrasRese`),
  ADD KEY `idOldRese` (`idOldRese`),
  ADD KEY `idNewRese` (`idNewRese`);

--
-- Indices de la tabla `disposicionFinalLlantas`
--
ALTER TABLE `disposicionFinalLlantas`
  ADD PRIMARY KEY (`idDispFinalLlanta`),
  ADD KEY `placa` (`placa`),
  ADD KEY `idProducto` (`idProducto`),
  ADD KEY `userControl` (`userControl`);

--
-- Indices de la tabla `documentosConductor`
--
ALTER TABLE `documentosConductor`
  ADD PRIMARY KEY (`idDocConductor`,`fkIdDocumento`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idDocVencimiento` (`fkIdDocumento`);

--
-- Indices de la tabla `documentosFlota`
--
ALTER TABLE `documentosFlota`
  ADD PRIMARY KEY (`fkPlacaFlota`,`fkIdDocumento`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idDocVencimiento` (`fkIdDocumento`);

--
-- Indices de la tabla `Documentos_conductor`
--
ALTER TABLE `Documentos_conductor`
  ADD PRIMARY KEY (`DocCond_Id`),
  ADD UNIQUE KEY `Pers_NumeroDoc` (`Pers_NumeroDoc`),
  ADD KEY `Pers_Id` (`Pers_NumeroDoc`);

--
-- Indices de la tabla `Documentos_Remolque`
--
ALTER TABLE `Documentos_Remolque`
  ADD PRIMARY KEY (`DocRemol_Id`),
  ADD KEY `Remol_Id` (`Remol_Id`);

--
-- Indices de la tabla `Documentos_Vehiculo`
--
ALTER TABLE `Documentos_Vehiculo`
  ADD PRIMARY KEY (`DocVeh_Id`),
  ADD KEY `Veh_Id` (`Veh_Id`);

--
-- Indices de la tabla `ejecutoresMantenimiento`
--
ALTER TABLE `ejecutoresMantenimiento`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ccEjecutor` (`ccEjecutor`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `ejecutores_mtto_especialidades`
--
ALTER TABLE `ejecutores_mtto_especialidades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idEjecutor` (`idEjecutor`),
  ADD KEY `idEspecialidad` (`idEspecialidad`);

--
-- Indices de la tabla `ejecutores_mtto_externo`
--
ALTER TABLE `ejecutores_mtto_externo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idEjecutor` (`id_sucursal`) USING BTREE,
  ADD KEY `usuarioControl` (`user_control`) USING BTREE;

--
-- Indices de la tabla `ejecutores_mtto_interno`
--
ALTER TABLE `ejecutores_mtto_interno`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `UNIQUE_KEYS` (`id_bodega`,`document`) USING BTREE,
  ADD KEY `FK_ejecutores_mtto_personal` (`user_control`),
  ADD KEY `FK_ejecutores_mtto_interno_personal` (`document`),
  ADD KEY `id_bodega` (`id_bodega`);

--
-- Indices de la tabla `emInventario`
--
ALTER TABLE `emInventario`
  ADD PRIMARY KEY (`idProducto`,`idEm`,`idProy`,`idLote`,`idTipoReserva`,`valUnitario`,`iva`),
  ADD KEY `idEm` (`idEm`),
  ADD KEY `idProducto` (`idProducto`),
  ADD KEY `idProy` (`idProy`),
  ADD KEY `idLote` (`idLote`),
  ADD KEY `idTipoReserva` (`idTipoReserva`);

--
-- Indices de la tabla `Empresa`
--
ALTER TABLE `Empresa`
  ADD PRIMARY KEY (`Emp_Id`),
  ADD KEY `id_emp_panes` (`Id_emp_plan`);

--
-- Indices de la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD PRIMARY KEY (`idEmpresa`),
  ADD KEY `fkIdCiudad` (`fkIdCiudad`),
  ADD KEY `fkIdPlanQi` (`fkIdPlanQi`);

--
-- Indices de la tabla `emProyectos`
--
ALTER TABLE `emProyectos`
  ADD PRIMARY KEY (`id_proy`),
  ADD KEY `FK_usuario_control` (`usuario_control`),
  ADD KEY `FK_idEm` (`idEm`);

--
-- Indices de la tabla `encDevInventario`
--
ALTER TABLE `encDevInventario`
  ADD PRIMARY KEY (`idDevInventario`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `id_em` (`id_em`),
  ADD KEY `id_proyecto` (`id_proyecto`);

--
-- Indices de la tabla `encEntradaInventario`
--
ALTER TABLE `encEntradaInventario`
  ADD PRIMARY KEY (`idEncEntradaInv`),
  ADD KEY `ID_Solicitud_Mat` (`idSolicitudMat`),
  ADD KEY `Usuario_control` (`usuarioControl`),
  ADD KEY `recibeBodega` (`recibeBodega`);

--
-- Indices de la tabla `encInventarios`
--
ALTER TABLE `encInventarios`
  ADD PRIMARY KEY (`idEncInventario`),
  ADD KEY `ID_Bodega` (`idBodega`),
  ADD KEY `Id_Movil` (`idMovil`),
  ADD KEY `ID_Usuario_inventario` (`idUsuarioInventario`),
  ADD KEY `ID_Usuario_movil` (`idUsuarioMovil`),
  ADD KEY `ID_Usuario_bodega` (`idUsuarioBodega`),
  ADD KEY `ID_Usuario_control` (`idUsuarioControl`);

--
-- Indices de la tabla `encOrdenCompra`
--
ALTER TABLE `encOrdenCompra`
  ADD PRIMARY KEY (`idEncOrdenCompra`),
  ADD KEY `ID_Bodega` (`idBodega`),
  ADD KEY `idProveedor` (`idProveedor`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `encSalidaProveedor`
--
ALTER TABLE `encSalidaProveedor`
  ADD PRIMARY KEY (`idEncSalidaProv`),
  ADD KEY `ID_Proveedor` (`idSucursal`),
  ADD KEY `ID_Bodega` (`idBodega`),
  ADD KEY `Cedula_Autoriza` (`cedulaAutoriza`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `encSolicitudMat`
--
ALTER TABLE `encSolicitudMat`
  ADD PRIMARY KEY (`idSolicitudMat`),
  ADD KEY `ID_Proveedor` (`idSucursal`),
  ADD KEY `Id_almacen` (`idAlmacen`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `encTranferEm`
--
ALTER TABLE `encTranferEm`
  ADD PRIMARY KEY (`idSalMatConsumo`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `id_em` (`id_em`),
  ADD KEY `id_proyecto` (`id_proyecto`);

--
-- Indices de la tabla `encTrasladoMoviles`
--
ALTER TABLE `encTrasladoMoviles`
  ADD PRIMARY KEY (`idTrasladoMovil`),
  ADD KEY `ID_Bodega` (`idBodega`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idUsuarioEntrega` (`idUsuarioEntrega`),
  ADD KEY `idUsuarioRecibe` (`idUsuarioRecibe`),
  ADD KEY `cedulaAprobado` (`cedulaAprobado`),
  ADD KEY `idMovilEntrega` (`idMovilEntrega`),
  ADD KEY `idMovilRecibe` (`idMovilRecibe`);

--
-- Indices de la tabla `encTrasladoReservas`
--
ALTER TABLE `encTrasladoReservas`
  ADD PRIMARY KEY (`idTrasladoReserva`),
  ADD KEY `idBodega` (`idBodega`),
  ADD KEY `cedulaUsuario` (`cedulaUsuario`);

--
-- Indices de la tabla `encuesta`
--
ALTER TABLE `encuesta`
  ADD PRIMARY KEY (`idEncuesta`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `creadorEncuesta` (`creadorEncuesta`);

--
-- Indices de la tabla `Encuesta`
--
ALTER TABLE `Encuesta`
  ADD PRIMARY KEY (`Idencuesta`);

--
-- Indices de la tabla `Enc_Preguntas`
--
ALTER TABLE `Enc_Preguntas`
  ADD PRIMARY KEY (`Id_pre`),
  ADD KEY `Id_encuesta` (`Id_encuesta`),
  ADD KEY `tipo_pregunta` (`tipo_pregunta`);

--
-- Indices de la tabla `Enc_Respuestas`
--
ALTER TABLE `Enc_Respuestas`
  ADD PRIMARY KEY (`Id_resp`);

--
-- Indices de la tabla `especialidadesEm`
--
ALTER TABLE `especialidadesEm`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `estadosLlantas`
--
ALTER TABLE `estadosLlantas`
  ADD PRIMARY KEY (`idEstadoLlanta`);

--
-- Indices de la tabla `evaluacionProveedorEnc`
--
ALTER TABLE `evaluacionProveedorEnc`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idSucursal` (`idSucursal`),
  ADD KEY `idCriticidad` (`idCriticidad`);

--
-- Indices de la tabla `evidencias`
--
ALTER TABLE `evidencias`
  ADD PRIMARY KEY (`idEvidencia`,`idCapacitacion`),
  ADD KEY `fk_evidencias_capacitacion1_idx` (`idCapacitacion`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `fallasSolucionadas`
--
ALTER TABLE `fallasSolucionadas`
  ADD PRIMARY KEY (`idFallasSolcionadas`),
  ADD KEY `idresumenpreoperacional` (`idResumenPreoperacional`),
  ADD KEY `Persona_Documento` (`personaDocumento`),
  ADD KEY `rdpId` (`rdpId`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idItemMalo` (`idItemMalo`);

--
-- Indices de la tabla `fallas_solucionadas`
--
ALTER TABLE `fallas_solucionadas`
  ADD PRIMARY KEY (`idFallasSolcionadas`),
  ADD KEY `idresumenpreoperacional` (`idresumenpreoperacional`),
  ADD KEY `Persona_Documento` (`Persona_Documento`);

--
-- Indices de la tabla `firmasDigitales`
--
ALTER TABLE `firmasDigitales`
  ADD PRIMARY KEY (`idFirma`),
  ADD UNIQUE KEY `Pers_NumeroDoc` (`fkNumeroDoc`),
  ADD KEY `Pers_Id` (`fkNumeroDoc`);

--
-- Indices de la tabla `Firmas_Digitales`
--
ALTER TABLE `Firmas_Digitales`
  ADD PRIMARY KEY (`Firma_Id`),
  ADD UNIQUE KEY `Pers_NumeroDoc` (`Pers_NumeroDoc`),
  ADD KEY `Pers_Id` (`Pers_NumeroDoc`);

--
-- Indices de la tabla `formatoEspecialesCat`
--
ALTER TABLE `formatoEspecialesCat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idFormato` (`idFormato`);

--
-- Indices de la tabla `formatoEspecialesCatItem`
--
ALTER TABLE `formatoEspecialesCatItem`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `formatoEspecialesEnca`
--
ALTER TABLE `formatoEspecialesEnca`
  ADD PRIMARY KEY (`id`),
  ADD KEY `placaV` (`placaV`),
  ADD KEY `placaR` (`placaR`),
  ADD KEY `userRealiza` (`userRealiza`),
  ADD KEY `uOperador` (`uOperador`),
  ADD KEY `uEvaluador` (`uEvaluador`),
  ADD KEY `poseedor` (`poseedor`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `formatoEspecialesEnca_det`
--
ALTER TABLE `formatoEspecialesEnca_det`
  ADD PRIMARY KEY (`idFEspecial`,`iditemEsp`);

--
-- Indices de la tabla `formatoEspecialesEnca_exp`
--
ALTER TABLE `formatoEspecialesEnca_exp`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `formatoEspecialesUserRealiza`
--
ALTER TABLE `formatoEspecialesUserRealiza`
  ADD PRIMARY KEY (`usuario`,`idFEspecial`);

--
-- Indices de la tabla `fotosPreoperacionalUltimate`
--
ALTER TABLE `fotosPreoperacionalUltimate`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `hasArticuloAlmacen`
--
ALTER TABLE `hasArticuloAlmacen`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id_articulo_2` (`id_articulo`,`id_almacen`),
  ADD KEY `id_articulo` (`id_articulo`),
  ADD KEY `id_almacen` (`id_almacen`),
  ADD KEY `usuario_control` (`usuario_control`);

--
-- Indices de la tabla `hashBinomios`
--
ALTER TABLE `hashBinomios`
  ADD PRIMARY KEY (`idBinomio`),
  ADD KEY `placaVehiculo` (`placaVehiculo`),
  ADD KEY `placaTrailer` (`placaTrailer`);

--
-- Indices de la tabla `hashTipoVehiculoCss`
--
ALTER TABLE `hashTipoVehiculoCss`
  ADD PRIMARY KEY (`idTipoVehiculo`,`idUbicacion`);

--
-- Indices de la tabla `historial_estados_asignacion_em_tareas`
--
ALTER TABLE `historial_estados_asignacion_em_tareas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK_historial_id_asignacion` (`id_asignacion`),
  ADD KEY `FK_historial_user_control` (`user_control`);

--
-- Indices de la tabla `historicoProcedimientosLlanta`
--
ALTER TABLE `historicoProcedimientosLlanta`
  ADD PRIMARY KEY (`idHisProcLlanta`),
  ADD KEY `userControl` (`userControl`) USING BTREE,
  ADD KEY `placa` (`placa`),
  ADD KEY `idProducto` (`idProducto`) USING BTREE;

--
-- Indices de la tabla `inspeccionLlantas`
--
ALTER TABLE `inspeccionLlantas`
  ADD PRIMARY KEY (`idEncInspLl`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `User_control` (`userControl`),
  ADD KEY `placa` (`placa`),
  ADD KEY `idUrlLlanta` (`idUrlLlanta`);

--
-- Indices de la tabla `inventarioVehiculo`
--
ALTER TABLE `inventarioVehiculo`
  ADD PRIMARY KEY (`placaInv`,`idProducto`,`idAlmacen`,`idLote`,`idTipoReserva`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `ID_Almacen` (`idAlmacen`),
  ADD KEY `ID_Lote` (`idLote`),
  ADD KEY `ID_Tipo_Reserva` (`idTipoReserva`),
  ADD KEY `ID_vehicle` (`placaInv`);

--
-- Indices de la tabla `itemInspeccion`
--
ALTER TABLE `itemInspeccion`
  ADD PRIMARY KEY (`idItemInsp`),
  ADD KEY `Cat_Item_Id` (`idCatItem`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idItemInsp` (`idItemInsp`);

--
-- Indices de la tabla `itemModuloFrontend`
--
ALTER TABLE `itemModuloFrontend`
  ADD PRIMARY KEY (`idItemModulo`);

--
-- Indices de la tabla `item_has_fv_remolque`
--
ALTER TABLE `item_has_fv_remolque`
  ADD PRIMARY KEY (`id_item`,`id_vehiculo`);

--
-- Indices de la tabla `item_has_fv_vehiculo`
--
ALTER TABLE `item_has_fv_vehiculo`
  ADD PRIMARY KEY (`id_item`,`id_vehiculo`);

--
-- Indices de la tabla `Item_Inspeccion`
--
ALTER TABLE `Item_Inspeccion`
  ADD PRIMARY KEY (`IInsp_Id`),
  ADD KEY `Cat_Item_Id` (`Cat_Item_Id`);

--
-- Indices de la tabla `llaveItemTpv`
--
ALTER TABLE `llaveItemTpv`
  ADD PRIMARY KEY (`idLlave`),
  ADD KEY `id_item` (`idItem`),
  ADD KEY `id_tp_vehiculo` (`idTpVehiculo`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `llave_item_tpv`
--
ALTER TABLE `llave_item_tpv`
  ADD PRIMARY KEY (`id_llave`),
  ADD KEY `id_item` (`id_item`),
  ADD KEY `id_tp_vehiculo` (`id_tp_vehiculo`);

--
-- Indices de la tabla `log_trigger_debug`
--
ALTER TABLE `log_trigger_debug`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `lote`
--
ALTER TABLE `lote`
  ADD PRIMARY KEY (`idLote`),
  ADD KEY `Usuario_control` (`usuarioControl`);

--
-- Indices de la tabla `maestraVencDocs`
--
ALTER TABLE `maestraVencDocs`
  ADD PRIMARY KEY (`idDocumento`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `manAddEncOrdenServicio`
--
ALTER TABLE `manAddEncOrdenServicio`
  ADD PRIMARY KEY (`Id_aeos`),
  ADD KEY `idEncOrdServicio` (`idEncOrdServicio`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `manArticulos`
--
ALTER TABLE `manArticulos`
  ADD PRIMARY KEY (`idArticulo`),
  ADD UNIQUE KEY `codigoArticulo` (`codigoArticulo`),
  ADD KEY `fkIdTipoArticulo` (`fkIdTipoArticulo`),
  ADD KEY `fkIdCatgArticulo` (`fkIdCatgArticulo`),
  ADD KEY `fkUndEmpaqueCompra` (`fkUndEmpaqueCompra`),
  ADD KEY `fkUndEmpaqueEntrega` (`fkUndEmpaqueEntrega`),
  ADD KEY `UsuarioControl` (`UsuarioControl`),
  ADD KEY `fkIdMarcaArticulos` (`fkIdMarcaArticulos`);

--
-- Indices de la tabla `manBodegas`
--
ALTER TABLE `manBodegas`
  ADD PRIMARY KEY (`idBodega`),
  ADD KEY `ID_Ciudad1` (`idCiudadBodega`),
  ADD KEY `ID_Usuario2` (`usuarioControl`);

--
-- Indices de la tabla `manCategoriaArticulos`
--
ALTER TABLE `manCategoriaArticulos`
  ADD PRIMARY KEY (`idCategoriaArticulos`),
  ADD KEY `id_usuario_control_fk` (`usuarioControl`);

--
-- Indices de la tabla `manCausas`
--
ALTER TABLE `manCausas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_control` (`usuario_control`);

--
-- Indices de la tabla `manDetalleOrdenServicio`
--
ALTER TABLE `manDetalleOrdenServicio`
  ADD PRIMARY KEY (`idDetalleOrdenServicio`),
  ADD KEY `id_encab_ord_servicio_fk_idx` (`fkIdEncabOrdServicio`),
  ADD KEY `id_falla_has_item_fk_idx` (`fkIdFallaHasItem`),
  ADD KEY `id_shr_fk_idx` (`fkIdShr`);

--
-- Indices de la tabla `manDetSolucionOrdenServicio`
--
ALTER TABLE `manDetSolucionOrdenServicio`
  ADD PRIMARY KEY (`idDetSolucion`),
  ADD KEY `id_solucion_orden_servicio_fk` (`fkIdSolucionOrdenServicio`),
  ADD KEY `id_articulo_fk` (`fkIdArticulo`);

--
-- Indices de la tabla `manEncabezadoOrdenServicio`
--
ALTER TABLE `manEncabezadoOrdenServicio`
  ADD PRIMARY KEY (`idEncOrdServicio`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `placavehiculo` (`placavehiculo`);

--
-- Indices de la tabla `manEncSolucionOrdenServicio`
--
ALTER TABLE `manEncSolucionOrdenServicio`
  ADD PRIMARY KEY (`idSolucionOrdenServicio`),
  ADD KEY `id_deta_orden_servicio_fk_idx` (`fkIdDetaOrdenServicio`),
  ADD KEY `id_usuario_control_fk` (`usuarioControl`);

--
-- Indices de la tabla `manFallas`
--
ALTER TABLE `manFallas`
  ADD PRIMARY KEY (`idFallas`),
  ADD KEY `id_usuario_control_fk` (`usuarioControl`);

--
-- Indices de la tabla `manFallasHasItem`
--
ALTER TABLE `manFallasHasItem`
  ADD PRIMARY KEY (`idFallasHasItem`),
  ADD KEY `id_falla_fk_idx` (`fkIdFalla`),
  ADD KEY `id_item_fk` (`fkIdItem`),
  ADD KEY `id_usuario_control_fk` (`usuarioControl`);

--
-- Indices de la tabla `manFrecuencias`
--
ALTER TABLE `manFrecuencias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_control` (`usuario_control`);

--
-- Indices de la tabla `manMarcaArticulos`
--
ALTER TABLE `manMarcaArticulos`
  ADD PRIMARY KEY (`idMarcaArticulos`),
  ADD KEY `id_usuario_control` (`usuarioControl`);

--
-- Indices de la tabla `manModulosFrontend`
--
ALTER TABLE `manModulosFrontend`
  ADD PRIMARY KEY (`idModulo`);

--
-- Indices de la tabla `manProrrogaMttoProg`
--
ALTER TABLE `manProrrogaMttoProg`
  ADD PRIMARY KEY (`idProrrogaMttoProg`,`fkIdEncaOrdenServicio`),
  ADD KEY `fk_enca_orden_servicio_fk_idx` (`fkIdEncaOrdenServicio`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `manReferenciasLlanta`
--
ALTER TABLE `manReferenciasLlanta`
  ADD PRIMARY KEY (`idReferencia`),
  ADD UNIQUE KEY `codigoReferencia` (`codigoReferencia`),
  ADD KEY `idx_codigo_ref` (`codigoReferencia`),
  ADD KEY `idx_ancho_altura` (`anchoBandaMM`,`alturaPerfil`,`diametroRinPulg`);

--
-- Indices de la tabla `manRutinas`
--
ALTER TABLE `manRutinas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `idSistema` (`idSistema`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `manRutinasTareas`
--
ALTER TABLE `manRutinasTareas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idRutina` (`idRutina`),
  ADD KEY `idTarea` (`idTarea`);

--
-- Indices de la tabla `manSeriSoluOS`
--
ALTER TABLE `manSeriSoluOS`
  ADD PRIMARY KEY (`idSerSolucion`),
  ADD KEY `id_articulo_fk` (`fkIdArticulo`),
  ADD KEY `idSolucionOrdenServicio_fk` (`fkIdSolucionOrdenServicio`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `manSistemas`
--
ALTER TABLE `manSistemas`
  ADD PRIMARY KEY (`idSistemas`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `manSistemasHhasRutinas`
--
ALTER TABLE `manSistemasHhasRutinas`
  ADD PRIMARY KEY (`id_shr`),
  ADD KEY `fk_sistemas_has_rutinas_rutinas1_idx` (`fkIdRutinas`),
  ADD KEY `fk_sistemas_has_rutinas_sistemas_idx` (`fkIdSistemas`),
  ADD KEY `id_tipo_veh` (`fkIdTipoVeh`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `manTareas`
--
ALTER TABLE `manTareas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `usuario_control` (`usuario_control`),
  ADD KEY `tipo_frecuencia` (`tipo_frecuencia`),
  ADD KEY `sistema` (`sistema`);

--
-- Indices de la tabla `manTipoArticulos`
--
ALTER TABLE `manTipoArticulos`
  ADD PRIMARY KEY (`idTipoArticulos`),
  ADD KEY `id_usuario_control` (`usuarioControl`);

--
-- Indices de la tabla `manTipoComprobante`
--
ALTER TABLE `manTipoComprobante`
  ADD PRIMARY KEY (`idTipoComp`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `manUnidadMedida`
--
ALTER TABLE `manUnidadMedida`
  ADD PRIMARY KEY (`idUnidadMedida`),
  ADD UNIQUE KEY `abreviaturaUnd` (`abreviaturaUnd`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `marcaVehiculo`
--
ALTER TABLE `marcaVehiculo`
  ADD PRIMARY KEY (`idMarca`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `marca_vehiculo_remolque`
--
ALTER TABLE `marca_vehiculo_remolque`
  ADD PRIMARY KEY (`marca_id`);

--
-- Indices de la tabla `Notificaciones`
--
ALTER TABLE `Notificaciones`
  ADD PRIMARY KEY (`id_notificacion`),
  ADD UNIQUE KEY `idusuario` (`idusuario`);

--
-- Indices de la tabla `notificacionesCorreo`
--
ALTER TABLE `notificacionesCorreo`
  ADD PRIMARY KEY (`idCorreo`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `notificacionesGeneral`
--
ALTER TABLE `notificacionesGeneral`
  ADD PRIMARY KEY (`ntId`),
  ADD KEY `nt_usuario_control` (`usuarioControl`),
  ADD KEY `nt_usuario_notificado` (`ntUsuarioNotificado`);

--
-- Indices de la tabla `notificacionesInspec`
--
ALTER TABLE `notificacionesInspec`
  ADD PRIMARY KEY (`idNotificacion`),
  ADD UNIQUE KEY `idusuario` (`idUsuario`);

--
-- Indices de la tabla `notify_correo`
--
ALTER TABLE `notify_correo`
  ADD PRIMARY KEY (`id_correo`);

--
-- Indices de la tabla `notify_correo2`
--
ALTER TABLE `notify_correo2`
  ADD PRIMARY KEY (`id_correo`);

--
-- Indices de la tabla `Permisos`
--
ALTER TABLE `Permisos`
  ADD PRIMARY KEY (`Permiso_Id`);

--
-- Indices de la tabla `permisosRol`
--
ALTER TABLE `permisosRol`
  ADD PRIMARY KEY (`fkIdRol`,`fkIdItemModulo`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idAcciones` (`idAcciones`),
  ADD KEY `fkIdItemModulo` (`fkIdItemModulo`);

--
-- Indices de la tabla `permisoUsuario`
--
ALTER TABLE `permisoUsuario`
  ADD PRIMARY KEY (`idUsuario`,`idItem`),
  ADD KEY `UsuarioControl` (`usuarioControl`),
  ADD KEY `idAccionesUsuario` (`idAccionesUsuario`),
  ADD KEY `idItem` (`idItem`);

--
-- Indices de la tabla `Personal`
--
ALTER TABLE `Personal`
  ADD PRIMARY KEY (`Pers_NumeroDoc`),
  ADD KEY `Emp_Id` (`Emp_Id`),
  ADD KEY `TipoDoc_Id` (`TipoDoc_Id`),
  ADD KEY `Carg_id` (`Carg_id`),
  ADD KEY `Pers_LugarExpDoc` (`Pers_LugarExpDoc`),
  ADD KEY `prueba` (`id_Auto_increment`);

--
-- Indices de la tabla `personal`
--
ALTER TABLE `personal`
  ADD PRIMARY KEY (`numeroDocumento`),
  ADD KEY `Emp_Id` (`fkIdEmpresa`),
  ADD KEY `TipoDoc_Id` (`fkIdTIpoDocumento`),
  ADD KEY `Carg_id` (`fkIdCargo`),
  ADD KEY `Pers_LugarExpDoc` (`lugarExpDocumento`),
  ADD KEY `fkIdRol` (`fkIdRol`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `numeroDocumento` (`numeroDocumento`);

--
-- Indices de la tabla `preguntasCapacitacion`
--
ALTER TABLE `preguntasCapacitacion`
  ADD PRIMARY KEY (`idPreguntaCap`),
  ADD KEY `fk_preguntas_tipo_pregunta1_idx` (`idTipoPregunta`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idCapPregunta` (`idCapPregunta`);

--
-- Indices de la tabla `preguntasEncuesta`
--
ALTER TABLE `preguntasEncuesta`
  ADD PRIMARY KEY (`idPregunta`),
  ADD KEY `Id_encuesta` (`idEncuesta`),
  ADD KEY `tipo_pregunta` (`tipoPregunta`);

--
-- Indices de la tabla `preguntas_has_capacitacion`
--
ALTER TABLE `preguntas_has_capacitacion`
  ADD PRIMARY KEY (`id_Pregunta1`,`id_Capacitacion1`),
  ADD KEY `fk_preguntas_has_capacitacion_capacitacion1_idx` (`id_Capacitacion1`),
  ADD KEY `fk_preguntas_has_capacitacion_preguntas1_idx` (`id_Pregunta1`);

--
-- Indices de la tabla `Preguntas_v2`
--
ALTER TABLE `Preguntas_v2`
  ADD PRIMARY KEY (`id_Pregunta`),
  ADD KEY `fk_preguntas_tipo_pregunta1_idx` (`id_TipoPregunta`);

--
-- Indices de la tabla `profesionalArea`
--
ALTER TABLE `profesionalArea`
  ADD PRIMARY KEY (`usuarioCapacitador`,`idArea`),
  ADD KEY `fk_profesor_has_asignaturas_asignaturas1_idx` (`idArea`),
  ADD KEY `fk_profesor_has_asignaturas_profesor1_idx` (`usuarioCapacitador`);

--
-- Indices de la tabla `profesional_area`
--
ALTER TABLE `profesional_area`
  ADD PRIMARY KEY (`id_Capacitador`,`id_area`),
  ADD KEY `fk_profesor_has_asignaturas_asignaturas1_idx` (`id_area`),
  ADD KEY `fk_profesor_has_asignaturas_profesor1_idx` (`id_Capacitador`);

--
-- Indices de la tabla `programacion_mtto`
--
ALTER TABLE `programacion_mtto`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_control` (`usuario_control`),
  ADD KEY `placa` (`placa`),
  ADD KEY `idx_programacion_mtto_placa_fecha` (`placa`,`fecha_inicio`,`fecha_fin`),
  ADD KEY `idx_programacion_mtto_fecha_inicio` (`fecha_inicio`),
  ADD KEY `idx_programacion_mtto_reprogramado` (`reprogramado`,`fecha_inicio`);

--
-- Indices de la tabla `programacion_mtto_asignacion_em_tareas`
--
ALTER TABLE `programacion_mtto_asignacion_em_tareas`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `id_tarea` (`id_tarea`),
  ADD KEY `user_control` (`user_control`),
  ADD KEY `id_programacion_asig` (`id_programacion_mtto`) USING BTREE,
  ADD KEY `id_programacion_mtto` (`id_programacion_mtto`),
  ADD KEY `idx_programacion_mtto_asignacion_id_prog` (`id_programacion_mtto`),
  ADD KEY `idx_programacion_mtto_asignacion_ejecutor` (`id_em`,`tipo_em`),
  ADD KEY `idx_programacion_mtto_asignacion_status` (`status`);

--
-- Indices de la tabla `programacion_mtto_fallas`
--
ALTER TABLE `programacion_mtto_fallas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_programacion` (`id_programacion`),
  ADD KEY `id_item_falla` (`id_item_falla`),
  ADD KEY `idx_programacion_mtto_fallas_id_prog` (`id_programacion`),
  ADD KEY `idx_programacion_mtto_fallas_item` (`id_item_falla`);

--
-- Indices de la tabla `programacion_mtto_fallas_causas`
--
ALTER TABLE `programacion_mtto_fallas_causas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mtto_falla_tarea` (`id_mtto_falla`),
  ADD KEY `id_causa` (`id_causa`);

--
-- Indices de la tabla `programacion_mtto_fallas_rutinas`
--
ALTER TABLE `programacion_mtto_fallas_rutinas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_falla_program` (`id_falla_program`),
  ADD KEY `id_rutina` (`id_rutina`);

--
-- Indices de la tabla `programacion_mtto_fallas_tareas`
--
ALTER TABLE `programacion_mtto_fallas_tareas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_tarea` (`id_tarea`),
  ADD KEY `id_falla_program` (`id_falla_program`);

--
-- Indices de la tabla `programacion_mtto_rutinas`
--
ALTER TABLE `programacion_mtto_rutinas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_programacion` (`id_programacion`),
  ADD KEY `id_rutina` (`id_rutina`),
  ADD KEY `idx_programacion_mtto_rutinas_id_prog` (`id_programacion`),
  ADD KEY `idx_programacion_mtto_rutinas_tipo` (`tipo_mtto`),
  ADD KEY `idx_programacion_mtto_rutinas_id_rutina` (`id_rutina`);

--
-- Indices de la tabla `programacion_mtto_rutinas_causas`
--
ALTER TABLE `programacion_mtto_rutinas_causas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mtto_rutina` (`id_mtto_rutina`),
  ADD KEY `id_causa` (`id_causa`),
  ADD KEY `idx_programacion_mtto_rutinas_causas_id_rutina` (`id_mtto_rutina`),
  ADD KEY `idx_programacion_mtto_rutinas_causas_id_causa` (`id_causa`);

--
-- Indices de la tabla `programacion_mtto_tareas`
--
ALTER TABLE `programacion_mtto_tareas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_programacion` (`id_programacion`),
  ADD KEY `id_tarea` (`id_tarea`),
  ADD KEY `idx_programacion_mtto_tareas_id_prog` (`id_programacion`),
  ADD KEY `idx_programacion_mtto_tareas_tipo` (`tipo_mtto`);

--
-- Indices de la tabla `programacion_mtto_tareas_causas`
--
ALTER TABLE `programacion_mtto_tareas_causas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_mtto_tarea` (`id_mtto_tarea`),
  ADD KEY `id_causa` (`id_causa`);

--
-- Indices de la tabla `Proveedor`
--
ALTER TABLE `Proveedor`
  ADD PRIMARY KEY (`Prov_Id`),
  ADD KEY `TipoDoc_Id` (`TipoDoc_Id`),
  ADD KEY `Prov_LugarExpDoc` (`Prov_LugarExpDoc`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`idProv`),
  ADD KEY `TipoDoc_Id` (`tipoDocId`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idRegimen` (`idRegimen`);

--
-- Indices de la tabla `qRealizanCapacitacion`
--
ALTER TABLE `qRealizanCapacitacion`
  ADD PRIMARY KEY (`qRIdCap`,`qRUsuario`),
  ADD UNIQUE KEY `Qr_idcap` (`qRIdCap`,`qRUsuario`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `qRUsuario` (`qRUsuario`);

--
-- Indices de la tabla `Qrealizan_capacitacion`
--
ALTER TABLE `Qrealizan_capacitacion`
  ADD PRIMARY KEY (`id_qrealiza`),
  ADD UNIQUE KEY `Qr_idcap` (`Qr_idcap`,`Qr_Usuario`),
  ADD UNIQUE KEY `Qr_idcap_2` (`Qr_idcap`,`Qr_Usuario`);

--
-- Indices de la tabla `Qrencuestas`
--
ALTER TABLE `Qrencuestas`
  ADD PRIMARY KEY (`id_qrealiza`),
  ADD UNIQUE KEY `Usuario` (`Usuario`,`Id_encuesta`);

--
-- Indices de la tabla `qREncuestas`
--
ALTER TABLE `qREncuestas`
  ADD PRIMARY KEY (`idQRealiza`),
  ADD UNIQUE KEY `Usuario` (`cedulaUsuario`,`idEncuestaUser`),
  ADD KEY `Id_encuesta` (`idEncuestaUser`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `reencauchadoras`
--
ALTER TABLE `reencauchadoras`
  ADD PRIMARY KEY (`idReencauchadora`);

--
-- Indices de la tabla `regimenTributario`
--
ALTER TABLE `regimenTributario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuairoControl` (`usuairoControl`);

--
-- Indices de la tabla `registroKilometrajeLlantas`
--
ALTER TABLE `registroKilometrajeLlantas`
  ADD PRIMARY KEY (`idRegistro`),
  ADD KEY `idx_llanta` (`idProducto`,`serialLlanta`),
  ADD KEY `idx_placas` (`placaCabezote`,`placaRemolque`),
  ADD KEY `idx_activo` (`activo`),
  ADD KEY `idx_serial_activo` (`serialLlanta`,`idProducto`,`activo`),
  ADD KEY `idx_remolque_activo` (`placaRemolque`,`activo`),
  ADD KEY `idx_cabezote_activo` (`placaCabezote`,`activo`),
  ADD KEY `idx_fecha_cierre` (`fechaFin`),
  ADD KEY `idx_llanta_producto` (`idProducto`,`serialLlanta`);

--
-- Indices de la tabla `remolque`
--
ALTER TABLE `remolque`
  ADD PRIMARY KEY (`idRemolque`),
  ADD UNIQUE KEY `Remol_Placa` (`placaRemolque`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `Remolque`
--
ALTER TABLE `Remolque`
  ADD PRIMARY KEY (`Remol_Id`),
  ADD UNIQUE KEY `Remol_Placa` (`Remol_Placa`),
  ADD KEY `Prov_Id` (`Prov_Id`),
  ADD KEY `Remol_LugarPlaca` (`Remol_LugarPlaca`),
  ADD KEY `Tv_Id` (`Tv_Id`);

--
-- Indices de la tabla `reporteAuditoria`
--
ALTER TABLE `reporteAuditoria`
  ADD PRIMARY KEY (`idReporteAuditoria`),
  ADD KEY `idResumen_Preoperacional` (`idResumenPreoperacional`),
  ADD KEY `personaDocumento` (`personaDocumento`);

--
-- Indices de la tabla `Reporte_Auditoria`
--
ALTER TABLE `Reporte_Auditoria`
  ADD PRIMARY KEY (`idReporte_Auditoria`),
  ADD KEY `idResumen_Preoperacional` (`idResumen_Preoperacional`);

--
-- Indices de la tabla `respuestasCapacitacion`
--
ALTER TABLE `respuestasCapacitacion`
  ADD PRIMARY KEY (`idRespuestas`,`idPregunta`),
  ADD KEY `fk_respuestas_preguntas1_idx` (`idPregunta`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `respuestasEncuesta`
--
ALTER TABLE `respuestasEncuesta`
  ADD PRIMARY KEY (`idResp`),
  ADD KEY `Id_preg` (`idPregRta`);

--
-- Indices de la tabla `respuestasEncuestasOk`
--
ALTER TABLE `respuestasEncuestasOk`
  ADD PRIMARY KEY (`idRespencUser`),
  ADD KEY `UsuarioUser` (`usuarioUser`);

--
-- Indices de la tabla `Respuestasencuestasok`
--
ALTER TABLE `Respuestasencuestasok`
  ADD PRIMARY KEY (`IdRespencUser`),
  ADD KEY `RespuestaSeleccionada` (`RespuestaSeleccionada`);

--
-- Indices de la tabla `respuestasUsuario`
--
ALTER TABLE `respuestasUsuario`
  ADD PRIMARY KEY (`idRespuestaUsuario`),
  ADD UNIQUE KEY `id_Realiza` (`usuarioRealiza`,`idRespuestas`),
  ADD KEY `fk_respuestas_usuario_qr_capacitacion1_idx` (`usuarioRealiza`),
  ADD KEY `fk_respuestas_usuario_respuestas1_idx` (`idRespuestas`);

--
-- Indices de la tabla `Respuestasv2`
--
ALTER TABLE `Respuestasv2`
  ADD PRIMARY KEY (`id_Respuestas`),
  ADD UNIQUE KEY `unique_respuesta_pregunta` (`id_Respuestas`,`id_Pregunta`),
  ADD KEY `fk_respuestas_preguntas1_idx` (`id_Pregunta`);

--
-- Indices de la tabla `respuestas_usuario`
--
ALTER TABLE `respuestas_usuario`
  ADD PRIMARY KEY (`id_Respuesta_Usuario`),
  ADD UNIQUE KEY `id_Realiza` (`id_Realiza`,`id_Respuestas`),
  ADD KEY `fk_respuestas_usuario_qr_capacitacion1_idx` (`id_Realiza`),
  ADD KEY `fk_respuestas_usuario_respuestas1_idx` (`id_Respuestas`);

--
-- Indices de la tabla `resumenPreoperacional`
--
ALTER TABLE `resumenPreoperacional`
  ADD PRIMARY KEY (`idResumen`),
  ADD UNIQUE KEY `fechaPreoperacional` (`fechaPreoperacional`,`ciudadGps`,`kilometraje`,`cantTanqueoGalones`,`usuarioPreoperacional`,`numeroGuia`,`placaVehiculo`,`placaRemolque`,`idCiudad`),
  ADD KEY `Pers_Id` (`usuarioPreoperacional`),
  ADD KEY `Veh_Id` (`placaVehiculo`),
  ADD KEY `Ciu_Id` (`idCiudad`),
  ADD KEY `Remol_Id_2` (`placaRemolque`);

--
-- Indices de la tabla `Rol`
--
ALTER TABLE `Rol`
  ADD PRIMARY KEY (`Rol_Id`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`rolId`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `rtaPreoperacional`
--
ALTER TABLE `rtaPreoperacional`
  ADD PRIMARY KEY (`idRtaPreop`),
  ADD UNIQUE KEY `uk_preop_item` (`idPreoperacional`,`idItemInps`),
  ADD KEY `ResuPre_Id` (`idPreoperacional`),
  ADD KEY `IInsp_Id` (`idItemInps`);

--
-- Indices de la tabla `serialEjecutorM`
--
ALTER TABLE `serialEjecutorM`
  ADD PRIMARY KEY (`idProducto`,`serial`),
  ADD KEY `idEjecutorM` (`idEjecutorM`),
  ADD KEY `idProy` (`idProy`),
  ADD KEY `idLote` (`idLote`),
  ADD KEY `idReservEm` (`idReservEm`);

--
-- Indices de la tabla `serialEntradaInventario`
--
ALTER TABLE `serialEntradaInventario`
  ADD PRIMARY KEY (`idEncEntradaInv`,`idProducto`,`serial`) USING BTREE,
  ADD KEY `ID_Enc_Entrada_Inv` (`idEncEntradaInv`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `Id_Reserva` (`idReserva`),
  ADD KEY `ID_Lote` (`idLote`);

--
-- Indices de la tabla `serialInstalar`
--
ALTER TABLE `serialInstalar`
  ADD PRIMARY KEY (`idProducto`,`serial`),
  ADD KEY `ID_Producto` (`idProducto`),
  ADD KEY `ID_Bodega` (`idBodega`),
  ADD KEY `ID_Movil` (`placaVehSeri`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idTipoReserva` (`idTipoReserva`),
  ADD KEY `idLoteSerial` (`idLoteSerial`),
  ADD KEY `idx_estado_llanta` (`fkIdEstadoLlanta`);

--
-- Indices de la tabla `serialSalProveedor`
--
ALTER TABLE `serialSalProveedor`
  ADD PRIMARY KEY (`idEncSalProv`,`idProducto`,`serial`),
  ADD KEY `idLote` (`idLote`),
  ADD KEY `idReserva` (`idReserva`);

--
-- Indices de la tabla `serialTranferEm`
--
ALTER TABLE `serialTranferEm`
  ADD PRIMARY KEY (`idEncTranfer`,`idProducto`,`serial`),
  ADD KEY `idLote` (`idLote`),
  ADD KEY `idReservEm` (`idReservEm`);

--
-- Indices de la tabla `serialTranferReserva`
--
ALTER TABLE `serialTranferReserva`
  ADD PRIMARY KEY (`idEncTranfer`,`idProducto`,`serial`);

--
-- Indices de la tabla `serialTranferReturn`
--
ALTER TABLE `serialTranferReturn`
  ADD PRIMARY KEY (`idEncTranfer`,`idProducto`,`serial`),
  ADD KEY `idLote` (`idLote`),
  ADD KEY `idReservEm` (`idReservEm`),
  ADD KEY `idProducto` (`idProducto`),
  ADD KEY `idEncTranfer` (`idEncTranfer`);

--
-- Indices de la tabla `sucursalesProv`
--
ALTER TABLE `sucursalesProv`
  ADD PRIMARY KEY (`idSucursal`),
  ADD KEY `idCiudad` (`idCiudad`),
  ADD KEY `idProvSucursal` (`idProvSucursal`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `ticketsSoporte`
--
ALTER TABLE `ticketsSoporte`
  ADD PRIMARY KEY (`idTicket`),
  ADD KEY `idx_usuario` (`usuario`),
  ADD KEY `idx_estado` (`estado`),
  ADD KEY `idx_categoria` (`categoria`),
  ADD KEY `idx_fechaCreacion` (`fechaCreacion`);

--
-- Indices de la tabla `ticketsSoporteArchivos`
--
ALTER TABLE `ticketsSoporteArchivos`
  ADD PRIMARY KEY (`idArchivo`),
  ADD KEY `idx_idTicket` (`idTicket`);

--
-- Indices de la tabla `ticketsSoporteRespuestas`
--
ALTER TABLE `ticketsSoporteRespuestas`
  ADD PRIMARY KEY (`idRespuesta`),
  ADD KEY `idx_idTicket` (`idTicket`),
  ADD KEY `idx_fechaRespuesta` (`fechaRespuesta`);

--
-- Indices de la tabla `tipoAdjuntos`
--
ALTER TABLE `tipoAdjuntos`
  ADD PRIMARY KEY (`idTipoAdjuntos`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `tipoDesgaste`
--
ALTER TABLE `tipoDesgaste`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `tipoDocumento`
--
ALTER TABLE `tipoDocumento`
  ADD PRIMARY KEY (`idTipoDocumento`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `tipoLlantas`
--
ALTER TABLE `tipoLlantas`
  ADD PRIMARY KEY (`idTipoLlantas`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `tipoPregunta`
--
ALTER TABLE `tipoPregunta`
  ADD PRIMARY KEY (`idTipoPregunta`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `tipoReserva`
--
ALTER TABLE `tipoReserva`
  ADD PRIMARY KEY (`idReserva`),
  ADD UNIQUE KEY `Name_Reserva` (`nombreReserva`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `tipoRin`
--
ALTER TABLE `tipoRin`
  ADD PRIMARY KEY (`idTipoRin`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `tiposVehiculos`
--
ALTER TABLE `tiposVehiculos`
  ADD PRIMARY KEY (`idTipVeh`),
  ADD KEY `fechaControl` (`fechaControl`),
  ADD KEY `usuarioControl` (`usuarioControl`);

--
-- Indices de la tabla `Tipos_Vehiculos`
--
ALTER TABLE `Tipos_Vehiculos`
  ADD PRIMARY KEY (`Tv_Id`);

--
-- Indices de la tabla `tipo_adjuntos`
--
ALTER TABLE `tipo_adjuntos`
  ADD PRIMARY KEY (`id_Tipo_Adjuntos`);

--
-- Indices de la tabla `Tipo_Documento`
--
ALTER TABLE `Tipo_Documento`
  ADD PRIMARY KEY (`TipoDoc_Id`);

--
-- Indices de la tabla `tipo_pregunta`
--
ALTER TABLE `tipo_pregunta`
  ADD PRIMARY KEY (`id_TipoPregunta`);

--
-- Indices de la tabla `trazabilidadReencauches`
--
ALTER TABLE `trazabilidadReencauches`
  ADD PRIMARY KEY (`idTrazabilidad`),
  ADD KEY `idx_serial_original` (`serialOriginal`),
  ADD KEY `idx_serial_actual` (`serialActual`),
  ADD KEY `idx_id_producto` (`idProducto`);

--
-- Indices de la tabla `Usuario`
--
ALTER TABLE `Usuario`
  ADD PRIMARY KEY (`Usuario_Id`),
  ADD UNIQUE KEY `UsuarioUser` (`UsuarioUser`),
  ADD KEY `Rol_Id` (`Rol_Id`),
  ADD KEY `Usuario_User` (`UsuarioUser`);

--
-- Indices de la tabla `usuarioPermisoBodega`
--
ALTER TABLE `usuarioPermisoBodega`
  ADD PRIMARY KEY (`usuarioPermiso`,`idBodegaPermiso`),
  ADD KEY `Rol_Id` (`estadoPermiso`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idBodegaPermiso` (`idBodegaPermiso`);

--
-- Indices de la tabla `Vehiculo`
--
ALTER TABLE `Vehiculo`
  ADD PRIMARY KEY (`Veh_Id`),
  ADD UNIQUE KEY `Veh_Placa` (`Veh_Placa`),
  ADD KEY `Veh_LugarPlaca` (`Veh_LugarPlaca`),
  ADD KEY `Prov_Id` (`Prov_Id`),
  ADD KEY `Tv_Id` (`Tv_Id`),
  ADD KEY `idx_km_actual` (`Veh_KmActual`);

--
-- Indices de la tabla `vehiculo`
--
ALTER TABLE `vehiculo`
  ADD PRIMARY KEY (`placa`),
  ADD KEY `Veh_LugarPlaca` (`fkCiudadMatricula`),
  ADD KEY `Prov_Id` (`idProveedor`),
  ADD KEY `Tv_Id` (`idTipoVeh`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `idIntegracion` (`idIntegracion`),
  ADD KEY `fkMarca` (`fkMarca`);

--
-- Indices de la tabla `versionFormatos`
--
ALTER TABLE `versionFormatos`
  ADD PRIMARY KEY (`idVersion`),
  ADD KEY `id_empresa` (`idEmpresaFormato`);

--
-- Indices de la tabla `version_formatos`
--
ALTER TABLE `version_formatos`
  ADD PRIMARY KEY (`Id_version`),
  ADD KEY `id_empresa` (`id_empresa`),
  ADD KEY `usuarioControl` (`usuarioControl`),
  ADD KEY `usuarioFirma` (`usuarioFirma`);

--
-- Indices de la tabla `vigencia`
--
ALTER TABLE `vigencia`
  ADD PRIMARY KEY (`id_Vigencia`),
  ADD KEY `fk_vigencia_capacitacion1_idx` (`id_Capacitacion1`);

--
-- Indices de la tabla `vigenciaCapacitacion`
--
ALTER TABLE `vigenciaCapacitacion`
  ADD PRIMARY KEY (`idVigencia`),
  ADD KEY `fk_vigencia_capacitacion1_idx` (`fkIdCapacitacion`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `accionesSistemaUsuario`
--
ALTER TABLE `accionesSistemaUsuario`
  MODIFY `idAccion` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `adjuntosCapacitacion`
--
ALTER TABLE `adjuntosCapacitacion`
  MODIFY `idAdjCapacitacion` int(25) NOT NULL AUTO_INCREMENT COMMENT 'id ajunto capacitación';

--
-- AUTO_INCREMENT de la tabla `adjuntosInspeccion`
--
ALTER TABLE `adjuntosInspeccion`
  MODIFY `idAdjunto` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `adjunto_capacitacion`
--
ALTER TABLE `adjunto_capacitacion`
  MODIFY `id_Adj_Capacitacion` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `alertasMantenimiento`
--
ALTER TABLE `alertasMantenimiento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `alertasMantenimientoDestinatarios`
--
ALTER TABLE `alertasMantenimientoDestinatarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `apilog`
--
ALTER TABLE `apilog`
  MODIFY `apiConsecutivo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `area`
--
ALTER TABLE `area`
  MODIFY `idArea` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `binomio_logs`
--
ALTER TABLE `binomio_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cabezoteVehiculo`
--
ALTER TABLE `cabezoteVehiculo`
  MODIFY `idCabezote` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `calificacionEm`
--
ALTER TABLE `calificacionEm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `calificacionesServicioConductor`
--
ALTER TABLE `calificacionesServicioConductor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `calificacionesServicioConductorDetalle`
--
ALTER TABLE `calificacionesServicioConductorDetalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `capacitacion`
--
ALTER TABLE `capacitacion`
  MODIFY `idCapacitacion` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `capacitacion_v2`
--
ALTER TABLE `capacitacion_v2`
  MODIFY `id_Capacitacion` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cargos`
--
ALTER TABLE `cargos`
  MODIFY `idCargo` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Cargos`
--
ALTER TABLE `Cargos`
  MODIFY `Carg_id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `categoriaItems`
--
ALTER TABLE `categoriaItems`
  MODIFY `idCategoriaItem` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Categoria_item`
--
ALTER TABLE `Categoria_item`
  MODIFY `Cat_Item_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cedulasAutorizaAlmacen`
--
ALTER TABLE `cedulasAutorizaAlmacen`
  MODIFY `idAutoriza` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ciudad`
--
ALTER TABLE `ciudad`
  MODIFY `idCiudad` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Ciudad`
--
ALTER TABLE `Ciudad`
  MODIFY `Ciu_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `configuracionAlertasMantenimiento`
--
ALTER TABLE `configuracionAlertasMantenimiento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `correctivasLLantas`
--
ALTER TABLE `correctivasLLantas`
  MODIFY `idCorrectivasLlanta` bigint(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `criterioEvaluacionEm`
--
ALTER TABLE `criterioEvaluacionEm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `criticidadEm`
--
ALTER TABLE `criticidadEm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cursosCertificados`
--
ALTER TABLE `cursosCertificados`
  MODIFY `idCurso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cursosCertificadosCapacitacion`
--
ALTER TABLE `cursosCertificadosCapacitacion`
  MODIFY `idCertificado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cursos_certificados`
--
ALTER TABLE `cursos_certificados`
  MODIFY `id_Curso` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cursos_certificados_has_capacitacion`
--
ALTER TABLE `cursos_certificados_has_capacitacion`
  MODIFY `id_Certificado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Departamento`
--
ALTER TABLE `Departamento`
  MODIFY `Dpt_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `departamento`
--
ALTER TABLE `departamento`
  MODIFY `idDepartamento` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `desmontesLlantas`
--
ALTER TABLE `desmontesLlantas`
  MODIFY `idDesmonteLlanta` bigint(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detInspeccionLlantas`
--
ALTER TABLE `detInspeccionLlantas`
  MODIFY `idDetalle` bigint(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `detSolicitudMat`
--
ALTER TABLE `detSolicitudMat`
  MODIFY `idDetSolicitud` int(1) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `disposicionFinalLlantas`
--
ALTER TABLE `disposicionFinalLlantas`
  MODIFY `idDispFinalLlanta` int(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Documentos_conductor`
--
ALTER TABLE `Documentos_conductor`
  MODIFY `DocCond_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Documentos_Remolque`
--
ALTER TABLE `Documentos_Remolque`
  MODIFY `DocRemol_Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Documentos_Vehiculo`
--
ALTER TABLE `Documentos_Vehiculo`
  MODIFY `DocVeh_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejecutoresMantenimiento`
--
ALTER TABLE `ejecutoresMantenimiento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejecutores_mtto_especialidades`
--
ALTER TABLE `ejecutores_mtto_especialidades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejecutores_mtto_externo`
--
ALTER TABLE `ejecutores_mtto_externo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ejecutores_mtto_interno`
--
ALTER TABLE `ejecutores_mtto_interno`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Empresa`
--
ALTER TABLE `Empresa`
  MODIFY `Emp_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `empresa`
--
ALTER TABLE `empresa`
  MODIFY `idEmpresa` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `emProyectos`
--
ALTER TABLE `emProyectos`
  MODIFY `id_proy` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encDevInventario`
--
ALTER TABLE `encDevInventario`
  MODIFY `idDevInventario` bigint(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encEntradaInventario`
--
ALTER TABLE `encEntradaInventario`
  MODIFY `idEncEntradaInv` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encInventarios`
--
ALTER TABLE `encInventarios`
  MODIFY `idEncInventario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encOrdenCompra`
--
ALTER TABLE `encOrdenCompra`
  MODIFY `idEncOrdenCompra` int(6) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encSalidaProveedor`
--
ALTER TABLE `encSalidaProveedor`
  MODIFY `idEncSalidaProv` int(5) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encSolicitudMat`
--
ALTER TABLE `encSolicitudMat`
  MODIFY `idSolicitudMat` int(1) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encTranferEm`
--
ALTER TABLE `encTranferEm`
  MODIFY `idSalMatConsumo` bigint(12) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encTrasladoMoviles`
--
ALTER TABLE `encTrasladoMoviles`
  MODIFY `idTrasladoMovil` int(9) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encTrasladoReservas`
--
ALTER TABLE `encTrasladoReservas`
  MODIFY `idTrasladoReserva` int(8) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `encuesta`
--
ALTER TABLE `encuesta`
  MODIFY `idEncuesta` int(19) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Encuesta`
--
ALTER TABLE `Encuesta`
  MODIFY `Idencuesta` int(19) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Enc_Preguntas`
--
ALTER TABLE `Enc_Preguntas`
  MODIFY `Id_pre` int(19) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Enc_Respuestas`
--
ALTER TABLE `Enc_Respuestas`
  MODIFY `Id_resp` int(19) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `especialidadesEm`
--
ALTER TABLE `especialidadesEm`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `estadosLlantas`
--
ALTER TABLE `estadosLlantas`
  MODIFY `idEstadoLlanta` bigint(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `evaluacionProveedorEnc`
--
ALTER TABLE `evaluacionProveedorEnc`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `evidencias`
--
ALTER TABLE `evidencias`
  MODIFY `idEvidencia` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `fallasSolucionadas`
--
ALTER TABLE `fallasSolucionadas`
  MODIFY `idFallasSolcionadas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `fallas_solucionadas`
--
ALTER TABLE `fallas_solucionadas`
  MODIFY `idFallasSolcionadas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `firmasDigitales`
--
ALTER TABLE `firmasDigitales`
  MODIFY `idFirma` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Firmas_Digitales`
--
ALTER TABLE `Firmas_Digitales`
  MODIFY `Firma_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `formatoEspecialesCat`
--
ALTER TABLE `formatoEspecialesCat`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `formatoEspecialesCatItem`
--
ALTER TABLE `formatoEspecialesCatItem`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `formatoEspecialesEnca`
--
ALTER TABLE `formatoEspecialesEnca`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `formatoEspecialesEnca_exp`
--
ALTER TABLE `formatoEspecialesEnca_exp`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `fotosPreoperacionalUltimate`
--
ALTER TABLE `fotosPreoperacionalUltimate`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `hasArticuloAlmacen`
--
ALTER TABLE `hasArticuloAlmacen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `hashBinomios`
--
ALTER TABLE `hashBinomios`
  MODIFY `idBinomio` bigint(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historial_estados_asignacion_em_tareas`
--
ALTER TABLE `historial_estados_asignacion_em_tareas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `historicoProcedimientosLlanta`
--
ALTER TABLE `historicoProcedimientosLlanta`
  MODIFY `idHisProcLlanta` bigint(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inspeccionLlantas`
--
ALTER TABLE `inspeccionLlantas`
  MODIFY `idEncInspLl` bigint(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `itemInspeccion`
--
ALTER TABLE `itemInspeccion`
  MODIFY `idItemInsp` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `itemModuloFrontend`
--
ALTER TABLE `itemModuloFrontend`
  MODIFY `idItemModulo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Item_Inspeccion`
--
ALTER TABLE `Item_Inspeccion`
  MODIFY `IInsp_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `llaveItemTpv`
--
ALTER TABLE `llaveItemTpv`
  MODIFY `idLlave` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `llave_item_tpv`
--
ALTER TABLE `llave_item_tpv`
  MODIFY `id_llave` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `log_trigger_debug`
--
ALTER TABLE `log_trigger_debug`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `lote`
--
ALTER TABLE `lote`
  MODIFY `idLote` int(2) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `maestraVencDocs`
--
ALTER TABLE `maestraVencDocs`
  MODIFY `idDocumento` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manAddEncOrdenServicio`
--
ALTER TABLE `manAddEncOrdenServicio`
  MODIFY `Id_aeos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manArticulos`
--
ALTER TABLE `manArticulos`
  MODIFY `idArticulo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manBodegas`
--
ALTER TABLE `manBodegas`
  MODIFY `idBodega` int(3) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manCategoriaArticulos`
--
ALTER TABLE `manCategoriaArticulos`
  MODIFY `idCategoriaArticulos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manCausas`
--
ALTER TABLE `manCausas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manDetalleOrdenServicio`
--
ALTER TABLE `manDetalleOrdenServicio`
  MODIFY `idDetalleOrdenServicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manDetSolucionOrdenServicio`
--
ALTER TABLE `manDetSolucionOrdenServicio`
  MODIFY `idDetSolucion` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manEncabezadoOrdenServicio`
--
ALTER TABLE `manEncabezadoOrdenServicio`
  MODIFY `idEncOrdServicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manEncSolucionOrdenServicio`
--
ALTER TABLE `manEncSolucionOrdenServicio`
  MODIFY `idSolucionOrdenServicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manFallas`
--
ALTER TABLE `manFallas`
  MODIFY `idFallas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manFallasHasItem`
--
ALTER TABLE `manFallasHasItem`
  MODIFY `idFallasHasItem` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manFrecuencias`
--
ALTER TABLE `manFrecuencias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manMarcaArticulos`
--
ALTER TABLE `manMarcaArticulos`
  MODIFY `idMarcaArticulos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manModulosFrontend`
--
ALTER TABLE `manModulosFrontend`
  MODIFY `idModulo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manReferenciasLlanta`
--
ALTER TABLE `manReferenciasLlanta`
  MODIFY `idReferencia` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manRutinas`
--
ALTER TABLE `manRutinas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manRutinasTareas`
--
ALTER TABLE `manRutinasTareas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manSeriSoluOS`
--
ALTER TABLE `manSeriSoluOS`
  MODIFY `idSerSolucion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manSistemas`
--
ALTER TABLE `manSistemas`
  MODIFY `idSistemas` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manSistemasHhasRutinas`
--
ALTER TABLE `manSistemasHhasRutinas`
  MODIFY `id_shr` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manTareas`
--
ALTER TABLE `manTareas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manTipoArticulos`
--
ALTER TABLE `manTipoArticulos`
  MODIFY `idTipoArticulos` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manTipoComprobante`
--
ALTER TABLE `manTipoComprobante`
  MODIFY `idTipoComp` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `manUnidadMedida`
--
ALTER TABLE `manUnidadMedida`
  MODIFY `idUnidadMedida` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marcaVehiculo`
--
ALTER TABLE `marcaVehiculo`
  MODIFY `idMarca` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `marca_vehiculo_remolque`
--
ALTER TABLE `marca_vehiculo_remolque`
  MODIFY `marca_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Notificaciones`
--
ALTER TABLE `Notificaciones`
  MODIFY `id_notificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificacionesCorreo`
--
ALTER TABLE `notificacionesCorreo`
  MODIFY `idCorreo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificacionesGeneral`
--
ALTER TABLE `notificacionesGeneral`
  MODIFY `ntId` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificacionesInspec`
--
ALTER TABLE `notificacionesInspec`
  MODIFY `idNotificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notify_correo`
--
ALTER TABLE `notify_correo`
  MODIFY `id_correo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notify_correo2`
--
ALTER TABLE `notify_correo2`
  MODIFY `id_correo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Permisos`
--
ALTER TABLE `Permisos`
  MODIFY `Permiso_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Personal`
--
ALTER TABLE `Personal`
  MODIFY `id_Auto_increment` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `preguntasCapacitacion`
--
ALTER TABLE `preguntasCapacitacion`
  MODIFY `idPreguntaCap` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `preguntasEncuesta`
--
ALTER TABLE `preguntasEncuesta`
  MODIFY `idPregunta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Preguntas_v2`
--
ALTER TABLE `Preguntas_v2`
  MODIFY `id_Pregunta` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto`
--
ALTER TABLE `programacion_mtto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_asignacion_em_tareas`
--
ALTER TABLE `programacion_mtto_asignacion_em_tareas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_fallas`
--
ALTER TABLE `programacion_mtto_fallas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_fallas_causas`
--
ALTER TABLE `programacion_mtto_fallas_causas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_fallas_rutinas`
--
ALTER TABLE `programacion_mtto_fallas_rutinas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_fallas_tareas`
--
ALTER TABLE `programacion_mtto_fallas_tareas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_rutinas`
--
ALTER TABLE `programacion_mtto_rutinas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_rutinas_causas`
--
ALTER TABLE `programacion_mtto_rutinas_causas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_tareas`
--
ALTER TABLE `programacion_mtto_tareas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `programacion_mtto_tareas_causas`
--
ALTER TABLE `programacion_mtto_tareas_causas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Proveedor`
--
ALTER TABLE `Proveedor`
  MODIFY `Prov_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `idProv` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Qrealizan_capacitacion`
--
ALTER TABLE `Qrealizan_capacitacion`
  MODIFY `id_qrealiza` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Qrencuestas`
--
ALTER TABLE `Qrencuestas`
  MODIFY `id_qrealiza` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `qREncuestas`
--
ALTER TABLE `qREncuestas`
  MODIFY `idQRealiza` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reencauchadoras`
--
ALTER TABLE `reencauchadoras`
  MODIFY `idReencauchadora` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `regimenTributario`
--
ALTER TABLE `regimenTributario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `registroKilometrajeLlantas`
--
ALTER TABLE `registroKilometrajeLlantas`
  MODIFY `idRegistro` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `remolque`
--
ALTER TABLE `remolque`
  MODIFY `idRemolque` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Remolque`
--
ALTER TABLE `Remolque`
  MODIFY `Remol_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `reporteAuditoria`
--
ALTER TABLE `reporteAuditoria`
  MODIFY `idReporteAuditoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Reporte_Auditoria`
--
ALTER TABLE `Reporte_Auditoria`
  MODIFY `idReporte_Auditoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `respuestasCapacitacion`
--
ALTER TABLE `respuestasCapacitacion`
  MODIFY `idRespuestas` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `respuestasEncuesta`
--
ALTER TABLE `respuestasEncuesta`
  MODIFY `idResp` int(19) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `respuestasEncuestasOk`
--
ALTER TABLE `respuestasEncuestasOk`
  MODIFY `idRespencUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Respuestasencuestasok`
--
ALTER TABLE `Respuestasencuestasok`
  MODIFY `IdRespencUser` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `respuestasUsuario`
--
ALTER TABLE `respuestasUsuario`
  MODIFY `idRespuestaUsuario` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Respuestasv2`
--
ALTER TABLE `Respuestasv2`
  MODIFY `id_Respuestas` bigint(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `respuestas_usuario`
--
ALTER TABLE `respuestas_usuario`
  MODIFY `id_Respuesta_Usuario` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `resumenPreoperacional`
--
ALTER TABLE `resumenPreoperacional`
  MODIFY `idResumen` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Rol`
--
ALTER TABLE `Rol`
  MODIFY `Rol_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `rolId` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `rtaPreoperacional`
--
ALTER TABLE `rtaPreoperacional`
  MODIFY `idRtaPreop` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sucursalesProv`
--
ALTER TABLE `sucursalesProv`
  MODIFY `idSucursal` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ticketsSoporte`
--
ALTER TABLE `ticketsSoporte`
  MODIFY `idTicket` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ticketsSoporteArchivos`
--
ALTER TABLE `ticketsSoporteArchivos`
  MODIFY `idArchivo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `ticketsSoporteRespuestas`
--
ALTER TABLE `ticketsSoporteRespuestas`
  MODIFY `idRespuesta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipoAdjuntos`
--
ALTER TABLE `tipoAdjuntos`
  MODIFY `idTipoAdjuntos` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipoDesgaste`
--
ALTER TABLE `tipoDesgaste`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipoDocumento`
--
ALTER TABLE `tipoDocumento`
  MODIFY `idTipoDocumento` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipoLlantas`
--
ALTER TABLE `tipoLlantas`
  MODIFY `idTipoLlantas` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipoPregunta`
--
ALTER TABLE `tipoPregunta`
  MODIFY `idTipoPregunta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipoReserva`
--
ALTER TABLE `tipoReserva`
  MODIFY `idReserva` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipoRin`
--
ALTER TABLE `tipoRin`
  MODIFY `idTipoRin` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tiposVehiculos`
--
ALTER TABLE `tiposVehiculos`
  MODIFY `idTipVeh` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Tipos_Vehiculos`
--
ALTER TABLE `Tipos_Vehiculos`
  MODIFY `Tv_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipo_adjuntos`
--
ALTER TABLE `tipo_adjuntos`
  MODIFY `id_Tipo_Adjuntos` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Tipo_Documento`
--
ALTER TABLE `Tipo_Documento`
  MODIFY `TipoDoc_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tipo_pregunta`
--
ALTER TABLE `tipo_pregunta`
  MODIFY `id_TipoPregunta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `trazabilidadReencauches`
--
ALTER TABLE `trazabilidadReencauches`
  MODIFY `idTrazabilidad` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Usuario`
--
ALTER TABLE `Usuario`
  MODIFY `Usuario_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Vehiculo`
--
ALTER TABLE `Vehiculo`
  MODIFY `Veh_Id` int(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `versionFormatos`
--
ALTER TABLE `versionFormatos`
  MODIFY `idVersion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `version_formatos`
--
ALTER TABLE `version_formatos`
  MODIFY `Id_version` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vigencia`
--
ALTER TABLE `vigencia`
  MODIFY `id_Vigencia` int(25) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `vigenciaCapacitacion`
--
ALTER TABLE `vigenciaCapacitacion`
  MODIFY `idVigencia` int(25) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `adjuntosCapacitacion`
--
ALTER TABLE `adjuntosCapacitacion`
  ADD CONSTRAINT `fk_adjunto_capacitacion_capacitacion1` FOREIGN KEY (`fkIdCapacitacion`) REFERENCES `capacitacion` (`idCapacitacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_adjunto_capacitacion_tipo_adjuntos1` FOREIGN KEY (`fkIdTipoAdjunto`) REFERENCES `tipoAdjuntos` (`idTipoAdjuntos`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `adjuntosInspeccion`
--
ALTER TABLE `adjuntosInspeccion`
  ADD CONSTRAINT `adjuntosInspeccion_ibfk_1` FOREIGN KEY (`idRtaInspeccion`) REFERENCES `rtaPreoperacional` (`idRtaPreop`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `alertasMantenimientoDestinatarios`
--
ALTER TABLE `alertasMantenimientoDestinatarios`
  ADD CONSTRAINT `alertasMantenimientoDestinatarios_ibfk_1` FOREIGN KEY (`id_alerta`) REFERENCES `alertasMantenimiento` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `almacenInventario`
--
ALTER TABLE `almacenInventario`
  ADD CONSTRAINT `almacenInventario_ibfk_1` FOREIGN KEY (`idAlmacen`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `almacenInventario_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `almacenInventario_ibfk_3` FOREIGN KEY (`idTipoReserva`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `almacenInventario_ibfk_4` FOREIGN KEY (`idLote`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `area`
--
ALTER TABLE `area`
  ADD CONSTRAINT `area_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cabezoteVehiculo`
--
ALTER TABLE `cabezoteVehiculo`
  ADD CONSTRAINT `cabezoteVehiculo_ibfk_1` FOREIGN KEY (`placaCabezote`) REFERENCES `vehiculo` (`placa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cabezoteVehiculo_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `capacitacion`
--
ALTER TABLE `capacitacion`
  ADD CONSTRAINT `capacitacion_ibfk_1` FOREIGN KEY (`idCapacitador`) REFERENCES `profesionalArea` (`usuarioCapacitador`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `capacitacion_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cargos`
--
ALTER TABLE `cargos`
  ADD CONSTRAINT `cargos_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `categoriaLicencias`
--
ALTER TABLE `categoriaLicencias`
  ADD CONSTRAINT `categoriaLicencias_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cedulasAutorizaAlmacen`
--
ALTER TABLE `cedulasAutorizaAlmacen`
  ADD CONSTRAINT `cedulasAutorizaAlmacen_ibfk_1` FOREIGN KEY (`CcUsuario`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cedulasAutorizaAlmacen_ibfk_2` FOREIGN KEY (`idAlmacen`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cedulasAutorizaAlmacen_ibfk_3` FOREIGN KEY (`UduarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ciudad`
--
ALTER TABLE `ciudad`
  ADD CONSTRAINT `ciudad_ibfk_1` FOREIGN KEY (`fkIdDepartamento`) REFERENCES `departamento` (`idDepartamento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ciudad_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cursosCertificados`
--
ALTER TABLE `cursosCertificados`
  ADD CONSTRAINT `cursosCertificados_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cursosCertificadosCapacitacion`
--
ALTER TABLE `cursosCertificadosCapacitacion`
  ADD CONSTRAINT `cursosCertificadosCapacitacion_ibfk_3` FOREIGN KEY (`idCapacitacion`) REFERENCES `capacitacion` (`idCapacitacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cursosCertificadosCapacitacion_ibfk_4` FOREIGN KEY (`idCurso`) REFERENCES `cursosCertificados` (`idCurso`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cursosCertificadosCapacitacion_ibfk_5` FOREIGN KEY (`idUsuario`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cursosCertificadosCapacitacion_ibfk_6` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cursosCertificadosConductor`
--
ALTER TABLE `cursosCertificadosConductor`
  ADD CONSTRAINT `cursosCertificadosConductor_ibfk_1` FOREIGN KEY (`idCurso`) REFERENCES `cursosCertificados` (`idCurso`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cursosCertificadosConductor_ibfk_2` FOREIGN KEY (`idUsuario`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cursosCertificadosConductor_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `cursos_certificados_has_capacitacion`
--
ALTER TABLE `cursos_certificados_has_capacitacion`
  ADD CONSTRAINT `cursos_certificados_has_capacitacion_ibfk_3` FOREIGN KEY (`id_Capacitacion`) REFERENCES `capacitacion_v2` (`id_Capacitacion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `cursos_certificados_has_capacitacion_ibfk_4` FOREIGN KEY (`id_Curso`) REFERENCES `cursos_certificados` (`id_Curso`);

--
-- Filtros para la tabla `cursos_certificados_has_conductor`
--
ALTER TABLE `cursos_certificados_has_conductor`
  ADD CONSTRAINT `cursos_certificados_has_conductor_ibfk_1` FOREIGN KEY (`id_Curso`) REFERENCES `cursos_certificados` (`id_Curso`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `departamento`
--
ALTER TABLE `departamento`
  ADD CONSTRAINT `departamento_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detDevInventario`
--
ALTER TABLE `detDevInventario`
  ADD CONSTRAINT `detDevInventario_ibfk_1` FOREIGN KEY (`idDevInventario`) REFERENCES `encDevInventario` (`idDevInventario`),
  ADD CONSTRAINT `detDevInventario_ibfk_3` FOREIGN KEY (`idLote`) REFERENCES `lote` (`idLote`),
  ADD CONSTRAINT `detDevInventario_ibfk_4` FOREIGN KEY (`idReserva`) REFERENCES `tipoReserva` (`idReserva`),
  ADD CONSTRAINT `detDevInventario_ibfk_5` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detEntradaInv`
--
ALTER TABLE `detEntradaInv`
  ADD CONSTRAINT `detEntradaInv_ibfk_1` FOREIGN KEY (`idEncEntradaInv`) REFERENCES `encEntradaInventario` (`idEncEntradaInv`),
  ADD CONSTRAINT `detEntradaInv_ibfk_3` FOREIGN KEY (`idLote`) REFERENCES `lote` (`idLote`),
  ADD CONSTRAINT `detEntradaInv_ibfk_4` FOREIGN KEY (`idReserva`) REFERENCES `tipoReserva` (`idReserva`),
  ADD CONSTRAINT `detEntradaInv_ibfk_5` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detEvaluacionProveedor`
--
ALTER TABLE `detEvaluacionProveedor`
  ADD CONSTRAINT `detEvaluacionProveedor_ibfk_1` FOREIGN KEY (`idCriterio`) REFERENCES `criterioEvaluacionEm` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detEvaluacionProveedor_ibfk_2` FOREIGN KEY (`idEncEvaluacion`) REFERENCES `evaluacionProveedorEnc` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detInspeccionLlantas`
--
ALTER TABLE `detInspeccionLlantas`
  ADD CONSTRAINT `detInspeccionLlantas_ibfk_1` FOREIGN KEY (`idEncInsp`) REFERENCES `inspeccionLlantas` (`idEncInspLl`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detInventarios`
--
ALTER TABLE `detInventarios`
  ADD CONSTRAINT `detInventarios_ibfk_1` FOREIGN KEY (`idInventario`) REFERENCES `encInventarios` (`idEncInventario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detInventarios_ibfk_2` FOREIGN KEY (`idLote`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detInventarios_ibfk_3` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detInventarios_ibfk_4` FOREIGN KEY (`idReserva`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detSalidaProveedor`
--
ALTER TABLE `detSalidaProveedor`
  ADD CONSTRAINT `detSalidaProveedor_ibfk_1` FOREIGN KEY (`idEncSalidaProv`) REFERENCES `encSalidaProveedor` (`idEncSalidaProv`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detSalidaProveedor_ibfk_2` FOREIGN KEY (`idLoteSalida`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detSalidaProveedor_ibfk_3` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detSolicitudMat`
--
ALTER TABLE `detSolicitudMat`
  ADD CONSTRAINT `detSolicitudMat_ibfk_1` FOREIGN KEY (`idSolicitudMat`) REFERENCES `encSolicitudMat` (`idSolicitudMat`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detSolicitudMat_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detTranferEm`
--
ALTER TABLE `detTranferEm`
  ADD CONSTRAINT `detTranferEm_ibfk_1` FOREIGN KEY (`idLote`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTranferEm_ibfk_2` FOREIGN KEY (`idReserva`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTranferEm_ibfk_3` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTranferEm_ibfk_4` FOREIGN KEY (`idSalidaMaterial`) REFERENCES `encTranferEm` (`idSalMatConsumo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detTrasladoMoviles`
--
ALTER TABLE `detTrasladoMoviles`
  ADD CONSTRAINT `detTrasladoMoviles_ibfk_1` FOREIGN KEY (`idLoteTraslado`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTrasladoMoviles_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTrasladoMoviles_ibfk_3` FOREIGN KEY (`idReserva`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTrasladoMoviles_ibfk_4` FOREIGN KEY (`idTrasladoMovil`) REFERENCES `encTrasladoMoviles` (`idTrasladoMovil`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detTrasladoReservas`
--
ALTER TABLE `detTrasladoReservas`
  ADD CONSTRAINT `detTrasladoReservas_ibfk_1` FOREIGN KEY (`idLoteTrasRese`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTrasladoReservas_ibfk_2` FOREIGN KEY (`idProTrasRese`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTrasladoReservas_ibfk_3` FOREIGN KEY (`idOldRese`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detTrasladoReservas_ibfk_4` FOREIGN KEY (`idNewRese`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `documentosConductor`
--
ALTER TABLE `documentosConductor`
  ADD CONSTRAINT `documentosConductor_ibfk_1` FOREIGN KEY (`idDocConductor`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `documentosConductor_ibfk_2` FOREIGN KEY (`fkIdDocumento`) REFERENCES `maestraVencDocs` (`idDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `documentosConductor_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `documentosFlota`
--
ALTER TABLE `documentosFlota`
  ADD CONSTRAINT `documentosFlota_ibfk_1` FOREIGN KEY (`fkIdDocumento`) REFERENCES `maestraVencDocs` (`idDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `documentosFlota_ibfk_2` FOREIGN KEY (`fkPlacaFlota`) REFERENCES `vehiculo` (`placa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `documentosFlota_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ejecutoresMantenimiento`
--
ALTER TABLE `ejecutoresMantenimiento`
  ADD CONSTRAINT `ejecutoresMantenimiento_ibfk_1` FOREIGN KEY (`ccEjecutor`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ejecutoresMantenimiento_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ejecutores_mtto_especialidades`
--
ALTER TABLE `ejecutores_mtto_especialidades`
  ADD CONSTRAINT `FK_ejecutores_mtto_especialidades_ejecutores_mtto` FOREIGN KEY (`idEjecutor`) REFERENCES `ejecutores_mtto_interno` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ejecutores_mtto_especialidades_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ejecutores_mtto_especialidades_ibfk_3` FOREIGN KEY (`idEspecialidad`) REFERENCES `especialidadesEm` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ejecutores_mtto_externo`
--
ALTER TABLE `ejecutores_mtto_externo`
  ADD CONSTRAINT `FK_ejecutores_mtto_externo_personal` FOREIGN KEY (`user_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_ejecutores_mtto_externo_sucursalesProv` FOREIGN KEY (`id_sucursal`) REFERENCES `sucursalesProv` (`idSucursal`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ejecutores_mtto_interno`
--
ALTER TABLE `ejecutores_mtto_interno`
  ADD CONSTRAINT `FK_ejecutores_mtto_interno_personal` FOREIGN KEY (`document`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_ejecutores_mtto_personal` FOREIGN KEY (`user_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `ejecutores_mtto_interno_ibfk_1` FOREIGN KEY (`id_bodega`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `empresa`
--
ALTER TABLE `empresa`
  ADD CONSTRAINT `empresa_ibfk_1` FOREIGN KEY (`fkIdPlanQi`) REFERENCES `qinspect_planesQi`.`planes` (`Id_plan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `empresa_ibfk_2` FOREIGN KEY (`fkIdCiudad`) REFERENCES `ciudad` (`idCiudad`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `emProyectos`
--
ALTER TABLE `emProyectos`
  ADD CONSTRAINT `emProyectos_ibfk_1` FOREIGN KEY (`idEm`) REFERENCES `ejecutores_mtto_interno` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `emProyectos_ibfk_2` FOREIGN KEY (`usuario_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encDevInventario`
--
ALTER TABLE `encDevInventario`
  ADD CONSTRAINT `encDevInventario_ibfk_1` FOREIGN KEY (`id_em`) REFERENCES `ejecutores_mtto_interno` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encDevInventario_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encEntradaInventario`
--
ALTER TABLE `encEntradaInventario`
  ADD CONSTRAINT `encEntradaInventario_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encEntradaInventario_ibfk_2` FOREIGN KEY (`idSolicitudMat`) REFERENCES `encSolicitudMat` (`idSolicitudMat`) ON DELETE CASCADE;

--
-- Filtros para la tabla `encInventarios`
--
ALTER TABLE `encInventarios`
  ADD CONSTRAINT `encInventarios_ibfk_1` FOREIGN KEY (`idBodega`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encInventarios_ibfk_2` FOREIGN KEY (`idUsuarioMovil`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encInventarios_ibfk_3` FOREIGN KEY (`idUsuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encOrdenCompra`
--
ALTER TABLE `encOrdenCompra`
  ADD CONSTRAINT `encOrdenCompra_ibfk_3` FOREIGN KEY (`idBodega`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encOrdenCompra_ibfk_4` FOREIGN KEY (`idProveedor`) REFERENCES `proveedor` (`idProv`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encOrdenCompra_ibfk_5` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encSalidaProveedor`
--
ALTER TABLE `encSalidaProveedor`
  ADD CONSTRAINT `encSalidaProveedor_ibfk_1` FOREIGN KEY (`idBodega`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encSalidaProveedor_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encSalidaProveedor_ibfk_4` FOREIGN KEY (`idSucursal`) REFERENCES `sucursalesProv` (`idSucursal`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encSolicitudMat`
--
ALTER TABLE `encSolicitudMat`
  ADD CONSTRAINT `encSolicitudMat_ibfk_1` FOREIGN KEY (`idAlmacen`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encSolicitudMat_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encSolicitudMat_ibfk_3` FOREIGN KEY (`idSucursal`) REFERENCES `sucursalesProv` (`idSucursal`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encTranferEm`
--
ALTER TABLE `encTranferEm`
  ADD CONSTRAINT `encTranferEm_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encTrasladoMoviles`
--
ALTER TABLE `encTrasladoMoviles`
  ADD CONSTRAINT `encTrasladoMoviles_ibfk_1` FOREIGN KEY (`idBodega`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encTrasladoMoviles_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encTrasladoMoviles_ibfk_3` FOREIGN KEY (`idUsuarioEntrega`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encTrasladoReservas`
--
ALTER TABLE `encTrasladoReservas`
  ADD CONSTRAINT `encTrasladoReservas_ibfk_1` FOREIGN KEY (`cedulaUsuario`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encTrasladoReservas_ibfk_2` FOREIGN KEY (`idBodega`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `encuesta`
--
ALTER TABLE `encuesta`
  ADD CONSTRAINT `encuesta_ibfk_1` FOREIGN KEY (`creadorEncuesta`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `encuesta_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `especialidadesEm`
--
ALTER TABLE `especialidadesEm`
  ADD CONSTRAINT `especialidadesEm_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `evaluacionProveedorEnc`
--
ALTER TABLE `evaluacionProveedorEnc`
  ADD CONSTRAINT `evaluacionProveedorEnc_ibfk_1` FOREIGN KEY (`idSucursal`) REFERENCES `sucursalesProv` (`idSucursal`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `evaluacionProveedorEnc_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `evaluacionProveedorEnc_ibfk_3` FOREIGN KEY (`idCriticidad`) REFERENCES `criticidadEm` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `evidencias`
--
ALTER TABLE `evidencias`
  ADD CONSTRAINT `evidencias_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `evidencias_ibfk_2` FOREIGN KEY (`idCapacitacion`) REFERENCES `capacitacion` (`idCapacitacion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `fallasSolucionadas`
--
ALTER TABLE `fallasSolucionadas`
  ADD CONSTRAINT `fallasSolucionadas_ibfk_3` FOREIGN KEY (`personaDocumento`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fallasSolucionadas_ibfk_4` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `firmasDigitales`
--
ALTER TABLE `firmasDigitales`
  ADD CONSTRAINT `firmasDigitales_ibfk_1` FOREIGN KEY (`fkNumeroDoc`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `hasArticuloAlmacen`
--
ALTER TABLE `hasArticuloAlmacen`
  ADD CONSTRAINT `hasArticuloAlmacen_ibfk_1` FOREIGN KEY (`usuario_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hasArticuloAlmacen_ibfk_2` FOREIGN KEY (`id_almacen`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `hasArticuloAlmacen_ibfk_3` FOREIGN KEY (`id_articulo`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `historial_estados_asignacion_em_tareas`
--
ALTER TABLE `historial_estados_asignacion_em_tareas`
  ADD CONSTRAINT `FK_historial_id_asignacion` FOREIGN KEY (`id_asignacion`) REFERENCES `programacion_mtto_asignacion_em_tareas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_historial_user_control` FOREIGN KEY (`user_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `inspeccionLlantas`
--
ALTER TABLE `inspeccionLlantas`
  ADD CONSTRAINT `inspeccionLlantas_ibfk_1` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inspeccionLlantas_ibfk_2` FOREIGN KEY (`placa`) REFERENCES `vehiculo` (`placa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inspeccionLlantas_ibfk_3` FOREIGN KEY (`userControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `inventarioVehiculo`
--
ALTER TABLE `inventarioVehiculo`
  ADD CONSTRAINT `inventarioVehiculo_ibfk_1` FOREIGN KEY (`idAlmacen`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inventarioVehiculo_ibfk_2` FOREIGN KEY (`idLote`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inventarioVehiculo_ibfk_3` FOREIGN KEY (`idTipoReserva`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inventarioVehiculo_ibfk_4` FOREIGN KEY (`placaInv`) REFERENCES `vehiculo` (`placa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `inventarioVehiculo_ibfk_5` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `itemInspeccion`
--
ALTER TABLE `itemInspeccion`
  ADD CONSTRAINT `itemInspeccion_ibfk_1` FOREIGN KEY (`idCatItem`) REFERENCES `categoriaItems` (`idCategoriaItem`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `itemInspeccion_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `Item_Inspeccion`
--
ALTER TABLE `Item_Inspeccion`
  ADD CONSTRAINT `Item_Inspeccion_ibfk_1` FOREIGN KEY (`Cat_Item_Id`) REFERENCES `Categoria_item` (`Cat_Item_Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `llaveItemTpv`
--
ALTER TABLE `llaveItemTpv`
  ADD CONSTRAINT `llaveItemTpv_ibfk_1` FOREIGN KEY (`idItem`) REFERENCES `itemInspeccion` (`idItemInsp`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `llaveItemTpv_ibfk_2` FOREIGN KEY (`idTpVehiculo`) REFERENCES `tiposVehiculos` (`idTipVeh`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `llaveItemTpv_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `lote`
--
ALTER TABLE `lote`
  ADD CONSTRAINT `lote_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `maestraVencDocs`
--
ALTER TABLE `maestraVencDocs`
  ADD CONSTRAINT `maestraVencDocs_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manAddEncOrdenServicio`
--
ALTER TABLE `manAddEncOrdenServicio`
  ADD CONSTRAINT `manAddEncOrdenServicio_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manAddEncOrdenServicio_ibfk_2` FOREIGN KEY (`idEncOrdServicio`) REFERENCES `manEncabezadoOrdenServicio` (`idEncOrdServicio`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manArticulos`
--
ALTER TABLE `manArticulos`
  ADD CONSTRAINT `manArticulos_ibfk_3` FOREIGN KEY (`fkIdTipoArticulo`) REFERENCES `manTipoArticulos` (`idTipoArticulos`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manArticulos_ibfk_6` FOREIGN KEY (`UsuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manArticulos_ibfk_7` FOREIGN KEY (`fkUndEmpaqueCompra`) REFERENCES `manUnidadMedida` (`idUnidadMedida`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manArticulos_ibfk_8` FOREIGN KEY (`fkUndEmpaqueEntrega`) REFERENCES `manUnidadMedida` (`idUnidadMedida`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manArticulos_ibfk_9` FOREIGN KEY (`fkIdCatgArticulo`) REFERENCES `manCategoriaArticulos` (`idCategoriaArticulos`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manBodegas`
--
ALTER TABLE `manBodegas`
  ADD CONSTRAINT `manBodegas_ibfk_1` FOREIGN KEY (`idCiudadBodega`) REFERENCES `ciudad` (`idCiudad`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manBodegas_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manCategoriaArticulos`
--
ALTER TABLE `manCategoriaArticulos`
  ADD CONSTRAINT `manCategoriaArticulos_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manCausas`
--
ALTER TABLE `manCausas`
  ADD CONSTRAINT `manCausas_ibfk_1` FOREIGN KEY (`usuario_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manDetalleOrdenServicio`
--
ALTER TABLE `manDetalleOrdenServicio`
  ADD CONSTRAINT `manDetalleOrdenServicio_ibfk_1` FOREIGN KEY (`fkIdEncabOrdServicio`) REFERENCES `manEncabezadoOrdenServicio` (`idEncOrdServicio`);

--
-- Filtros para la tabla `manDetSolucionOrdenServicio`
--
ALTER TABLE `manDetSolucionOrdenServicio`
  ADD CONSTRAINT `manDetSolucionOrdenServicio_ibfk_1` FOREIGN KEY (`fkIdArticulo`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manDetSolucionOrdenServicio_ibfk_2` FOREIGN KEY (`fkIdSolucionOrdenServicio`) REFERENCES `manEncSolucionOrdenServicio` (`idSolucionOrdenServicio`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manEncabezadoOrdenServicio`
--
ALTER TABLE `manEncabezadoOrdenServicio`
  ADD CONSTRAINT `manEncabezadoOrdenServicio_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manEncabezadoOrdenServicio_ibfk_2` FOREIGN KEY (`placavehiculo`) REFERENCES `vehiculo` (`placa`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manEncSolucionOrdenServicio`
--
ALTER TABLE `manEncSolucionOrdenServicio`
  ADD CONSTRAINT `manEncSolucionOrdenServicio_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manFallas`
--
ALTER TABLE `manFallas`
  ADD CONSTRAINT `manFallas_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manFallasHasItem`
--
ALTER TABLE `manFallasHasItem`
  ADD CONSTRAINT `manFallasHasItem_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manFallasHasItem_ibfk_2` FOREIGN KEY (`fkIdFalla`) REFERENCES `manFallas` (`idFallas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manFrecuencias`
--
ALTER TABLE `manFrecuencias`
  ADD CONSTRAINT `manFrecuencias_ibfk_1` FOREIGN KEY (`usuario_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manMarcaArticulos`
--
ALTER TABLE `manMarcaArticulos`
  ADD CONSTRAINT `manMarcaArticulos_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manProrrogaMttoProg`
--
ALTER TABLE `manProrrogaMttoProg`
  ADD CONSTRAINT `manProrrogaMttoProg_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manProrrogaMttoProg_ibfk_2` FOREIGN KEY (`fkIdEncaOrdenServicio`) REFERENCES `manEncabezadoOrdenServicio` (`idEncOrdServicio`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manRutinas`
--
ALTER TABLE `manRutinas`
  ADD CONSTRAINT `manRutinas_ibfk_1` FOREIGN KEY (`idSistema`) REFERENCES `manSistemas` (`idSistemas`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manRutinas_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manRutinasTareas`
--
ALTER TABLE `manRutinasTareas`
  ADD CONSTRAINT `manRutinasTareas_ibfk_1` FOREIGN KEY (`idRutina`) REFERENCES `manRutinas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manRutinasTareas_ibfk_2` FOREIGN KEY (`idTarea`) REFERENCES `manTareas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manSeriSoluOS`
--
ALTER TABLE `manSeriSoluOS`
  ADD CONSTRAINT `manSeriSoluOS_ibfk_1` FOREIGN KEY (`fkIdArticulo`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manSeriSoluOS_ibfk_2` FOREIGN KEY (`fkIdSolucionOrdenServicio`) REFERENCES `manEncSolucionOrdenServicio` (`idSolucionOrdenServicio`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manSeriSoluOS_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manSistemas`
--
ALTER TABLE `manSistemas`
  ADD CONSTRAINT `manSistemas_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manSistemasHhasRutinas`
--
ALTER TABLE `manSistemasHhasRutinas`
  ADD CONSTRAINT `manSistemasHhasRutinas_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manSistemasHhasRutinas_ibfk_2` FOREIGN KEY (`fkIdTipoVeh`) REFERENCES `tiposVehiculos` (`idTipVeh`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manSistemasHhasRutinas_ibfk_3` FOREIGN KEY (`fkIdSistemas`) REFERENCES `manSistemas` (`idSistemas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manTareas`
--
ALTER TABLE `manTareas`
  ADD CONSTRAINT `manTareas_ibfk_1` FOREIGN KEY (`usuario_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manTareas_ibfk_2` FOREIGN KEY (`tipo_frecuencia`) REFERENCES `manFrecuencias` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `manTareas_ibfk_3` FOREIGN KEY (`sistema`) REFERENCES `manSistemas` (`idSistemas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manTipoArticulos`
--
ALTER TABLE `manTipoArticulos`
  ADD CONSTRAINT `manTipoArticulos_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manTipoComprobante`
--
ALTER TABLE `manTipoComprobante`
  ADD CONSTRAINT `manTipoComprobante_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `manUnidadMedida`
--
ALTER TABLE `manUnidadMedida`
  ADD CONSTRAINT `manUnidadMedida_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `marcaVehiculo`
--
ALTER TABLE `marcaVehiculo`
  ADD CONSTRAINT `marcaVehiculo_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `notificacionesCorreo`
--
ALTER TABLE `notificacionesCorreo`
  ADD CONSTRAINT `notificacionesCorreo_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `notificacionesGeneral`
--
ALTER TABLE `notificacionesGeneral`
  ADD CONSTRAINT `notificacionesGeneral_ibfk_1` FOREIGN KEY (`ntUsuarioNotificado`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `notificacionesGeneral_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `notificacionesInspec`
--
ALTER TABLE `notificacionesInspec`
  ADD CONSTRAINT `notificacionesInspec_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `permisosRol`
--
ALTER TABLE `permisosRol`
  ADD CONSTRAINT `permisosRol_ibfk_1` FOREIGN KEY (`fkIdItemModulo`) REFERENCES `itemModuloFrontend` (`idItemModulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permisosRol_ibfk_2` FOREIGN KEY (`fkIdRol`) REFERENCES `rol` (`rolId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permisosRol_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permisosRol_ibfk_4` FOREIGN KEY (`idAcciones`) REFERENCES `accionesSistemaUsuario` (`idAccion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `permisoUsuario`
--
ALTER TABLE `permisoUsuario`
  ADD CONSTRAINT `permisoUsuario_ibfk_2` FOREIGN KEY (`idAccionesUsuario`) REFERENCES `accionesSistemaUsuario` (`idAccion`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permisoUsuario_ibfk_3` FOREIGN KEY (`idItem`) REFERENCES `itemModuloFrontend` (`idItemModulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permisoUsuario_ibfk_4` FOREIGN KEY (`idAccionesUsuario`) REFERENCES `accionesSistemaUsuario` (`idAccion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `personal`
--
ALTER TABLE `personal`
  ADD CONSTRAINT `personal_ibfk_1` FOREIGN KEY (`fkIdTIpoDocumento`) REFERENCES `tipoDocumento` (`idTipoDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `personal_ibfk_2` FOREIGN KEY (`fkIdEmpresa`) REFERENCES `empresa` (`idEmpresa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `personal_ibfk_3` FOREIGN KEY (`fkIdCargo`) REFERENCES `cargos` (`idCargo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `personal_ibfk_4` FOREIGN KEY (`fkIdRol`) REFERENCES `rol` (`rolId`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `personal_ibfk_5` FOREIGN KEY (`lugarExpDocumento`) REFERENCES `ciudad` (`idCiudad`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `preguntasCapacitacion`
--
ALTER TABLE `preguntasCapacitacion`
  ADD CONSTRAINT `preguntasCapacitacion_ibfk_1` FOREIGN KEY (`idTipoPregunta`) REFERENCES `tipoPregunta` (`idTipoPregunta`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `preguntasCapacitacion_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `preguntasCapacitacion_ibfk_3` FOREIGN KEY (`idCapPregunta`) REFERENCES `capacitacion` (`idCapacitacion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `preguntasEncuesta`
--
ALTER TABLE `preguntasEncuesta`
  ADD CONSTRAINT `preguntasEncuesta_ibfk_1` FOREIGN KEY (`idEncuesta`) REFERENCES `encuesta` (`idEncuesta`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `preguntasEncuesta_ibfk_2` FOREIGN KEY (`tipoPregunta`) REFERENCES `tipoPregunta` (`idTipoPregunta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `profesionalArea`
--
ALTER TABLE `profesionalArea`
  ADD CONSTRAINT `profesionalArea_ibfk_1` FOREIGN KEY (`idArea`) REFERENCES `area` (`idArea`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `profesionalArea_ibfk_2` FOREIGN KEY (`usuarioCapacitador`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto`
--
ALTER TABLE `programacion_mtto`
  ADD CONSTRAINT `programacion_mtto_ibfk_1` FOREIGN KEY (`placa`) REFERENCES `vehiculo` (`placa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_ibfk_2` FOREIGN KEY (`usuario_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_asignacion_em_tareas`
--
ALTER TABLE `programacion_mtto_asignacion_em_tareas`
  ADD CONSTRAINT `programacion_mtto_asignacion_em_tareas_ibfk_1` FOREIGN KEY (`id_programacion_mtto`) REFERENCES `programacion_mtto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_asignacion_em_tareas_ibfk_2` FOREIGN KEY (`id_tarea`) REFERENCES `manTareas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_asignacion_em_tareas_ibfk_3` FOREIGN KEY (`user_control`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_fallas`
--
ALTER TABLE `programacion_mtto_fallas`
  ADD CONSTRAINT `programacion_mtto_fallas_ibfk_1` FOREIGN KEY (`id_item_falla`) REFERENCES `itemInspeccion` (`idItemInsp`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_fallas_ibfk_2` FOREIGN KEY (`id_programacion`) REFERENCES `programacion_mtto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_fallas_causas`
--
ALTER TABLE `programacion_mtto_fallas_causas`
  ADD CONSTRAINT `programacion_mtto_fallas_causas_ibfk_1` FOREIGN KEY (`id_causa`) REFERENCES `manCausas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_fallas_causas_ibfk_2` FOREIGN KEY (`id_mtto_falla`) REFERENCES `programacion_mtto_fallas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_fallas_rutinas`
--
ALTER TABLE `programacion_mtto_fallas_rutinas`
  ADD CONSTRAINT `programacion_mtto_fallas_rutinas_ibfk_1` FOREIGN KEY (`id_rutina`) REFERENCES `manRutinas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_fallas_rutinas_ibfk_2` FOREIGN KEY (`id_falla_program`) REFERENCES `programacion_mtto_fallas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_fallas_tareas`
--
ALTER TABLE `programacion_mtto_fallas_tareas`
  ADD CONSTRAINT `programacion_mtto_fallas_tareas_ibfk_1` FOREIGN KEY (`id_tarea`) REFERENCES `manTareas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_fallas_tareas_ibfk_2` FOREIGN KEY (`id_falla_program`) REFERENCES `programacion_mtto_fallas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_rutinas`
--
ALTER TABLE `programacion_mtto_rutinas`
  ADD CONSTRAINT `programacion_mtto_rutinas_ibfk_1` FOREIGN KEY (`id_programacion`) REFERENCES `programacion_mtto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_rutinas_ibfk_2` FOREIGN KEY (`id_rutina`) REFERENCES `manRutinas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_rutinas_causas`
--
ALTER TABLE `programacion_mtto_rutinas_causas`
  ADD CONSTRAINT `programacion_mtto_rutinas_causas_ibfk_1` FOREIGN KEY (`id_causa`) REFERENCES `manCausas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_rutinas_causas_ibfk_2` FOREIGN KEY (`id_mtto_rutina`) REFERENCES `programacion_mtto_rutinas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_tareas`
--
ALTER TABLE `programacion_mtto_tareas`
  ADD CONSTRAINT `programacion_mtto_tareas_ibfk_1` FOREIGN KEY (`id_programacion`) REFERENCES `programacion_mtto` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_tareas_ibfk_2` FOREIGN KEY (`id_tarea`) REFERENCES `manTareas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `programacion_mtto_tareas_causas`
--
ALTER TABLE `programacion_mtto_tareas_causas`
  ADD CONSTRAINT `programacion_mtto_tareas_causas_ibfk_1` FOREIGN KEY (`id_causa`) REFERENCES `manCausas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `programacion_mtto_tareas_causas_ibfk_2` FOREIGN KEY (`id_mtto_tarea`) REFERENCES `programacion_mtto_tareas` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD CONSTRAINT `proveedor_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `proveedor_ibfk_2` FOREIGN KEY (`tipoDocId`) REFERENCES `tipoDocumento` (`idTipoDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `proveedor_ibfk_3` FOREIGN KEY (`idRegimen`) REFERENCES `regimenTributario` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `qRealizanCapacitacion`
--
ALTER TABLE `qRealizanCapacitacion`
  ADD CONSTRAINT `qRealizanCapacitacion_ibfk_1` FOREIGN KEY (`qRUsuario`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `qRealizanCapacitacion_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `qRealizanCapacitacion_ibfk_3` FOREIGN KEY (`qRIdCap`) REFERENCES `capacitacion` (`idCapacitacion`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `qREncuestas`
--
ALTER TABLE `qREncuestas`
  ADD CONSTRAINT `qREncuestas_ibfk_1` FOREIGN KEY (`idEncuestaUser`) REFERENCES `encuesta` (`idEncuesta`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `qREncuestas_ibfk_2` FOREIGN KEY (`cedulaUsuario`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `qREncuestas_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `regimenTributario`
--
ALTER TABLE `regimenTributario`
  ADD CONSTRAINT `regimenTributario_ibfk_1` FOREIGN KEY (`usuairoControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `remolque`
--
ALTER TABLE `remolque`
  ADD CONSTRAINT `remolque_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `reporteAuditoria`
--
ALTER TABLE `reporteAuditoria`
  ADD CONSTRAINT `reporteAuditoria_ibfk_1` FOREIGN KEY (`personaDocumento`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reporteAuditoria_ibfk_2` FOREIGN KEY (`idResumenPreoperacional`) REFERENCES `resumenPreoperacional` (`idResumen`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `respuestasCapacitacion`
--
ALTER TABLE `respuestasCapacitacion`
  ADD CONSTRAINT `respuestasCapacitacion_ibfk_1` FOREIGN KEY (`idPregunta`) REFERENCES `preguntasCapacitacion` (`idPreguntaCap`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `respuestasCapacitacion_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `respuestasEncuesta`
--
ALTER TABLE `respuestasEncuesta`
  ADD CONSTRAINT `respuestasEncuesta_ibfk_1` FOREIGN KEY (`idPregRta`) REFERENCES `preguntasEncuesta` (`idPregunta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `respuestasEncuestasOk`
--
ALTER TABLE `respuestasEncuestasOk`
  ADD CONSTRAINT `respuestasEncuestasOk_ibfk_1` FOREIGN KEY (`usuarioUser`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `respuestasUsuario`
--
ALTER TABLE `respuestasUsuario`
  ADD CONSTRAINT `respuestasUsuario_ibfk_1` FOREIGN KEY (`usuarioRealiza`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `Respuestasv2`
--
ALTER TABLE `Respuestasv2`
  ADD CONSTRAINT `fk_respuestas_preguntas1` FOREIGN KEY (`id_Pregunta`) REFERENCES `Preguntas_v2` (`id_Pregunta`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `respuestas_usuario`
--
ALTER TABLE `respuestas_usuario`
  ADD CONSTRAINT `fk_respuestas_usuario_respuestas1` FOREIGN KEY (`id_Respuestas`) REFERENCES `Respuestasv2` (`id_Respuestas`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `resumenPreoperacional`
--
ALTER TABLE `resumenPreoperacional`
  ADD CONSTRAINT `resumenPreoperacional_ibfk_1` FOREIGN KEY (`idCiudad`) REFERENCES `ciudad` (`idCiudad`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resumenPreoperacional_ibfk_2` FOREIGN KEY (`usuarioPreoperacional`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resumenPreoperacional_ibfk_3` FOREIGN KEY (`placaRemolque`) REFERENCES `vehiculo` (`placa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `resumenPreoperacional_ibfk_4` FOREIGN KEY (`placaVehiculo`) REFERENCES `vehiculo` (`placa`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `rol`
--
ALTER TABLE `rol`
  ADD CONSTRAINT `rol_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `rtaPreoperacional`
--
ALTER TABLE `rtaPreoperacional`
  ADD CONSTRAINT `rtaPreoperacional_ibfk_2` FOREIGN KEY (`idItemInps`) REFERENCES `itemInspeccion` (`idItemInsp`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `serialEntradaInventario`
--
ALTER TABLE `serialEntradaInventario`
  ADD CONSTRAINT `serialEntradaInventario_ibfk_1` FOREIGN KEY (`idEncEntradaInv`) REFERENCES `encEntradaInventario` (`idEncEntradaInv`) ON DELETE CASCADE,
  ADD CONSTRAINT `serialEntradaInventario_ibfk_2` FOREIGN KEY (`idLote`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serialEntradaInventario_ibfk_3` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serialEntradaInventario_ibfk_4` FOREIGN KEY (`idReserva`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `serialInstalar`
--
ALTER TABLE `serialInstalar`
  ADD CONSTRAINT `fk_serialInstalar_estadoLlanta` FOREIGN KEY (`fkIdEstadoLlanta`) REFERENCES `estadosLlantas` (`idEstadoLlanta`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `serialInstalar_ibfk_1` FOREIGN KEY (`idBodega`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serialInstalar_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serialInstalar_ibfk_4` FOREIGN KEY (`idLoteSerial`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serialInstalar_ibfk_5` FOREIGN KEY (`idTipoReserva`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `serialTranferReturn`
--
ALTER TABLE `serialTranferReturn`
  ADD CONSTRAINT `serialTranferReturn_ibfk_1` FOREIGN KEY (`idEncTranfer`) REFERENCES `encDevInventario` (`idDevInventario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serialTranferReturn_ibfk_2` FOREIGN KEY (`idLote`) REFERENCES `lote` (`idLote`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serialTranferReturn_ibfk_3` FOREIGN KEY (`idProducto`) REFERENCES `manArticulos` (`idArticulo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `serialTranferReturn_ibfk_4` FOREIGN KEY (`idReservEm`) REFERENCES `tipoReserva` (`idReserva`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `sucursalesProv`
--
ALTER TABLE `sucursalesProv`
  ADD CONSTRAINT `sucursalesProv_ibfk_1` FOREIGN KEY (`idProvSucursal`) REFERENCES `proveedor` (`idProv`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sucursalesProv_ibfk_2` FOREIGN KEY (`idCiudad`) REFERENCES `ciudad` (`idCiudad`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `sucursalesProv_ibfk_3` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ticketsSoporteArchivos`
--
ALTER TABLE `ticketsSoporteArchivos`
  ADD CONSTRAINT `fk_ticket_archivo` FOREIGN KEY (`idTicket`) REFERENCES `ticketsSoporte` (`idTicket`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `ticketsSoporteRespuestas`
--
ALTER TABLE `ticketsSoporteRespuestas`
  ADD CONSTRAINT `fk_ticket_respuesta` FOREIGN KEY (`idTicket`) REFERENCES `ticketsSoporte` (`idTicket`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tipoAdjuntos`
--
ALTER TABLE `tipoAdjuntos`
  ADD CONSTRAINT `tipoAdjuntos_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tipoDocumento`
--
ALTER TABLE `tipoDocumento`
  ADD CONSTRAINT `tipoDocumento_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tipoPregunta`
--
ALTER TABLE `tipoPregunta`
  ADD CONSTRAINT `tipoPregunta_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tipoReserva`
--
ALTER TABLE `tipoReserva`
  ADD CONSTRAINT `tipoReserva_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `tiposVehiculos`
--
ALTER TABLE `tiposVehiculos`
  ADD CONSTRAINT `tiposVehiculos_ibfk_1` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarioPermisoBodega`
--
ALTER TABLE `usuarioPermisoBodega`
  ADD CONSTRAINT `usuarioPermisoBodega_ibfk_1` FOREIGN KEY (`idBodegaPermiso`) REFERENCES `manBodegas` (`idBodega`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuarioPermisoBodega_ibfk_2` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usuarioPermisoBodega_ibfk_3` FOREIGN KEY (`usuarioPermiso`) REFERENCES `personal` (`numeroDocumento`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `vehiculo`
--
ALTER TABLE `vehiculo`
  ADD CONSTRAINT `vehiculo_ibfk_1` FOREIGN KEY (`fkCiudadMatricula`) REFERENCES `ciudad` (`idCiudad`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `vehiculo_ibfk_2` FOREIGN KEY (`fkMarca`) REFERENCES `marcaVehiculo` (`idMarca`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `vehiculo_ibfk_3` FOREIGN KEY (`idProveedor`) REFERENCES `proveedor` (`idProv`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `vehiculo_ibfk_4` FOREIGN KEY (`idTipoVeh`) REFERENCES `tiposVehiculos` (`idTipVeh`),
  ADD CONSTRAINT `vehiculo_ibfk_5` FOREIGN KEY (`usuarioControl`) REFERENCES `personal` (`numeroDocumento`);

--
-- Filtros para la tabla `versionFormatos`
--
ALTER TABLE `versionFormatos`
  ADD CONSTRAINT `versionFormatos_ibfk_1` FOREIGN KEY (`idEmpresaFormato`) REFERENCES `empresa` (`idEmpresa`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `version_formatos`
--
ALTER TABLE `version_formatos`
  ADD CONSTRAINT `version_formatos_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `Empresa` (`Emp_Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `vigencia`
--
ALTER TABLE `vigencia`
  ADD CONSTRAINT `fk_vigencia_capacitacion1` FOREIGN KEY (`id_Capacitacion1`) REFERENCES `capacitacion_v2` (`id_Capacitacion`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
