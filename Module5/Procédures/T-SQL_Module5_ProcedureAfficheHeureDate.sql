/**    5.2
Cr�er une proc�dure qui affichera la phrase 
� Nous sommes le [Date_du_jour] et il est actuellement [heure_du_moment] �.
**/
USE AdventureWorks2008R2
GO

CREATE PROCEDURE AfficheHeureDate
AS
	PRINT 'Nous sommes le ' + CONVERT(VARCHAR, getDate(), 106)
			+ ' et il est actuellement ' + CONVERT(VARCHAR, getDate(), 108)
GO