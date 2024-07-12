/** 5.11
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

USE AdventureWorks2008R2
GO

CREATE PROCEDURE dbo.RemplirEmp @emp DONNEES_EMP READONLY
	AS
		BEGIN
			SET NOCOUNT ON

			INSERT INTO employes
			SELECT 
				id_temp, 
				nom_temp, 
				prenom_temp, 
				GETDATE(), 
				BD_temp 
			FROM @emp

			SELECT * FROM employes
		END
GO

