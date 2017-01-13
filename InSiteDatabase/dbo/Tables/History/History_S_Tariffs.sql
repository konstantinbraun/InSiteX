CREATE TABLE [dbo].[History_S_Tariffs]
(
    [SystemID]         INT            NOT NULL,
    [TariffID]           INT NOT NULL,
    [NameVisible]      NVARCHAR (50)  NULL,
    [DescriptionShort] NVARCHAR (200) NULL,
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    CONSTRAINT [PK_History_S_Tariffs] PRIMARY KEY ([SystemID], [TariffID], [EditOn]), 
)
