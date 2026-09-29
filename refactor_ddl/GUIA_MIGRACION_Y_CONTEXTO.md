# Guía de contexto y migración — refactor_ddl

Documento único de referencia para entender las **8 bases normalizadas**, su inventario real en RDS (bastión) y cómo migrar desde el modelo legacy (`qinspect_planesQi` / `qinspect_new*`) hacia el API Nest y el resto del ecosistema.

| Campo | Valor |
|-------|--------|
| **Última sync DDL ↔ bastión** | 2026-09-29 |
| **Fuente del DDL** | `SHOW CREATE TABLE` sobre `qinspecting-prod` (túnel bastión) |
| **Scripts de esquema** | `0X_bd_*/00_schema.sql` |
| **Provisionar vacío** | `./crear_bases_y_schema.sh [host] [user] [password] [port]` |

Detalle de columnas/índices: siempre el `00_schema.sql` de cada carpeta. Mapeos de carga por dominio: `MAPEO_ORIGEN.md` en cada `0X_bd_*`.

---

## 1. Contexto: por qué 8 bases

El modelo legacy era **una base MySQL por empresa** (`qinspect_newpruebas`, `qinspect_newtmc`, …) más `qinspect_planesQi` para tenancy. El refactor consolida en **un RDS multi-base por dominio**, con `id_empresa` en tablas transaccionales (sin FK cross-database).

| Orden | Base | Rol | Origen principal |
|------:|------|-----|------------------|
| 01 | `bd_tenancy_planes` | Empresas, planes, capacidades, empleados QI, mensajes, régimen, términos | `qinspect_planesQi` |
| 02 | `bd_personal` | Personal + roles + catálogos de persona | `personal` / catálogos de cada `qinspect_new*` |
| 08 | `bd_catalogos_compartidos` | Maestras compartidas (EM, adjuntos, licencias, etc.) | catálogos duplicados en cada new* |
| 03 | `bd_inspecciones` | Preoperacional, ítems, llantas, formatos especiales | insp / preop / lla / fes |
| 04 | `bd_mantenimientos` | OS, rutinas, programación mtto, ejecutores EM | man / prog / ejm |
| 05 | `bd_inventario` | Almacenes, movimientos, seriales, proveedores | inv / prov / serial* |
| 06 | `bd_capacitaciones` | Cap legacy (`cap_*`) + LMS training + encuestas | cap* + app training |
| 07 | `bd_flota_documentos` | Vehículos, remolques, documentos, firmas | veh / doc |

**También en el mismo RDS (no se recrean con el script DDL):**

| Base | Uso en migración |
|------|------------------|
| `legacy_planesQi` | Snapshot / origen tenancy |
| `legacy_newpruebas` | Snapshot / origen operativo de referencia |
| `legacy_newtmc` | Snapshot / origen de otra empresa |

**Vistas:** `vistas_reporting/` (control de llantas cross-DB) es opcional; **aún no** está aplicada sobre las `bd_*` del bastión (sí existe `vistaControlLlantas` en legacy).

---

## 2. Inventario actual (tablas en bastión = `00_schema.sql`)

Cada base incluye además `migrations` (TypeORM). Conteos: tenancy **10** · personal **8** · catálogos **15** · inspecciones **31** · mantenimientos **42** · inventario **32** · capacitaciones **65** · flota **10**.

### 01 — `bd_tenancy_planes`
`ten_empresas`, `ten_planes`, `ten_planes_empresas`, `ten_plan_capacidades`, `ten_empresa_capacidades`, `ten_empleados_qi`, `ten_mensajes`, `ten_regimen_tributario`, `ten_terminos_condiciones`, `migrations`

### 02 — `bd_personal`
`per_personal`, `per_rol`, `cat_departamento`, `cat_ciudad`, `cat_area`, `cat_cargos`, `cat_tipo_documento`, `migrations`

### 08 — `bd_catalogos_compartidos`
`cat_categoria_items`, `cat_categoria_licencias`, `cat_calificacion_em`, `cat_criterio_evaluacion_em`, `cat_criticidad_em`, `cat_cursos_certificados`, `cat_tipo_reserva`, `cat_lote`, `cat_maestra_venc_docs`, `cat_tipo_adjuntos`, `cat_acciones_sistema_usuario`, `cat_cedulas_autoriza_almacen`, `cat_especialidades_em`, `cat_hash_tipo_vehiculo_css`, `migrations`

