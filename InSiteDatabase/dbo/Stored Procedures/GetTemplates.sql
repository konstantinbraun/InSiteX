CREATE PROCEDURE [dbo].[GetTemplates]
(
	@SystemID int,
	@BpID int,
	@DialogName nvarchar(200),
	@WithFileData bit
)
AS

SELECT
	m_t.SystemID,
	m_t.BpID,
	m_t.TemplateID,
	m_t.NameVisible,
	m_t.DescriptionShort,
	m_t."FileName",
	(CASE WHEN @WithFileData = 1 THEN m_t.FileData ELSE NULL END) AS FileData,
	m_t.FileType,
	m_t.DialogID,
	m_t.IsDefault,
	m_t.CreatedFrom,
	m_t.CreatedOn,
	m_t.EditFrom,
	m_t.EditOn	
FROM Master_Templates AS m_t
	INNER JOIN (SELECT DISTINCT SystemID, DialogID, PageName FROM System_Dialogs WHERE SystemID = @SystemID) AS s_d
		ON m_t.SystemID = s_d.SystemID
			AND m_t.DialogID = s_d.DialogID
WHERE m_t.SystemID = @SystemID
	AND m_t.BpID = @BpID
	AND s_d.PageName LIKE '%.' + @DialogName