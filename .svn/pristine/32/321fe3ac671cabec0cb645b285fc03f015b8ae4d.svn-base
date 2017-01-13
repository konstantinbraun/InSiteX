CREATE PROCEDURE [dbo].[LockSubContractors]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@Lock bit,
	@UserName nvarchar(50)
)
AS

WITH Companies(SystemID, BpID, CompanyID, ParentID) AS
(
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID
	FROM Master_Companies m_c
		WHERE m_c.SystemID = @SystemID 
			AND m_c.BpID = @BpID 
			AND m_c.CompanyID = @CompanyID 

	UNION ALL
	
	SELECT m_c.SystemID, m_c.BpID, m_c.CompanyID, m_c.ParentID
	FROM Master_Companies m_c
		INNER JOIN Companies
			ON Companies.SystemID = m_c.SystemID
				AND Companies.BpID = m_c.BpID
				AND Companies.CompanyID = m_c.ParentID
)
UPDATE Master_Companies
SET LockedFrom = (CASE WHEN @Lock = 1 THEN @UserName ELSE '' END),
	LockedOn = (CASE WHEN @Lock = 1 THEN SYSDATETIME() ELSE NULL END),
	ReleaseFrom = (CASE WHEN @Lock = 0 THEN @UserName ELSE ReleaseFrom END),
	ReleaseOn = (CASE WHEN @Lock = 0 THEN SYSDATETIME() ELSE ReleaseOn END)
FROM Master_Companies m_c
	JOIN Companies c
		ON m_c.SystemID = c.SystemID
			AND m_c.BpID = c.BpID
			AND m_c.CompanyID = c.CompanyID
;

