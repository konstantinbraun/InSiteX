CREATE PROCEDURE [dbo].[GetReportMWAttestationRequestHeaders]
(
	@SystemID int,
	@BpID int,
	@MonthUntil date,
	@CompanyID int,
	@MCOnly bit = 0
)
AS

DECLARE @BpName nvarchar(50)
SELECT @BpName = NameVisible
FROM Master_BuildingProjects
WHERE SystemID = @SystemID
	AND BpID = @BpID

-- Hilfstabellen
DECLARE @SelectedCompanies table
(
	SystemID int,
	BpID int,
	BpName nvarchar(50),
	CompanyID int PRIMARY KEY,
	ParentID int,
	NameVisible nvarchar(50),
	NameAdditional nvarchar(200),
	TreeLevel nvarchar(50),
	IndentLevel int,
	AddressBlock nvarchar(500),
	MinWageAttestation bit
)
;

DECLARE @MinWageData table
(
	SystemID int,
	BpID int,
	BpName nvarchar(50),
	CompanyID int PRIMARY KEY,
	ParentID int,
	NameVisible nvarchar(50),
	NameAdditional nvarchar(200),
	TreeLevel nvarchar(50),
	IndentLevel int,
	MWAttestationMCOpen int,
	MWAttestationSCOpen int,
	MWAttestationMCFaulty int,
	MWAttestationSCFaulty int,
	MWAttestationMCWrong int,
	MWAttestationSCWrong int,
	AddressBlock nvarchar(500)
)
;

DECLARE @CRLF nvarchar(10) = CHAR(13) + CHAR(10);

