CREATE PROCEDURE [dbo].[GetEmployeePassStatus]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int
)
AS

DECLARE @Count int = 0

SELECT @Count = COUNT(PassID)
FROM Master_Passes
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND EmployeeID = @EmployeeID

IF (@Count = 0)
	-- Kein Pass vorhanden
	BEGIN 
		SELECT 1
		RETURN 1
	END
ELSE
	SELECT @Count = COUNT(PassID)
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND PrintedOn IS NOT NULL
		AND ActivatedOn IS NULL
		AND DeactivatedOn IS NULL
		AND LockedOn IS NULL

IF (@Count > 0)
	-- Pass gedruckt und nicht aktiviert
	BEGIN 
		SELECT 2
		RETURN 2
	END
ELSE
	SELECT @Count = COUNT(PassID)
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND PrintedOn IS NOT NULL
		AND ActivatedOn IS NOT NULL
		AND DeactivatedOn IS NULL
		AND LockedOn IS NULL

IF (@Count > 0)
	-- Pass gedruckt und aktiviert
	BEGIN 
		SELECT 3
		RETURN 3
	END
ELSE
	SELECT @Count = COUNT(PassID)
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND DeactivatedOn IS NOT NULL
		AND LockedOn IS NULL

IF (@Count > 0)
	-- Pass deaktiviert
	BEGIN 
		SELECT 4
		RETURN 4
	END
ELSE
	SELECT @Count = COUNT(PassID)
	FROM Master_Passes
	WHERE SystemID = @SystemID
		AND BpID = @BpID
		AND EmployeeID = @EmployeeID
		AND LockedOn IS NOT NULL

IF (@Count > 0)
	-- Pass gesperrt
	BEGIN 
		SELECT 5
		RETURN 5
	END

SELECT 0
RETURN 0
	