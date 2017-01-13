CREATE PROCEDURE [dbo].[GetEmployeePassTemplate]
(
	@SystemID int,
	@BpID int,
	@EmployeeID int,
	@DialogID int
)
AS

DECLARE @TemplateName nvarchar(200)

SELECT @TemplateName = m_t.FileName
FROM Master_Employees AS m_e 
	INNER JOIN Master_AttributesBuildingProject AS m_abp 
		ON m_e.SystemID = m_abp.SystemID 
			AND m_e.BpID = m_abp.BpID 
			AND m_e.AttributeID = m_abp.AttributeID 
	INNER JOIN Master_Templates AS m_t 
		ON m_abp.SystemID = m_t.SystemID 
			AND m_abp.BpID = m_t.BpID 
			AND m_abp.TemplateID = m_t.TemplateID
WHERE m_e.SystemID = @SystemID 
	AND m_e.BpID = @BpID 
	AND m_e.EmployeeID = @EmployeeID

IF (@TemplateName IS NULL OR @TemplateName = '')
	SELECT @TemplateName = m_t.FileName
	FROM Master_Employees AS m_e 
		INNER JOIN Master_Templates AS m_t 
			ON m_e.SystemID = m_t.SystemID 
				AND m_e.BpID = m_t.BpID
	WHERE m_e.SystemID = @SystemID 
		AND m_e.BpID = @BpID 
		AND m_e.EmployeeID = @EmployeeID 
		AND m_t.DialogID = @DialogID 
		AND m_t.IsDefault = 1

SELECT @TemplateName AS TemplateName
