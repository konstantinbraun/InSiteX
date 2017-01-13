CREATE PROCEDURE [dbo].[MoveShortTermAccessArea]
	@SystemID int,
	@BpID int,
	@ShortTermVisitorID int,
	@AccessAreaID int,
	@User nvarchar(50)
AS
	DECLARE @Direction int
	SET @Direction = (  SELECT COUNT(*) 
						FROM Data_ShortTermAccessAreas
						WHERE SystemID = @SystemID
							AND BpID = @BpID
							AND ShortTermVisitorID = @ShortTermVisitorID
							AND AccessAreaID = @AccessAreaID)
	IF (@Direction = 0)
		BEGIN
			-- Einfügen
			INSERT INTO Data_ShortTermAccessAreas
			(
				SystemID,
				BpID,
				ShortTermVisitorID,
				AccessAreaID,
				CreatedFrom,
				CreatedOn,
				EditFrom,
				EditOn
			)
			SELECT 
				@SystemID,
				@BpID,
				@ShortTermVisitorID,
				AccessAreaID,
				@User,
				SYSDATETIME(),
				@User,
				SYSDATETIME()
			FROM Master_AccessAreas
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND AccessAreaID = @AccessAreaID
		END

	ELSE
		BEGIN
			-- Entfernen
			DELETE FROM Data_ShortTermAccessAreas
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND ShortTermVisitorID = @ShortTermVisitorID
				AND AccessAreaID = @AccessAreaID
		END

RETURN 0
