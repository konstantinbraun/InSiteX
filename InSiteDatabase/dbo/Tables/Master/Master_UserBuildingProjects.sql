CREATE TABLE [dbo].[Master_UserBuildingProjects](
	[SystemID] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[BpID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[CreatedFrom] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NOT NULL,
	[EditFrom] [nvarchar](50) NOT NULL,
	[EditOn] [datetime] NOT NULL,
 CONSTRAINT [PK_Master_UserBuildingProjects] PRIMARY KEY CLUSTERED 
(
	[SystemID] ASC,
	[UserID] ASC,
	[BpID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Master_UserBuildingProjects] ADD  CONSTRAINT [DF__Master_Us__Creat__0B129727]  DEFAULT (sysdatetime()) FOR [CreatedOn]
GO

ALTER TABLE [dbo].[Master_UserBuildingProjects] ADD  CONSTRAINT [DF__Master_Us__EditO__0C06BB60]  DEFAULT (sysdatetime()) FOR [EditOn]
GO

