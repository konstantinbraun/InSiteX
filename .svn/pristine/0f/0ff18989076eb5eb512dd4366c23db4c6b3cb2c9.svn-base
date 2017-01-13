CREATE TABLE [dbo].[Master_States]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [StateID] INT NOT NULL IDENTITY, 
    [StateDefaultID] INT NOT NULL, 
    [Ref1ID] INT NOT NULL DEFAULT 0, 
    [Ref2ID] INT NOT NULL DEFAULT 0, 
    [Ref3ID] INT NOT NULL DEFAULT 0, 
    [Ref4ID] INT NOT NULL DEFAULT 0, 
    [Ref5ID] INT NOT NULL DEFAULT 0, 
    [Ref6ID] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_States] PRIMARY KEY ([SystemID], [BpID], [StateID]),
)
