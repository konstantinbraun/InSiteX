CREATE TABLE [dbo].[Master_CompanyTrades]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TradeGroupID] INT NOT NULL,
    [TradeID] INT NOT NULL,
    [CompanyID] INT NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_CompanyTrades] PRIMARY KEY ([SystemID], [BpID], [TradeGroupID], [TradeID], [CompanyID]) 
)
