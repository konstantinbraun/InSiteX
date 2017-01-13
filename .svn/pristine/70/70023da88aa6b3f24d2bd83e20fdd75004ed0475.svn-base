CREATE PROCEDURE [dbo].[GetBpCompaniesWithLevel]
(
	@SystemID int,
	@BpID int,
	@Level int = 0,
	@CompanyID int = 0
)
AS

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
ORDER BY TreeLevel
;

SELECT        
	m_c.SystemID, 
	m_c.BpID, 
	m_c.CompanyID, 
	(CASE WHEN @CompanyID > 0 THEN NULL ELSE (CASE WHEN m_c.ParentID = 0 THEN NULL ELSE m_c.ParentID END) END) AS ParentID, 
	m_c.NameVisible, 
	m_c.NameAdditional, 
	m_c.[Description], 
	m_c.AddressID, 
	m_c.IsVisible, 
	m_c.IsValid, 
	m_c.TradeAssociation, 
	m_c.BlnSOKA, 
	m_c.CreatedFrom, 
	m_c.CreatedOn, 
	m_c.EditFrom, 
	m_c.EditOn, 
	s_a.Address1, 
	s_a.Address2, 
	s_a.Zip, 
	s_a.City, 
	s_a.[State], 
	s_a.CountryID, 
	s_a.Phone, 
	s_a.Email, 
	s_a.WWW, 
	m_c.NameVisible 
		+ (CASE WHEN m_c.NameAdditional IS NULL THEN '' ELSE ', ' + m_c.NameAdditional END) 
		+ (CASE WHEN s_a.City IS NULL THEN '' ELSE ', ' + s_a.City END) AS CompanyName,
	m_c.CompanyCentralID
FROM Master_Companies AS m_c 
	LEFT OUTER JOIN System_Addresses AS s_a 
		ON m_c.SystemID = s_a.SystemID 
			AND m_c.AddressID = s_a.AddressID 
	INNER JOIN @SelectedCompanies as c 
		ON m_c.SystemID = c.SystemID
			AND m_c.BpID = c.BpID
			AND m_c.CompanyID = c.CompanyID
WHERE m_c.SystemID = @SystemID 
	AND m_c.BpID = @BpID 
	AND m_c.ReleaseOn IS NOT NULL 
	AND m_c.LockedOn IS NULL 
	AND c.IndentLevel = (CASE WHEN @Level = 0 THEN c.IndentLevel ELSE @Level END)
ORDER BY c.TreeLevel
;