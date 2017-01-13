CREATE TABLE [dbo].[History_TradesStatistical]
(
    [SystemID]         INT            NOT NULL,
    [TradeGroupID] INT NOT NULL,
    [TradeID] INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [TradeNumber] NVARCHAR(50) NULL, 
    [CostLocationID] INT NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_TradesStatistical] PRIMARY KEY ([SystemID], [TradeGroupID], [TradeID], [EditOn]) 
)
