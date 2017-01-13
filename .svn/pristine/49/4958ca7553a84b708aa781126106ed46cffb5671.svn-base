CREATE TABLE [dbo].[Master_Countries](
	[SystemID] [int] NOT NULL,
	[BpID] [int] NOT NULL,
	[CountryID] [nvarchar](10) NOT NULL,
	[CountryGroupID] [int] NOT NULL,
	[NameVisible] [nvarchar](50) NULL,
	[DescriptionShort] [nvarchar](200) NULL,
	[CreatedFrom] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL DEFAULT SYSDATETIME(),
	[EditFrom] [nvarchar](50) NULL,
	[EditOn] [datetime] NOT NULL DEFAULT SYSDATETIME(),
 CONSTRAINT [PK_Master_Countries] PRIMARY KEY CLUSTERED 
(
	[SystemID] ASC,
	[BpID] ASC,
	[CountryID] ASC
)
)