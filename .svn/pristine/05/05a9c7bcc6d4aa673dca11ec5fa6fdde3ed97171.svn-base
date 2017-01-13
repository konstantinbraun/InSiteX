CREATE TABLE [dbo].[Master_Templates]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [TemplateID] INT NOT NULL IDENTITY,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [FileName] NVARCHAR(200) NULL, 
    [FileData] IMAGE NULL, 
    [FileType] NVARCHAR(200) NULL, 
    [DialogID] INT NOT NULL DEFAULT 0, 
    [IsDefault] BIT NOT NULL DEFAULT 0, 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_Templates] PRIMARY KEY ([SystemID], [BpID], [TemplateID]), 
)
