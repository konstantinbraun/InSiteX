CREATE PROCEDURE [dbo].[GetReportMinWageData]
(
	@SystemID int,
	@BpID int,
	@MonthFrom date,
	@MonthUntil date,
	@CompanyID int = 0
)
AS

-- Hilfstabellen
DECLARE @SelectedCompanies table
(
	SystemID int,
	BpID int,
	CompanyID int PRIMARY KEY,
	ParentID int,
	NameVisible nvarchar(50),
	NameAdditional nvarchar(200),
	TreeLevel nvarchar(50),
	IndentLevel int,
	MinWageAttestation bit
)
;

DECLARE @MinWageData table
(
	SystemID int,
	BpID int,
	CompanyID int PRIMARY KEY,
	ParentID int,
	NameVisible nvarchar(50),
	NameAdditional nvarchar(200),
	TreeLevel nvarchar(50),
	IndentLevel int,
	MWAttestationMCRequired int,
	MWAttestationSCRequired int,
	MWAttestationMCOpen int,
	MWAttestationSCOpen int,
	MWAttestationMCExisting int,
	MWAttestationSCExisting int,
	MWAttestationMCFaulty int,
	MWAttestationSCFaulty int,
	MWAttestationMCToLow int,
	MWAttestationSCToLow int,
	MWAttestationMCWrong int,
	MWAttestationSCWrong int
)
;

