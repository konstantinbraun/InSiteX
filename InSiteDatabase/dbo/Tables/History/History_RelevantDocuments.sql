CREATE TABLE [dbo].[History_RelevantDocuments]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [RelevantDocumentID] INT NOT NULL,
    [RelevantFor] TINYINT NOT NULL DEFAULT 0, 
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [IsAccessRelevant] BIT NOT NULL DEFAULT 1, 
    [RecExpirationDate] BIT NOT NULL DEFAULT 1, 
    [RecIDNumber] BIT NOT NULL DEFAULT 1, 
    [SampleFileName] NVARCHAR(200) NULL, 
    [SampleData] IMAGE NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_RelevantDocuments] PRIMARY KEY ([SystemID], [BpID], [RelevantDocumentID], [EditOn]), 
)
