CREATE PROCEDURE [dbo].[GetCompaniesSubcontractors]
(
	@SystemID int,
	@BpID int,
	@CompanyCentralID int
)
AS
WITH Companies AS
(
	SELECT 
		m_c.SystemID, 
		m_c.BpID, 
		m_c.CompanyID, 
		m_c.ParentID,
		m_c.CompanyCentralID,
		m_c.NameVisible,
		m_c.NameAdditional
	FROM Master_Companies m_c
		WHERE m_c.SystemID = @SystemID 
			AND m_c.BpID = @BpID 
			AND m_c.CompanyCentralID = @CompanyCentralID 

	UNION ALL
	
	SELECT 
		m_c.SystemID, 
		m_c.BpID, 
		m_c.CompanyID, 
		m_c.ParentID,
		m_c.CompanyCentralID,
		m_c.NameVisible,
		m_c.NameAdditional
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON Companies.SystemID = m_c.SystemID
				AND Companies.BpID = m_c.BpID
				AND Companies.CompanyID = m_c.ParentID
)
SELECT 
	SystemID, 
	BpID, 
	CompanyID, 
	ParentID, 
	CompanyCentralID, 
	NameVisible, 
	NameAdditional
FROM Companies
ORDER BY 
	NameVisible, 
	NameAdditional
;