-- Hauptunternehmer und alle Subunternehmer selektieren
WITH Companies AS
(
	SELECT 
		m_c.SystemID, 
		m_c.BpID, 
		m_c.CompanyID, 
		NULL AS ParentID, 
		s_c.NameVisible, 
		s_c.NameAdditional, 
		CAST(RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY s_c.NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel, 
		1 AS IndentLevel,
		m_c.MinWageAttestation
	FROM Master_Companies AS m_c
		INNER JOIN System_Companies AS s_c
			ON m_c.SystemID = s_c.SystemID 
				AND m_c.CompanyCentralID = s_c.CompanyID
		WHERE m_c.SystemID = @SystemID 
			AND m_c.BpID = @BpID 
			AND m_c.CompanyID = (CASE WHEN @CompanyID = 0 THEN m_c.CompanyID ELSE @CompanyID END) 
			AND m_c.ParentID = (CASE WHEN @CompanyID = 0 THEN 0 ELSE m_c.ParentID END)

	UNION ALL
	
	SELECT 
		m_c.SystemID, 
		m_c.BpID, 
		m_c.CompanyID, 
		m_c.ParentID, 
		s_c.NameVisible, 
		s_c.NameAdditional, 
		CAST(TreeLevel + ';' + RIGHT(CONCAT('000', CAST(ROW_NUMBER() OVER(PARTITION BY m_c.ParentID ORDER BY m_c.NameVisible) AS nvarchar(50))), 3) AS nvarchar(50)) AS TreeLevel,
		IndentLevel + 1 AS IndentLevel,
		m_c.MinWageAttestation
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON m_c.SystemID = Companies.SystemID
				AND m_c.BpID = Companies.BpID
				AND m_c.ParentID = Companies.CompanyID
		INNER JOIN System_Companies AS s_c
			ON m_c.SystemID = s_c.SystemID 
				AND m_c.CompanyCentralID = s_c.CompanyID
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
	IndentLevel,
	MinWageAttestation
)
SELECT DISTINCT
	SystemID,
	BpID,
	CompanyID,
	ParentID,
	NameVisible,
	NameAdditional,
	TreeLevel,
	IndentLevel,
	MinWageAttestation 
FROM Companies
ORDER BY TreeLevel
;

INSERT INTO @MinWageData
(	
	SystemID,
	BpID,
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID,
	TreeLevel,
	IndentLevel,
	MWAttestationMCRequired,
	MWAttestationSCRequired,
	MWAttestationMCOpen,
	MWAttestationSCOpen,
	MWAttestationMCExisting,
	MWAttestationSCExisting,
	MWAttestationMCFaulty,
	MWAttestationSCFaulty,
	MWAttestationMCToLow,
	MWAttestationSCToLow,
	MWAttestationMCWrong,
	MWAttestationSCWrong
)
SELECT         
	sc.SystemID, 
	sc.BpID, 
	sc.CompanyID,
	sc.NameVisible,
	sc.NameAdditional,
	sc.ParentID,
	sc.TreeLevel,
	sc.IndentLevel,
	SUM(CASE WHEN d_emw.StatusCode > 0 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCRequired,
	SUM(CASE WHEN d_emw.StatusCode > 0 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationSCRequired,
	SUM(CASE WHEN d_emw.StatusCode = 1 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCOpen,
	SUM(CASE WHEN d_emw.StatusCode = 1 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationSCOpen,
	SUM(CASE WHEN d_emw.StatusCode = 2 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCExisting,
	SUM(CASE WHEN d_emw.StatusCode = 2 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationSCExisting,
	SUM(CASE WHEN d_emw.StatusCode = 3 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCFaulty,
	SUM(CASE WHEN d_emw.StatusCode = 3 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationSCFaulty,
	SUM(CASE WHEN d_emw.StatusCode = 4 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCToLow,
	SUM(CASE WHEN d_emw.StatusCode = 4 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationSCToLow,
	SUM(CASE WHEN d_emw.StatusCode = 5 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationMCWrong,
	SUM(CASE WHEN d_emw.StatusCode = 5 AND sc.MinWageAttestation = 1 THEN 1 ELSE 0 END) AS MWAttestationSCWrong
FROM @SelectedCompanies AS sc
	INNER JOIN Master_Employees AS m_e
		ON sc.SystemID = m_e.SystemID
			AND sc.BpID = m_e.BpID
			AND sc.CompanyID = m_e.CompanyID 
	INNER JOIN Data_EmployeeMinWage AS d_emw 
		ON m_e.SystemID = d_emw.SystemID 
			AND m_e.BpID = d_emw.BpID 
			AND m_e.EmployeeID = d_emw.EmployeeID
WHERE d_emw.MWMonth BETWEEN @MonthFrom AND @MonthUntil
	AND d_emw.StatusCode > 0
GROUP BY
	sc.SystemID, 
	sc.BpID, 
	sc.CompanyID,
	sc.NameVisible,
	sc.NameAdditional,
	sc.ParentID,
	sc.TreeLevel,
	sc.IndentLevel
;

INSERT INTO @MinWageData
(	
	SystemID,
	BpID,
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID,
	TreeLevel,
	IndentLevel,
	MWAttestationMCRequired,
	MWAttestationSCRequired,
	MWAttestationMCOpen,
	MWAttestationSCOpen,
	MWAttestationMCExisting,
	MWAttestationSCExisting,
	MWAttestationMCFaulty,
	MWAttestationSCFaulty,
	MWAttestationMCToLow,
	MWAttestationSCToLow,
	MWAttestationMCWrong,
	MWAttestationSCWrong
)
SELECT DISTINCT        
	sc.SystemID, 
	sc.BpID, 
	sc.CompanyID,
	sc.NameVisible,
	sc.NameAdditional,
	sc.ParentID,
	sc.TreeLevel,
	sc.IndentLevel,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0
FROM @SelectedCompanies AS sc
	INNER JOIN @MinWageData AS mw
		ON sc.SystemID = mw.SystemID
			AND sc.BpID = mw.BpID
			AND sc.CompanyID = mw.ParentID
WHERE NOT EXISTS
	(
		SELECT * 
		FROM @MinWageData mw2
		WHERE mw2.SystemID = mw.SystemID
			AND mw2.BpID = mw.BpID
			AND mw2.CompanyID = mw.ParentID
	)
;

WITH MinWageSums
AS
(
	SELECT
		SystemID,
		BpID,
		CompanyID,
		CompanyID AS CompanyIDOrg,
		NameVisible,
		NameAdditional,
		ParentID,
		TreeLevel,
		IndentLevel,
		MWAttestationMCRequired,
		MWAttestationSCRequired,
		MWAttestationMCOpen,
		MWAttestationSCOpen,
		MWAttestationMCExisting,
		MWAttestationSCExisting,
		MWAttestationMCFaulty,
		MWAttestationSCFaulty,
		MWAttestationMCToLow,
		MWAttestationSCToLow,
		MWAttestationMCWrong,
		MWAttestationSCWrong
	FROM @MinWageData

	UNION ALL

	SELECT
		mws.SystemID,
		mws.BpID,
		mws.CompanyID,
		mwd.CompanyID AS CompanyIDOrg,
		mws.NameVisible,
		mws.NameAdditional,
		mws.ParentID,
		mws.TreeLevel,
		mws.IndentLevel,
		0 AS MWAttestationMCRequired,
		mwd.MWAttestationSCRequired,
		0 AS MWAttestationMCOpen,
		mwd.MWAttestationSCOpen,
		0 AS MWAttestationMCExisting,
		mwd.MWAttestationSCExisting,
		0 AS MWAttestationMCFaulty,
		mwd.MWAttestationSCFaulty,
		0 AS MWAttestationMCToLow,
		mwd.MWAttestationSCToLow,
		0 AS MWAttestationMCWrong,
		mwd.MWAttestationSCWrong
	FROM @MinWageData AS mwd
		INNER JOIN MinWageSums AS mws
			ON mwd.SystemID = mws.SystemID
				AND mwd.BpID = mws.BpID
				AND mwd.ParentID = mws.CompanyIDOrg
)
SELECT
	SystemID,
	BpID,
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID,
	TreeLevel,
	IndentLevel,
	SUM(MWAttestationMCRequired) AS MWAttestationMCRequired,
	SUM(MWAttestationSCRequired) AS MWAttestationSCRequired,
	SUM(MWAttestationMCOpen) AS MWAttestationMCOpen,
	SUM(MWAttestationSCOpen) AS MWAttestationSCOpen,
	SUM(MWAttestationMCExisting) AS MWAttestationMCExisting,
	SUM(MWAttestationSCExisting) AS MWAttestationSCExisting,
	SUM(MWAttestationMCFaulty) AS MWAttestationMCFaulty,
	SUM(MWAttestationSCFaulty) AS MWAttestationSCFaulty,
	SUM(MWAttestationMCToLow) AS MWAttestationMCToLow,
	SUM(MWAttestationSCToLow) AS MWAttestationSCToLow,
	SUM(MWAttestationMCWrong) AS MWAttestationMCWrong,
	SUM(MWAttestationSCWrong) AS MWAttestationSCWrong
FROM MinWageSums
GROUP BY
	SystemID,
	BpID,
	CompanyID,
	NameVisible,
	NameAdditional,
	ParentID,
	TreeLevel,
	IndentLevel
ORDER BY TreeLevel
;
