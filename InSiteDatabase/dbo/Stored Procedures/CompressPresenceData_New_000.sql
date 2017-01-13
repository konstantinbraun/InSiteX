CREATE PROCEDURE [dbo].[CompressPresenceData_New]
(
	@SystemID int,
	@BpID int,
	@PresenceDay date,
	@CompressType int
)
AS

DECLARE @EndOfDay datetime = DATEADD(D, 1, @PresenceDay);
SET @EndOfDay = DATEADD(S, -1, @EndOfDay);

DECLARE @BeginOfMonth date = DATEFROMPARTS(DATEPART(YYYY, @PresenceDay), DATEPART(M, @PresenceDay), 1);
DECLARE @EndOfMonth date = DATEFROMPARTS(DATEPART(YYYY, @PresenceDay), DATEPART(M, @PresenceDay) + 1, 1);
SET @EndOfMonth = DATEADD(D, -1, @EndOfMonth);

DECLARE @MWCheck bit = 0;
DECLARE @MWSeconds bigint;

SELECT 
	@MWCheck = MWCheck,
	@MWSeconds = ISNULL(MWHours, 0) * 3600
FROM Master_BuildingProjects
WHERE SystemID = @SystemID
	AND BpID = @BpID
;

-- Ergänzung der inkonsistenten Zutrittsereignisse
DECLARE @SecondRow bit;
DECLARE @AccessAreaID int, @OwnerID int, @InternalID nvarchar(50), @AccessOn datetime, @AccessType int, @PresentTimeHours int, @PresentTimeMinutes int;
DECLARE @AccessAreaID1 int, @OwnerID1 int, @InternalID1 nvarchar(50), @AccessOn1 datetime, @AccessType1 int, @PresentTimeHours1 int, @PresentTimeMinutes1 int;
DECLARE @AccessEvents CURSOR FOR
SELECT
	d_ae.AccessAreaID,
	d_ae.OwnerID,
	d_ae.InternalID,
	d_ae.AccessOn,
	d_ae.AccessType,
	m_aa.PresentTimeHours,
	m_aa.PresentTimeMinutes
FROM Data_AccessEvents d_ae
	INNER JOIN Master_AccessAreas m_aa
		ON d_ae.SystemID = m_aa.SystemID
			AND d_ae.BpID = m_aa.BpID
			AND d_ae.AccessAreaID = m_aa.AccessAreaID
WHERE d_ae.SystemID = @SystemID
	AND d_ae.BpID = @BpID
	AND d_ae.AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay
	AND d_ae.AccessResult = 1
	AND m_aa.CompleteAccessTimes = 1
ORDER BY InternalID, AccessAreaID, AccessOn, AccessType
;

OPEN @AccessEvents

-- Ersten Satz lesen
FETCH NEXT FROM @AccessEvents
INTO @AccessAreaID, @OwnerID, @InternalID, @AccessOn, @AccessType, @PresentTimeHours, @PresentTimeMinutes

DECLARE @AccessOnNew datetime = CAST(@PresenceDay AS datetime)

