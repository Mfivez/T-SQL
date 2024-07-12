﻿/**
Pour l'installation de la backup d'AdventureWork nécessaire à ce module,
voir l'introduction du module 2

**/

USE AdventureWorks2008R2
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.1
Créer une procédure qui remplace la fonction de récupération de la date en l’affichant
directement à l’écran. L’appel de cette procédure permet donc d’un seul coup de récupérer la date et
l’heure du système, sans passer par « getDate() » ou « CURRENT_TIMESTAMP »
**/

EXEC DateDuJour
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.2
Créer une procédure qui affichera la phrase 
« Nous sommes le [Date_du_jour] et il est actuellement [heure_du_moment] ».
**/

EXEC AfficheHeureDate
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.3
Créer une procédure qui insère dans une table temporaire les données vous concernant. 
Ces données sont fournies en paramètres.
**/

EXEC InsererDonneesPerso 
					'Jean', 
					'Michel', 
					'promenade des anglais, 208', '1968-10-10'
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.4
Créer une procédure qui insère des données dans deux tables temporaires distinctes #Anciens et #Jeunes. 
Si l’employé est né avant 1980 et après 1970, et qu’il a été engagé dans l’entreprise avant 2008, il rentre dans la première table #Anciens. 
S’il est né après 1990, et qu’il a été engagé après 2010 il se retrouve dans la deuxième table #Jeunes
**/

EXEC TrierEmploye
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.5
Créer une fonction qui renvoie le nombre de lignes contenues dans la table HumanResources.Employee
**/

PRINT 'Nombre de lignes dans HumanResources.Employee: ' + CAST(dbo.CompterLesLignes() AS VARCHAR)
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------


/**    5.6
Créer une fonction qui renvoie le nom du produit (Name de Production.Product) dont le prix
(StandardCost de Production.ProductCostHistory) a été modifié le plus grand nombre de fois. S’il y a
ex-aequo, il faudra renvoyer une phrase concaténée de l’ensemble des noms !
**/

declare @affichage varchar(max)
set @affichage = dbo.ModifPrix ()
PRINT @affichage

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.7
Créer une procédure ayant un paramètre en mode OUTPUT qui permet de modifier les lignes
de la table HumanResources.Employee et de mettre la date « ModifiedDate » à la date du jour, 

si cette date n’est pas égale au 31 juillet 2008. La procédure renverra le nombre de lignes réellement mises à
jour, via son paramètre OUTPUT. 

Faites l’exercice avec une simple requête d’update. Faites une seconde version qui stocke 
au préalable les valeurs à mettre à jour dans un curseur déclaré au sein de la procédure.
**/

DECLARE @nbreLignesModifOUT int

EXECUTE dbo.MajHE @nbreLignesModifOUT OUT
-- OU "EXECUTE dbo.MajHEbis @nbreLignesModifOUT OUT"
PRINT @nbreLignesModifOUT

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.8
Créer une procédure qui récupère dans un curseur 
		- l’ensemble des produits (Name de Production.Product) 
		- et leur prix (StandardCost de Production.ProductCostHistory) 
	dont dont la valeur de « EndDate » est à « NULL ». 
	
Si le prix est de moins de 15, alors il faut inscrire ce produit dans une table non-temporaire que la procédure créera SI ELLE N’EXISTE PAS 
(référez-vous aux exemples du cours pour trouver comment faire !) 

Si le prix est plus grand que 15, alors il faudra insérer dans une table temporaire 
		- le nom du produit, 
		- le prix,
		- une phrase associée qui sera :
				- « prix bien trop élevé » si le prix est de plus de 50,
				- « prix raisonnable » si le prix est compris entre 15 et 50.

La procédure renvoie le nombre de valeurs insérées dans la table non-temporaire dans un paramètre passé en mode OUTPUT 
et affiche le contenu de la table temporaire.
**/

DECLARE @plusDe15OUT int
EXECUTE dbo.VerifProduits @plusDE15OUT OUTPUT
PRINT 'Nombres de produits coutant plus de 15 : ' + CONVERT(varchar,
@plusDE15OUT)

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.9

Créer une procédure qui permet d’afficher la phrase « X employés travaillent au poste de [JobTitle de HumanResources.Employee] »

Ce nombre X sera renvoyé par une fonction que vous aurez préalablement créée et qui demande en paramètre de quel Job il s’agit, 
paramètre passé par la procédure appelante. 

Tester la procédure pour plusieurs JobTitle différents au sein de la procédure.

**/

EXECUTE dbo.AnalyserHE 'Production Technician - WC60'

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.10
Créer une procédure qui affiche 
		- le nom des produits (Name de Production.Product) 
		- et le prix (ListPrice de Production.Product) des produits 
	appartenant à la même sous-catégorie que :
		- le nom de catégorie (Name de Production.ProductSubcategory) passé en paramètres à la procédure 
	et ayant :
		- un prix (ListPrice de Production.Product) inférieur à un prix également passé en paramètres. 
	
