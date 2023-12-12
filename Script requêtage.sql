-- Requête 1 : Sélectionner tous les étudiants
SELECT * FROM Etudiant;

-- Requête 2 : Trouver un étudiant par son nom
SELECT * FROM Etudiant WHERE Nom = 'Dupont';

-- Requête 3 : Lister tous les étudiants d'une filière spécifique
SELECT * FROM Etudiant WHERE Filiere_ID = (SELECT ID_Filiere FROM Filiere WHERE Nom_Filiere = 'Informatique');

-- Requête 4 : Mettre à jour l'adresse e-mail d'un étudiant
UPDATE Etudiant SET Email = 'nouveau.email@example.com' WHERE ID_Etudiant = 1;

-- Requête 5 : Supprimer un étudiant de la base de données
DELETE FROM Etudiant WHERE ID_Etudiant = 1;

-- Requête 6 : Compter le nombre total d'étudiants
SELECT COUNT(*) FROM Etudiant;

-- Requête 7 : Rechercher les étudiants ayant un intérêt spécifique
SELECT * FROM Etudiant WHERE Interets LIKE '%musique%';

-- Requête 8 : Lister tous les matchs d'un étudiant donné
SELECT * FROM Match_Etudiants WHERE ID_Etudiant1 = 1 OR ID_Etudiant2 = 1;

-- Requête 9 : Trouver l'âge d'un étudiant spécifique
SELECT CalculAge(Date_Naissance) AS Age FROM Etudiant WHERE ID_Etudiant = 1;

-- Requête 10 : Afficher les noms des filières
SELECT Nom_Filiere FROM Filiere;

-- Requête 11 : Trouver les étudiants dont l'adresse e-mail est invalide
SELECT * FROM Etudiant WHERE NOT EmailValide(Email);

-- Requête 12 : Lister les 5 derniers messages reçus par un étudiant
SELECT * FROM Message WHERE ID_Destinataire = 1 ORDER BY Date_Envoi DESC LIMIT 5;

-- Requête 13 : Insérer un nouveau étudiant
INSERT INTO Etudiant (Nom, Prenom, Date_Naissance, Email, Mot_de_Passe, Filiere_ID, Interets) VALUES ('Moreau', 'Julie', '1995-04-12', 'julie.moreau@example.com', 'password123', 2, 'Cinéma, Lecture');

-- Requête 14 : Afficher le nom complet et l'âge de chaque étudiant
SELECT Nom, Prenom, CalculAge(Date_Naissance) AS Age FROM Etudiant;

-- Requête 15 : Mettre à jour les intérêts d'un étudiant
UPDATE Etudiant SET Interets = 'Musique, Sport' WHERE ID_Etudiant = 1;

-- Requête 16 : Trouver tous les matchs effectués au cours du dernier mois
SELECT * FROM Match_Etudiants WHERE Date_Match > DATE_SUB(NOW(), INTERVAL 1 MONTH);

-- Requête 17 : Lister tous les étudiants n'ayant pas de match
SELECT * FROM Etudiant WHERE ID_Etudiant NOT IN (SELECT ID_Etudiant1 FROM Match_Etudiants) AND ID_Etudiant NOT IN (SELECT ID_Etudiant2 FROM Match_Etudiants);

-- Requête 18 : Afficher les étudiants et leur filière respective
SELECT E.Nom, E.Prenom, F.Nom_Filiere FROM Etudiant E JOIN Filiere F ON E.Filiere_ID = F.ID_Filiere;

-- Requête 19 : Trouver le nombre de matchs pour chaque étudiant
SELECT 
    ID_Etudiant, 
    COUNT(ID_Match) AS Nombre_Matchs 
FROM 
    (SELECT 
         ID_Etudiant1 AS ID_Etudiant, 
         ID_Match 
     FROM Match_Etudiants 
     UNION ALL 
     SELECT 
         ID_Etudiant2, 
         ID_Match 
     FROM Match_Etudiants) AS Matches 
GROUP BY ID_Etudiant;

-- Requête 20 : Obtenir un aperçu des interactions entre les étudiants, leurs filières, leurs matchs et leurs messages
SELECT 
    E1.Nom AS Nom_Etudiant1, 
    E1.Prenom AS Prenom_Etudiant1, 
    F1.Nom_Filiere AS Filiere_Etudiant1, 
    E2.Nom AS Nom_Etudiant2, 
    E2.Prenom AS Prenom_Etudiant2, 
    F2.Nom_Filiere AS Filiere_Etudiant2, 
    M.Date_Match, 
    MSG.Contenu AS Dernier_Message, 
    MSG.Date_Envoi AS Date_Dernier_Message
FROM 
    Match_Etudiants M
JOIN Etudiant E1 ON M.ID_Etudiant1 = E1.ID_Etudiant
JOIN Etudiant E2 ON M.ID_Etudiant2 = E2.ID_Etudiant
JOIN Filiere F1 ON E1.Filiere_ID = F1.ID_Filiere
JOIN Filiere F2 ON E2.Filiere_ID = F2.ID_Filiere
LEFT JOIN (
    SELECT 
        ID_Expéditeur, 
        ID_Destinataire, 
        Contenu, 
        Date_Envoi, 
        ROW_NUMBER() OVER (PARTITION BY ID_Expéditeur, ID_Destinataire ORDER BY Date_Envoi DESC) AS rn
    FROM Message
) MSG ON (MSG.ID_Expéditeur = E1.ID_Etudiant AND MSG.ID_Destinataire = E2.ID_Etudiant AND MSG.rn = 1)
ORDER BY M.Date_Match DESC;
