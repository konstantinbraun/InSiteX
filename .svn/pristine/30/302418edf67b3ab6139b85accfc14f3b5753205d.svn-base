CREATE PROCEDURE [dbo].[GetMWLackTriggerOverdueEmployee]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

DECLARE @MonthNow date = DATEFROMPARTS(YEAR(SYSDATETIME()), MONTH(SYSDATETIME()), 1);

SELECT DISTINCT 
	m_bp.SystemID,
	m_bp.BpID,
	m_e.EmployeeID
FROM Master_BuildingProjects AS m_bp 
	INNER JOIN Master_Companies AS m_c 
		ON m_bp.SystemID = m_c.SystemID 
			AND m_bp.BpID = m_c.BpID 
	INNER JOIN Master_Employees AS m_e 
		ON m_c.SystemID = m_e.SystemID 
			AND m_c.BpID = m_e.BpID 
			AND m_c.CompanyID = m_e.CompanyID 
	INNER JOIN Data_EmployeeMinWage AS d_emw 
		ON m_e.SystemID = d_emw.SystemID 
			AND m_e.BpID = d_emw.BpID 
			AND m_e.EmployeeID = d_emw.EmployeeID
WHERE m_bp.SystemID = @SystemID
	AND m_bp.BpID = @BpID 
	AND m_bp.MinWageAccessRelevance = 1  
	AND m_bp.MWCheck = 1 
--	AND DAY(SYSDATETIME()) > m_bp.MWDeadline + m_bp.MWLackTrigger 
	AND m_c.MinWageAttestation = 1 
	AND m_e.EmployeeID = @EmployeeID
	AND m_e.StatusID = 20 -- Released
--	AND d_emw.MWMonth = @MonthNow
	AND d_emw.MWMonth <  DATEADD(MONTH,(CASE WHEN DAY(SYSDATETIME()) > m_bp.MWDeadline + m_bp.MWLackTrigger THEN 0 ELSE -1 END), @MonthNow) 
	AND d_emw.StatusCode = 1 
--	AND d_emw.StatusCode > 0
