CREATE PROCEDURE [dbo].[GetShortTermPassTemplate]
(
	@SystemID int,
	@BpID int,
	@ShortTermPassTypeID int
)
AS

SELECT        
	m_t.[FileName]
FROM Master_ShortTermPassTypes AS m_stpt 
	INNER JOIN Master_Templates AS m_t 
		ON m_stpt.SystemID = m_t.SystemID 
			AND m_stpt.BpID = m_t.BpID 
			AND m_stpt.TemplateID = m_t.TemplateID
WHERE m_stpt.SystemID = @SystemID
	AND m_stpt.BpID = @BpID 
	AND m_stpt.ShortTermPassTypeID = @ShortTermPassTypeID
