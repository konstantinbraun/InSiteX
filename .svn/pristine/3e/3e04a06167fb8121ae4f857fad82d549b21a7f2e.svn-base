CREATE TABLE [dbo].[System_Tariffs]
(
    [SystemID]         INT            NOT NULL,
    [TariffID]           INT            IDENTITY (1, 1) NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_System_Tariffs] PRIMARY KEY ([SystemID], [TariffID]), 
)
