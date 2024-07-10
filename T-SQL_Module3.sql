/**
Pour l'installation de la backup d'AdventureWork nécessaire à ce module,
voir l'introduction du module 2

**/

USE AdventureWorks2008R2
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    3.1 
Pour l’employé numéro 21 de la table HumanResources.Employee, examinez sa date d’arrivée dans l’entreprise ainsi que sa date de naissance. 
Si son ancienneté est de plus de 9 ans, afficher la phrase :
	« L’employé 21 est un Senior ». Sinon, il faudra signaler qu’il s’agit d’un Junior.
**/

DECLARE 
	@date_arrivee DATE, 
	@date_naiss DATE

-- Sélection des dates de HireDate et BirthDate pour l'employé numéro 21
SELECT 
	@date_arrivee = HireDate , 
	@date_naiss = BirthDate
FROM 
	HumanResources.Employee
WHERE 
	BusinessEntityID = 21

-- La fonction DATEDIFF permet de faire une comparaison entre 2 dates :
	-- Le 1 er élément qu'on lui fournit (YEAR) spécifie sur quelle partie de la date la comparaison aura lieu
	-- Le 2ème et le 3 ème sont les 2 dates que l'on va comparer.
-- Si on lit littéralement la condition du if on peut lire ceci :
	-- Si la différence entre la date d'arrivée et la date d'aujourd'hui est plus grande que 9 ans alors : ....
-- Et pour le else :
	-- si la condition du if est fausse, alors : ....
IF ( DATEDIFF( YEAR, @date_arrivee, GETDATE () ) > 9 )
	BEGIN
		PRINT 'L’employé 21 est un Senior'
	END
ELSE
	BEGIN
		PRINT 'L’employé 21 est un Junior'
	END

GO

-- Lorsqu'on utilise la structure if/else , on doit encapsuler la logique à l'intérieur du if et du else dans des blocs BEGIN ... END

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    3.2 
S’il existe dans la table Person.Person, quelqu’un du nom de « Zugelder », affichez son nom complet (Prénom, deuxième nom, nom de famille) .
Sinon, signaler qu’il n’existe personne portant ce nom !
**/

-- Déclaration des variables
DECLARE 
	@prenom nvarchar(50), 
	@deuxieme_prenom nvarchar(50), 
	@nom nvarchar(50)

-- Vérification de l'existence d'une personne avec le nom de famille 'Zugelder'
IF EXISTS ( SELECT * FROM Person.Person WHERE LastName LIKE 'Zugelder' )
	-- Si oui
	BEGIN
		SELECT 
			@prenom = FirstName, 
			@deuxieme_prenom = MiddleName, 
			@nom = LastName
		FROM 
			Person.Person
		WHERE 
			LastName LIKE 'Zugelder'

		PRINT (@prenom + ' ' + @deuxieme_prenom + ' ' + @nom )
	END
ELSE
	-- Sinon
	BEGIN
		PRINT 'Personne ne s´appelle Zugelder dans la table...'
	END
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    3.3 
Si le nombre de femmes est plus important que le nombre d’hommes, affichez, dans une table,
« Les femmes domineront le monde ! »

Sinon, indiquez « La guerre des sexes n’est pas finie… »

Afficher le contenu de votre table
**/

-- Déclaration des variables pour compter le nombre de femmes et d'hommes
DECLARE @F INT
SELECT @F = COUNT(*) FROM HumanResources.Employee WHERE Gender LIKE 'F'

DECLARE @M INT
SELECT @M = COUNT(*) FROM HumanResources.Employee WHERE Gender LIKE 'M'

IF ( @F > @M )
	BEGIN
		SELECT 'Les femmes domineront le monde !' 
		AS 'Avenir du monde' 
		INTO #temp_monde

		SELECT * FROM #temp_monde
		DROP TABLE #temp_monde
	END
ELSE
	BEGIN
		SELECT 'La guerre des sexes n’est pas finie…' 
		AS 'Avenir du monde' 
		INTO #temp_monde2

		SELECT * FROM #temp_monde2
		DROP TABLE #temp_monde2
	END
GO

/**
PS : Au cours de ce module d'exercice corrigés, vous aurez l'occasion d'observer que j'ai préféré au préalable de mes if et mes else, déclarer des variables
	 afin de les utiliser dans mes comparaisons. Ceci n'est pas du tout obligatoire, mais rend le code plus agréable à la lecture.
	 
	 Notez que si vous souhaitez faire de l'optimisation de comptoire, alors effectivement le fait de déclarer ces variables
	 nous amènera à consommer plus de mémoire, il serait donc préférable de ne pas le faire, du moins, à condition que vous n'ayez besoin qu'une seule fois des données récupérées
**/

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    3.4 
Comparer le nombre d’heures d’absence des employés 21 et 27. 

Si le nombre d’heures de repos de l’un ET son nombre d’heures de vacances sont plus importants que ceux de l’autre, signalez le
par un message à l’écran ! 

Sinon, si le nombre d’heures de repos de l’un est plus grand que celui de l’autre, mais que son nombre d’heures de vacances est inférieur, 
signaler que tout va bien. 

