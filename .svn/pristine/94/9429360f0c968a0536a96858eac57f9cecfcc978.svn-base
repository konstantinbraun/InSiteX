CREATE TABLE [dbo].[Master_BuildingProjects] (
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            IDENTITY (1, 1) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) CONSTRAINT [DF_Master_BuildingProject_DescriptionShort] NULL,
    [TypeID]           TINYINT        CONSTRAINT [DF_Table_1_ByType] DEFAULT ((0)) NOT NULL,
    [BasedOn] INT NOT NULL DEFAULT 0, 
    [IsVisible]        BIT            NOT NULL,
    [CountryID] NVARCHAR(10) NULL, 
    [BuilderName] NVARCHAR(200) NULL, 
    [PresentType] TINYINT NOT NULL DEFAULT 0, 
    [MWCheck] BIT NOT NULL DEFAULT 0, 
    [MWHours] INT NOT NULL DEFAULT 0, 
    [MWDeadline] INT NOT NULL DEFAULT 0, 
    [MWLackTrigger] INT NOT NULL DEFAULT 0, 
    [MinWageAccessRelevance] BIT NOT NULL DEFAULT 0, 
    [Address] NVARCHAR(500) NULL, 
    [DefaultRoleID] INT NOT NULL DEFAULT 0, 
    [DefaultAccessAreaID] INT NOT NULL DEFAULT 0, 
    [DefaultTimeSlotGroupID] INT NOT NULL DEFAULT 0, 
    [DefaultSTAccessAreaID] INT NOT NULL DEFAULT 0, 
    [DefaultSTTimeSlotGroupID] INT NOT NULL DEFAULT 0, 
    [PrintPassOnCompleteDocs] BIT NOT NULL DEFAULT 0, 
    [DefaultTariffScope] INT NOT NULL DEFAULT 0, 
    [ContainerManagementName] NVARCHAR(50) NULL, 
    [AccessRightValidDays] INT NOT NULL DEFAULT 365, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       CONSTRAINT [DF_Master_BuildingProject_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_Master_BuildingProject_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_BuildingProject] PRIMARY KEY CLUSTERED ([SystemID] ASC, [BpID] ASC)
);


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'BpID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Bezeichnung des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'NameVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Beschreibung des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'DescriptionShort'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Satztyp: Bauvorhaben, Vorlage',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'TypeID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'In Anwendung anzeigen',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'CreatedFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'CreatedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'EditFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'EditOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Basiert auf Vorlage / Bauvorhaben',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'BasedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Land des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'CountryID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Name des Bauherrn',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'BuilderName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Anwesenheitsvariante',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'PresentType'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Mindestlohn Prüfung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = 'MWCheck'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Grenzwert monatliche Anwesenheit für Mindestlohn',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'MWHours'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Vorlage Mindestlohnbescheinigung ab Tag im Monat',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'MWDeadline'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Adresse',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'Address'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Kein Zutritt, wenn die Fälligkeit der ML-Bescheinigung um diese Anzahl Tage überschritten wurde',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_BuildingProjects',
    @level2type = N'COLUMN',
    @level2name = N'MWLackTrigger'