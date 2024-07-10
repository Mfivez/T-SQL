/** Ressources n�cessaires au module 2 :

Lors de la r�alisation des exercices de ce module vous aurez besoin d'utiliser la base de donn�es : "AdventureWorks2008R2".
Pour la t�l�charger et acc�der � cette base de donn�es vous aurez � l'int�grer dans le dossier backup de votre Microsoft SQL Server.

m�thodologie :
	1. Rendez-vous sur : https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms

	2. Ou alors t�l�charger directement depuis ce lien le fichier backup : 
				https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks2008r2/adventure-works-2008r2-oltp.bak

	3. Rendez vous dans le dossier backup :
		a. Appuyez sur Windows + R, un menu contextuel s'ouvrira.
		b. Trouver l'endroit ou vous avez installer Microsoft SQL Server, pour ma part : "C:\Program Files\Microsoft SQL Server"
		c. Ouvrez le dossier qui commence par MSSQL
		d. Ouvrez le dossier nomm� MSSQL
		e. Enfin ouvrez le dossier backup et d�posez-y le fichier de backup pr�c�demment t�l�charg�.

	4. Dans le programme SSMS maintenant :
		a. Faites un clique droit sur le dossier base de donn�es
		b. S�lectionnez Restaurer la base de donn�es...
		c. Selectionnez Support(Device) et puis cliquez sur les [...] pour parcourir vos dossiers.
		d. Cliquez sur ajouter et s�lectionnez le fichier de backup.
		e. Cliquez sur ok -> ok -> ok : Un message devrait normalement valider la bonne restauration de la base de donn�es !

Vous �tes fin pr�t pour ce module.

**/
USE AdventureWorks2008R2
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.1 
� l�aide de la commande � PRINT �, affichez le message � Le T-SQL, c�est bien pratique ! �
**/

PRINT 'Le T-SQL, c�est bien pratique !'

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.2 
Cr�er � pr�sent une variable de type � chaine de caract�res �.
Cette variable contiendra la phrase affich�e au point 2.1.
Afficher le contenu de la variable via la commande � PRINT �
**/

-- D�claration d'une variable @ma_var de type VARCHAR
DECLARE @ma_var VARCHAR(50)

-- Stockage d'une valeur de type VARCHAR dans cette variable via le mot-cl� SET
SET @ma_var = 'Le T-SQL, c�est bien pratique !'

PRINT @ma_var
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**   2.3  
D�clarer une variable qui contiendra le nombre d�employ�s de la table � Person.Person � de votre base de donn�es AdventureWorks2008R2.
Affichez le contenu de cette variable
**/

-- D�claration d'une variable @person_count de type INTEGER
DECLARE @person_count INTEGER

-- Affectation du r�sultat de la requ�te COUNT(*) � la variable @person_count
SELECT @person_count = COUNT(*) FROM Person.Person

-- Affichage du contenu de la variable � l'�cran
PRINT @person_count
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.4 
D�clarer une variable nomm�e � prenom_emp �, du m�me type que les valeurs de la colonne �
FirstName � de la table Person.Person.
Remplir cette variable avec le pr�nom de M. Eminhizer et afficher le contenu de la
variable.
V�rifier que cette valeur est bien � Terry �
**/

-- Pour connaitre le type de la colonne "FirstName", suivre le chemin suivant :
-- "Databases > AdventureWorks2008R2 > Tables > Person.Person > Columns"

-- D�claration d'une variable @prenom_emp de type nvarchar(50)
DECLARE @prenom_emp nvarchar(50)

-- S�lection du pr�nom (FirstName) de la table Person.Person o� LastName est 'Eminhizer'
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
-- Le code ainsi corrig� fonctionne mais n'affiche rien puisque les valeurs de @x, @y et donc de @z sont NULL
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.6 
Et dans ce cas-ci ?
**/

DECLARE
@x VARCHAR(50), -- Le type VARCHAR demande une pr�cision
@y VARCHAR(50),
@z INTeger -- Ligne correcte, puisque le T-SQL n'est pas case-sensitive

