# Vistas de reporting (cross-base)

Vistas que unen tablas de **varias bases** del refactor (03 inspecciones, 04 mantenimientos, 05 inventario) para reportes y control de negocio.

## vistaControlLlantas / lla_vista_control_llantas

Control de llantas: código, remolque actual, km acumulado, vida útil, % vida, descripción, marca, placa cabezote, km tramo, fecha fin.  
Depende de: `inv_serial_instalar` (05), `man_articulos`, `man_marca_articulos` (04), `lla_registro_kilometraje_llantas` (03).

- **Mismo esquema (unificado):** Si todas las tablas están en una sola base (replica unificada o despliegue single-DB), usar `01_vista_control_llantas_unificado.sql`.
- **Bases separadas (mismo servidor):** Si 03, 04 y 05 son bases distintas en el mismo MySQL, usar `01_vista_control_llantas_cross_db.sql` y sustituir los placeholders `BD_INSPECCIONES`, `BD_MANTENIMIENTOS`, `BD_INVENTARIO` por los nombres reales de las bases.

La vista expone alias compatibles con legacy: `codigoLlanta`, `remolqueActual`, `kmAcumulado`, `vidaUtilKm`, `porcentajeVida`, `descripcionLlanta`, `marca`, `placaCabezote`, `kmTramo`, `fechaFin`.