WHILE @@FETCH_STATUS = 0
	BEGIN
	-- Zweiten Satz lesen
	FETCH NEXT FROM @AccessEvents
	INTO @AccessAreaID1, @OwnerID1, @InternalID1, @AccessOn1, @AccessType1, @PresentTimeHours1, @PresentTimeMinutes1
	IF (@@FETCH_STATUS = 0)
		SET @SecondRow = 1
	ELSE
		SET @SecondRow = 0

	-- Erstes Ereignis ist Geht Buchung?
	IF (@AccessType = 0)
		BEGIN
			-- Maximale Anwesenheitszeit beachten
			IF (DATEDIFF(MINUTE, @AccessOnNew, @AccessOn) > (@PresentTimeHours * 60) + @PresentTimeMinutes)
				SET @AccessOnNew = DATEADD(MINUTE, ((@PresentTimeHours * 60) + @PresentTimeMinutes) * (-1), @AccessOn)
		
			-- Kommt Buchung erzeugen
			INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
				AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom)
			VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 1, 1, 
				'', 0, 1, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System')
		END

	-- Es gibt einen zweiten Satz?
	ELSE IF (@SecondRow = 1)
		BEGIN
			IF (@InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1 AND @AccessType = 1 AND @AccessType1 = 0)
				BEGIN
					-- Kommt und Geht Buchungen gehören zusammen, nichts machen
					SET @AccessOnNew = CAST(@PresenceDay AS datetime)

					-- Nächsten Satz lesen
					FETCH NEXT FROM @AccessEvents
					INTO @AccessAreaID, @OwnerID, @InternalID, @AccessOn, @AccessType, @PresentTimeHours, @PresentTimeMinutes
				END

		ELSE
			BEGIN
				-- Kommt und Geht Buchungen gehören nicht zusammen oder zwei Kommt Buchungen hintereinander
				IF (@InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1 AND @AccessType = 1 AND @AccessType1 = 1)
					BEGIN
						-- Zwei Kommt Buchungen hintereinander -> Geht Buchung erzeugen
						SET @AccessOnNew = @EndOfDay

						-- Maximale Anwesenheitszeit beachten
						IF (DATEDIFF(MINUTE, @AccessOn, @AccessOnNew) > (@PresentTimeHours * 60) + @PresentTimeMinutes)
							SET @AccessOnNew = DATEADD(MINUTE, (@PresentTimeHours * 60) + @PresentTimeMinutes, @AccessOn)
		
						-- Geht Buchung erzeugen
						INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
							AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom)
						VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 0, 1, 
							'', 0, 1, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System')

						-- Zweiter Satz wird erster Satz
						 SET @AccessAreaID = @AccessAreaID1
						 SET @OwnerID = @OwnerID1
						 SET @InternalID = @InternalID1
						 SET @AccessOn = @AccessOn1
						 SET @AccessType = @AccessType1
						 SET @PresentTimeHours = @PresentTimeHours1
						 SET @PresentTimeMinutes = @PresentTimeMinutes1
					END

				ELSE
					BEGIN
					-- Buchungen gehören nicht zusammen
					IF (@AccessType = 1)
						BEGIN
							-- Letzte Geht Buchung für ersten Satz fehlt -> erzeugen
							SET @AccessOnNew = @EndOfDay

							-- Maximale Anwesenheitszeit beachten
							IF (DATEDIFF(MINUTE, @AccessOn, @AccessOnNew) > (@PresentTimeHours * 60) + @PresentTimeMinutes)
								SET @AccessOnNew = DATEADD(MINUTE, (@PresentTimeHours * 60) + @PresentTimeMinutes, @AccessOn)
		
							-- Geht Buchung erzeugen
							INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
								AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom)
							VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 0, 1, 
								'', 0, 1, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System')
						END

					IF (@AccessType1 = 0)
						BEGIN
							-- Erste Kommt Buchung für zweiten Satz fehlt -> erzeugen
							SET @AccessOnNew = CAST(@PresenceDay AS datetime)

							-- Maximale Anwesenheitszeit beachten
							IF (DATEDIFF(MINUTE, @AccessOnNew, @AccessOn) > (@PresentTimeHours * 60) + @PresentTimeMinutes)
								SET @AccessOnNew = DATEADD(MINUTE, ((@PresentTimeHours * 60) + @PresentTimeMinutes) * (-1), @AccessOn)
		
							-- Kommt Buchung erzeugen
							INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
								AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom)
							VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 1, 1, 
								'', 0, 1, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System')
						END

				END


			END


	END

END




-- Ermittlung aller Zutrittsereignisse für den Tag
INSERT INTO Data_PresenceAccessEvents
(
	SystemID,
	BpID,
	CompanyID,
	TradeID,
	PresenceDay,
	EmployeeID,
	AccessAt,
	ExitAt,
	PresenceSeconds,
	AccessAreaID,
	TimeSlotID,
	AccessTimeManual,
	ExitTimeManual
)
SELECT DISTINCT        
	d_ae.SystemID, 
	d_ae.BpID, 
	m_e.CompanyID, 
	m_e.TradeID,
	@PresenceDay,
	d_ae.OwnerID,
	ISNULL(d_ae.AccessAt, CAST(@PresenceDay AS datetime)),
	(CASE WHEN DATEDIFF(s, CAST(d_ae.ExitAt AS datetime), CAST(@PresenceDay AS datetime)) = 0 THEN @EndOfDay ELSE d_ae.ExitAt END) AS ExitAt,
	ISNULL(SUM(DATEDIFF(s, d_ae.AccessAt, (CASE WHEN DATEDIFF(s, CAST(d_ae.ExitAt AS datetime), CAST(@PresenceDay AS datetime)) = 0 THEN @EndOfDay ELSE d_ae.ExitAt END))), 0) AS PresenceSeconds,
	d_ae.AccessAreaID,
	0,
	(CASE WHEN d_ae.AccessAt IS NULL THEN 1 ELSE d_ae.AccessTimeManual END) AS AccessTimeManual,
	(CASE WHEN DATEDIFF(s, CAST(d_ae.ExitAt AS datetime), CAST(@PresenceDay AS datetime)) = 0 THEN 1 ELSE d_ae.ExitTimeManual END) AS ExitTimeManual
