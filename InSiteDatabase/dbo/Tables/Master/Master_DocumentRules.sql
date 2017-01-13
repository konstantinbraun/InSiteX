CREATE TABLE [dbo].[Master_DocumentRules]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [CountryGroupIDEmployer] INT NOT NULL,
    [CountryGroupIDEmployee] INT NOT NULL,
    [EmploymentStatusID] INT NOT NULL, 
    [RelevantFor] TINYINT NOT NULL DEFAULT 0, 
    [RelevantDocumentID] INT NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_DocumentRules] PRIMARY KEY ([SystemID], [BpID], [CountryGroupIDEmployer], [CountryGroupIDEmployee], [EmploymentStatusID], [RelevantFor], [RelevantDocumentID]) 
)
