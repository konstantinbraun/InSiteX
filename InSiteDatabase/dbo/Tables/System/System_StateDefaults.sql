CREATE TABLE [dbo].[System_StateDefaults]
(
    [SystemID]         INT            NOT NULL,
    [StateDefaultID] INT NOT NULL IDENTITY, 
    [NextStateID] INT NOT NULL DEFAULT 0, 
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [DialogID] INT NOT NULL DEFAULT 0, 
    [ActionID] INT NOT NULL DEFAULT 0, 
    [ResourceID] NVARCHAR(50) NULL, 
    [MinimumTypeID] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_System_StateDefaults] PRIMARY KEY ([SystemID], [StateDefaultID]),
)
