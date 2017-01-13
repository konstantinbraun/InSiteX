CREATE TABLE [dbo].[History_Dialogs_Actions]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [RoleID]           INT            NOT NULL, 
    [DialogID] INT NOT NULL, 
    [ActionID] INT NOT NULL,
    [IsActive] BIT NOT NULL DEFAULT 1, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_History_Dialogs_Actions] PRIMARY KEY ([SystemID], [BpID], [RoleID], [DialogID], [ActionID], [EditOn]), 
)
