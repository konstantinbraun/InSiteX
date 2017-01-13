CREATE TABLE [dbo].[History_TariffContracts]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TariffContractID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [ValidFrom]        DATE       DEFAULT (sysdatetime()) NOT NULL,
    [Status] INT DEFAULT 0 NOT NULL,
    [TariffValue1Name]      NVARCHAR (50)  NULL,
    [TariffValue2Name]      NVARCHAR (50)  NULL,
    [TariffValue3Name]      NVARCHAR (50)  NULL,
    [TariffValue4Name]      NVARCHAR (50)  NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_M_TariffAgreement] PRIMARY KEY ([SystemID], [BpID], [TariffContractID], [EditOn]), 
)
