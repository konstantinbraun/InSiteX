CREATE TABLE [dbo].[Data_AccessRightEvents]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [AccessRightEventID] INT NOT NULL IDENTITY,
    [PassID]           INT            NOT NULL, 
    [PassType] INT NOT NULL, 
    [ExternalID] NVARCHAR(50) NULL, 
    [OwnerID] INT NOT NULL, 
    [IsActive] BIT NOT NULL DEFAULT 0, 
    [ValidUntil] DATETIME NULL, 
    [AccessAllowed] BIT NOT NULL DEFAULT 0, 
    [AccessDenialReason] NVARCHAR(500) NULL, 
    [Message] NVARCHAR(200) NULL, 
    [MessageFrom] DATETIME NULL, 
    [MessageUntil] DATETIME NULL, 
    [IsDelivered] BIT NOT NULL DEFAULT 0, 
    [DeliveredAt] DATETIME NULL, 
    [DeliveryMessage] NVARCHAR(500) NULL, 
    [IsNewest] BIT NOT NULL DEFAULT 1, 
    [HasSubstitute] BIT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR(50)  NULL,
    [CreatedOn]        DATETIME   DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]      NVARCHAR(50)  NULL,
    [EditOn]        DATETIME   DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Data_AccessRights] PRIMARY KEY ([SystemID], [BpID], [AccessRightEventID]), 
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'BpID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Zutrittsrecht Ereignisses',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'AccessRightEventID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Ausweises / Kurzzeitausweises',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'PassID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Mitarbeiters / Besuchers',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'OwnerID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'1 = Ausweis, 2 = Kurzzeitausweis',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'PassType'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'1 = Aktiv, 0 = Inaktiv',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'IsActive'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Gültig bis',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'ValidUntil'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'1 = Zutritt erlaubt, 0 = Zutritt nicht erlaubt',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'AccessAllowed'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Nachricht an Inhaber',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'Message'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Nachricht anzeigen von ...',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'MessageFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'... bis',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'MessageUntil'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Angelegt von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'CreatedFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Angelegt am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'CreatedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Übergabe an Zutrittsystem erfolgreich',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'IsDelivered'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Zeitpunkt der Übergabe an Zutrittsystem',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'DeliveredAt'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Letzte Meldung vom Zutrittsystem',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'DeliveryMessage'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Externe ID des Ausweises',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'ExternalID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Gründe für Ablehnung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'AccessDenialReason'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Neuester Eintrag',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = 'IsNewest'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ersatzausweis zugeteilt',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'HasSubstitute'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'EditFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Data_AccessRightEvents',
    @level2type = N'COLUMN',
    @level2name = N'EditOn'