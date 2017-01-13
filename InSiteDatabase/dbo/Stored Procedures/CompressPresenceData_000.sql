CREATE PROCEDURE [dbo].[CompressPresenceData000]
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
DECLARE @Month int = DATEPART(MONTH, @PresenceDay);
DECLARE @Year int = DATEPART(YYYY, @PresenceDay);
IF (@Month = 12)
BEGIN
	SET @Month = 1;
	SET @Year += 1;
END
DECLARE @EndOfMonth date = DATEFROMPARTS(@Year, @Month, 1);
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

DECLARE @SecondRow bit = 0, @Shift int = 0;
DECLARE @AccessAreaID int, @OwnerID int, @InternalID nvarchar(50), @AccessOn datetime, @AccessType int, @PresentTimeHours int, @PresentTimeMinutes int, @CountIt bit, @IsManualEntry bit, @PassType int, @AccessEventID int, @IsOnlineAccessEvent bit;
DECLARE @AccessAreaID1 int, @OwnerID1 int, @InternalID1 nvarchar(50), @AccessOn1 datetime, @AccessType1 int, @PresentTimeHours1 int, @PresentTimeMinutes1 int, @CountIt1 bit, @IsManualEntry1 bit, @PassType1 int, @AccessEventID1 int, @IsOnlineAccessEvent1 bit;

-- Bestehende Verdichtungsdaten löschen
DELETE FROM Data_PresenceAccessEvents
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND PresenceDay = @PresenceDay
;

-- Bestehende Korrekturdaten löschen
--DELETE FROM Data_AccessEvents
--WHERE SystemID = @SystemID
--	AND BpID = @BpID
--	AND AccessOn BETWEEN @PresenceDay AND @EndOfDay
--	AND AccessResult = 1 
--	AND IsManualEntry = 1 
--	AND Remark = 'Added by System'
--;

-- Ergänzung der inkonsistenten Zutrittsereignisse
DECLARE AccessEvents CURSOR FOR
SELECT
	d_ae.AccessAreaID,
	d_ae.OwnerID,
	d_ae.InternalID,
	d_ae.AccessOn,
	d_ae.AccessType,
	m_aa.PresentTimeHours,
	m_aa.PresentTimeMinutes,
	d_ae.CountIt,
	d_ae.IsManualEntry,
	d_ae.PassType,
	d_ae.AccessEventID,
	d_ae.IsOnlineAccessEvent
FROM Data_AccessEvents d_ae
	INNER JOIN Master_AccessAreas m_aa
		ON d_ae.SystemID = m_aa.SystemID
			AND d_ae.BpID = m_aa.BpID
			AND d_ae.AccessAreaID = m_aa.AccessAreaID
WHERE d_ae.SystemID = @SystemID
	AND d_ae.BpID = @BpID
	AND d_ae.AccessOn BETWEEN CAST(@PresenceDay AS datetime) AND @EndOfDay
	AND d_ae.AccessResult = 1
	-- AND d_ae.PassType = 1
	AND m_aa.AccessTimeRelevant = 1
	AND m_aa.CompleteAccessTimes = 1
ORDER BY d_ae.InternalID, d_ae.AccessAreaID, d_ae.AccessOn, d_ae.AccessType
;

OPEN AccessEvents

PRINT N'Verdichtung für: ' + CONVERT(nvarchar, CAST(@PresenceDay AS datetime));

PRINT N'Ersten Satz lesen';
FETCH NEXT FROM AccessEvents
INTO @AccessAreaID, @OwnerID, @InternalID, @AccessOn, @AccessType, @PresentTimeHours, @PresentTimeMinutes, @CountIt, @IsManualEntry, @PassType, @AccessEventID, @IsOnlineAccessEvent
SELECT @AccessAreaID, @OwnerID, @InternalID, @AccessOn, @AccessType, @PresentTimeHours, @PresentTimeMinutes, @CountIt, @IsManualEntry, @PassType, @AccessEventID, @IsOnlineAccessEvent

