CREATE DATABASE  IF NOT EXISTS `organizzazione_eventi` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `organizzazione_eventi`;
-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: organizzazione_eventi
-- ------------------------------------------------------
-- Server version	8.0.3

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
-- Table structure for table `acquisto`
--

DROP TABLE IF EXISTS `acquisto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `acquisto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pacchetto` int NOT NULL,
  `utente` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `promo` varchar(15) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `prezzo_totale` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `inserito` (`promo`),
  KEY `effettua` (`utente`),
  KEY `scelto` (`pacchetto`),
  CONSTRAINT `effettua` FOREIGN KEY (`utente`) REFERENCES `utente` (`email`),
  CONSTRAINT `inserito` FOREIGN KEY (`promo`) REFERENCES `codice_promo` (`codice`),
  CONSTRAINT `scelto` FOREIGN KEY (`pacchetto`) REFERENCES `pacchetto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acquisto`
--

LOCK TABLES `acquisto` WRITE;
/*!40000 ALTER TABLE `acquisto` DISABLE KEYS */;
INSERT INTO `acquisto` VALUES (11,2,'Erikaing@live.it',NULL,150),(13,21,'Erikaing@live.it','50OFF',25),(14,15,'sofiacatalano@live.it','50OFF',25);
/*!40000 ALTER TABLE `acquisto` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci*/ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER ` controllo_posti_disponibili` BEFORE INSERT ON `acquisto` FOR EACH ROW BEGIN
    IF	(SELECT num_posti
         FROM pacchetto
         WHERE id = NEW.pacchetto) < 1
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'il pacchetto selezionato non è più \t\t\t\t\t\t\t\tdisponibile.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci*/ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `calcola_prezzo_totale` BEFORE INSERT ON `acquisto` FOR EACH ROW BEGIN
DECLARE prezzo_pacchetto DECIMAL(10,2);
DECLARE sconto DECIMAL(5,2);
SELECT costo INTO prezzo_pacchetto
FROM pacchetto WHERE id = NEW.pacchetto;
SELECT percentuale INTO sconto
FROM codice_promo WHERE codice = NEW.promo;
	IF sconto IS NOT NULL THEN 
SET NEW.prezzo_totale = prezzo_pacchetto - (prezzo_pacchetto / 100 * sconto);
	ELSE
		SET NEW.prezzo_totale = prezzo_pacchetto;
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci*/ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controllo_codice_usato` BEFORE INSERT ON `acquisto` FOR EACH ROW BEGIN
DECLARE x INT;
SELECT COUNT(*) INTO x
FROM acquisto 
WHERE promo = NEW.promo 
AND utente = NEW.utente;
IF x > 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Questo codice promo è già stato utilizzato da questo utente.';
    	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci*/ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `aggiorna_posti_disponibili` AFTER INSERT ON `acquisto` FOR EACH ROW BEGIN
UPDATE pacchetto
SET num_posti = num_posti - 1
WHERE id = NEW.pacchetto;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `artista`
--

DROP TABLE IF EXISTS `artista`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artista` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artista`
--

