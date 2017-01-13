CREATE PROCEDURE [dbo].[ResetDateRange]
(
	@SystemID int,
	@BpID int,
	@DateFrom date,
	@DateUntil date
)

AS

DECLARE @EndOfDateUntil datetime = DATETIMEFROMPARTS(YEAR(@DateUntil), MONTH(@DateUntil), DAY(@DateUntil), 23, 59, 59, 0);

-- Automatische Verarbeitung sperren
UPDATE Master_AccessSystems
SET CompressStartTime = SYSDATETIME()
WHERE SystemID = @SystemID
	AND BpID = @BpID
;

-- Bestehende Verdichtungsdaten im Zeitraum löschen
DELETE FROM Data_PresenceAccessEvents
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND PresenceDay BETWEEN @DateFrom AND @DateUntil
;

-- Manuelle Korrekturbuchungen löschen
DELETE FROM Data_AccessEvents
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND AccessOn BETWEEN @DateFrom AND @EndOfDateUntil
	AND DATEDIFF(SECOND, AccessOn, CAST(AccessOn AS date)) <> 0
	AND DATEDIFF(SECOND, AccessOn, DATETIMEFROMPARTS(YEAR(AccessOn), MONTH(AccessOn), DAY(AccessOn), 23, 59, 59, 0)) <> 0
	AND AccessResult = 1
	AND IsManualEntry = 1
	AND IsOnlineAccessEvent = 0
	AND AddedBySystem = 1
;

-- Alle Buchungen im Zeitraum auf unbearbeitet setzen
UPDATE Data_AccessEvents
SET AccessEventLinkedID = NULL
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND AccessOn BETWEEN @DateFrom AND @EndOfDateUntil
	AND AccessResult = 1
;

-- Automatische Verarbeitung freigeben
UPDATE Master_AccessSystems
SET CompressStartTime = NULL,
	LastCompress = @DateFrom,
	LastAddition = @DateFrom
WHERE SystemID = @SystemID
	AND BpID = @BpID
;

