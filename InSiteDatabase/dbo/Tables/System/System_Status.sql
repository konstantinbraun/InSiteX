CREATE TABLE [dbo].[System_Status]
(
	[SystemID] INT NOT NULL , 
	[StatusID] INT NOT NULL ,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL, 
    [ResourceID] NVARCHAR(50) NULL, 
    PRIMARY KEY ([SystemID], [StatusID]), 
)
