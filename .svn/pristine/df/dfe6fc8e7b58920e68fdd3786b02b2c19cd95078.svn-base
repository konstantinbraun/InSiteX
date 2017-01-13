CREATE PROCEDURE [dbo].[MoveCompanyAttribute]
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@AttributeID int,
	@User nvarchar(50)
AS
	DECLARE @Direction int
	SET @Direction = (  SELECT COUNT(*) 
						FROM Master_AttributesCompany
						WHERE SystemID = @SystemID
							AND BpID = @BpID
							AND CompanyID = @CompanyID
							AND AttributeID = @AttributeID)
	IF (@Direction = 0)
		BEGIN
			-- Einfügen
			INSERT INTO Master_AttributesCompany
			(
				SystemID,
				BpID,
				AttributeID,
				CompanyID,
				CreatedFrom,
				CreatedOn,
				EditFrom,
				EditOn
			)
			VALUES
			( 
				@SystemID,
				@BpID,
				@AttributeID,
				@CompanyID,
				@User,
				SYSDATETIME(),
				@User,
				SYSDATETIME()
			)
		END

	ELSE
		BEGIN
			-- Entfernen
			DELETE FROM Master_AttributesCompany
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND CompanyID = @CompanyID
				AND AttributeID = @AttributeID
		END

RETURN 0
