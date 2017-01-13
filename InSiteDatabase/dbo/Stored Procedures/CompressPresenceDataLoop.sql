CREATE PROCEDURE [dbo].[CompressPresenceDataLoop]
(
	@SystemID int,
	@BpID int,
	@PresenceDayFrom date,
	@PresenceDayUntil date,
	@CompressType int
)
AS

DECLARE @PresenceDay date = @PresenceDayFrom

WHILE (DATEDIFF(DAY, @PresenceDay, @PresenceDayUntil) > 0)
	BEGIN
		EXEC dbo.CompressPresenceData @SystemID, @BpID, @PresenceDay, @CompressType
		SET @PresenceDay = CAST(DATEADD(DAY, 1, @PresenceDay) AS date)
	END

