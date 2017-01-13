CREATE PROCEDURE [dbo].[GetEmployeeRelevantDocuments]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int,
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
	m_erd.SystemID, 
	m_erd.BpID, 
	m_erd.EmployeeID, 
	m_erd.RelevantFor, 
	m_erd.RelevantDocumentID, 
	m_rd.NameVisible, 
	m_erd.DocumentReceived, 
	m_erd.ExpirationDate, 
	m_erd.IDNumber, 
	m_tr1.DescriptionTranslated AS ToolTipExpiration, 
	m_tr2.DescriptionTranslated AS ToolTipDocumentID, 
	ISNULL(m_rd.IsAccessRelevant, 0) AS IsAccessRelevant, 
	m_erd.CreatedFrom, 
	m_erd.CreatedOn, 
	m_erd.EditFrom, 
	m_erd.EditOn, 
	ISNULL(m_rd.RecExpirationDate, 0) RecExpirationDate, 
	ISNULL(m_rd.RecIDNumber, 0) RecIDNumber,
	m_rd.SampleData 
FROM Master_EmployeeRelevantDocuments AS m_erd 
	LEFT OUTER JOIN Master_RelevantDocuments AS m_rd 
		ON m_rd.SystemID = m_erd.SystemID 
			AND m_rd.BpID = m_erd.BpID 
			AND m_rd.RelevantDocumentID = m_erd.RelevantDocumentID 
	LEFT OUTER JOIN Master_Translations AS m_tr1 
		ON m_rd.SystemID = m_tr1.SystemID 
			AND m_rd.BpID = m_tr1.BpID 
			AND m_rd.RelevantDocumentID = m_tr1.ForeignID 
	LEFT OUTER JOIN Master_Translations AS m_tr2 
		ON m_tr2.SystemID = m_rd.SystemID 
			AND m_tr2.BpID = m_rd.BpID 
			AND m_tr2.ForeignID = m_rd.RelevantDocumentID 
WHERE m_erd.SystemID = @SystemID 
	AND m_erd.BpID = @BpID 
	AND m_erd.EmployeeID = @EmployeeID 
	AND ((m_tr1.DialogID = 6 
			AND m_tr1.FieldID = 13 
			AND m_tr2.DialogID = 6 
			AND m_tr2.FieldID = 14 
			AND m_tr1.LanguageID = @UsedLanguageID 
			AND m_tr2.LanguageID = @UsedLanguageID) 
		OR (m_tr1.DialogID IS NULL 
			AND m_tr1.FieldID IS NULL 
			AND m_tr2.DialogID IS NULL 
			AND m_tr2.FieldID IS NULL 
			AND m_tr1.LanguageID IS NULL 
			AND m_tr2.LanguageID IS NULL)) 

