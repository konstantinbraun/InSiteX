CREATE TABLE [dbo].[History_S_TariffContracts]
(
    [SystemID]         INT            NOT NULL,
    [TariffID]           INT            NOT NULL,
    [TariffContractID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [ValidFrom]        DATE       DEFAULT (sysdatetime()) NOT NULL,
    [ValidTo]        DATE       DEFAULT (sysdatetime()) NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_S_TariffContracts] PRIMARY KEY ([SystemID], [TariffID], [TariffContractID], [EditOn]), 
)
