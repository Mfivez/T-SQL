USE AdventureWorks2008R2
GO

/**    5.1
Cr�er une proc�dure qui remplace la fonction de r�cup�ration de la date en l�affichant
directement � l��cran. L�appel de cette proc�dure permet donc d�un seul coup de r�cup�rer la date et
l�heure du syst�me, sans passer par � getDate() � ou � CURRENT_TIMESTAMP �
**/
CREATE PROCEDURE DateDuJour
AS
	PRINT getDate()
GO
