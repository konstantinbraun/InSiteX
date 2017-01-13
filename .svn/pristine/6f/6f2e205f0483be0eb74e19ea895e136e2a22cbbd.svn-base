CREATE PROCEDURE [dbo].[GetNextID]
(
	@SystemID int,
	@IDName nvarchar(50)
)
AS

	DECLARE @IDValue int = -1

	SELECT @IDValue = IDValue
	FROM System_KeyTable
	WHERE SystemID = @SystemID
		AND IDName = @IDName

	IF (@@ROWCOUNT > 0)
		BEGIN

			SET @IDValue = @IDValue + 1

			UPDATE System_KeyTable
			SET IDValue = @IDValue
			WHERE SystemID = @SystemID
			AND IDName = @IDName

		END

	SELECT @IDValue
