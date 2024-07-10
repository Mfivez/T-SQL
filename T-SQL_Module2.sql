/** Ressources nécessaires au module 2 :

Lors de la réalisation des exercices de ce module vous aurez besoin d'utiliser la base de données : "AdventureWorks2008R2".
Pour la télécharger et accéder à cette base de données vous aurez à l'intégrer dans le dossier backup de votre Microsoft SQL Server.

méthodologie :
	1. Rendez-vous sur : https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms

	2. Ou alors télécharger directement depuis ce lien le fichier backup : 
				https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks2008r2/adventure-works-2008r2-oltp.bak

	3. Rendez vous dans le dossier backup :
		a. Appuyez sur Windows + R, un menu contextuel s'ouvrira.
		b. Trouver l'endroit ou vous avez installer Microsoft SQL Server, pour ma part : "C:\Program Files\Microsoft SQL Server"
		c. Ouvrez le dossier qui commence par MSSQL
		d. Ouvrez le dossier nommé MSSQL
		e. Enfin ouvrez le dossier backup et déposez-y le fichier de backup précédemment téléchargé.

	4. Dans le programme SSMS maintenant :
		a. Faites un clique droit sur le dossier base de données
		b. Sélectionnez Restaurer la base de données...
		c. Selectionnez Support(Device) et puis cliquez sur les [...] pour parcourir vos dossiers.
		d. Cliquez sur ajouter et sélectionnez le fichier de backup.
		e. Cliquez sur ok -> ok -> ok : Un message devrait normalement valider la bonne restauration de la base de données !

Vous êtes fin prêt pour ce module.

**/
USE AdventureWorks2008R2
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.1 
À l’aide de la commande « PRINT », affichez le message « Le T-SQL, c’est bien pratique ! »
**/

PRINT 'Le T-SQL, c’est bien pratique !'

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.2 
Créer à présent une variable de type « chaine de caractères ».
Cette variable contiendra la phrase affichée au point 2.1.
Afficher le contenu de la variable via la commande « PRINT »
**/

-- Déclaration d'une variable @ma_var de type VARCHAR
DECLARE @ma_var VARCHAR(50)

-- Stockage d'une valeur de type VARCHAR dans cette variable via le mot-clé SET
SET @ma_var = 'Le T-SQL, c’est bien pratique !'

PRINT @ma_var
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**   2.3  
Déclarer une variable qui contiendra le nombre d’employés de la table « Person.Person » de votre base de données AdventureWorks2008R2.
Affichez le contenu de cette variable
**/

-- Déclaration d'une variable @person_count de type INTEGER
DECLARE @person_count INTEGER

-- Affectation du résultat de la requête COUNT(*) à la variable @person_count
SELECT @person_count = COUNT(*) FROM Person.Person

-- Affichage du contenu de la variable à l'écran
PRINT @person_count
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.4 
Déclarer une variable nommée « prenom_emp », du même type que les valeurs de la colonne «
FirstName » de la table Person.Person.
Remplir cette variable avec le prénom de M. Eminhizer et afficher le contenu de la
variable.
Vérifier que cette valeur est bien « Terry »
**/

-- Pour connaitre le type de la colonne "FirstName", suivre le chemin suivant :
-- "Databases > AdventureWorks2008R2 > Tables > Person.Person > Columns"

-- Déclaration d'une variable @prenom_emp de type nvarchar(50)
DECLARE @prenom_emp nvarchar(50)

-- Sélection du prénom (FirstName) de la table Person.Person où LastName est 'Eminhizer'
SELECT @prenom_emp = FirstName 
FROM Person.Person 
WHERE LastName = 'Eminhizer'

PRINT @prenom_emp
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.5 
Soit le code suivant. Que doit-il donner ? Fonctionne-t-il et sinon, pourquoi ?
**/
DECLARE
@x int,
@y int, -- Virgule manquante en fin de ligne
@z varchar -- '@' manquant devant le 'z' pour en faire une variable
set @z = @x + @y -- Le signe '=' simple sert d'affectation et non '==' ;

--'@' manquant devant 'x' et 'y'
PRINT @z
-- Le code ainsi corrigé fonctionne mais n'affiche rien puisque les valeurs de @x, @y et donc de @z sont NULL
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.6 
Et dans ce cas-ci ?
**/

DECLARE
@x VARCHAR(50), -- Le type VARCHAR demande une précision
@y VARCHAR(50),
@z INTeger -- Ligne correcte, puisque le T-SQL n'est pas case-sensitive

SET @x = 'La valeur de' ;
-- L'affectation d'une valeur se fait via la commande 'SET' ;
-- Le symbole d'affectation est le '=' et non le ':=' ;
-- Une chaine de caractères est toujours placée entre guillemets simples