### 03 — `bd_inspecciones`
`insp_item_inspeccion`, `insp_item_tipo_vehiculo`, `insp_adjuntos_inspeccion`, `insp_item_has_fv_vehiculo`, `insp_item_has_fv_remolque`, `insp_inspeccion_llantas`, `preop_resumen_preoperacional`, `preop_rta_preoperacional`, `preop_fallas_solucionadas`, `preop_fotos_preoperacional_ultimate`, `lla_*` (det, item, estados, correctivas, desmontes, disposición, historico, kilometraje, reencauchadoras, trazabilidad, referencias, cat tipos), `fes_*` (cat, cat_item, enca, enca_det, enca_exp, user_realiza), `migrations`

### 04 — `bd_mantenimientos`
Catálogos `man_*` (bodegas, artículos, fallas, causas, tareas, frecuencias, rutinas, sistemas, OS, soluciones, prórrogas, módulos…), `prog_programacion_mtto` + detalle (tareas, fallas, rutinas, causas, asignación EM, historial), `ejm_ejecutores_mtto_*`, `ejm_em_inventario`, `ejm_em_proyectos`, `migrations`

### 05 — `bd_inventario`
`inv_almacen_*` / `inv_enc_*` / `inv_det_*` (inventarios, entradas, solicitudes, devoluciones, traslados, salida proveedor, orden compra), `inv_inventario_vehiculo`, `inv_has_articulo_almacen`, `inv_serial_instalar` + seriales de movimiento (`inv_serial_ejecutor_m`, `inv_serial_entrada_inventario`, `inv_serial_sal_proveedor`, `inv_serial_tranfer_*`), `prov_*`, `migrations`

### 06 — `bd_capacitaciones`
- **Cap legacy:** `cap_capacitacion`, adjuntos, evidencias, certificados, vigencia, preguntas/respuestas, profesional área, sección/lección/inscripción/progreso/material, catálogos `cap_area` / `cap_tipo_*` / `cap_cursos_certificados`
- **Encuestas:** `enc_encuesta`, `enc_preguntas_encuesta`, `enc_respuestas_encuesta`
- **LMS training:** `empresas`, `personas`, `usuarios`, `roles`, `capacitaciones`, lecciones, inscripciones, evaluaciones, certificados, pagos, alertas, `device_tokens`, `notificaciones`, etc. (todo en `00_schema.sql`)

### 07 — `bd_flota_documentos`
`veh_cat_tipos_vehiculos` (incluye `icon_ref` y attrs de llantas/remolque), `veh_cat_marca_vehiculo`, `veh_vehiculo`, `veh_cabezote_vehiculo`, `veh_remolque`, `veh_hash_binomios`, `doc_documentos_conductor`, `doc_documentos_flota`, `doc_firmas_digitales`, `migrations`

---

## 3. Cobertura de negocio legacy → refactor

| Dominio | Legacy (ejemplos) | Destino refactor | Estado |
|---------|-------------------|------------------|--------|
| Tenancy / planes | Empresas, planes, Planes_empresas, Empleados, mensajes | `ten_*` (+ régimen, términos) | Cubierto |
| Personal / roles | Personal, area, cargos, ciudad, departamento, tipoDocumento, Rol | `per_personal`, `per_rol`, `cat_*` | Cubierto (`Usuario` legacy → Cognito + `per_*` / LMS `usuarios`) |
| Inspecciones / preop | itemInspeccion, resumenPreoperacional, rta*, adjuntos, item_has_fv_* | `insp_*`, `preop_*` | Cubierto |
| Ítem × tipo vehículo | llaveItemTpv / llave_item_tpv | `insp_item_tipo_vehiculo` | Cubierto |
| Llantas / TireCheck | inspeccionLlantas, serialInstalar, registroKilometraje, estadosLlanta… | `lla_*` + `inv_serial_instalar` | Cubierto; vista reporting pendiente de aplicar en `bd_*` |
| Formatos especiales | formatoEspeciales* | `fes_*` | Cubierto |
| Mantenimiento | man*, programacion_mtto*, ejecutores*, emProyectos, emInventario | `man_*`, `prog_*`, `ejm_*`, `ejm_em_*` | Cubierto |
| Inventario / seriales | almacen*, enc/det*, proveedor*, serial* | `inv_*`, `prov_*`, `inv_serial_*` | Cubierto |
| Capacitaciones / encuestas | capacitacion*, encuesta* | `cap_*`, `enc_*` + LMS | Cubierto |
| Flota / documentos | vehiculo, remolque, documentos*, firmas* | `veh_*`, `doc_*` | Cubierto (`Documentos_Remolque/Vehiculo` → `doc_documentos_flota`) |
| Catálogos compartidos | categoriaItems, licencias, calificacionEm… | `bd_catalogos_compartidos.cat_*` | Cubierto |
| Permisos / tickets / alerts mtto legacy | Permisos*, ticketsSoporte*, alertasMantenimiento* | — | **No migrados** (opcional; ver §6) |

