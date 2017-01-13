CREATE PROCEDURE [dbo].[GetProcessUsers]
	@SystemID int,
	@BpID int,
	@DialogID int,
	@ActionID int
AS

SELECT DISTINCT
	m_u.SystemID, 
	(CASE WHEN @BpID <> 0 THEN m_ubp.BpID ELSE 0 END) BpID, 
	m_u.UserID, 
	ISNULL(m_u.CompanyID, 0) CompanyID, 
	m_u.FirstName, 
	m_u.LastName, 
	ISNULL(m_u.Email, '') AS Email, 
	s_d.NameVisible AS DialogName, 
	s_d.ResourceID AS DialogRessource, 
	s_d.PageName,
	m_u.UseEmail,
	m_r.SelfAndSubcontractors,
	m_r_d.UseCompanyAssignment,
	m_u.LanguageID
FROM Master_Users AS m_u 
	INNER JOIN Master_UserBuildingProjects AS m_ubp 
		ON m_u.SystemID = m_ubp.SystemID 
			AND m_u.UserID = m_ubp.UserID 
	INNER JOIN Master_Roles_Dialogs AS m_r_d 
		ON m_ubp.SystemID = m_r_d.SystemID 
			AND m_ubp.BpID = m_r_d.BpID 
			AND m_ubp.RoleID = m_r_d.RoleID 
	INNER JOIN Master_Roles AS m_r 
		ON m_r_d.SystemID = m_r.SystemID 
			AND m_r_d.BpID = m_r.BpID 
			AND m_r_d.RoleID = m_r.RoleID 
	INNER JOIN System_Dialogs AS s_d 
		ON m_r_d.SystemID = s_d.SystemID 
			AND m_r_d.DialogID = s_d.DialogID 
	INNER JOIN Master_Dialogs_Actions AS m_d_a 
		ON m_r_d.SystemID = m_d_a.SystemID 
			AND m_r_d.BpID = m_d_a.BpID 
			AND m_r_d.RoleID = m_d_a.RoleID
			AND m_r_d.DialogID = m_d_a.DialogID
WHERE m_u.SystemID = @SystemID
	AND NOT m_u.ReleaseOn IS NULL 
	AND m_u.LockedOn IS NULL
	AND m_ubp.BpID = (CASE WHEN @BpID = 0 THEN m_ubp.BpID ELSE @BpID END) 
	AND m_r_d.DialogID = @DialogID 
	AND m_r_d.IsActive = 1
	AND m_d_a.ActionID = @ActionID 
	AND m_d_a.IsActive = 1
