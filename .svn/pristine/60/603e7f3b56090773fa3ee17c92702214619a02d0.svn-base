CREATE TABLE [dbo].[System_Mailbox](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemID] [int] NOT NULL,
	[Subject] [nvarchar](255) NOT NULL,
	[JobId] [int] NOT NULL,
	[UserID] [int] NOT NULL,
	[Body] VARCHAR(MAX) NOT NULL,
	[MailCreated] [datetime2](7) NOT NULL,
	[MailRead] [datetime2](7) NULL,
[SenderID] INT NOT NULL DEFAULT 0, 
    PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Subject of the message' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'System_Mailbox', @level2type=N'COLUMN',@level2name=N'Subject'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Text of the message' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'System_Mailbox', @level2type=N'COLUMN',@level2name=N'Body'
GO

