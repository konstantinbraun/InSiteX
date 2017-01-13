CREATE TABLE [dbo].[Master_Addresses] (
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [AddressID]        INT            IDENTITY (1, 1) NOT NULL,
    [Salutation]       NVARCHAR (50)  NULL,
    [Title]            NVARCHAR (50)  NULL,
    [FirstName]        NVARCHAR (50)  NULL,
    [MiddleName]       NVARCHAR (50)  NULL,
    [LastName]         NVARCHAR (50)  NULL,
    [Address1]         NVARCHAR (100) NULL,
    [Address2]         NVARCHAR (100) NULL,
    [Zip]              NVARCHAR (20)  NULL,
    [City]             NVARCHAR (100) NULL,
    [State]            NVARCHAR (100) NULL,
    [DenominationID]       INT            CONSTRAINT [DF_Master_Addresses_Denomination] DEFAULT ((0)) NOT NULL,
    [CountryID]      NVARCHAR(10)       NULL,
    [LanguageID]     NVARCHAR(10)       NULL,
    [NationalityID] NVARCHAR(10) NULL, 
    [Phone]            NVARCHAR (50)  NULL,
    [Mobile]           NVARCHAR (50)  NULL,
    [Email]            NVARCHAR (200) NULL,
    [WWW] NVARCHAR(200) NULL, 
    [DescriptionShort] NVARCHAR (200) NULL,
    [BirthDate] DATE NULL, 
    [Gender] INT NULL, 
    [PhotoFileName] NVARCHAR(200) NULL, 
    [PhotoData] IMAGE NULL, 
    [ThumbnailData] IMAGE NULL, 
    [Soundex] NVARCHAR(1000) NULL, 
    [CreatedFrom]      TIMESTAMP  NULL,
    [CreatedOn]        DATETIME       CONSTRAINT [DF_Master_Addresses_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       CONSTRAINT [DF_Master_Addresses_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_Address] PRIMARY KEY CLUSTERED ([SystemID] ASC, [BpID] ASC, [AddressID] ASC)
);


GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Anrede',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'Salutation'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Titel',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'Title'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Vorname',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'FirstName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'weitere Vornamen',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'MiddleName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Nachname',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'LastName'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Adresse 1',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'Address1'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Adresse 2',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'Address2'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'PLZ',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'Zip'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ort',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'City'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Region, Bundesland',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'State'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Konfession',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'DenominationID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Ländercode',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'CountryID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Sprachencode',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'LanguageID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Telefon',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'Phone'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Mobiltelefon',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'Mobile'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Email',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'Email'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Bemerkung',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'DescriptionShort'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Systems',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'SystemID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID des Bauvorhabens',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'BpID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'ID der Adresse',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'AddressID'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'CreatedFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Erstellt am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'CreatedOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert am',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'EditFrom'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geändert von',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'EditOn'
GO
EXEC sp_addextendedproperty @name = N'MS_Description',
    @value = N'Geburtstag',
    @level0type = N'SCHEMA',
    @level0name = N'dbo',
    @level1type = N'TABLE',
    @level1name = N'Master_Addresses',
    @level2type = N'COLUMN',
    @level2name = N'BirthDate'