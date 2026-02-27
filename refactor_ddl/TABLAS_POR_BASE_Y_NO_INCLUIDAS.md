# Tablas por base (refactor DDL) y tablas no incluidas

Verificación: qué tablas están en cada `0X_bd_*/00_schema.sql` y qué tablas del mapeo de migración de datos **no** tienen tabla destino en el refactor.

---

## 1. Tablas que SÍ están en refactor_ddl (por base)

### 01_bd_tenancy_planes
| Tabla |
|-------|
| ten_empresas |
| ten_planes |
| ten_planes_empresas |
| ten_empresa_capacidades |
| ten_empleados_qi |
| ten_mensajes |

### 02_bd_personal
| Tabla |
|-------|
| cat_departamento |
| cat_ciudad |
| cat_area |
| cat_cargos |
| cat_tipo_documento |
| per_personal |

### 08_bd_catalogos_compartidos
| Tabla |
|-------|
| cat_categoria_items |
| cat_categoria_licencias |
| cat_calificacion_em |
| cat_criterio_evaluacion_em |
| cat_criticidad_em |
| cat_cursos_certificados |
| cat_tipo_reserva |
| cat_lote |
| cat_maestra_venc_docs |
| cat_tipo_adjuntos |
| cat_acciones_sistema_usuario |
| cat_cedulas_autoriza_almacen |
| cat_especialidades_em |
| cat_hash_tipo_vehiculo_css |

### 03_bd_inspecciones
| Tabla |
|-------|
| insp_item_inspeccion |
| insp_adjuntos_inspeccion |
| insp_inspeccion_llantas |
| lla_det_inspeccion_llantas |
| lla_inspeccion_llanta_item |
| preop_resumen_preoperacional |
| preop_rta_preoperacional |
| preop_fallas_solucionadas |
| preop_fotos_preoperacional_ultimate |
| lla_correctivas_llantas |
| lla_desmontes_llantas |
| lla_disposicion_final_llantas |
| lla_estados_llantas |
| lla_cat_tipo_desgaste |
| lla_cat_tipo_llantas |
| lla_cat_tipo_rin |
| lla_referencias_llanta |
| lla_historico_procedimientos_llanta |
| lla_registro_kilometraje_llantas |
| lla_reencauchadoras |
| lla_trazabilidad_reencauches |
| fes_formato_especiales_cat |
| fes_formato_especiales_cat_item |
| fes_formato_especiales_enca |
| fes_formato_especiales_enca_det |
| fes_formato_especiales_enca_exp |
| fes_formato_especiales_user_realiza |
| insp_item_has_fv_vehiculo |
| insp_item_has_fv_remolque |

### 04_bd_mantenimientos
| Tabla |
|-------|
| man_bodegas |
| man_categoria_articulos |
| man_marca_articulos |
| man_tipo_articulos |
| man_unidad_medida |
| man_tipo_comprobante |
| man_articulos |
| man_fallas |
| man_fallas_has_item |
| man_causas |
| man_frecuencias |
| man_tareas |
| man_rutinas_tareas |
| man_prog_test |
| man_sistemas |
| man_rutinas |
| man_sistemas_has_rutinas |
| man_encabezado_orden_servicio |
| man_detalle_orden_servicio |
| man_enc_solucion_orden_servicio |
| man_det_solucion_orden_servicio |
| man_add_enc_orden_servicio |
| man_prorroga_mtto_prog |
| man_seri_solu_os |
| prog_programacion_mtto |
| prog_programacion_mtto_tareas |
| prog_programacion_mtto_fallas |
| prog_programacion_mtto_fallas_causas |
| prog_programacion_mtto_fallas_rutinas |
| prog_programacion_mtto_fallas_tareas |
| prog_programacion_mtto_rutinas |
| prog_programacion_mtto_rutinas_causas |
| prog_programacion_mtto_tareas_causas |
| prog_programacion_mtto_asignacion_em_tareas |
| prog_historial_estados_asignacion_em_tareas |
| ejm_ejecutores_mtto_interno |
| ejm_ejecutores_mtto_externo |
| ejm_ejecutores_mtto_especialidades |
| man_modulos_frontend |

### 05_bd_inventario
| Tabla |
|-------|
| inv_serial_instalar |
| inv_almacen_inventario |
| inv_enc_inventarios |
| inv_det_inventarios |
| inv_enc_entrada_inventario |
| inv_det_entrada_inv |
| inv_enc_solicitud_mat |
| inv_det_solicitud_mat |
| inv_enc_dev_inventario |
| inv_det_dev_inventario |
| inv_enc_tranfer_em |
| inv_det_tranfer_em |
| inv_enc_traslado_moviles |
| inv_det_traslado_moviles |
| inv_enc_traslado_reservas |
| inv_det_traslado_reservas |
| inv_enc_salida_proveedor |
| inv_det_salida_proveedor |
| inv_enc_orden_compra |
| inv_inventario_vehiculo |
| inv_has_articulo_almacen |
| prov_proveedor |
| prov_sucursales_prov |
| prov_evaluacion_proveedor_enc |
| prov_det_evaluacion_proveedor |

