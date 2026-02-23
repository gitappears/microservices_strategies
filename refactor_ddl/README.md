# DDL refactorizado y normalizado – Bases por sistema

Este directorio contiene los scripts DDL para crear las bases de datos normalizadas del plan de microservicios QInspecting. **Orden de ejecución:** según el número de carpeta (01, 02, …).

## Convenciones

- **Charset:** `utf8mb4` y collation `utf8mb4_unicode_ci` en todas las tablas.
- **Nombres de tablas:** prefijo por dominio (ten*, cat*, per*, etc.) y PascalCase o snake_case consistente según el archivo.
- **Claves primarias:** `id` auto_increment cuando aplica; tablas catálogo pueden usar PK natural (ej. código).
- **Tenant:** las tablas transaccionales incluyen `id_empresa` (INT) para multi-tenancy.
- **Control:** se recomienda `fecha_control` (DATETIME), `usuario_control` (VARCHAR) donde aplique.
- **Sin triggers legacy:** no se replican los triggers PascalCase↔camelCase del esquema actual; la aplicación escribe en una sola tabla.

## Bases y dependencias

| Orden | Base                  | Origen principal        | Dependencias |
|-------|-----------------------|-------------------------|--------------|
| 01    | bd_tenancy_planes     | qinspect_planesQi       | Ninguna      |
| 02    | bd_personal           | personal + catálogos de cada qinspect_new* | id_empresa → tenancy |
| 03    | bd_inspecciones       | tablas insp/preop/lla/fes | id_empresa   |
| 04    | bd_mantenimientos     | tablas man/prog/ejm     | id_empresa   |
| 05    | bd_inventario         | tablas inv*             | id_empresa   |
| 06    | bd_capacitaciones     | tablas cap*             | id_empresa, id_personal |
| 07    | bd_flota_documentos   | tablas veh/doc           | id_empresa   |

## Cómo usar

1. Crear cada base en MySQL: `CREATE DATABASE bd_tenancy_planes CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`
2. Ejecutar los `.sql` de la carpeta correspondiente en orden (00_schema.sql primero; luego migraciones si las hay).
3. Los datos se migran con los scripts de migración (DataMigrationService o scripts SQL de carga desde los dumps).

**Script helper:** desde este directorio puedes ejecutar:
```bash
chmod +x crear_bases_y_schema.sh
./crear_bases_y_schema.sh [host] [user] [password]
```
Crea las 7 bases (bd_tenancy_planes, bd_personal, bd_inspecciones, bd_mantenimientos, bd_inventario, bd_capacitaciones, bd_flota_documentos) y aplica sus DDL. La carga de datos desde los dumps se hace aparte (ver MAPEO_ORIGEN.md en cada carpeta).

## Origen de los esquemas

- **qinspect_planesQi** → `01_bd_tenancy_planes`
- Tablas `personal`, catálogos (departamento, ciudad, area, cargos, tipoDocumento) de cada **qinspect_new*** → `02_bd_personal`
- Tablas insp/preop/lla/fes → `03_bd_inspecciones`
- Tablas man/prog/ejm → `04_bd_mantenimientos`
- Tablas inv* → `05_bd_inventario`
- Tablas cap* → `06_bd_capacitaciones`
- Tablas veh/doc → `07_bd_flota_documentos`

Mapeo detallado en cada carpeta en `MAPEO_ORIGEN.md`; script de migración de datos desde planesQi en `01_bd_tenancy_planes/01_migrate_from_planesQi.sql`.
