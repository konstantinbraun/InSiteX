CREATE PROCEDURE [dbo].[GetViewState]
	@VsId uniqueidentifier 
AS

BEGIN
	SELECT VsId, VsData, VsTimeStamp, VsSession 
	FROM ViewStateData (NOLOCK)
	WHERE VsId = @VsId
END
