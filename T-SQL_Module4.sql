/**
Pour l'installation de la backup d'AdventureWork nécessaire à ce module,
voir l'introduction du module 2

**/

USE AdventureWorks2008R2
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.1 
Est-il possible de sortir d’une boucle WHILE en T-SQL ? Si oui comment ?

Testez cette possibilité avec une boucle qui affiche le carré des nombres de 1 à 20 
mais qui sort de la boucle si la valeur vaut 12.
**/

DECLARE @x int
SET @x = 1

-- L'instruction "BREAK" permet de sortir d'une boucle de façon abrupte
WHILE (@x <= 20)
BEGIN
	IF (@x = 12) 
		BEGIN 
			BREAK 
		END
	PRINT (@x * @x)
	SET @x = @x + 1
END
GO

-- Il est important de noter que même si dans un cas simple comme celui-ci, utiliser un break pour sortir d'une boucle while ne comprend pas de risque particulier,
-- lorsque l'on arrive sur la création de boucle avec une logique plus complexe, l'utilisation du break peut amener à rencontrer des comportements inattendus au sein de notre logique,
-- il est donc déconseillé de l'utiliser.

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.2 
Comment mettre fin à une boucle en T-SQL ? 

Quels sont les 2 choses les plus importantes ?
	-- Les bornes BEGIN et END qui délimite la structure procédural du while
	-- La condition de sortie de la boucle est également primordiale afin de ne pas rentrer dans un cas de boucle infinie


Créez une boucle WHILE infinie. Cela fait-il planter SQLServer ?
**/

DECLARE @x int
SET @x = 1

-- Exemple de boucle infinie :
WHILE (@x <= 20)
	BEGIN
		IF (@x = 12) BEGIN 
			BREAK 
		END

		PRINT (@x * @x)

		-- SET @x = @x + 1
	END
GO

/**
Les boucles infinies ne font pas "planter" SQLServer, mais le serveur essayera d'exécuter la boucle autant de fois qu'il le peut. 
Le résultat ne s'affiche que lorsque l'on annule l'exécution (en cliquant sur le carré rouge "Cancel Executing Query" (à côté du bouton "Execute") 
Une fois l'exécution interrompue, les résultats traités sont affichés 
Laisser tourner la boucle à l'infini risque de grandement ralentir votre machine jusqu'à en saturer probablement la mémoire...
Evitons donc de le faire ! ;)
**/

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.3 
Afficher le carré des nombres impairs allant de 1 à 50 sans prendre les nombres compris entre 20 et 30.
**/

DECLARE @x int
SET @x = 1

WHILE (@x <= 50)
	BEGIN
		IF ( ( @x NOT BETWEEN 20 AND 30 ) AND ( @x%2 = 1 ) )
			BEGIN
				PRINT (@x * @x)
			END
		SET @x = @x + 1
	END
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------
    
/**    4.4 
Ecrire une boucle WHILE qui affiche la phrase « Ceci est un nombre divisible par 3 : [valeur_divisible_par_3] » pour tous les nombres divisibles par 3 entre 1 et 30
**/

DECLARE @x int
SET @x = 1

WHILE (@x <= 30)
	BEGIN
		IF ( @x%3 = 0 )
			BEGIN
				PRINT ('Ceci est un nombre divisible par 3 : ' + CONVERT (VARCHAR, @x))
			END

		SET @x = @x + 1
	END
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.5 
Ecrire une boucle WHILE qui affiche le décompte des années depuis aujourd'hui jusqu’à 1983. 
Incrémenter également un compteur à afficher en fin de décompte dans la phrase « [compteur] années ont été décomptées depuis [annee_en_cours] ».
**/

DECLARE 
	@annee int, 
	@compteur INT

SET @annee = YEAR ( GETDATE() )
SET @compteur = 0

