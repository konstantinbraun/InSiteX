CREATE TABLE [dbo].[Master_Roles] (
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [RoleID]           INT            IDENTITY (1, 1) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [TypeID]           TINYINT        CONSTRAINT [DF_Master_Role_TypeID] DEFAULT ((1)) NOT NULL,
    [IsVisible]        BIT            CONSTRAINT [DF_Master_Role_IsVisible] DEFAULT ((1)) NOT NULL,
    [ShowInList] BIT NOT NULL DEFAULT 1, 
    [SelfAndSubcontractors] BIT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       CONSTRAINT [DF_Master_Role_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_Master_Role_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_Role] PRIMARY KEY CLUSTERED ([SystemID] ASC, [BpID] ASC, [RoleID] ASC)
);


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'BpID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Rolle',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'RoleID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Bezeichnung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'NameVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Beschreibung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'DescriptionShort'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Typ ID',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'TypeID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ist sichtbar',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'CreatedFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'CreatedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'EditFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'EditOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'In Listen anzeigen',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Roles',
    @level2type = N'COLUMN',
    @level2name = N'ShowInList'