SET @y = @x + '@z' + ' est ' -- '@' manquant devant 'y'

PRINT @y + @z -- Le signe de concaténation est le '+' non le '.'

-- Le message d'erreur obtenu est le suivant :
-- "Conversion failed when converting the varchar value 'La valeur de@z1 est ' to data type int."
-- Il concerne la dernière ligne puisque nous essayons de faire une concaténation entre une chaine de caractères (@y) et un entier (@z)
-- Il faut convertir (CONVERT) la variable '@z' en chaine de caractères :
PRINT @y + CONVERT (VARCHAR, @z)

-- De cette façon, il n'y a plus d'erreur, mais le contenu de '@z' étant NULL, rien ne s'affiche
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.7 
Créer une variable nommée « date_du_jour » qui aura le format DATETIME et la valeur de la
date du jour. Afficher cette date.
**/

DECLARE @date_du_jour DATETIME
SET @date_du_jour = GETDATE ()
PRINT @date_du_jour

-- Ici pour affecter la date du jour on passe par l'utilisation d'une fonction déjà existante dans ssms.
-- Plus loin dans les modules nous verrons comment créer nos propres fonctions réutilisables avec leur propre utilité !
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.8 
À l’aide de plusieurs variables, afficher la phrase
« M. [Nom] [Prénom] est l’employé numéro [ID de l’employé], a été engagé le [date d’entrée en service de l’employé] et est un [homme/femme] »

Les informations dont vous avez besoin se trouvent dans les tables « Person.Person » et « HumanResources.Employee »
**/

-- Nous choisissons ici de traiter les données de M. Eminhizer

-- Déclaration des variables
DECLARE 
    @nom nvarchar(50),            
    @prenom nvarchar(50),         
    @id INTEGER,                  
    @date_embauche DATE,          
    @type nchar(1);               

-- Sélection des données de l'employé
SELECT 
    @nom = PP.LastName,          
    @prenom = PP.FirstName,      
    @id = PP.BusinessEntityID,   
    @date_embauche = HE.HireDate,
    @type = HE.Gender            
FROM 
    Person.Person PP             
JOIN 
    HumanResources.Employee HE   
ON 
    PP.BusinessEntityID = HE.BusinessEntityID  

WHERE 
    PP.LastName LIKE 'Eminhizer';  

-- Affichage des informations de l'employé
PRINT ('M. ' + @nom + ' ' + @prenom + ' est l’employé numéro ' + CONVERT(VARCHAR, @id) + 
       ', a été engagé le ' + CONVERT(VARCHAR, @date_embauche) + 
       ' et est un ' + @type);
GO

-- Dans ce script :
-- - Les variables @nom, @prenom, @id, @date_embauche et @type sont utilisées pour stocker les données spécifiques de l'employé.
-- - La clause SELECT attribue les valeurs correspondantes à ces variables en fonction du nom de famille 'Eminhizer'.
-- - Les informations récupérées sont ensuite concaténées dans une chaîne de caractères avec la commande PRINT pour afficher un message informatif sur l'employé.

-- Explication de la jointure :
	-- La jointure utilisée est une jointure INNER JOIN, spécifiée par le mot-clé JOIN.
	-- Elle relie les lignes de la table Person.Person avec celles de HumanResources.Employee
	-- en utilisant la clause ON PP.BusinessEntityID = HE.BusinessEntityID.

	-- Cela signifie que la jointure se fait sur la colonne BusinessEntityID, qui est une clé étrangère
	-- reliant les tables Person.Person et HumanResources.Employee.

	-- Lorsque vous utilisez PP.BusinessEntityID = HE.BusinessEntityID dans la clause ON,
	-- cela signifie que seules les lignes où les valeurs de BusinessEntityID sont identiques dans les deux tables seront jointes ensemble.
	-- Dans ce cas, la jointure garantit que chaque enregistrement sélectionné a un correspondant dans l'autre table,
	-- permettant ainsi de récupérer les informations complètes de l'employé ayant le nom de famille 'Eminhizer'.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.9 
Créer une variable entière contenant votre âge.
Créer une seconde variable de type chaine de caractères, contenant votre nom.

Afficher maintenant la concaténation de ces variables.
Cette opération pose-t-elle problème ? Avez-vous utilisé la fonction CONVERT dans ce cas ?
Aurait-elle été utile ? Si vous ne l’avez pas utilisée, n’hésitez pas à la faire ! Cela change-t-il la réponse ?
**/

DECLARE 
	@mon_age INTEGER, 
	@mon_nom VARCHAR(10)

SET @mon_age = 120
SET @mon_nom = 'Inconito'
PRINT (@mon_nom + ', ' + CONVERT (VARCHAR, @mon_age) + ' ans.')

