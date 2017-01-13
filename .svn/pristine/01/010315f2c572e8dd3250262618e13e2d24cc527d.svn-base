CREATE TABLE [dbo].[Master_CountryGroups]
(
    [SystemID]         INT            NOT NULL,
    [BpID]             INT            NOT NULL,
    [CountryGroupID] INT NOT NULL IDENTITY,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_Master_CountryGroups] PRIMARY KEY ([SystemID], [BpID], [CountryGroupID]), 
)
