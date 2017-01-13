CREATE PROCEDURE [dbo].[GetPassBillings]
	@SystemID int,
	@BpID int,
	@CompanyID int = 0,
	@EvaluationPeriod int,
	@DateFrom datetime,
	@DateUntil datetime,
	@CompanyLevel int,
	@Remarks nvarchar(200)
AS

DECLARE @MinDate datetime = '01-01-2000 00:00:00';
DECLARE @BeginOfWeek datetime = CAST(DATEADD(D, - (DATEPART(DW, CAST(SYSDATETIME() AS date)) + @@DATEFIRST - 2) % 7, CAST(SYSDATETIME() AS date)) AS datetime);
DECLARE @BeginOfMonth date = DATEFROMPARTS(DATEPART(YYYY, CAST(SYSDATETIME() AS date)), DATEPART(M, CAST(SYSDATETIME() AS date)), 1);

IF (@EvaluationPeriod = 2)
	-- Aufgelaufen bis gestern
	BEGIN
		SET @DateFrom = @MinDate
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime))
	END

ELSE IF (@EvaluationPeriod = 3)
	-- Aufgelaufen bis letzte Woche
	BEGIN
		SET @DateFrom = @MinDate
		SET @DateUntil = DATEADD(MILLISECOND, -10, @BeginOfWeek)
	END

ELSE IF (@EvaluationPeriod = 4)
	-- Aufgelaufen bis letzten Monat
	BEGIN
		SET @DateFrom = @MinDate
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(@BeginOfMonth AS datetime))
	END

ELSE IF (@EvaluationPeriod = 5)
	-- Nur letzter Monat
	BEGIN
		IF DATEPART(M, CAST(SYSDATETIME() AS date)) = 1
			SET @DateFrom = DATEFROMPARTS(YEAR(SYSDATETIME())-1, 12, 1)
		ELSE
			SET @DateFrom = DATEFROMPARTS(DATEPART(YYYY, CAST(SYSDATETIME() AS date)), DATEPART(M, CAST(SYSDATETIME() AS date)) - 1, 1)
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(@BeginOfMonth AS datetime))
	END

ELSE IF (@EvaluationPeriod = 6)
	-- Nur letzte Woche
	BEGIN
		SET @DateFrom = DATEADD(WEEK, -1, @BeginOfWeek)
		SET @DateUntil = DATEADD(MILLISECOND, -10, @BeginOfWeek)
	END

ELSE IF (@EvaluationPeriod = 7)
	-- Nur letzter Tag
	BEGIN
		SET @DateFrom = DATEADD(D, -1, CAST(CAST(SYSDATETIME() AS date) AS datetime))
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime))
	END

ELSE IF (@EvaluationPeriod = 8)
	-- Aufgelaufen aktueller Monat bis gestern
	BEGIN
		SET @DateFrom = @BeginOfMonth
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime))
	END

ELSE IF (@EvaluationPeriod = 9)
	-- Aufgelaufen aktuelle Woche bis gestern
	BEGIN
		SET @DateFrom = @BeginOfWeek
		SET @DateUntil = DATEADD(MILLISECOND, -10, CAST(CAST(SYSDATETIME() AS date) AS datetime))
	END
;

-- Hilfstabelle für selektierte Firmen
DECLARE @SelectedCompanies SelectedCompanies;

IF (@CompanyLevel = 1)
	-- Hauptunternehmer selektieren
	INSERT INTO @SelectedCompanies 
	(
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel
	)
	SELECT
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		NameVisible,
		NameAdditional,
		CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
		1
	FROM Master_Companies
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND CompanyID = (CASE WHEN @CompanyID = 0 THEN CompanyID ELSE @CompanyID END)
		AND ParentID = (CASE WHEN @CompanyID = 0 THEN 0 ELSE ParentID END)
	;

