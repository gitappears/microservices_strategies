-- =============================================================================
-- Vista control llantas (esquema UNIFICADO: tablas 03+04+05 en la misma base)
-- Origen: vistaControlLlantas (legacy). Uso: reportes, qinspecting, qinspecting-mantenimiento.
-- Aplicar solo cuando inv_serial_instalar, man_articulos, man_marca_articulos y
-- lla_registro_kilometraje_llantas existan en la base actual.
-- =============================================================================

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
  (SELECT mm.`descripcion` FROM `man_marca_articulos` mm WHERE mm.`id_marca_articulos` = ma.`fk_id_marca_articulos` LIMIT 1) AS marca,
  rk.`placa_cabezote` AS placaCabezote,
  rk.`km_tramo` AS kmTramo,
  rk.`fecha_fin` AS fechaFin
FROM `inv_serial_instalar` si
JOIN `man_articulos` ma ON si.`id_empresa` = ma.`id_empresa` AND si.`id_producto` = ma.`id_articulo`
LEFT JOIN `lla_registro_kilometraje_llantas` rk
  ON si.`id_empresa` = rk.`id_empresa`
  AND si.`id_producto` = rk.`id_producto`
  AND si.`serial` = rk.`serial_llanta`
  AND rk.`activo` = 0
ORDER BY rk.`fecha_fin` DESC;

-- Alias legacy para compatibilidad con consultas que usan el nombre antiguo
CREATE VIEW `vistaControlLlantas` AS SELECT * FROM `lla_vista_control_llantas`;
