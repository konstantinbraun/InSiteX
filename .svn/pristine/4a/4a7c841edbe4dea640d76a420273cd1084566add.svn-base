CREATE TABLE [dbo].[System_Images]
(
	[SystemID] INT NOT NULL , 
    [ImageID] INT NOT NULL IDENTITY, 
    [ImageName] NVARCHAR(50) NULL, 
    [ImagePath] NVARCHAR(100) NULL, 
    PRIMARY KEY ([SystemID], [ImageID])
)

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Images',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bildes',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Images',
    @level2type = N'COLUMN',
    @level2name = N'ImageID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Name des Bildes',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Images',
    @level2type = N'COLUMN',
    @level2name = N'ImageName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Pfad des Bildes',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Images',
    @level2type = N'COLUMN',
    @level2name = N'ImagePath'