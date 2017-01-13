CREATE TABLE [dbo].[Master_Dialogs_Actions]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [RoleID]           INT            NOT NULL, 
    [DialogID] INT NOT NULL, 
    [ActionID] INT NOT NULL,
    [IsActive] BIT NOT NULL DEFAULT 1, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       CONSTRAINT [DF_Master_Dialogs_Actions_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_Master_Dialogs_Actions_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_Dialogs_Actions] PRIMARY KEY ([SystemID], [BpID], [RoleID], [DialogID], [ActionID]), 
)
