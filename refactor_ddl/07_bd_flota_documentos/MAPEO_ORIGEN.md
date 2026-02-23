# bd_flota_documentos – Origen

| Origen | Destino |
|--------|---------|
| vehiculo / Vehiculo | veh_vehiculo |
| cabezoteVehiculo | veh_cabezote_vehiculo |
| remolque / Remolque | veh_remolque |
| hashBinomios | veh_hash_binomios |
| tiposVehiculos / Tipos_Vehiculos | veh_cat_tipos_vehiculos |
| marcaVehiculo / marca_vehiculo_remolque | veh_cat_marca_vehiculo |
| documentosConductor / Documentos_conductor | doc_documentos_conductor |
| documentosFlota | doc_documentos_flota |
| firmasDigitales / Firmas_Digitales | doc_firmas_digitales |

- **documentosConductor**: `fkNumeroDoc` / `Pers_NumeroDoc` → `numero_documento_conductor` (bd_personal.per_personal).
- **documentosFlota**: `fkPlacaFlota` → `fk_placa_flota` (veh_vehiculo.placa o veh_remolque.placa_remolque).
- **firmasDigitales**: `fkNumeroDoc` / `Pers_NumeroDoc` → `fk_numero_doc` (bd_personal).

Inyectar `id_empresa` en todas las tablas desde mapeo base → ten_empresas.
