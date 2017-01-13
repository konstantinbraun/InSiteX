CREATE PROCEDURE [dbo].[PrintPass]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@ReplacementPassCaseID int,
	@Reason nvarchar(200),
	@UserName nvarchar(50),
	@DeactivationMessage nvarchar(500)
)
AS
	DECLARE @PassCount int
	DECLARE @ActivePassCount int
	DECLARE @PassID int

	SELECT @PassCount = PassCount
	FROM Master_Employees
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID

	IF (@ReplacementPassCaseID = 0 OR @ReplacementPassCaseID IS NULL)
		SELECT @ReplacementPassCaseID = ReplacementPassCaseID
		FROM Master_ReplacementPassCases 
		WHERE SystemID = @SystemID
			AND BpID = @BpID
			AND IsInitialIssue = 1

	-- Zutrittsrecht für alten Ausweis deaktivieren
	UPDATE Data_AccessRightEvents
	SET AccessAllowed = 0,
		AccessDenialReason = @DeactivationMessage,
		IsDelivered = 0,
		DeliveredAt = NULL,
		CreatedOn = SYSDATETIME(),
		CreatedFrom = @UserName
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND OwnerID = @EmployeeID
		AND AccessAllowed = 1 

	-- ID des Mitarbeiters von allen alten Pässen entfernen
	UPDATE Master_Passes
	SET EmployeeID = 0
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID

	-- Pass anlegen
	INSERT INTO Master_Passes
	(
		SystemID,
		BpID,
		InternalID,
		ExternalID,
		NameVisible,
		DescriptionShort,
		ValidFrom,
		ValidUntil,
		EmployeeID,
		TypeID,
		PrintedFrom,
		PrintedOn,
		CreatedFrom,
		CreatedOn,
		EditFrom,
		EditOn
	)
	VALUES
	(
		@SystemID,
		@BpID,
		NULL,
		CONVERT(nvarchar(10), @SystemID) + CONVERT(nvarchar(10), @EmployeeID) + REPLICATE('0', 2 - LEN(CONVERT(nvarchar(2), @PassCount + 1))) + CONVERT(nvarchar(2), @PassCount + 1),
		NULL,
		NULL,
		SYSDATETIME(),
		NULL,
		@EmployeeID,
		10,
		@UserName,
		SYSDATETIME(),
		@UserName,
		SYSDATETIME(),
		@UserName,
		SYSDATETIME()
	)

	SELECT @PassID = SCOPE_IDENTITY()

	-- PassCount hochsetzen
	UPDATE Master_Employees
	SET PassCount = PassCount + 1
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID

	-- Historieneintrag für Pass Druck anlegen
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
	VALUES
	(
		@SystemID,
		@BpID,
		@PassID,
		@EmployeeID,
		SYSDATETIME(),
		@Reason,
		11, -- Drucken
		@ReplacementPassCaseID
	)

	-- Druckdaten aufbereiten
SELECT
	m_e.SystemID, 
	m_e.BpID, 
	m_p.PassID, 
	m_e.EmployeeID, 
	m_c.NameVisible, 
	m_c.[Description], 
	m_a.FirstName, 
	m_a.LastName, 
	ISNULL(s_l.CountryName, N'') AS CountryName, 
	m_p.ExternalID, 
	@ReplacementPassCaseID AS PassCaseID
FROM Master_Employees AS m_e 
	INNER JOIN Master_Addresses AS m_a 
		ON m_e.SystemID = m_a.SystemID 
			AND m_e.BpID = m_a.BpID 
			AND m_e.AddressID = m_a.AddressID 
	INNER JOIN Master_Passes AS m_p 
		ON m_e.SystemID = m_p.SystemID 
			AND m_e.BpID = m_p.BpID 
			AND m_e.EmployeeID = m_p.EmployeeID 
	INNER JOIN Master_Companies AS m_c 
		ON m_e.SystemID = m_c.SystemID 
			AND m_e.BpID = m_c.BpID 
			AND m_e.CompanyID = m_c.CompanyID 
	LEFT OUTER JOIN System_Languages AS s_l 
		ON m_a.NationalityID = s_l.CountryID
WHERE m_e.SystemID = @SystemID 
	AND m_e.BpID = @BpID 
	AND m_e.EmployeeID = @EmployeeID 
	AND m_p.PrintedOn IS NOT NULL 
	AND m_p.ActivatedOn IS NULL

RETURN 0
