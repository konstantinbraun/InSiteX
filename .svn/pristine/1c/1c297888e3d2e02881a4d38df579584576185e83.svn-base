CREATE PROCEDURE [dbo].[CopyBuildingProject]
(
	@SystemID int,
	@BpIDFrom int,
	@BpIDTo int,
	@UserID int,
	@UserName nvarchar(50)
)
AS

-- Zutrittssystem
INSERT INTO Master_AccessSystems
(
	SystemID,
	BpID,
	AccessSystemID,
	LastUpdate
)
SELECT
	SystemID,
	@BpIDTo,
	AccessSystemID,
	NULL
FROM Master_AccessSystems
WHERE SystemID = @SystemID 
	AND BpID = @BpIDFrom

-- Rollen
INSERT INTO Master_Roles 
(
	SystemID, 
	BpID, 
	NameVisible, 
	DescriptionShort, 
	TypeID, 
	IsVisible, 
	ShowInList,
	SelfAndSubcontractors,
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
) 
SELECT 
	SystemID, 
	@BpIDTo, 
	NameVisible, 
	DescriptionShort, 
	TypeID, 
	IsVisible, 
	ShowInList,
	SelfAndSubcontractors,
	@UserName, 
	SYSDATETIME(), 
	@UserName, 
	SYSDATETIME() 
FROM Master_Roles 
WHERE SystemID = @SystemID 
	AND BpID = @BpIDFrom

