-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 23-02-2026 a las 10:02:48
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
-- Base de datos: `qinspect_planesQi`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Empleados`
--

CREATE TABLE `Empleados` (
  `Cedula` int(11) NOT NULL,
  `Primer_Nombre` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Segundo_Nombre` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Primer_Apellido` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Segundo_Apellido` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Cargo` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Email_Corporativo` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `Email_Personal` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci DEFAULT NULL,
  `Descripcion_cargo` varchar(500) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Celular` bigint(20) NOT NULL,
  `Fecha_nacimiento` date NOT NULL,
  `Rh` varchar(10) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Estado_contrato` int(1) NOT NULL,
  `Fecha_Expedicion` date NOT NULL,
  `Fecha_Vigencia` date NOT NULL,
  `Departamento_area` varchar(50) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Empresas`
--

CREATE TABLE `Empresas` (
  `Id_empresa` int(11) NOT NULL,
  `Razon_social` varchar(450) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Digito_verificacion` int(1) NOT NULL,
  `Direccion` varchar(300) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `nombre_QI` varchar(200) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `url_QI` varchar(500) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `ruta_logo` varchar(500) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `descripcion_logo` varchar(1000) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `base` varchar(100) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `estado` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensajes`
--

CREATE TABLE `mensajes` (
  `id_mensaje` int(11) NOT NULL,
  `Name` varchar(15) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Mensaje` varchar(250) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Estado` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

CREATE TABLE `planes` (
  `Id_plan` int(11) NOT NULL,
  `Descripcion` varchar(450) CHARACTER SET utf8 COLLATE utf8_spanish_ci NOT NULL,
  `Vh_desde` int(11) NOT NULL,
  `Vh_hasta` int(11) NOT NULL,
  `Precio` int(11) NOT NULL,
  `Max_inspecciones` int(11) NOT NULL,
  `Max_capacitaciones` int(11) NOT NULL,
  `Estado` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='tabla de planes de los clientes';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `Planes_empresas`
--

CREATE TABLE `Planes_empresas` (
  `Id_llave` int(11) NOT NULL,
  `Id_empresa` int(11) NOT NULL,
  `Id_plan` int(11) NOT NULL,
  `Fecha_inicio` date NOT NULL,
  `Fecha_facturacion` date NOT NULL,
  `Estado` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `Empleados`
--
ALTER TABLE `Empleados`
  ADD PRIMARY KEY (`Cedula`);

--
-- Indices de la tabla `Empresas`
--
ALTER TABLE `Empresas`
  ADD PRIMARY KEY (`Id_empresa`);

--
-- Indices de la tabla `mensajes`
--
ALTER TABLE `mensajes`
  ADD PRIMARY KEY (`id_mensaje`);

--
-- Indices de la tabla `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`Id_plan`);

--
-- Indices de la tabla `Planes_empresas`
--
ALTER TABLE `Planes_empresas`
  ADD PRIMARY KEY (`Id_llave`),
  ADD KEY `Nit_empresa` (`Id_empresa`),
  ADD KEY `Id_plan` (`Id_plan`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `Empresas`
--
ALTER TABLE `Empresas`
  MODIFY `Id_empresa` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `mensajes`
--
ALTER TABLE `mensajes`
  MODIFY `id_mensaje` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `planes`
--
ALTER TABLE `planes`
  MODIFY `Id_plan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `Planes_empresas`
--
ALTER TABLE `Planes_empresas`
  MODIFY `Id_llave` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `Planes_empresas`
--
ALTER TABLE `Planes_empresas`
  ADD CONSTRAINT `Planes_empresas_ibfk_1` FOREIGN KEY (`Id_empresa`) REFERENCES `Empresas` (`Id_empresa`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Planes_empresas_ibfk_2` FOREIGN KEY (`Id_plan`) REFERENCES `planes` (`Id_plan`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