DECLARE @AccessOnNew datetime = CAST(@PresenceDay AS datetime)

WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@SecondRow = 0)
			BEGIN
				PRINT N'Zweiten Satz lesen';
				FETCH NEXT FROM AccessEvents
				INTO @AccessAreaID1, @OwnerID1, @InternalID1, @AccessOn1, @AccessType1, @PresentTimeHours1, @PresentTimeMinutes1, @CountIt1, @IsManualEntry1, @PassType1, @AccessEventID1, @IsOnlineAccessEvent1
				SELECT @AccessAreaID1, @OwnerID1, @InternalID1, @AccessOn1, @AccessType1, @PresentTimeHours1, @PresentTimeMinutes1, @CountIt1, @IsManualEntry1, @PassType1, @AccessEventID1, @IsOnlineAccessEvent1

				IF (@@FETCH_STATUS = 0)
					SET @SecondRow = 1
				ELSE
					SET @SecondRow = 0
			END
		IF (@SecondRow = 1)
			BEGIN
				PRINT N'Es gibt einen zweiten Satz'
				IF (@InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1 AND @AccessType = 1 AND @AccessType1 = 0)
					BEGIN
						IF (@PassType = 1)
							BEGIN
								PRINT N'Kommt und Geht Buchungen gehören zusammen, Anwesenheitssatz erzeugen'
								SET @AccessOnNew = CAST(@PresenceDay AS datetime)
						
								INSERT INTO Data_PresenceAccessEvents (SystemID, BpID, CompanyID, TradeID, PresenceDay, EmployeeID, AccessAt, ExitAt, PresenceSeconds, 
									AccessAreaID, TimeSlotID, AccessTimeManual, ExitTimeManual, CountAs)
								SELECT SystemID, BpID, CompanyID, TradeID, @PresenceDay, EmployeeID, @AccessOn, @AccessOn1, DATEDIFF(s, @AccessOn, @AccessOn1),
									@AccessAreaID, 0, @IsManualEntry, @IsManualEntry1, CASE WHEN @CountIt = 0 OR @CountIt1 = 0 THEN 0 ELSE 1 END 
								FROM Master_Employees
								WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @OwnerID
							END

						PRINT N'Nächsten Satz lesen';
						FETCH NEXT FROM AccessEvents
						INTO @AccessAreaID, @OwnerID, @InternalID, @AccessOn, @AccessType, @PresentTimeHours, @PresentTimeMinutes, @CountIt, @IsManualEntry, @PassType, @AccessEventID, @IsOnlineAccessEvent
						SELECT @AccessAreaID, @OwnerID, @InternalID, @AccessOn, @AccessType, @PresentTimeHours, @PresentTimeMinutes, @CountIt, @IsManualEntry, @PassType, @AccessEventID, @IsOnlineAccessEvent

						IF (@@FETCH_STATUS = 0)
							SET @SecondRow = 0
					END

				ELSE
					BEGIN
						IF (@AccessType = 1)
							BEGIN
								PRINT N'(Erste Buchung ist Kommt Buchung und Buchungen gehören nicht zusammen) oder (Buchungen gehören zusammen und zwei Kommt Buchungen hintereinander)';
								SET @AccessOnNew = @EndOfDay

								IF (@IsManualEntry = 1 AND @CountIt = 0)
									BEGIN
										PRINT N'Geht Buchung für manuelle Tagesabgrenzung fehlt, Geht Buchung auf 0:00:01 Uhr setzen';
										SET @AccessOnNew = CAST(DATEADD(SECOND, 1, CAST(@PresenceDay AS datetime)) AS datetime)
									END

								ELSE IF (DATEDIFF(MINUTE, @AccessOn, @AccessOnNew) > (@PresentTimeHours * 60) + @PresentTimeMinutes)
									BEGIN
										PRINT N'Maximale Anwesenheitszeit überschritten, zu erzeugende Geht Buchung auf maximale Anwesenheitszeit begrenzen';
										SET @AccessOnNew = DATEADD(MINUTE, (@PresentTimeHours * 60) + @PresentTimeMinutes, @AccessOn)
										SET @Shift = 1
									END

								ELSE IF NOT (@AccessType = 1 AND @AccessType1 = 1)
									BEGIN
										PRINT N'Maximale Anwesenheitszeit noch nicht erreicht, zu erzeugende Kommt Buchung auf nächsten Tag 0:00:00 setzen';
										SET @AccessOnNew = DATEADD(DAY, 1, CAST(@PresenceDay AS datetime))

										PRINT N'Kommt-Buchung nicht nach nächster Kommt-Buchung';
										IF (DATEDIFF(SECOND, @AccessOnNew, @AccessOn1) > 0 AND @AccessType1 = 1 AND @InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1)
											BEGIN
												SET @AccessOnNew = DATEADD(SECOND, (-1), @AccessOn1)
											END

										PRINT N'Kommt Buchung erzeugen und Zählung für Anwesenheitstage für diesen Satz auf 0 setzen';
										INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
											AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
										VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 1, 1, 
											'', 0, 1, 0, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System', @PassType)

										SET @AccessOnNew = @EndOfDay
									END

								IF (DATEDIFF(SECOND, @AccessOnNew, @AccessOn1) < 0 AND @AccessType1 = 1 AND @InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1)
									BEGIN
										PRINT N'Geht-Buchung nicht nach nächster Kommt-Buchung';
										SET @AccessOnNew = DATEADD(SECOND, (-1), @AccessOn1)
										SET @Shift = 0
									END
		
								IF (@AccessType = 1 AND @AccessType1 = 1 AND @InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1)
									BEGIN
										PRINT N'Zwei zusammengehörige Kommt Buchungen hintereinander -> Offline Buchung auf ungültig setzen';
										DECLARE @AccessEventID2 int = @AccessEventID;
										SET @Shift = 0;

										IF (@IsOnlineAccessEvent = 1)
											BEGIN
												SET @AccessEventID2 = @AccessEventID1;
												SET @Shift = 2;
											END

										UPDATE Data_AccessEvents
										SET AccessResult = 0 
										WHERE SystemID = @SystemID
											AND BpID = @BpID
											AND AccessEventID = @AccessEventID2

									END
								
								ELSE
									BEGIN
										PRINT N'Geht Buchung erzeugen';
										INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
											AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
										VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 0, 1, 
											'', 0, 1, 1, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System', @PassType)

										IF (@PassType = 1)
											BEGIN
												PRINT N'Anwesenheitssatz erzeugen';
												INSERT INTO Data_PresenceAccessEvents (SystemID, BpID, CompanyID, TradeID, PresenceDay, EmployeeID, AccessAt, ExitAt, PresenceSeconds, 
													AccessAreaID, TimeSlotID, AccessTimeManual, ExitTimeManual, CountAs)
												SELECT SystemID, BpID, CompanyID, TradeID, @PresenceDay, EmployeeID, @AccessOn, @AccessOnNew, DATEDIFF(s, @AccessOn, @AccessOnNew),
													@AccessAreaID, 0, @IsManualEntry, 1, @CountIt 
												FROM Master_Employees
												WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @OwnerID
											END
									END
							END

						ELSE
							BEGIN
								PRINT N'(Erste Buchung ist Geht Buchung und Buchungen gehören nicht zusammen) oder (Buchungen gehören zusammen und zwei Geht Buchungen hintereinander)';

								SET @AccessOnNew = CAST(@PresenceDay AS datetime)

								PRINT N'Maximale Anwesenheitszeit beachten';
								IF (DATEDIFF(MINUTE, @AccessOnNew, @AccessOn) > (@PresentTimeHours * 60) + @PresentTimeMinutes)
									SET @AccessOnNew = DATEADD(MINUTE, ((@PresentTimeHours * 60) + @PresentTimeMinutes) * (-1), @AccessOn)

								PRINT N'Kommt-Buchung nicht vor vorheriger Geht-Buchung';
								IF (DATEDIFF(SECOND, @AccessOnNew, @AccessOn1) > 0 AND @AccessType1 = 0 AND @InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1)
									BEGIN
										SET @AccessOnNew = DATEADD(SECOND, (-1), @AccessOn1)
									END
		
								IF (@AccessType = 1 AND @AccessType1 = 1 AND @InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1)
									BEGIN
										PRINT N'Zwei zusammengehörige Geht Buchungen hintereinander -> Offline Buchung auf ungültig setzen';
										SET @AccessEventID2 = @AccessEventID;
										SET @Shift = 0;

										IF (@IsOnlineAccessEvent = 1)
											BEGIN
												SET @AccessEventID2 = @AccessEventID1;
												SET @Shift = 2;
											END

										UPDATE Data_AccessEvents
										SET AccessResult = 0 
										WHERE SystemID = @SystemID
											AND BpID = @BpID
											AND AccessEventID = @AccessEventID2

									END
								
								ELSE
									BEGIN
										PRINT N'Kommt Buchung erzeugen';
										INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
											AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
										VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 1, 1, 
											'', 0, 1, 1, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System', @PassType)

										IF (@PassType = 1)
											BEGIN
												PRINT N'Anwesenheitssatz erzeugen';
												INSERT INTO Data_PresenceAccessEvents (SystemID, BpID, CompanyID, TradeID, PresenceDay, EmployeeID, AccessAt, ExitAt, PresenceSeconds, 
													AccessAreaID, TimeSlotID, AccessTimeManual, ExitTimeManual, CountAs)
												SELECT SystemID, BpID, CompanyID, TradeID, @PresenceDay, EmployeeID, @AccessOnNew, @AccessOn, DATEDIFF(s, @AccessOnNew, @AccessOn),
													@AccessAreaID, 0, 1, @IsManualEntry, @CountIt 
												FROM Master_Employees
												WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @OwnerID
											END
									END
							END

						IF (@Shift = 0 OR NOT (@InternalID = @InternalID1 AND @AccessAreaID = @AccessAreaID1))
							BEGIN
								PRINT N'Zweiter Satz wird erster Satz';
								SET @AccessAreaID = @AccessAreaID1
								SET @OwnerID = @OwnerID1
								SET @InternalID = @InternalID1
								SET @AccessOn = @AccessOn1
								SET @AccessType = @AccessType1
								SET @PresentTimeHours = @PresentTimeHours1
								SET @PresentTimeMinutes = @PresentTimeMinutes1
								SET @CountIt = @CountIt1
								SET @IsManualEntry = @IsManualEntry1
								SET @PassType = @PassType1
								SET @SecondRow = 0
							END
						ELSE
							IF NOT (@Shift = 2)
								BEGIN
									PRINT N'Eingefügter Geht Satz wird erster Satz';
									SET @AccessOn = @AccessOnNew
									SET @AccessType = 0
								END

						SET @Shift = 0
					END

			END

	END

