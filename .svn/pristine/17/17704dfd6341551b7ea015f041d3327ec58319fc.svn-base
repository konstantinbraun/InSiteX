CREATE PROCEDURE [dbo].[GetParentContractors]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@Level int = 1
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
	IndentLevel int
)
;

WITH Companies (SystemID, BpID, CompanyID, ParentID, NameVisible, IndentLevel) AS
(
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID, m_c.NameVisible, 1 AS IndentLevel
	FROM Master_Companies m_c
		WHERE m_c.SystemID = @SystemID 
			AND m_c.BpID = @BpID 
			AND m_c.CompanyID = @CompanyID 

	UNION ALL
	
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID, m_c.NameVisible, IndentLevel + 1 AS IndentLevel
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON Companies.SystemID = m_c.SystemID
				AND Companies.BpID = m_c.BpID
				AND Companies.ParentID = m_c.CompanyID
)
INSERT INTO @SelectedCompanies 
(
	SystemID,
	BpID,
	CompanyID,
	ParentID,
	NameVisible,
	IndentLevel
)
SELECT DISTINCT 
	SystemID, 
	BpID, 
	CompanyID, 
	ParentID, 
	NameVisible, 
	IndentLevel 
FROM Companies
WHERE CompanyID != @CompanyID
ORDER BY IndentLevel DESC
;

DECLARE @MaxLevel int
;

SELECT @MaxLevel = MAX(IndentLevel)
FROM @SelectedCompanies

SELECT * FROM @SelectedCompanies
WHERE IndentLevel = (@MaxLevel + 1 - @Level)
