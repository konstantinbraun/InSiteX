CREATE TABLE [dbo].[Data_AccessAreaEvents]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [AccessRightEventID] INT NOT NULL,
    [AccessAreaEventID] INT NOT NULL IDENTITY, 
    [AccessAreaID] INT NOT NULL, 
    [TimeSlotID] INT NOT NULL, 
    [ValidFrom] DATETIME NOT NULL, 
    [ValidUntil] DATETIME NOT NULL, 
    [ValidDays] CHAR(7) NULL, 
    [TimeFrom] TIME NULL, 
    [TimeUntil] TIME NULL, 
    [AdditionalRights] INT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_Data_AccessAreaEvents] PRIMARY KEY ([SystemID], [BpID], [AccessRightEventID], [AccessAreaEventID]),
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'BpID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Zutrittsrecht Ereignisses',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'AccessRightEventID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Zutrittsbereich Ereignisses',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'AccessAreaEventID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Zutrittsbereichs',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'AccessAreaID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Zeitfensters',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'TimeSlotID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Gültig von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'ValidFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Gültig bis',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'ValidUntil'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Gültige Wochentage',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'ValidDays'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Zeitfenster ab ...',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'TimeFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'... bis',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessAreaEvents',
    @level2type = N'COLUMN',
    @level2name = N'TimeUntil'