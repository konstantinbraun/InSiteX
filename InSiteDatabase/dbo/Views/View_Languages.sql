CREATE VIEW [dbo].[View_Languages]
	AS SELECT DISTINCT LanguageID, LanguageName, '' AS FlagName FROM System_Languages