### 06_bd_capacitaciones
| Tabla |
|-------|
| cap_capacitacion |
| cap_adjuntos_capacitacion |
| cap_evidencias |
| cap_cursos_certificados_capacitacion |
| cap_cursos_certificados_conductor |
| cap_vigencia_capacitacion |
| cap_preguntas_capacitacion |
| cap_preguntas_has_capacitacion |
| cap_respuestas_capacitacion |
| cap_respuestas_usuario |
| cap_profesional_area |
| cap_seccion_capacitacion |
| cap_leccion |
| cap_inscripcion |
| cap_progreso_leccion |
| cap_material_capacitacion |
| enc_encuesta |
| enc_preguntas_encuesta |
| enc_respuestas_encuesta |

### 07_bd_flota_documentos
| Tabla |
|-------|
| veh_cat_tipos_vehiculos |
| veh_cat_marca_vehiculo |
| veh_vehiculo |
| veh_cabezote_vehiculo |
| veh_remolque |
| veh_hash_binomios |
| doc_documentos_conductor |
| doc_documentos_flota |
| doc_firmas_digitales |

---

## 2. Tablas del data-migration.config que NO tienen DDL en refactor

**Actualización:** Se creó `08_bd_catalogos_compartidos` con las 14 tablas cat_*; proveedores (prov_*) en **05_bd_inventario**; encuestas (enc_*) en **06_bd_capacitaciones**. Las siguientes siguen sin DDL:

| Origen (legacy) | Destino en config | Dónde debería quedar (según plan) |
|-----------------|-------------------|-----------------------------------|
| apilog | log_apilog | Logs; base de logs o no migrada. |
| llaveItemTpv | cat_llave_item_tpv | Relación ítem inspección / tipo vehículo. **bd_inspecciones** (03) si se añade. |
| itemModuloFrontend | cat_item_modulo_frontend | Items de menú frontend. Existe **man_modulos_frontend** (04); no existe cat_item_modulo_frontend. |
| emProyectos | ejm_em_proyectos | **No existe** en refactor. bd_mantenimientos o módulo EM. |
| emInventario | ejm_em_inventario | **No existe** en refactor. Idem. |

*Nota: ejecutoresMantenimiento → ejm_ejecutores_mtto_interno está en 04_bd_mantenimientos. Cat_* en 08, prov_* en 05, enc_* en 06.*

---

## 3. Resumen: por qué no están (pendientes)

| Motivo | Tablas afectadas |
|--------|------------------|
| **Módulo EM (proyectos-inventario)** | ejm_em_proyectos, ejm_em_inventario. |
| **Maestras frontend / inspección** | cat_llave_item_tpv; itemModuloFrontend (existe man_modulos_frontend, no cat_item_modulo). |
| **Logs** | log_apilog. |

**Ya incluidas:** bd_catalogos_compartidos (08) con 14 cat_*; proveedores en bd_inventario (05); encuestas en bd_capacitaciones (06).

---

## 4. Recomendaciones

**Actualización:** Catálogos (08), proveedores (05) y encuestas (06) ya tienen DDL. Pendientes:

1. **Catálogos:** Crear `08_bd_catalogos` (o `01_catalogos.sql` dentro de una base compartida) con las tablas cat_* que falten (categoria_items, tipo_reserva, lote, tipo_adjuntos, etc.) si se quieren migrar; o documentar que quedan en legacy hasta definir bd_catalogos_compartidos.
2. **Proveedores:** Definir si van en bd_inventario, en una nueva `bd_proveedores` o se dejan fuera del refactor inicial; luego añadir DDL y mapeo.
3. **Encuestas:** Definir base (ej. bd_inspecciones o bd_capacitaciones) y añadir DDL enc_* si se migran.
4. **emProyectos / emInventario:** Revisar si se consolidan en bd_mantenimientos con tablas ejm_* o en una base de “proyectos EM”; añadir DDL donde corresponda.
5. **data-migration.config:** Para tablas que **no** tengan destino en refactor, o bien se excluyen del `migrationOrder` y del mapeo, o se crea el DDL correspondiente y se añade a la migración inicial.

Este documento se puede actualizar cuando se creen nuevas carpetas `0X_bd_*` o se añadan tablas a los DDL existentes.

---

## 5. Vistas de reporting (cross-base)

Vistas que unen tablas de varias bases; DDL en **refactor_ddl/vistas_reporting/**:

| Vista | Descripción | Depende de |
|-------|-------------|-------------|
| **lla_vista_control_llantas** / **vistaControlLlantas** | Control llantas (km, vida útil, %) | inv_serial_instalar (05), man_articulos, man_marca_articulos (04), lla_registro_kilometraje_llantas (03) |

Uso: qinspecting, qinspecting-mantenimiento. Ver vistas_reporting/README.md para esquema unificado vs bases separadas.
