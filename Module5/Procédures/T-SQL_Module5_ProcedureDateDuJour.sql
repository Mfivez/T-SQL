USE AdventureWorks2008R2
GO

/**    5.1
Créer une procédure qui remplace la fonction de récupération de la date en l’affichant
directement à l’écran. L’appel de cette procédure permet donc d’un seul coup de récupérer la date et
l’heure du système, sans passer par « getDate() » ou « CURRENT_TIMESTAMP »
**/
CREATE PROCEDURE DateDuJour
AS
	PRINT getDate()
GO
