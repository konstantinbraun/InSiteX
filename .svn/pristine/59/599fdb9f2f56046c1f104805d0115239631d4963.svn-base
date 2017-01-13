CREATE TABLE [dbo].[History_TariffData]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TariffContractID]           INT            NOT NULL,
    [TariffDataID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [TariffValue1] DECIMAL(19, 4) NOT NULL DEFAULT 0, 
    [TariffValue2] DECIMAL(19, 4) NOT NULL DEFAULT 0, 
    [TariffValue3] DECIMAL(19, 4) NOT NULL DEFAULT 0, 
    [TariffValue4] DECIMAL(19, 4) NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_TariffData] PRIMARY KEY ([SystemID], [BpID], [TariffContractID], [TariffDataID], [EditOn]), 
)
