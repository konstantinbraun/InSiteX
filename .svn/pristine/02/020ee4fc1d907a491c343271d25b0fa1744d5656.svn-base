CREATE PROCEDURE [dbo].[CompressPresenceData]
(
	@SystemID int,
	@BpID int,
	@PresenceDay date,
	@CompressType int
)
AS

SET NOCOUNT ON;

-- Bestehende Verdichtungsdaten löschen
DELETE FROM Data_PresenceEmployee
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND PresenceDay = @PresenceDay
;

-- Anwesenheit pro Firma, Gewerk und Mitarbeiter, Variante 2 und 3
INSERT INTO Data_PresenceEmployee
(
	SystemID,
	BpID,
	CompanyID,
	TradeID,
	PresenceDay,
	EmployeeID,
	CountAs,
	PresenceSeconds
)
SELECT DISTINCT        
	d_pae.SystemID, 
	d_pae.BpID, 
	d_pae.CompanyID, 
	d_pae.TradeID,
	d_pae.PresenceDay,
	d_pae.EmployeeID,
	MAX(d_pae.CountAs),
	SUM(d_pae.PresenceSeconds)
FROM Data_PresenceAccessEvents AS d_pae
WHERE d_pae.SystemID = @SystemID
	AND d_pae.BpID = @BpID
	AND d_pae.PresenceDay = @PresenceDay
	AND NOT EXISTS
	(
		SELECT 1 
		FROM Data_PresenceEmployee AS d_pe
		WHERE d_pe.SystemID = d_pae.SystemID
			AND d_pe.BpID = d_pae.BpID
			AND d_pe.CompanyID = d_pae.CompanyID
			AND d_pe.TradeID = d_pae.TradeID
			AND d_pe.PresenceDay = d_pae.PresenceDay
			AND d_pe.EmployeeID = d_pae.EmployeeID
	)
GROUP BY 
	d_pae.SystemID, 
	d_pae.BpID, 
	d_pae.CompanyID, 
	d_pae.TradeID,
	d_pae.PresenceDay,
	d_pae.EmployeeID
;

-- Bestehende Verdichtungsdaten löschen
DELETE FROM Data_PresenceCompany
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND PresenceDay = @PresenceDay
;

-- Verdichtung pro Firma und Gewerk, alle Varianten
INSERT INTO Data_PresenceCompany
(
	SystemID,
	BpID,
	CompanyID,
	TradeID,
	PresenceDay,
	CountAs,
	PresenceSeconds
)
SELECT        
	d_pae.SystemID, 
	d_pae.BpID, 
	d_pae.CompanyID, 
	d_pae.TradeID,
	d_pae.PresenceDay,
	SUM(d_pae.CountAs),
	SUM(d_pae.PresenceSeconds)
FROM Data_PresenceEmployee AS d_pae
WHERE d_pae.SystemID = @SystemID
	AND d_pae.BpID = @BpID
	AND d_pae.PresenceDay = @PresenceDay
	AND NOT EXISTS
	(
		SELECT 1 
		FROM Data_PresenceCompany AS d_pc
		WHERE d_pc.SystemID = d_pae.SystemID
			AND d_pc.BpID = d_pae.BpID
			AND d_pc.CompanyID = d_pae.CompanyID
			AND d_pc.TradeID = d_pae.TradeID
			AND d_pc.PresenceDay = d_pae.PresenceDay
	)
GROUP BY
	d_pae.SystemID, 
	d_pae.BpID, 
	d_pae.CompanyID, 
	d_pae.TradeID,
	d_pae.PresenceDay
;

-- Löschen der nicht erforderlichen Verdichtungen für die aktuelle Anwesenheitsvariante
--IF (@CompressType = 2)
--	DELETE FROM Data_PresenceAccessEvents
--	WHERE SystemID = @SystemID
--		AND BpID = @BpID
--		AND PresenceDay = @PresenceDay

--IF (@CompressType = 1)
--	DELETE FROM Data_PresenceEmployee
--	WHERE SystemID = @SystemID
--		AND BpID = @BpID
--		AND PresenceDay = @PresenceDay

-- Flag und minimale Anwesenheitszeit für Mindestlohnprüfung
DECLARE @MWCheck bit = 0;
DECLARE @MWSeconds bigint;

SELECT 
	@MWCheck = MWCheck,
	@MWSeconds = ISNULL(MWHours, 0) * 3600
FROM Master_BuildingProjects
WHERE SystemID = @SystemID
	AND BpID = @BpID
;