IF (@CompanyLevel = 2)
	-- Hauptunternehmer und direkte Subunternehmer selektieren
	WITH Companies AS
	(
		SELECT 
			SystemID, 
			BpID, 
			CompanyID, 
			ParentID, 
			NameVisible, 
			NameAdditional, 
			CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
			1 AS IndentLevel
		FROM Master_Companies
			WHERE SystemID = @SystemID 
				AND BpID = @BpID 
				AND CompanyID = (CASE WHEN @CompanyID = 0 THEN CompanyID ELSE @CompanyID END) 
				AND ParentID = (CASE WHEN @CompanyID = 0 THEN 0 ELSE ParentID END)

		UNION ALL
	
		SELECT 
			m_c.SystemID, 
			m_c.BpID, 
			m_c.CompanyID, 
			m_c.ParentID, 
			m_c.NameVisible, 
			m_c.NameAdditional, 
			CAST(TreeLevel + ';' + RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel,
			IndentLevel + 1 AS IndentLevel
		FROM Master_Companies m_c
			INNER JOIN Companies
				ON Companies.SystemID = m_c.SystemID
					AND Companies.BpID = m_c.BpID
					AND Companies.CompanyID = m_c.ParentID
	)
	INSERT INTO @SelectedCompanies 
	(
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel
	)
	SELECT DISTINCT
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		REPLICATE(CHAR(9), IndentLevel - 1) + NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel 
	FROM Companies
	WHERE IndentLevel <= 2
	ORDER BY TreeLevel
	;

ELSE IF (@CompanyLevel = 3)
	-- Hauptunternehmer und alle Subunternehmer selektieren
	WITH Companies AS
	(
		SELECT 
			SystemID, 
			BpID, 
			CompanyID, 
			ParentID, 
			NameVisible, 
			NameAdditional, 
			CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
			1 AS IndentLevel
		FROM Master_Companies
			WHERE SystemID = @SystemID 
				AND BpID = @BpID 
				AND CompanyID = (CASE WHEN @CompanyID = 0 THEN CompanyID ELSE @CompanyID END) 
				AND ParentID = (CASE WHEN @CompanyID = 0 THEN 0 ELSE ParentID END)

		UNION ALL
	
		SELECT 
			m_c.SystemID, 
			m_c.BpID, 
			m_c.CompanyID, 
			m_c.ParentID, 
			m_c.NameVisible, 
			m_c.NameAdditional, 
			CAST(TreeLevel + ';' + RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel,
			IndentLevel + 1 AS IndentLevel
		FROM Master_Companies m_c
			INNER JOIN Companies
				ON Companies.SystemID = m_c.SystemID
					AND Companies.BpID = m_c.BpID
					AND Companies.CompanyID = m_c.ParentID
	)
	INSERT INTO @SelectedCompanies 
	(
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel
	)
	SELECT DISTINCT
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		REPLICATE('·  ', IndentLevel - 1) + NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel 
	FROM Companies
	ORDER BY TreeLevel
	;

-- Addressdaten Hauptunternehmer
SELECT DISTINCT
	m_c.SystemID,
	m_c.BpID,
	m_c.CompanyID,
	0 AS ParentID,
	1 AS IsMainContractor,
	m_c.NameVisible AS CompanyName,
	m_c.NameAdditional,
	s_a.Address1,
	s_a.Address2,
	s_a.Zip,
	s_a.City,
	s_a.CountryID,
	0 AS EmployeeID,
	'' AS FirstName,
	'' AS LastName,
	'' AS ReplacementCase,
	0 AS PassID,
	'' AS ExternalID,
	'' AS Reason,
	NULL AS PrintedOn,
	'' AS PrintedFrom,
	0 AS PrintCount,
	NULL AS ActivatedOn,
	'' AS ActivatedFrom,
	0  AS ActiveCount,
	NULL AS LockedOn,
	'' AS LockedFrom,
	0 AS LockCount,
	0 AS Cost,
	'' AS Currency,
	CONVERT(bit, 0) AS CreditForOldPass,
	'' AS InvoiceTo,
	CONVERT(bit, 0) AS WillBeCharged,
	@Remarks AS Remarks,
	sc.TreeLevel,
	m_c.PassBudget,
	0 AS FirstPassCount,
	0 AS SecondPassCount
FROM Master_Companies m_c
	INNER JOIN System_Addresses s_a
		ON s_a.SystemID = m_c.SystemID
			AND s_a.AddressID = m_c.AddressID
	INNER JOIN @SelectedCompanies sc
		ON sc.CompanyID = m_c.CompanyID
WHERE m_c.SystemID = @SystemID
	AND m_c.BpID = @BpID
	AND sc.IndentLevel = 1

UNION

-- Abrechnungsdaten selektieren
SELECT 
	d_ph.SystemID,
	d_ph.BpID,
	m_c.CompanyID,
	(CASE WHEN m_c.ParentID = 0 OR m_c.ParentID = @CompanyID THEN m_c.CompanyID ELSE m_c.ParentID END) AS ParentID,
	(CASE WHEN m_c.ParentID = 0 OR m_c.ParentID = @CompanyID THEN 1 ELSE 0 END) AS IsMainContractor,
	m_c.NameVisible AS CompanyName,
	m_c.NameAdditional,
	s_a.Address1,
	s_a.Address2,
	s_a.Zip,
	s_a.City,
	s_a.CountryID,
	d_ph.EmployeeID AS EmployeeID,
	m_ae.FirstName,
	m_ae.LastName,
	m_rpc.NameVisible AS ReplacementCase,
	d_ph.PassID,
	m_p.ExternalID,
	d_ph.Reason,
	m_p.PrintedOn,
	m_p.PrintedFrom,
	(CASE WHEN m_p.PrintedOn IS NULL THEN 0 ELSE 1 END) AS PrintCount,
	m_p.ActivatedOn,
	m_p.ActivatedFrom,
	(CASE WHEN m_p.LockedOn IS NULL AND m_p.ActivatedOn IS NOT NULL THEN 1 ELSE 0 END) AS ActiveCount,
	m_p.LockedOn,
	m_p.LockedFrom,
	(CASE WHEN m_p.LockedOn IS NULL THEN 0 ELSE 1 END) AS LockCount,
	m_rpc.Cost,
	m_rpc.Currency,
	m_rpc.CreditForOldPass,
	m_rpc.InvoiceTo,
	m_rpc.WillBeCharged,
	@Remarks AS Remarks,
	sc.TreeLevel,
	m_c.PassBudget,
	(CASE WHEN m_rpc.IsInitialIssue = 1 THEN 1 ELSE 0 END) AS FirstPassCount,
	(CASE WHEN m_rpc.IsInitialIssue = 1 THEN 0 ELSE 1 END) AS SecondPassCount
FROM Data_PassHistory d_ph
	INNER JOIN Master_ReplacementPassCases m_rpc
		ON m_rpc.SystemID = d_ph.SystemID
			AND m_rpc.BpID = d_ph.BpID
			AND m_rpc.ReplacementPassCaseID = d_ph.ReplacementPassCaseID
	INNER JOIN Master_Employees m_e
		ON m_e.SystemID = d_ph.SystemID
			AND m_e.BpID = d_ph.BpID
			AND m_e.EmployeeID = d_ph.EmployeeID
	INNER JOIN Master_Addresses m_ae
		ON m_ae.SystemID = m_e.SystemID
			AND m_ae.BpID = m_e.BpID
			AND m_ae.AddressID = m_e.AddressID
	INNER JOIN @SelectedCompanies sc
		ON sc.CompanyID = m_e.CompanyID
	INNER JOIN Master_Companies m_c
		ON m_c.SystemID = m_e.SystemID
			AND m_c.BpID = m_e.BpID
			AND m_c.CompanyID = m_e.CompanyID
	INNER JOIN System_Addresses s_a
		ON s_a.SystemID = m_c.SystemID
			AND s_a.AddressID = m_c.AddressID
	LEFT OUTER JOIN Master_Passes m_p
		ON m_p.SystemID = d_ph.SystemID
			AND m_p.BpID = d_ph.BpID
			AND m_p.PassID = d_ph.PassID
WHERE d_ph.SystemID = @SystemID
	AND d_ph.BpID = @BpID
	AND d_ph.ActionID = 11
	AND d_ph.ReplacementPassCaseID IS NOT NULL
	AND EXISTS 
		(
			SELECT 1
			FROM Data_PassHistory d_ph1
			WHERE d_ph1.SystemID = @SystemID
				AND d_ph1.BpID = @BpID
				AND d_ph1.PassID = d_ph.PassID
				AND d_ph1.ActionID = 12
				AND d_ph1.ReplacementPassCaseID IS NULL
				AND d_ph1.[Timestamp] BETWEEN @DateFrom AND @DateUntil
		)
ORDER BY 
	sc.TreeLevel, 
	EmployeeID, 
	ReplacementCase
