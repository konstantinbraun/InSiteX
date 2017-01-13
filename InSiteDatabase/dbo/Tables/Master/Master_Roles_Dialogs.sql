CREATE TABLE [dbo].[Master_Roles_Dialogs]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [RoleID]           INT            NOT NULL, 
    [DialogID] INT NOT NULL, 
    [IsActive] BIT NOT NULL DEFAULT 1, 
    [UseCompanyAssignment] BIT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       CONSTRAINT [DF_Master_Roles_Dialogs_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_Master_Roles_Dialogs_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_Roles_Dialogs] PRIMARY KEY ([SystemID], [BpID], [RoleID], [DialogID]),
)
