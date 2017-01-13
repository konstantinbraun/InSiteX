CREATE PROCEDURE [dbo].[GetCompanyAdminUserWithBP]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
AS

SELECT m_u.*
FROM Master_Users m_u
	INNER JOIN System_Companies s_c
		ON m_u.SystemID = s_c.SystemID
			AND m_u.UserID = s_c.UserID
	INNER JOIN Master_Companies m_c
		ON s_c.SystemID = m_c.SystemID
			AND s_c.CompanyID = m_c.CompanyCentralID
WHERE m_u.SystemID = @SystemID
	AND m_c.BpID = @BpID
	AND m_c.CompanyID = @CompanyID
