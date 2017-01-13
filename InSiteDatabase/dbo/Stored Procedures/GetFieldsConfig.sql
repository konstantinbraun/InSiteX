CREATE PROCEDURE [dbo].[GetFieldsConfig]
(
	@SystemID int,
	@BpID int,
	@RoleID int,
	@DialogID int,
	@ActionID int,
	@LanguageID nvarchar(10)
)

AS

SELECT
	rd.IsActive AS DialogIsActive, 
	da.IsActive AS ActionIsActive, 
	da.ActionID,
	af.IsVisible, 
	af.IsEditable, 
	af.IsMandatory, 
	ISNULL(af.DefaultValue, '') DefaultValue, 
	f.InternalName, 
	f.TypeID,
	ISNULL(t.NameTranslated, '') NameTranslated,
	ISNULL(t.DescriptionTranslated, '') DescriptionTranslated,
	f.ResourceID,
	ISNULL(m_tn.NodeID, 0) NodeID
FROM Master_Roles_Dialogs AS rd 
	INNER JOIN Master_Dialogs_Actions AS da 
		ON rd.SystemID = da.SystemID 
			AND rd.BpID = da.BpID 
			AND rd.RoleID = da.RoleID 
			AND rd.DialogID = da.DialogID 
	INNER JOIN Master_Actions_Fields AS af 
		ON da.SystemID = af.SystemID 
			AND da.BpID = af.BpID 
			AND da.RoleID = af.RoleID 
			AND da.DialogID = af.DialogID 
			AND da.ActionID = af.ActionID 
	INNER JOIN System_Fields AS f 
		ON af.SystemID = f.SystemID 
			AND af.DialogID = f.DialogID 
			AND af.FieldID = f.FieldID
	LEFT OUTER JOIN Master_Translations AS t 
		ON af.SystemID = t.SystemID 
			AND af.BpID = t.BpID 
			AND af.DialogID = t.DialogID 
			AND af.FieldID = t.FieldID
	LEFT OUTER JOIN Master_TreeNodes AS m_tn 
		ON rd.SystemID = m_tn.SystemID 
			AND rd.DialogID = m_tn.DialogID 
WHERE rd.SystemID = @SystemID 
	AND rd.BpID = @BpID 
	AND rd.RoleID = @RoleID 
	AND rd.DialogID = @DialogID
	AND da.ActionID = (CASE WHEN @ActionID = 0 THEN da.ActionID ELSE @ActionID END)
	AND (t.LanguageID = @LanguageID OR t.LanguageID IS NULL)
