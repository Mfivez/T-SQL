/**    5.9

Cr�er une proc�dure qui permet d�afficher la phrase � X employ�s travaillent au poste de [JobTitle de HumanResources.Employee] �

Ce nombre X sera renvoy� par une fonction que vous aurez pr�alablement cr��e et qui demande en param�tre de quel Job il s�agit, 
param�tre pass� par la proc�dure appelante. 

Tester la proc�dure pour plusieurs JobTitle diff�rents au sein de la proc�dure.

**/

USE AdventureWorks2008R2
GO

CREATE PROCEDURE dbo.AnalyserHE @job nvarchar(50)
	AS
		BEGIN
			PRINT CONVERT(varchar,dbo.CompterJobTitle(@job))
					+ ' employ�s travaillent au poste de "' + @job + '"'
		END
GO