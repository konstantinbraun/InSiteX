CREATE PROCEDURE [dbo].[GetPresenceData]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@CompanyLevel int,
	@AccessAreaID int,
	@EvaluationPeriod int,
	@DateFrom datetime,
	@DateUntil datetime,
	@PresenceLevel int
)
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

-- Reportdaten erstellen
DECLARE @ReportData table
(
	SystemID int NOT NULL,
	BpID int NOT NULL,
	CompanyID int DEFAULT 0 NOT NULL,
	NameVisible nvarchar(200),
	NameAdditional nvarchar(200),
	ParentID int DEFAULT 0 NOT NULL,
	TradeID int DEFAULT 0 NOT NULL,
	PresenceDay date NULL,
	EmployeeID int NULL,
	FirstName nvarchar(50) NULL,
	LastName nvarchar(50) NULL,
	AccessAt datetime NULL,
	ExitAt datetime NULL,
	PresenceSeconds bigint NULL,
	AccessAreaID int DEFAULT 0 NOT NULL,
	TimeSlotID int DEFAULT 0 NOT NULL,
	CountAs int NULL,
	TreeLevel nvarchar(50) DEFAULT '9999999999' NOT NULL,
	IndentLevel int DEFAULT 0 NOT NULL,
	CompressLevel int DEFAULT 0 NOT NULL,
	AccessTimeManual bit DEFAULT 0 NOT NULL,
	ExitTimeManual bit DEFAULT 0 NOT NULL,
	DateFrom datetime DEFAULT NULL,
	DateUntil datetime DEFAULT NULL,
	AccessAreaName nvarchar(50) DEFAULT '' NOT NULL,
	PresenceLevel int DEFAULT 0 NOT NULL
)
;

-- Gesamtsumme (100)
INSERT INTO @ReportData
SELECT 
	c.SystemID,
	c.BpID, 
	0 AS CompanyID,
	'' AS NameVisible,
	'' AS NameAdditional,
	0 AS ParentID,
	0 AS TradeID,
	NULL AS PresenceDay,
	NULL AS EmployeeID,
	'' AS FirstName,
	'' AS LastName,
	NULL AS AccessAt,
	NULL AS ExitAt,
	SUM(ISNULL(d_pc.PresenceSeconds, 0)) AS PresenceSeconds,
	0 AS AccessAreaID,
	0 AS TimeSlotID,
	SUM(ISNULL(d_pc.CountAs, 0)) AS CountAs,
	'9999999999' AS TreeLevel,
	0 AS IndentLevel,
	100 AS CompressLevel,
	0 AS AccessTimeManual,
	0 AS ExitTimeManual,
	@DateFrom AS DateFrom,
	@DateUntil AS DateUntil,
	'' AS AccessAreaName,
	@PresenceLevel
FROM @SelectedCompanies AS c
	INNER JOIN Data_PresenceCompany AS d_pc
		ON c.SystemID = d_pc.SystemID
			AND c.BpID = d_pc.BpID
			AND c.CompanyID = d_pc.CompanyID
WHERE (d_pc.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pc.PresenceDay IS NULL)
GROUP BY
	c.SystemID,
	c.BpID 
;

-- Summen Firmen und Nachunternehmer (20)
INSERT INTO @ReportData
SELECT 
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	0 AS TradeID,
	NULL AS PresenceDay,
	0 AS EmployeeID,
	'' AS FirstName,
	'' AS LastName,
	NULL AS AccessAt,
	NULL AS ExitAt,
	dbo.GetPresenceWithSubcontractorsCL(c.SystemID, c.BpID, c.CompanyID, @CompanyLevel, @SelectedCompanies, @DateFrom, @DateUntil) AS PresenceSeconds,
	0 AS AccessAreaID,
	0 AS TimeSlotID,
	dbo.GetCountWithSubcontractorsCL(c.SystemID, c.BpID, c.CompanyID, @CompanyLevel, @SelectedCompanies, @DateFrom, @DateUntil) AS CountAs,
	c.TreeLevel,
	c.IndentLevel,
	20 AS CompressLevel,
	0 AS AccessTimeManual,
	0 AS ExitTimeManual,
	@DateFrom AS DateFrom,
	@DateUntil AS DateUntil,
	'' AS AccessAreaName,
	@PresenceLevel
