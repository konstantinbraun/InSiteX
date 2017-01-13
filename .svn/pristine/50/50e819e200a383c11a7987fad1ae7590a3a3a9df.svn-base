CREATE TABLE [dbo].[System_Fields] (
    [SystemID]     INT           NOT NULL,
    [DialogID]     INT           NOT NULL,
    [FieldID]      INT           IDENTITY (1, 1) NOT NULL,
    [InternalName] NVARCHAR (50) NULL,
    [ResourceID] NVARCHAR(50) NULL, 
    [TypeID]       TINYINT       CONSTRAINT [DF_System_Fields_TypeID] DEFAULT ((1)) NOT NULL,
    [IsVisible]    BIT           CONSTRAINT [DF_System_Fields_IsVisible] DEFAULT ((1)) NOT NULL,
    [IsMandatory]  BIT           CONSTRAINT [DF_System_Fields_IsMandatory] DEFAULT ((0)) NOT NULL,
    [DefaultValue] NVARCHAR (10) NULL,
    [HasVariables] BIT NOT NULL DEFAULT 0, 
    CONSTRAINT [PK_System_Fields] PRIMARY KEY CLUSTERED ([SystemID] ASC, [DialogID] ASC, [FieldID] ASC)
);


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO

GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Dialogs',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'DialogID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Feldes',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'FieldID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Interner Feldname',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'InternalName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Feldtyp',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'TypeID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Wird angezeigt',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'IsVisible'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ist erforderlich',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'IsMandatory'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Standardwert',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'DefaultValue'
GO

EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Benutzt Textvariablen',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'System_Fields',
    @level2type = N'COLUMN',
    @level2name = N'HasVariables'