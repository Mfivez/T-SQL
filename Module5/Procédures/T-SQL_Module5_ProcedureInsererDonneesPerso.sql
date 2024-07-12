/**    5.3
Créer une procédure qui insère dans une table temporaire les données vous concernant. 
Ces données sont fournies en paramètres.
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
								