CREATE PROCEDURE [dbo].[AccessEventConsistency]
(
	@SystemID int,
	@BpID int,
	@IgnoreLink bit = 0,
	@AccessAreaID int = 0,
	@LookBackDays int = 2
)
AS

BEGIN

	-- Alle mehrfach identischen Zutritssereignisse löschen
	UPDATE Data_AccessEvents
	SET AccessResult = 0,
		Remark = 'Duplicate',
		EditOn = SYSDATETIME(),
		EditFrom = 'AccessEventConsistency' 
	FROM Data_AccessEvents dae3
		INNER JOIN 
		(
			SELECT 
				dae1.SystemID,
				dae1.BpID,
				MIN(dae1.AccessEventID) AccessEventID,
				dae1.AccessOn,
				dae1.AccessType,
				dae1.AccessAreaID,
				dae1.InternalID
			FROM Data_AccessEvents dae1
			WHERE dae1.SystemID = @SystemID
				AND dae1.BpID = @BpID
				AND dae1.AccessResult = 1
				AND dae1.AccessOn >= DATEADD(DAY, @LookBackDays * (-1), SYSDATETIME())
				AND EXISTS
				(
					SELECT 1
					FROM Data_AccessEvents dae2
					WHERE dae2.SystemID = dae1.SystemID
						AND dae2.BpID = dae1.BpID
						AND dae2.AccessAreaID = dae1.AccessAreaID
						AND dae2.InternalID = dae1.InternalID
						AND dae2.AccessType = dae1.AccessType
						AND dae2.AccessOn = dae1.AccessOn
						AND dae2.AccessEventID != dae1.AccessEventID
				)
			GROUP BY
				dae1.SystemID,
				dae1.BpID,
				dae1.AccessOn,
				dae1.AccessType,
				dae1.AccessAreaID,
				dae1.InternalID
		) dae0
			ON dae3.SystemID = dae0.SystemID
				AND dae3.BpID = dae0.BpID
				AND dae3.AccessOn = dae0.AccessOn
				AND dae3.AccessType = dae0.AccessType
				AND dae3.AccessAreaID = dae0.AccessAreaID
				AND dae3.InternalID = dae0.InternalID
				AND dae3.AccessEventID != dae0.AccessEventID
	WHERE dae0.SystemID = @SystemID
		AND dae0.BpID = @BpID
		AND dae0.AccessAreaID = (CASE WHEN @AccessAreaID = 0 THEN dae0.AccessAreaID ELSE @AccessAreaID END)
		AND dae0.AccessOn >= DATEADD(DAY, @LookBackDays * (-1), SYSDATETIME())
	;

	DECLARE @AccessAreaID1 int, @InternalID1 nvarchar(50), @AccessOn1 datetime, @AccessType1 int, @AccessEventID1 int, @OwnerID1 int, @PassType1 int;
	DECLARE @AccessAreaID2 int, @InternalID2 nvarchar(50), @AccessOn2 datetime, @AccessType2 int, @AccessEventID2 int, @OwnerID2 int, @PassType2 int;

	-- Alle gültigen Zutrittsereignisse, die schon korrigiert wurden
	DECLARE AccessEvents CURSOR READ_ONLY FOR 
	SELECT
		d_ae.AccessAreaID,
		LOWER(d_ae.InternalID) InternalID,
		d_ae.AccessOn,
		d_ae.AccessType,
		d_ae.AccessEventID,
		d_ae.OwnerID,
		d_ae.PassType
	FROM Data_AccessEvents d_ae
	WHERE d_ae.SystemID = @SystemID
		AND d_ae.BpID = @BpID
		AND d_ae.AccessAreaID = (CASE WHEN @AccessAreaID = 0 THEN d_ae.AccessAreaID ELSE @AccessAreaID END)
		AND d_ae.AccessResult = 1
		AND (NOT d_ae.AccessEventLinkedID IS NULL OR @IgnoreLink = 1)
	ORDER BY d_ae.AccessAreaID, d_ae.InternalID, d_ae.AccessOn, d_ae.AccessType DESC
	;

	OPEN AccessEvents;

	-- Ersten Satz lesen
	FETCH NEXT FROM AccessEvents
	INTO @AccessAreaID1, @InternalID1, @AccessOn1, @AccessType1, @AccessEventID1, @OwnerID1, @PassType1;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Zweiten Satz lesen
		FETCH NEXT FROM AccessEvents
		INTO @AccessAreaID2, @InternalID2, @AccessOn2, @AccessType2, @AccessEventID2, @OwnerID2, @PassType2;
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
			-- Wenn erster und zweiter Satz identisch bzgl. Zutrittsbereich, AusweisID und Zutrittsrichtung
			IF (@AccessAreaID1 = @AccessAreaID2 AND @InternalID1 = @InternalID2	AND @AccessType1 = @AccessType2)
			BEGIN
				-- Ja -> Zutrittsereignis ungültig machen
				UPDATE Data_AccessEvents
				SET AccessResult = 0,
					Remark = 'Two successive events with same direction',
					EditOn = SYSDATETIME(),
					EditFrom = 'AccessEventConsistency' 
				WHERE AccessEventID = @AccessEventID2
				;

				-- Nächsten 2. Satz lesen
				FETCH NEXT FROM AccessEvents
				INTO @AccessAreaID2, @InternalID2, @AccessOn2, @AccessType2, @AccessEventID2, @OwnerID2, @PassType2;
			END

			ELSE
			BEGIN
				-- Nein -> Wenn erster und zweiter Satz mit ungleicher AusweisID oder mit gleicher AusweisID, aber dann mit ungleichem Zutrittsbereich 
				IF (@InternalID1 <> @InternalID2 OR (@InternalID1 = @InternalID2 AND @AccessAreaID1 <> @AccessAreaID2))
				BEGIN
					-- Ja -> Wenn erster Satz Kommt-Ereignis und Buchung liegt 18 Stunden zurück
					IF (@AccessType1 = 1 AND DATEDIFF(HOUR, @AccessOn1, SYSDATETIME()) > 18)
					BEGIN
						-- Ja -> Geht-Ereignis 18 Stunden nach Kommt-Ereignis erzeugen
						DECLARE @AccessOnNew datetime;
						SET @AccessOnNew = DATEADD(HOUR, 18, @AccessOn1)

						INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, AccessType, AccessResult, 
							MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
						VALUES (@SystemID, 0, @BpID, @AccessAreaID1, 0, 0, @OwnerID1, @InternalID1, 0, @AccessOnNew, 0, 1, 
							'', 0, 1, 1, 'Missing exit event', SYSDATETIME(), 'AccessEventConsistency', SYSDATETIME(), 'AccessEventConsistency', @PassType1)

						-- Wenn Geht-Ereignis am nächsten Tag
						IF (DAY(@AccessOn1) < DAY(@AccessOnNew))
						BEGIN
							-- Ja -> Nachtabgrenzung erzeugen
							-- Kommt-Ereignis am Folgetag um 0:00 Uhr
							SET @AccessOnNew = DATETIMEFROMPARTS(YEAR(@AccessOnNew), MONTH(@AccessOnNew), DAY(@AccessOnNew), 0, 0, 0, 0);
							INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, AccessType, AccessResult, 
								MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
							VALUES (@SystemID, 0, @BpID, @AccessAreaID1, 0, 0, @OwnerID1, @InternalID1, 0, @AccessOnNew, 1, 1, 
								'', 0, 1, 1, 'Midnight demarcation enter', SYSDATETIME(), 'AccessEventConsistency', SYSDATETIME(), 'AccessEventConsistency', @PassType1)

							-- Geht-Ereignis am selben Tag um 23:59
							SET @AccessOnNew = DATETIMEFROMPARTS(YEAR(@AccessOn1), MONTH(@AccessOn1), DAY(@AccessOn1), 23, 59, 59, 0);
							INSERT INTO Data_AccessEvents (SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, AccessType, AccessResult, 
								MessageShown, DenialReason, IsManualEntry, CountIt, Remark, CreatedOn, CreatedFrom, EditOn, EditFrom, PassType)
							VALUES (@SystemID, 0, @BpID, @AccessAreaID1, 0, 0, @OwnerID1, @InternalID1, 0, @AccessOnNew, 0, 1, 
								'', 0, 1, 1, 'Midnight demarcation exit', SYSDATETIME(), 'AccessEventConsistency', SYSDATETIME(), 'AccessEventConsistency', @PassType1)
						END
					END
				END

				-- Zweiten Satz in ersten Satz kopieren
				SET @AccessAreaID1 = @AccessAreaID2;
				SET	@InternalID1 = @InternalID2;
				SET @AccessOn1 = @AccessOn2;
				SET @AccessType1 = @AccessType2;
				SET @AccessEventID1 = @AccessEventID2;
				SET @OwnerID1 = @OwnerID2;
				SET @PassType1 = @PassType2;

				-- Innere Schleife beenden
				BREAK;
			END

		END
	END

	CLOSE AccessEvents;
	DEALLOCATE AccessEvents;

	-- LinkID auf NULL wenn 0
	UPDATE Data_AccessEvents
	SET AccessEventLinkedID = NULL 
	WHERE SystemID = @SystemID 
		AND BpID = @BpID
		AND AccessAreaID = (CASE WHEN @AccessAreaID = 0 THEN AccessAreaID ELSE @AccessAreaID END)
		AND AccessResult = 1
		AND AccessEventLinkedID = 0
	;

END