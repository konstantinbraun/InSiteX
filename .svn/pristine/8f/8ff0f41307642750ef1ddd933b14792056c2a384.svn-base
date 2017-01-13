CREATE TABLE [dbo].[System_JobTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemID] [int] NOT NULL,
	[JobName] [nvarchar](50) NOT NULL,
	[UserID] [int] NOT NULL,
	[RequestedStart] [datetime2](7) NOT NULL,
	[JobPriority] [smallint] NOT NULL,
	[JobType] [smallint] NOT NULL,
	[JobParameter] [xml] NOT NULL,
	[JobState] [smallint] NOT NULL,
	[JobStarted] [datetime2](7) NULL,
	[JobTerminated] [datetime2](7) NULL,
	[JobCreated] [datetime2](7) NOT NULL,
	[JobMessage] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contains Error messages or other hints' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'System_JobTable', @level2type=N'COLUMN',@level2name=N'JobMessage'
GO

