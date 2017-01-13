CREATE PROCEDURE [dbo].[DeactivatePass]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@InternalID nvarchar(50),
	@Reason nvarchar(200),
	@UserName nvarchar(50)
)
AS

	-- Historieneintrag für zu deaktivierenden Pass
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
		13, -- Deaktivieren
		NULL
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND InternalID = @InternalID

	-- Aktiven Pass deaktivieren
	UPDATE Master_Passes
	SET DeactivatedFrom = @UserName,
		DeactivatedOn = SYSDATETIME(),
		ActivatedFrom = '',
		ActivatedOn = NULL,
		EditFrom = @UserName,
		EditOn = SYSDATETIME()
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND InternalID = @InternalID
RETURN 0