SET @x = 'La valeur de' ;
-- L'affectation d'une valeur se fait via la commande 'SET' ;
-- Le symbole d'affectation est le '=' et non le ':=' ;
-- Une chaine de caract�res est toujours plac�e entre guillemets simples

SET @y = @x + '@z' + ' est ' -- '@' manquant devant 'y'

PRINT @y + @z -- Le signe de concat�nation est le '+' non le '.'

-- Le message d'erreur obtenu est le suivant :
-- "Conversion failed when converting the varchar value 'La valeur de@z1 est ' to data type int."
-- Il concerne la derni�re ligne puisque nous essayons de faire une concat�nation entre une chaine de caract�res (@y) et un entier (@z)
-- Il faut convertir (CONVERT) la variable '@z' en chaine de caract�res :
PRINT @y + CONVERT (VARCHAR, @z)

-- De cette fa�on, il n'y a plus d'erreur, mais le contenu de '@z' �tant NULL, rien ne s'affiche
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.7 
Cr�er une variable nomm�e � date_du_jour � qui aura le format DATETIME et la valeur de la
date du jour. Afficher cette date.
**/

DECLARE @date_du_jour DATETIME
SET @date_du_jour = GETDATE ()
PRINT @date_du_jour

-- Ici pour affecter la date du jour on passe par l'utilisation d'une fonction d�j� existante dans ssms.
-- Plus loin dans les modules nous verrons comment cr�er nos propres fonctions r�utilisables avec leur propre utilit� !
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.8 
� l�aide de plusieurs variables, afficher la phrase
� M. [Nom] [Pr�nom] est l�employ� num�ro [ID de l�employ�], a �t� engag� le [date d�entr�e en service de l�employ�] et est un [homme/femme] �

Les informations dont vous avez besoin se trouvent dans les tables � Person.Person � et � HumanResources.Employee �
**/

-- Nous choisissons ici de traiter les donn�es de M. Eminhizer

-- D�claration des variables
DECLARE 
    @nom nvarchar(50),            
    @prenom nvarchar(50),         
    @id INTEGER,                  
    @date_embauche DATE,          
    @type nchar(1);               

-- S�lection des donn�es de l'employ�
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

-- Affichage des informations de l'employ�
PRINT ('M. ' + @nom + ' ' + @prenom + ' est l�employ� num�ro ' + CONVERT(VARCHAR, @id) + 
       ', a �t� engag� le ' + CONVERT(VARCHAR, @date_embauche) + 
       ' et est un ' + @type);
GO

-- Dans ce script :
-- - Les variables @nom, @prenom, @id, @date_embauche et @type sont utilis�es pour stocker les donn�es sp�cifiques de l'employ�.
-- - La clause SELECT attribue les valeurs correspondantes � ces variables en fonction du nom de famille 'Eminhizer'.
-- - Les informations r�cup�r�es sont ensuite concat�n�es dans une cha�ne de caract�res avec la commande PRINT pour afficher un message informatif sur l'employ�.

-- Explication de la jointure :
	-- La jointure utilis�e est une jointure INNER JOIN, sp�cifi�e par le mot-cl� JOIN.
	-- Elle relie les lignes de la table Person.Person avec celles de HumanResources.Employee
	-- en utilisant la clause ON PP.BusinessEntityID = HE.BusinessEntityID.

	-- Cela signifie que la jointure se fait sur la colonne BusinessEntityID, qui est une cl� �trang�re
	-- reliant les tables Person.Person et HumanResources.Employee.

	-- Lorsque vous utilisez PP.BusinessEntityID = HE.BusinessEntityID dans la clause ON,
	-- cela signifie que seules les lignes o� les valeurs de BusinessEntityID sont identiques dans les deux tables seront jointes ensemble.
	-- Dans ce cas, la jointure garantit que chaque enregistrement s�lectionn� a un correspondant dans l'autre table,
	-- permettant ainsi de r�cup�rer les informations compl�tes de l'employ� ayant le nom de famille 'Eminhizer'.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.9 