WHILE (@annee >= 1983)
	BEGIN
		PRINT ( CONVERT ( VARCHAR, @annee ) )

		IF ( @annee = 1983 )
			BEGIN
				PRINT ( CONVERT ( VARCHAR, @compteur ) + ' années ont été décomptées depuis ' + CONVERT ( VARCHAR, YEAR ( GETDATE() ) ) )
			END

		SET @compteur = @compteur + 1
		SET @annee = @annee - 1
	END
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.6 
Écrire une boucle qui, pour chaque itération, enregistre la date sous 5 formats différents (vous avez le choix des formats) dans une variable de type TABLE. 
Afficher les données récoltées à l’écran
**/

DECLARE @tab_date TABLE ( une_date VARCHAR(50) )

DECLARE @i INT
SET @i = 1

WHILE (@i <= 5)
	BEGIN
		INSERT INTO 
			@tab_date 
		VALUES 
			( CONVERT (VARCHAR, GETDATE(), CONVERT(INTEGER,(100 + (14*rand()))) ) )

		SET @i = @i + 1
	END

SELECT * FROM @tab_date
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.7 
Ecrire une boucle simple qui permette d’afficher la phrase 
	« [LAST_NAME de l’employé] est l’employé dont l’id est [ID de l’employé] » 
pour les 100 premiers employés de la table « Person.Person ». 

1. Faites l’exercice en déclarant d’abord 2 variables distinctes de type table "tab_nom" qui contiendront les valeurs pour LastName et BusinessEntityId (sans utiliser de curseur) 
et l'autre "tab_id" qui contiendra le BusinessEntityId (Utiliser une jointure pour afficher les résultats).

2. Refaire ensuite l’exercice en stockant d’abord les valeurs récupérées dans un curseur.
**/

------ 1. 2 variables de type table ------ 

-- Déclaration de deux variables de type table
DECLARE @tab_nom TABLE (
	num_emp int, 
	nom_emp nvarchar(50)
	)

DECLARE @tab_id TABLE (
	id_emp nvarchar(50)
	)

-- Insertion des données dans @tab_nom
INSERT INTO @tab_nom 
SELECT TOP 100
	BusinessEntityID, 
	LastName 
FROM Person.Person

-- Insertion des données dans @tab_id
INSERT INTO @tab_id 
SELECT BusinessEntityID 
FROM Person.Person

-- Sélection et affichage des données en combinant les deux tables de variables
SELECT (nom_emp + ' est l´employé dont l´id est ' + CONVERT(varchar,id_emp) ) 
FROM 
	@tab_nom N 
JOIN 
	@tab_id ID 
ON 
	N.num_emp = ID.id_emp
GO

------ 2. Un curseur et une boucle ------ 

-- Déclaration du curseur CR_emp pour parcourir les données des employés
DECLARE CR_emp CURSOR 
FOR SELECT TOP 100
	BusinessEntityID, 
	LastName 
FROM
	Person.Person

-- Déclaration des variables pour stocker les données récupérées par le curseur
DECLARE 
	@id_emp int, 
	@nom_emp nvarchar(50)

-- Ouverture du curseur
OPEN CR_emp

-- Récupération de la première ligne du curseur
FETCH CR_emp 
INTO 
	@id_emp, 
	@nom_emp

-- Boucle pour parcourir toutes les lignes du curseur
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT (@nom_emp + ' est l´employé dont l´id est ' + CONVERT(varchar,@id_emp) )
		
		-- Récupération de la ligne suivante du curseur
		FETCH CR_emp 
		INTO 
			@id_emp, 
			@nom_emp
	END

-- Fermeture et désallocation du curseur
CLOSE CR_emp
DEALLOCATE CR_emp
GO