---

## 4. Playbook de migración de datos

### 4.1 Orden recomendado

1. **Provisionar** las 8 bases (`crear_bases_y_schema.sh` o DDL ya aplicado en RDS).
2. **Tenancy (`01`)** — cargar / migrar empresas y planes desde `legacy_planesQi` o dump `qinspect_planesQi` (`01_migrate_from_planesQi.sql`). Anotar `ten_empresas.base_legacy` ↔ nombre de base antigua.
3. **Catálogos** — `02` (persona) y `08` (compartidos); deduplicar filas repetidas por empresa.
4. **Personal (`02`)** — unificar `personal`/`Personal` de cada `qinspect_new*` inyectando `id_empresa` según `base_legacy`.
5. **Flota (`07`)** — vehículos, remolques, documentos, firmas con `id_empresa`.
6. **Inspecciones (`03`)** — ítems, preop, llantas, formatos.
7. **Mantenimientos (`04`) + Inventario (`05`)** — respetar FKs lógicas (artículos ↔ seriales ↔ kilometraje).
8. **Capacitaciones (`06`)** — `cap_*` / `enc_*`; LMS por scripts propios de training si aplica (`04_migrate_cap_legacy_to_lms.sql`, bridge).
9. **Validar** conteos por `id_empresa`, spot-checks de placas/documentos, smoke de Nest (`auth`, flota, preop, identity).
10. **Opcional:** aplicar `vistas_reporting/` cuando reportes de llantas deban salir de `bd_*`.

### 4.2 Reglas transversales

- **Tenant:** toda fila transaccional lleva `id_empresa` resuelto desde `ten_empresas` (vía `base_legacy` o NIT).
- **Sin FK entre bases:** referencias por IDs/documentos/placas; la app resuelve con varios DataSources.
- **PK típicas:** `per_personal (numero_documento, id_empresa)`; `veh_vehiculo (placa, id_empresa)`; otras según `00_schema.sql`.
- **Auth:** login ya no depende de `Usuario` por base; Cognito + perfil en `per_personal` (y LMS `usuarios` en capacitaciones).
- **PascalCase / camelCase duplicado en legacy:** migrar a **una** tabla snake_case; no recrear triggers de espejo.
- **Idempotencia:** preferir `INSERT … ON DUPLICATE KEY` / staging por `id_empresa` + clave natural.

### 4.3 Mapeo rápido legacy → tabla destino

| Legacy | Destino |
|--------|---------|
| Empresas / planes / Planes_empresas / Empleados / mensajes | `ten_empresas`, `ten_planes`, `ten_planes_empresas`, `ten_empleados_qi`, `ten_mensajes` |
| personal / Personal | `per_personal` |
| Rol / rol | `per_rol` |
| departamento, ciudad, area, cargos, tipoDocumento | `cat_*` en `bd_personal` |
| itemInspeccion, adjuntosInspeccion, item_has_fv_* | `insp_*` |
| resumenPreoperacional, rtaPreoperacional, fallas*, fotos* | `preop_*` |
| *Llantas* / manReferenciasLlanta | `lla_*` |
| serialInstalar | `inv_serial_instalar` |
| serialEjecutorM, serialEntradaInventario, … | `inv_serial_*` |
| programacion_mtto* | `prog_programacion_mtto*` |
| manBodegas, manArticulos, manTareas, … | `man_*` |
| ejecutores_mtto_*, emProyectos, emInventario | `ejm_*`, `ejm_em_proyectos`, `ejm_em_inventario` |
| almacenInventario, enc/det*, proveedor* | `inv_*`, `prov_*` |
| capacitacion*, encuesta* | `cap_*`, `enc_*` |
| vehiculo, remolque, cabezote*, documentos*, firmas* | `veh_*`, `doc_*` |
| tiposVehiculos, marcaVehiculo | `veh_cat_*` |

Detalle de columnas por dominio: `*/MAPEO_ORIGEN.md`.

---

## 5. Nest (`qinspecting_api_nest`) — convenciones y entidades

### 5.1 Convenciones

