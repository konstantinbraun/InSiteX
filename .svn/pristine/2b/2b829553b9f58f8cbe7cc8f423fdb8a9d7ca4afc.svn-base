CREATE TABLE [dbo].[History_S_TariffWages]
(
    [SystemID]         INT            NOT NULL,
    [TariffID]           INT            NOT NULL,
    [TariffContractID]           INT            NOT NULL,
    [TariffScopeID]           INT            NOT NULL,
    [TariffWageGroupID]           INT            NOT NULL,
    [TariffWageID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [ValidFrom]        DATE       DEFAULT (sysdatetime()) NOT NULL,
    [Wage] DECIMAL(19, 4) NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_S_TariffWages] PRIMARY KEY ([SystemID], [TariffID], [TariffContractID], [TariffScopeID], [TariffWageGroupID], [TariffWageID], [EditOn]), 
)
