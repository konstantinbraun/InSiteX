CREATE TABLE [dbo].[System_Languages](
	[CultureID] [nvarchar](10) NOT NULL,
	[CultureName] [nvarchar](255) NULL,
	[FlagName] [nvarchar](255) NULL,
	[CountryID] [nvarchar](10) NULL,
	[CountryName] [nvarchar](255) NULL,
	[LanguageID] [nvarchar](10) NULL,
	[LanguageName] [nvarchar](255) NULL,
 CONSTRAINT [PK_System_Languages] PRIMARY KEY CLUSTERED 
(
	[CultureID] ASC
)
)