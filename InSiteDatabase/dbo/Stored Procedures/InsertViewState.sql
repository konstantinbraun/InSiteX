CREATE PROCEDURE [dbo].[InsertViewState]
	@VsId uniqueidentifier,
	@VsData varbinary(max),
	@VsTimeStamp datetime,
	@VsSession nvarchar(200)
AS

BEGIN
	INSERT INTO ViewStateData 
	VALUES
	(
		@VsId, 
		@VsData, 
		@VsTimeStamp,
		@VsSession
	)
END

RETURN 0
