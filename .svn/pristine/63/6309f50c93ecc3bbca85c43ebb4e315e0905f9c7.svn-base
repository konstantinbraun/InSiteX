CREATE TABLE [dbo].[Data_StatisticsTerminals]
(
	[SystemID] INT NOT NULL , 
    [BfID] INT NOT NULL, 
    [BpID] INT NOT NULL, 
    [StatisticsDate] DATE NOT NULL, 
    [AccessAreaID] INT NOT NULL, 
    [TerminalID] INT NOT NULL, 
    [OnlineTime] INT NOT NULL DEFAULT 0, 
    [EnterEvents] INT NOT NULL DEFAULT 0, 
    [ExitEvents] INT NOT NULL DEFAULT 0, 
    [OnOffChanges] INT NOT NULL DEFAULT 0, 
    [ErrorEvents] INT NOT NULL DEFAULT 0, 
    [SnapshotTimestamp] DATETIME NULL, 
    CONSTRAINT [PK_Data_StatisticsTerminals] PRIMARY KEY ([SystemID], [BfID], [BpID], [StatisticsDate], [AccessAreaID], [TerminalID]), 

)
