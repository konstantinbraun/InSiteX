CREATE TABLE [dbo].[System_SessionLog]
(
    [SessionID] NVARCHAR(200) NOT NULL, 
    [SystemID] INT NULL, 
    [UserID] INT NULL, 
    [FirstUsed] DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    [LastUsed] DATETIME NULL, 
    [SessionState] INT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_System_SessionLog] PRIMARY KEY ([SessionID])
)
