CREATE FUNCTION [dbo].[GetCountWithSubcontractorsCL]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@CompanyLevel int,
	@PrimarySelection SelectedCompanies READONLY,
	@DateFrom datetime,
	@DateUntil datetime 
)
RETURNS INT
AS
BEGIN
	DECLARE @CountAs int = 0;

	DECLARE @SelectedCompanies SelectedCompanies;

	DECLARE @CompaniesPresenceData table
	(
		SystemID int,
		BpID int,
		CompanyID int,
		ParentID int,
		CountAs int,
		PresenceSeconds bigint
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
		AND CompanyID = @CompanyID
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
			TreeLevel, 
			IndentLevel
		FROM @PrimarySelection
			WHERE SystemID = @SystemID 
				AND BpID = @BpID 
				AND CompanyID = @CompanyID 

		UNION ALL
	
		SELECT 
			m_c.SystemID, 
			m_c.BpID, 
			m_c.CompanyID, 
			m_c.ParentID, 
			m_c.NameVisible, 
			m_c.NameAdditional, 
			m_c.TreeLevel,
			m_c.IndentLevel
		FROM @PrimarySelection m_c
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
			TreeLevel, 
			IndentLevel
		FROM @PrimarySelection
			WHERE SystemID = @SystemID 
				AND BpID = @BpID 
				AND CompanyID = @CompanyID 

		UNION ALL
	
		SELECT 
			m_c.SystemID, 
			m_c.BpID, 
			m_c.CompanyID, 
			m_c.ParentID, 
			m_c.NameVisible, 
			m_c.NameAdditional, 
			m_c.TreeLevel,
			m_c.IndentLevel
		FROM @PrimarySelection m_c
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

	INSERT INTO @CompaniesPresenceData
	(
		SystemID,
		BpID,
		CompanyID,
		ParentID,
		CountAs,
		PresenceSeconds
	)
	SELECT        
		m_c.SystemID, 
		m_c.BpID, 
		m_c.CompanyID, 
		m_c.ParentID, 
		SUM(ISNULL(d_pc.CountAs, 0)) AS CountAs, 
		SUM(ISNULL(d_pc.PresenceSeconds, 0)) AS PresenceSeconds
	FROM @SelectedCompanies AS m_c 
		LEFT OUTER JOIN Data_PresenceCompany AS d_pc 
			ON m_c.SystemID = d_pc.SystemID 
				AND m_c.BpID = d_pc.BpID 
				AND m_c.CompanyID = d_pc.CompanyID
		WHERE m_c.SystemID = @SystemID
			AND m_c.BpID = @BpID
			AND (d_pc.PresenceDay BETWEEN @DateFrom AND @DateUntil OR d_pc.PresenceDay IS NULL)
	GROUP BY 
		m_c.SystemID, 
		m_c.BpID, 
		m_c.CompanyID, 
		m_c.ParentID
	;

	SELECT 
		@CountAs = SUM(CountAs)
	FROM @CompaniesPresenceData
	;

	RETURN @CountAs;
END
