CREATE TABLE [dbo].[History_Roles_Dialogs]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [RoleID]           INT            NOT NULL, 
    [DialogID] INT NOT NULL, 
    [UseCompanyAssignment] BIT NOT NULL DEFAULT 0, 
    [IsActive] BIT NOT NULL DEFAULT 1, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_History_Roles_Dialogs] PRIMARY KEY ([SystemID], [BpID], [RoleID], [DialogID], [EditOn]),
)
