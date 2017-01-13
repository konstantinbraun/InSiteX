CREATE TABLE [dbo].[Data_ShortTermPassesPrint]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [PrintID] INT NOT NULL IDENTITY, 
    [FileName] NVARCHAR(200) NULL, 
    [FileType] NVARCHAR(50) NULL, 
    [FileData] IMAGE NULL, 
    [PrintedFrom] NVARCHAR(50) NULL, 
    [PrintedOn] DATETIME NULL, 
    CONSTRAINT [PK_Data_ShortTermPassesPrint] PRIMARY KEY ([SystemID], [BpID], [PrintID]) 
)
