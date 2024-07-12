/** 5.11
Cr�er une table employes pouvant r�cup�rer 
		- les ID, 
		- noms, 
		- pr�noms, 
		- dates d�embauche 
		- et dates de naissance des employ�s (HumanResources.Employee de AdventureWorks2008R2). 
		
Cr�er une proc�dure capable de remplir votre table d�un seul coup en utilisant les donn�es pass�es en param�tres.

Les donn�es pass�es seront contenues dans une variable de type table qui contiendra les 
		- ID, 
		- noms,
		- pr�noms 
		- et dates de naissance des employ�s. 
		
La date d�embauche sera la date du jour que vous compl�terez vous-m�me � partir de la proc�dure.
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

