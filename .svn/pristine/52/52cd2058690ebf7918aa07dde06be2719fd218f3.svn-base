CREATE TABLE [dbo].[Data_StatisticsAccessEvents]
(
	[SystemID] INT NOT NULL , 
    [BfID] INT NOT NULL DEFAULT 0, 
    [BpID] INT NOT NULL,
    [StatisticsDate] DATE NOT NULL, 
    [AccessAreaID] INT NOT NULL, 
    [PassType] INT NOT NULL, 
    [CountEnter] INT NOT NULL DEFAULT 0, 
    [CountExit] INT NOT NULL DEFAULT 0, 
    [SnapshotTimestamp] DATETIME NULL, 
    PRIMARY KEY ([SystemID], [BfID], [BpID], [StatisticsDate], [AccessAreaID], [PassType]), 
)
