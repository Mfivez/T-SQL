/**    5.10
Créer une procédure qui affiche 
		- le nom des produits (Name de Production.Product) 
		- et le prix (ListPrice de Production.Product) des produits 
	appartenant à la même sous-catégorie que :
		- le nom de catégorie (Name de Production.ProductSubcategory) passé en paramètres à la procédure 
	et ayant :
		- un prix (ListPrice de Production.Product) inférieur à un prix également passé en paramètres. 
	
Tester la procédure dans le cas de tous les articles ayant un rapport avec « %Bikes% » et un prix inférieur à 700.

La procédure renverra également une valeur en mode OUTPUT qui informera du nombre totale de lignes non-affichées par la procédure 
(les produits non-affichés).
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