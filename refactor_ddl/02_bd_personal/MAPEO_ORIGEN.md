# Mapeo: bases qinspect_new* → bd_personal

La base **bd_personal** se alimenta desde **cada** base por empresa (qinspect_newdistransllano, qinspect_newriano, qinspect_newtmc, etc.). El `id_empresa` debe tomarse del maestro **qinspect_planesQi**: tabla Empresas donde `Empresas.base` = nombre de la base actual.

## Catálogos (una sola vez desde una base origen, ej. qinspect_newpruebas)

| Origen (camelCase o PascalCase) | Destino bd_personal |
|----------------------------------|---------------------|
| departamento (idDepartamento, nombreDpto, usuarioControl) | cat_departamento (id_departamento, nombre_dpto, usuario_control) |
| Ciudad / ciudad (Ciu_Id/idCiudad, Ciu_Nombre/nombreCiudad, Dpt_Id/fkIdDepartamento) | cat_ciudad (id_ciudad, nombre_ciudad, fk_id_departamento) |
| area (idArea, nombreArea, estadoArea, usuarioControl) | cat_area (id_area, nombre_area, estado_area, usuario_control) |
| cargos / Cargos (idCargo/Carg_id, nombreCargo/Carg_Descripcion, estadoCargo) | cat_cargos (id_cargo, nombre_cargo, estado_cargo) |
| tipoDocumento / Tipo_Documento (idTipoDocumento/TipoDoc_Id, nombreTipoDocumento/TipoDoc_Descrip) | cat_tipo_documento (id_tipo_documento, nombre_tipo_documento) |

**Deduplicación:** insertar catálogos desde una sola base origen (ej. newpruebas) o hacer MERGE por PK para no duplicar ciudades/departamentos/cargos entre empresas.

## Personal (desde cada base new*)

Para cada base `qinspect_newXXXX`:

1. Obtener `id_empresa`: `SELECT Id_empresa FROM qinspect_planesQi.Empresas WHERE base = 'qinspect_newXXXX'`.
2. Insertar desde la tabla **personal** (minúscula) de esa base:

| Origen (personal)     | Destino (per_personal)     |
|------------------------|----------------------------|
| numeroDocumento        | numero_documento           |
| (id_empresa del paso 1)| id_empresa                 |
| lugarExpDocumento      | lugar_exp_documento        |
| fechaNacimiento        | fecha_nacimiento          |
| genero                 | genero                     |
| rh                     | rh                         |
| arl, eps, afp          | arl, eps, afp              |
| numeroCelular          | numero_celular             |
| direccion              | direccion                  |
| nombres, apellidos     | nombres, apellidos         |
| email                  | email                      |
| urlFoto                | url_foto                   |
| estadoPersonal         | estado_personal            |
| fkIdTIpoDocumento      | fk_id_tipo_documento       |
| fkIdCargo              | fk_id_cargo                |
| fkIdRol                | fk_id_rol                  |
| fechaControl           | fecha_control              |
| usuarioControl         | usuario_control            |

**Deduplicación:** PK (numero_documento, id_empresa). Si la misma persona aparece en más de una base (misma empresa), usar ON DUPLICATE KEY UPDATE o ignorar duplicados.

## Orden recomendado

1. Crear bd_personal y ejecutar 00_schema.sql.
2. Poblar catálogos desde **una** base origen (departamento → ciudad → area → cargos → tipo_documento).
3. Por cada base qinspect_new*: resolver id_empresa desde planesQi y ejecutar INSERT de personal en bd_personal.
