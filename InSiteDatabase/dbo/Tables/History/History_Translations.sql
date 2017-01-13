CREATE TABLE [dbo].[History_Translations] (
    [SystemID]              INT            NOT NULL,
    [BpID]                  INT            NOT NULL,
    [DialogID]                 INT            DEFAULT ((0)) NOT NULL,
    [FieldID]                 INT            DEFAULT ((0)) NOT NULL,
    [ForeignID] INT NOT NULL DEFAULT 0, 
    [LanguageID]          NVARCHAR(10)       NOT NULL,
    [NameTranslated]        NVARCHAR (50)  NULL,
    [DescriptionTranslated] NVARCHAR (200) NULL,
    [HtmlTranslated] TEXT NULL, 
    [CreatedFrom]           NVARCHAR (50)  NULL,
    [CreatedOn]             DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]              NVARCHAR (50)  NULL,
    [EditOn]                DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_History_Translations] PRIMARY KEY CLUSTERED ([SystemID], [BpID], [DialogID], [FieldID], [ForeignID], [LanguageID], [EditOn])
);

