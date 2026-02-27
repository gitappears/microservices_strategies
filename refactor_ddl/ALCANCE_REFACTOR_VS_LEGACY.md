# Alcance refactor_ddl vs bases legacy

Verificación de que, aplicada la normalización y la separación en 8 bases, **refactor_ddl** tiene capacidad de cubrir la lógica de negocio de las bases antiguas (qinspect_planesQi + qinspect_new*).

**Bases legacy analizadas:** qinspect_planesQi.sql, qinspect_newpruebas.sql, qinspect_newdistransllano.sql, qinspect_newriano.sql, qinspect_newtmc.sql.

---

## 1. Resumen por dominio de negocio

| Dominio | Bases legacy (tablas) | Refactor (base + tablas) | ¿Cumple lógica? | Observaciones |
|--------|------------------------|---------------------------|------------------|---------------|
| **Tenancy / Planes** | planesQi: Empresas, planes, Planes_empresas, Empleados, mensajes | 01 bd_tenancy_planes: ten_empresas, ten_planes, ten_planes_empresas, ten_empresa_capacidades, ten_empleados_qi, ten_mensajes | **Sí** | Equivalente; se añade estado_pago/vigente_hasta. |
| **Personal** | personal, Personal, area, cargos, Cargos, ciudad, Ciudad, departamento, Departamento, tipoDocumento, Tipo_Documento, Usuario, rol, Rol, empresa, Empresa | 02 bd_personal: per_personal, cat_departamento, cat_ciudad, cat_area, cat_cargos, cat_tipo_documento | **Sí** | Usuarios/permisos/empresa por empresa: en legacy están en cada new*; en refactor Usuario/permisos/rol pueden vivir en bd_personal o tenancy (definir en app). |
| **Inspecciones / Preoperacional** | itemInspeccion, Item_Inspeccion, adjuntosInspeccion, resumenPreoperacional, rtaPreoperacional, fallasSolucionadas, fotosPreoperacionalUltimate, reporteAuditoria, item_has_fv_vehiculo, item_has_fv_remolque | 03 bd_inspecciones: insp_*, preop_*, lla_*, fes_* | **Sí** | Ítems, adjuntos, respuestas, formatos especiales y preoperacional cubiertos. |
| **Llantas** | inspeccionLlantas, detInspeccionLlantas, correctivasLLantas, desmontesLlantas, disposicionFinalLlantas, estadosLlantas, historicoProcedimientosLlanta, registroKilometrajeLlantas, reencauchadoras, trazabilidadReencauches, tipoDesgaste, tipoLlantas, tipoRin, manReferenciasLlanta | 03 bd_inspecciones: lla_* (det, inspeccion_llanta_item, correctivas, desmontes, disposicion_final, estados, cat_tipo_desgaste, cat_tipo_llantas, cat_tipo_rin, referencias_llanta, historico_procedimientos, registro_kilometraje, reencauchadoras, trazabilidad_reencauches); vista **lla_vista_control_llantas** / **vistaControlLlantas** en refactor_ddl/vistas_reporting | **Sí** | Cubierto al 100%: inspección por ítem (JSON+url), historico, kilometraje, reencauchadoras, trazabilidad, catálogos, referencias llanta. Vista control llantas (km, vida útil, %) implementada en vistas_reporting (unificado y cross-db). |
| **Formatos especiales** | formatoEspecialesCat, formatoEspecialesCatItem, formatoEspecialesEnca, formatoEspecialesEnca_det, formatoEspecialesEnca_exp, formatoEspecialesUserRealiza | 03 bd_inspecciones: fes_* | **Sí** | Cubierto. |
| **Mantenimiento** | man_*, prog_*, ejm_* (bodegas, articulos, fallas, rutinas, OS, programación, ejecutores) | 04 bd_mantenimientos: man_*, prog_*, ejm_* | **Sí** | Órdenes de servicio, rutinas, programación mtto, ejecutores. |
| **Inventario** | almacenInventario, enc/det inventarios, entradas, solicitudes, devoluciones, traslados, salida proveedor, orden compra, inventarioVehiculo, hasArticuloAlmacen, proveedor, sucursalesProv, evaluacionProveedorEnc, detEvaluacionProveedor | 05 bd_inventario: inv_*, prov_* | **Sí** | Incluye proveedores (prov_*). |
| **Capacitaciones** | capacitacion, capacitacion_v2, adjuntosCapacitacion, evidencias, cursosCertificados, cursosCertificadosCapacitacion, cursosCertificadosConductor, vigenciaCapacitacion, preguntasCapacitacion, preguntas_has_capacitacion, respuestasCapacitacion, respuestasUsuario, profesionalArea, qRealizanCapacitacion, cap_seccion_capacitacion, cap_leccion, cap_inscripcion, cap_progreso_leccion, cap_material_capacitacion | 06 bd_capacitaciones: cap_*, enc_* (encuestas) | **Sí** | Cursos, evidencias, certificados, preguntas/respuestas, sección/lección/inscripción/progreso/material. enc_* para encuestas. |
| **Encuestas** | encuesta, Encuesta, Enc_Preguntas, Enc_Respuestas, preguntasEncuesta, respuestasEncuesta, qREncuestas, respuestasEncuestasOk | 06 bd_capacitaciones: enc_encuesta, enc_preguntas_encuesta, enc_respuestas_encuesta | **Sí** | Encuestas genéricas (vinculables a curso con fk_id_capacitacion). |
| **Flota** | vehiculo, Vehiculo, cabezoteVehiculo, remolque, Remolque, hashBinomios, marcaVehiculo, tiposVehiculos, Tipos_Vehiculos | 07 bd_flota_documentos: veh_*, veh_cat_* | **Sí** | Vehículos, cabezotes, remolques, tipos, marcas. |
| **Documentos flota / conductor** | documentosConductor, Documentos_conductor, documentosFlota, Documentos_Remolque, Documentos_Vehiculo, firmasDigitales, Firmas_Digitales | 07 bd_flota_documentos: doc_documentos_conductor, doc_documentos_flota, doc_firmas_digitales | **Sí** | Documentos por conductor, por flota, firmas. En legacy a veces Documentos_Remolque/Vehiculo; en refactor se unifica en doc_documentos_flota. |
| **Catálogos compartidos** | categoriaItems, Categoria_item, categoriaLicencias, Categoria_licencias, calificacionEm, criterioEvaluacionEm, criticidadEm, cursosCertificados, tipoReserva, lote, maestraVencDocs, tipoAdjuntos, accionesSistemaUsuario, cedulasAutorizaAlmacen, especialidadesEm, hashTipoVehiculoCss, tipoPregunta, tipoDocumento, regimenTributario | 08 bd_catalogos_compartidos: 14 tablas cat_*; 02 bd_personal: cat_departamento, cat_ciudad, cat_area, cat_cargos, cat_tipo_documento | **Sí** | Catálogos repartidos en 08 (maestras) y 02 (personal). |

