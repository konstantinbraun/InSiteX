CREATE TABLE [dbo].[System_MailAttachment](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SystemID] [int] NOT NULL,
	[MailID] [int] NOT NULL,
	[DocumentID] [int] NOT NULL,
	[AttachmentRead] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[System_MailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_System_MailAttachment_System_Documents] FOREIGN KEY([DocumentID])
REFERENCES [dbo].[System_Documents] ([Id])
GO

ALTER TABLE [dbo].[System_MailAttachment] CHECK CONSTRAINT [FK_System_MailAttachment_System_Documents]
GO

ALTER TABLE [dbo].[System_MailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_System_MailAttachment_System_Mailbox] FOREIGN KEY([MailID])
REFERENCES [dbo].[System_Mailbox] ([Id])
GO

ALTER TABLE [dbo].[System_MailAttachment] CHECK CONSTRAINT [FK_System_MailAttachment_System_Mailbox]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Referenz zur Mailboxtabelle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'System_MailAttachment', @level2type=N'COLUMN',@level2name=N'MailID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Referenz zur Dokumnettabelle' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'System_MailAttachment', @level2type=N'COLUMN',@level2name=N'DocumentID'
GO

