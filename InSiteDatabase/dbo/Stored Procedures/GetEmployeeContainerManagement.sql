CREATE PROCEDURE [dbo].[GetEmployeeContainerManagement]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

SELECT DISTINCT
	m_e.SystemID, 
	m_e.BpID, 
	m_e.EmployeeID, 
	m_p.ExternalID,
	m_a.FirstName, 
	m_a.LastName, 
	m_e.CompanyID, 
	m_e.TradeID, 
	m_a.Phone, 
	CAST(MAX(ISNULL(CAST(m_sr.IsDisposalExpert AS int), 0)) AS bit) AS IsDisposalExpert,
	m_bp.ContainerManagementName
FROM Master_Employees AS m_e
	INNER JOIN Master_Addresses AS m_a
		ON m_e.SystemID = m_a.SystemID 
		AND m_e.BpID = m_a.BpID 
		AND m_e.AddressID = m_a.AddressID 
	INNER JOIN Master_BuildingProjects AS m_bp
		ON m_e.SystemID = m_bp.SystemID
			AND m_e.BpID = m_bp.BpID
	INNER JOIN Master_Passes AS m_p
		ON m_e.SystemID = m_p.SystemID 
			AND m_e.BpID = m_p.BpID 
			AND m_e.EmployeeID = m_p.EmployeeID 
	LEFT OUTER JOIN Master_EmployeeQualification AS m_eq 
		ON m_e.SystemID = m_eq.SystemID 
			AND m_e.BpID = m_eq.BpID 
			AND m_e.EmployeeID = m_eq.EmployeeID
	LEFT OUTER JOIN Master_StaffRoles AS m_sr 
		ON m_sr.SystemID = m_eq.SystemID 
			AND m_sr.BpID = m_eq.BpID 
			AND m_sr.StaffRoleID = m_eq.StaffRoleID 
WHERE m_e.SystemID = @SystemID 
	AND m_e.BpID = @BpID 
	AND m_e.EmployeeID = CASE WHEN @EmployeeID = 0 THEN m_e.EmployeeID ELSE @EmployeeID END
	AND m_bp.ContainerManagementName IS NOT NULL 
	AND m_bp.ContainerManagementName <> ''
	AND m_p.ActivatedOn IS NOT NULL
	-- AND m_sr.IsDisposalExpert = 1
GROUP BY
	m_e.SystemID, 
	m_e.BpID, 
	m_e.EmployeeID, 
	m_p.ExternalID,
	m_a.FirstName, 
	m_a.LastName, 
	m_e.CompanyID, 
	m_e.TradeID, 
	m_a.Phone, 
	m_bp.ContainerManagementName

