CREATE PROCEDURE [dbo].[CleanupProcessEvents]
(
	@SystemID int,
	@BpID int
)

AS

-- Gelöschte Firmen
DELETE d_pe
FROM Data_ProcessEvents d_pe
WHERE d_pe.SystemID = @SystemID
	AND d_pe.BpID = 0
	AND d_pe.DialogID = 91
	AND NOT EXISTS
	(
		SELECT 1
		FROM System_Companies m_c
		WHERE m_c.SystemID = d_pe.SystemID
			AND m_c.CompanyID = d_pe.RefID
	)
;

-- Gelöschte Benutzer
DELETE d_pe
FROM Data_ProcessEvents d_pe
WHERE d_pe.SystemID = @SystemID
	AND d_pe.BpID = 0
	AND d_pe.DialogID = 92
	AND NOT EXISTS
	(
		SELECT 1
		FROM Master_Users m_c
		WHERE m_c.SystemID = d_pe.SystemID
			AND m_c.UserID = d_pe.RefID
	)
;

-- Gelöschte BV Firmen
DELETE d_pe
FROM Data_ProcessEvents d_pe
WHERE  d_pe.SystemID = @SystemID
	AND d_pe.BpID = @BpID
	AND d_pe.DialogID = 2
	AND NOT EXISTS
	(
		SELECT 1
		FROM Master_Companies m_c
		WHERE m_c.SystemID = d_pe.SystemID
			AND m_c.BpID = d_pe.BpID
			AND m_c.CompanyID = d_pe.RefID
	)
;

-- Gelöschte Mitarbeiter
DELETE d_pe
FROM Data_ProcessEvents d_pe
WHERE  d_pe.SystemID = @SystemID
	AND d_pe.BpID = @BpID
	AND d_pe.DialogID = 25
	AND NOT EXISTS
	(
		SELECT 1
		FROM Master_Employees m_c
		WHERE m_c.SystemID = d_pe.SystemID
			AND m_c.BpID = d_pe.BpID
			AND m_c.EmployeeID = d_pe.RefID
	)
;

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

-- Nicht erledigte Vorgänge nach xx Tagen auf erledigt setzen
-- Erlaubnis von Streif steht aus
--UPDATE Data_ProcessEvents
--SET StatusID = 50, 
--	DoneFrom='System', 
--	DoneOn=SYSDATETIME()
--WHERE SystemID = @SystemID
--	AND BpID = @BpID
--	AND CreatedOn < DATEADD(DAY, -30, SYSDATETIME()) 
--	AND StatusID <> 50
--;

