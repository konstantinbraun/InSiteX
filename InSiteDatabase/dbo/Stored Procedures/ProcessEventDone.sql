CREATE PROCEDURE [dbo].[ProcessEventDone]
	@SystemID int,
	@DialogID int,
	@ActionID int,
	@RefID int,
	@UserIDExecutive int,
	@DoneFrom nvarchar(50),
	@StatusID int
AS

-- Set process status to done 
UPDATE Data_ProcessEvents 
SET DoneFrom = @DoneFrom, 
	DoneOn = SYSDATETIME(),
	StatusID = @StatusID 
WHERE SystemID = @SystemID 
	AND TypeID = 1 
	AND DialogID = @DialogID 
	AND ActionID = @ActionID 
	AND RefID = @RefID
	AND DoneOn IS NULL; 

-- Delete message attachments belonging to process
DELETE m 
FROM System_MailAttachment m
	INNER JOIN System_Mailbox mb
		ON m.SystemID = mb.SystemID 
			AND m.MailID = mb.Id
	INNER JOIN Data_ProcessEvents p 
		ON mb.SystemID = p.SystemID 
			AND mb.JobId = p.ProcessEventID 
WHERE p.SystemID = @SystemID 
	-- AND p.UserIDExecutive <> @UserIDExecutive 
	AND p.TypeID = 1 
	AND p.DialogID = @DialogID 
	AND p.ActionID = @ActionID 
	AND p.RefID = @RefID; 

-- Delete Documents with no attachments
DELETE System_Documents
WHERE SystemID = @SystemID
	AND NOT EXISTS 
	(
		SELECT 1
		FROM System_MailAttachment a
		WHERE a.SystemID = System_Documents.SystemID
			AND a.DocumentID = System_Documents.Id
	)

-- Delete user messages belonging to process
DELETE m 
FROM System_Mailbox m 
	INNER JOIN Data_ProcessEvents p 
	ON m.SystemID = p.SystemID 
		AND m.JobId = p.ProcessEventID 
WHERE p.SystemID = @SystemID 
	-- AND p.UserIDExecutive <> @UserIDExecutive 
	AND p.TypeID = 1 
	AND p.DialogID = @DialogID 
	AND p.ActionID = @ActionID 
	AND p.RefID = @RefID; 

