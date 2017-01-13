CREATE TABLE [dbo].[Data_Logging]
(
    [LoggingID] INT NOT NULL IDENTITY,
	[SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL, 
    [Date] DATETIME NOT NULL, 
    [Thread] NVARCHAR(255) NULL, 
    [Level] NVARCHAR(50) NULL, 
    [Logger] NVARCHAR(255) NULL, 
    [Message] NVARCHAR(4000) NULL, 
    [Exception] NVARCHAR(2000) NULL, 
    [SessionID] NVARCHAR(200) NULL, 
    [DialogID] INT NOT NULL DEFAULT 0, 
    [UserID] INT NOT NULL DEFAULT 0, 
    [ActionID] INT NOT NULL DEFAULT 0, 
    [RefID] NVARCHAR(50) NOT NULL DEFAULT '0', 
    CONSTRAINT [PK_System_Logging] PRIMARY KEY ([LoggingID]),

)
