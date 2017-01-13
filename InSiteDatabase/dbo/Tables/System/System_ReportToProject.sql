CREATE TABLE [dbo].[System_ReportToProject](
	[ReportToProjectId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NOT NULL,
	[BpID] [int] NOT NULL,
	[SystemID] [int] NOT NULL,
 CONSTRAINT [PK_System_ReportProject] PRIMARY KEY CLUSTERED 
(
	[ReportToProjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_System_ReportProject_System_ReportProject] FOREIGN KEY([ReportId]) REFERENCES [dbo].[System_Reports] ([ReportId]) ON DELETE CASCADE, 
    CONSTRAINT [FK_System_ReportToProject_Master_BuildingProjects] FOREIGN KEY([SystemID], [BpID]) REFERENCES [dbo].[Master_BuildingProjects] ([SystemID], [BpID]) ON UPDATE CASCADE ON DELETE CASCADE, 
) ON [PRIMARY]

GO

