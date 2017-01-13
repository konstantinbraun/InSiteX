CREATE TABLE [dbo].[Master_Rights] (
    [SystemID]     INT           NOT NULL,
    [BpID]         INT           NOT NULL,
    [RightID]      INT           IDENTITY (1, 1) NOT NULL,
    [RefID1]       INT           CONSTRAINT [DF_Master_Rights_RefID1] DEFAULT ((0)) NOT NULL,
    [RefID2]       INT           CONSTRAINT [DF_Master_Rights_RefID2] DEFAULT ((0)) NOT NULL,
    [RefID3]       INT           CONSTRAINT [DF_Master_Rights_RefID3] DEFAULT ((0)) NOT NULL,
    [NameInternal] NVARCHAR (50) NULL,
    [IsValid]      BIT           CONSTRAINT [DF_Master_Rights_IsVisible] DEFAULT ((1)) NOT NULL,
    [CreatedFrom]  NVARCHAR (50) NULL,
    [CreatedOn]    DATETIME      CONSTRAINT [DF_Master_Rights_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]     NVARCHAR (50) NULL,
    [EditOn]       DATETIME      CONSTRAINT [DF_Master_Rights_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_Rights] PRIMARY KEY CLUSTERED ([SystemID] ASC, [BpID] ASC, [RightID] ASC)
);


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'BpID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Rechte ID',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'RightID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Verweis ID 1',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'RefID1'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Verweis ID 2',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'RefID2'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Verweis ID 3',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'RefID3'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Bezeichnung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'NameInternal'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ist gültig',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'IsValid'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'CreatedFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'CreatedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'EditFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Rights',
    @level2type = N'COLUMN',
    @level2name = N'EditOn'
GO