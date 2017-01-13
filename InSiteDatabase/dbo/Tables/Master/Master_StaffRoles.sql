CREATE TABLE [dbo].[Master_StaffRoles]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [StaffRoleID]           INT            IDENTITY (1, 1) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [IsVisible]        BIT            DEFAULT 1 NOT NULL,
    [IsFirstAider] BIT NOT NULL DEFAULT 0, 
    [IsDisposalExpert] BIT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       CONSTRAINT [DF_Master_StaffRoles_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_Master_StaffRoles_EditOn] DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_StaffRoles] PRIMARY KEY ([SystemID], [BpID], [StaffRoleID]), 
)
