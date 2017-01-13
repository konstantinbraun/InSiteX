CREATE PROCEDURE [dbo].[ActivatePass]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@InternalID nvarchar(50),
	@UserName nvarchar(50)
)
AS
	DECLARE @ActivePassCount int
	DECLARE @OtherUser int

	SELECT @OtherUser = ISNULL(EmployeeID, 0)
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID != @EmployeeID
		AND InternalID = @InternalID
	
	IF (@OtherUser > 0)
		RETURN

	SELECT @ActivePassCount = COUNT(PassID)
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND ActivatedOn IS NOT NULL
		AND DeactivatedOn IS NULL
		AND LockedOn IS NULL

	IF (@ActivePassCount > 0)
		BEGIN
			-- Historieneintrag für alle aktiven Pässe
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
				NULL,
				13, -- Deaktivieren
				NULL
			FROM Master_Passes
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND EmployeeID = @EmployeeID
				AND ActivatedOn IS NOT NULL
				AND DeactivatedOn IS NULL
				AND LockedOn IS NULL

			-- Alle aktiven Pässe deaktivieren
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
				AND ActivatedOn IS NOT NULL
				AND DeactivatedOn IS NULL
				AND LockedOn IS NULL
		END

	-- Historieneintrag für zu aktivierenden Pass
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
		NULL,
		12, -- Aktivieren
		NULL
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND PrintedOn IS NOT NULL
		AND ActivatedOn IS NULL

	-- Gedruckten Pass aktivieren
	UPDATE Master_Passes
	SET InternalID = @InternalID,
		ActivatedFrom = @UserName,
		ActivatedOn = SYSDATETIME(),
		DeactivatedFrom = '',
		DeactivatedOn = NULL,
		EditFrom = @UserName,
		EditOn = SYSDATETIME()
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND PrintedOn IS NOT NULL
		AND ActivatedOn IS NULL

RETURN 0
