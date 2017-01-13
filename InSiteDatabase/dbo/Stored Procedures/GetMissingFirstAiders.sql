CREATE PROCEDURE [dbo].[GetMissingFirstAiders]
(
	@SystemID int,
	@BpID int
)
AS

SELECT 
	a.SystemID, 
	a.BpID, 
	a.EmployeesPresent, 
	a.FirstAidersPresent, 
	a.CompanyID, 
	a.CompanyName, 
	MIN(m_fa.MinAiders) - a.FirstAidersPresent AS MinAiders
FROM
(
	SELECT
		m_e.SystemID, 
		m_e.BpID, 
		COUNT(m_e.EmployeeID) AS EmployeesPresent, 
		SUM(ISNULL(CAST(m_sr.IsFirstAider AS tinyint), 0)) AS FirstAidersPresent, 
		m_c.CompanyID, 
		m_c.NameVisible AS CompanyName
	FROM Master_Employees AS m_e
		INNER JOIN Master_Passes m_p
			ON m_p.SystemID = m_e.SystemID
				AND m_p.BpID = m_e.BpID
				AND m_p.EmployeeID = m_e.EmployeeID
		INNER JOIN Master_Companies AS m_c 
			ON m_e.SystemID = m_c.SystemID 
				AND m_e.BpID = m_c.BpID 
				AND m_e.CompanyID = m_c.CompanyID 
		LEFT OUTER JOIN Master_EmployeeQualification AS m_eq 
			ON m_e.SystemID = m_eq.SystemID 
				AND m_e.BpID = m_eq.BpID 
				AND m_e.EmployeeID = m_eq.EmployeeID
		LEFT OUTER JOIN Master_StaffRoles AS m_sr 
			ON m_eq.SystemID = m_sr.SystemID 
				AND m_eq.BpID = m_sr.BpID 
				AND m_eq.StaffRoleID = m_sr.StaffRoleID 
		WHERE m_e.SystemID = @SystemID
			AND m_e.BpID = @BpID
			AND m_p.ActivatedOn IS NOT NULL
			AND m_p.DeactivatedOn IS NULL
			AND m_p.LockedOn IS NULL
			AND dbo.EmployeePresentState(m_e.SystemID, m_e.BpID, m_e.EmployeeID) = 1
			AND (m_sr.IsFirstAider = 1 OR m_sr.IsFirstAider IS NULL)
		GROUP BY 
			m_e.SystemID, 
			m_e.BpID, 
			m_c.CompanyID, 
			m_c.NameVisible
) AS a
	INNER JOIN Master_FirstAiders AS m_fa
		ON a.SystemID = m_fa.SystemID
			AND a.BpID = m_fa.BpID
			AND a.EmployeesPresent <= m_fa.MaxPresent
GROUP BY
	a.SystemID, 
	a.BpID, 
	a.EmployeesPresent, 
	a.FirstAidersPresent, 
	a.CompanyID, 
	a.CompanyName
-- HAVING a.FirstAidersPresent < MIN(m_fa.MinAiders)