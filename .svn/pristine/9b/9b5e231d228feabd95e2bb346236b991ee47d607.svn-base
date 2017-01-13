CREATE TABLE [dbo].[System_Actions]
(
	[SystemID] INT NOT NULL , 
    [ActionID] INT NOT NULL IDENTITY,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL, 
    [ResourceID] NVARCHAR(50) NULL, 
    [IsRightRelevant] BIT NOT NULL DEFAULT 0, 
    PRIMARY KEY ([SystemID], [ActionID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Sytems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Actions',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Aktion',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Actions',
    @level2type = N'COLUMN',
    @level2name = N'ActionID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Name der Aktion',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Actions',
    @level2type = N'COLUMN',
    @level2name = 'NameVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Beschreibung der Aktion',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Actions',
    @level2type = N'COLUMN',
    @level2name = N'DescriptionShort'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Ressource',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Actions',
    @level2type = N'COLUMN',
    @level2name = 'ResourceID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Relevant für Rechtesteuerung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Actions',
    @level2type = N'COLUMN',
    @level2name = N'IsRightRelevant'