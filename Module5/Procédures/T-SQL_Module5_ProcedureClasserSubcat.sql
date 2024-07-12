/**    5.10
Cr�er une proc�dure qui affiche 
		- le nom des produits (Name de Production.Product) 
		- et le prix (ListPrice de Production.Product) des produits 
	appartenant � la m�me sous-cat�gorie que :
		- le nom de cat�gorie (Name de Production.ProductSubcategory) pass� en param�tres � la proc�dure 
	et ayant :
		- un prix (ListPrice de Production.Product) inf�rieur � un prix �galement pass� en param�tres. 
	
Tester la proc�dure dans le cas de tous les articles ayant un rapport avec � %Bikes% � et un prix inf�rieur � 700.

La proc�dure renverra �galement une valeur en mode OUTPUT qui informera du nombre totale de lignes non-affich�es par la proc�dure 
(les produits non-affich�s).
**/

USE AdventureWorks2008R2
GO

CREATE PROCEDURE dbo.ClasserSubcat 
	@nom_subcat nvarchar(50), 
	@prix money,
	@total_non_affiche int
	OUTPUT
AS
	BEGIN
		SET NOCOUNT ON

		DECLARE @total_affiche int

		SELECT 
			PP.Name, 
			PP.ListPrice 
		FROM 
			Production.Product PP 
		JOIN
			Production.ProductSubcategory PPs
		ON 
			PP.ProductSubcategoryID = PPs.ProductSubcategoryID
		WHERE 
			PPs.Name LIKE @nom_subcat AND PP.ListPrice < @prix

		SET @total_affiche = @@ROWCOUNT

		SELECT @total_non_affiche = COUNT(*) - @total_affiche 
		FROM Production.Product
	END
GO