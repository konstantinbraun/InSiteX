-- Bestehende Verdichtungsdaten löschen
DELETE FROM Data_PresenceAccessEvents
;

DELETE FROM Data_AccessEvents
WHERE IsManualEntry = 1
;

UPDATE Data_AccessEvents
SET AccessEventLinkedID = NULL
;
