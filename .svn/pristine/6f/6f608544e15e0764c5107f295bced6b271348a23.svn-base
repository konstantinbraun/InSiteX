CREATE PROCEDURE [dbo].[GetPresentPersonsPerAccessArea]
	@SystemID int,
	@BpID int
AS

SELECT
	s.SystemID, 
	s.BpID, 
	SUM(s.EmployeesPresent) AS EmployeesPresent, 
	SUM(s.VisitorsPresent) AS VisitorsPresent, 
	s.AccessAreaID, 
	s.NameVisible
FROM
(
	SELECT 
		m_e.SystemID, 
		m_e.BpID, 
		COUNT(m_e.EmployeeID) AS EmployeesPresent, 
		0 AS VisitorsPresent, 
		m_eaa.AccessAreaID, 
		m_aa.NameVisible
	FROM Master_Employees m_e 
		INNER JOIN Master_Passes m_p
			ON m_p.SystemID = m_e.SystemID
				AND m_p.BpID = m_e.BpID
				AND m_p.EmployeeID = m_e.EmployeeID
		INNER JOIN Master_EmployeeAccessAreas m_eaa
			ON m_e.SystemID = m_eaa.SystemID
				AND m_e.BpID = m_eaa.BpID
				AND m_e.EmployeeID = m_eaa.EmployeeID
		INNER JOIN Master_AccessAreas m_aa
			ON m_eaa.SystemID = m_aa.SystemID
				AND m_eaa.BpID = m_aa.BpID
				AND m_eaa.AccessAreaID = m_aa.AccessAreaID
	WHERE m_e.SystemID = @SystemID 
		AND m_e.BpID = @BpID
		AND m_p.ActivatedOn IS NOT NULL
		AND m_p.DeactivatedOn IS NULL
		AND m_p.LockedOn IS NULL
		AND dbo.EmployeeAccessAreaPresentState(m_e.SystemID, m_e.BpID, m_e.EmployeeID, m_eaa.AccessAreaID) = 1
	GROUP BY 
		m_e.SystemID, 
		m_e.BpID, 
		m_eaa.AccessAreaID, 
		m_aa.NameVisible

	UNION

	SELECT 
		d_stv.SystemID, 
		d_stv.BpID, 
		0 AS EmployeesPresent, 
		COUNT(d_stv.ShortTermVisitorID) AS VisitorsPresent, 
		d_staa.AccessAreaID, 
		m_aa.NameVisible
	FROM Data_ShortTermVisitors d_stv 
		INNER JOIN Data_ShortTermPasses d_stp
			ON d_stv.SystemID = d_stp.SystemID
				AND d_stv.BpID = d_stp.BpID
				AND d_stv.ShortTermPassID = d_stp.ShortTermPassID
		INNER JOIN Data_ShortTermAccessAreas d_staa
			ON d_stv.SystemID = d_staa.SystemID
				AND d_stv.BpID = d_staa.BpID
				AND d_stv.ShortTermVisitorID = d_staa.ShortTermVisitorID
		INNER JOIN Master_AccessAreas m_aa
			ON d_staa.SystemID = m_aa.SystemID
				AND d_staa.BpID = m_aa.BpID
				AND d_staa.AccessAreaID = m_aa.AccessAreaID
	WHERE d_stv.SystemID = @SystemID 
		AND d_stv.BpID = @BpID
		AND d_stv.PassActivatedOn IS NOT NULL
		AND d_stv.PassDeactivatedOn IS NULL
		AND d_stv.PassLockedOn IS NULL
		AND dbo.ShortTermAccessAreaPresentState(d_stv.SystemID, d_stv.BpID, d_stv.ShortTermVisitorID, d_staa.AccessAreaID) = 1
	GROUP BY 
		d_stv.SystemID, 
		d_stv.BpID, 
		d_staa.AccessAreaID, 
		m_aa.NameVisible
) AS s
GROUP BY 
	s.SystemID, 
	s.BpID, 
	s.AccessAreaID, 
	s.NameVisible
