CREATE FUNCTION [dbo].[HasLockedMainContractor]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
RETURNS INT
AS
BEGIN
	DECLARE @Count int = 0;

	WITH Companies (SystemID, BpID, CompanyID, ParentID, NameVisible, LockedOn, LockSubContractors) AS
	(
		SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID, m_c.NameVisible, m_c.LockedOn, m_c.LockSubContractors
		FROM Master_Companies m_c
			WHERE m_c.SystemID = @SystemID 
				AND m_c.BpID = @BpID 
				AND m_c.CompanyID = @CompanyID 
				AND m_c.ParentID <> 0

		UNION ALL
	
		SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID, m_c.NameVisible, m_c.LockedOn, m_c.LockSubContractors
		FROM Master_Companies m_c
			INNER JOIN Companies
				ON m_c.SystemID = Companies.SystemID 
					AND m_c.BpID = Companies.BpID
					AND m_c.CompanyID = Companies.ParentID
		WHERE m_c.CompanyID != @CompanyID
	)
	SELECT @Count = COUNT(CompanyID) 
	FROM Companies
	WHERE CompanyID != @CompanyID
		AND LockedOn IS NOT NULL
		AND LockSubContractors = 1

	RETURN SIGN(@Count)
END
