CREATE PROCEDURE [dbo].[GetPresenceDataNow]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@CompanyLevel int,
	@AccessAreaID int,
	@PresenceDay date,
	@PresentOnly bit = 1
)
AS

SET @PresenceDay = CAST(SYSDATETIME() AS date)

DECLARE @EndOfDay datetime = DATEADD(d, 1, @PresenceDay);
SET @EndOfDay = DATEADD(s, -1, @EndOfDay);

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
		CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY ParentID ORDER BY NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
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
		NameVisible,
		NameAdditional,
		TreeLevel,
		IndentLevel 
	FROM Companies
	ORDER BY TreeLevel;

-- Zutrittsdaten Mitarbeiter selektieren
SELECT *
FROM
(
	SELECT        
		d_ae.SystemID, 
		d_ae.BpID, 
		m_e.CompanyID, 
		c.NameVisible AS CompanyName,
		m_e.TradeID,
		m_t.TradeNumber,
		m_t.NameVisible AS TradeName,
		@PresenceDay AS PresenceDay,
		d_ae.OwnerID AS EmployeeID,
		m_a.FirstName,
		m_a.LastName,
		d_ae.AccessAt,
		(CASE WHEN d_ae.AccessAt > d_ae.ExitAt THEN NULL ELSE d_ae.ExitAt END) AS ExitAt,
		ISNULL(SUM(DATEDIFF(s, d_ae.AccessAt, (CASE WHEN DATEDIFF(s, CAST(d_ae.ExitAt AS datetime), CAST(@PresenceDay AS datetime)) = 0 THEN @EndOfDay ELSE d_ae.ExitAt END))), 0) AS PresenceSeconds,
		d_ae.AccessAreaID,
		m_aa.NameVisible AS AccessAreaName,
		m_e.EmploymentStatusID,
		m_es.NameVisible AS EmploymentStatusName,
		c.TreeLevel,
		c.IndentLevel,
		dbo.EmployeePresentState(d_ae.SystemID, d_ae.BpID, d_ae.OwnerID) AS IsPresent,
		1 AS PassType,
		dbo.IsFirstAider(m_e.SystemID, m_e.BpID, m_e.EmployeeID) AS IsFirstAider,
		dbo.GetQualification(m_e.SystemID, m_e.BpID, m_e.EmployeeID) AS Qualification,
		m_e.ExternalPassID
	FROM @SelectedCompanies AS c
		INNER JOIN
		(
			SELECT 
				SystemID, 
				BpID, 
				OwnerID, 
				AccessAreaID,
				MAX(CASE WHEN AccessType = 1 THEN AccessOn ELSE @PresenceDay END) AS AccessAt,
				MAX(CASE WHEN AccessType = 0 THEN AccessOn ELSE NULL END) AS ExitAt  
			FROM Data_AccessEvents
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay
				AND AccessAreaID = (CASE WHEN @AccessAreaID = 0 THEN AccessAreaID ELSE @AccessAreaID END)
				AND AccessResult = 1
				AND PassType = 1
			GROUP BY 
				SystemID, 
				BpID, 
				OwnerID, 
				AccessAreaID 
		) AS d_ae 
			ON c.SystemID = d_ae.SystemID
				AND c.BpID = d_ae.BpID
		INNER JOIN Master_Employees AS m_e 
			ON d_ae.SystemID = m_e.SystemID 
				AND d_ae.BpID = m_e.BpID 
				AND d_ae.OwnerID = m_e.EmployeeID
				AND c.CompanyID = m_e.CompanyID
		INNER JOIN Master_Addresses m_a
			ON m_e.SystemID = m_a.SystemID
				AND m_e.BpID = m_a.BpID
				AND m_e.AddressID = m_a.AddressID
		INNER JOIN Master_AccessAreas AS m_aa
			ON d_ae.SystemID = m_aa.SystemID
				AND d_ae.BpID = m_aa.BpID 
				AND d_ae.AccessAreaID = m_aa.AccessAreaID
		LEFT OUTER JOIN Master_Trades AS m_t
			ON m_e.SystemID = m_t.SystemID
				AND m_e.BpID = m_t.BpID
				AND m_e.TradeID = m_t.TradeID
		LEFT OUTER JOIN Master_EmploymentStatus AS m_es
			ON m_e.SystemID = m_es.SystemID
				AND m_e.BpID = m_es.BpID
				AND m_e.EmploymentStatusID = m_es.EmploymentStatusID
	GROUP BY
		d_ae.SystemID, 
		d_ae.BpID, 
		m_e.CompanyID, 
		c.NameVisible,
		m_e.TradeID,
		m_t.TradeNumber,
		m_t.NameVisible,
		d_ae.OwnerID,
		m_a.FirstName,
		m_a.LastName,
		d_ae.AccessAt,
		d_ae.ExitAt,
		d_ae.AccessAreaID,
		m_aa.NameVisible,
		m_e.EmploymentStatusID,
		m_es.NameVisible,
		c.TreeLevel,
		c.IndentLevel,
		(CASE WHEN d_ae.ExitAt IS NULL THEN 1 ELSE 0 END),
		dbo.IsFirstAider(m_e.SystemID, m_e.BpID, m_e.EmployeeID),
		dbo.GetQualification(m_e.SystemID, m_e.BpID, m_e.EmployeeID),
		m_e.ExternalPassID
) AS p
WHERE p.IsPresent = (CASE WHEN @PresentOnly = 1 THEN 1 ELSE p.IsPresent END)

