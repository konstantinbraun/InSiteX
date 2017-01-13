CREATE TABLE [dbo].[Master_Passes] (
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [PassID]           INT            IDENTITY (1, 1) NOT NULL,
    [InternalID] NVARCHAR(50) NULL, 
    [ExternalID] NVARCHAR(50) NULL, 
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [ValidFrom]        DATETIME       NULL,
    [ValidUntil]       DATETIME       NULL,
    [EmployeeID]             INT            NOT NULL,
    [TypeID] INT NOT NULL DEFAULT 0, 
    [FileName] NVARCHAR(200) NULL, 
    [FileType] NVARCHAR(50) NULL, 
    [FileData] IMAGE NULL, 
    [BarcodeData] IMAGE NULL, 
    [PrintedFrom] NVARCHAR(50) NULL, 
    [PrintedOn] DATETIME NULL, 
    [ActivatedFrom] NVARCHAR(50) NULL, 
    [ActivatedOn] DATETIME NULL, 
    [DeactivatedFrom] NVARCHAR(50) NULL, 
    [DeactivatedOn] DATETIME NULL, 
    [LockedFrom] NVARCHAR(50) NULL, 
    [LockedOn] DATETIME NULL, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       CONSTRAINT [DF_Master_Passes_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_Master_Passes_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_Passes] PRIMARY KEY CLUSTERED ([SystemID] ASC, [BpID] ASC, [PassID] ASC)
);

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'BpID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Ausweises',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'PassID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Bezeichnung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'NameVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Beschreibung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'DescriptionShort'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'CreatedFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'CreatedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'EditFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'EditOn'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Gültig von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'ValidFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Gültig bis',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'ValidUntil'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ausweistyp',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Passes',
    @level2type = N'COLUMN',
    @level2name = N'TypeID'