FROM @SelectedCompanies AS c
	LEFT OUTER JOIN Data_PresenceCompany AS d_pc
		ON c.SystemID = d_pc.SystemID
			AND c.BpID = d_pc.BpID
			AND c.CompanyID = d_pc.CompanyID
WHERE (d_pc.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pc.PresenceDay IS NULL)
GROUP BY
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	c.TreeLevel,
	c.IndentLevel
;

-- Hauptunternehmer ohne eigene anwesende MA (20)
INSERT INTO @ReportData
SELECT 
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	0 AS TradeID,
	NULL AS PresenceDay,
	0 AS EmployeeID,
	'' AS FirstName,
	'' AS LastName,
	NULL AS AccessAt,
	NULL AS ExitAt,
	dbo.GetPresenceWithSubcontractorsCL(c.SystemID, c.BpID, c.CompanyID, @CompanyLevel, @SelectedCompanies, @DateFrom, @DateUntil) AS PresenceSeconds,
	0 AS AccessAreaID,
	0 AS TimeSlotID,
	dbo.GetCountWithSubcontractorsCL(c.SystemID, c.BpID, c.CompanyID, @CompanyLevel, @SelectedCompanies, @DateFrom, @DateUntil) AS CountAs,
	c.TreeLevel,
	c.IndentLevel,
	20 AS CompressLevel,
	0 AS AccessTimeManual,
	0 AS ExitTimeManual,
	@DateFrom AS DateFrom,
	@DateUntil AS DateUntil,
	'' AS AccessAreaName,
	@PresenceLevel
FROM @SelectedCompanies AS c
	INNER JOIN @ReportData AS d_pc
		ON c.CompanyID = d_pc.ParentID
WHERE NOT EXISTS 
(
	SELECT 1 FROM @ReportData rd
	WHERE rd.SystemID = d_pc.SystemID
		AND rd.BpID = d_pc.BpID
		AND rd.CompanyID = d_pc.ParentID
		AND rd.AccessAreaID = d_pc.AccessAreaID
		AND rd.CompressLevel = d_pc.CompressLevel
)
	AND d_pc.PresenceSeconds != 0
GROUP BY
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	c.TreeLevel,
	c.IndentLevel
;


-- Daten abhängig von der Anwesenheitsvariante verdichten
-- Variante 1: Firmen Summen (10)
INSERT INTO @ReportData
SELECT 
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	0 AS TradeID,
	NULL AS PresenceDay,
	0 AS EmployeeID,
	'' AS FirstName,
	'' AS LastName,
	NULL AS AccessAt,
	NULL AS ExitAt,
	SUM(ISNULL(d_pc.PresenceSeconds, 0)) AS PresenceSeconds,
	0 AS AccessAreaID,
	0 AS TimeSlotID,
	SUM(ISNULL(d_pc.CountAs, 0)) AS CountAs,
	c.TreeLevel,
	c.IndentLevel,
	10 AS CompressLevel,
	0 AS AccessTimeManual,
	0 AS ExitTimeManual,
	@DateFrom AS DateFrom,
	@DateUntil AS DateUntil,
	'' AS AccessAreaName,
	@PresenceLevel
FROM @SelectedCompanies AS c
	LEFT OUTER JOIN Data_PresenceCompany AS d_pc
		ON c.SystemID = d_pc.SystemID
			AND c.BpID = d_pc.BpID
			AND c.CompanyID = d_pc.CompanyID
WHERE (d_pc.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pc.PresenceDay IS NULL)
GROUP BY
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	c.TreeLevel,
	c.IndentLevel
;

