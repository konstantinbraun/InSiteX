CREATE PROCEDURE [dbo].[GetPresenceData000]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@DateFrom date,
	@DateUntil date,
	@NameIsVisible bit,
	@CompanyLevel int,
	@CompressType int
)
AS

-- Hilfstabelle
DECLARE @SelectedCompanies table
(
	SystemID int,
	BpID int,
	CompanyID int PRIMARY KEY,
	ParentID int,
	NameVisible nvarchar(50),
	NameAdditional nvarchar(200),
	TreeLevel nvarchar(50),
	IndentLevel int
)

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
		CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50)) AS TreeLevel,
		1
	FROM Master_Companies
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND CompanyID = (CASE WHEN @CompanyID = 0 THEN CompanyID ELSE @CompanyID END)

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
			CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50)) AS TreeLevel, 
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
			CAST(TreeLevel + ';' + CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50)) AS nvarchar(50)) AS TreeLevel,
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
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel 
	FROM Companies
	WHERE IndentLevel <= 2
	ORDER BY TreeLevel;

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
			CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50)) AS TreeLevel, 
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
			CAST(TreeLevel + ';' + CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50)) AS nvarchar(50)) AS TreeLevel,
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
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel 
	FROM Companies
	ORDER BY TreeLevel;

-- Summenzeilen generieren
WITH PresenceData AS
(
	SELECT 
		c.SystemID,
		c.BpID, 
		c.CompanyID,
		c.ParentID,
		c.NameVisible,
		c.NameAdditional,
		c.TreeLevel,
		c.IndentLevel,
		ISNULL(d_pc.PresenceSeconds, 0) AS PresenceSeconds,
		ISNULL(d_pe.CountAs, 0) AS CountAs
	FROM @SelectedCompanies AS c
		INNER JOIN Data_PresenceCompany AS d_pc
			ON c.CompanyID = d_pc.CompanyID
		INNER JOIN Data_PresenceEmployee AS d_pe
			ON d_pc.SystemID = d_pe.SystemID
				AND d_pc.BpID = d_pe.BpID
				AND d_pc.CompanyID = d_pe.CompanyID
				AND d_pc.TradeID = d_pe.TradeID
				AND d_pc.PresenceDay = d_pe.PresenceDay
	WHERE (d_pc.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pc.PresenceDay IS NULL)
--		AND dbo.HasSubcontractors(c.SystemID, c.BpID, c.CompanyID) = 1

	UNION ALL

	SELECT 
		c.SystemID,
		c.BpID, 
		c.CompanyID,
		c.ParentID,
		c.NameVisible,
		c.NameAdditional,
		c.TreeLevel,
		c.IndentLevel,
		ISNULL(d_pc.PresenceSeconds, 0) AS PresenceSeconds,
		ISNULL(d_pe.CountAs, 0) AS CountAs
	FROM @SelectedCompanies AS c
		INNER JOIN Data_PresenceCompany AS d_pc
			ON c.CompanyID = d_pc.CompanyID
		INNER JOIN Data_PresenceEmployee AS d_pe
			ON d_pc.SystemID = d_pe.SystemID
				AND d_pc.BpID = d_pe.BpID
				AND d_pc.CompanyID = d_pe.CompanyID
				AND d_pc.TradeID = d_pe.TradeID
				AND d_pc.PresenceDay = d_pe.PresenceDay
		INNER JOIN PresenceData AS p
			ON c.SystemID = p.SystemID
				AND c.BpID = p.BpID
				AND c.ParentID = p.CompanyID
	WHERE (d_pc.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pc.PresenceDay IS NULL)
)
SELECT 
	SystemID,
	BpID, 
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID,
	0 AS TradeID,
	NULL AS PresenceDay,
	0 AS EmployeeID,
	'' AS FirstName,
	'' AS LastName,
	NULL AS AccessAt,
	NULL AS ExitAt,
	SUM(PresenceSeconds) AS PresenceSeconds,
	0 AS AccessAreaID,
	0 AS TimeSlotID,
	SUM(CountAs) AS CountAs,
	MAX(TreeLevel) AS TreeLevel,
	MAX(IndentLevel) AS IndentLevel,
	-1 AS CompressLevel,
	0 AS AccessTimeManual,
	0 AS ExitTimeManual
FROM PresenceData
GROUP BY
	SystemID,
	BpID, 
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID

UNION

-- Daten abhängig von der Anwesenheitsvariante verdichten
-- Variante 1
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
	SUM(ISNULL(d_pe.CountAs, 0)) AS CountAs,
	c.TreeLevel,
	c.IndentLevel,
	1 AS CompressLevel,
	0 AS AccessTimeManual,
	0 AS ExitTimeManual
