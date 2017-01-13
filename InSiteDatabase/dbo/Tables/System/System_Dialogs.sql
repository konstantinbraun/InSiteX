CREATE TABLE [dbo].[System_Dialogs] (
    [SystemID]    INT           NOT NULL,
    [DialogID]    INT           IDENTITY (1, 1) NOT NULL,
    [TypeID]      TINYINT       CONSTRAINT [DF_System_Dialogs_TypeID] DEFAULT ((1)) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL, 
    [ResourceID] NVARCHAR(50) NULL, 
    [PageName] NVARCHAR(200) NULL, 
    [IsVisible]   BIT           CONSTRAINT [DF_System_Dialogs_IsVisible] DEFAULT ((1)) NOT NULL,
    [UseFieldRights] BIT NOT NULL DEFAULT 0, 
    [TranslationOnly] BIT NOT NULL DEFAULT 0, 
    [UseReportingServer] BIT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_System_Dialogs] PRIMARY KEY CLUSTERED ([SystemID] ASC, [DialogID] ASC)
);


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Dialogs',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = N'DialogID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Dialogtyp',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = N'TypeID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Wird angezeigt',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible'
GO

GO

GO

GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Ressource',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = 'ResourceID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Interner Name',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = 'NameVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Kurzbeschreibung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = N'DescriptionShort'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Rechte auf Feldebene verwenden?',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = N'UseFieldRights'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Wird nur für Übersetzungen verwendet',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = N'TranslationOnly'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Verwendet Reporting Server',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Dialogs',
    @level2type = N'COLUMN',
    @level2name = N'UseReportingServer'