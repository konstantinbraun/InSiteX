CREATE FUNCTION [dbo].[GetMWStatusCode]
(
	@StatusID int
)

RETURNS nvarchar(15)

AS

BEGIN
	DECLARE @Ret nvarchar(15);

	IF (@StatusID = 0)
		SET @Ret = 'Initialisiert'
	ELSE IF (@StatusID = 1)	
		SET @Ret = 'Offen'
	ELSE IF (@StatusID = 2)	
		SET @Ret = 'OK'
	ELSE IF (@StatusID = 3)	
		SET @Ret = 'Fehlerhaft'
	ELSE IF (@StatusID = 4)	
		SET @Ret = 'Zu niedrig'
	ELSE IF (@StatusID = 5)	
		SET @Ret = 'Falsch'
	ELSE 
		SET @Ret = 'Unbekannt'
	;

	RETURN @Ret;
END
