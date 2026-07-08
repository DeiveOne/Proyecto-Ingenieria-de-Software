-- =====================================================================
-- ECOBIVA - Parte 1: Seguridad, Base de Datos y Arquitectura
-- Schema alineado al Diagrama de Clases del informe (punto 5,
-- consolidado DC1 + DC2 + Csprint3)
-- =====================================================================

-- =========================
-- TABLA EMPLEADO
-- Entidad base del dominio de RRHH, independiente de Usuario.
-- Un Empleado puede o no tener cuenta de acceso (Usuario).
-- =========================
CREATE TABLE Empleado (
  idEmpleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  documento VARCHAR(30) NOT NULL UNIQUE,
  fechaIngreso DATE NOT NULL,
  cargoActual VARCHAR(100) NOT NULL,
  tarifaHora DECIMAL(10,2) NOT NULL DEFAULT 0,
  estadoLaboral BOOLEAN NOT NULL DEFAULT TRUE
);

-- =========================
-- TABLA ROL
-- Catálogo de roles del sistema.
-- =========================
CREATE TABLE Rol (
  idRol INT AUTO_INCREMENT PRIMARY KEY,
  nombreRol VARCHAR(50) NOT NULL UNIQUE,
  descripcion VARCHAR(255)
);

-- =========================
-- TABLA USUARIO
-- Cuenta de acceso al sistema. Ya NO tiene idRol directo:
-- las capacidades se determinan dinámicamente vía UsuarioRol.
-- =========================
CREATE TABLE Usuario (
  idUsuario INT AUTO_INCREMENT PRIMARY KEY,
  correo VARCHAR(150) NOT NULL UNIQUE,
  passwordHash VARCHAR(255) NOT NULL,
  estado BOOLEAN NOT NULL DEFAULT TRUE,
  ultimoAcceso DATETIME NULL,
  idEmpleado INT NOT NULL,
  FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado)
);

-- =========================
-- TABLA USUARIORROL (entidad asociativa *..*)
-- Registra qué rol(es) tiene activo cada usuario y desde cuándo.
-- Al reasignar un rol no se sobrescribe: se cierra el registro
-- anterior con fechaFin y se crea uno nuevo (historial completo).
-- =========================
CREATE TABLE UsuarioRol (
  idUsuarioRol INT AUTO_INCREMENT PRIMARY KEY,
  idUsuario INT NOT NULL,
  idRol INT NOT NULL,
  fechaAsignacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fechaFin DATETIME NULL,
  asignadoPor INT NOT NULL,
  FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario),
  FOREIGN KEY (idRol) REFERENCES Rol(idRol),
  FOREIGN KEY (asignadoPor) REFERENCES Usuario(idUsuario)
);

-- =========================
-- TABLA PERFILTECNICO
-- Ya NO hereda de Usuario. Se asocia a Empleado (1..1), porque la
-- capacidad técnica es un atributo laboral, no un tipo fijo de cuenta.
-- =========================
CREATE TABLE PerfilTecnico (
  idPerfilTecnico INT AUTO_INCREMENT PRIMARY KEY,
  idEmpleado INT NOT NULL UNIQUE,
  cargaActual INT NOT NULL DEFAULT 0,
  especialidad VARCHAR(100),
  FOREIGN KEY (idEmpleado) REFERENCES Empleado(idEmpleado)
);

-- =========================
-- TABLA TOKENRECUPERACION
-- Ciclo de vida del token de recuperación de contraseña
-- (vigencia 30 minutos según el informe).
-- =========================
CREATE TABLE TokenRecuperacion (
  idToken INT AUTO_INCREMENT PRIMARY KEY,
  token VARCHAR(255) NOT NULL,
  fechaGeneracion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  fechaExpiracion DATETIME NOT NULL,
  usado BOOLEAN NOT NULL DEFAULT FALSE,
  idUsuario INT NOT NULL,
  FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

-- =========================
-- TABLA LOGAUDITORIA
-- Registro inmutable de acciones críticas. Relación real a Usuario
-- (ya no es un campo de texto plano).
-- =========================
CREATE TABLE LogAuditoria (
  idLog INT AUTO_INCREMENT PRIMARY KEY,
  accion VARCHAR(100) NOT NULL,
  modulo VARCHAR(100) NOT NULL,
  fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  detalle VARCHAR(500),
  idUsuario INT NOT NULL,
  FOREIGN KEY (idUsuario) REFERENCES Usuario(idUsuario)
);

-- =========================
-- TABLA PERMISO
-- Matriz Rol-Módulo: qué acciones están autorizadas.
-- =========================
CREATE TABLE Permiso (
  idPermiso INT AUTO_INCREMENT PRIMARY KEY,
  idRol INT NOT NULL,
  modulo VARCHAR(100) NOT NULL,
  verAutorizado BOOLEAN NOT NULL DEFAULT FALSE,
  crearAutorizado BOOLEAN NOT NULL DEFAULT FALSE,
  editarAutorizado BOOLEAN NOT NULL DEFAULT FALSE,
  eliminarAutorizado BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (idRol) REFERENCES Rol(idRol)
);

-- =====================================================================
-- DATOS SEMILLA
-- =====================================================================

-- Roles base
INSERT INTO Rol (nombreRol, descripcion) VALUES
('Admin', 'Administrador del sistema con acceso total'),
('Tecnico', 'Encargado de diagnóstico y reparación de vehículos'),
('Asesor', 'Encargado de atención al cliente y órdenes de servicio');

-- Empleado de prueba (necesario porque Usuario depende de Empleado)
INSERT INTO Empleado (nombre, documento, fechaIngreso, cargoActual, tarifaHora, estadoLaboral) VALUES
('Administrador Prueba', '0000000000', CURDATE(), 'Administrador', 0, TRUE);

-- Nota: el Usuario admin de prueba y su UsuarioRol se insertan desde
-- Node (seed.js), porque el passwordHash debe generarse con bcrypt,
-- no puede ir en texto plano ni un hash fijo en SQL.