CREATE PROCEDURE [dbo].[CreateAlternateTranslations]
	@SystemID int,
	@BpID int,
	@DialogID int,
	@FieldID int,
	@ForeignID int
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
		CreatedFrom,
		CreatedOn,
		EditFrom,
		EditOn
	)
	SELECT
		@SystemID,
		@BpID,
		@DialogID,
		@FieldID,
		@ForeignID,
		l.LanguageID,
		'',
		'',
		'System',
		SYSDATETIME(),
		'System',
		SYSDATETIME()
	FROM Master_AllowedLanguages l
	WHERE l.SystemID = @SystemID
		AND l.BpID = @BpID
		AND NOT EXISTS (
							SELECT 1
							FROM Master_Translations t
							WHERE t.SystemID = @SystemID
								AND t.BpID = @BpID
								AND t.DialogID = @DialogID
								AND t.FieldID = @FieldID
								AND t.ForeignID = @ForeignID
								AND t.LanguageID = l.LanguageID
						)
RETURN 0