LOCK TABLES `artista` WRITE;
/*!40000 ALTER TABLE `artista` DISABLE KEYS */;
INSERT INTO `artista` VALUES (1,'Blanco','Cantante'),(2,'Ligabue','Cantante'),(3,'Vasco','Cantante'),(4,'Laura Pausini','Cantante'),(5,'Carla Fracci','Ballerino'),(6,'Davide Dato','Ballerino'),(7,'Katia Follesa','Comico'),(8,'Frank Matano','Comico'),(9,'I soldi spicci','Comico'),(10,'Alessandro Siani','Comico'),(11,'Giulia Ottonello','Attore'),(12,'Gianni Quillico','Attore');
/*!40000 ALTER TABLE `artista` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categoria`
--

DROP TABLE IF EXISTS `categoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `descrizione` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categoria`
--

LOCK TABLES `categoria` WRITE;
/*!40000 ALTER TABLE `categoria` DISABLE KEYS */;
INSERT INTO `categoria` VALUES (1,'Balletto'),(2,'Concerto'),(3,'Teatro'),(4,'Cabaret');
/*!40000 ALTER TABLE `categoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `codice_promo`
--

DROP TABLE IF EXISTS `codice_promo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `codice_promo` (
  `codice` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `percentuale` float NOT NULL,
  PRIMARY KEY (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `codice_promo`
--

LOCK TABLES `codice_promo` WRITE;
/*!40000 ALTER TABLE `codice_promo` DISABLE KEYS */;
INSERT INTO `codice_promo` VALUES ('50OFF',50),('FLASHSALE80',80),('SCONTO20',20),('SCONTO30',30),('WELCOME10',10),('WELCOME5',5);
/*!40000 ALTER TABLE `codice_promo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `counteventi`
--

DROP TABLE IF EXISTS `counteventi`;
/*!50001 DROP VIEW IF EXISTS `counteventi`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `counteventi` AS SELECT 
 1 AS `nome`,
 1 AS `numEventi`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `evento`
--

DROP TABLE IF EXISTS `evento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoria` int NOT NULL,
  `nome` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `data` datetime NOT NULL,
  `luogo` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appartiene` (`categoria`),
  CONSTRAINT `appartiene` FOREIGN KEY (`categoria`) REFERENCES `categoria` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evento`
--

LOCK TABLES `evento` WRITE;
/*!40000 ALTER TABLE `evento` DISABLE KEYS */;
INSERT INTO `evento` VALUES (1,1,'Lo schiaccianoci','2023-03-16 18:00:00','Milano'),(2,1,'Don Chisciot','2023-05-19 21:15:00','Londra'),(3,2,'Vibrazioni in Bianco e nero','2023-08-18 19:00:00','Roma'),(4,2,'La voce di Blanco','2023-07-16 17:00:00','Catania'),(5,2,'Laura Pausini in Concerto','2023-08-12 18:00:00','Bari'),(6,2,'Ligabue in roccia','2023-09-02 19:15:00','Modena'),(7,2,'Vasco per sempre','2023-10-02 18:30:00','Napoli'),(10,4,'Cabaret della luna piena','2023-05-16 22:00:00','Agrigento'),(11,4,'Risate e sorpese','2023-04-16 20:30:00','Messina'),(12,3,'Parliamo di donne','1997-03-16 19:45:00','Milano'),(13,3,'Cantando sotto la pioggia','2013-03-16 20:00:00','Roma');
/*!40000 ALTER TABLE `evento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `numacquisti`
--

DROP TABLE IF EXISTS `numacquisti`;
/*!50001 DROP VIEW IF EXISTS `numacquisti`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `numacquisti` AS SELECT 
 1 AS `acquistiEffettuati`,
 1 AS `utente`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `organizza`
--

DROP TABLE IF EXISTS `organizza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organizza` (
  `artista` int NOT NULL,
  `evento` int NOT NULL,
  PRIMARY KEY (`artista`,`evento`),
  KEY `organizzata` (`evento`),
  CONSTRAINT `organizzata` FOREIGN KEY (`evento`) REFERENCES `evento` (`id`),
  CONSTRAINT `organizzato` FOREIGN KEY (`artista`) REFERENCES `artista` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organizza`
--

LOCK TABLES `organizza` WRITE;
/*!40000 ALTER TABLE `organizza` DISABLE KEYS */;
INSERT INTO `organizza` VALUES (6,1),(5,2),(1,3),(1,4),(4,5),(2,6),(3,7),(7,10),(10,10),(8,11),(9,11),(12,12),(11,13);
/*!40000 ALTER TABLE `organizza` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacchetto`
--

DROP TABLE IF EXISTS `pacchetto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacchetto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evento` int NOT NULL,
  `tipologia` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `costo` float NOT NULL,
  `num_posti` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dispone` (`evento`),
  CONSTRAINT `dispone` FOREIGN KEY (`evento`) REFERENCES `evento` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacchetto`
--

LOCK TABLES `pacchetto` WRITE;
/*!40000 ALTER TABLE `pacchetto` DISABLE KEYS */;
INSERT INTO `pacchetto` VALUES (1,1,'Balconcino centrale',250,30),(2,1,'Balconcino laterale',150,0),(3,1,'Standard',60,400),(4,2,'Balconcino centrale',250,39),(5,2,'Balconcino laterale',140,59),(6,2,'Standard',45,700),(7,3,'PIT',45,2000),(8,3,'Tribuna',90,1000),(9,4,'PIT',50,2200),(10,4,'Tribuna',110,800),(11,5,'PIT',60,3000),(12,5,'Tribuna',1500,130),(13,6,'PIT',55,5000),(14,6,'Tribuna',120,1500),(15,7,'PIT',50,2498),(16,7,'Tribuna',95,1200),(17,10,'Standard',15,80),(18,10,'VIP',40,20),(19,11,'Standard',20,70),(20,11,'VIP',50,30),(21,12,'Basic',50,499),(22,12,'Pro',80,200),(23,13,'Basic',60,299),(24,13,'Pro',90,150);
/*!40000 ALTER TABLE `pacchetto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `utente`
--

DROP TABLE IF EXISTS `utente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `utente` (
  `email` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `nome` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `cognome` varchar(15) COLLATE utf8mb4_general_ci NOT NULL,
  `data_nascita` date NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `utente`
--

LOCK TABLES `utente` WRITE;
/*!40000 ALTER TABLE `utente` DISABLE KEYS */;
INSERT INTO `utente` VALUES ('aurorascrivano@outlook.com','Aurora','Scrivano','1996-03-07'),('Enzo.diletto@hotmail.it','Enzo','Diletto','1998-06-30'),('Erikaing@live.it','Erika','Ingegnoso','2005-12-15'),('Noemi.cauchi@gmail.com','Noemi','Cauchi','1987-03-17'),('Salvo.20@gmail.com','Salvatore','Sultano','2002-10-20'),('sofiacatalano@live.it','Sofia','Catalano','2002-06-14');
/*!40000 ALTER TABLE `utente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'organizzazione_eventi'
--

--
-- Dumping routines for database 'organizzazione_eventi'
--
/*!50003 DROP PROCEDURE IF EXISTS `codici non usati` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci*/ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `codici non usati`()
BEGIN
    SELECT codice
    FROM codice_promo 
    LEFT JOIN acquisto 
    ON codice = promo AND id IS NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `concerti Blanco` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci*/ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `concerti Blanco`()
