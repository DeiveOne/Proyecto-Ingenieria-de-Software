CREATE DATABASE `ecobiva_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */
/*!80016 DEFAULT ENCRYPTION='N' */;

CREATE DATABASE `ecobiva_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */
/*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `Empleado` (
  `idEmpleado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `documento` varchar(30) NOT NULL,
  `fechaIngreso` date NOT NULL,
  `cargoActual` varchar(100) NOT NULL,
  `tarifaHora` decimal(10, 2) NOT NULL DEFAULT '0.00',
  `estadoLaboral` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idEmpleado`),
  UNIQUE KEY `documento` (`documento`)
) ENGINE = InnoDB AUTO_INCREMENT = 7 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `LogAuditoria` (
  `idLog` int NOT NULL AUTO_INCREMENT,
  `accion` varchar(100) NOT NULL,
  `modulo` varchar(100) NOT NULL,
  `fechaHora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `detalle` varchar(500) DEFAULT NULL,
  `ipOrigen` varchar(45) DEFAULT NULL,
  `idUsuario` int DEFAULT NULL,
  PRIMARY KEY (`idLog`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `LogAuditoria_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `Usuario` (`idUsuario`)
) ENGINE = InnoDB AUTO_INCREMENT = 20 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `PerfilTecnico` (
  `idPerfilTecnico` int NOT NULL AUTO_INCREMENT,
  `idEmpleado` int NOT NULL,
  `cargaActual` int NOT NULL DEFAULT '0',
  `especialidad` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`idPerfilTecnico`),
  UNIQUE KEY `idEmpleado` (`idEmpleado`),
  CONSTRAINT `PerfilTecnico_ibfk_1` FOREIGN KEY (`idEmpleado`) REFERENCES `Empleado` (`idEmpleado`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Permiso` (
  `idPermiso` int NOT NULL AUTO_INCREMENT,
  `modulo` varchar(50) NOT NULL,
  `accion` varchar(30) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`idPermiso`),
  UNIQUE KEY `uq_modulo_accion` (`modulo`,
`accion`)
) ENGINE = InnoDB AUTO_INCREMENT = 17 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `PreguntaSeguridad` (
  `idPregunta` int NOT NULL AUTO_INCREMENT,
  `textoPregunta` varchar(255) NOT NULL,
  PRIMARY KEY (`idPregunta`),
  UNIQUE KEY `textoPregunta` (`textoPregunta`)
) ENGINE = InnoDB AUTO_INCREMENT = 7 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Rol` (
  `idRol` int NOT NULL AUTO_INCREMENT,
  `nombreRol` varchar(50) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`idRol`),
  UNIQUE KEY `nombreRol` (`nombreRol`)
) ENGINE = InnoDB AUTO_INCREMENT = 5 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `RolPermiso` (
  `idRol` int NOT NULL,
  `idPermiso` int NOT NULL,
  `permitido` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idRol`,
`idPermiso`),
  KEY `idPermiso` (`idPermiso`),
  CONSTRAINT `RolPermiso_ibfk_1` FOREIGN KEY (`idRol`) REFERENCES `Rol` (`idRol`) ON
DELETE
    CASCADE,
    CONSTRAINT `RolPermiso_ibfk_2` FOREIGN KEY (`idPermiso`) REFERENCES `Permiso` (`idPermiso`) ON
    DELETE
        CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `TokenRecuperacion` (
  `idToken` int NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `fechaGeneracion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaExpiracion` datetime NOT NULL,
  `usado` tinyint(1) NOT NULL DEFAULT '0',
  `idUsuario` int NOT NULL,
  PRIMARY KEY (`idToken`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `TokenRecuperacion_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `Usuario` (`idUsuario`)
) ENGINE = InnoDB AUTO_INCREMENT = 6 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `Usuario` (
  `idUsuario` int NOT NULL AUTO_INCREMENT,
  `correo` varchar(150) NOT NULL,
  `passwordHash` varchar(255) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `ultimoAcceso` datetime DEFAULT NULL,
  `idEmpleado` int NOT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `correo` (`correo`),
  KEY `idEmpleado` (`idEmpleado`),
  CONSTRAINT `Usuario_ibfk_1` FOREIGN KEY (`idEmpleado`) REFERENCES `Empleado` (`idEmpleado`)
) ENGINE = InnoDB AUTO_INCREMENT = 7 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `UsuarioPreguntaSeguridad` (
  `idUsuarioPregunta` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idPregunta` int NOT NULL,
  `respuestaHash` varchar(255) NOT NULL,
  PRIMARY KEY (`idUsuarioPregunta`),
  UNIQUE KEY `unico_usuario_pregunta` (`idUsuario`,
`idPregunta`),
  KEY `idPregunta` (`idPregunta`),
  CONSTRAINT `UsuarioPreguntaSeguridad_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `Usuario` (`idUsuario`),
  CONSTRAINT `UsuarioPreguntaSeguridad_ibfk_2` FOREIGN KEY (`idPregunta`) REFERENCES `PreguntaSeguridad` (`idPregunta`)
) ENGINE = InnoDB AUTO_INCREMENT = 17 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

CREATE TABLE `UsuarioRol` (
  `idUsuarioRol` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idRol` int NOT NULL,
  `fechaAsignacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaFin` datetime DEFAULT NULL,
  `asignadoPor` int NOT NULL,
  PRIMARY KEY (`idUsuarioRol`),
  KEY `idUsuario` (`idUsuario`),
  KEY `idRol` (`idRol`),
  KEY `asignadoPor` (`asignadoPor`),
  CONSTRAINT `UsuarioRol_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `Usuario` (`idUsuario`),
  CONSTRAINT `UsuarioRol_ibfk_2` FOREIGN KEY (`idRol`) REFERENCES `Rol` (`idRol`),
  CONSTRAINT `UsuarioRol_ibfk_3` FOREIGN KEY (`asignadoPor`) REFERENCES `Usuario` (`idUsuario`)
) ENGINE = InnoDB AUTO_INCREMENT = 13 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;
