CREATE PROCEDURE [dbo].[SaveControlStateToDB]
	@SystemID int,
	@UserID int,
	@UserKey nvarchar(200),
	@UserSettings nvarchar(MAX)
AS

	DECLARE @Count int

	SELECT @Count = COUNT(UserKey)
	FROM Data_UserControlStates
	WHERE SystemID = @SystemID
		AND UserID = @UserID
		AND UserKey = @UserKey

	IF (@Count > 0)
		BEGIN
			UPDATE Data_UserControlStates
			SET UserSettings = @UserSettings,
				LastUpdate = SYSDATETIME()
			WHERE SystemID = @SystemID
				AND UserID = @UserID
				AND UserKey = @UserKey
		END

	ELSE
		BEGIN
			INSERT INTO Data_UserControlStates
			(
				SystemID,
				UserID,
				UserKey,
				UserSettings,
				LastUpdate
			)
			VALUES
			(
				@SystemID,
				@UserID,
				@UserKey,
				@UserSettings,
				SYSDATETIME()
			)
		END
