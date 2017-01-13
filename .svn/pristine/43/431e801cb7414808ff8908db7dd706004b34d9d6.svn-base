CREATE TABLE [dbo].[Master_CompanyAdditions]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [CompanyID] INT NOT NULL, 
    [TradeAssociation] NVARCHAR(200) NULL, 
    [BlnSOKA] BIT NOT NULL DEFAULT 0, 
    [IsPartner] BIT NOT NULL DEFAULT 0, 
    [RiskAssessment] BIT NOT NULL DEFAULT 0, 
    [MinWageAttestation] BIT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_CompanyAdditions] PRIMARY KEY ([SystemID], [BpID], [CompanyID]), 
)
