CREATE TABLE [dbo].[Master_Actions_Fields]
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
    [CreatedOn]        DATETIME       CONSTRAINT [DF_Master_Actions_Fields_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_Master_Actions_Fields_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    PRIMARY KEY ([SystemID], [BpID], [RoleID], [DialogID], [ActionID], [FieldID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'BpID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Rolle',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'RoleID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Aktion',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'ActionID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Dialogs',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'DialogID'
GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Feldes',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = 'FieldID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ist sichtbar',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ist editierbar',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'IsEditable'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'CreatedFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'CreatedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'EditFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'EditOn'

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ist erforderlich',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'IsMandatory'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Standardwert',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Actions_Fields',
    @level2type = N'COLUMN',
    @level2name = N'DefaultValue'