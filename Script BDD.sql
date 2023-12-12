-- Création des tables

-- Table Etudiant
CREATE TABLE Etudiant (
    ID_Etudiant INT AUTO_INCREMENT PRIMARY KEY,
    Nom VARCHAR(191) NOT NULL,
    Prenom VARCHAR(191) NOT NULL,
    Date_Naissance DATE NOT NULL,
    Email VARCHAR(191) NOT NULL UNIQUE,
    Mot_de_Passe VARCHAR(191) NOT NULL,
    Filiere_ID INT,
    Interets TEXT,
    Photo_Profil BLOB,
    FOREIGN KEY (Filiere_ID) REFERENCES Filiere(ID_Filiere)
) DEFAULT CHARSET=utf8mb4;

-- Table Filiere
CREATE TABLE Filiere (
    ID_Filiere INT AUTO_INCREMENT PRIMARY KEY,
    Nom_Filiere VARCHAR(191) NOT NULL
) DEFAULT CHARSET=utf8mb4;

-- Table Match_Etudiants
CREATE TABLE Match_Etudiants (
    ID_Match INT AUTO_INCREMENT PRIMARY KEY,
    ID_Etudiant1 INT,
    ID_Etudiant2 INT,
    Date_Match DATETIME NOT NULL,
    FOREIGN KEY (ID_Etudiant1) REFERENCES Etudiant(ID_Etudiant),
    FOREIGN KEY (ID_Etudiant2) REFERENCES Etudiant(ID_Etudiant)
) DEFAULT CHARSET=utf8mb4;

-- Table Message
CREATE TABLE Message (
    ID_Message INT AUTO_INCREMENT PRIMARY KEY,
    ID_Expéditeur INT,
    ID_Destinataire INT,
    Contenu TEXT NOT NULL,
    Date_Envoi DATETIME NOT NULL,
    FOREIGN KEY (ID_Expéditeur) REFERENCES Etudiant(ID_Etudiant),
    FOREIGN KEY (ID_Destinataire) REFERENCES Etudiant(ID_Etudiant)
) DEFAULT CHARSET=utf8mb4;

-- Définition des fonctions

-- Fonction CalculAge
DELIMITER //
CREATE FUNCTION CalculAge(dateNaissance DATE) 
RETURNS INT
BEGIN
    DECLARE age INT;
    SET age = TIMESTAMPDIFF(YEAR, dateNaissance, CURDATE());
    RETURN age;
END //
DELIMITER ;

-- Fonction EmailValide
DELIMITER //
CREATE FUNCTION EmailValide(email VARCHAR(255)) 
RETURNS BOOLEAN
BEGIN
    DECLARE result BOOLEAN;
    SET result = email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';
    RETURN result;
END //
DELIMITER ;

-- Définition des triggers

-- Trigger VerifAgeInscription
DELIMITER //
CREATE TRIGGER VerifAgeInscription 
BEFORE INSERT ON Etudiant
FOR EACH ROW
BEGIN
    IF CalculAge(NEW.Date_Naissance) < 18 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L\'âge doit être supérieur ou égal à 18 ans.';
    END IF;
END //
DELIMITER ;

-- Trigger VerifEmailUniqueUpdate

DELIMITER //
CREATE TRIGGER VerifEmailUniqueUpdate
BEFORE UPDATE ON Etudiant
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Etudiant WHERE Email = NEW.Email AND ID_Etudiant != NEW.ID_Etudiant) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'L\'email doit être unique.';
    END IF;
END //
DELIMITER ;

-- Trigger VerifFormatEmailInscription

DELIMITER //
CREATE TRIGGER VerifFormatEmailInscription
BEFORE INSERT ON Etudiant
FOR EACH ROW
BEGIN
    IF NOT EmailValide(NEW.Email) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Format de l\'email invalide.';
    END IF;
END //
DELIMITER ;