/** 

Comparaison des deux approches

1. Utilisation de variables de type table :
   - Déclare et initialise des tables temporaires dans des variables.
   - Insère les données nécessaires dans ces variables.
   - Effectue une jointure et une sélection sur ces tables de variables pour obtenir le résultat souhaité.
   - Approche efficace pour manipuler et interroger des ensembles de données de petite à moyenne taille.
   - Simplifie la logique en utilisant des opérations de type SQL standard.

2. Utilisation d'un curseur et d'une boucle :
   - Déclare un curseur pour parcourir les résultats d'une requête.
   - Utilise des variables pour stocker les valeurs de chaque ligne récupérée par le curseur.
   - Boucle à travers chaque ligne du curseur et exécute des actions pour chaque ligne.
   - Approche nécessaire lorsque des opérations ligne par ligne sont requises.
   - Moins performante pour les grandes quantités de données en raison du traitement ligne par ligne.

**/

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.8 
Récupérer les 200 premiers 
		- noms 
		- prénoms
		- ID d’employés 
	de la table Person.Person ainsi que leur 
		- Job 
	à partir de la table HumanResources.Employees. Stocker ces valeurs dans un curseur.

Afficher les données du curseur dans une table temporaire, mais uniquement si ces valeurs
correspondent aux employés techniciens de productions WC60.
Le tri se fera après récupération de l’ensemble des données dans le curseur.
**/

-- Création d'une table temporaire pour stocker les informations des employés
CREATE TABLE #temp_emp (
	nom_emp nvarchar(50), 
	prenom_emp nvarchar(50),
	id_emp int, 
	job_emp nvarchar(50)
	)

-- Déclaration d'un curseur pour sélectionner les 200 premiers employés et leurs informations de poste
DECLARE CR_emp CURSOR 
FOR SELECT TOP 200 
	PP.LastName, 
	PP.FirstName,
	PP.BusinessEntityID, 
	HE.JobTitle
FROM 
	Person.Person PP 
JOIN
	HumanResources.Employee HE 
ON 
	PP.BusinessEntityID = HE.BusinessEntityID

-- Déclaration des variables pour stocker les valeurs récupérées par le curseur
DECLARE 
	@nom nvarchar(50), 
	@prenom nvarchar(50), 
	@id int, 
	@job nvarchar(50)

-- Ouverture du curseur
OPEN CR_emp

-- Récupération de la première ligne du curseur et stockage des valeurs dans les variables
FETCH CR_emp 
INTO 
	@nom, 
	@prenom, 
	@id, 
	@job

-- Boucle pour parcourir toutes les lignes du curseur
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		IF (@job LIKE 'Production Technician - WC60')
			BEGIN
				INSERT INTO #temp_emp 
				VALUES (@nom, @prenom, @id, @job)
			END

		-- Récupération de la ligne suivante du curseur et mise à jour des variables
		FETCH CR_emp 
		INTO 
			@nom, 
			@prenom, 
			@id, 
			@job
	END

-- Fermeture du curseur + Libération des ressources allouées
CLOSE CR_emp
DEALLOCATE CR_emp

SELECT * FROM #temp_emp
DROP TABLE #temp_emp

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.9 
Afficher les données des employés (Nom, Prénom, Date de naissance) rattachés à l’un des
Jobs (Janitor). Assurez-vous qu’il ne faille changer les données que d’une seule variable afin
d’afficher les données des employés rattachés à un autre Job.
**/

-- Déclaration de la variable @job
DECLARE @job nvarchar(50)
SET @job = 'Janitor'

-- Déclaration du curseur CR_emp et sélection des données nécessaires.
DECLARE CR_emp CURSOR FOR 
SELECT 
	PP.LastName, 
	PP.FirstName, 
	HE.BirthDate
FROM 
	Person.Person PP 
JOIN
	HumanResources.Employee HE 
ON 
	PP.BusinessEntityID = HE.BusinessEntityID
WHERE 
	HE.JobTitle LIKE @job

-- Déclaration des variables nécessaires au stockage 
DECLARE 
	@nom nvarchar(50), 
	@prenom nvarchar(50), 
	@b_day date

--Ouverture du curseur
OPEN CR_emp

-- Récupération de la 1 ère ligne et stockage dans les variables de celle-ci
FETCH CR_emp 
INTO 
	@nom, 
	@prenom, 
	@b_day

