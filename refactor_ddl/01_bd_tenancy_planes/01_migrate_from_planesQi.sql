-- =============================================================================
-- bd_tenancy_planes - Migración de datos desde qinspect_planesQi
-- Ejecutar después de 00_schema.sql.
-- Requisito: tener la base de datos de origen qinspect_planesQi en el mismo servidor.
-- Ejemplo: mysql -u root bd_tenancy_planes < 01_migrate_from_planesQi.sql
-- =============================================================================

-- ten_empresas <- Empresas (origen: qinspect_planesQi)
INSERT INTO `ten_empresas` (
  `id_empresa`, `razon_social`, `nit`, `digito_verificacion`, `direccion`,
  `nombre_qi`, `url_qi`, `ruta_logo`, `descripcion_logo`, `base_legacy`, `estado`
)
SELECT
  `Id_empresa`,
  `Razon_social`,
  COALESCE(SUBSTRING_INDEX(Razon_social, '-', 1), '') AS nit,
  `Digito_verificacion`,
  `Direccion`,
  `nombre_QI`,
  `url_QI`,
  `ruta_logo`,
  `descripcion_logo`,
  `base`,
  `estado`
FROM `qinspect_planesQi`.`Empresas`
ON DUPLICATE KEY UPDATE
  razon_social = VALUES(razon_social),
  direccion = VALUES(direccion),
  nombre_qi = VALUES(nombre_qi),
  url_qi = VALUES(url_qi),
  ruta_logo = VALUES(ruta_logo),
  base_legacy = VALUES(base_legacy),
  estado = VALUES(estado);

-- ten_planes <- planes
INSERT INTO `ten_planes` (
  `id_plan`, `descripcion`, `vh_desde`, `vh_hasta`, `precio`,
  `max_inspecciones`, `max_capacitaciones`, `estado`
)
SELECT
  `Id_plan`, `Descripcion`, `Vh_desde`, `Vh_hasta`, `Precio`,
  `Max_inspecciones`, `Max_capacitaciones`, `Estado`
FROM `qinspect_planesQi`.`planes`
ON DUPLICATE KEY UPDATE
  descripcion = VALUES(descripcion),
  vh_desde = VALUES(vh_desde),
  vh_hasta = VALUES(vh_hasta),
  precio = VALUES(precio),
  max_inspecciones = VALUES(max_inspecciones),
  max_capacitaciones = VALUES(max_capacitaciones),
  estado = VALUES(estado);

-- ten_planes_empresas <- Planes_empresas (vigente_hasta y estado_pago por defecto)
INSERT INTO `ten_planes_empresas` (
  `id_llave`, `id_empresa`, `id_plan`, `fecha_inicio`, `fecha_facturacion`,
  `estado_pago`, `estado`
)
SELECT
  `Id_llave`, `Id_empresa`, `Id_plan`, `Fecha_inicio`, `Fecha_facturacion`,
  1 AS estado_pago,
  `Estado`
FROM `qinspect_planesQi`.`Planes_empresas`
ON DUPLICATE KEY UPDATE
  fecha_inicio = VALUES(fecha_inicio),
  fecha_facturacion = VALUES(fecha_facturacion),
  estado = VALUES(estado);

-- ten_empleados_qi <- Empleados
INSERT INTO `ten_empleados_qi` (
  `cedula`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`,
  `cargo`, `email_corporativo`, `email_personal`, `descripcion_cargo`, `celular`,
  `fecha_nacimiento`, `rh`, `estado_contrato`, `fecha_expedicion`, `fecha_vigencia`, `departamento_area`
)
SELECT
  `Cedula`, `Primer_Nombre`, `Segundo_Nombre`, `Primer_Apellido`, `Segundo_Apellido`,
  `Cargo`, `Email_Corporativo`, `Email_Personal`, `Descripcion_cargo`, `Celular`,
  `Fecha_nacimiento`, `Rh`, `Estado_contrato`, `Fecha_Expedicion`, `Fecha_Vigencia`, `Departamento_area`
FROM `qinspect_planesQi`.`Empleados`
ON DUPLICATE KEY UPDATE
  primer_nombre = VALUES(primer_nombre),
  segundo_nombre = VALUES(segundo_nombre),
  primer_apellido = VALUES(primer_apellido),
  segundo_apellido = VALUES(segundo_apellido),
  cargo = VALUES(cargo),
  descripcion_cargo = VALUES(descripcion_cargo),
  celular = VALUES(celular),
  fecha_vigencia = VALUES(fecha_vigencia);

-- ten_mensajes <- mensajes
INSERT INTO `ten_mensajes` (`id_mensaje`, `nombre`, `mensaje`, `estado`)
SELECT `id_mensaje`, `Name`, `Mensaje`, `Estado` FROM `qinspect_planesQi`.`mensajes`
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), mensaje = VALUES(mensaje), estado = VALUES(estado);
