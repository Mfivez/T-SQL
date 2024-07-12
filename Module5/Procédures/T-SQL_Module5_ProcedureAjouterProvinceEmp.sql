/**
5.13 R�colter les informations StatePronvinceID et Name de Person.StateProvince que vous recouperez avec les informations de Person.Address 
afin de mettre en relation le nom de la province o� r�side chaque employ� dans une variable de type table. 

Toutes ces informations sont centralis�es dans la table Person.BusinessEntityAddress. 

Cr�er une proc�dure qui rajoutera � la table cr��e au point 5.11, pour chaque employ� dont le num�ro de t�l�phone est fourni, 
le nom de la province dans laquelle il r�side. La colonne suppl�mentaire devra �tre rajout�e, bien entendu.
**/

USE AdventureWorks2008R2
GO

CREATE PROCEDURE dbo.AjouterProvinceEmp @tab_province PROVINCE READONLY
AS
	BEGIN
		SET NOCOUNT ON

		DECLARE CR_prov CURSOR 
		FOR SELECT * 
		FROM @tab_province

		DECLARE 
			@id_emp_temp int, 
			@id_prov_temp int, 
			@nom_prov_temp nvarchar(50)
		
		OPEN CR_prov
		
		FETCH CR_prov 
		INTO 
			@id_emp_temp, 
			@id_prov_temp, 
			@nom_prov_temp

		BEGIN TRANSACTION
			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					UPDATE employes 
					SET Province = @nom_prov_temp
					WHERE 
						id_emp = @id_emp_temp AND TelNum IS NOT NULL
					
					FETCH CR_prov 
					INTO 
						@id_emp_temp, 
						@id_prov_temp, 
						@nom_prov_temp

				END

			SELECT * FROM employes
		ROLLBACK TRANSACTION

		CLOSE CR_prov
		DEALLOCATE CR_prov
	END
GO