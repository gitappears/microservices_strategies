# bd_inspecciones – Origen

Tablas origen (en cada `qinspect_new*`) → tablas normalizadas en esta base.

| Origen | Destino (prefijo) |
|--------|-------------------|
| itemInspeccion / Item_Inspeccion | insp_item_inspeccion |
| adjuntosInspeccion | insp_adjuntos_inspeccion |
| inspeccionLlantas | insp_inspeccion_llantas |
| detInspeccionLlantas | lla_det_inspeccion_llantas |
| rtaPreoperacional | preop_rta_preoperacional |
| resumenPreoperacional | preop_resumen_preoperacional |
| fallasSolucionadas | preop_fallas_solucionadas |
| fotosPreoperacionalUltimate | preop_fotos_preoperacional_ultimate |
| correctivasLLantas | lla_correctivas_llantas |
| desmontesLlantas | lla_desmontes_llantas |
| disposicionFinalLlantas | lla_disposicion_final_llantas |
| estadosLlantas | lla_estados_llantas |
| formatoEspecialesCat | fes_formato_especiales_cat |
| formatoEspecialesCatItem | fes_formato_especiales_cat_item |
| formatoEspecialesEnca | fes_formato_especiales_enca |
| formatoEspecialesEnca_det | fes_formato_especiales_enca_det |
| formatoEspecialesEnca_exp | fes_formato_especiales_enca_exp |
| formatoEspecialesUserRealiza | fes_formato_especiales_user_realiza |
| item_has_fv_vehiculo | insp_item_has_fv_vehiculo |
| item_has_fv_remolque | insp_item_has_fv_remolque |

**Migración:** por cada base `qinspect_new*`, obtener `id_empresa` desde `qinspect_planesQi.Empresas.base` e insertar en las tablas destino añadiendo la columna `id_empresa`.
