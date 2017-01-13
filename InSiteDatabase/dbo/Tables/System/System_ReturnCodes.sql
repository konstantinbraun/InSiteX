CREATE TABLE [dbo].[System_ReturnCodes]
(
	[SystemID] INT NOT NULL , 
    [ReturnCodeID] INT NOT NULL, 
    [OriginalMessage] NVARCHAR(1000) NULL, 
    [ResourceID] NVARCHAR(50) NULL, 
    PRIMARY KEY ([SystemID], [ReturnCodeID])
)
