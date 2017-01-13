CREATE TABLE [dbo].[Master_TreeNodes]
(
    [SystemID] INT NOT NULL,
	[NodeID] INT NOT NULL  IDENTITY, 
    [ParentID] INT NULL , 
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) CONSTRAINT [DF_Master_TreeNodes_DescriptionShort] NULL,
    [ResourceID] NVARCHAR(50) NULL, 
    [ContextMenuID] NVARCHAR(50) NULL, 
    [NodeUrl] NVARCHAR(200) NULL, 
    [ImageID] INT NOT NULL DEFAULT 0, 
    [RefID] INT NOT NULL DEFAULT 0, 
    [RefType] INT NOT NULL DEFAULT 0, 
    [IsVisible] TINYINT NOT NULL DEFAULT 1, 
    [IsValid] TINYINT NOT NULL DEFAULT 1, 
    [Rank] INT NOT NULL DEFAULT 0, 
    [NeededTypeID] TINYINT NOT NULL DEFAULT 1, 
    [DialogID] INT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_Master_TreeNodes] PRIMARY KEY ([SystemID], [NodeID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Knotens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'NodeID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Eltern-Knotens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'ParentID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Bezeichnung des Knotens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'NameVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Beschreibung des Knotens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'DescriptionShort'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des verbundenen Stammsatzes',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'RefID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Typ des verbundenen Stammsatzes',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'RefType'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ist sichtbar',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ist gültig',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'IsValid'
GO

GO

GO

GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'URL der verbundenen Seite',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'NodeUrl'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Knoten-Icon',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = N'ImageID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Ressource',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_TreeNodes',
    @level2type = N'COLUMN',
    @level2name = 'ResourceID'