GO
-- Sans le convert, l'erreur suivante apparait, elle concerne la ligne du PRINT :
-- 'Conversion failed when converting the varchar value 'Inconito, ' to data type int.'
-- Lorsque le système rencontre des entiers entourés de symboles '+' il essaye automatiquement de faire une addition
-- Afin de forcer la concaténation, il faut convertir toutes les valeurs qui ne sont pas des chaines de caractères dans le bon format

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.10 
Générer 3 variables entières.
Afficher l’addition de ces trois variables dans une table temporaire.
La colonne utilisée pour l’affichage aura pour nom « Résultat »
**/

DECLARE 
	@entier1 INTEGER, 
	@entier2 INTEGER, 
	@entier3 INTEGER

SET @entier1 = 18
SET @entier2 = 40
SET @entier3 = 11

SELECT ( @entier1 + @entier2 + @entier3 ) 
AS 'Résultat' 
INTO #tab_result

SELECT * FROM #tab_result

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.11 
Créer des variables pour contenir les données des colonnes « BusinessEntityID », « JobTitle »
et « BirthDate » de la table HumanResources.Employee.

Afficher [BusinessEntityID] + ' ' + [JobTitle] + ' ' + [BirthDate]

Cela affiche-t-il le résultat attendu ? Comment résoudre ce problème ?
**/

-- Pour M. Eminhizer :
DECLARE 
	@BEID INT, 
	@nom_job nvarchar(50), 
	@b_day DATE

SELECT 
	@BEID = HE.BusinessEntityID, 
	@nom_job = HE.JobTitle, 
	@b_day = HE.BirthDate

FROM 
	Person.Person PP 
JOIN 
	HumanResources.Employee HE 
ON
	PP.BusinessEntityID = HE.BusinessEntityID
WHERE 
	PP.LastName LIKE 'Eminhizer'

PRINT (@BEID + ' ' + @nom_job + ' ' + @b_day)

-- Erreur renvoyée pour le PRINT : -- "Operand type clash: date is incompatible with int"

-- Des symbole '+' incitent le serveur à essayer une addition. Les types "varchar" créent donc des erreur
-- Utiliser un CONVERT sur les valeur différente du VARCHAR résoud le soucis

PRINT ( CONVERT (VARCHAR, @BEID) + ' ' + @nom_job + ' ' + CONVERT (VARCHAR, @b_day) )
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.12 
Déclarer une table temporaire qui contiendra les données issues des colonnes Title, FirstName et LastName de la table Person.Person.
**/

CREATE TABLE #tab_copy_PP (
    Title nvarchar(8), 
    FirstName nvarchar(50),
    LastName nvarchar(50)
);

/** 
    Insérer les données dans la table temporaire. 
    Afficher l’ensemble des données de la table.
**/

-- Insertion des données de Person.Person dans la table temporaire #tab_copy_PP
INSERT INTO #tab_copy_PP (Title, FirstName, LastName)
SELECT 
    Title, 
    FirstName, 
    LastName 
FROM 
    Person.Person;

-- Sélection de toutes les données de la table temporaire #tab_copy_PP
SELECT * FROM #tab_copy_PP;

/** 
    Déconnectez-vous de SQLServer et reconnectez-vous. 
    La table temporaire existe-t-elle toujours ?
**/

-- Les tables temporaires créées avec un # sont automatiquement supprimées à la fin de la session de connexion.
-- Donc, après la déconnexion et la reconnexion, la table temporaire #tab_copy_PP ne devrait plus exister.

/** 
    A la fin de l’exercice, supprimer la table créée.
**/
DROP TABLE #tab_copy_PP;

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.13 
Déclarer une variable temporaire de type table qui aura pour colonnes « TitreJob », « DateEmbauche », « HeuresVacances » et « HeuresMaladie ».
Remplir cette variable avec les données de tous les Techniciens de production WC60 de la table HumanResources.Employee.
Afficher le contenu de cette table grâce à un select.
**/


DECLARE @tab_WC60 TABLE (
    TitreJob nvarchar(50),
    DateEmbauche DATE,
    HeuresVacances smallint,
    HeuresMaladie smallint
)

INSERT INTO @tab_WC60 (
	TitreJob, 
	DateEmbauche, 
	HeuresVacances, 
	HeuresMaladie
)

SELECT 
    JobTitle,
    HireDate,
    VacationHours,
    SickLeaveHours
FROM 
    HumanResources.Employee
WHERE 
    JobTitle LIKE 'Production Technician - WC60'; 

SELECT * FROM @tab_WC60;

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.14 
Afficher maintenant les données de la variable de type table de l’exercice précédent dans une table.
**/

