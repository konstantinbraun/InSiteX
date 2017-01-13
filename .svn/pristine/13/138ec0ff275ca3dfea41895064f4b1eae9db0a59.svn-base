CREATE PROCEDURE [dbo].[AppendLog]
	@SystemID int,
	 @BpID int, 
	 @log_date datetime, 
	 @thread nvarchar(255), 
	 @log_level nvarchar(50), 
	 @logger nvarchar(255), 
	 @message nvarchar(4000), 
	 @exception nvarchar(2000), 
	 @SessionID nvarchar(200), 
	 @IsDialog bit, 
	 @UserID int, 
	 @ActionID int, 
	 @RefID nvarchar(50)
AS
	IF (@IsDialog = 1)
		BEGIN
			INSERT INTO Data_Logging 
			(
				SystemID, 
				BpID, 
				[Date], 
				Thread, 
				[Level], 
				Logger, 
				[Message], 
				Exception, 
				SessionID, 
				DialogID, 
				UserID, 
				ActionID, 
				RefID
			) 
			SELECT 
				@SystemID, 
				@BpID, 
				@log_date, 
				@thread, 
				@log_level, 
				@logger, 
				@message, 
				@exception, 
				@SessionID, 
				d.DialogID, 
				@UserID, 
				@ActionID, 
				@RefID 
			FROM System_Dialogs d 
			WHERE d.SystemID = @SystemID 
				AND d.PageName = @logger
		END
	ELSE
		BEGIN
			INSERT INTO Data_Logging 
			(
				SystemID, 
				BpID, 
				[Date], 
				Thread, 
				[Level], 
				Logger, 
				[Message], 
				Exception, 
				SessionID, 
				DialogID, 
				UserID, 
				ActionID, 
				RefID
			) 
			VALUES
			( 
				@SystemID, 
				@BpID, 
				@log_date, 
				@thread, 
				@log_level, 
				@logger, 
				@message, 
				@exception, 
				@SessionID, 
				0, 
				@UserID, 
				@ActionID, 
				@RefID 
			)
		END
RETURN 0
