CREATE PROCEDURE [dbo].[GetUserDuplicates]
(
	@SystemID int,
	@UserID int
)
AS

DECLARE @Soundex nvarchar(1000);
DECLARE @Email nvarchar(200);
DECLARE @CompanyID int;

SELECT 
	@Soundex = [Soundex], 
	@Email = Email, 
	@CompanyID = CompanyID
FROM Master_Users
WHERE SystemID = @SystemID
	AND UserID = @UserID
;

SELECT 
	m_u.UserID, 
	m_u.FirstName, 
	m_u.LastName, 
	m_u.Email, 
	ISNULL(s_c.NameVisible, '') AS NameVisible,
	(CASE 
		WHEN m_u.[Soundex] = @Soundex AND m_u.Email = @Email THEN 1
		WHEN m_u.[Soundex] = @Soundex AND m_u.CompanyID = @CompanyID THEN 2
	END) AS Match
FROM Master_Users m_u
	LEFT OUTER JOIN System_Companies s_c
		ON m_u.SystemID = s_c.SystemID
			AND m_u.CompanyID = s_c.CompanyID
WHERE m_u.SystemID = @SystemID
	AND m_u.UserID != @UserID
	AND ((m_u.[Soundex] = @Soundex AND m_u.Email = @Email)
		OR (m_u.[Soundex] = @Soundex AND m_u.CompanyID = @CompanyID))
ORDER BY
	Match,
	m_u.LastName,
	m_u.FirstName
;
