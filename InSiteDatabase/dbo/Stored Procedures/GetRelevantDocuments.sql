CREATE PROCEDURE [dbo].[GetRelevantDocuments]
(
	@SystemID int,
	@BpID int,
	@RelevantDocumentID int = 0,
	@LanguageID nvarchar(10) 
)
AS

DECLARE @CountLanguage int = 0
DECLARE @UsedLanguageID nvarchar(10) = 'en-GB'

SELECT @CountLanguage = COUNT(LanguageID)
FROM Master_AllowedLanguages
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND LanguageID = @LanguageID

IF (@CountLanguage > 0)
	SET @UsedLanguageID = @LanguageID

SELECT
	m_rd.SystemID, 
	m_rd.BpID, 
	m_rd.RelevantDocumentID, 
	m_rd.NameVisible, 
	m_tr1.DescriptionTranslated AS ToolTipExpiration, 
	m_tr2.DescriptionTranslated AS ToolTipDocumentID, 
	m_rd.RelevantFor, 
	m_rd.DescriptionShort, 
	m_rd.IsAccessRelevant, 
	m_rd.RecExpirationDate, 
	m_rd.RecIDNumber, 
	m_rd.SampleFileName, 
	m_rd.SampleData, 
	m_rd.CreatedFrom, 
	m_rd.CreatedOn, 
	m_rd.EditFrom, 
	m_rd.EditOn
FROM Master_RelevantDocuments AS m_rd 
	INNER JOIN Master_Translations AS m_tr2
		ON m_tr2.SystemID = m_rd.SystemID 
			AND m_tr2.BpID = m_rd.BpID 
			AND m_tr2.ForeignID = m_rd.RelevantDocumentID 
	INNER JOIN Master_Translations AS m_tr1 
		ON m_rd.SystemID = m_tr1.SystemID 
			AND m_rd.BpID = m_tr1.BpID 
			AND m_rd.RelevantDocumentID = m_tr1.ForeignID
WHERE m_rd.SystemID = @SystemID 
	AND m_rd.BpID = @BpID 
	AND m_rd.RelevantDocumentID = (CASE WHEN @RelevantDocumentID = 0 THEN m_rd.RelevantDocumentID ELSE @RelevantDocumentID END) 
	AND m_tr1.FieldID = 13 
	AND m_tr2.DialogID = 6 
	AND m_tr2.FieldID = 14 
	AND m_tr1.LanguageID = @UsedLanguageID 
	AND m_tr2.LanguageID = @UsedLanguageID 