FROM @SelectedCompanies AS c
	LEFT OUTER JOIN Data_PresenceCompany AS d_pc
		ON c.CompanyID = d_pc.CompanyID
	LEFT OUTER JOIN Data_PresenceEmployee AS d_pe
		ON d_pc.SystemID = d_pe.SystemID
			AND d_pc.BpID = d_pe.BpID
			AND d_pc.CompanyID = d_pe.CompanyID
			AND d_pc.TradeID = d_pe.TradeID
			AND d_pc.PresenceDay = d_pe.PresenceDay
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

UNION

-- Variante 2
SELECT 
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	0 AS TradeID,
	NULL AS PresenceDay,
	(CASE WHEN @NameIsVisible = 1 THEN d_pe.EmployeeID ELSE '' END) AS EmployeeID,
	(CASE WHEN @NameIsVisible = 1 THEN m_a.FirstName ELSE '' END) AS FirstName,
	(CASE WHEN @NameIsVisible = 1 THEN m_a.LastName ELSE '' END) AS LastName,
	NULL AS AccessAt,
	NULL AS ExitAt,
	SUM(ISNULL(d_pe.PresenceSeconds, 0)) AS PresenceSeconds,
	0 AS AccessAreaID,
	0 AS TimeSlotID,
	SUM(ISNULL(d_pe.CountAs, 0)) AS CountAs,
	c.TreeLevel,
	c.IndentLevel,
	2 AS CompressLevel,
	0 AS AccessTimeManual,
	0 AS ExitTimeManual
FROM @SelectedCompanies AS c
	LEFT OUTER JOIN Data_PresenceEmployee AS d_pe
		ON c.CompanyID = d_pe.CompanyID
	LEFT OUTER JOIN Master_Employees m_e
		ON d_pe.SystemID = m_e.SystemID
			AND d_pe.BpID = m_e.BpID
			AND d_pe.EmployeeID = m_e.EmployeeID
	LEFT OUTER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
WHERE (d_pe.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pe.PresenceDay IS NULL)
	AND (@CompressType = 2 OR @CompressType = 3)
GROUP BY
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	(CASE WHEN @NameIsVisible = 1 THEN d_pe.EmployeeID ELSE '' END),
	(CASE WHEN @NameIsVisible = 1 THEN m_a.FirstName ELSE '' END),
	(CASE WHEN @NameIsVisible = 1 THEN m_a.LastName ELSE '' END),
	c.TreeLevel,
	c.IndentLevel

UNION

-- Variante 3
SELECT 
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	0 AS TradeID,
	d_pae.PresenceDay,
	(CASE WHEN @NameIsVisible = 1 THEN d_pae.EmployeeID ELSE '' END) AS EmployeeID,
	(CASE WHEN @NameIsVisible = 1 THEN m_a.FirstName ELSE '' END) AS FirstName,
	(CASE WHEN @NameIsVisible = 1 THEN m_a.LastName ELSE '' END) AS LastName,
	d_pae.AccessAt AS AccessAt,
	d_pae.ExitAt AS ExitAt,
	SUM(ISNULL(d_pae.PresenceSeconds, 0)) AS PresenceSeconds,
	d_pae.AccessAreaID AS AccessAreaID,
	d_pae.TimeSlotID AS TimeSlotID,
	0 AS CountAs,
	c.TreeLevel,
	c.IndentLevel,
	3 AS CompressLevel,
	d_pae.AccessTimeManual,
	d_pae.ExitTimeManual
FROM @SelectedCompanies AS c
	LEFT OUTER JOIN Data_PresenceAccessEvents AS d_pae
		ON c.CompanyID = d_pae.CompanyID
	LEFT OUTER JOIN Master_Employees m_e
		ON d_pae.SystemID = m_e.SystemID
			AND d_pae.BpID = m_e.BpID
			AND d_pae.EmployeeID = m_e.EmployeeID
	LEFT OUTER JOIN Master_Addresses m_a
		ON m_e.SystemID = m_a.SystemID
			AND m_e.BpID = m_a.BpID
			AND m_e.AddressID = m_a.AddressID
WHERE (d_pae.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pae.PresenceDay IS NULL)
	AND @CompressType = 3
GROUP BY
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	d_pae.PresenceDay,
	(CASE WHEN @NameIsVisible = 1 THEN d_pae.EmployeeID ELSE '' END),
	(CASE WHEN @NameIsVisible = 1 THEN m_a.FirstName ELSE '' END),
	(CASE WHEN @NameIsVisible = 1 THEN m_a.LastName ELSE '' END),
	d_pae.AccessAt,
	d_pae.ExitAt,
	d_pae.AccessAreaID,
	d_pae.TimeSlotID,
	c.TreeLevel,
	c.IndentLevel,
	d_pae.AccessTimeManual,
	d_pae.ExitTimeManual
ORDER BY TreeLevel, CompressLevel
