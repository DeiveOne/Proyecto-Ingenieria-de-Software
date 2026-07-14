CREATE DATABASE  IF NOT EXISTS `ecobiva_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ecobiva_db`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: ecobiva_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `alertastock`
--

DROP TABLE IF EXISTS `alertastock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alertastock` (
  `idAlerta` int NOT NULL AUTO_INCREMENT,
  `fechaGeneracion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estadoGestion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendiente',
  `idRepuesto` int NOT NULL,
  PRIMARY KEY (`idAlerta`),
  KEY `idRepuesto` (`idRepuesto`),
  CONSTRAINT `alertastock_ibfk_1` FOREIGN KEY (`idRepuesto`) REFERENCES `repuesto` (`idRepuesto`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alertastock`
--

LOCK TABLES `alertastock` WRITE;
/*!40000 ALTER TABLE `alertastock` DISABLE KEYS */;
INSERT INTO `alertastock` VALUES (9,'2026-07-14 11:54:37','pendiente',37),(10,'2026-07-14 11:54:37','pendiente',40);
/*!40000 ALTER TABLE `alertastock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bateria`
--

DROP TABLE IF EXISTS `bateria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bateria` (
  `idRepuesto` int NOT NULL,
  `serial` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `modeloCompatible` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `voltajeFinal` float DEFAULT NULL,
  `amperajeFinal` float DEFAULT NULL,
  `idVehiculo` int DEFAULT NULL,
  PRIMARY KEY (`idRepuesto`),
  UNIQUE KEY `serial` (`serial`),
  KEY `idVehiculo` (`idVehiculo`),
  CONSTRAINT `bateria_ibfk_1` FOREIGN KEY (`idRepuesto`) REFERENCES `repuesto` (`idRepuesto`),
  CONSTRAINT `bateria_ibfk_2` FOREIGN KEY (`idVehiculo`) REFERENCES `vehiculo` (`idVehiculo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bateria`
--

LOCK TABLES `bateria` WRITE;
/*!40000 ALTER TABLE `bateria` DISABLE KEYS */;
INSERT INTO `bateria` VALUES (43,'BAT-0001','EcoMoto X1','Nueva',NULL,NULL,NULL),(44,'BAT-0002','EcoMoto X2 Pro','Instalada',71.5,29.8,21);
/*!40000 ALTER TABLE `bateria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cliente` (
  `idCliente` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `correo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `documento` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `preferenciaNotificacion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `puntosAcumulados` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`idCliente`),
  UNIQUE KEY `documento` (`documento`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (25,'Juan Pérez','3204567890','juan.perez@example.com','1012456789','WhatsApp',1,185),(26,'María Gómez','3157894561','maria.gomez@example.com','1098765432','Correo',1,0),(27,'Carlos Ramírez','3012345678','carlos.ramirez@example.com','1076543210','SMS',1,0);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diagnostico`
--

DROP TABLE IF EXISTS `diagnostico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnostico` (
  `idDiagnostico` int NOT NULL AUTO_INCREMENT,
  `checklist` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `subtotalManoObra` decimal(10,2) NOT NULL DEFAULT '0.00',
  `subtotalRepuestos` decimal(10,2) NOT NULL DEFAULT '0.00',
  `bloqueado` tinyint(1) NOT NULL DEFAULT '0',
  `fechaEnvio` datetime DEFAULT NULL,
  `idOrdenServicio` int NOT NULL,
  `tipoDiagnostico` enum('superficial','profundo') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'superficial',
  `costoDiagnostico` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`idDiagnostico`),
  UNIQUE KEY `idOrdenServicio` (`idOrdenServicio`),
  CONSTRAINT `diagnostico_ibfk_1` FOREIGN KEY (`idOrdenServicio`) REFERENCES `ordenservicio` (`idOrden`),
  CONSTRAINT `diagnostico_chk_1` CHECK (json_valid(`checklist`))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diagnostico`
--

LOCK TABLES `diagnostico` WRITE;
/*!40000 ALTER TABLE `diagnostico` DISABLE KEYS */;
INSERT INTO `diagnostico` VALUES (1,'{\"frenos\":\"desgastados, requieren cambio\",\"aceite\":\"cambio realizado\",\"bateria\":\"ok, sin novedad\"}',60000.00,125000.00,1,'2026-06-30 11:54:37',3,'profundo',40000.00),(2,'{\"bateria\":\"revisar celdas por sospecha de descarga irregular\",\"motor\":\"sin novedad\"}',40000.00,0.00,0,NULL,4,'superficial',0.00);
/*!40000 ALTER TABLE `diagnostico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleado`
--

DROP TABLE IF EXISTS `empleado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleado` (
  `idEmpleado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `documento` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fechaIngreso` date NOT NULL,
  `cargoActual` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tarifaHora` decimal(10,2) NOT NULL DEFAULT '0.00',
  `estadoLaboral` tinyint(1) NOT NULL DEFAULT '1',
  `fechaRetiro` date DEFAULT NULL,
  PRIMARY KEY (`idEmpleado`),
  UNIQUE KEY `documento` (`documento`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleado`
--

LOCK TABLES `empleado` WRITE;
/*!40000 ALTER TABLE `empleado` DISABLE KEYS */;
INSERT INTO `empleado` VALUES (21,'Administrador Raíz','900000001',NULL,'2026-07-14','Administrador',0.00,1,NULL),(22,'Técnico de Prueba','900000002',NULL,'2026-07-14','Técnico Operativo',25.00,1,NULL),(23,'Asesor de Prueba','900000003',NULL,'2026-07-14','Asesor de Servicio',18.00,1,NULL),(24,'Cliente Demo','900000004',NULL,'2026-07-14','Cliente Final',0.00,1,NULL);
/*!40000 ALTER TABLE `empleado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evidenciafoto`
--

DROP TABLE IF EXISTS `evidenciafoto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evidenciafoto` (
  `idFoto` int NOT NULL AUTO_INCREMENT,
  `idEvidencia` int NOT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`idFoto`),
  KEY `idEvidencia` (`idEvidencia`),
  CONSTRAINT `evidenciafoto_ibfk_1` FOREIGN KEY (`idEvidencia`) REFERENCES `evidenciaingreso` (`idEvidencia`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evidenciafoto`
--

LOCK TABLES `evidenciafoto` WRITE;
/*!40000 ALTER TABLE `evidenciafoto` DISABLE KEYS */;
INSERT INTO `evidenciafoto` VALUES (1,1,'https://storage.ecobiva.com/evidencias/evb456-ingreso-1.jpg');
/*!40000 ALTER TABLE `evidenciafoto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evidenciaingreso`
--

DROP TABLE IF EXISTS `evidenciaingreso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evidenciaingreso` (
  `idEvidencia` int NOT NULL AUTO_INCREMENT,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `fechaRegistro` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idVehiculo` int NOT NULL,
  PRIMARY KEY (`idEvidencia`),
  KEY `idVehiculo` (`idVehiculo`),
  CONSTRAINT `evidenciaingreso_ibfk_1` FOREIGN KEY (`idVehiculo`) REFERENCES `vehiculo` (`idVehiculo`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evidenciaingreso`
--

LOCK TABLES `evidenciaingreso` WRITE;
/*!40000 ALTER TABLE `evidenciaingreso` DISABLE KEYS */;
INSERT INTO `evidenciaingreso` VALUES (1,'Rayón leve en el guardabarros delantero, se deja constancia antes de intervenir.','2026-07-11 11:54:37',21);
/*!40000 ALTER TABLE `evidenciaingreso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `factura`
--

DROP TABLE IF EXISTS `factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura` (
  `idFactura` int NOT NULL AUTO_INCREMENT,
  `idOrdenServicio` int NOT NULL,
  `numeroFactura` varchar(50) NOT NULL,
  `tipo` enum('diagnostico','reparacion') NOT NULL DEFAULT 'reparacion',
  `fechaEmision` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `subtotalManoObra` decimal(10,2) NOT NULL DEFAULT '0.00',
  `subtotalRepuestos` decimal(10,2) NOT NULL DEFAULT '0.00',
  `descuento` decimal(10,2) NOT NULL DEFAULT '0.00',
  `impuestos` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `metodoPago` varchar(50) DEFAULT NULL,
  `pagoConfirmado` tinyint(1) NOT NULL DEFAULT '0',
  `fechaPago` datetime DEFAULT NULL,
  `idUsuarioCreador` int DEFAULT NULL,
  PRIMARY KEY (`idFactura`),
  UNIQUE KEY `numeroFactura` (`numeroFactura`),
  UNIQUE KEY `uq_orden_tipo` (`idOrdenServicio`,`tipo`),
  KEY `idUsuarioCreador` (`idUsuarioCreador`),
  CONSTRAINT `Factura_ibfk_1` FOREIGN KEY (`idOrdenServicio`) REFERENCES `ordenservicio` (`idOrden`),
  CONSTRAINT `Factura_ibfk_2` FOREIGN KEY (`idUsuarioCreador`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `factura`
--

LOCK TABLES `factura` WRITE;
/*!40000 ALTER TABLE `factura` DISABLE KEYS */;
INSERT INTO `factura` VALUES (1,3,'FAC-000001','reparacion','2026-07-14 11:54:37',60000.00,125000.00,0.00,0.00,185000.00,'Efectivo',1,'2026-07-02 11:54:37',21);
/*!40000 ALTER TABLE `factura` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firmadigital`
--

DROP TABLE IF EXISTS `firmadigital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `firmadigital` (
  `idFirma` int NOT NULL AUTO_INCREMENT,
  `imagenFirma` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `metodoCaptura` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fechaCaptura` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `terminosAceptados` tinyint(1) NOT NULL DEFAULT '0',
  `idOrden` int NOT NULL,
  PRIMARY KEY (`idFirma`),
  KEY `idOrden` (`idOrden`),
  CONSTRAINT `firmadigital_ibfk_1` FOREIGN KEY (`idOrden`) REFERENCES `ordenservicio` (`idOrden`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firmadigital`
--

LOCK TABLES `firmadigital` WRITE;
/*!40000 ALTER TABLE `firmadigital` DISABLE KEYS */;
INSERT INTO `firmadigital` VALUES (1,'data:image/png;base64,SEED_PLACEHOLDER','Táctil','2026-07-02 11:54:37',1,3);
/*!40000 ALTER TABLE `firmadigital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historialcargo`
--

DROP TABLE IF EXISTS `historialcargo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historialcargo` (
  `idHistorial` int NOT NULL AUTO_INCREMENT,
  `idEmpleado` int NOT NULL,
  `cargoAnterior` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cargoNuevo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fechaCambio` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `motivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idUsuario` int DEFAULT NULL,
  PRIMARY KEY (`idHistorial`),
  KEY `idEmpleado` (`idEmpleado`),
  KEY `FK_HistorialCargo_Usuario` (`idUsuario`),
  CONSTRAINT `FK_HistorialCargo_Usuario` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`),
  CONSTRAINT `histcargo_ibfk_1` FOREIGN KEY (`idEmpleado`) REFERENCES `empleado` (`idEmpleado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historialcargo`
--

LOCK TABLES `historialcargo` WRITE;
/*!40000 ALTER TABLE `historialcargo` DISABLE KEYS */;
INSERT INTO `historialcargo` VALUES (3,22,'Técnico Junior','Técnico Operativo','2026-04-15 11:54:37','Promoción por desempeño',19);
/*!40000 ALTER TABLE `historialcargo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historialestado`
--

DROP TABLE IF EXISTS `historialestado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historialestado` (
  `idHistorial` int NOT NULL AUTO_INCREMENT,
  `estadoAnterior` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estadoNuevo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarioId` int NOT NULL,
  `motivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idOrdenServicio` int NOT NULL,
  PRIMARY KEY (`idHistorial`),
  KEY `usuarioId` (`usuarioId`),
  KEY `idOrdenServicio` (`idOrdenServicio`),
  CONSTRAINT `historialestado_ibfk_1` FOREIGN KEY (`usuarioId`) REFERENCES `usuario` (`idUsuario`),
  CONSTRAINT `historialestado_ibfk_2` FOREIGN KEY (`idOrdenServicio`) REFERENCES `ordenservicio` (`idOrden`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historialestado`
--

LOCK TABLES `historialestado` WRITE;
/*!40000 ALTER TABLE `historialestado` DISABLE KEYS */;
INSERT INTO `historialestado` VALUES (15,NULL,'recibido','2026-06-29 11:54:37',21,'Creación de la orden',3),(16,'recibido','en_diagnostico','2026-06-30 11:54:37',20,'Vehículo ingresado a taller',3),(17,'en_diagnostico','pendiente_aprobacion','2026-06-30 11:54:37',20,'Diagnóstico enviado a aprobación del cliente',3),(18,'pendiente_aprobacion','aprobada','2026-07-01 11:54:37',21,'Cliente aprueba la reparación propuesta',3),(19,'aprobada','en_reparacion','2026-07-01 11:54:37',20,'Inicia reparación',3),(20,'en_reparacion','finalizada','2026-07-01 11:54:37',20,'Servicio completado',3),(21,'finalizada','entregada','2026-07-02 11:54:37',21,'Entregado al cliente',3),(22,NULL,'recibido','2026-07-11 11:54:37',21,'Creación de la orden',4),(23,'recibido','en_diagnostico','2026-07-12 11:54:37',20,'Vehículo ingresado a taller',4),(24,NULL,'recibido','2026-07-14 11:54:37',21,'Creación de la orden',5);
/*!40000 ALTER TABLE `historialestado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logauditoria`
--

DROP TABLE IF EXISTS `logauditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logauditoria` (
  `idLog` int NOT NULL AUTO_INCREMENT,
  `accion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `modulo` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `detalle` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idUsuario` int NOT NULL,
  PRIMARY KEY (`idLog`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `logaud_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logauditoria`
--

LOCK TABLES `logauditoria` WRITE;
/*!40000 ALTER TABLE `logauditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `logauditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `movimientokardex`
--

DROP TABLE IF EXISTS `movimientokardex`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `movimientokardex` (
  `idMovimiento` int NOT NULL AUTO_INCREMENT,
  `tipoMovimiento` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cantidad` int NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `idRepuesto` int NOT NULL,
  `idOrdenServicio` int DEFAULT NULL,
  `idUsuario` int NOT NULL,
  PRIMARY KEY (`idMovimiento`),
  KEY `idRepuesto` (`idRepuesto`),
  KEY `idOrdenServicio` (`idOrdenServicio`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `movimientokardex_ibfk_1` FOREIGN KEY (`idRepuesto`) REFERENCES `repuesto` (`idRepuesto`),
  CONSTRAINT `movimientokardex_ibfk_2` FOREIGN KEY (`idOrdenServicio`) REFERENCES `ordenservicio` (`idOrden`),
  CONSTRAINT `movimientokardex_ibfk_3` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `movimientokardex`
--

LOCK TABLES `movimientokardex` WRITE;
/*!40000 ALTER TABLE `movimientokardex` DISABLE KEYS */;
INSERT INTO `movimientokardex` VALUES (5,'entrada',20,'2026-06-24 11:54:37',38,NULL,19);
/*!40000 ALTER TABLE `movimientokardex` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nomina`
--

DROP TABLE IF EXISTS `nomina`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nomina` (
  `idNomina` int NOT NULL AUTO_INCREMENT,
  `idEmpleado` int NOT NULL,
  `periodoInicio` date NOT NULL,
  `periodoFin` date NOT NULL,
  `totalHoras` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tarifaHoraAplicada` decimal(10,2) NOT NULL,
  `totalPagar` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fechaGeneracion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idNomina`),
  KEY `idEmpleado` (`idEmpleado`),
  CONSTRAINT `nomina_ibfk_1` FOREIGN KEY (`idEmpleado`) REFERENCES `empleado` (`idEmpleado`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nomina`
--

LOCK TABLES `nomina` WRITE;
/*!40000 ALTER TABLE `nomina` DISABLE KEYS */;
INSERT INTO `nomina` VALUES (2,22,'2026-06-30','2026-07-14',18.00,25.00,450.00,'2026-07-14 11:54:37');
/*!40000 ALTER TABLE `nomina` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordengarantia`
--

DROP TABLE IF EXISTS `ordengarantia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordengarantia` (
  `idOrdenGarantia` int NOT NULL AUTO_INCREMENT,
  `ordenOrigenId` int NOT NULL,
  `estado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'abierta',
  `costoInterno` decimal(10,2) DEFAULT NULL,
  `fechaApertura` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notasSeguimiento` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`idOrdenGarantia`),
  KEY `ordenOrigenId` (`ordenOrigenId`),
  CONSTRAINT `ordengarantia_ibfk_1` FOREIGN KEY (`ordenOrigenId`) REFERENCES `ordenservicio` (`idOrden`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordengarantia`
--

LOCK TABLES `ordengarantia` WRITE;
/*!40000 ALTER TABLE `ordengarantia` DISABLE KEYS */;
INSERT INTO `ordengarantia` VALUES (1,3,'abierta',NULL,'2026-07-12 11:54:37','Cliente reporta leve ruido en el freno delantero luego de 2 semanas de uso');
/*!40000 ALTER TABLE `ordengarantia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordenservicio`
--

DROP TABLE IF EXISTS `ordenservicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ordenservicio` (
  `idOrden` int NOT NULL AUTO_INCREMENT,
  `folio` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fechaCreacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'abierta',
  `kilometrajeIngreso` int DEFAULT NULL,
  `nivelBateriaIngreso` int DEFAULT NULL,
  `idCliente` int NOT NULL,
  `idVehiculo` int NOT NULL,
  `idTecnico` int DEFAULT NULL,
  `idAsesor` int DEFAULT NULL,
  PRIMARY KEY (`idOrden`),
  UNIQUE KEY `folio` (`folio`),
  KEY `idCliente` (`idCliente`),
  KEY `idVehiculo` (`idVehiculo`),
  KEY `idTecnico` (`idTecnico`),
  KEY `idAsesor` (`idAsesor`),
  CONSTRAINT `ordenservicio_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  CONSTRAINT `ordenservicio_ibfk_2` FOREIGN KEY (`idVehiculo`) REFERENCES `vehiculo` (`idVehiculo`),
  CONSTRAINT `ordenservicio_ibfk_3` FOREIGN KEY (`idTecnico`) REFERENCES `usuario` (`idUsuario`),
  CONSTRAINT `ordenservicio_ibfk_4` FOREIGN KEY (`idAsesor`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordenservicio`
--

LOCK TABLES `ordenservicio` WRITE;
/*!40000 ALTER TABLE `ordenservicio` DISABLE KEYS */;
INSERT INTO `ordenservicio` VALUES (3,'OT-000001','2026-06-29 11:54:37','entregada',1200,45,25,20,20,21),(4,'OT-000002','2026-07-11 11:54:37','en_diagnostico',500,60,26,21,20,21),(5,'OT-000003','2026-07-14 11:54:37','recibido',8300,20,27,22,NULL,21);
/*!40000 ALTER TABLE `ordenservicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfiltecnico`
--

DROP TABLE IF EXISTS `perfiltecnico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `perfiltecnico` (
  `idPerfilTecnico` int NOT NULL AUTO_INCREMENT,
  `idEmpleado` int NOT NULL,
  `cargaActual` int NOT NULL DEFAULT '0',
  `capacidadMaxima` int NOT NULL DEFAULT '3',
  `especialidad` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idPerfilTecnico`),
  UNIQUE KEY `idEmpleado` (`idEmpleado`),
  CONSTRAINT `perfiltec_ibfk_1` FOREIGN KEY (`idEmpleado`) REFERENCES `empleado` (`idEmpleado`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfiltecnico`
--

LOCK TABLES `perfiltecnico` WRITE;
/*!40000 ALTER TABLE `perfiltecnico` DISABLE KEYS */;
INSERT INTO `perfiltecnico` VALUES (7,22,2,3,'Sistemas eléctricos y baterías');
/*!40000 ALTER TABLE `perfiltecnico` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permiso`
--

DROP TABLE IF EXISTS `permiso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permiso` (
  `idPermiso` int NOT NULL AUTO_INCREMENT,
  `modulo` varchar(50) NOT NULL,
  `accion` varchar(30) NOT NULL,
  `descripcion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`idPermiso`),
  UNIQUE KEY `uq_modulo_accion` (`modulo`,`accion`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permiso`
--

LOCK TABLES `permiso` WRITE;
/*!40000 ALTER TABLE `permiso` DISABLE KEYS */;
INSERT INTO `permiso` VALUES (25,'permisos','leer','Ver la matriz de permisos por rol'),(26,'permisos','editar','Editar la matriz de permisos por rol'),(27,'auditoria','leer','Consultar el log de auditoría'),(28,'auditoria','exportar','Exportar el log de auditoría');
/*!40000 ALTER TABLE `permiso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preguntaseguridad`
--

DROP TABLE IF EXISTS `preguntaseguridad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preguntaseguridad` (
  `idPregunta` int NOT NULL AUTO_INCREMENT,
  `textoPregunta` varchar(255) NOT NULL,
  PRIMARY KEY (`idPregunta`),
  UNIQUE KEY `textoPregunta` (`textoPregunta`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preguntaseguridad`
--

LOCK TABLES `preguntaseguridad` WRITE;
/*!40000 ALTER TABLE `preguntaseguridad` DISABLE KEYS */;
INSERT INTO `preguntaseguridad` VALUES (37,'¿Cuál es el nombre de la ciudad donde naciste?'),(42,'¿Cuál es el nombre de tu escuela primaria?'),(38,'¿Cuál es el nombre de tu mejor amigo de la infancia?'),(39,'¿Cuál es el nombre de tu primera mascota?'),(40,'¿Cuál es tu color favorito?'),(41,'¿Cuál es tu comida favorita?');
/*!40000 ALTER TABLE `preguntaseguridad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `puntofidelidad`
--

DROP TABLE IF EXISTS `puntofidelidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `puntofidelidad` (
  `idMovimiento` int NOT NULL AUTO_INCREMENT,
  `tipoMovimiento` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `puntos` int NOT NULL DEFAULT '0',
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `porcentajeDescuentoAplicado` decimal(5,2) DEFAULT NULL,
  `idCliente` int NOT NULL,
  `idOrden` int DEFAULT NULL,
  PRIMARY KEY (`idMovimiento`),
  KEY `idCliente` (`idCliente`),
  KEY `idOrden` (`idOrden`),
  CONSTRAINT `puntofidelidad_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  CONSTRAINT `puntofidelidad_ibfk_2` FOREIGN KEY (`idOrden`) REFERENCES `ordenservicio` (`idOrden`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `puntofidelidad`
--

LOCK TABLES `puntofidelidad` WRITE;
/*!40000 ALTER TABLE `puntofidelidad` DISABLE KEYS */;
INSERT INTO `puntofidelidad` VALUES (1,'acumulacion',185,'2026-07-02 11:54:37',NULL,25,3);
/*!40000 ALTER TABLE `puntofidelidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recordatoriopreventivo`
--

DROP TABLE IF EXISTS `recordatoriopreventivo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recordatoriopreventivo` (
  `idRecordatorio` int NOT NULL AUTO_INCREMENT,
  `canal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fechaEnvio` datetime NOT NULL,
  `enviado` tinyint(1) NOT NULL DEFAULT '0',
  `idCliente` int NOT NULL,
  `idVehiculo` int NOT NULL,
  PRIMARY KEY (`idRecordatorio`),
  KEY `idCliente` (`idCliente`),
  KEY `idVehiculo` (`idVehiculo`),
  CONSTRAINT `recordatoriopreventivo_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`),
  CONSTRAINT `recordatoriopreventivo_ibfk_2` FOREIGN KEY (`idVehiculo`) REFERENCES `vehiculo` (`idVehiculo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recordatoriopreventivo`
--

LOCK TABLES `recordatoriopreventivo` WRITE;
/*!40000 ALTER TABLE `recordatoriopreventivo` DISABLE KEYS */;
INSERT INTO `recordatoriopreventivo` VALUES (1,'WhatsApp','2026-06-14 11:54:37',1,25,20),(2,'SMS','2026-07-29 11:54:37',0,27,23);
/*!40000 ALTER TABLE `recordatoriopreventivo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registrohoras`
--

DROP TABLE IF EXISTS `registrohoras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registrohoras` (
  `idRegistro` int NOT NULL AUTO_INCREMENT,
  `idEmpleado` int NOT NULL,
  `fecha` date NOT NULL,
  `horasTrabajadas` decimal(10,2) NOT NULL,
  `idOrdenServicio` int DEFAULT NULL,
  PRIMARY KEY (`idRegistro`),
  KEY `idEmpleado` (`idEmpleado`),
  KEY `idOrdenServicio` (`idOrdenServicio`),
  CONSTRAINT `registrohoras_ibfk_1` FOREIGN KEY (`idEmpleado`) REFERENCES `empleado` (`idEmpleado`),
  CONSTRAINT `registrohoras_ibfk_2` FOREIGN KEY (`idOrdenServicio`) REFERENCES `ordenservicio` (`idOrden`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registrohoras`
--

LOCK TABLES `registrohoras` WRITE;
/*!40000 ALTER TABLE `registrohoras` DISABLE KEYS */;
INSERT INTO `registrohoras` VALUES (1,22,'2026-06-30',4.00,3),(2,22,'2026-07-01',3.00,3),(3,22,'2026-07-12',5.00,4),(4,22,'2026-07-13',6.00,NULL);
/*!40000 ALTER TABLE `registrohoras` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repuesto`
--

DROP TABLE IF EXISTS `repuesto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repuesto` (
  `idRepuesto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `categoria` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `precioUnitario` decimal(10,2) NOT NULL DEFAULT '0.00',
  `proveedor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `stockActual` int NOT NULL DEFAULT '0',
  `stockMinimo` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`idRepuesto`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repuesto`
--

LOCK TABLES `repuesto` WRITE;
/*!40000 ALTER TABLE `repuesto` DISABLE KEYS */;
INSERT INTO `repuesto` VALUES (37,'Pastillas de freno delanteras','Frenos',45000.00,'FrenosCol S.A.',3,5),(38,'Filtro de aceite','Mantenimiento',18000.00,'MotoPartes Ltda',20,5),(39,'Aceite motor sintético 5W-30 (1L)','Lubricantes',35000.00,'LubriMax',15,8),(40,'Amortiguador delantero','Suspensión',120000.00,'SuspenCol',2,4),(41,'Kit de cables y conectores eléctricos','Eléctrico',25000.00,'ElectroMoto',10,5),(42,'Controlador de motor eléctrico','Eléctrico',280000.00,'EVParts',4,3),(43,'Batería de Litio 60V 20Ah','Batería',850000.00,'PowerCell',6,2),(44,'Batería de Litio 72V 30Ah','Batería',1200000.00,'PowerCell',3,2);
/*!40000 ALTER TABLE `repuesto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `idRol` int NOT NULL AUTO_INCREMENT,
  `nombreRol` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`idRol`),
  UNIQUE KEY `nombreRol` (`nombreRol`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (49,'Admin','Administrador del sistema, acceso total'),(50,'Tecnico','Técnico de taller'),(51,'Asesor','Asesor de servicio'),(52,'Cliente','Cliente con acceso limitado al sistema');
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rolpermiso`
--

DROP TABLE IF EXISTS `rolpermiso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rolpermiso` (
  `idRol` int NOT NULL,
  `idPermiso` int NOT NULL,
  `permitido` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idRol`,`idPermiso`),
  KEY `idx_permiso` (`idPermiso`),
  CONSTRAINT `RolPermiso_ibfk_1` FOREIGN KEY (`idRol`) REFERENCES `rol` (`idRol`) ON DELETE CASCADE,
  CONSTRAINT `RolPermiso_ibfk_2` FOREIGN KEY (`idPermiso`) REFERENCES `permiso` (`idPermiso`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rolpermiso`
--

LOCK TABLES `rolpermiso` WRITE;
/*!40000 ALTER TABLE `rolpermiso` DISABLE KEYS */;
INSERT INTO `rolpermiso` VALUES (49,25,1),(49,26,1),(49,27,1),(49,28,1),(50,25,0),(50,26,0),(50,27,0),(50,28,0),(51,25,0),(51,26,0),(51,27,0),(51,28,0),(52,25,0),(52,26,0),(52,27,0),(52,28,0);
/*!40000 ALTER TABLE `rolpermiso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `terminogarantia`
--

DROP TABLE IF EXISTS `terminogarantia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `terminogarantia` (
  `idTermino` int NOT NULL AUTO_INCREMENT,
  `categoria` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `textoLegal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `plazoGarantiaDias` int NOT NULL DEFAULT '0',
  `version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `vigente` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`idTermino`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `terminogarantia`
--

LOCK TABLES `terminogarantia` WRITE;
/*!40000 ALTER TABLE `terminogarantia` DISABLE KEYS */;
INSERT INTO `terminogarantia` VALUES (1,'Batería','La batería cuenta con garantía de fábrica por defectos de manufactura, sujeta a uso adecuado y carga con cargador original.',365,'v1',1),(2,'Mano de obra','La mano de obra realizada en taller cuenta con garantía de 30 días sobre el servicio prestado; no cubre daños por mal uso posterior.',30,'v1',1),(3,'Repuestos electrónicos','Los repuestos electrónicos instalados cuentan con la garantía del proveedor, sujeta a las condiciones del fabricante.',90,'v1',1);
/*!40000 ALTER TABLE `terminogarantia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tokenrecuperacion`
--

DROP TABLE IF EXISTS `tokenrecuperacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tokenrecuperacion` (
  `idToken` int NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `fechaGeneracion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fechaExpiracion` datetime NOT NULL,
  `usado` tinyint(1) DEFAULT '0',
  `idUsuario` int NOT NULL,
  PRIMARY KEY (`idToken`),
  KEY `idUsuario` (`idUsuario`),
  CONSTRAINT `tokenrecuperacion_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tokenrecuperacion`
--

LOCK TABLES `tokenrecuperacion` WRITE;
/*!40000 ALTER TABLE `tokenrecuperacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `tokenrecuperacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idUsuario` int NOT NULL AUTO_INCREMENT,
  `correo` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `passwordHash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT '1',
  `ultimoAcceso` datetime DEFAULT NULL,
  `idEmpleado` int NOT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE KEY `correo` (`correo`),
  KEY `idEmpleado` (`idEmpleado`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`idEmpleado`) REFERENCES `empleado` (`idEmpleado`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (19,'admin@ecobiva.com','$2b$10$j6c15ywfNFXks2mRXFDMV.trbmy5jUYeNVLSkA2X48T5PENqX0K3O',1,'2026-07-14 12:01:42',21),(20,'tecnico@ecobiva.com','$2b$10$soLViqflh24LXdv8haBtn.tD/SxGy16TafSi279.CNhzcrBYRJyJq',1,NULL,22),(21,'asesor@ecobiva.com','$2b$10$uvOe5sV3HHOlUKWQrN1z8OZBk373GsEdCE1W5IZwBcnXTjzJw4WTa',1,NULL,23),(22,'cliente@ecobiva.com','$2b$10$O3.HRG0uk23qmKAoaoV/wORNN8u3RavNSjLykpz6J1VCcgLawRfEe',1,NULL,24);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuariopreguntaseguridad`
--

DROP TABLE IF EXISTS `usuariopreguntaseguridad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuariopreguntaseguridad` (
  `idUsuarioPregunta` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idPregunta` int NOT NULL,
  `respuestaHash` varchar(255) NOT NULL,
  PRIMARY KEY (`idUsuarioPregunta`),
  UNIQUE KEY `idUsuario` (`idUsuario`,`idPregunta`),
  KEY `idPregunta` (`idPregunta`),
  CONSTRAINT `usuariopreguntaseguridad_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`),
  CONSTRAINT `usuariopreguntaseguridad_ibfk_2` FOREIGN KEY (`idPregunta`) REFERENCES `preguntaseguridad` (`idPregunta`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuariopreguntaseguridad`
--

LOCK TABLES `usuariopreguntaseguridad` WRITE;
/*!40000 ALTER TABLE `usuariopreguntaseguridad` DISABLE KEYS */;
INSERT INTO `usuariopreguntaseguridad` VALUES (49,19,39,'$2b$10$Haec6vn0w66XpTMTahgRMuJVfhSfic8Q6FMZ7kaDTGFH6IqD5ClkS'),(50,19,42,'$2b$10$FTPswKmEaQOY6F3OYAhZMO7sp6ekQmIWx862nkkwS84Momxb2Mk5q'),(51,19,41,'$2b$10$yR0tnJcIYT0p8bHOxce4c.jSvidUguWJn477E0gcl.tWpfKNXeh/.'),(52,20,39,'$2b$10$E0YGrP8ELtencPxlX3YGteQKrcR.EDPGd1MoTLTUxxFN54LXiJk4.'),(53,20,40,'$2b$10$OHIcT1vNVPNHTGRVLmNhFuQJT8FsOG9QGfO789I8tFaoiiNwptLr6'),(54,20,41,'$2b$10$0ENEweofPSbvjUO9M3/JGu1.vNHZt.VD6HAHZB6z5OUNeDd7zltHW'),(55,21,37,'$2b$10$joHoHlZL8DvLok904DmrWOJhzutBfMRA24Y7LsDS/c3.0N2IcU0xy'),(56,21,40,'$2b$10$bqC0TNkFDJo.pIk67u4vXe1BRvFHv5huKirpvia7eP6ZpGgNFmrdG'),(57,21,39,'$2b$10$vZTXwUQhphabpSxpykQileViwSodDH0DXhD/2AUjyVDKHaMvrkNVq'),(58,22,38,'$2b$10$K8Z3ZgxUpcl7t6m81eCOT.ptTI1bkConU8YZyX.svgAOsrAzXnj22'),(59,22,39,'$2b$10$Fc/VKQMDsS5LtoEHIA7K7.mQ0l6epvNt8G0LQxGemPfuUQ/NKSdL2'),(60,22,41,'$2b$10$a0Od5DbvgpJcxJSS5lGI3.3frqRXsKwwyFbplTGqRU7ANsqNSRS5G');
/*!40000 ALTER TABLE `usuariopreguntaseguridad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuariorol`
--

DROP TABLE IF EXISTS `usuariorol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuariorol` (
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
  CONSTRAINT `usuariorol_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`),
  CONSTRAINT `usuariorol_ibfk_2` FOREIGN KEY (`idRol`) REFERENCES `rol` (`idRol`),
  CONSTRAINT `usuariorol_ibfk_3` FOREIGN KEY (`asignadoPor`) REFERENCES `usuario` (`idUsuario`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuariorol`
--

LOCK TABLES `usuariorol` WRITE;
/*!40000 ALTER TABLE `usuariorol` DISABLE KEYS */;
INSERT INTO `usuariorol` VALUES (19,19,49,'2026-07-14 11:54:36',NULL,19),(20,20,50,'2026-07-14 11:54:36',NULL,20),(21,21,51,'2026-07-14 11:54:36',NULL,21),(22,22,52,'2026-07-14 11:54:37',NULL,22);
/*!40000 ALTER TABLE `usuariorol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehiculo`
--

DROP TABLE IF EXISTS `vehiculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehiculo` (
  `idVehiculo` int NOT NULL AUTO_INCREMENT,
  `placa` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `marca` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `modelo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `anio` int DEFAULT NULL,
  `serialMotor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `tipoVehiculo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `especificacionesBateria` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `idCliente` int NOT NULL,
  PRIMARY KEY (`idVehiculo`),
  UNIQUE KEY `placa` (`placa`),
  KEY `idCliente` (`idCliente`),
  CONSTRAINT `vehiculo_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `cliente` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehiculo`
--

LOCK TABLES `vehiculo` WRITE;
/*!40000 ALTER TABLE `vehiculo` DISABLE KEYS */;
INSERT INTO `vehiculo` VALUES (20,'EVA123','EcoMoto','X1',2023,'MTR-0001','Motocicleta Eléctrica','60V 20Ah',25),(21,'EVB456','EcoMoto','X2 Pro',2024,'MTR-0002','Motocicleta Eléctrica','72V 30Ah',26),(22,'EVC789','Voltium','Urban',2022,'MTR-0003','Motocicleta Eléctrica','60V 20Ah',27),(23,'EVC790','Voltium','Cargo',2023,'MTR-0004','Motocicleta de Carga Eléctrica','72V 40Ah',27);
/*!40000 ALTER TABLE `vehiculo` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-14 13:09:24
ALTER TABLE Repuesto
  ADD COLUMN activo TINYINT(1) NOT NULL DEFAULT 1 AFTER stockMinimo;