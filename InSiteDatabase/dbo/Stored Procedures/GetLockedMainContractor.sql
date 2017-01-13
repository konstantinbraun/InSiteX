CREATE PROCEDURE [dbo].[GetLockedMainContractor]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
AS

WITH Companies (SystemID, BpID, CompanyID, ParentID, NameVisible, LockedOn, LockSubContractors) AS
(
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID, m_c.NameVisible, m_c.LockedOn, m_c.LockSubContractors
	FROM Master_Companies m_c
		WHERE m_c.SystemID = @SystemID 
			AND m_c.BpID = @BpID 
			AND m_c.CompanyID = @CompanyID 

	UNION ALL
	
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID, m_c.NameVisible, m_c.LockedOn, m_c.LockSubContractors
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON Companies.SystemID = m_c.SystemID
				AND Companies.BpID = m_c.BpID
				AND Companies.ParentID = m_c.CompanyID
				AND m_c.CompanyID <> m_c.ParentID
)
SELECT SystemID, BpID, CompanyID, ParentID, NameVisible, LockedOn, LockSubContractors 
FROM Companies
WHERE CompanyID != @CompanyID
	AND LockedOn IS NOT NULL
	AND LockSubContractors = 1
;