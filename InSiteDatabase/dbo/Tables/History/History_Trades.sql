CREATE TABLE [dbo].[History_Trades]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TradeGroupID] INT NOT NULL,
    [TradeID] INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) CONSTRAINT [DF_Master_Trades_DescriptionShort] NULL,
    [TradeNumber] NVARCHAR(50) NULL, 
    [CostLocationID] INT NULL, 
    [TradeGroupStatisticalID] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_Trades] PRIMARY KEY ([SystemID], [BpID], [TradeGroupID], [TradeID], [EditOn]) 
)