-- Boucle pour print les valeurs demandées
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		PRINT (@nom + ' ' + @prenom + ', ' + CONVERT (varchar,@b_day) )
		
		FETCH CR_emp 
		INTO 
			@nom, 
			@prenom, 
			@b_day
	END

-- Fermeture et désallocation du curseur
CLOSE CR_emp
DEALLOCATE CR_emp

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.10 
Récupérer la liste des Id employés dans un curseur. 
Récupérer la liste des ventes de la table Sales.SalesPerson dans un autre curseur. 

Pour chaque employé, si son id (BusinessEntityId) est repris dans le second curseur, afficher 
		- le montant de la dernière commission qui le concerne
		- la date à laquelle elle a été modifiée. 

❗Tout se passe avec les curseurs et les boucles, pas question de faire de jointure dans ce cas !
**/

-- Déclaration du 1er curseur et de sa zone d'action
DECLARE CR_emp CURSOR 
FOR SELECT BusinessEntityID 
FROM Person.Person

-- Déclaration du 2ème curseur et de sa zone d'action
DECLARE CR_sales CURSOR 
FOR SELECT 
	BusinessEntityID, 
	CommissionPct,
	ModifiedDate 
FROM Sales.SalesPerson

-- Déclaration des variables qui serviront au stockage des valeurs
DECLARE @emp_id_PP int,
		@emp_id_SSP int, 
		@com smallmoney, 
		@modif datetime

-- Ouverture du curseur
OPEN CR_emp

-- Sélection de la 1 ère ligne du curseur et insertion dans la variable @emp_id
FETCH CR_emp 
INTO @emp_id_PP

-- Ouverture de la boucle principal
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		-- Ouverture du curseur secondaire
		OPEN CR_sales
		
		FETCH CR_sales 
		INTO 
			@emp_id_SSP, 
			@com, 
			@modif

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF (@emp_id_PP = @emp_id_SSP)
					BEGIN
						PRINT ('Dernière commission pour ' + CONVERT (varchar, @emp_id_PP)
								+ ' en date du ' + CONVERT (varchar, @modif) + ' : '
								+ CONVERT(VARCHAR(1000), CONVERT(SMALLMONEY, @com), 2) )
					END

				FETCH CR_sales 
				INTO 
					@emp_id_SSP, 
					@com, 
					@modif
			END

		CLOSE CR_sales
		
		FETCH CR_emp 
		INTO @emp_id_PP

	END

DEALLOCATE CR_sales

CLOSE CR_emp
DEALLOCATE CR_emp

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.11 
Récupérer les produits et leurs noms dans la table Production.Product dans un premier curseur.

Récupérer la quantité commandée des produits dans la table Production.Workorder dans un second curseur. 

Pour chaque produit existant, afficher la quantité commandée. 

❗ pas de COUNT via un SELECT dans ce cas ! 
	De nouveau, tout se passe dans les curseurs et les boucles ! Ne tester la requête que pour les 2000 premières entrées de la table Production.Workorder
**/

-- Déclaration du curseur pour récupérer les produits
DECLARE CR_produit CURSOR 
FOR SELECT 
	ProductID, 
	Name 
FROM
	Production.Product

-- Déclaration du curseur pour récupérer les ordres de travail
DECLARE CR_workorder CURSOR 
FOR SELECT TOP 2000 
	ProductID, 
	OrderQty 
FROM
	Production.WorkOrder

-- Déclaration des variables

DECLARE 
	@prod_id_PP int, 
	@nom_prod nvarchar(50),
	@prod_id_PWO int, 
	@quantite int,
	@total int

-- Ouverture du curseur des produits
OPEN CR_produit

-- Récupération de la première ligne du curseur des produits
FETCH CR_produit 
INTO 
	@prod_id_PP, 
	@nom_prod