FROM 
	(
		SELECT 
			SystemID, 
			BpID, 
			OwnerID, 
			AccessAreaID,
			MIN(CASE WHEN AccessType = 1 THEN AccessOn ELSE NULL END) AS AccessAt,
			MAX(CASE WHEN AccessType = 0 THEN AccessOn ELSE NULL END) AS ExitAt,  
			MAX(CASE WHEN AccessType = 1 AND IsManualEntry = 1 THEN 1 ELSE 0 END) AS AccessTimeManual,
			MAX(CASE WHEN AccessType = 0 AND IsManualEntry = 1 THEN 1 ELSE 0 END) AS ExitTimeManual
		FROM Data_AccessEvents
		WHERE SystemID = @SystemID
			AND BpID = @BpID
			AND AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay
			AND AccessResult = 1
		GROUP BY
			SystemID, 
			BpID, 
			OwnerID, 
			AccessAreaID
	) AS d_ae 
	INNER JOIN Master_Employees AS m_e 
		ON d_ae.SystemID = m_e.SystemID 
			AND d_ae.BpID = m_e.BpID 
			AND d_ae.OwnerID = m_e.EmployeeID
	INNER JOIN Master_AccessAreas AS m_aa
		ON d_ae.SystemID = m_aa.SystemID
			AND d_ae.BpID = m_aa.BpID 
			AND d_ae.AccessAreaID = m_aa.AccessAreaID
WHERE NOT EXISTS
	(
		SELECT 1 
		FROM Data_PresenceAccessEvents AS d_pae
		WHERE d_pae.SystemID = @SystemID
			AND d_pae.BpID = @BpID
			AND d_pae.CompanyID = m_e.CompanyID
			AND d_pae.TradeID = m_e.TradeID
			AND d_pae.PresenceDay = CAST(@PresenceDay AS datetime)
			AND d_pae.EmployeeID = d_ae.OwnerID
			AND d_pae.AccessAt = d_ae.AccessAt
	)
GROUP BY
	d_ae.SystemID, 
	d_ae.BpID, 
	m_e.CompanyID, 
	m_e.TradeID,
	d_ae.OwnerID,
	ISNULL(d_ae.AccessAt, CAST(@PresenceDay AS datetime)),
	(CASE WHEN DATEDIFF(s, CAST(d_ae.ExitAt AS datetime), CAST(@PresenceDay AS datetime)) = 0 THEN @EndOfDay ELSE d_ae.ExitAt END),
	d_ae.AccessAreaID,
	(CASE WHEN d_ae.AccessAt IS NULL THEN 1 ELSE d_ae.AccessTimeManual END),
	(CASE WHEN DATEDIFF(s, CAST(d_ae.ExitAt AS datetime), CAST(@PresenceDay AS datetime)) = 0 THEN 1 ELSE d_ae.ExitTimeManual END)
	;

-- Ermittlung der relevanten Zeitfenster
SET DATEFIRST 1;

UPDATE d_pae
SET d_pae.TimeSlotID = ISNULL(m_ts.TimeSlotID, 0)
FROM Data_PresenceAccessEvents AS d_pae 
	INNER JOIN Master_EmployeeAccessAreas AS m_eaa 
		ON d_pae.SystemID = m_eaa.SystemID 
			AND d_pae.BpID = m_eaa.BpID 
			AND d_pae.EmployeeID = m_eaa.EmployeeID 
			AND d_pae.AccessAreaID = m_eaa.AccessAreaID 
	INNER JOIN Master_TimeSlots AS m_ts 
		ON m_eaa.SystemID = m_ts.SystemID 
			AND m_eaa.BpID = m_ts.BpID 
			AND m_eaa.TimeSlotGroupID = m_ts.TimeSlotGroupID
WHERE d_pae.SystemID = @SystemID
	AND d_pae.BpID = @BpID
	AND d_pae.PresenceDay = @PresenceDay
	AND d_pae.AccessAt BETWEEN m_ts.ValidFrom AND m_ts.ValidUntil
	AND d_pae.AccessAt BETWEEN (CAST(@PresenceDay AS datetime) + CAST(m_ts.TimeFrom AS datetime)) AND (CAST(@PresenceDay AS datetime) + CAST(m_ts.TimeUntil AS datetime))
	AND SUBSTRING(m_ts.ValidDays, DATEPART(dw, d_pae.AccessAt), 1) = '1';

-- Verdichtung pro Firma und Gewerk, alle Varianten
INSERT INTO Data_PresenceCompany
(
	SystemID,
	BpID,
	CompanyID,
	TradeID,
	PresenceDay,
	PresenceSeconds
)
SELECT        
	d_pae.SystemID, 
	d_pae.BpID, 
	d_pae.CompanyID, 
	d_pae.TradeID,
	d_pae.PresenceDay,
	SUM(d_pae.PresenceSeconds)
FROM Data_PresenceAccessEvents AS d_pae
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
	d_pae.PresenceDay;

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
	1,
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
	d_pae.EmployeeID;

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

IF (@MWCheck = 1)
BEGIN
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
	WHERE d_pe.PresenceDay BETWEEN @BeginOfMonth AND @EndOfMonth
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
	WHERE  d_emw.SystemID = @SystemID 
		AND d_emw.BpID = @BpID
		and d_emw.MWMonth = @BeginOfMonth
END