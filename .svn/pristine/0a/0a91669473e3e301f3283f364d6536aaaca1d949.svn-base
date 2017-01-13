CREATE PROCEDURE [dbo].[MoveEmployeeQualification]
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@StaffRoleID int,
	@User nvarchar(50)
AS
	DECLARE @Direction int
	SET @Direction = (  SELECT COUNT(*) 
						FROM Master_EmployeeQualification
						WHERE SystemID = @SystemID
							AND BpID = @BpID
							AND EmployeeID = @EmployeeID
							AND StaffRoleID = @StaffRoleID)
	IF (@Direction = 0)
		BEGIN
			-- Einfügen
			INSERT INTO Master_EmployeeQualification
			(
				SystemID,
				BpID,
				EmployeeID,
				StaffRoleID,
				CreatedFrom,
				CreatedOn,
				EditFrom,
				EditOn
			)
			SELECT 
				@SystemID,
				@BpID,
				@EmployeeID,
				StaffRoleID,
				@User,
				SYSDATETIME(),
				@User,
				SYSDATETIME()
			FROM Master_StaffRoles
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND StaffRoleID = @StaffRoleID
		END

	ELSE
		BEGIN
			-- Entfernen
			DELETE FROM Master_EmployeeQualification
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND EmployeeID = @EmployeeID
				AND StaffRoleID = @StaffRoleID
		END

RETURN 0
