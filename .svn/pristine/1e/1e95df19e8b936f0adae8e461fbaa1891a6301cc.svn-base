CREATE PROCEDURE [dbo].[GetPresentEmployeesCustoms]
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
		@PresenceDay AS PresenceDay,
		d_ae.OwnerID AS EmployeeID,
		m_a.FirstName,
		m_a.LastName,
		d_ae.AccessAt,
		(CASE WHEN d_ae.AccessAt > d_ae.ExitAt THEN NULL ELSE d_ae.ExitAt END) AS ExitAt,
		SUM(ISNULL(DATEDIFF(s, d_ae.AccessAt, (CASE WHEN DATEDIFF(s, CAST(d_ae.ExitAt AS datetime), CAST(@PresenceDay AS datetime)) = 0 THEN @EndOfDay ELSE d_ae.ExitAt END)), 0)) AS PresenceSeconds,
		d_ae.AccessAreaID,
		m_aa.NameVisible AS AccessAreaName,
		c.TreeLevel,
		c.IndentLevel,
		dbo.EmployeePresentState(d_ae.SystemID, d_ae.BpID, d_ae.OwnerID) AS IsPresent,
		1 AS PassType,
		m_e.ExternalPassID,
		m_a.NationalityID,
		v_c.CountryName AS NationalityName,
		ISNULL(m_a.Address1, '') AS Address1,
		ISNULL(m_a.Address2, '') AS Address2,
		ISNULL(m_a.CountryID, '') AS CountryID,
		ISNULL(m_a.Zip, '') AS Zip,
		ISNULL(m_a.City, '') AS City,
		s_rf.DescriptionShort AS RelevantFor,
		m_rd.NameVisible AS DocumentName,
		m_rd.DescriptionShort AS DocumentDescription,
		m_erd.IDNumber AS DocumentID,
		m_erd.ExpirationDate
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
		INNER JOIN Master_Addresses AS m_a
			ON m_e.SystemID = m_a.SystemID
				AND m_e.BpID = m_a.BpID
				AND m_e.AddressID = m_a.AddressID
		INNER JOIN View_Countries AS v_c
			ON m_a.NationalityID = v_c.CountryID
		INNER JOIN Master_AccessAreas AS m_aa
			ON d_ae.SystemID = m_aa.SystemID
				AND d_ae.BpID = m_aa.BpID 
				AND d_ae.AccessAreaID = m_aa.AccessAreaID
		INNER JOIN Master_EmployeeRelevantDocuments AS m_erd
			ON m_e.SystemID = m_erd.SystemID
				AND m_e.BpID = m_erd.BpID
				AND m_e.EmployeeID = m_erd.EmployeeID
		INNER JOIN Master_RelevantDocuments AS m_rd
			ON m_erd.SystemID = m_rd.SystemID
				AND m_erd.BpID = m_rd.BpID
				AND m_erd.RelevantDocumentID = m_rd.RelevantDocumentID
		INNER JOIN System_RelevantFor AS s_rf
			ON m_rd.SystemID = s_rf.SystemID
				AND m_rd.RelevantFor = s_rf.RelevantFor
	GROUP BY
		d_ae.SystemID, 
		d_ae.BpID, 
		m_e.CompanyID, 
		c.NameVisible,
		d_ae.OwnerID,
		m_a.FirstName,
		m_a.LastName,
		d_ae.AccessAt,
		(CASE WHEN d_ae.AccessAt > d_ae.ExitAt THEN NULL ELSE d_ae.ExitAt END),
		d_ae.AccessAreaID,
		m_aa.NameVisible,
		c.TreeLevel,
		c.IndentLevel,
		dbo.EmployeePresentState(d_ae.SystemID, d_ae.BpID, d_ae.OwnerID),
		m_e.ExternalPassID,
		m_a.NationalityID,
		v_c.CountryName,
		m_a.Address1,
		m_a.Address2,
		m_a.CountryID,
		m_a.Zip,
		m_a.City,
		s_rf.DescriptionShort,
		m_rd.NameVisible,
		m_rd.DescriptionShort,
		m_erd.IDNumber,
		m_erd.ExpirationDate
) AS p
WHERE p.IsPresent = (CASE WHEN @PresentOnly = 1 THEN 1 ELSE p.IsPresent END)
;	