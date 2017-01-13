BEGIN TRANSACTION;

DELETE FROM Data_AccessEvents
WHERE BpID = 57
	AND AccessResult = 1 
	AND AccessOn > '2016-04-13 14:00:00'
	AND IsManualEntry = 1
	AND AddedBySystem = 1
;

UPDATE Data_AccessEvents
SET AccessEventLinkedID = NULL
WHERE BpID = 57
	AND AccessResult = 1 
	AND AccessOn > '2016-04-13 14:00:00'
	AND IsManualEntry = 0
	AND AddedBySystem = 0
;

SELECT * 
FROM Data_AccessEvents
WHERE BpID = 57
	AND AccessResult = 1 
	AND AccessOn > '2016-04-13 14:00:00'
ORDER BY AccessOn
;

ROLLBACK TRANSACTION;

COMMIT TRANSACTION;

