CREATE TABLE [dbo].[History_S_TariffWageGroups]
(
    [SystemID]         INT            NOT NULL,
    [TariffID]           INT            NOT NULL,
    [TariffContractID]           INT            NOT NULL,
    [TariffScopeID]           INT            NOT NULL,
    [TariffWageGroupID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_S_TariffWageGroups] PRIMARY KEY ([SystemID], [TariffID], [TariffContractID], [TariffScopeID], [TariffWageGroupID], [EditOn]), 
)
