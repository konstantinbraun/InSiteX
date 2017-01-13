CREATE TABLE [dbo].[Data_MWAttestationRequest]
(
	[SystemID] INT NOT NULL , 
    [BpID] INT NOT NULL, 
    [RequestID] INT NOT NULL IDENTITY, 
    [CompanyID] INT NOT NULL, 
    [MWMonth] DATE NOT NULL, 
    [FileName] NVARCHAR(200) NULL, 
    [FileType] NVARCHAR(50) NULL, 
    [FileData] IMAGE NULL, 
    [CreatedFrom] NVARCHAR(50) NULL, 
    [CreatedOn] DATETIME NOT NULL DEFAULT SYSDATETIME(), 
    PRIMARY KEY ([SystemID], [BpID], [RequestID])
)
