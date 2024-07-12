/**    5.3
Cr�er une proc�dure qui ins�re dans une table temporaire les donn�es vous concernant. 
Ces donn�es sont fournies en param�tres.
**/
USE AdventureWorks2008R2
GO

CREATE PROCEDURE InsererDonneesPerso
									@nom VARCHAR(50),
									@prenom VARCHAR(50),
									@adresse VARCHAR(50),
									@naiss DATE
AS
	CREATE TABLE #donnees_temp (
								nom nvarchar(50), 
								prenom nvarchar(50),
								adresse nvarchar(50), 
								b_date date
								)

	INSERT INTO #donnees_temp 
	VALUES (
			@nom, 
			@prenom, 
			@adresse, 
			@naiss
			)

	SELECT * FROM #donnees_temp
GO
								