Tester la procédure dans le cas de tous les articles ayant un rapport avec « %Bikes% » et un prix inférieur à 700.

La procédure renverra également une valeur en mode OUTPUT qui informera du nombre totale de lignes non-affichées par la procédure 
(les produits non-affichés).
**/

DECLARE @lignes_manquantes int
EXECUTE dbo.ClasserSubcat 
					'%Bikes%', 
					700, 
					@lignes_manquantes OUTPUT

PRINT CONVERT (varchar,@lignes_manquantes) + ' lignes non-affichées'

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.11
Créer une table employes pouvant récupérer 
		- les ID, 
		- noms, 
		- prénoms, 
		- dates d’embauche 
		- et dates de naissance des employés (HumanResources.Employee de AdventureWorks2008R2). 
		
Créer une procédure capable de remplir votre table d’un seul coup en utilisant les données passées en paramètres.

Les données passées seront contenues dans une variable de type table qui contiendra les 
		- ID, 
		- noms,
		- prénoms 
		- et dates de naissance des employés. 
		
La date d’embauche sera la date du jour que vous complèterez vous-même à partir de la procédure.
**/


IF OBJECT_ID('employes', 'U') IS NOT NULL
	BEGIN
		DROP TABLE employes
	END

CREATE TABLE employes (
	id_emp int PRIMARY KEY,
	nom_emp nvarchar(50),
	prenom_emp nvarchar(50),
	HD_emp date,
	BD_emp date
)
GO

CREATE TYPE donnees_emp AS TABLE (
	id_temp int,
	nom_temp nvarchar(50),
	prenom_temp nvarchar(50),
	BD_temp date
)
GO

DECLARE @emp_traite DONNEES_EMP

INSERT INTO @emp_traite
SELECT 
	HE.BusinessEntityID, 
	PP.LastName, 
	PP.FirstName, 
	HE.BirthDate
FROM 
	HumanResources.Employee HE 
JOIN 
	Person.Person PP
ON 
	HE.BusinessEntityID = PP.BusinessEntityID

EXECUTE dbo.RemplirEmp @emp_traite

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**    5.12
Récupérer les données de la table Person.PersonPhone dans une variable de type table. 

Passer la variable fournie à une procédure qui vous permettra de rajouter les numéros de téléphones
correspondants aux employés que vous avez entrés au point 5.11.

Par contre, on ne retiendra dans notre table personnelle les numéros que s’ils sont de type 3 (PhoneNumberTypeID). 
La procédure renvoie le nombre de lignes mises à jour via un paramètre en mode OUTPUT Il faudra bien entendu
ajouter la colonne « TelNum » à la table créée au point 5.11
**/

ALTER TABLE employes ADD TelNum nvarchar(25)
GO

CREATE TYPE telephone AS TABLE (
	id_emp int,
	num_tel nvarchar(25),
	num_tel_id int,
	date_modif datetime
)
GO

DECLARE 
	@tel_temp TELEPHONE, 
	@val_retour int

INSERT INTO @tel_temp 
SELECT * 
FROM Person.PersonPhone

EXECUTE dbo.AjouterTelEmp 
	@tel_temp, 
	@val_retour OUTPUT

PRINT CONVERT (varchar, @val_retour) + ' lignes de la table Employes modifiées'

SELECT * FROM employes
GO

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------

/**
5.13 Récolter les informations StatePronvinceID et Name de Person.StateProvince que vous recouperez avec les informations de Person.Address 
afin de mettre en relation le nom de la province où réside chaque employé dans une variable de type table. 

Toutes ces informations sont centralisées dans la table Person.BusinessEntityAddress. 

Créer une procédure qui rajoutera à la table créée au point 5.11, pour chaque employé dont le numéro de téléphone est fourni, 
le nom de la province dans laquelle il réside. La colonne supplémentaire devra être rajoutée, bien entendu.
**/

USE AdventureWorks2008R2
GO

ALTER TABLE employes ADD Province nvarchar(50)
GO

CREATE TYPE province AS TABLE (
	id_emp int,
	id_province int,
	nom_province nvarchar(50)
)
GO

DECLARE @tab_provinces PROVINCE

INSERT INTO @tab_provinces
SELECT 
	PP.BusinessEntityID, 
	Psp.StateProvinceID, 
	Psp.Name
FROM 
	Person.StateProvince Psp 
JOIN 
	Person.Address PA
ON 
	Psp.StateProvinceID = PA.StateProvinceID
JOIN
	Person.BusinessEntityAddress PBea
ON 
	PBea.AddressID = PA.AddressID
JOIN 
	Person.Person PP
ON 
	PP.BusinessEntityID = PBea.BusinessEntityID

EXECUTE dbo.AjouterProvinceEmp @tab_provinces
SELECT * FROM employes

-------------------------------------------------------------------------------------------------
--#############################################################################################--
-------------------------------------------------------------------------------------------------