CREATE TABLE [dbo].[History_TradeGroupsStatistical]
(
    [SystemID]         INT            NOT NULL,
    [TradeGroupID] INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200)  NULL,
    [Position] INT NOT NULL DEFAULT 0, 
    [PassColor] NVARCHAR(10) NULL , 
    [TemplateID] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_TradeGroupsStatistical] PRIMARY KEY ([SystemID], [TradeGroupID], [EditOn]), 
)
