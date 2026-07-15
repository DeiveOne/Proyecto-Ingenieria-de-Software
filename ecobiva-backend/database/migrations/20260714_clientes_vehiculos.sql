-- Aplicar una única vez sobre bases de datos ya existentes antes de desplegar este merge.
ALTER TABLE Cliente
  ADD COLUMN tipoDocumento VARCHAR(10) NOT NULL DEFAULT 'CC' AFTER idCliente,
  ADD COLUMN ciudad VARCHAR(100) NULL AFTER correo,
  ADD COLUMN direccion VARCHAR(255) NULL AFTER ciudad,
  ADD COLUMN tipoComunicacion VARCHAR(50) NULL AFTER direccion;

UPDATE Cliente
SET tipoComunicacion = COALESCE(preferenciaNotificacion, 'Correo')
WHERE tipoComunicacion IS NULL;

ALTER TABLE Vehiculo
  ADD COLUMN color VARCHAR(50) NULL AFTER anio,
  ADD COLUMN kilometraje INT NULL AFTER color,
  ADD COLUMN fechaIngreso DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER kilometraje,
  ADD COLUMN estado TINYINT(1) NOT NULL DEFAULT 1 AFTER fechaIngreso;
