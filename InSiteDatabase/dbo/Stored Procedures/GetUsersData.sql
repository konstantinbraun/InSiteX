CREATE PROCEDURE [dbo].[GetUsersData]
(
	@SystemID int,
	@BpID int = 0,
	@CompanyCentralID int = 0,
	@UserID int,
	@Usertype int,
	@Filter nvarchar(50)
)
AS

SELECT DISTINCT
	m_u.SystemID, 
	m_u.UserID, 
	UPPER(LEFT (m_u.LastName, 1)) AS FirstChar, 
	m_u.FirstName, 
	m_u.LastName, 
	m_u.CompanyID, 
	m_u.LoginName, 
	m_u.[Password], 
	m_u.RoleID, 
	m_u.LanguageID, 
	m_u.SkinName, 
	m_u.Phone, 
	m_u.Email, 
	m_u.SessionID, 
	m_u.IsVisible, 
	m_u.CreatedFrom, 
	m_u.CreatedOn, 
	m_u.EditFrom,
	m_u.EditOn, 
	s_c.NameVisible AS Company, 
	m_u.ReleaseFrom, 
	m_u.ReleaseOn, 
	m_u.LockedFrom, 
	m_u.LockedOn, 
	m_u.StatusID, 
	m_u.FirstName + ' ' + m_u.LastName AS UserName, 
	m_u.Salutation, 
	m_u.GenderID, 
	m_u.IsSysAdmin, 
	s_c.StatusID AS CompanyStatusID, 
	CASE 
		WHEN ISNULL(s_sl.SessionState,0) > 0 THEN 1
		ELSE 0
	END AS  IsOnline,
	m_u.UseEmail, 
	m_u.[Soundex] AS Duplicates
FROM Master_Users AS m_u
	LEFT OUTER JOIN Master_UserBuildingProjects AS m_ubp
		ON m_u.SystemID = m_ubp.SystemID 
			AND m_u.UserID = m_ubp.UserID
	LEFT OUTER JOIN Master_Roles AS m_r
		ON m_r.SystemID = m_ubp.SystemID 
			AND m_r.BpID = m_ubp.BpID 
			AND m_r.RoleID = m_ubp.RoleID
	LEFT OUTER JOIN System_Companies AS s_c
		ON m_u.SystemID = s_c.SystemID 
			AND m_u.CompanyID = s_c.CompanyID
	LEFT OUTER JOIN Master_UserBuildingProjects AS m_ubp_own
		ON m_u.SystemID = m_ubp_own.SystemID 
			AND m_ubp.BpID = m_ubp_own.BpID
	LEFT OUTER JOIN
		 ( SELECT * 
			FROM  System_SessionLog AS s_sl 
			WHERE (s_sl.SessionState = 10) OR (s_sl.SessionState = 20) 
		 ) AS s_sl ON m_u.SystemID = s_sl.SystemID AND m_u.UserID = s_sl.UserID	
WHERE m_u.SystemID = @SystemID
	AND m_u.CompanyID = 
		(
			CASE 
				WHEN @CompanyCentralID = 0 
				THEN m_u.CompanyID 
				ELSE @CompanyCentralID 
			END
		)
	AND @Filter = 
		(
			CASE 
				WHEN @Filter = '' 
				THEN @Filter 
				ELSE UPPER(LEFT (m_u.LastName, 1)) 
			END
		) 
	AND 
	(
		(m_ubp.BpID IS NOT NULL AND @BpID = -1)
		OR
		(m_ubp.BpID IS NULL AND @BpID = -2)
		OR
		(m_ubp.BpID = @BpID)
		OR
		(@BpID = 0)
	)
	AND (m_r.TypeID <= @Usertype OR m_r.TypeID IS NULL)
	AND (m_ubp_own.UserID = @UserID OR @Usertype >= 50)
ORDER BY 
	m_u.LastName, 
	m_u.FirstName, 
	s_c.NameVisible
