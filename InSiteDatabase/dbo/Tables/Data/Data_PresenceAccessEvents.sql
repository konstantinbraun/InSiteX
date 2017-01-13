CREATE TABLE [dbo].[Data_PresenceAccessEvents]
(
	[SystemID] INT NOT NULL , 
    [BpID] INT NOT NULL, 
    [CompanyID] INT NOT NULL, 
    [TradeID] INT NOT NULL, 
    [PresenceDay] DATE NOT NULL, 
    [EmployeeID] INT NOT NULL, 
    [AccessAt] DATETIME NOT NULL, 
    [ExitAt] DATETIME NULL, 
    [PresenceSeconds] BIGINT NOT NULL DEFAULT 0, 
    [AccessAreaID] INT NOT NULL, 
    [TimeSlotID] INT NOT NULL, 
    [AccessTimeManual] BIT NOT NULL DEFAULT 0, 
    [ExitTimeManual] BIT NOT NULL DEFAULT 0, 
    [CountAs] TINYINT NOT NULL DEFAULT 1, 
    PRIMARY KEY ([SystemID], [BpID], [CompanyID], [TradeID], [PresenceDay], [EmployeeID], [AccessAt])
)
