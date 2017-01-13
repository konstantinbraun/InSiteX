CREATE PROCEDURE [dbo].[GetSubContractors]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
AS

WITH Companies (SystemID, BpID, CompanyID, ParentID, NameVisible) AS
(
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID, m_c.NameVisible
	FROM Master_Companies m_c
		WHERE m_c.SystemID = @SystemID 
			AND m_c.BpID = @BpID 
			AND m_c.CompanyID = @CompanyID 

	UNION ALL
	
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID, m_c.NameVisible
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON Companies.SystemID = m_c.SystemID
				AND Companies.BpID = m_c.BpID
				AND Companies.CompanyID = m_c.ParentID
)
SELECT SystemID, BpID, CompanyID, ParentID, NameVisible 
FROM Companies
WHERE CompanyID != @CompanyID
;