/**    5.12
Récupérer les données de la table Person.PersonPhone dans une variable de type table. 

Passer la variable fournie à une procédure qui vous permettra de rajouter les numéros de téléphones
correspondants aux employés que vous avez entrés au point 5.11.

Par contre, on ne retiendra dans notre table personnelle les numéros que s’ils sont de type 3 (PhoneNumberTypeID). 
La procédure renvoie le nombre de lignes mises à jour via un paramètre en mode OUTPUT Il faudra bien entendu
ajouter la colonne « TelNum » à la table créée au point 5.11
**/
USE AdventureWorks2008R2
GO

CREATE PROCEDURE dbo.AjouterTelEmp 
	@tab_tel TELEPHONE READONLY,
	@lignes_modif int OUTPUT
AS
	BEGIN
		SET NOCOUNT ON

		SET @lignes_modif = 0

		DECLARE CR_tel CURSOR 
		FOR SELECT * 
		FROM @tab_tel

		DECLARE 
			@id_temp int, 
			@tel_temp nvarchar(25), 
			@id_tel_temp int,
			@date_temp datetime

		OPEN CR_tel

		FETCH CR_tel 
		INTO 
			@id_temp, 
			@tel_temp, 
			@id_tel_temp, 
			@date_temp

		-- BEGIN TRANSACTION
		WHILE (@@FETCH_STATUS = 0)
			BEGIN
				IF @id_tel_temp = 3
					BEGIN
						UPDATE employes 
						SET TelNum = @tel_temp
						WHERE id_emp = @id_temp

						IF @@ROWCOUNT = 1
							BEGIN
								SET @lignes_modif = @lignes_modif + 1
							END
					END
				
				FETCH CR_tel 
				INTO 
					@id_temp, 
					@tel_temp, 
					@id_tel_temp, 
					@date_temp

			END
		SELECT * FROM employes

		-- ROLLBACK TRANSACTION
		CLOSE CR_tel
		DEALLOCATE CR_tel
	END
GO