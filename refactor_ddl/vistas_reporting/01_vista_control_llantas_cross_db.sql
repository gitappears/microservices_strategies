-- =============================================================================
-- Vista control llantas (BASES SEPARADAS: 03, 04, 05 en el mismo servidor MySQL)
-- Sustituir BD_INVENTARIO, BD_MANTENIMIENTOS, BD_INSPECCIONES por los nombres
-- reales de las bases (ej. bd_inventario_empresa1, bd_mantenimientos_empresa1,
-- bd_inspecciones_empresa1 o el esquema que use el tenant).
-- Crear esta vista en la base de reporting o en BD_INSPECCIONES; el usuario MySQL
-- debe tener SELECT sobre las tres bases.
-- =============================================================================

-- Ejemplo con placeholders (reemplazar antes de ejecutar):
-- BD_INVENTARIO    -> nombre de la base donde está inv_serial_instalar
-- BD_MANTENIMIENTOS -> nombre de la base donde están man_articulos, man_marca_articulos
-- BD_INSPECCIONES  -> nombre de la base donde está lla_registro_kilometraje_llantas

DROP VIEW IF EXISTS `vistaControlLlantas`;
DROP VIEW IF EXISTS `lla_vista_control_llantas`;

CREATE VIEW `lla_vista_control_llantas` AS
SELECT
  si.`serial` AS codigoLlanta,
  si.`placa_veh_seri` AS remolqueActual,
  si.`km_total` AS kmAcumulado,
  ma.`vida_util_km` AS vidaUtilKm,
  CASE WHEN ma.`vida_util_km` > 0 THEN ROUND((si.`km_total` / ma.`vida_util_km`) * 100, 2) ELSE 0 END AS porcentajeVida,
  ma.`descripcion` AS descripcionLlanta,
  (SELECT mm.`descripcion` FROM `BD_MANTENIMIENTOS`.`man_marca_articulos` mm WHERE mm.`id_marca_articulos` = ma.`fk_id_marca_articulos` LIMIT 1) AS marca,
  rk.`placa_cabezote` AS placaCabezote,
  rk.`km_tramo` AS kmTramo,
  rk.`fecha_fin` AS fechaFin
FROM `BD_INVENTARIO`.`inv_serial_instalar` si
JOIN `BD_MANTENIMIENTOS`.`man_articulos` ma ON si.`id_empresa` = ma.`id_empresa` AND si.`id_producto` = ma.`id_articulo`
LEFT JOIN `BD_INSPECCIONES`.`lla_registro_kilometraje_llantas` rk
  ON si.`id_empresa` = rk.`id_empresa`
  AND si.`id_producto` = rk.`id_producto`
  AND si.`serial` = rk.`serial_llanta`
  AND rk.`activo` = 0
ORDER BY rk.`fecha_fin` DESC;

CREATE VIEW `vistaControlLlantas` AS SELECT * FROM `lla_vista_control_llantas`;