-- Rechtedefinitionen
-- Dialoge
INSERT INTO Master_Roles_Dialogs
(
	SystemID, 
	BpID, 
	RoleID, 
	DialogID, 
	UseCompanyAssignment,
	IsActive, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT 
	m_r_d.SystemID, 
	@BpIDTo, 
	m_r_target.RoleID, 
	m_r_d.DialogID, 
	m_r_d.UseCompanyAssignment,
	m_r_d.IsActive, 
	m_r_d.CreatedFrom, 
	m_r_d.CreatedOn, 
	m_r_d.EditFrom, 
	m_r_d.EditOn
FROM Master_Roles_Dialogs AS m_r_d 
	INNER JOIN Master_Roles AS m_r_source 
		ON m_r_d.SystemID = m_r_source.SystemID 
			AND m_r_d.BpID = m_r_source.BpID 
			AND m_r_d.RoleID = m_r_source.RoleID 
	INNER JOIN Master_Roles AS m_r_target 
		ON m_r_source.SystemID = m_r_target.SystemID 
			AND m_r_source.NameVisible = m_r_target.NameVisible
WHERE m_r_d.SystemID = @SystemID 
	AND m_r_d.BpID = @BpIDFrom 
	AND m_r_target.BpID = @BpIDTo

-- Aktionen
INSERT INTO Master_Dialogs_Actions
(
	SystemID, 
	BpID, 
	RoleID, 
	DialogID,
	ActionID, 
	IsActive, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT        
	m_d_a.SystemID, 
	@BpIDTo, 
	m_r_target.RoleID, 
	m_d_a.DialogID, 
	m_d_a.ActionID, 
	m_d_a.IsActive, 
	m_d_a.CreatedFrom, 
	m_d_a.CreatedOn, 
	m_d_a.EditFrom, 
	m_d_a.EditOn
FROM Master_Dialogs_Actions AS m_d_a 
	INNER JOIN Master_Roles AS m_r_source 
		ON m_d_a.SystemID = m_r_source.SystemID 
			AND m_d_a.BpID = m_r_source.BpID 
			AND m_d_a.RoleID = m_r_source.RoleID 
	INNER JOIN Master_Roles AS m_r_target 
		ON m_r_source.SystemID = m_r_target.SystemID 
			AND m_r_source.NameVisible = m_r_target.NameVisible
WHERE m_d_a.SystemID = @SystemID 
	AND m_d_a.BpID = @BpIDFrom 
	AND m_r_target.BpID = @BpIDTo

-- Felder
INSERT INTO Master_Actions_Fields
(
	SystemID, 
	BpID, 
	RoleID, 
	DialogID, 
	ActionID, 
	FieldID, 
	IsVisible, 
	IsEditable, 
	IsMandatory, 
	DefaultValue,
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn 
)
SELECT 
	m_a_f.SystemID, 
	@BpIDTo, 
	m_r_target.RoleID, 
	m_a_f.DialogID, 
	m_a_f.ActionID, 
	m_a_f.FieldID, 
	m_a_f.IsVisible, 
	m_a_f.IsEditable, 
	m_a_f.IsMandatory, 
	m_a_f.DefaultValue,
	m_a_f.CreatedFrom, 
	m_a_f.CreatedOn, 
	m_a_f.EditFrom, 
	m_a_f.EditOn 
FROM Master_Actions_Fields AS m_a_f 
	INNER JOIN Master_Roles AS m_r_source 
		ON m_a_f.SystemID = m_r_source.SystemID 
			AND m_a_f.BpID = m_r_source.BpID 
			AND m_a_f.RoleID = m_r_source.RoleID 
	INNER JOIN Master_Roles AS m_r_target 
		ON m_r_source.SystemID = m_r_target.SystemID 
			AND m_r_source.NameVisible = m_r_target.NameVisible
WHERE m_r_target.BpID = @BpIDTo 
	AND m_a_f.SystemID = @SystemID 
	AND m_a_f.BpID = @BpIDFrom

-- Relevante Dokumente
INSERT INTO Master_RelevantDocuments
(
	SystemID, 
	BpID, 
	RelevantFor, 
	NameVisible, 
	DescriptionShort, 
	IsAccessRelevant, 
	RecExpirationDate, 
	RecIDNumber, 
	SampleFileName, 
	SampleData, 
	CreatedFrom,
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT
	SystemID, 
	@BpIDTo, 
	RelevantFor, 
	NameVisible, 
	DescriptionShort, 
	IsAccessRelevant, 
	RecExpirationDate, 
	RecIDNumber, 
	SampleFileName, 
	SampleData, 
    CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
FROM Master_RelevantDocuments AS m_rd
WHERE SystemID = @SystemID 
	AND BpID = @BpIDFrom

-- Übersetzungen für Felder
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
	SystemID, 
	@BpIDTo, 
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
FROM Master_Translations AS m_t
WHERE SystemID = @SystemID
	AND BpID = @BpIDFrom 
	AND ForeignID = 0 

-- Hinweistexte für relevante Dokumente
INSERT INTO Master_Translations
(
	SystemID, 
	BpID, 
	DialogID, 
	FieldID, 
	LanguageID, 
	NameTranslated, 
	DescriptionTranslated, 
	HtmlTranslated, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn, 
	ForeignID
)
SELECT
	m_t.SystemID, 
	@BpIDTo, 
	m_t.DialogID, 
	m_t.FieldID, 
	m_t.LanguageID, 
	m_t.NameTranslated, 
	m_t.DescriptionTranslated, 
	m_t.HtmlTranslated, 
	m_t.CreatedFrom, 
    m_t.CreatedOn, 
	m_t.EditFrom, 
	m_t.EditOn, 
	m_rd_target.RelevantDocumentID
FROM Master_Translations AS m_t 
	INNER JOIN Master_RelevantDocuments AS m_rd_source 
		ON m_t.SystemID = m_rd_source.SystemID 
			AND m_t.BpID = m_rd_source.BpID 
			AND m_t.ForeignID = m_rd_source.RelevantDocumentID 
	INNER JOIN Master_RelevantDocuments AS m_rd_target 
		ON m_rd_source.SystemID = m_rd_target.SystemID 
			AND m_rd_source.NameVisible = m_rd_target.NameVisible
WHERE m_t.ForeignID > 0 
	AND m_t.BpID = @BpIDFrom 
	AND m_t.SystemID = @SystemID 
	AND m_rd_target.BpID = @BpIDTo

-- Benutzerrechte des anlegenden Benutzers
INSERT INTO Master_UserBuildingProjects 
(
	SystemID, 
	UserID, 
	BpID, 
	RoleID, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
) 
SELECT 
	ubp.SystemID, 
	ubp.UserID, 
	@BpIDTo, 
	rn.RoleID, 
	@UserName, 
	SYSDATETIME(), 
	@UserName, 
	SYSDATETIME() 
FROM Master_UserBuildingProjects AS ubp 
	INNER JOIN Master_Roles AS ro 
		ON ubp.SystemID = ro.SystemID 
			AND ubp.BpID = ro.BpID 
			AND ubp.RoleID = ro.RoleID 
	INNER JOIN Master_Roles AS rn 
		ON ro.NameVisible = rn.NameVisible 
			AND ro.SystemID = rn.SystemID
WHERE ubp.SystemID = @SystemID 
	AND ubp.BpID = @BpIDFrom
	AND ubp.UserID = @UserID
	AND rn.BpID = @BpIDTo

-- Root Rechte kopieren
INSERT INTO Master_UserBuildingProjects 
(
	SystemID, 
	UserID, 
	BpID, 
	RoleID, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
) 
SELECT DISTINCT 
	m_r.SystemID, 
	m_ubp.UserID, 
	@BpIDTo, 
	m_rn.RoleID, 
	@UserName, 
	SYSDATETIME(), 
	@UserName, 
	SYSDATETIME() 
FROM Master_Roles m_r
	INNER JOIN Master_UserBuildingProjects m_ubp
		ON m_r.SystemID = m_ubp.SystemID
			AND m_r.BpID = m_ubp.BpID
			AND m_r.RoleID = m_ubp.RoleID
	INNER JOIN Master_Roles AS m_rn 
		ON m_r.SystemID = m_rn.SystemID
			AND m_r.NameVisible = m_rn.NameVisible 
WHERE m_r.SystemID = @SystemID 
	AND m_r.BpID = @BpIDFrom
	AND m_r.TypeID = 100
	AND m_rn.BpID = @BpIDTo
	AND NOT EXISTS 
	(
		SELECT 1
		FROM Master_UserBuildingProjects m_ubp1
		WHERE m_ubp1.SystemID = m_r.SystemID
			AND m_ubp1.BpID = @BpIDTo
			AND m_ubp1.UserID = m_ubp.UserID
	)

-- Superadmin Rechte kopieren
INSERT INTO Master_UserBuildingProjects 
(
	SystemID, 
	UserID, 
	BpID, 
	RoleID, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
) 
SELECT DISTINCT 
	m_r.SystemID, 
	m_ubp.UserID, 
	@BpIDTo, 
	m_rn.RoleID, 
	@UserName, 
	SYSDATETIME(), 
	@UserName, 
	SYSDATETIME() 
FROM Master_Roles m_r
	INNER JOIN Master_UserBuildingProjects m_ubp
		ON m_r.SystemID = m_ubp.SystemID
			AND m_r.BpID = m_ubp.BpID
			AND m_r.RoleID = m_ubp.RoleID
	INNER JOIN Master_Roles AS m_rn 
		ON m_r.SystemID = m_rn.SystemID
			AND m_r.NameVisible = m_rn.NameVisible 
WHERE m_r.SystemID = @SystemID 
	AND m_r.BpID = @BpIDFrom
	AND m_r.TypeID = 50
	AND m_rn.BpID = @BpIDTo
	AND NOT EXISTS 
	(
		SELECT 1
		FROM Master_UserBuildingProjects m_ubp1
		WHERE m_ubp1.SystemID = m_r.SystemID
			AND m_ubp1.BpID = @BpIDTo
			AND m_ubp1.UserID = m_ubp.UserID
	)

-- Erlaubte Sprachen
INSERT INTO Master_AllowedLanguages
(
	SystemID,
	BpID,
	LanguageID,
	CreatedFrom,
	CreatedOn,
	EditFrom,
	EditOn
)
SELECT
	SystemID,
	@BpIDTo,
	LanguageID,
	@UserName,
	SYSDATETIME(),
	@UserName,
	SYSDATETIME()
FROM Master_AllowedLanguages
WHERE SystemID = @SystemID 
	AND BpID = @BpIDFrom

-- Gewerkegruppen
INSERT INTO Master_TradeGroups
(
	SystemID,
	BpID,
	NameVisible,
	DescriptionShort,
	Position,
	PassColor,
	TemplateID,
	CreatedFrom,
	CreatedOn,
	EditFrom,
	EditOn
)
SELECT
	SystemID,
	@BpIDTo,
	NameVisible,
	DescriptionShort,
	Position,
	PassColor,
	0,
	@UserName,
	SYSDATETIME(),
	@UserName,
	SYSDATETIME()
FROM System_TradeGroupsStatistical
WHERE SystemID = @SystemID 

-- Gewerke
INSERT INTO Master_Trades
(
	SystemID,
	BpID,
	TradeGroupID,
	NameVisible,
	DescriptionShort,
	TradeNumber,
	CostLocationID,
	TradeGroupStatisticalID,
	CreatedFrom,
	CreatedOn,
	EditFrom,
	EditOn
)
SELECT
	s_ts.SystemID,
	@BpIDTo,
	m_tg.TradeGroupID,
	s_ts.NameVisible,
	s_ts.DescriptionShort,
	s_ts.TradeNumber,
	s_ts.CostLocationID,
	s_ts.TradeGroupID,
	@UserName,
	SYSDATETIME(),
	@UserName,
	SYSDATETIME()
FROM System_TradesStatistical AS s_ts 
	INNER JOIN System_TradeGroupsStatistical AS s_tgs 
		ON s_ts.SystemID = s_tgs.SystemID 
			AND s_ts.TradeGroupID = s_tgs.TradeGroupID 
	INNER JOIN Master_TradeGroups AS m_tg 
		ON s_ts.SystemID = m_tg.SystemID 
		AND s_tgs.NameVisible = m_tg.NameVisible 
		AND s_tgs.Position = m_tg.Position
WHERE s_ts.SystemID = @SystemID 
	AND m_tg.BpID = @BpIDTo

-- Ländergruppen
INSERT INTO Master_CountryGroups
(
	SystemID, 
	BpID, 
	NameVisible, 
	DescriptionShort, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT
	SystemID, 
	@BpIDTo, 
	NameVisible, 
	DescriptionShort, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
FROM Master_CountryGroups AS m_cg
WHERE SystemID = @SystemID 
	AND BpID = @BpIDFrom

-- Länder
INSERT INTO Master_Countries
(
	SystemID, 
	BpID, 
	CountryGroupID, 
	CountryID,
	NameVisible, 
	DescriptionShort, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn 
)
SELECT
	m_c.SystemID, 
	@BpIDTo, 
	m_cg_target.CountryGroupID, 
	m_c.CountryID,
	m_c.NameVisible, 
	m_c.DescriptionShort, 
	m_c.CreatedFrom, 
	m_c.CreatedOn, 
	m_c.EditFrom, 
	m_c.EditOn 
FROM Master_Countries AS m_c 
	INNER JOIN Master_CountryGroups AS m_cg_source 
		ON m_c.SystemID = m_cg_source.SystemID 
			AND m_c.BpID = m_cg_source.BpID 
			AND m_c.CountryGroupID = m_cg_source.CountryGroupID 
	INNER JOIN Master_CountryGroups AS m_cg_target 
		ON m_cg_source.SystemID = m_cg_target.SystemID 
			AND m_cg_source.NameVisible = m_cg_target.NameVisible
WHERE m_c.SystemID = @SystemID 
	AND m_c.BpID = @BpIDFrom 
	AND m_cg_target.BpID = @BpIDTo

-- Beschäftigungsstatus
INSERT INTO Master_EmploymentStatus
(
	SystemID, 
	BpID, 
	NameVisible, 
	DescriptionShort, 
	MWObligate, 
	MWFrom, 
	MWTo, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT
	SystemID, 
	@BpIDTo, 
	NameVisible, 
	DescriptionShort, 
	MWObligate, 
	MWFrom, 
	MWTo, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
FROM Master_EmploymentStatus AS m_es
WHERE SystemID = @SystemID 
	AND BpID = @BpIDFrom

-- Dokumentenregeln
INSERT INTO Master_DocumentRules
(
	SystemID, 
	BpID, 
	CountryGroupIDEmployer, 
	CountryGroupIDEmployee, 
	EmploymentStatusID, 
	RelevantDocumentID, 
	RelevantFor, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom,
	EditOn
)
SELECT        
	m_dr.SystemID, 
	@BpIDTo, 
	m_cg_Employer_Target.CountryGroupID, 
	m_cg_Employee_Target.CountryGroupID, 
	m_es_Target.EmploymentStatusID,
	m_rd_Target.RelevantDocumentID, 
	m_dr.RelevantFor, 
	m_dr.CreatedFrom, 
	m_dr.CreatedOn, 
	m_dr.EditFrom, 
	m_dr.EditOn
FROM Master_DocumentRules AS m_dr 
	INNER JOIN Master_CountryGroups AS m_cg_Employer_Source 
		ON m_dr.SystemID = m_cg_Employer_Source.SystemID 
			AND m_dr.BpID = m_cg_Employer_Source.BpID 
			AND m_dr.CountryGroupIDEmployer = m_cg_Employer_Source.CountryGroupID 
	INNER JOIN Master_CountryGroups AS m_cg_Employer_Target 
		ON m_cg_Employer_Source.SystemID = m_cg_Employer_Target.SystemID 
			AND m_cg_Employer_Source.NameVisible = m_cg_Employer_Target.NameVisible 
	INNER JOIN Master_CountryGroups AS m_cg_Employee_Source 
		ON m_dr.SystemID = m_cg_Employee_Source.SystemID 
			AND m_dr.BpID = m_cg_Employee_Source.BpID 
			AND m_dr.CountryGroupIDEmployee = m_cg_Employee_Source.CountryGroupID 
	INNER JOIN Master_CountryGroups AS m_cg_Employee_Target 
		ON m_cg_Employee_Source.SystemID = m_cg_Employee_Target.SystemID 
			AND m_cg_Employee_Source.NameVisible = m_cg_Employee_Target.NameVisible 
	INNER JOIN Master_EmploymentStatus AS m_es_Source 
		ON m_dr.SystemID = m_es_Source.SystemID 
			AND m_dr.BpID = m_es_Source.BpID 
			AND m_dr.EmploymentStatusID = m_es_Source.EmploymentStatusID 
	INNER JOIN Master_EmploymentStatus AS m_es_Target 
		ON m_es_Source.SystemID = m_es_Target.SystemID 
			AND m_es_Source.NameVisible = m_es_Target.NameVisible 
	INNER JOIN Master_RelevantDocuments AS m_rd_Source 
		ON m_dr.SystemID = m_rd_Source.SystemID 
			AND m_dr.BpID = m_rd_Source.BpID 
			AND m_dr.RelevantDocumentID = m_rd_Source.RelevantDocumentID 
	INNER JOIN Master_RelevantDocuments AS m_rd_Target 
		ON m_rd_Source.SystemID = m_rd_Target.SystemID 
			AND m_rd_Source.NameVisible = m_rd_Target.NameVisible
WHERE m_dr.BpID = @BpIDFrom 
	AND m_cg_Employer_Target.BpID = @BpIDTo 
	AND m_cg_Employee_Target.BpID = @BpIDTo 
	AND m_es_Target.BpID = @BpIDTo 
	AND m_rd_Target.BpID = @BpIDTo

-- Dokumentenprüfregeln
INSERT INTO Master_DocumentCheckingRules
(
	SystemID, 
	BpID, 
	CountryGroupIDEmployer, 
	CountryGroupIDEmployee, 
	EmploymentStatusID, 
	CheckingRuleID, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT 
	m_dcr.SystemID, 
	@BpIDTo, 
	m_cg_Employer_Target.CountryGroupID, 
	m_cg_Employee_Target.CountryGroupID, 
	m_es_Target.EmploymentStatusID,
	m_dcr.CheckingRuleID, 
	m_dcr.CreatedFrom, 
	m_dcr.CreatedOn, 
	m_dcr.EditFrom, 
	m_dcr.EditOn
FROM Master_DocumentCheckingRules AS m_dcr 
	INNER JOIN Master_CountryGroups AS m_cg_Employer_Source 
		ON m_dcr.SystemID = m_cg_Employer_Source.SystemID 
			AND m_dcr.BpID = m_cg_Employer_Source.BpID 
			AND m_dcr.CountryGroupIDEmployer = m_cg_Employer_Source.CountryGroupID 
	INNER JOIN Master_CountryGroups AS m_cg_Employer_Target 
		ON m_cg_Employer_Source.SystemID = m_cg_Employer_Target.SystemID 
			AND m_cg_Employer_Source.NameVisible = m_cg_Employer_Target.NameVisible 
	INNER JOIN Master_CountryGroups AS m_cg_Employee_Source 
		ON m_dcr.SystemID = m_cg_Employee_Source.SystemID 
			AND m_dcr.BpID = m_cg_Employee_Source.BpID 
			AND m_dcr.CountryGroupIDEmployee = m_cg_Employee_Source.CountryGroupID 
	INNER JOIN Master_CountryGroups AS m_cg_Employee_Target 
		ON m_cg_Employee_Source.SystemID = m_cg_Employee_Target.SystemID 
			AND m_cg_Employee_Source.NameVisible = m_cg_Employee_Target.NameVisible 
	INNER JOIN Master_EmploymentStatus AS m_es_Source 
		ON m_dcr.SystemID = m_es_Source.SystemID 
			AND m_dcr.BpID = m_es_Source.BpID 
			AND m_dcr.EmploymentStatusID = m_es_Source.EmploymentStatusID 
	INNER JOIN Master_EmploymentStatus AS m_es_Target 
		ON m_es_Source.SystemID = m_es_Target.SystemID 
			AND m_es_Source.NameVisible = m_es_Target.NameVisible
WHERE m_dcr.SystemID = @SystemID 
	AND m_dcr.BpID = @BpIDFrom
	AND m_cg_Employer_Target.BpID = @BpIDTo 
	AND m_cg_Employee_Target.BpID = @BpIDTo 
	AND m_es_Target.BpID = @BpIDTo 

-- Qualifikation
INSERT INTO Master_StaffRoles
(
	SystemID, 
	BpID, 
	NameVisible, 
	DescriptionShort, 
	IsVisible, 
	IsFirstAider, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT 
	SystemID, 
	@BpIDTo, 
	NameVisible, 
	DescriptionShort, 
	IsVisible, 
	IsFirstAider, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
FROM Master_StaffRoles AS m_sr
WHERE SystemID = @SystemID
	AND BpID = @BpIDFrom

-- Ersthelfer
INSERT INTO Master_FirstAiders
(
	SystemID, 
	BpID, 
	DescriptionShort, 
	MaxPresent, 
	MinAiders,
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT
	SystemID, 
	@BpIDTo, 
	DescriptionShort, 
	MaxPresent, 
	MinAiders,
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn 
FROM Master_FirstAiders AS m_fa
WHERE SystemID = @SystemID
	AND BpID = @BpIDFrom

-- Vorlagen
INSERT INTO Master_Templates
(
	SystemID, 
	BpID, 
	NameVisible, 
	DescriptionShort, 
	[FileName],
	FileData,
	FileType, 
	DialogID,
	IsDefault,
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT
	SystemID, 
	@BpIDTo, 
	NameVisible, 
	DescriptionShort, 
	[FileName],
	FileData,
	FileType, 
	DialogID,
	IsDefault,
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
FROM Master_Templates AS m_t
WHERE SystemID = @SystemID 
	AND BpID = @BpIDFrom

-- Kurzzeitausweistypen
INSERT INTO Master_ShortTermPassTypes
(
	SystemID, 
	BpID, 
	DescriptionShort, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn, 
	NameVisible, 
	TemplateID, 
	ValidFrom, 
	ValidDays, 
	ValidHours, 
	ValidMinutes, 
	RoleID
)
SELECT
	m_stpt.SystemID, 
	@BpIDTo, 
	m_stpt.DescriptionShort, 
	m_stpt.CreatedFrom, 
	m_stpt.CreatedOn, 
	m_stpt.EditFrom, 
	m_stpt.EditOn, 
	m_stpt.NameVisible,
	m_t_Target.TemplateID, 
	m_stpt.ValidFrom, 
	m_stpt.ValidDays, 
	m_stpt.ValidHours, 
	m_stpt.ValidMinutes, 
	m_r_Target.RoleID
FROM Master_ShortTermPassTypes AS m_stpt 
	INNER JOIN Master_Roles AS m_r_Source 
		ON m_stpt.SystemID = m_r_Source.SystemID 
			AND m_stpt.BpID = m_r_Source.BpID 
			AND m_stpt.RoleID = m_r_Source.RoleID 
	INNER JOIN Master_Roles AS m_r_Target 
		ON m_r_Source.SystemID = m_r_Target.SystemID 
			AND m_r_Source.NameVisible = m_r_Target.NameVisible 
	INNER JOIN Master_Templates AS m_t_Source 
		ON m_stpt.SystemID = m_t_Source.SystemID 
			AND m_stpt.BpID = m_t_Source.BpID 
			AND m_stpt.TemplateID = m_t_Source.TemplateID 
	INNER JOIN Master_Templates AS m_t_Target 
		ON m_t_Source.SystemID = m_t_Target.SystemID 
			AND m_t_Source.NameVisible = m_t_Target.NameVisible
WHERE m_stpt.SystemID = @SystemID 
	AND m_stpt.BpID = @BpIDFrom 
	AND m_r_Target.BpID = @BpIDTo 
	AND m_t_Target.BpID = @BpIDTo

-- Ersatzausweisfälle
INSERT INTO Master_ReplacementPassCases
(
	SystemID, 
	BpID, 
	NameVisible, 
	DescriptionShort, 
	WillBeCharged, 
	Cost, 
	Currency, 
	InvoiceTo, 
	OldPassInvalid, 
	CreditForOldPass, 
	IsInitialIssue, 
	CreatedFrom, 
    CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT
	SystemID, 
	@BpIDTo, 
	NameVisible, 
	DescriptionShort, 
	WillBeCharged, 
	Cost, 
	Currency, 
	InvoiceTo, 
	OldPassInvalid, 
	CreditForOldPass, 
	IsInitialIssue, 
	CreatedFrom, 
    CreatedOn, 
	EditFrom, 
	EditOn
FROM Master_ReplacementPassCases AS m_rpc
WHERE SystemID = @SystemID 
	AND BpID = @BpIDFrom

RETURN 0
