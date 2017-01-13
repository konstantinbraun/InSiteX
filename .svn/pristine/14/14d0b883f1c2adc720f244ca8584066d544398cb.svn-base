CREATE PROCEDURE [dbo].[CreateFieldsTranslations]
	@SystemID int,
	@BpID int = 0
AS

	INSERT INTO Master_Translations
	(
		SystemID,
		BpID,
		DialogID,
		FieldID,
		ForeignID,
		LanguageID,
		NameTranslated,
		DescriptionTranslated,
		HtmlTranslated,
		CreatedFrom,
		CreatedOn,
		EditFrom,
		EditOn
	)
	SELECT
		f.SystemID,
		l.BpID,
		f.DialogID,
		f.FieldID,
		0,
		l.LanguageID,
		'',
		'',
		'',
		'System',
		SYSDATETIME(),
		'System',
		SYSDATETIME()
	FROM System_Fields f, 
		Master_AllowedLanguages l,
		System_Dialogs sd
	WHERE f.SystemID = @SystemID
		AND l.SystemID = f.SystemID
		AND l.BpID = (CASE WHEN @BpID = 0 THEN l.BpID ELSE @BpID END)
		AND sd.SystemID = f.SystemID
		AND sd.DialogID = f.DialogID
		AND (sd.UseFieldRights = 1 OR sd.TranslationOnly = 1)
		AND NOT EXISTS (
							SELECT 1
							FROM Master_Translations t
							WHERE t.SystemID = f.SystemID
								AND t.BpID = l.BpID
								AND t.DialogID = f.DialogID
								AND t.FieldID = f.FieldID
								AND t.ForeignID = 0
								AND t.LanguageID = l.LanguageID
						)

	SELECT @@ROWCOUNT AS Master_Translations_Count

RETURN 0
