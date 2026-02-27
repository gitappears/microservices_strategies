# Mapeo entidades qinspecting_api_nest → bases normalizadas

Este documento indica qué entidades del API Nest fueron adaptadas a la nueva estructura de bases (ref. `PLAN_TRABAJO_MICROSERVICIOS_QINSPECTING.md` y DDL en cada carpeta `0X_bd_*`).

## Convenciones aplicadas

- **Tabla:** nombre en BD snake_case con prefijo de dominio (ten_, per_, cat_, insp_, preop_, man_, inv_, cap_, veh_, doc_).
- **Columnas:** snake_case en BD; en entidades TypeORM se usa `name: 'snake_case'` y propiedad en camelCase.
- **id_empresa:** añadido en todas las tablas transaccionales (tenant). Sin FK a `ten_empresas` entre bases.
- **PK compuestas:** donde el DDL lo define (ej. `per_personal`: numero_documento + id_empresa; `veh_vehiculo`: placa + id_empresa).

## Verificación: tablas por base y no incluidas en refactor

Para ver qué tablas están en cada base (01–07) y qué tablas del mapeo de migración de datos **no** tienen DDL en el refactor, ver: **[TABLAS_POR_BASE_Y_NO_INCLUIDAS.md](./TABLAS_POR_BASE_Y_NO_INCLUIDAS.md)**. Ahí se listan las tablas destino que faltan (cat_*, prov_*, enc_*, ejm_em_*, etc.) y dónde deberían quedar según el plan.

## Entidades ya adaptadas