CREATE TABLE #tab_temp_WC60 (
	TitreJob nvarchar(50), 
	DateEmbauche DATE, 
	HeuresVacances smallint, 
	HeuresMaladie smallint
)

INSERT INTO #tab_temp_WC60 
SELECT * FROM @tab_WC60

SELECT * FROM #tab_temp_WC60

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.15 
Déclarer une table temporaire qui contiendra une colonne contenant le mois de naissance,
une 2ème contenant le nom, une 3ème le prénom et une dernière la ville où résident 5 de vos connaissances.
Remplir cette table avec les données attendues.
**/

CREATE TABLE #tab_naissance (
    mois_naiss nvarchar(50),
    nom nvarchar(50),
    prenom nvarchar(50),
    ville nvarchar(50)
);


INSERT INTO #tab_naissance 
VALUES 
    ('Avril', 'Faulkner', 'Stéphane', 'Bruxelles'),
    ('Juin', 'Person', 'Michael', 'Charleroi'),
    ('Septembre', 'Moore', 'Thierry', 'Ecaussine'),
    ('Décembre', 'Herssens', 'Caroline', 'Louvain-la-Neuve'),
    ('Octobre', 'Meurice', 'Maxime', 'Namur');

SELECT * FROM #tab_naissance;

/**    
Déclarer une variable qui permettra de copier toutes les données de la table temporaire
que vous venez de créer, y transférer les données qu’elle contient et afficher le contenu de la table temporaire et de la variable.
**/


DECLARE @tab_naissance TABLE (
    mois_naiss nvarchar(50),
    nom nvarchar(50),
    prenom nvarchar(50),
    ville nvarchar(50)
);

-- Insertion dans la table 
INSERT INTO @tab_naissance
SELECT * FROM #tab_naissance;

-- Affichage
SELECT * FROM #tab_naissance
SELECT * FROM @tab_naissance

/**    
Modifier les 2 premières lignes de votre table temporaire avec les données de deux autres personnes.
**/

-- Mise à jour des 2 premières lignes de la table temporaire #tab_naissance

UPDATE #tab_naissance 
SET mois_naiss = 'JANVIER' 
WHERE nom = 'Faulkner';

UPDATE #tab_naissance 
SET mois_naiss = 'NOVEMBRE' 
WHERE nom = 'Person';

-- Affichage du contenu mis à jour de la table temporaire #tab_naissance
SELECT * 
FROM #tab_naissance;

-- Affichage après modification
SELECT * 
FROM @tab_naissance;

/*
Les données ont-elles été modifiées aux deux endroits simultanément ? Pourquoi ?
	-> Les données n'ont été modifiées que dans la table temporaire '#tab_naissance'. 
	
	Les tables temporaires et les variables temporaires ne sont pas liées implicitement, 
	même si leur structure et leur contenu initial sont identiques.
*/

-- Les tables temporaires ne sont accessibles que dans le contexte de la session actuelle.
-- Pour vérifier si les données existent toujours après déconnexion et reconnexion, 
-- il faudrait exécuter le script dans un nouvel environnement de session.

DROP TABLE #tab_naissance;

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.16 
Quel est le nom de chacun des techniciens de productions WC60 ?
Récupérer leur nom, prénom et leur job dans une variable temporaire dont on affiche le résultat dans une table temporaire.
**/

-- Déclaration d'une variable temporaire de type table @tab_info_techWC60 pour stocker les informations des techniciens WC60
DECLARE @tab_info_techWC60 TABLE (
    nom nvarchar(50),
    prenom nvarchar(50),
    job nvarchar(50)
);

-- Création de la table temporaire #tab_copy_info_TechWC60 pour copier les données de la variable temporaire
CREATE TABLE #tab_copy_info_TechWC60 (
    copy_nom nvarchar(50),
    copy_prenom nvarchar(50),
    copy_job nvarchar(50)
);

-- Insertion des données des techniciens de production WC60 dans la variable temporaire @tab_info_techWC60

INSERT INTO @tab_info_techWC60 (nom, prenom, job)
SELECT 
    PP.LastName, 
    PP.FirstName, 
    HE.JobTitle
FROM 
    Person.Person PP
JOIN 
    HumanResources.Employee HE ON PP.BusinessEntityID = HE.BusinessEntityID
WHERE 
    HE.JobTitle LIKE 'Production Technician - WC60';

-- Insertion des données de la variable temporaire @tab_info_techWC60 dans la table temporaire #tab_copy_info_TechWC60
INSERT INTO #tab_copy_info_TechWC60 (copy_nom, copy_prenom, copy_job)
SELECT * FROM @tab_info_techWC60;

-- Affichage du contenu de la table temporaire
SELECT * FROM #tab_copy_info_TechWC60;

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------
