/**    5.6
Créer une fonction qui renvoie le nom du produit (Name de Production.Product) dont le prix
(StandardCost de Production.ProductCostHistory) a été modifié le plus grand nombre de fois. S’il y a
ex-aequo, il faudra renvoyer une phrase concaténée de l’ensemble des noms !
**/
USE AdventureWorks2008R2
Go

CREATE FUNCTION dbo.ModifPrix ()
	RETURNS varchar(max)
		AS
			BEGIN

				DECLARE @tabNomsProduits table (nom_prod nvarchar(50))

				DECLARE @valeurRetour varchar(max)

				INSERT INTO @tabNomsProduits
				SELECT PP.Name 
				FROM Production.Product PP
				WHERE (
						SELECT COUNT(*) 
						FROM Production.ProductCostHistory
						WHERE ProductID = PP.ProductID
						)
					= (
						SELECT MAX(Nbr) 
						FROM (
								SELECT COUNT(*) as 'Nbr'
								FROM Production.ProductCostHistory
								GROUP BY ProductID) as T
								)
				
				IF (SELECT COUNT(*) FROM @tabNomsProduits) = 1
					BEGIN
						SELECT @valeurRetour = nom_prod 
						FROM @tabNomsProduits
					END

				ELSE
					BEGIN
						DECLARE CR_NomsProduits CURSOR 
						FOR SELECT * 
						FROM @tabNomsProduits

						DECLARE 
							@nom_temp nvarchar(50), 
							@first_time int
				
						OPEN CR_NomsProduits

						FETCH CR_NomsProduits 
						INTO @nom_temp

						SET @valeurRetour = 'Noms des produits : '
						SET @first_time = 1

						WHILE (@@FETCH_STATUS = 0)
							BEGIN
								IF @first_time = 1
									BEGIN
										SET @valeurRetour = @valeurRetour + @nom_temp
									END
								ELSE
									BEGIN
										SET @valeurRetour = @valeurRetour + ' || ' +
										@nom_temp
									END

								FETCH CR_NomsProduits 
								INTO @nom_temp

								SET @first_time = 0
							END

						CLOSE CR_NomsProduits
						DEALLOCATE CR_NomsProduits
					END
			RETURN @valeurRetour
		END
GO