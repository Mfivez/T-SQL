/**    5.7
Cr�er une proc�dure ayant un param�tre en mode OUTPUT qui permet de modifier les lignes
de la table HumanResources.Employee et de mettre la date � ModifiedDate � � la date du jour, 

si cette date n�est pas �gale au 31 juillet 2008. La proc�dure renverra le nombre de lignes r�ellement mises �
jour, via son param�tre OUTPUT. 

Faites l�exercice avec une simple requ�te d�update. Faites une seconde version qui stocke 
au pr�alable les valeurs � mettre � jour dans un curseur d�clar� au sein de la proc�dure.
**/

-- REMARQUE :: Les "BEGIN TRANSACTION" et "ROLLBACK TRANSACTION"
--sont utilis�s ici afin de ne pas modifier effectivement les
-- donn�es et pouvoir refaire l'exercice plusieurs fois

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