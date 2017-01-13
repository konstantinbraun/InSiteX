CREATE TABLE [dbo].[Data_Statistics]
(
	[SystemID] INT NOT NULL , 
    [BfID] INT NOT NULL, 
    [BpID] INT NOT NULL, 
    [AssignedEmployees] INT NOT NULL DEFAULT 0, 
    [AccessEventsCount] INT NOT NULL DEFAULT 0, 
    [CorrectedEvents] INT NOT NULL DEFAULT 0, 
    [LastCompression] DATETIME NULL, 
    [LastCorrection] DATETIME NULL, 
    [MaximumPresentTime] INT NOT NULL DEFAULT 0, 
    [PresentOvernight] INT NOT NULL DEFAULT 0, 
    [ReplacementPasses] INT NOT NULL DEFAULT 0, 
    [SnapshotTimestamp] DATETIME NULL, 
    [StatisticsDate] DATE NOT NULL, 
    PRIMARY KEY ([SystemID], [BfID], [BpID], [StatisticsDate])
)
