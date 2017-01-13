CREATE PROCEDURE [dbo].[GetUserInfo]
(
	@LoginName nvarchar(50)
)
AS

SELECT        
	m_u.SystemID, 
	m_u.BpID, 
	m_u.UserID, 
	m_u.CompanyID, 
	m_u.FirstName, 
	m_u.LastName, 
	s_c.NameVisible, 
	s_c.[Description], 
	s_a.Address1, 
	s_a.Address2, 
	s_a.Zip, 
	s_a.City, 
	s_a.[State], 
	v_c.CountryName, 
	s_a.WWW, 
	s_c.TradeAssociation, 
	m_u.Salutation, 
	v_l.LanguageName, 
	m_u.Phone, 
	m_u.Email, 
	m_u.LoginName
FROM Master_Users AS m_u 
	LEFT OUTER JOIN System_Companies AS s_c 
		ON m_u.SystemID = s_c.SystemID 
			AND m_u.CompanyID = s_c.CompanyID 
	LEFT OUTER JOIN System_Addresses AS s_a 
		ON s_c.SystemID = s_a.SystemID 
			AND s_c.AddressID = s_a.AddressID 
	LEFT OUTER JOIN View_Countries AS v_c 
		ON s_a.CountryID = v_c.CountryID 
	LEFT OUTER JOIN View_Languages AS v_l 
		ON m_u.LanguageID = v_l.LanguageID
WHERE m_u.LoginName LIKE @LoginName
;