UNION

-- Zutrittsdaten Kurzzeitausweise selektieren
SELECT *
FROM
(
	SELECT        
		d_ae.SystemID, 
		d_ae.BpID, 
		d_stv.AssignedCompanyID AS CompanyID, 
		c.NameVisible AS CompanyName,
		0 AS TradeID,
		'' AS TradeNumber,
		'' AS TradeName,
		@PresenceDay AS PresenceDay,
		d_ae.OwnerID AS EmployeeID,
		d_stv.FirstName,
		d_stv.LastName,
		d_ae.AccessAt,
		(CASE WHEN d_ae.AccessAt > d_ae.ExitAt THEN NULL ELSE d_ae.ExitAt END) AS ExitAt,
		ISNULL(SUM(DATEDIFF(s, d_ae.AccessAt, (CASE WHEN DATEDIFF(s, CAST(d_ae.ExitAt AS datetime), CAST(@PresenceDay AS datetime)) = 0 THEN @EndOfDay ELSE d_ae.ExitAt END))), 0) AS PresenceSeconds,
		d_ae.AccessAreaID,
		m_aa.NameVisible AS AccessAreaName,
		0 AS EmploymentStatusID,
		'' AS EmploymentStatusName,
		c.TreeLevel,
		c.IndentLevel,
		dbo.ShortTermPresentState(d_ae.SystemID, d_ae.BpID, d_ae.OwnerID) AS IsPresent,
		2 AS PassType,
		CAST(0 AS bit) AS IsFirstAider,
		'' AS Qualification,
		'' AS ExternalPassID
	FROM @SelectedCompanies AS c
		INNER JOIN
		(
			SELECT 
				SystemID, 
				BpID, 
				OwnerID, 
				AccessAreaID,
				InternalID,
				MAX(CASE WHEN AccessType = 1 THEN AccessOn ELSE @PresenceDay END) AS AccessAt,
				MAX(CASE WHEN AccessType = 0 THEN AccessOn ELSE NULL END) AS ExitAt  
			FROM Data_AccessEvents
			WHERE SystemID = @SystemID
				AND BpID = @BpID
				AND AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay
				AND AccessAreaID = (CASE WHEN @AccessAreaID = 0 THEN AccessAreaID ELSE @AccessAreaID END)
				AND AccessResult = 1
				AND PassType = 2
			GROUP BY 
				SystemID, 
				BpID, 
				OwnerID, 
				AccessAreaID,
				InternalID 
		) AS d_ae 
			ON c.SystemID = d_ae.SystemID
				AND c.BpID = d_ae.BpID
		INNER JOIN Data_ShortTermVisitors AS d_stv 
			ON d_ae.SystemID = d_stv.SystemID 
				AND d_ae.BpID = d_stv.BpID 
				AND d_ae.OwnerID = d_stv.ShortTermVisitorID
				AND d_ae.InternalID = d_stv.PassInternalID
				AND c.CompanyID = d_stv.AssignedCompanyID
		INNER JOIN Master_AccessAreas AS m_aa
			ON d_ae.SystemID = m_aa.SystemID
				AND d_ae.BpID = m_aa.BpID 
				AND d_ae.AccessAreaID = m_aa.AccessAreaID
	GROUP BY
		d_ae.SystemID, 
		d_ae.BpID, 
		d_stv.AssignedCompanyID, 
		c.NameVisible,
		d_ae.OwnerID,
		d_stv.FirstName,
		d_stv.LastName,
		d_ae.AccessAt,
		d_ae.ExitAt,
		d_ae.AccessAreaID,
		m_aa.NameVisible,
		c.TreeLevel,
		c.IndentLevel,
		(CASE WHEN d_ae.ExitAt IS NULL THEN 1 ELSE 0 END)
) AS p1
WHERE p1.IsPresent = (CASE WHEN @PresentOnly = 1 THEN 1 ELSE p1.IsPresent END)
	