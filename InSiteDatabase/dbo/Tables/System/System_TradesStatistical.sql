CREATE TABLE [dbo].[System_TradesStatistical]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TradeGroupID] INT NOT NULL,
    [TradeID] INT NOT NULL IDENTITY,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) CONSTRAINT [DF_Master_Trades_DescriptionShort] NULL,
    [TradeNumber] NVARCHAR(50) NULL, 
    [CostLocationID] INT NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_TradesStatistical] PRIMARY KEY ([SystemID], [BpID], [TradeGroupID], [TradeID]) 
)
