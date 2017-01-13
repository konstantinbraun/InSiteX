CREATE TABLE [dbo].[Master_TradeGroups]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TradeGroupID] INT NOT NULL IDENTITY,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) CONSTRAINT [DF_Master_TradeGroups_DescriptionShort] NULL,
    [Position] INT NOT NULL DEFAULT 0, 
    [PassColor] NVARCHAR(10) NULL , 
    [TemplateID] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_TradeGroups] PRIMARY KEY ([SystemID], [BpID], [TradeGroupID]), 
)
