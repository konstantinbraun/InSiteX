CREATE PROCEDURE [dbo].[GetCompanyContainerManagement]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
AS

SELECT
	m_c.SystemID,
	m_c.BpID,
	m_c.CompanyID,
	s_c.NameVisible,
	s_c.NameAdditional,
	m_bp.ContainerManagementName
FROM Master_Companies AS m_c
	INNER JOIN Master_BuildingProjects AS m_bp
		ON m_c.SystemID = m_bp.SystemID
			AND m_c.BpID = m_bp.BpID
	INNER JOIN System_Companies as s_c
		ON m_c.SystemID = s_c.SystemID
			AND m_c.CompanyCentralID = s_c.CompanyID
WHERE m_c.SystemID = @SystemID 
	AND m_c.BpID = (CASE WHEN @BpID = 0 THEN m_c.BpID ELSE @BpID END) 
	AND s_c.CompanyID = CASE WHEN @CompanyID = 0 THEN s_c.CompanyID ELSE @CompanyID END -- Zentrale FirmenID abfragen, da hier die Bezeichnung geändert wird
	AND m_bp.ContainerManagementName IS NOT NULL 
	AND m_bp.ContainerManagementName <> ''
