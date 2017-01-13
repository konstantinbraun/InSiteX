CREATE TABLE [dbo].[History_AllowedLanguages]
(
    [SystemID] INT NOT NULL, 
    [BpID] INT NOT NULL, 
	[LanguageID] NVARCHAR(10) NOT NULL , 
    [CreatedFrom]      NVARCHAR (50)  NULL,
    [CreatedOn]        DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [EditFrom]         NVARCHAR (50)  NOT NULL,
    [EditOn]           DATETIME       DEFAULT (sysdatetime()) NOT NULL, 
    PRIMARY KEY ([SystemID], [BpID], [LanguageID], [EditOn])
)
