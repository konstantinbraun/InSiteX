CREATE PROCEDURE [dbo].[DeleteViewState]
	@VsSession nvarchar(200) 
AS

BEGIN
	DELETE 
	FROM ViewStateData
	WHERE VsSession = @VsSession
END

RETURN @@ROWCOUNT