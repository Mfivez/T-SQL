/**    5.8
Créer une procédure qui récupère dans un curseur 
		- l’ensemble des produits (Name de Production.Product) 
		- et leur prix (StandardCost de Production.ProductCostHistory) 
	dont dont la valeur de « EndDate » est à « NULL ». 
	
Si le prix est de moins de 15, alors il faut inscrire ce produit dans une table non-temporaire que la procédure créera SI ELLE N’EXISTE PAS 
(référez-vous aux exemples du cours pour trouver comment faire !) 

Si le prix est plus grand que 15, alors il faudra insérer dans une table temporaire 
		- le nom du produit, 
		- le prix,
		- une phrase associée qui sera :
				- « prix bien trop élevé » si le prix est de plus de 50,
				- « prix raisonnable » si le prix est compris entre 15 et 50.

La procédure renvoie le nombre de valeurs insérées dans la table non-temporaire dans un paramètre passé en mode OUTPUT 
et affiche le contenu de la table temporaire.
**/

USE AdventureWorks2008R2
GO

CREATE PROCEDURE dbo.VerifProduits @plusDe15 
int OUTPUT

AS
	BEGIN
		SET NOCOUNT ON

		DECLARE CR_produits CURSOR
		FOR SELECT 
			PP.Name, 
			PPch.StandardCost 
		FROM 
			Production.Product PP
		JOIN 
			Production.ProductCostHistory PPch 
		ON 
			PP.ProductID = PPch.ProductID
		WHERE PPch.EndDate IS NULL

		DECLARE 
			@nom_prod nvarchar(50), 
			@cout_prod money, 
			@remarque varchar(50)
		
		IF OBJECT_ID('MoinsDe15', 'U') IS NULL
			BEGIN
				CREATE TABLE MoinsDe15 (
					nom_produit nvarchar(50),
					cout_produit money
				)
			END

		IF OBJECT_ID('tempdb..#PlusDe15') IS NOT NULL
			BEGIN
				DROP TABLE #PlusDe15
			END

		CREATE TABLE #PlusDe15 (
			nom_produit nvarchar(50),
			cout_produit money,
			remarque varchar(50)
		)

		OPEN CR_produits

		FETCH CR_produits 
		INTO 
			@nom_prod, 
			@cout_prod

		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF @cout_prod < 15
					BEGIN
						INSERT INTO MoinsDe15 
						VALUES (
							@nom_prod, 
							@cout_prod
							)
					END
				ELSE
					BEGIN
						IF @cout_prod BETWEEN 15 AND 50
							BEGIN
								SET @remarque = 'prix raisonnable'
							END
						ELSE
							BEGIN
								SET @remarque = 'prix bien trop élevé'
							END

						INSERT INTO #PlusDe15 
						VALUES (
							@nom_prod, 
							@cout_prod,
							@remarque
							)
					END

				FETCH CR_produits 
				INTO 
					@nom_prod, 
					@cout_prod
			END

		CLOSE CR_produits
		DEALLOCATE CR_produits

		SELECT * FROM #PlusDe15
		SELECT @plusDe15 = COUNT(*) FROM MoinsDe15

	END
GO