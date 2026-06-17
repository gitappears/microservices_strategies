-- Renombra capacidad legacy platform_develop → platform_qinspecting
-- Ejecutar en bd_tenancy_planes si ya existían filas con el código anterior

UPDATE `ten_plan_capacidades`
SET `codigo_capacidad` = 'platform_qinspecting'
WHERE `codigo_capacidad` = 'platform_develop';

UPDATE `ten_empresa_capacidades`
SET `codigo_capacidad` = 'platform_qinspecting'
WHERE `codigo_capacidad` = 'platform_develop';
