CREATE TABLE [dbo].[System_CostLocations]
(
	[SystemID] INT NOT NULL , 
    [CostLocationID]           INT            IDENTITY (1, 1) NOT NULL,
    [CostLocationNumber] NVARCHAR(50) NOT NULL, 
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [TypeID]           TINYINT        CONSTRAINT [DF_System_CostLocations_TypeID] DEFAULT ((1)) NOT NULL,
    [IsVisible]        BIT            CONSTRAINT [DF_System_CostLocations_IsVisible] DEFAULT ((1)) NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       CONSTRAINT [DF_System_CostLocations_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_System_CostLocations_EditOn] DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_System_CostLocations] PRIMARY KEY ([SystemID], [CostLocationID]),
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Kostenstellen ID',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'CostLocationID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Kostenstellen Nummer',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'CostLocationNumber'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Bezeichnung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'NameVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Beschreibung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'DescriptionShort'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Typ ID',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'TypeID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Anzeigen J/N',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'CreatedFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'CreatedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'EditFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_CostLocations',
    @level2type = N'COLUMN',
    @level2name = N'EditOn'