| Base | Tabla DDL | Entidad Nest (archivo) |
|------|-----------|-------------------------|
| bd_tenancy_planes | ten_empresas | Empresa (empresa.entity.ts) |
| bd_personal | cat_departamento | Departamento |
| bd_personal | cat_ciudad | Ciudad |
| bd_personal | cat_area | Area |
| bd_personal | cat_cargos | Cargos |
| bd_personal | cat_tipo_documento | TipoDocumento |
| bd_personal | per_personal | Personal (PK: numero_documento, id_empresa) |
| bd_inspecciones | insp_item_inspeccion | ItemInspeccion (PK: id_item_inspeccion, id_empresa) |
| bd_inspecciones | preop_resumen_preoperacional | ResumenPreoperacional |
| bd_inspecciones | preop_rta_preoperacional | RtaPreoperacional |
| bd_inspecciones | preop_fallas_solucionadas | FallasSolucionadas |
| bd_inspecciones | preop_fotos_preoperacional_ultimate | FotosPreoperacionalUltimate |
| bd_flota_documentos | veh_vehiculo | Vehiculo (PK: placa, id_empresa) |
| bd_flota_documentos | veh_remolque | Remolque (PK: id_remolque, id_empresa) |
| bd_flota_documentos | veh_cabezote_vehiculo | CabezoteVehiculo |
| bd_flota_documentos | veh_hash_binomios | HashBinomios |
| bd_flota_documentos | doc_documentos_conductor | DocumentosConductor (PK: id_doc_conductor, id_empresa) |
| bd_flota_documentos | doc_documentos_flota | DocumentosFlota |
| bd_flota_documentos | doc_firmas_digitales | FirmasDigitales |
| bd_inspecciones | insp_adjuntos_inspeccion | AdjuntosInspeccion |
| bd_inspecciones | insp_inspeccion_llantas | InspeccionLlantas |
| bd_inspecciones | lla_det_inspeccion_llantas | DetInspeccionLlantas |
| bd_inspecciones | lla_correctivas_llantas | CorrectivasLlantas |
| bd_inspecciones | lla_desmontes_llantas | DesmontesLlantas |
| bd_inspecciones | lla_disposicion_final_llantas | DisposicionFinalLlantas |
| bd_inspecciones | lla_estados_llantas | EstadosLlantas |
| bd_mantenimientos | man_bodegas | ManBodegas |
| bd_mantenimientos | man_categoria_articulos | ManCategoriaArticulos |
| bd_mantenimientos | man_marca_articulos | ManMarcaArticulos |
| bd_mantenimientos | man_tipo_articulos | ManTipoArticulos |
| bd_mantenimientos | man_unidad_medida | ManUnidadMedida |
| bd_mantenimientos | man_tipo_comprobante | ManTipoComprobante |
| bd_mantenimientos | man_articulos | ManArticulos |
| bd_mantenimientos | man_fallas | ManFallas |
| bd_mantenimientos | man_fallas_has_item | ManFallasHasItem |
| bd_mantenimientos | man_sistemas | ManSistemas |
| bd_mantenimientos | man_rutinas | ManRutinas |
| bd_mantenimientos | man_sistemas_has_rutinas | ManSistemasHhasRutinas |
| bd_mantenimientos | man_encabezado_orden_servicio | ManEncabezadoOrdenServicio |
| bd_mantenimientos | man_detalle_orden_servicio | ManDetalleOrdenServicio |
| bd_mantenimientos | man_enc_solucion_orden_servicio | ManEncSolucionOrdenServicio |
| bd_mantenimientos | man_det_solucion_orden_servicio | ManDetSolucionOrdenServicio |
| bd_mantenimientos | man_add_enc_orden_servicio | ManAddEncOrdenServicio |
| bd_mantenimientos | man_prorroga_mtto_prog | ManProrrogaMttoProg |
| bd_mantenimientos | man_seri_solu_os | ManSeriSoluOS |
| bd_mantenimientos | man_modulos_frontend | ManModulosFrontend |
| bd_mantenimientos | prog_programacion_mtto_asignacion_em_tareas | ProgramacionMttoAsignacionEmTareas |
| bd_mantenimientos | prog_historial_estados_asignacion_em_tareas | HistorialEstadosAsignacionEmTareas |
| bd_mantenimientos | ejm_ejecutores_mtto_interno | EjecutoresMttoInterno |
| bd_mantenimientos | ejm_ejecutores_mtto_externo | EjecutoresMttoExterno |
| bd_mantenimientos | ejm_ejecutores_mtto_especialidades | EjecutoresMttoEspecialidades |
| bd_inspecciones | fes_formato_especiales_cat | FormatoEspecialesCat |
| bd_inspecciones | fes_formato_especiales_cat_item | FormatoEspecialesCatItem |
| bd_inspecciones | fes_formato_especiales_enca | FormatoEspecialesEnca |
| bd_inspecciones | fes_formato_especiales_enca_det | FormatoEspecialesEncaDet |
| bd_inspecciones | fes_formato_especiales_enca_exp | FormatoEspecialesEncaExp |
| bd_inspecciones | fes_formato_especiales_user_realiza | FormatoEspecialesUserRealiza |
| bd_inspecciones | insp_item_has_fv_vehiculo | ItemHasFvVehiculo |
| bd_inspecciones | insp_item_has_fv_remolque | ItemHasFvRemolque |
| bd_inventario | inv_almacen_inventario | AlmacenInventario |
| bd_inventario | inv_enc_inventarios | EncInventarios |
| bd_inventario | inv_det_inventarios | DetInventarios |
| bd_inventario | inv_enc_entrada_inventario | EncEntradaInventario |
| bd_inventario | inv_det_entrada_inv | DetEntradaInv |
| bd_inventario | inv_enc_solicitud_mat | EncSolicitudMat |
| bd_inventario | inv_det_solicitud_mat | DetSolicitudMat |
| bd_inventario | inv_enc_dev_inventario | EncDevInventario |
| bd_inventario | inv_det_dev_inventario | DetDevInventario |
| bd_inventario | inv_enc_tranfer_em | EncTranferEm |
| bd_inventario | inv_det_tranfer_em | DetTranferEm |
| bd_inventario | inv_enc_traslado_moviles | EncTrasladoMoviles |
| bd_inventario | inv_det_traslado_moviles | DetTrasladoMoviles |
| bd_inventario | inv_enc_traslado_reservas | EncTrasladoReservas |
| bd_inventario | inv_det_traslado_reservas | DetTrasladoReservas |
| bd_inventario | inv_enc_salida_proveedor | EncSalidaProveedor |
| bd_inventario | inv_det_salida_proveedor | DetSalidaProveedor |
| bd_inventario | inv_enc_orden_compra | EncOrdenCompra |
| bd_inventario | inv_inventario_vehiculo | InventarioVehiculo |
| bd_inventario | inv_has_articulo_almacen | HasArticuloAlmacen |
| bd_capacitaciones | cap_capacitacion | Capacitacion |
| bd_capacitaciones | cap_adjuntos_capacitacion | AdjuntosCapacitacion |
| bd_capacitaciones | cap_evidencias | Evidencias |
| bd_capacitaciones | cap_cursos_certificados_capacitacion | CursosCertificadosCapacitacion |
| bd_capacitaciones | cap_cursos_certificados_conductor | CursosCertificadosConductor |
| bd_capacitaciones | cap_vigencia_capacitacion | VigenciaCapacitacion |
| bd_capacitaciones | cap_preguntas_capacitacion | PreguntasCapacitacion |
| bd_capacitaciones | cap_preguntas_has_capacitacion | PreguntasHasCapacitacion |
| bd_capacitaciones | cap_respuestas_capacitacion | RespuestasCapacitacion |
| bd_capacitaciones | cap_respuestas_usuario | RespuestasUsuario |
| bd_capacitaciones | cap_profesional_area | ProfesionalArea |

