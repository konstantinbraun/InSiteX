CREATE FUNCTION [dbo].[IsOnline]
(
	@SystemID int,
	@UserID int
)
RETURNS bit

AS

BEGIN
	DECLARE @IsOnline bit = 0;
	DECLARE @SessionCount int = 0;

	SELECT @SessionCount = COUNT(SessionID)
	FROM System_SessionLog
	WHERE UserID = @UserID
		AND (SessionState = 10 OR SessionState = 20)
	
	IF (@SessionCount > 0)
		SET @IsOnline = 1

	RETURN @IsOnline
END