BEGIN
    SELECT E.nome, E.data, E.luogo
    FROM categoria C
    JOIN evento E ON C.id = E.categoria
    JOIN organizza O ON E.id = O.evento
    JOIN artista A ON O.artista = A.id
    WHERE C.descrizione = 'Concerto'
    AND A.nome = 'Blanco';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `max eventi di artista` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci*/ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `max eventi di artista`()
BEGIN
SELECT *
FROM counteventi
WHERE numEventi >= (SELECT MAX(numEventi)
			        FROM counteventi);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `min acquisti di utente` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci*/ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `min acquisti di utente`()
BEGIN
SELECT U.email, U.nome, U.cognome, acquistiEffettuati
FROM utente U, numacquisti N
WHERE email = utente
AND acquistiEffettuati <= (SELECT MIN(acquistiEffettuati)
				     FROM numacquisti);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `counteventi`
--

/*!50001 DROP VIEW IF EXISTS `counteventi`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `counteventi` AS select `artista`.`nome` AS `nome`,count(0) AS `numEventi` from ((`organizza` join `evento`) join `artista`) where ((`organizza`.`evento` = `evento`.`id`) and (`organizza`.`artista` = `artista`.`id`)) group by `organizza`.`artista` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `numacquisti`
--

/*!50001 DROP VIEW IF EXISTS `numacquisti`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci*/;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `numacquisti` AS select count(0) AS `acquistiEffettuati`,`group by utente`.`utente` AS `utente` from `acquisto` `group by utente` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-03-30 11:55:03
