CREATE TABLE [dbo].[Master_Translations] (
    [SystemID]              INT            NOT NULL,
    [BpID]                  INT            NOT NULL,
    [DialogID]                 INT            CONSTRAINT [DF_Master_Translations_RefID] DEFAULT ((0)) NOT NULL,
    [FieldID]                 INT            CONSTRAINT [DF_Master_Translations_SubID] DEFAULT ((0)) NOT NULL,
    [ForeignID] INT NOT NULL DEFAULT 0, 
    [LanguageID]          NVARCHAR(10)       NOT NULL,
    [NameTranslated]        NVARCHAR (50)  NULL,
    [DescriptionTranslated] NVARCHAR (200) NULL,
    [HtmlTranslated] TEXT NULL, 
    [CreatedFrom]           NVARCHAR (50)  NULL,
    [CreatedOn]             DATETIME       CONSTRAINT [DF_Master_Translations_CreatedOn] DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]              NVARCHAR (50)  NULL,
    [EditOn]                DATETIME       CONSTRAINT [DF_Master_Translations_EditOn] DEFAULT (sysdatetime()) NOT NULL,
    CONSTRAINT [PK_Master_Translations] PRIMARY KEY CLUSTERED ([SystemID], [BpID], [DialogID], [FieldID], [ForeignID], [LanguageID])
);

