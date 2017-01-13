CREATE TABLE [dbo].[Data_EmployeeMinWage]
(
	[SystemID] INT NOT NULL , 
    [BpID] INT NOT NULL, 
    [EmployeeID] INT NOT NULL, 
    [MWMonth] DATE NOT NULL, 
    [PresenceSeconds] BIGINT NOT NULL DEFAULT 0, 
    [StatusCode] INT NOT NULL DEFAULT 0, 
    [Amount] DECIMAL(12, 4) NOT NULL DEFAULT 0, 
    [RequestListID] INT NULL, 
    [WageGroupID] INT NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME DEFAULT (sysdatetime()) NOT NULL, 
    [RequestedFrom] NVARCHAR(50) NULL, 
    [RequestedOn] DATETIME NULL , 
    [ReceivedFrom] NVARCHAR(50) NULL, 
    [ReceivedOn] DATETIME NULL, 
    PRIMARY KEY ([SystemID], [BpID], [EmployeeID], [MWMonth])
)
