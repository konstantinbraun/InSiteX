CREATE PROCEDURE [dbo].[GetTradeReportData]
(
	@SystemID int,
	@BpID int,
	@DateFrom date,
	@DateUntil date
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
;

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
			AND ParentID = 0

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
ORDER BY TreeLevel
;

SELECT 
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	m_t.TradeGroupID,
	m_tg.NameVisible AS TradeGroupName,
	d_pe.TradeID,
	m_t.TradeNumber,
	m_t.NameVisible AS TradeName,
	d_pe.PresenceDay,
	SUM(ISNULL(d_pe.PresenceSeconds, 0)) AS PresenceSeconds,
	SUM(ISNULL(d_pe.CountAs, 0)) AS CountAs,
	c.TreeLevel,
	c.IndentLevel
FROM @SelectedCompanies AS c
	INNER JOIN Data_PresenceEmployee AS d_pe
		ON c.CompanyID = d_pe.CompanyID
	INNER JOIN Master_Trades AS m_t
		ON d_pe.SystemID = m_t.SystemID
			AND d_pe.BpID = m_t.BpID
			AND d_pe.TradeID = m_t.TradeID
	INNER JOIN Master_TradeGroups AS m_tg
		ON m_t.SystemID = m_tg.SystemID
			AND m_t.BpID = m_tg.BpID
			AND m_t.TradeGroupID = m_tg.TradeGroupID
WHERE d_pe.PresenceDay BETWEEN @DateFrom AND @DateUntil
GROUP BY
	c.SystemID,
	c.BpID, 
	c.CompanyID,
	c.NameVisible,
	c.NameAdditional,
	c.ParentID,
	m_t.TradeGroupID,
	m_tg.NameVisible,
	d_pe.TradeID,
	m_t.TradeNumber,
	m_t.NameVisible,
	d_pe.PresenceDay,
	c.TreeLevel,
	c.IndentLevel
;