Cr�er une variable enti�re contenant votre �ge.
Cr�er une seconde variable de type chaine de caract�res, contenant votre nom.

Afficher maintenant la concat�nation de ces variables.
Cette op�ration pose-t-elle probl�me ? Avez-vous utilis� la fonction CONVERT dans ce cas ?
Aurait-elle �t� utile ? Si vous ne l�avez pas utilis�e, n�h�sitez pas � la faire ! Cela change-t-il la r�ponse ?
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
-- Lorsque le syst�me rencontre des entiers entour�s de symboles '+' il essaye automatiquement de faire une addition
-- Afin de forcer la concat�nation, il faut convertir toutes les valeurs qui ne sont pas des chaines de caract�res dans le bon format

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.10 
G�n�rer 3 variables enti�res.
Afficher l�addition de ces trois variables dans une table temporaire.
La colonne utilis�e pour l�affichage aura pour nom � R�sultat �
**/

DECLARE 
	@entier1 INTEGER, 
	@entier2 INTEGER, 
	@entier3 INTEGER

SET @entier1 = 18
SET @entier2 = 40
SET @entier3 = 11

SELECT ( @entier1 + @entier2 + @entier3 ) 
AS 'R�sultat' 
INTO #tab_result

SELECT * FROM #tab_result

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.11 
Cr�er des variables pour contenir les donn�es des colonnes � BusinessEntityID �, � JobTitle �
et � BirthDate � de la table HumanResources.Employee.

Afficher [BusinessEntityID] + ' ' + [JobTitle] + ' ' + [BirthDate]

Cela affiche-t-il le r�sultat attendu ? Comment r�soudre ce probl�me ?
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

-- Erreur renvoy�e pour le PRINT : -- "Operand type clash: date is incompatible with int"

-- Des symbole '+' incitent le serveur � essayer une addition. Les types "varchar" cr�ent donc des erreur
-- Utiliser un CONVERT sur les valeur diff�rente du VARCHAR r�soud le soucis

PRINT ( CONVERT (VARCHAR, @BEID) + ' ' + @nom_job + ' ' + CONVERT (VARCHAR, @b_day) )
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.12 
D�clarer une table temporaire qui contiendra les donn�es issues des colonnes Title, FirstName et LastName de la table Person.Person.
**/

CREATE TABLE #tab_copy_PP (
    Title nvarchar(8), 
    FirstName nvarchar(50),
    LastName nvarchar(50)
);

/** 
    Ins�rer les donn�es dans la table temporaire. 
    Afficher l�ensemble des donn�es de la table.
**/

-- Insertion des donn�es de Person.Person dans la table temporaire #tab_copy_PP
INSERT INTO #tab_copy_PP (Title, FirstName, LastName)
SELECT 
    Title, 
    FirstName, 
    LastName 
FROM 
    Person.Person;

-- S�lection de toutes les donn�es de la table temporaire #tab_copy_PP
SELECT * FROM #tab_copy_PP;

/** 
    D�connectez-vous de SQLServer et reconnectez-vous. 
    La table temporaire existe-t-elle toujours ?
**/

-- Les tables temporaires cr��es avec un # sont automatiquement supprim�es � la fin de la session de connexion.
-- Donc, apr�s la d�connexion et la reconnexion, la table temporaire #tab_copy_PP ne devrait plus exister.

/** 
    A la fin de l�exercice, supprimer la table cr��e.
**/
DROP TABLE #tab_copy_PP;

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.13 
D�clarer une variable temporaire de type table qui aura pour colonnes � TitreJob �, � DateEmbauche �, � HeuresVacances � et � HeuresMaladie �.
Remplir cette variable avec les donn�es de tous les Techniciens de production WC60 de la table HumanResources.Employee.
Afficher le contenu de cette table gr�ce � un select.
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
Afficher maintenant les donn�es de la variable de type table de l�exercice pr�c�dent dans une table.
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
D�clarer une table temporaire qui contiendra une colonne contenant le mois de naissance,
une 2�me contenant le nom, une 3�me le pr�nom et une derni�re la ville o� r�sident 5 de vos connaissances.
Remplir cette table avec les donn�es attendues.
**/

