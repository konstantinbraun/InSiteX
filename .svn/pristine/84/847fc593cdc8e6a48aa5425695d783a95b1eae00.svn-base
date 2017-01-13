CREATE TABLE [dbo].[Master_AttributesBuildingProject]
(
    [SystemID] INT NOT NULL, 
    [BpID] INT NOT NULL,
	[AttributeID] INT NOT NULL  IDENTITY, 
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [PassColor] NVARCHAR(10) NULL, 
    [TemplateID] INT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    PRIMARY KEY ([SystemID], [BpID], [AttributeID]), 
)