Dans les autres cas, il n’y a rien à signaler. Choisissez vous-même du quel employé vous partirez pour faire la
comparaison.
**/

-- Déclaration des variables et récupération des données à comparer
DECLARE @SickLeaveHoursEmploye21 INT
SELECT @SickLeaveHoursEmploye21 = SickLeaveHours FROM HumanResources.Employee WHERE BusinessEntityID = 21

DECLARE @SickLeaveHoursEmploye27 INT
SELECT @SickLeaveHoursEmploye27 = SickLeaveHours FROM HumanResources.Employee WHERE BusinessEntityID = 27

DECLARE @VacationHours21 INT
SELECT @VacationHours21 = VacationHours FROM HumanResources.Employee WHERE BusinessEntityID = 21

DECLARE @VacationHours27 INT
SELECT @VacationHours27 = VacationHours FROM HumanResources.Employee WHERE BusinessEntityID = 27

-- Comparaison des heures de congé maladie et de vacances entre les employés 21 et 27
IF ( @SickLeaveHoursEmploye21 > @SickLeaveHoursEmploye27 ) AND ( @VacationHours21 > @VacationHours27 )
	BEGIN
		-- Si l'employé 21 a plus d'heures de congé maladie et plus d'heures de vacances que l'employé 27
		PRINT ('21 a bien plus profité de la vie que 27 !')
	END
ELSE
	BEGIN
		-- Si l'employé 21 a plus d'heures de congé maladie mais moins d'heures de vacances que l'employé 27
		IF ( @SickLeaveHoursEmploye21 > @SickLeaveHoursEmploye27 ) AND ( @VacationHours21 < @VacationHours27 )
			BEGIN
				PRINT ('21 a une petite santé, mais tout va bien !')
			END
		ELSE
			BEGIN
				-- Pour tous les autres cas :
				PRINT ('27 est un paresseux !')
		END
	END
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    3.5 
Afficher, dans une table temporaire dont le nom de la colonne sera « Suivi_employé » le statut d’un employé analysé. 

Selon le cas, si l’employé est né après l’an 2000, cela est vraisemblablement impossible. 

Dans le cas où l’employé est arrivé dans l’entreprise entre 2017 et 2018, il est un Junior.

Entre 2012 et 2016 il est un Qualified. 

Entre 2007 et 2011, il est Confirmed, sinon, c’est un President !

Traitez un employé au hasard, de la table HumanResources.Employee. 

Un select vers votre table temporaire suffit !
**/

-- Nous choisissons M. Frank Lee, BusinessEntityID 200

-- Crée une table temporaire pour stocker le statut de l'employé
CREATE TABLE #temp_suivi ( Suivi_employé VARCHAR(50) )

-- Déclare 2 variables pour stocker l'année de naissance et l'année d'arrivée dans l'entreprise de l'employé
DECLARE 
	@annee_naiss INTEGER, 
	@date_arrivee INTEGER

-- Récupère l'année de naissance et l'année d'arrivée dans l'entreprise de l'employé 200
SELECT 
	@annee_naiss = YEAR(BirthDate), 
	@date_arrivee = YEAR(HireDate)
FROM 
	HumanResources.Employee
WHERE 
	BusinessEntityID = 200

-- Suivi de l'employé :
IF ( @annee_naiss > 2000 )
	BEGIN
		INSERT INTO #temp_suivi VALUES ('Impossible')
	END
ELSE
	BEGIN
		IF ( (@date_arrivee >= 2017) AND (@date_arrivee <= 2018) )
			BEGIN
				INSERT INTO #temp_suivi VALUES ('Junior')
			END
		ELSE
			BEGIN
				IF ( (@date_arrivee >= 2012) AND (@date_arrivee <= 2016) )
					BEGIN
						INSERT INTO #temp_suivi VALUES ('Qualified')
					END
				ELSE
					BEGIN
						IF ( (@date_arrivee >= 2007) AND (@date_arrivee <= 2011) )
							BEGIN
								INSERT INTO #temp_suivi VALUES ('Confirmed')
							END
						ELSE
							BEGIN
								INSERT INTO #temp_suivi VALUES ('President')
							END
					END
			END
	END

SELECT * FROM #temp_suivi
DROP TABLE #temp_suivi

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    3.6 
En fonction de l’âge de l’employé traité, prévenez-nous s’il sera bientôt à la retraite ou pas via une phrase affichée à l’écran 
	
	« Attention, retraite imminente pour [nom_employé] ! » 
	
	ou justement, 
	«[nom_employé] a encore de longues années à faire chez nous ! » 
	
Utilisez ici un CASE pour afficher la phrase voulue.
**/


-- Nous choisissons M. Frank Lee, BusinessEntityID 200

DECLARE 
	@age INTEGER, 
	@nom nvarchar(50), 
	@affichage varchar(100)

SELECT @nom = LastName 
FROM Person.Person 
WHERE BusinessEntityID = 200

