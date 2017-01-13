CREATE PROCEDURE [dbo].[MoveEmployeeAccessArea]
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@AccessAreaID int,
	@User nvarchar(50)
AS
	DECLARE @Direction int
	SET @Direction = (  SELECT COUNT(*) 
						FROM Master_EmployeeAccessAreas
						WHERE SystemID = @SystemID
							AND BpID = @BpID
							AND EmployeeID = @EmployeeID
							AND AccessAreaID = @AccessAreaID)
	IF (@Direction = 0)
		BEGIN
			-- Einfügen
			INSERT INTO Master_EmployeeAccessAreas
			(
				SystemID,
				BpID,
				EmployeeID,
				AccessAreaID,
				CreatedFrom,
				CreatedOn,
				EditFrom,
				EditOn
			)
			SELECT 
				@SystemID,
				@BpID,
				@EmployeeID,
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
			DELETE FROM Master_EmployeeAccessAreas
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND EmployeeID = @EmployeeID
				AND AccessAreaID = @AccessAreaID
		END

RETURN 0
