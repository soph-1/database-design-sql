-- =====================================================
-- Database: organizzazione_eventi
-- Progetto universitario: Gestione eventi e acquisti
-- =====================================================

CREATE DATABASE IF NOT EXISTS `organizzazione_eventi`
CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `organizzazione_eventi`;

-- =====================================================
-- Tabelle principali
-- =====================================================

-- 1. Utente
DROP TABLE IF EXISTS `utente`;
CREATE TABLE `utente` (
  `email` varchar(30) NOT NULL,
  `nome` varchar(15) NOT NULL,
  `cognome` varchar(15) NOT NULL,
  `data_nascita` date NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Codice promo
DROP TABLE IF EXISTS `codice_promo`;
CREATE TABLE `codice_promo` (
  `codice` varchar(20) NOT NULL,
  `percentuale` float NOT NULL,
  PRIMARY KEY (`codice`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Artista
DROP TABLE IF EXISTS `artista`;
CREATE TABLE `artista` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(20) NOT NULL,
  `tipo` varchar(15) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;

-- 4. Categoria
DROP TABLE IF EXISTS `categoria`;
CREATE TABLE `categoria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `descrizione` varchar(40) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

-- 5. Evento
DROP TABLE IF EXISTS `evento`;
CREATE TABLE `evento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoria` int NOT NULL,
  `nome` varchar(40) NOT NULL,
  `data` datetime NOT NULL,
  `luogo` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `appartiene` (`categoria`),
  CONSTRAINT `appartiene` FOREIGN KEY (`categoria`) REFERENCES `categoria` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4;

-- 6. Pacchetto
DROP TABLE IF EXISTS `pacchetto`;
CREATE TABLE `pacchetto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `evento` int NOT NULL,
  `tipologia` varchar(30) NOT NULL,
  `costo` float NOT NULL,
  `num_posti` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dispone` (`evento`),
  CONSTRAINT `dispone` FOREIGN KEY (`evento`) REFERENCES `evento` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;

-- 7. Acquisto
DROP TABLE IF EXISTS `acquisto`;
CREATE TABLE `acquisto` (
  `id` int NOT NULL AUTO_INCREMENT,
  `pacchetto` int NOT NULL,
  `utente` varchar(30) NOT NULL,
  `promo` varchar(15) DEFAULT NULL,
  `prezzo_totale` float DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `effettua` (`utente`),
  KEY `inserito` (`promo`),
  KEY `scelto` (`pacchetto`),
  CONSTRAINT `effettua` FOREIGN KEY (`utente`) REFERENCES `utente` (`email`),
  CONSTRAINT `inserito` FOREIGN KEY (`promo`) REFERENCES `codice_promo` (`codice`),
  CONSTRAINT `scelto` FOREIGN KEY (`pacchetto`) REFERENCES `pacchetto` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4;

-- 8. Organizza (associa artista-evento)
DROP TABLE IF EXISTS `organizza`;
CREATE TABLE `organizza` (
  `artista` int NOT NULL,
  `evento` int NOT NULL,
  PRIMARY KEY (`artista`,`evento`),
  KEY `organizzata` (`evento`),
  CONSTRAINT `organizzato` FOREIGN KEY (`artista`) REFERENCES `artista` (`id`),
  CONSTRAINT `organizzata` FOREIGN KEY (`evento`) REFERENCES `evento` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =====================================================
-- Insert dati di esempio
-- =====================================================

-- Utenti
INSERT INTO `utente` VALUES
('aurorascrivano@outlook.com','Aurora','Scrivano','1996-03-07'),
('Enzo.diletto@hotmail.it','Enzo','Diletto','1998-06-30'),
('Erikaing@live.it','Erika','Ingegnoso','2005-12-15'),
('Noemi.cauchi@gmail.com','Noemi','Cauchi','1987-03-17'),
('sofiacatalano@live.it','Sofia','Catalano','2002-06-14');

-- Codici promo
INSERT INTO `codice_promo` VALUES
('50OFF',50),('FLASHSALE80',80),('SCONTO20',20),('SCONTO30',30),('WELCOME10',10),('WELCOME5',5);

-- Artisti
INSERT INTO `artista` VALUES
(1,'Blanco','Cantante'),(2,'Ligabue','Cantante'),(3,'Vasco','Cantante'),
(4,'Laura Pausini','Cantante'),(5,'Carla Fracci','Ballerino'),(6,'Davide Dato','Ballerino'),
(7,'Katia Follesa','Comico'),(8,'Frank Matano','Comico'),(9,'I soldi spicci','Comico'),
(10,'Alessandro Siani','Comico'),(11,'Giulia Ottonello','Attore'),(12,'Gianni Quillico','Attore');

-- Categoria
INSERT INTO `categoria` VALUES
(1,'Balletto'),(2,'Concerto'),(3,'Teatro'),(4,'Cabaret');

-- Eventi (esempio)
INSERT INTO `evento` VALUES
(1,1,'Lo schiaccianoci','2023-03-16 18:00:00','Milano'),
(2,1,'Don Chisciot','2023-05-19 21:15:00','Londra'),
(3,2,'Vibrazioni in Bianco e nero','2023-08-18 19:00:00','Roma'),
(4,2,'La voce di Blanco','2023-07-16 17:00:00','Catania');

-- Pacchetti
INSERT INTO `pacchetto` VALUES
(1,1,'Balconcino centrale',250,30),
(2,1,'Balconcino laterale',150,0),
(3,1,'Standard',60,400);

-- Acquisti di esempio
INSERT INTO `acquisto` VALUES
(11,2,'Erikaing@live.it',NULL,150),
(13,21,'Erikaing@live.it','50OFF',25),
(14,15,'sofiacatalano@live.it','50OFF',25);

-- =====================================================
-- Trigger (puliti e funzionanti)
-- =====================================================

DELIMITER ;;
CREATE TRIGGER `controllo_posti_disponibili` BEFORE INSERT ON `acquisto`
FOR EACH ROW
BEGIN
    IF (SELECT num_posti FROM pacchetto WHERE id = NEW.pacchetto) < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Il pacchetto selezionato non è più disponibile.';
    END IF;
END;;
DELIMITER ;

DELIMITER ;;
CREATE TRIGGER `aggiorna_posti_disponibili` AFTER INSERT ON `acquisto`
FOR EACH ROW
BEGIN
    UPDATE pacchetto
    SET num_posti = num_posti - 1
    WHERE id = NEW.pacchetto;
END;;
DELIMITER ;

