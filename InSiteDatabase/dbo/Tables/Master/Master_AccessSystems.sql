CREATE TABLE [dbo].[Master_AccessSystems]
(
	[SystemID] INT NOT NULL , 
    [BpID] INT NOT NULL, 
    [AccessSystemID] INT NOT NULL, 
    [LastUpdate] DATETIME NULL, 
    [AllTerminalsOnline] BIT NOT NULL DEFAULT 1, 
    [LastCompress] DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    [LastGetAccessEvents] DATETIME NULL, 
    [CompressStartTime] DATETIME NULL, 
    [LastGetAccessRights] DATETIME NULL, 
    [LastUpdateAccessRights] DATETIME NULL, 
    [LastOfflineState] DATETIME NULL, 
    [LastAddition] DATETIME NULL, 
    PRIMARY KEY ([SystemID], [BpID], [AccessSystemID])
)