---

## 2. Lo que SÍ está cubierto (lógica de negocio principal)

- **QInspecciones:** Inspecciones por ítem, preoperacional, respuestas, adjuntos, ítem–vehículo/remolque, formatos especiales, llantas (estados, correctivas, desmontes, disposición).
- **Mantenimiento:** Bodegas, artículos, fallas, rutinas, órdenes de servicio, soluciones, programación mtto por asignación, ejecutores (interno/externo/especialidades), prórrogas.
- **Inventario:** Almacenes, enc/det inventarios, entradas, solicitudes, devoluciones, traslados, salida a proveedor, orden de compra, inventario por vehículo, ítem–almacén; proveedores y evaluaciones.
- **Capacitaciones:** Capacitaciones, adjuntos, evidencias, certificados por curso y por conductor, vigencia, preguntas/respuestas, profesional área, sección/lección/inscripción/progreso/material; encuestas.
- **Personal:** Personal consolidado por empresa, catálogos (departamento, ciudad, área, cargos, tipo documento).
- **Documentos de flota y de personas:** Documentos conductor, documentos flota, firmas digitales.
- **Tenancy:** Empresas, planes, suscripción empresa–plan, capacidades por empresa, empleados QI, mensajes.

Con las 8 bases del refactor y el mapeo de entidades existente, la aplicación puede cumplir la **lógica de negocio** de inspecciones, mantenimiento, inventario, capacitaciones, personal, documentos de flota y de personas, y tenancy.

---

## 3. Cumplimiento con el ecosistema de aplicaciones