-- Variante 2: Mitarbeiter Summen (40)
INSERT INTO @ReportData
SELECT 
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	0 AS TradeID,
	NULL AS PresenceDay,
	d_pe.EmployeeID,
	m_a.FirstName,
	m_a.LastName,
	NULL AS AccessAt,
	NULL AS ExitAt,
	SUM(CASE WHEN @PresenceLevel = 2 THEN 1 ELSE ISNULL(d_pe.PresenceSeconds, 0) END) AS PresenceSeconds,
	0 AS AccessAreaID,
	0 AS TimeSlotID,
	SUM(ISNULL(d_pe.CountAs, 0)) AS CountAs,
	c.TreeLevel,
	c.IndentLevel,
	40 AS CompressLevel,
	0 AS AccessTimeManual,
	0 AS ExitTimeManual,
	@DateFrom AS DateFrom,
	@DateUntil AS DateUntil,
	'' AS AccessAreaName,
	@PresenceLevel
FROM @SelectedCompanies AS c
	INNER JOIN Data_PresenceEmployee AS d_pe
		ON c.SystemID = d_pe.SystemID
			AND c.BpID = d_pe.BpID
			AND c.CompanyID = d_pe.CompanyID
	INNER JOIN Master_Employees m_e
		ON d_pe.SystemID = m_e.SystemID
			AND d_pe.BpID = m_e.BpID
			AND d_pe.EmployeeID = m_e.EmployeeID
	INNER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
WHERE (d_pe.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pe.PresenceDay IS NULL)
	AND (@PresenceLevel = 2 OR @PresenceLevel = 3)
GROUP BY
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	d_pe.EmployeeID,
	m_a.FirstName,
	m_a.LastName,
	c.TreeLevel,
	c.IndentLevel
;

-- Variante 3: Mitarbeiter Zutrittsereignisse (30)
INSERT INTO @ReportData
SELECT 
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	0 AS TradeID,
	d_pae.PresenceDay,
	d_pae.EmployeeID,
	m_a.FirstName,
	m_a.LastName,
	d_pae.AccessAt AS AccessAt,
	d_pae.ExitAt AS ExitAt,
	SUM(ISNULL(d_pae.PresenceSeconds, 0)) AS PresenceSeconds,
	d_pae.AccessAreaID AS AccessAreaID,
	d_pae.TimeSlotID AS TimeSlotID,
	0 AS CountAs,
	c.TreeLevel,
	c.IndentLevel,
	30 AS CompressLevel,
	d_pae.AccessTimeManual,
	d_pae.ExitTimeManual,
	@DateFrom AS DateFrom,
	@DateUntil AS DateUntil,
	m_aa.NameVisible AS AccessAreaName,
	@PresenceLevel
FROM @SelectedCompanies AS c
	LEFT OUTER JOIN Data_PresenceAccessEvents AS d_pae
		ON c.SystemID = d_pae.SystemID
			AND c.BpID = d_pae.BpID
			AND c.CompanyID = d_pae.CompanyID
	LEFT OUTER JOIN Master_Employees m_e
		ON d_pae.SystemID = m_e.SystemID
			AND d_pae.BpID = m_e.BpID
			AND d_pae.EmployeeID = m_e.EmployeeID
	LEFT OUTER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
	LEFT OUTER JOIN Master_AccessAreas m_aa
		ON d_pae.SystemID = m_aa.SystemID
			AND d_pae.BpID = m_aa.BpID
			AND d_pae.AccessAreaID = m_aa.AccessAreaID
WHERE (d_pae.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pae.PresenceDay IS NULL)
	AND @PresenceLevel = 3
	AND d_pae.AccessAreaID = (CASE WHEN @AccessAreaID = 0 THEN d_pae.AccessAreaID ELSE @AccessAreaID END)
GROUP BY
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	d_pae.PresenceDay,
	d_pae.EmployeeID,
	m_a.FirstName,
	m_a.LastName,
	d_pae.AccessAt,
	d_pae.ExitAt,
	d_pae.AccessAreaID,
	d_pae.TimeSlotID,
	c.TreeLevel,
	c.IndentLevel,
	d_pae.AccessTimeManual,
	d_pae.ExitTimeManual,
	m_aa.NameVisible
ORDER BY TreeLevel, LastName, FirstName, CompressLevel, PresenceDay
;

SELECT 
	*
FROM @ReportData
ORDER BY
	TreeLevel, IndentLevel, NameVisible, LastName, FirstName, EmployeeID, CompressLevel DESC, PresenceDay
;

