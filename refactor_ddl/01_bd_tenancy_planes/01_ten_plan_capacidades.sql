-- Capacidades incluidas en cada plan comercial (bundle plan → plataformas).
-- Ejecutar en bd_tenancy_planes tras 00_schema.sql

CREATE TABLE IF NOT EXISTS `ten_plan_capacidades` (
  `id_plan` INT(11) NOT NULL,
  `codigo_capacidad` VARCHAR(80) NOT NULL COMMENT 'platform_qinspecting | platform_mantenimiento | modulo_capacitaciones_empresa',
  `fecha_control` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuario_control` VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (`id_plan`, `codigo_capacidad`),
  CONSTRAINT `fk_ten_pc_plan` FOREIGN KEY (`id_plan`) REFERENCES `ten_planes` (`id_plan`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Capacidades/plataformas habilitadas por plan';