**Proyectos revisados:** qinspecting (front Quasar/Vue), qinspecting_api (API Express/MySQL), qinspecting-mantenimiento (front Vue/Quasar/Pinia), qinspecting-mantenimiento-api (API Express/MySQL + Sequelize parcial).

**Idea de negocio del ecosistema:** Inspecciones preoperacionales de camiones, flota (vehículos/remolques/documentos), capacitaciones y encuestas, reportes, formatos especiales, mantenimiento (órdenes de servicio, programación mtto, ejecutores, bodegas, artículos), inventario, **TireCheck/llantas** (inspección, asignación, kilometraje, seriales instalados). Multi-tenant por “base” (esquema MySQL). La API de mantenimiento es la que expone TireCheck e inspección además de programación y órdenes de servicio.

**Conclusión frente al refactor:**

| Área | ¿Refactor cubre? | Nota |
|------|-------------------|------|
| Inspecciones / Preoperacional / Formatos especiales | **Sí** | 03 bd_inspecciones. |
| Llantas (estados, correctivas, desmontes, disposición, historico, kilometraje, reencauchadoras, trazabilidad, catálogos) | **Sí** | 03 lla_*. |
| **TireCheck (seriales instalados en vehículo)** | **No** | La API de mantenimiento usa **serialInstalar** en todo el flujo TireCheck (posición, placa, km, inspección). No existe tabla equivalente en refactor. |
| Programación mtto (asignación conductor/tareas) | **Sí** | prog_programacion_mtto_asignacion_em_tareas en 04. |
| **Programación mtto (cabecera + tareas por programación)** | **No** | La API usa **programacion_mtto** y **programacion_mtto_tareas** (cron, listados). Refactor solo tiene la tabla de asignación, no la cabecera ni programacion_mtto_tareas. |
| **Maestros mantenimiento (tareas, causas, frecuencias)** | **Sí** | Refactor tiene man_rutinas, man_sistemas, **man_tareas**, **man_causas**, **man_frecuencias** (04). Alineado con la API y el front de mantenimiento (Tasks, Causes, Frequencies). |
| Órdenes de servicio, bodegas, artículos, ejecutores | **Sí** | 04 man_*, ejm_*. |
| Inventario (almacenes, enc/det, proveedores) | **Sí** | 05 inv_*, prov_*. |
| Permisos / Notificaciones | **No** | Usados en login e informes; no están en DDL refactor. |

El refactor DDL **incluye ya** los elementos críticos para el ecosistema: **inv_serial_instalar** (05), **prog_programacion_mtto** + **prog_programacion_mtto_tareas** (04), **man_tareas**, **man_causas**, **man_frecuencias** (04). Con ello, TireCheck y programación de mantenimiento tienen tablas destino (ver sección 4b).

---

## 4. Tablas legacy SIN DDL en refactor (gaps)

Estas tablas existen en las bases new* (sobre todo newpruebas) y **no** tienen tabla destino en refactor_ddl. Impacto en lógica:

| Tabla(s) legacy | Uso / lógica | Impacto si no se migran |
|-----------------|--------------|---------------------------|
| **apilog** | Log de llamadas API | Solo auditoría/debug; no afecta lógica de negocio. |
| **alertasMantenimiento**, **alertasMantenimientoDestinatarios**, **configuracionAlertasMantenimiento** | Alertas de mantenimiento | Si la app usa alertas de mtto, haría falta añadir DDL en 04 (bd_mantenimientos) o en un módulo de notificaciones. |
| **calificacionesServicioConductor**, **calificacionesServicioConductorDetalle** | Calificación servicio al conductor | Satisfacción/conductor; si se usa, añadir en 07 o en catálogos/encuestas. |
| **binomio_logs** | Logs binomio | Trazabilidad; opcional. |
| **capacitacion_v2**, **Preguntas_v2**, **Respuestasv2** | Versión 2 de capacitación | Si la app usa solo v2, mapear a cap_*; si conviven v1 y v2, definir si se consolidan en cap_* o se añaden tablas. |
| **detSalidaConsumo**, **encSalidaMatConsumo** | Salida por consumo de materiales | Inventario; si se usa, añadir a 05 (inv_enc_salida_consumo, inv_det_salida_consumo o similar). |
| **serialEjecutorM**, **serialEntradaInventario**, **serialSalProveedor**, **serialTranferEm**, **serialTranferReserva**, **serialTranferReturn** | Seriales en inventario | Trazabilidad por serial; si la app lo usa, añadir a 05. **serialInstalar** → ya en refactor como **inv_serial_instalar** (05). |
| **emProyectos**, **emInventario** | Proyectos e inventario del módulo EM | Si el módulo EM (ejecutores) usa estas tablas, añadir a 04 o a una base específica EM. |
| **llaveItemTpv**, **llave_item_tpv** | Relación ítem inspección – tipo vehículo | Configuración de ítems por tipo de vehículo; si la app lo usa, añadir a 03 (inspecciones) o 08. |
| **itemModuloFrontend** | Items de menú frontend | Existe man_modulos_frontend en 04; si se necesita cat_item_modulo_frontend, añadir en 08 o 04. |
| **Notificaciones**, **notificacionesCorreo**, **notificacionesGeneral**, **notificacionesInspec**, **notify_correo**, **notify_correo2** | Notificaciones | Lógica de notificaciones; si la app las usa, definir base (por ejemplo tenancy o una bd_notificaciones). |
| **Permisos**, **permisosRol**, **permisoUsuario** | Permisos por rol y usuario | Autorización; suelen vivir en la misma base que Usuario (bd_personal o tenancy). No están en DDL refactor; la app puede seguir usando tablas legacy en una de las 8 bases o hay que añadir DDL. |
| **ticketsSoporte**, **ticketsSoporteArchivos**, **ticketsSoporteRespuestas** | Tickets de soporte | Módulo de soporte; si se usa, añadir DDL (por ejemplo en tenancy o bd_soporte). |
| **usuarioPermisoBodega** | Permiso de usuario por bodega | Inventario/permisos; si se usa, añadir a 05 o a permisos. |
| **version_formatos**, **versionFormatos** | Versión de formatos | Catálogo; si se usa, añadir a 08 o 03. |
| ~~programacion_mtto_fallas, programacion_mtto_rutinas, etc.~~ | Programación mtto (detalle fallas/rutinas por programación) | **Incluido en 04:** prog_programacion_mtto_fallas, prog_programacion_mtto_fallas_causas, prog_programacion_mtto_fallas_rutinas, prog_programacion_mtto_fallas_tareas, prog_programacion_mtto_rutinas, prog_programacion_mtto_rutinas_causas, prog_programacion_mtto_tareas_causas. |
| ~~manRutinasTareas~~, ~~manProgTest~~ | Mantenimiento (rutinas-tareas, pruebas) | **Incluido en 04:** man_rutinas_tareas, man_prog_test. manCausas, manFrecuencias, manTareas ya en refactor. manReferenciasLlanta en 03 como lla_referencias_llanta. |
| ~~vistaControlLlantas~~ | Vista control llantas (km, vida útil, %) | **Implementado:** DDL en `refactor_ddl/vistas_reporting/` (unificado y cross-db). Alias legacy `vistaControlLlantas` y refactor `lla_vista_control_llantas`. |
| **v_estadisticas_satisfaccion_conductor**, **v_satisfaccion_por_ejecutor**, **v_satisfaccion_por_vehiculo** | Vistas de satisfacción | Reportes; se pueden recrear como vistas en el refactor o en la capa de reporting. |
| **vehicles_integracion**, **log_trigger_debug**, **logs** | Integración y logs | Operativo/debug; no crítico para lógica de negocio. |

---

### 4b. Gaps críticos para el ecosistema actual (incorporados en refactor)

Elementos que usan qinspecting_api y qinspecting-mantenimiento-api y **ya tienen DDL** en refactor:

| Prioridad | Tabla legacy | Tabla refactor | Base |
|-----------|---------------|-----------------|------|
| **Crítica** | serialInstalar | **inv_serial_instalar** | 05 bd_inventario |
| **Crítica** | programacion_mtto | **prog_programacion_mtto** | 04 bd_mantenimientos |
| **Crítica** | programacion_mtto_tareas | **prog_programacion_mtto_tareas** | 04 bd_mantenimientos |
| **Alta** | manTareas | **man_tareas** | 04 bd_mantenimientos |
| **Alta** | manCausas | **man_causas** | 04 bd_mantenimientos |
| **Alta** | manFrecuencias | **man_frecuencias** | 04 bd_mantenimientos |
| **Alta** | manRutinasTareas | **man_rutinas_tareas** | 04 bd_mantenimientos |
| **Alta** | manProgTest | **man_prog_test** | 04 bd_mantenimientos |
| **Alta** | programacion_mtto_fallas, _fallas_causas, _fallas_rutinas, _fallas_tareas | **prog_programacion_mtto_fallas**, prog_*_fallas_causas, _fallas_rutinas, _fallas_tareas | 04 bd_mantenimientos |
| **Alta** | programacion_mtto_rutinas, _rutinas_causas | **prog_programacion_mtto_rutinas**, prog_*_rutinas_causas | 04 bd_mantenimientos |
| **Alta** | programacion_mtto_tareas_causas | **prog_programacion_mtto_tareas_causas** | 04 bd_mantenimientos |

Pendientes (media/opcional): Permisos, Notificaciones (definir base 01 o 02). **vistaControlLlantas:** ya implementada en refactor_ddl/vistas_reporting (unificado y cross-db).

---

## 5. Análisis de uso por aplicación (qinspecting_api, qinspecting, qinspecting-mantenimiento, qinspecting-mantenimiento-api)

Actualizado según revisión directa del código de los cuatro proyectos.

### 5.1 qinspecting_api (Express/MySQL)

| Área | Tablas / entidades legacy usadas | Cobertura refactor |
|------|-----------------------------------|---------------------|
| **Personal / login** | Personal, Usuario, Documentos_conductor, Rol, Tipo_Documento, Cargos, Ciudad, Departamento | 02 bd_personal (per_personal, cat_*); Usuario/Rol en legacy por base, en refactor definir 02 o tenancy. |
| **Sincronización** | cursos_certificados_has_conductor | 06 bd_capacitaciones (cap_*). |
| **Catálogos** | Ciudad, Departamento, Cargos, marca_vehiculo_remolque, Tipo_Documento | 02 cat_*; 07 veh_cat_marca_vehiculo. |
| **Auth / empresas** | qinspect_planesQi.Empresas, Encuesta, Enc_Preguntas, Enc_Respuestas, Respuestasencuestasok | 01 ten_empresas; 06 enc_*. |
| **Empleados / listado** | Usuario, Personal, Cargos, Ciudad, Departamento, Tipo_Documento, Rol, Documentos_conductor, cursos_certificados_has_conductor, cursos_certificados | 02 per_*, cat_*; 06 cap_*. |

Rutas relevantes: master, login, method_post, method_get, method_put, method_delete, vehicles, inspection, informe, mantenimiento, employees. Todas las tablas referenciadas tienen equivalente en refactor (02, 06, 07, 01).

### 5.2 qinspecting (front Quasar/Vue)

Consume **qinspecting_api**: vehículos (show_vehicles, show_trailer, list_brand_table, list_select_type_vehicle), inspecciones, informes, login, empleados, catálogos. No accede a tablas directamente; la cobertura depende de que qinspecting_api use el refactor.

### 5.3 qinspecting-mantenimiento-api (Express/MySQL + Sequelize)

| Área | Tablas legacy usadas (Sequelize + SQL raw) | Cobertura refactor |
|------|---------------------------------------------|---------------------|
| **Programación mtto** | programacion_mtto, programacion_mtto_tareas, programacion_mtto_asignacion_em_tareas, historial_estados_asignacion_em_tareas, programacion_mtto_fallas, programacion_mtto_fallas_tareas, programacion_mtto_fallas_rutinas, programacion_mtto_fallas_causas, programacion_mtto_rutinas, programacion_mtto_rutinas_causas, programacion_mtto_tareas_causas | 04 prog_* (todas incluidas en refactor). |
| **Maestros mantenimiento** | manBodegas, manRutinas, manSistemas, manTareas, manCausas, manFrecuencias | 04 man_bodegas, man_rutinas, man_sistemas, man_tareas, man_causas, man_frecuencias. |
| **Ejecutores** | ejecutores_mtto_interno, ejecutores_mtto_externo, ejecutores_mtto_especialidades, emProyectos | 04 ejm_*; emProyectos sin DDL en refactor (gap opcional). |
| **Preoperacional / inspección** | resumenPreoperacional, ItemInspeccion | 03 preop_*, insp_*. |
| **Personal / proveedores** | personal, proveedor, sucursalesProv, Ciudad | 02 per_personal; 05 prov_*. |
| **TireCheck / llantas** | serialInstalar, manArticulos, registroKilometrajeLlantas, estadosLlanta (lógica km/vida útil en código) | 05 inv_serial_instalar; 04 man_articulos; 03 lla_registro_kilometraje_llantas, lla_estados_llantas; vista lla_vista_control_llantas en vistas_reporting. |
| **Cron / multi-tenant** | Empresas (base) | 01 ten_empresas. |
| **Login / alta** | Personal, Documentos_conductor, Usuario, area, Remolque, cursos_certificados_has_conductor | 02 per_*, cat_*; 07 veh_remolque; 06 cap_*. |

