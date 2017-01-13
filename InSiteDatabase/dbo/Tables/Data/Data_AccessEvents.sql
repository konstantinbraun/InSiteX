CREATE TABLE [dbo].[Data_AccessEvents]
(
    [AccessEventID] INT NOT NULL IDENTITY,
	[SystemID] INT NOT NULL , 
    [BfID] INT NOT NULL DEFAULT 0, 
    [BpID] INT NOT NULL, 
    [AccessAreaID] INT NOT NULL, 
    [EntryID] INT NOT NULL, 
    [PoeID] INT NOT NULL, 
    [OwnerID] INT NOT NULL, 
    [InternalID] NVARCHAR(50) NULL, 
    [IsOnlineAccessEvent] BIT NOT NULL DEFAULT 0, 
    [AccessOn] DATETIME NULL, 
    [AccessType] INT NOT NULL DEFAULT 0, 
    [AccessResult] INT NOT NULL DEFAULT 0, 
    [MessageShown] BIT NOT NULL DEFAULT 0, 
    [DenialReason] INT NOT NULL DEFAULT 0, 
    [IsManualEntry] BIT NOT NULL DEFAULT 0, 
    [AddedBySystem] BIT NOT NULL DEFAULT 0, 
    [CountIt] BIT NOT NULL DEFAULT 1, 
    [Remark] NVARCHAR(200) NULL, 
    [PassType] INT NOT NULL DEFAULT 0, 
    [AccessEventLinkedID] INT NULL, 
    [CreatedOn] DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    [CreatedFrom] NVARCHAR(50) NULL, 
    [EditOn] DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    [EditFrom] NVARCHAR(50) NULL, 
    [CorrectedOn] DATETIME NULL, 
    [MaxPresentTimeExc] BIT NOT NULL DEFAULT 0, 
    [PresentOvernight] BIT NOT NULL DEFAULT 0, 
    PRIMARY KEY ([AccessEventID])
)

GO