-- Hauptunternehmer und alle Subunternehmer selektieren
WITH Companies AS
(
	SELECT 
		m_c.SystemID, 
		m_c.BpID, 
		@BpName AS BpName,
		m_c.CompanyID, 
		m_c.ParentID, 
		m_c.NameVisible, 
		m_c.NameAdditional, 
		CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
		1 AS IndentLevel,
		m_c.NameVisible + ' ' + 
		@CRLF +
		(CASE WHEN m_c.NameAdditional IS NULL OR m_c.NameAdditional = '' THEN '' ELSE m_c.NameAdditional + ' ' + @CRLF END) +
		(CASE WHEN m_cc.Salutation IS NULL OR m_cc.Salutation = '' THEN '' ELSE m_cc.Salutation + ' ' END) +
		(CASE WHEN m_cc.Salutation IS NULL OR m_cc.FirstName = '' THEN '' ELSE m_cc.FirstName + ' ' END) +
		(CASE WHEN m_cc.Salutation IS NULL OR m_cc.LastName = '' THEN '' ELSE m_cc.LastName + ' ' + @CRLF END) +
		(CASE WHEN s_a.Address1 IS NULL OR s_a.Address1 = '' THEN '' ELSE s_a.Address1 + ' ' + @CRLF END) +
		(CASE WHEN s_a.Zip IS NULL OR s_a.Zip = '' THEN '' ELSE s_a.Zip + ' ' END) +
		(CASE WHEN s_a.City IS NULL OR s_a.City = '' THEN '' ELSE s_a.City + ' ' + @CRLF END) AS AddressBlock,
		m_c.MinWageAttestation
	FROM Master_Companies m_c
		INNER JOIN System_Companies s_c
			ON m_c.SystemID = s_c.SystemID
				AND m_c.CompanyCentralID = s_c.CompanyID
		INNER JOIN System_Addresses s_a
			ON s_c.SystemID = s_a.SystemID
				AND s_c.AddressID = s_a.AddressID
		INNER JOIN Master_CompanyContacts m_cc
			ON m_c.SystemID = m_cc.SystemID
				AND m_c.BpID = m_cc.BpID
				AND m_c.CompanyID = m_cc.CompanyID
	WHERE m_c.SystemID = @SystemID 
		AND m_c.BpID = @BpID 
		AND m_c.CompanyID = @CompanyID 
		AND m_cc.IsMWRelevant = 1

	UNION ALL
	
	SELECT 
		m_c.SystemID, 
		m_c.BpID, 
		@BpName As BpName,
		m_c.CompanyID, 
		m_c.ParentID, 
		m_c.NameVisible, 
		m_c.NameAdditional, 
		CAST(TreeLevel + ';' + RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel,
		IndentLevel + 1 AS IndentLevel,
		m_c.NameVisible + ' ' + 
		@CRLF +
		(CASE WHEN m_c.NameAdditional IS NULL OR m_c.NameAdditional = '' THEN '' ELSE m_c.NameAdditional + ' ' + @CRLF END) +
		(CASE WHEN m_cc.Salutation IS NULL OR m_cc.Salutation = '' THEN '' ELSE m_cc.Salutation + ' ' END) +
		(CASE WHEN m_cc.Salutation IS NULL OR m_cc.FirstName = '' THEN '' ELSE m_cc.FirstName + ' ' END) +
		(CASE WHEN m_cc.Salutation IS NULL OR m_cc.LastName = '' THEN '' ELSE m_cc.LastName + ' ' + @CRLF END) +
		(CASE WHEN s_a.Address1 IS NULL OR s_a.Address1 = '' THEN '' ELSE s_a.Address1 + ' ' + @CRLF END) +
		(CASE WHEN s_a.Zip IS NULL OR s_a.Zip = '' THEN '' ELSE s_a.Zip + ' ' END) +
		(CASE WHEN s_a.City IS NULL OR s_a.City = '' THEN '' ELSE s_a.City + ' ' + @CRLF END) AS AddressBlock,
		m_c.MinWageAttestation
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON Companies.SystemID = m_c.SystemID
				AND Companies.BpID = m_c.BpID
				AND Companies.CompanyID = m_c.ParentID
		INNER JOIN System_Companies s_c
			ON m_c.SystemID = s_c.SystemID
				AND m_c.CompanyCentralID = s_c.CompanyID
		INNER JOIN System_Addresses s_a
			ON s_c.SystemID = s_a.SystemID
				AND s_c.AddressID = s_a.AddressID
		INNER JOIN Master_CompanyContacts m_cc
			ON m_c.SystemID = m_cc.SystemID
				AND m_c.BpID = m_cc.BpID
				AND m_c.CompanyID = m_cc.CompanyID
		WHERE m_cc.IsMWRelevant = 1
			AND @MCOnly = 0
)
INSERT INTO @SelectedCompanies 
(
	SystemID,
	BpID,
	BpName,
	CompanyID,
	ParentID,
	NameVisible,
	NameAdditional,
	TreeLevel,
	IndentLevel,
	AddressBlock,
	MinWageAttestation
)
SELECT DISTINCT
	SystemID,
	BpID,
	BpName,
	CompanyID,
	ParentID,
	NameVisible,
	NameAdditional,
	TreeLevel,
	IndentLevel,
	AddressBlock ,
	MinWageAttestation
FROM Companies
ORDER BY TreeLevel
;

INSERT INTO @MinWageData
(	
	SystemID,
	BpID,
	BpName,
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID,
	TreeLevel,
	IndentLevel,
	MWAttestationMCOpen,
	MWAttestationSCOpen,
	MWAttestationMCFaulty,
	MWAttestationSCFaulty,
	MWAttestationMCWrong,
	MWAttestationSCWrong,
	AddressBlock
)
SELECT         
	sc.SystemID, 
	sc.BpID, 
	sc.BpName,
	sc.CompanyID,
	sc.NameVisible,
	sc.NameAdditional,
	sc.ParentID,
	sc.TreeLevel,
	sc.IndentLevel,
	SUM(CASE WHEN d_emw.StatusCode = 1 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCOpen,
	SUM(CASE WHEN d_emw.StatusCode = 1 THEN 1 ELSE 0 END) AS MWAttestationSCOpen,
	SUM(CASE WHEN d_emw.StatusCode = 3 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCFaulty,
	SUM(CASE WHEN d_emw.StatusCode = 3 THEN 1 ELSE 0 END) AS MWAttestationSCFaulty,
	SUM(CASE WHEN d_emw.StatusCode = 5 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCWrong,
	SUM(CASE WHEN d_emw.StatusCode = 5 THEN 1 ELSE 0 END) AS MWAttestationSCWrong,
	sc.AddressBlock
FROM @SelectedCompanies AS sc
	INNER JOIN Master_Employees AS m_e
		ON sc.SystemID = m_e.SystemID
			AND sc.BpID = m_e.BpID
			AND sc.CompanyID = m_e.CompanyID 
	INNER JOIN Data_EmployeeMinWage AS d_emw 
		ON m_e.SystemID = d_emw.SystemID 
			AND m_e.BpID = d_emw.BpID 
			AND m_e.EmployeeID = d_emw.EmployeeID
WHERE d_emw.MWMonth <= @MonthUntil
	AND d_emw.StatusCode IN (1, 3, 5)
GROUP BY
	sc.SystemID, 
	sc.BpID, 
	sc.BpName,
	sc.CompanyID,
	sc.NameVisible,
	sc.NameAdditional,
	sc.ParentID,
	sc.TreeLevel,
	sc.IndentLevel,
	sc.AddressBlock
;

WITH MinWageSums
AS
(
	SELECT
		SystemID,
		BpID,
		BpName,
		CompanyID,
		CompanyID AS CompanyIDOrg,
		NameVisible,
		NameAdditional,
		ParentID,
		TreeLevel,
		IndentLevel,
		MWAttestationMCOpen,
		MWAttestationSCOpen,
		MWAttestationMCFaulty,
		MWAttestationSCFaulty,
		MWAttestationMCWrong,
		MWAttestationSCWrong,
		AddressBlock
	FROM @MinWageData

	UNION ALL

	SELECT
		mws.SystemID,
		mws.BpID,
		mws.BpName,
		mws.CompanyID,
		mwd.CompanyID AS CompanyIDOrg,
		mws.NameVisible,
		mws.NameAdditional,
		mws.ParentID,
		mws.TreeLevel,
		mws.IndentLevel,
		0 AS MWAttestationMCOpen,
		mwd.MWAttestationSCOpen,
		0 AS MWAttestationMCFaulty,
		mwd.MWAttestationSCFaulty,
		0 AS MWAttestationMCWrong,
		mwd.MWAttestationSCWrong,
		mws.AddressBlock
	FROM @MinWageData AS mwd
		INNER JOIN MinWageSums AS mws
			ON mwd.SystemID = mws.SystemID
				AND mwd.BpID = mws.BpID
				AND mwd.ParentID = mws.CompanyIDOrg
)
SELECT
	SystemID,
	BpID,
	BpName,
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID,
	TreeLevel,
	IndentLevel,
	SUM(MWAttestationMCOpen) AS MWAttestationMCOpen,
	SUM(MWAttestationSCOpen) AS MWAttestationSCOpen,
	SUM(MWAttestationMCFaulty) AS MWAttestationMCFaulty,
	SUM(MWAttestationSCFaulty) AS MWAttestationSCFaulty,
	SUM(MWAttestationMCWrong) AS MWAttestationMCWrong,
	SUM(MWAttestationSCWrong) AS MWAttestationSCWrong,
	AddressBlock
FROM MinWageSums
GROUP BY
	SystemID,
	BpID,
	BpName,
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID,
	TreeLevel,
	IndentLevel,
	AddressBlock
