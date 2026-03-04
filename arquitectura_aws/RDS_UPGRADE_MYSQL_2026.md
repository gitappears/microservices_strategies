# Actualización RDS MySQL 8.0 → 8.4 (fin de soporte 31-jul-2026)

AWS notifica que **Amazon RDS para MySQL 8.0** alcanzará el **fin del soporte estándar el 31 de julio de 2026**. Después de esa fecha:

- Si **no** actualizas a una versión principal más nueva (p. ej. 8.4), AWS aplicará una actualización a una versión en **Extended Support** en una ventana de mantenimiento y **cobrará soporte extendido** (coste adicional por vCPU/hora).
- Si **optas por no** soporte extendido, AWS realizará una actualización mayor de versión durante una ventana de mantenimiento (riesgo de no elegir tú la fecha).

**Recomendación:** Actualizar a **MySQL 8.4 LTS** antes del 31 de julio de 2026. AWS RDS ya soporta 8.4 y permite actualización directa desde 8.0.

---

## Cambios en este repositorio

- **Plantilla `rds-databases.yaml`:**  
  - El valor por defecto de la versión de motor pasó de `8.0` a **`8.4`**.  
  - Se añadió el parámetro opcional **`EngineVersion`** (default `8.4`) para poder elegir versión sin editar la plantilla.
- **Nuevos despliegues:** Si despliegas el stack con la plantilla actual, la instancia RDS se creará ya con MySQL 8.4 (o la versión que pases en `EngineVersion`).

---

## Si ya tienes una instancia RDS MySQL 8.0 (QInspecting u otra)

Tienes hasta el **31 de julio de 2026** para actualizar sin pasar por Extended Support.

### Opción 1: Actualización in-place (consola o CLI)

1. **Hacer una instantánea** de la instancia antes (recomendado):
   ```bash
   aws rds create-db-snapshot \
     --db-instance-identifier qinspecting-prod \
     --db-snapshot-identifier qinspecting-prod-pre-84-$(date +%Y%m%d)
   ```

2. **Programar la actualización** en tu ventana de mantenimiento o ejecutarla cuando convenga:
   ```bash
   aws rds modify-db-instance \
     --db-instance-identifier qinspecting-prod \
     --engine-version 8.4 \
     --allow-major-version-upgrade \
     --apply-immediately
   ```
   (Obligatorio: `--allow-major-version-upgrade` para pasar de 8.0 a 8.4. Quita `--apply-immediately` si prefieres que se aplique en la próxima ventana de mantenimiento.)

3. La instancia se **reiniciará** una o más veces durante la actualización. La aplicación debe tolerar una breve indisponibilidad o usar reconexión.

### Opción 2: Blue/Green (menos tiempo de indisponibilidad)

Si quieres minimizar el corte, puedes usar [Blue/Green Deployments de RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/blue-green-deployments.html): se crea un entorno “verde” con 8.4, se sincroniza y luego se cambia el tráfico. Más pasos, pero con ventana de corte muy corta.

### Opción 3: Actualizar el stack CloudFormation

Si la instancia la creó este stack (`qinspecting-rds`), puedes actualizar el stack pasando la nueva versión:

```bash
aws cloudformation deploy \
  --template-file rds-databases.yaml \
  --stack-name qinspecting-rds \
  --parameter-overrides \
    VpcId=vpc-xxx \
    PrivateSubnetIds=subnet-1,subnet-2 \
    DBSecurityGroupId=sg-xxx \
    MasterUserPassword='xxx' \
    EngineVersion=8.4
```

Comprueba en la consola de CloudFormation si el cambio aplica una actualización in-place o un reemplazo; si reemplaza, habrá nueva instancia y posible cambio de endpoint.

---

## Compatibilidad aplicación (8.0 → 8.4)

MySQL 8.4 LTS es compatible con clientes y código que funcionan con 8.0 para el uso típico (UTF8MB4, JSON, ventanas, etc.). Si usas características muy concretas o deprecated en 8.0, revisa las [notas de la versión MySQL 8.4](https://dev.mysql.com/doc/relnotes/mysql/8.4/en/). El Lambda Authorizer y las APIs que usan `mysql2`/drivers estándar no suelen requerir cambios.

---

## Enlaces útiles (del mensaje de AWS)

- [Soporte MySQL en la comunidad](https://www.mysql.com/support/)
- [RDS Extended Support](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/extended-support.html)
- [Optar por no recibir Extended Support](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/extended-support-viewing.html)
- [Crear instantánea RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateSnapshot.html)
- [Blue/Green en RDS](https://aws.amazon.com/blogs/aws/new-fully-managed-blue-green-deployments-in-amazon-aurora-and-amazon-rds/)
- [Actualizar versión de motor en RDS MySQL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.MySQL.html)
- [Precios RDS](https://aws.amazon.com/rds/pricing/)
