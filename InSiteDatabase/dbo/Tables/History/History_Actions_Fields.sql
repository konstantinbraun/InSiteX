CREATE TABLE [dbo].[History_Actions_Fields]
(
	[SystemID] INT NOT NULL , 
    [BpID] INT NOT NULL, 
    [RoleID] INT NOT NULL, 
    [DialogID] INT NOT NULL, 
    [ActionID] INT NOT NULL, 
    [FieldID] INT NOT NULL, 
    [IsVisible] BIT NOT NULL DEFAULT 1, 
    [IsEditable] BIT NOT NULL DEFAULT 0, 
    [IsMandatory] BIT NOT NULL DEFAULT 0, 
    [DefaultValue] NVARCHAR(200) NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    PRIMARY KEY ([SystemID], [BpID], [RoleID], [DialogID], [ActionID], [FieldID], [EditOn])
)
