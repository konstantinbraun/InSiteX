CREATE TABLE [dbo].[Master_EmployeeRelevantDocuments]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [EmployeeID]             INT            NOT NULL,
    [RelevantFor] TINYINT NOT NULL, 
    [RelevantDocumentID] INT NOT NULL DEFAULT 0,
    [DocumentReceived] BIT NOT NULL DEFAULT 0, 
    [ExpirationDate] DATE NULL, 
    [IDNumber] NVARCHAR(50) NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_EmployeeRelevantDocuments] PRIMARY KEY ([SystemID], [RelevantFor], [BpID], [EmployeeID]), 
)