-- Boucle principale pour parcourir chaque produit
WHILE (@@FETCH_STATUS = 0)
	BEGIN

		-- Ouverture du curseur des ordres de travail
		OPEN CR_workorder
		
		-- Récupération de la première ligne du curseur des ordres de travail
		FETCH CR_workorder 
		INTO 
			@prod_id_PWO, 
			@quantite
		
		-- Initialisation du total des quantités pour le produit courant
		SET @total = 0
		
		-- Boucle pour parcourir chaque ordre de travail
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				-- Si le produit de l'ordre de travail correspond au produit courant
				IF (@prod_id_PP = @prod_id_PWO)
					BEGIN
						SET @total = @total + @quantite
					END

				-- Récupération de la ligne suivante du curseur des ordres de travail
				FETCH CR_workorder 
				INTO 
					@prod_id_PWO, 
					@quantite
			END
		
		-- Affichage du total des quantités pour le produit courant
		PRINT ('Total vendu pour produit ' + @nom_prod + ', ID ' 
					+ CONVERT (VARCHAR,@prod_id_PP) + ' : ' + CONVERT (VARCHAR,@total) )
		
		-- Fermeture du curseur des ordres de travail
		CLOSE CR_workorder

		-- Récupération de la ligne suivante du curseur des produits
		FETCH CR_produit 
		INTO 
			@prod_id_PP, 
			@nom_prod
	END

DEALLOCATE CR_workorder

CLOSE CR_produit
DEALLOCATE CR_produit

GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    4.12 
Récupérer le prix le plus récent (pas de date de fin) de chacun des produits dans la table Production.productCostHistory. 

Récupérer dans un autre curseur les données concernant chaque produit. 

Pour chaque produit, insérer dans une table temporaire son nom, son prix et la date de sa dernière mis à jour.
**/

-- Création d'une table temporaire pour stocker les données des produits
CREATE TABLE #temp_prod (
	nom_prod nvarchar(50), 
	prix_prod money, 
	date_modif datetime)

-- Déclaration du curseur pour récupérer les produits
DECLARE CR_produit CURSOR 
FOR SELECT 
	ProductID, 
	Name 
FROM Production.Product

-- Déclaration du curseur pour récupérer les coûts des produits
DECLARE CR_cost CURSOR 
FOR SELECT 
	ProductID, 
	StandardCost, 
	ModifiedDate
FROM Production.ProductCostHistory 
WHERE EndDate IS NULL

-- Déclaration des variables
DECLARE 
	@prod_id_PP int, 
	@nom_prod nvarchar(50),
	@prod_id_PPCH int, 
	@prix money, 
	@der_date datetime

-- Ouverture du curseur des produits
OPEN CR_produit

-- Récupération de la première ligne du curseur des produits
FETCH CR_produit 
INTO 
	@prod_id_PP, 
	@nom_prod

-- Boucle principale pour parcourir chaque produit
WHILE (@@FETCH_STATUS = 0)
	BEGIN
		-- Ouverture du curseur des coûts
		OPEN CR_cost

		-- Récupération de la première ligne du curseur des coûts
		FETCH CR_cost 
		INTO 
			@prod_id_PPCH, 
			@prix, 
			@der_date

		-- Boucle pour parcourir chaque coût de produit
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				-- Si le produit de la table des coûts correspond au produit courant
				IF (@prod_id_PP = @prod_id_PPCH)
					BEGIN
						INSERT INTO #temp_prod 
						VALUES (@nom_prod, @prix, @der_date)
					END
				
				-- Récupération de la ligne suivante du curseur des coûts
				FETCH CR_cost 
				INTO 
					@prod_id_PPCH, 
					@prix, 
					@der_date
			END
		
		-- Fermeture du curseur des coûts
		CLOSE CR_cost

		-- Récupération de la ligne suivante du curseur des produits
		FETCH CR_produit 
		INTO 
			@prod_id_PP, 
			@nom_prod
	END

DEALLOCATE CR_cost

CLOSE CR_produit
DEALLOCATE CR_produit

SELECT * FROM #temp_prod
DROP TABLE #temp_prod

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------
