CREATE PROCEDURE [dbo].[UpdateProcessEventsStatus]
	@SystemID int,
	@BpID int
AS

-- Firmenstamm BV
UPDATE Data_ProcessEvents
SET StatusID = 50
FROM Data_ProcessEvents AS d_pe 
	INNER JOIN Master_Companies AS m_c 
		ON d_pe.SystemID = m_c.SystemID 
			AND d_pe.BpID = m_c.BpID 
			AND d_pe.RefID = m_c.CompanyID
WHERE d_pe.SystemID = @SystemID
	AND d_pe.BpID = @BpID
	AND d_pe.DialogID = 2
	AND d_pe.ActionID = 15
	AND d_pe.StatusID <> 50
	AND m_c.ReleaseOn IS NOT NULL
;

-- Mitarbeiterstamm, Freigabe für BV
UPDATE Data_ProcessEvents
SET StatusID = 50
FROM Data_ProcessEvents AS d_pe 
	INNER JOIN Master_Employees AS m_e 
		ON d_pe.SystemID = m_e.SystemID 
			AND d_pe.BpID = m_e.BpID 
			AND d_pe.RefID = m_e.EmployeeID
WHERE d_pe.SystemID = @SystemID
	AND d_pe.BpID = @BpID
	AND d_pe.DialogID = 25
	AND d_pe.ActionID = 15
	AND d_pe.StatusID <> 50
	AND m_e.ReleaseBOn IS NOT NULL
;

-- Mitarbeiterstamm, Freigabe für Firma
UPDATE Data_ProcessEvents
SET StatusID = 50
FROM Data_ProcessEvents AS d_pe 
	INNER JOIN Master_Employees AS m_e 
		ON d_pe.SystemID = m_e.SystemID 
			AND d_pe.BpID = m_e.BpID 
			AND d_pe.RefID = m_e.EmployeeID
WHERE d_pe.SystemID = @SystemID
	AND d_pe.BpID = @BpID
	AND d_pe.DialogID = 25
	AND d_pe.ActionID = 5
	AND d_pe.StatusID <> 50
	AND m_e.ReleaseCOn IS NOT NULL
;


RETURN 0
