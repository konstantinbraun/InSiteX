CREATE TABLE [dbo].[System_TariffContracts]
(
    [SystemID]         INT            NOT NULL,
    [TariffID]           INT            NOT NULL,
    [TariffContractID]           INT            IDENTITY (1, 1) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [ValidFrom]        DATE       DEFAULT (sysdatetime()) NOT NULL,
    [ValidTo]        DATE       DEFAULT (sysdatetime()) NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_System_TariffContracts] PRIMARY KEY ([SystemID], [TariffID], [TariffContractID]), 
)