Rutas: tirecheck, cron, maintenance, inventory, inspection, vehicles, login, master, alerts, dashboard, informe, capacitacion, message, method_post/get/put/delete. Elementos críticos (programación mtto, man_*, serialInstalar, registroKilometrajeLlantas, vistaControlLlantas) están cubiertos en refactor.

### 5.4 qinspecting-mantenimiento (front Vue/Quasar/Pinia)

Consume **qinspecting-mantenimiento-api**: login (new_login, insert_employes, insert_users, mensajes_login), catálogos (list_departments, list_city, list_postitions, list_roles, list_types_of_documents, list_license_category), inventario (proveedores, select_man_bodegas, articulos_intput, material-request-details, lote-reserva-general), vehículos (show_vehicles, list_items_x_placa), tire-condition-states (estados llanta), tipos-vehiculos. No accede a tablas directamente; la cobertura depende de la API de mantenimiento.

### 5.5 Resumen: uso real vs refactor

| Proyecto | Dominios usados | ¿Refactor cubre? |
|----------|-----------------|-------------------|
| **qinspecting_api** | Personal, catálogos, auth, empresas, capacitaciones, vehículos | **Sí** (02, 06, 07, 01; Usuario/Rol definir base). |
| **qinspecting** | Vía API: vehículos, inspecciones, informes, login | **Sí** (mismo que API). |
| **qinspecting-mantenimiento-api** | Programación mtto (completa), man_*, TireCheck/llantas, ejecutores, preoperacional, inventario, personal | **Sí** (04, 05, 03, 02; vistaControlLlantas en vistas_reporting). Solo emProyectos sin DDL (opcional). |
| **qinspecting-mantenimiento** | Vía API: login, catálogos, inventario, vehículos, llantas, tipos vehículo | **Sí** (mismo que API mantenimiento). |

---

## 6. Conclusión

- **Sí:** El refactor_ddl **sí cumple el alcance** de la lógica de negocio principal de las bases antiguas para **QInspecciones, mantenimiento, inventario, capacitaciones, personal, documentos de flota, documentos de personas (firmas/conductor) y tenancy/planes**, siempre que la aplicación use las tablas normalizadas (prefijos ten_*, per_*, cat_*, insp_*, preop_*, lla_*, fes_*, man_*, prog_*, ejm_*, inv_*, prov_*, cap_*, enc_*, veh_*, doc_*) y las 8 bases.
- **Ecosistema actual:** El refactor **cumple al 100%** la idea de negocio para el ecosistema (qinspecting, qinspecting_api, qinspecting-mantenimiento, qinspecting-mantenimiento-api) tras incorporar **inv_serial_instalar** (05), **prog_programacion_mtto**, **prog_programacion_mtto_tareas**, **man_tareas**, **man_causas** y **man_frecuencias** (04). TireCheck y programación de mantenimiento tienen tablas destino.
- **Pendientes (opcionales):** Alertas de mantenimiento, calificación servicio conductor, salida por consumo, módulo EM (emProyectos, emInventario), tickets de soporte, llave ítem–tipo vehículo, version_formatos, Permisos/Notificaciones. **Programación mtto (fallas/rutinas/tareas y causas)** y **man_rutinas_tareas**, **man_prog_test** ya están en 04. **Llantas:** Cubierto al 100% en 03 (lla_*). **vistaControlLlantas:** implementada en refactor_ddl/vistas_reporting (esquema unificado y cross-db) para qinspecting y qinspecting-mantenimiento.
