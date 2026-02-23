# Mapeo: origen → bd_tenancy_planes

Ejecutar **01_migrate_from_planesQi.sql** con la base de datos de **origen** (qinspect_planesQi) cargada en el mismo servidor MySQL que la base destino bd_tenancy_planes, o copiar los datos vía ETL/script.

| Tabla origen (planesQi) | Tabla destino (bd_tenancy_planes) | Notas |
|-------------------------|-----------------------------------|--------|
| Empresas                | ten_empresas                      | `base` → base_legacy; nit se puede derivar de Razon_social si no existe en origen |
| planes                  | ten_planes                        | Directo |
| Planes_empresas         | ten_planes_empresas               | estado_pago=1, vigente_hasta=NULL por defecto |
| Empleados               | ten_empleados_qi                  | Directo |
| mensajes                | ten_mensajes                      | Name→nombre, Mensaje→mensaje |
| —                       | ten_empresa_capacidades           | Vacía; se llena por negocio |
