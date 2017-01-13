CREATE TABLE [dbo].[Master_CompanyTariffs]
(
    [SystemID]         INT            NOT NULL,
    [BpID]           INT            NOT NULL,
    [TariffScopeID]           INT            NOT NULL,
    [CompanyID]        INT            NOT NULL,
    [ValidFrom]        DATE       DEFAULT (sysdatetime()) NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_CompanyTariffs] PRIMARY KEY ([SystemID], [BpID], [TariffScopeID], [CompanyID]), 
)
