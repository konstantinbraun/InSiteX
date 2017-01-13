CREATE PROCEDURE [dbo].[GetCompanyAdminUser]
(
	@SystemID int,
	@CompanyCentralID int
)
AS

SELECT m_u.*
FROM Master_Users m_u
	INNER JOIN System_Companies s_c
		ON m_u.SystemID = s_c.SystemID
			AND m_u.UserID = s_c.UserID
WHERE m_u.SystemID = @SystemID
	AND s_c.CompanyID = @CompanyCentralID
