CREATE TABLE [dbo].[Master_ShortTermPassTypes]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [ShortTermPassTypeID]           INT            IDENTITY (1, 1) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [TemplateID] INT DEFAULT 0 NOT NULL,
    [ValidFrom] INT NOT NULL DEFAULT 0, 
    [ValidDays] INT NOT NULL DEFAULT 0, 
    [ValidHours] INT NOT NULL DEFAULT 0, 
    [ValidMinutes] INT NOT NULL DEFAULT 0, 
    [RoleID]           INT            DEFAULT 0 NOT NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_ShortTermPassTypes] PRIMARY KEY ([SystemID], [BpID], [ShortTermPassTypeID]), 
)