CREATE TABLE #tab_naissance (
    mois_naiss nvarchar(50),
    nom nvarchar(50),
    prenom nvarchar(50),
    ville nvarchar(50)
);


INSERT INTO #tab_naissance 
VALUES 
    ('Avril', 'Faulkner', 'St�phane', 'Bruxelles'),
    ('Juin', 'Person', 'Michael', 'Charleroi'),
    ('Septembre', 'Moore', 'Thierry', 'Ecaussine'),
    ('D�cembre', 'Herssens', 'Caroline', 'Louvain-la-Neuve'),
    ('Octobre', 'Meurice', 'Maxime', 'Namur');

SELECT * FROM #tab_naissance;

/**    
D�clarer une variable qui permettra de copier toutes les donn�es de la table temporaire
que vous venez de cr�er, y transf�rer les donn�es qu�elle contient et afficher le contenu de la table temporaire et de la variable.
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
Modifier les 2 premi�res lignes de votre table temporaire avec les donn�es de deux autres personnes.
**/

-- Mise � jour des 2 premi�res lignes de la table temporaire #tab_naissance

UPDATE #tab_naissance 
SET mois_naiss = 'JANVIER' 
WHERE nom = 'Faulkner';

UPDATE #tab_naissance 
SET mois_naiss = 'NOVEMBRE' 
WHERE nom = 'Person';

-- Affichage du contenu mis � jour de la table temporaire #tab_naissance
SELECT * 
FROM #tab_naissance;

-- Affichage apr�s modification
SELECT * 
FROM @tab_naissance;

/*
Les donn�es ont-elles �t� modifi�es aux deux endroits simultan�ment ? Pourquoi ?
	-> Les donn�es n'ont �t� modifi�es que dans la table temporaire '#tab_naissance'. 
	
	Les tables temporaires et les variables temporaires ne sont pas li�es implicitement, 
	m�me si leur structure et leur contenu initial sont identiques.
*/

-- Les tables temporaires ne sont accessibles que dans le contexte de la session actuelle.
-- Pour v�rifier si les donn�es existent toujours apr�s d�connexion et reconnexion, 
-- il faudrait ex�cuter le script dans un nouvel environnement de session.

DROP TABLE #tab_naissance;

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    2.16 
Quel est le nom de chacun des techniciens de productions WC60 ?
R�cup�rer leur nom, pr�nom et leur job dans une variable temporaire dont on affiche le r�sultat dans une table temporaire.
**/

-- D�claration d'une variable temporaire de type table @tab_info_techWC60 pour stocker les informations des techniciens WC60
DECLARE @tab_info_techWC60 TABLE (
    nom nvarchar(50),
    prenom nvarchar(50),
    job nvarchar(50)
);

-- Cr�ation de la table temporaire #tab_copy_info_TechWC60 pour copier les donn�es de la variable temporaire
CREATE TABLE #tab_copy_info_TechWC60 (
    copy_nom nvarchar(50),
    copy_prenom nvarchar(50),
    copy_job nvarchar(50)
);

-- Insertion des donn�es des techniciens de production WC60 dans la variable temporaire @tab_info_techWC60

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

-- Insertion des donn�es de la variable temporaire @tab_info_techWC60 dans la table temporaire #tab_copy_info_TechWC60
INSERT INTO #tab_copy_info_TechWC60 (copy_nom, copy_prenom, copy_job)
SELECT * FROM @tab_info_techWC60;

-- Affichage du contenu de la table temporaire
SELECT * FROM #tab_copy_info_TechWC60;

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------
