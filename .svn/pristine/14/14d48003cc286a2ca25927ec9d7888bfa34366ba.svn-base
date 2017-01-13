CREATE TABLE [dbo].[System_TariffScopes]
(
    [SystemID]         INT            NOT NULL,
    [TariffID]           INT            NOT NULL,
    [TariffContractID]           INT            NOT NULL,
    [TariffScopeID]           INT            IDENTITY (1, 1) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [ScopeID] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_System_TariffScopes] PRIMARY KEY ([SystemID], [TariffID], [TariffContractID], [TariffScopeID]), 
)
