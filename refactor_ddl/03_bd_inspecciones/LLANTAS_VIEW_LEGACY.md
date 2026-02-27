# Vista legacy vistaControlLlantas (reporting)

En legacy, la vista **vistaControlLlantas** se usa para control de llantas (código, remolque actual, km acumulado, vida útil, % vida, descripción, marca, placa cabezote, km tramo, fecha fin).

## Definición legacy (qinspect_newpruebas)

La vista depende de tablas que en el refactor están en **varias bases**:

- `serialInstalar` (inventario / flota, según producto)
- `manArticulos` (bd_mantenimientos)
- `manMarcaArticulos` (bd_mantenimientos)
- `registroKilometrajeLlantas` → **lla_registro_kilometraje_llantas** (03 bd_inspecciones)

```sql
CREATE VIEW vistaControlLlantas AS
SELECT
  si.serial AS codigoLlanta,
  si.placaVehSeri AS remolqueActual,
  si.kmTotal AS kmAcumulado,
  ma.vidaUtilKm AS vidaUtilKm,
  CASE WHEN ma.vidaUtilKm > 0 THEN ROUND((si.kmTotal / ma.vidaUtilKm) * 100, 2) ELSE 0 END AS porcentajeVida,
  ma.descripcion AS descripcionLlanta,
  (SELECT manMarcaArticulos.descripcion FROM manMarcaArticulos WHERE manMarcaArticulos.idMarcaArticulos = ma.fkIdMarcaArticulos) AS marca,
  rk.placaCabezote AS placaCabezote,
  rk.kmTramo AS kmTramo,
  rk.fechaFin AS fechaFin
FROM serialInstalar si
JOIN manArticulos ma ON si.idProducto = ma.idArticulo
LEFT JOIN registroKilometrajeLlantas rk
  ON si.idProducto = rk.idProducto AND si.serial = rk.serialLlanta AND rk.activo = 0
ORDER BY rk.fechaFin DESC;
```

## En el refactor (implementado)

La vista **sí** está implementada en el refactor para uso en qinspecting y qinspecting-mantenimiento:

- **DDL:** `refactor_ddl/vistas_reporting/`
  - **Esquema unificado** (todas las tablas en la misma base): `01_vista_control_llantas_unificado.sql`
  - **Bases separadas** (03, 04, 05 en el mismo servidor): `01_vista_control_llantas_cross_db.sql` (sustituir placeholders BD_INVENTARIO, BD_MANTENIMIENTOS, BD_INSPECCIONES)
- Se crean `lla_vista_control_llantas` y el alias legacy `vistaControlLlantas` con las mismas columnas (codigoLlanta, remolqueActual, kmAcumulado, vidaUtilKm, porcentajeVida, descripcionLlanta, marca, placaCabezote, kmTramo, fechaFin).

Las tablas **lla_*** en 03 cubren el 100% de la idea de negocio de llantas; esta vista es la capa de agregación para reportes y control de llantas.