IF (@MWCheck = 1)
BEGIN
	-- Monatsanfang und -ende des Anwesenheitstages als Datum / Uhrzeit ermitteln
	DECLARE @BeginOfMonth date = DATEFROMPARTS(YEAR(@PresenceDay), MONTH(@PresenceDay), 1);
	DECLARE @EndOfMonth date = DATEADD(DAY, -1, DATEADD(MONTH, 1, @BeginOfMonth));

	-- Mindestlohnsätze für Mitarbeiter anlegen oder aktualisieren
	INSERT INTO Data_EmployeeMinWage
	(
		SystemID, 
		BpID, 
		EmployeeID, 
		MWMonth, 
		PresenceSeconds, 
		StatusCode, 
		Amount, 
		CreatedFrom, 
		CreatedOn, 
		EditFrom, 
		EditOn
	)
	SELECT
		d_pe.SystemID, 
		d_pe.BpID, 
		d_pe.EmployeeID, 
		@BeginOfMonth, 
		0, 
		0, 
		0, 
		'System', 
		SYSDATETIME(), 
		'System', 
		SYSDATETIME()
	FROM Data_PresenceEmployee AS d_pe
		INNER JOIN Master_Employees AS m_e
			ON d_pe.SystemID = m_e.SystemID
				AND d_pe.BpID = m_e.BpID
				AND d_pe.EmployeeID = m_e.EmployeeID 
		INNER JOIN Master_Companies AS m_c
			ON m_e.SystemID = m_c.SystemID 
				AND m_e.BpID = m_c.BpID 
				AND m_e.CompanyID = m_c.CompanyID 
		INNER JOIN Master_EmploymentStatus AS m_es
			ON m_e.SystemID = m_es.SystemID 
				AND m_e.BpID = m_es.BpID 
				AND m_e.EmploymentStatusID = m_es.EmploymentStatusID
	WHERE d_pe.PresenceDay BETWEEN @BeginOfMonth AND @EndOfMonth
		AND m_c.MinWageAttestation = 1 
		AND m_es.MWObligate = 1
		AND NOT EXISTS
		(
			SELECT 1
			FROM Data_EmployeeMinWage
			WHERE SystemID = d_pe.SystemID
				AND BpID = d_pe.BpID
				AND EmployeeID = d_pe.EmployeeID
				AND MWMonth = @BeginOfMonth
		)
	GROUP BY 
		d_pe.SystemID, 
		d_pe.BpID, 
		d_pe.EmployeeID
	HAVING d_pe.SystemID = @SystemID 
		AND d_pe.BpID = @BpID 
	;

	UPDATE d_emw
	SET PresenceSeconds = d_pe.PresenceSeconds,
		StatusCode = (CASE WHEN d_pe.PresenceSeconds > @MWSeconds THEN 1 ELSE 0 END)
	FROM Data_EmployeeMinWage AS d_emw 
		INNER JOIN 
		(
			SELECT 
				SystemID, 
				BpID, 
				EmployeeID, 
				SUM(ISNULL(PresenceSeconds, 0)) AS PresenceSeconds 
				FROM Data_PresenceEmployee 
			WHERE PresenceDay BETWEEN @BeginOfMonth AND @EndOfMonth 
			GROUP BY 
				SystemID, 
				BpID, 
				EmployeeID
			HAVING SystemID = @SystemID 
				AND BpID = @BpID 
		) AS d_pe 
			ON d_emw.SystemID = d_pe.SystemID 
				AND d_emw.BpID = d_pe.BpID 
				AND d_emw.EmployeeID = d_pe.EmployeeID 
		INNER JOIN Master_Employees AS m_e
			ON d_emw.SystemID = m_e.SystemID
				AND d_emw.BpID = m_e.BpID
				AND d_emw.EmployeeID = m_e.EmployeeID 
		INNER JOIN Master_Companies AS m_c
			ON m_e.SystemID = m_c.SystemID 
				AND m_e.BpID = m_c.BpID 
				AND m_e.CompanyID = m_c.CompanyID 
		INNER JOIN Master_EmploymentStatus AS m_es
			ON m_e.SystemID = m_es.SystemID 
				AND m_e.BpID = m_es.BpID 
				AND m_e.EmploymentStatusID = m_es.EmploymentStatusID
	WHERE  d_emw.SystemID = @SystemID 
		AND d_emw.BpID = @BpID
		AND d_emw.MWMonth = @BeginOfMonth
		AND m_c.MinWageAttestation = 1 
		AND m_es.MWObligate = 1
	;
END

-- Bereinigung der Vorgangsverwaltung
EXEC dbo.CleanupProcessEvents @SystemID, @BpID;

RETURN 0;
