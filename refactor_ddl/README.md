# DDL refactorizado y normalizado – Bases por sistema

Este directorio contiene los scripts DDL para crear las bases de datos normalizadas del plan de microservicios QInspecting. **Orden de ejecución:** según el número de carpeta (01, 02, …).

> **Sincronización bastión (2026-09-29):** cada `00_schema.sql` se regeneró con `SHOW CREATE TABLE` desde RDS `qinspecting-prod` (vía túnel bastión).  
> **Contexto + migración (documento único):** [`GUIA_MIGRACION_Y_CONTEXTO.md`](GUIA_MIGRACION_Y_CONTEXTO.md).

## Convenciones

- **Charset:** `utf8mb4` y collation `utf8mb4_unicode_ci` en la mayoría de tablas (respetar el DDL real de cada una).
- **Nombres de tablas:** prefijo por dominio (ten*, cat*, per*, etc.) según el esquema desplegado.
- **Claves primarias:** según definición real en RDS (auto_increment o PK natural).
- **Tenant:** las tablas transaccionales incluyen `id_empresa` (INT) donde aplica.
- **Sin triggers legacy:** no se replican los triggers PascalCase↔camelCase del esquema antiguo.

## Bases y dependencias

| Orden | Base                  | Origen principal        | Dependencias |
|-------|-----------------------|-------------------------|--------------|
| 01    | bd_tenancy_planes     | qinspect_planesQi       | Ninguna      |
| 02    | bd_personal           | personal + catálogos de cada qinspect_new* | id_empresa → tenancy |
| 08    | bd_catalogos_compartidos | cat_* compartidos (categorías, licencias, calificaciones, etc.) | Ninguna      |
| 03    | bd_inspecciones       | tablas insp/preop/lla/fes | id_empresa   |
| 04    | bd_mantenimientos     | tablas man/prog/ejm     | id_empresa   |
| 05    | bd_inventario         | tablas inv*             | id_empresa   |
| 06    | bd_capacitaciones     | tablas cap* + LMS training | id_empresa, id_personal |
| 07    | bd_flota_documentos   | tablas veh/doc           | id_empresa   |

En el mismo RDS existen además `legacy_planesQi`, `legacy_newpruebas` y `legacy_newtmc` (solo migración/referencia).

## Cómo usar

1. Crear cada base en MySQL: `CREATE DATABASE bd_tenancy_planes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
2. Ejecutar `00_schema.sql` de la carpeta correspondiente (incluye el esquema completo del bastión). Los stubs `01_*.sql` / `02_*.sql` no vuelven a crear tablas.
3. Los datos se migran con los scripts de migración (DataMigrationService o scripts SQL de carga desde los dumps).

**Script helper:** desde este directorio puedes ejecutar:
```bash
chmod +x crear_bases_y_schema.sh
./crear_bases_y_schema.sh [host] [user] [password]
```
Crea las 8 bases (bd_tenancy_planes, bd_personal, bd_catalogos_compartidos, bd_inspecciones, bd_mantenimientos, bd_inventario, bd_capacitaciones, bd_flota_documentos) y aplica sus DDL. La carga de datos desde los dumps se hace aparte (ver MAPEO_ORIGEN.md en cada carpeta).

## Origen de los esquemas

- **qinspect_planesQi** → `01_bd_tenancy_planes`
- Tablas `personal`, catálogos (departamento, ciudad, area, cargos, tipoDocumento) de cada **qinspect_new*** → `02_bd_personal`
- Catálogos compartidos (categorías items, licencias, calificaciones EM, etc.) → `08_bd_catalogos_compartidos`
- Tablas insp/preop/lla/fes → `03_bd_inspecciones`
- Tablas man/prog/ejm → `04_bd_mantenimientos`
- Tablas inv* → `05_bd_inventario`
- Tablas cap* + LMS → `06_bd_capacitaciones`
- Tablas veh/doc → `07_bd_flota_documentos`

Mapeo detallado en cada carpeta en `MAPEO_ORIGEN.md`; script de migración de datos desde planesQi en `01_bd_tenancy_planes/01_migrate_from_planesQi.sql`.
