CREATE PROCEDURE [dbo].[LockPass]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@Reason nvarchar(200),
	@UserName nvarchar(50)
)
AS

	-- Historieneintrag für zu sperrenden Pass
	INSERT INTO Data_PassHistory
	(
		SystemID,
		BpID,
		PassID,
		EmployeeID,
		[Timestamp],
		Reason,
		ActionID,
		ReplacementPassCaseID
	)
	SELECT
		@SystemID,
		@BpID,
		PassID,
		EmployeeID,
		SYSDATETIME(),
		@Reason,
		6, -- Sperren
		NULL
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND PrintedOn IS NOT NULL
		AND ActivatedOn IS NOT NULL
		AND DeactivatedOn IS NULL

	-- Aktiven Pass sperren
	UPDATE Master_Passes
	SET LockedFrom = @UserName,
		LockedOn = SYSDATETIME(),
		ActivatedFrom = NULL,
		ActivatedOn = NULL,
		EditFrom = @UserName,
		EditOn = SYSDATETIME()
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND PrintedOn IS NOT NULL
		AND ActivatedOn IS NOT NULL
		AND DeactivatedOn IS NULL
RETURN 0