IF (@SecondRow = 0 AND @OwnerID IS NOT NULL)
	BEGIN
		IF (@AccessType = 1)
			BEGIN
				PRINT N'Letzter Satz ist Kommt Buchung';
				SET @AccessOnNew = @EndOfDay

				IF (@IsManualEntry = 1 AND @CountIt = 0)
					BEGIN
						PRINT N'Geht Buchung für manuelle Tagesabgrenzung fehlt, Geht Buchung auf 0:00:01 Uhr setzen';
						SET @AccessOnNew = CAST(DATEADD(SECOND, 1, CAST(@PresenceDay AS datetime)) AS datetime)
					END

				ELSE IF (DATEDIFF(MINUTE, @AccessOn, @AccessOnNew) > (@PresentTimeHours * 60) + @PresentTimeMinutes)
					BEGIN
						PRINT N'Maximale Anwesenheitszeit überschritten, zu erzeugende Geht Buchung auf maximale Anwesenheitszeit begrenzen';
						SET @AccessOnNew = DATEADD(MINUTE, (@PresentTimeHours * 60) + @PresentTimeMinutes, @AccessOn)
					END

				ELSE
					BEGIN
						PRINT N'Maximale Anwesenheitszeit noch nicht erreicht, zu erzeugende Kommt Buchung auf nächsten Tag 0:00:00 setzen';
						SET @AccessOnNew = DATEADD(DAY, 1, CAST(@PresenceDay AS datetime))

						PRINT N'Kommt Buchung erzeugen und Zählung für Anwesenheitstage für diesen Satz auf 0 setzen';
						INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
							AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
						VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 1, 1, 
							'', 0, 1, 0, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System', @PassType)

						SET @AccessOnNew = @EndOfDay
					END
		
				PRINT N'Geht Buchung erzeugen'
				INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
					AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
				VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 0, 1, 
					'', 0, 1, 1, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System', @PassType)

				IF (@PassType = 1)
					BEGIN
						PRINT N'Anwesenheitssatz erzeugen';
						INSERT INTO Data_PresenceAccessEvents (SystemID, BpID, CompanyID, TradeID, PresenceDay, EmployeeID, AccessAt, ExitAt, PresenceSeconds, 
							AccessAreaID, TimeSlotID, AccessTimeManual, ExitTimeManual, CountAs)
						SELECT SystemID, BpID, CompanyID, TradeID, @PresenceDay, EmployeeID, @AccessOn, @AccessOnNew, DATEDIFF(s, @AccessOn, @AccessOnNew),
							@AccessAreaID, 0, @IsManualEntry, 1, @CountIt 
						FROM Master_Employees
						WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @OwnerID
					END

			END

		ELSE
			BEGIN
				PRINT N'Letzter Satz ist Geht Buchung';

				SET @AccessOnNew = CAST(@PresenceDay AS datetime)

				PRINT N'Maximale Anwesenheitszeit beachten';
				IF (DATEDIFF(MINUTE, @AccessOnNew, @AccessOn) > (@PresentTimeHours * 60) + @PresentTimeMinutes)
					SET @AccessOnNew = DATEADD(MINUTE, ((@PresentTimeHours * 60) + @PresentTimeMinutes) * (-1), @AccessOn)
		
				PRINT N'Kommt Buchung erzeugen';
				INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, 
					AccessType, AccessResult, MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
				VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @OwnerID, @InternalID, 0, @AccessOnNew, 1, 1, 
					'', 0, 1, 1, 'Added by System', SYSDATETIME(), 'System', SYSDATETIME(), 'System', @PassType)

				IF (@PassType = 1)
					BEGIN
						PRINT N'Anwesenheitssatz erzeugen';
						INSERT INTO Data_PresenceAccessEvents (SystemID, BpID, CompanyID, TradeID, PresenceDay, EmployeeID, AccessAt, ExitAt, PresenceSeconds, 
							AccessAreaID, TimeSlotID, AccessTimeManual, ExitTimeManual, CountAs)
						SELECT SystemID, BpID, CompanyID, TradeID, @PresenceDay, EmployeeID, @AccessOnNew, @AccessOn, DATEDIFF(s, @AccessOnNew, @AccessOn),
							@AccessAreaID, 0, 1, @IsManualEntry, @CountIt 
						FROM Master_Employees
						WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @OwnerID
					END
			END

	END

PRINT N'Cursor schliessen'
CLOSE AccessEvents
DEALLOCATE AccessEvents

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
	d_pae.PresenceDay;

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
