/**    5.9

Créer une procédure qui permet d’afficher la phrase « X employés travaillent au poste de [JobTitle de HumanResources.Employee] »

Ce nombre X sera renvoyé par une fonction que vous aurez préalablement créée et qui demande en paramètre de quel Job il s’agit, 
paramètre passé par la procédure appelante. 

Tester la procédure pour plusieurs JobTitle différents au sein de la procédure.

**/

USE AdventureWorks2008R2
GO

CREATE FUNCTION dbo.CompterJobTitle (@job nvarchar(50))
	RETURNS int
		AS
			BEGIN
				DECLARE @count int

				SELECT @count = COUNT(*) 
				FROM HumanResources.Employee
				WHERE JobTitle LIKE @job

				RETURN @count
			END
GO