- `@Entity('tabla_ddl')`; columnas BD en snake_case → propiedad camelCase con `name: '…'`.
- Filtrar / escribir siempre con `idEmpresa` en tablas tenant.
- PK compuestas: consultas con ambos campos (`numeroDocumento`+`idEmpresa`, `placa`+`idEmpresa`).
- No asumir JOINs SQL entre bases; orquestar en aplicación o conexión multi-schema solo en fase transición.

### 5.2 Entidades ya alineadas (resumen)

| Base | Tablas / entidades |
|------|--------------------|
| `bd_tenancy_planes` | `ten_empresas` → Empresa |
| `bd_personal` | `per_personal`, `cat_departamento`, `cat_ciudad`, `cat_area`, `cat_cargos`, `cat_tipo_documento` |
| `bd_inspecciones` | `insp_*`, `preop_*`, `lla_*` (núcleo), `fes_*`, `insp_item_has_fv_*` |
| `bd_flota_documentos` | `veh_*`, `doc_*` |
| `bd_mantenimientos` | `man_*` núcleo OS/rutinas, `prog_*` asignación/historial, `ejm_ejecutores_*` |
| `bd_inventario` | `inv_*` movimientos, `prov_*` vía servicios/adapters |
| `bd_capacitaciones` | `cap_*` núcleo; LMS training suele usar su propio módulo/TypeORM |

Al adaptar código nuevo: contrastar el nombre exacto de tabla con el `00_schema.sql` del bastión (puede haber columnas extra vs entidades antiguas).

**Deuda conocida en Nest:** algunos módulos aún declaran nombres legacy (`documentosFlota`, `remolque`, `ser_serial_*` en vez de `inv_serial_*`). Al migrar esos módulos, alinear `@Entity(...)` al inventario §2.

### 5.3 Checklist al tocar una entidad

1. ¿La tabla existe en el inventario §2?
2. ¿La entidad declara el mismo nombre y PK?
3. ¿Se propaga `idEmpresa` en create/update/list?
4. ¿Hay equivalentes legacy PascalCase que deban dejar de usarse?

---

## 6. Gaps opcionales (legacy sin destino de negocio prioritario)

No bloquean el ecosistema actual (v2 + Nest + mantenimiento/TireCheck). Migrar solo si el producto lo exige:

| Legacy | Nota |
|--------|------|
| `apilog`, `log_trigger_debug`, `logs`, `vehicles_integracion` | Operativo / debug |
| `alertasMantenimiento*` | Alertas mtto clásicas (LMS ya tiene `alertas_vencimiento` / `notificaciones` en 06) |
| `calificacionesServicioConductor*` | Satisfacción conductor |
| `binomio_logs` | Trazabilidad binomio |
| `detSalidaConsumo`, `encSalidaMatConsumo` | Salida por consumo |
| `Permisos`, `permisosRol`, `permisoUsuario`, `usuarioPermisoBodega` | Authz legacy (hoy Cognito groups + reglas app) |
| `ticketsSoporte*` | Soporte |
| `Notificaciones*` / `notify_*` (legacy new*) | Sustituibles por módulo notificaciones LMS o servicio dedicado |
| `version_formatos` | Catálogo de versiones |
| Vistas `v_satisfaccion_*` | Recrear en reporting si hace falta |

---

## 7. Ecosistema de aplicaciones (contexto)

| Proyecto | Cómo usa datos | Bases relevantes |
|----------|----------------|------------------|
| `qinspecting_v2` | Front Quasar → Nest | 01, 02, 03, 07 (+ auth Cognito) |
| `qinspecting_api_nest` | API canónica multi-DB | Todas las `bd_*` según módulo |
| `qinspecting` / `qinspecting_api` | Legacy Express | Histórico; migrar lecturas a Nest/`bd_*` |
| `qinspecting_mantenimiento` (+ API) | Mtto, TireCheck, inventario | 03, 04, 05, 07 |
| `training` / training API | LMS | `bd_capacitaciones` (modelo LMS) |

---

## 8. Referencias rápidas

| Recurso | Ubicación |
|---------|-----------|
| DDL por base | `0X_bd_*/00_schema.sql` |
| Mapeo columnas origen | `0X_bd_*/MAPEO_ORIGEN.md` |
| Migrate planesQi | `01_bd_tenancy_planes/01_migrate_from_planesQi.sql` |
| Bridge / LMS cap | `06_bd_capacitaciones/03_*.sql`, `04_*.sql` |
| Vistas llantas | `vistas_reporting/` |
| Crear bases | `crear_bases_y_schema.sh` |
| Lista YAML AWS | `../arquitectura_aws/rds-databases-config.yml` |
| Acceso RDS | `../arquitectura_aws/BASTION.md` |
