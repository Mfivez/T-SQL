/**    5.7
Créer une procédure ayant un paramètre en mode OUTPUT qui permet de modifier les lignes
de la table HumanResources.Employee et de mettre la date « ModifiedDate » à la date du jour, 

si cette date n’est pas égale au 31 juillet 2008. La procédure renverra le nombre de lignes réellement mises à
jour, via son paramètre OUTPUT. 

Faites l’exercice avec une simple requête d’update. Faites une seconde version qui stocke 
au préalable les valeurs à mettre à jour dans un curseur déclaré au sein de la procédure.
**/

-- REMARQUE :: Les "BEGIN TRANSACTION" et "ROLLBACK TRANSACTION"
--sont utilisés ici afin de ne pas modifier effectivement les
-- données et pouvoir refaire l'exercice plusieurs fois

-- Sans curseur

CREATE PROCEDURE dbo.MajHE @nbreLignesModif int OUTPUT
	AS
		BEGIN
			BEGIN TRANSACTION
				UPDATE HumanResources.Employee 
				SET ModifiedDate = GETDATE()

				WHERE ModifiedDate <> CONVERT(datetime, '2008-07-31')
				SET @nbreLignesModif = @@ROWCOUNT

			ROLLBACK TRANSACTION
		END
GO

-- Avec curseur
CREATE PROCEDURE dbo.MajHEbis @nbreLignesModif int OUTPUT
	AS
		BEGIN
			SET NOCOUNT ON

			DECLARE CR_Modifs CURSOR
			FOR SELECT BusinessEntityID 
			FROM HumanResources.Employee
			WHERE ModifiedDate <> CONVERT(datetime, '2008-07-31')
			
			DECLARE 
				@id_emp int, 
				@count int

			SET @count = 0

			OPEN CR_Modifs

			FETCH CR_Modifs 
			INTO @id_emp

			BEGIN TRANSACTION
				WHILE (@@FETCH_STATUS = 0)
					BEGIN
						UPDATE HumanResources.Employee 
						SET ModifiedDate = GETDATE()
						WHERE BusinessEntityID = @id_emp
			
						SET @count = @count + 1

						FETCH CR_Modifs 
						INTO @id_emp
					END

				SET @nbreLignesModif = @count

				ROLLBACK TRANSACTION

			CLOSE CR_Modifs
			DEALLOCATE CR_Modifs
		END
GO