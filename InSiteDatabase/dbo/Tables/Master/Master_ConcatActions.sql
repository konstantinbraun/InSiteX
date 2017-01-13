CREATE TABLE [dbo].[Master_ConcatActions]
(
	[SystemID] INT NOT NULL , 
    [BpID] INT NOT NULL, 
    [ActionID] INT NOT NULL, 
    [ParentActionID] INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    PRIMARY KEY ([SystemID], [ParentActionID], [BpID], [ActionID]), 
)
