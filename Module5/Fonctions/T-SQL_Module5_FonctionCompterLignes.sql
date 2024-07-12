/**    5.5
Créer une fonction qui renvoie le nombre de lignes contenues dans la table HumanResources.Employee
**/

USE AdventureWorks2008R2
GO

CREATE FUNCTION dbo.CompterLesLignes()
	RETURNS INT
		AS
			BEGIN
				DECLARE @total INT

				SELECT @total = COUNT(*) FROM HumanResources.Employee

				RETURN @total
			END

GO