CREATE PROCEDURE [dbo].[CreateRightsHierarchy]
	@SystemID int,
	@BpID int = 0
AS
	-- Insert all not existing dialogs for all roles
	INSERT INTO Master_Roles_Dialogs
	(
		SystemID,
		BpID,
		RoleID,
		DialogID,
		IsActive,
		CreatedFrom,
		CreatedOn,
		EditFrom,
		EditOn
	)
	SELECT 
		r.SystemID,
		r.BpID,
		r.RoleID,
		d.DialogID,
		d.IsVisible,
		'System',
		SYSDATETIME(),
		'System',
		SYSDATETIME()
	FROM Master_Roles r, 
		System_Dialogs d
	WHERE r.SystemID = @SystemID
		AND r.BpID = (CASE WHEN @BpID = 0 THEN r.BpID ELSE @BpID END)
		AND d.SystemID = r.SystemID
		AND d.TranslationOnly = 0
		AND NOT EXISTS (
							SELECT 1
							FROM Master_Roles_Dialogs d1
							WHERE d1.SystemID = r.SystemID
								AND d1.BpID = r.BpID
								AND d1.RoleID = r.RoleID
								AND d1.DialogID = d.DialogID
						)

	SELECT @@ROWCOUNT AS Master_Roles_Dialogs_Count

	-- Insert all not existing actions for all dialogs
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
	SELECT DISTINCT
		d.SystemID,
		d.BpID,
		d.RoleID,
		d.DialogID,
		a.ActionID,
		1,
		'System',
		SYSDATETIME(),
		'System',
		SYSDATETIME()
	FROM Master_Roles_Dialogs d,
		System_Actions a,
		System_Dialogs sd
	WHERE d.SystemID = @SystemID
		AND d.BpID = (CASE WHEN @BpID = 0 THEN d.BpID ELSE @BpID END)
		AND a.SystemID = d.SystemID
		AND a.IsRightRelevant = 1
		AND sd.SystemID = d.SystemID
		AND sd.DialogID = d.DialogID
		AND sd.UseFieldRights = 1
		AND NOT EXISTS (
							SELECT 1
							FROM Master_Dialogs_Actions a1
							WHERE a1.SystemID = d.SystemID
								AND a1.BpID = d.BpID
								AND a1.RoleID = d.RoleID
								AND a1.DialogID = d.DialogID
								AND a1.ActionID = a.ActionID
						)

	SELECT @@ROWCOUNT AS Master_Dialogs_Actions_Count

	-- Insert all not existing fields for all actions
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
		a.SystemID,
		a.BpID,
		a.RoleID,
		a.DialogID,
		a.ActionID,
		f.FieldID,
		f.IsVisible,
		1,
		f.IsMandatory,
		f.DefaultValue,
		'System',
		SYSDATETIME(),
		'System',
		SYSDATETIME()
	FROM Master_Dialogs_Actions a,
		System_Fields f,
		System_Dialogs d
	WHERE a.SystemID = @SystemID
		AND a.BpID = (CASE WHEN @BpID = 0 THEN a.BpID ELSE @BpID END)
		AND f.SystemID = a.SystemID
		AND f.DialogID = a.DialogID
		AND d.SystemID = a.SystemID
		AND d.DialogID = a.DialogID
		AND d.UseFieldRights = 1
		AND NOT EXISTS (
							SELECT 1
							FROM Master_Actions_Fields f1
							WHERE f1.SystemID = a.SystemID
								AND f1.BpID = a.BpID
								AND f1.RoleID = a.RoleID
								AND f1.DialogID = a.DialogID
								AND f1.ActionID = a.ActionID
								AND f1.FieldID = f.FieldID
						)

	SELECT @@ROWCOUNT AS Master_Actions_Fields_Count

RETURN 0