SELECT @affichage = 
	CASE 
		WHEN YEAR (BirthDate) > ( YEAR ( GETDATE () ) - 55) THEN 'Attention, retraite imminente pour ' + @nom + ' !'
		ELSE @nom + ' a encore de longue années à faire chez nous !'
	END
FROM HumanResources.Employee

PRINT ( @affichage )

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    3.7 
Enregistrez dans une variable de type TABLE, le nombre d’occurrence des noms 
	Coleman,
	Powell, 
	Suarez,
	Vance.

Vous trouverez ces noms dans la table Person.Person. 

Il est possible de faire l’opération en une seule requête, 
cependant faites le également en créant pour chaque élément à transférer, 
une variable supplémentaire qui contiendra le nombre de personnes qui portent le même nom.
**/

-- Déclaration de la variable table
DECLARE @tab_nbre_noms TABLE (
	nom nvarchar(50), 
	nbre_occurence int)

-- Insertion des occurences dans la variable table
INSERT INTO @tab_nbre_noms 
SELECT 
	LastName, 
	COUNT(*)
FROM 
	Person.Person
WHERE 
	LastName LIKE 'Coleman' OR 
	LastName LIKE 'Powell' OR 
	LastName LIKE 'Suarez' OR 
	LastName LIKE 'Vance'
GROUP BY 
	LastName

-- Petit rappel pour le GROUP BY :
	-- Le GROUP BY en SQL est utilisé pour regrouper les lignes ayant des valeurs communes dans des colonnes spécifiées. 
	-- Il est souvent utilisé en conjonction avec des fonctions d'agrégation telles que COUNT, SUM, AVG, MAX, et MIN.

SELECT * FROM @tab_nbre_noms

-- OU BIEN

-- Déclaration des variables
DECLARE @tab_nbre_noms2 TABLE (
	nom nvarchar(50), 
	nbre_occurence int)

DECLARE
	@nbre_Coleman INTEGER, 
	@nbre_Powell INTEGER, 
	@nbre_Suarez INTEGER,
	@nbre_Vance INTEGER

-- Récupération des données dans les variables
SELECT @nbre_Coleman = COUNT(*) FROM Person.Person WHERE LastName LIKE 'Coleman'
SELECT @nbre_Powell = COUNT(*) FROM Person.Person WHERE LastName LIKE 'Powell'
SELECT @nbre_Suarez = COUNT(*) FROM Person.Person WHERE LastName LIKE 'Suarez'
SELECT @nbre_Vance = COUNT(*) FROM Person.Person WHERE LastName LIKE 'Vance'

-- Insertion des variables dans la variable table
INSERT INTO @tab_nbre_noms2 VALUES ('Coleman', @nbre_Coleman)
INSERT INTO @tab_nbre_noms2 VALUES ('Powell', @nbre_Powell)
INSERT INTO @tab_nbre_noms2 VALUES ('Suarez', @nbre_Suarez)
INSERT INTO @tab_nbre_noms2 VALUES ('Vance', @nbre_Vance)

SELECT * FROM @tab_nbre_noms2
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    3.8 
S’il existe plus de 20 employés nés avant 1975, 

alors dans le cas où ils ont plus de 80 heures d’absence totale (vacances et maladie), afficher dans une table temporaire, qu’ils sont en excédant.

Dans le cas où ce nombre est entre 60 et 80, ils sont dans la norme, 

dans le cas où ils sont entre 40 et 60 heures d’absence, alors ils sont de bons éléments ! 

Faites l’exercice également s’il existe plus de 20 employés nés entre 1980 et 1990.
**/

-- Création de la table temporaire et déclaration des variables.
CREATE TABLE #temp_absences (
	ID_Emp INTEGER, 
	Annee INTEGER, 
	Statut VARCHAR(20))

DECLARE @NbrEmployeWithBirthDateBefore75 INT
SELECT @NbrEmployeWithBirthDateBefore75 = COUNT(*) FROM HumanResources.Employee WHERE YEAR (BirthDate) < 1975

DECLARE @NbrEmployeWithBirthDateBetween80And90 INT
SELECT @NbrEmployeWithBirthDateBetween80And90 =  COUNT(*) FROM HumanResources.Employee WHERE YEAR (BirthDate) BETWEEN 1980 AND 1990

IF ( ( @NbrEmployeWithBirthDateBefore75 > 20 ) OR ( @NbrEmployeWithBirthDateBetween80And90 > 20 ) )
	BEGIN

		INSERT INTO #temp_absences
		SELECT 
			BusinessEntityID, 
			YEAR (BirthDate),
		CASE
			WHEN (VacationHours + SickLeaveHours) > 79 THEN 'Excédant'
			WHEN (VacationHours + SickLeaveHours) BETWEEN 60 AND 79 THEN 'Dans la norme'
			WHEN (VacationHours + SickLeaveHours) BETWEEN 40 AND 59 THEN 'Bon élément'
			ELSE 'N / A'
		END
		FROM HumanResources.Employee
		WHERE (YEAR (BirthDate) < 1975) OR (YEAR (BirthDate) BETWEEN 1980 AND 1990)
	END

SELECT * FROM #temp_absences
DROP TABLE #temp_absences

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------
