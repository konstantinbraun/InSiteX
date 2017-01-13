CREATE TABLE [dbo].[System_TariffWageGroups]
(
    [SystemID]         INT            NOT NULL,
    [TariffID]           INT            NOT NULL,
    [TariffContractID]           INT            NOT NULL,
    [TariffScopeID]           INT            NOT NULL,
    [TariffWageGroupID]           INT            IDENTITY (1, 1) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_System_TariffWageGroups] PRIMARY KEY ([SystemID], [TariffID], [TariffContractID], [TariffScopeID], [TariffWageGroupID]), 
)