## Entidades pendientes de adaptar (por dominio)

Seguir el mismo patrón: `@Entity('nombre_tabla_ddl')`, columnas con `name: 'snake_case'` (o camelCase si el DDL 06 lo mantiene), añadir `id_empresa` donde indique el DDL.

### bd_inspecciones (03) – resto
- preop_reporte_auditoria (no listado en MAPEO_ORIGEN; añadir id_empresa si se incluye)
- lla_historico_procedimientos_llanta (no en DDL refactor)

### bd_capacitaciones (06) – opcional (modelo Udemy)
- cap_seccion_capacitacion, cap_leccion, cap_inscripcion, cap_progreso_leccion, cap_material_capacitacion (crear entidades si se usan). La entidad QRealizanCapacitacion (tabla legacy cap_q_realizan_capacitacion) fue eliminada del DDL; usar cap_inscripcion para inscripción/progreso.

## Cambios en código que usan las entidades

1. **Personal:** PK compuesta `(numeroDocumento, idEmpresa)`. Reemplazar usos de `fkIdEmpresa` por `idEmpresa`. Repositorios: `findOne({ where: { numeroDocumento, idEmpresa } })`.
2. **Vehiculo:** PK compuesta `(placa, idEmpresa)`. Incluir `idEmpresa` en todas las consultas por placa.
3. **Empresa:** Ahora apunta a `ten_empresas`; columnas distintas (razon_social, nombre_qi, base_legacy, etc.). Ajustar DTOs y servicios que lean Empresa.
4. **Relaciones entre bases:** No hay FK; referencias por `id_empresa`, `numero_documento_conductor`, etc. Resolver datos de personal/tenancy vía API o mismo DataSource si se usa conexión unificada en fase transición.

## Catálogos compartidos (bd_personal)

- cat_departamento, cat_ciudad, cat_area, cat_cargos, cat_tipo_documento no llevan `id_empresa`.
- TiposVehiculos, MarcaVehiculo: en DDL flota están como veh_cat_tipos_vehiculos y veh_cat_marca_vehiculo (sin id_empresa). Adaptar maestras según la base donde vivan en el DDL final.
