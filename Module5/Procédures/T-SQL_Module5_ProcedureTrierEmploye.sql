/**    5.4
Créer une procédure qui insère des données dans deux tables temporaires distinctes #Anciens et #Jeunes. 
Si l’employé est né avant 1980 et après 1970, et qu’il a été engagé dans l’entreprise avant 2008, il rentre dans la première table #Anciens. 
S’il est né après 1990, et qu’il a été engagé après 2010 il se retrouve dans la deuxième table #Jeunes
**/

USE AdventureWorks2008R2
GO

CREATE PROCEDURE TrierEmploye
AS
	IF OBJECT_ID('tempdb..#Anciens') IS NOT NULL
		BEGIN
			DROP TABLE #Anciens
		END

	IF OBJECT_ID('tempdb..#Jeunes') IS NOT NULL
		BEGIN
			DROP TABLE #Jeunes
		END

	CREATE TABLE #Anciens (
							id int, 
							nom nvarchar(50), 
							prenom nvarchar(50),
							b_date date, 
							h_date date
							)

	CREATE TABLE #Jeunes (
							id int, 
							nom nvarchar(50), 
							prenom nvarchar(50),
							b_date date, 
							h_date date
							)

	INSERT INTO #Anciens
	SELECT 
		HE.BusinessEntityID, 
		PP.LastName, 
		PP.FirstName, 
		HE.BirthDate,
		HE.HireDate
	FROM 
		HumanResources.Employee HE 
	JOIN 
		Person.Person PP
	ON 
		HE.BusinessEntityID = PP.BusinessEntityID
	WHERE 
		YEAR(HE.BirthDate) BETWEEN 1970 AND 1980 AND YEAR(HE.HireDate) < 2008
	
	INSERT INTO #Jeunes
	SELECT 
		HE.BusinessEntityID, 
		PP.LastName, 
		PP.FirstName, 
		HE.BirthDate,
		HE.HireDate
	FROM 
		HumanResources.Employee HE 
	JOIN 
		Person.Person PP
	ON 
		HE.BusinessEntityID = PP.BusinessEntityID
	WHERE 
		YEAR(HE.BirthDate) > 1990 AND YEAR(HE.HireDate) > 2010
	
	SELECT * FROM #Anciens
	SELECT * FROM #Jeunes
go