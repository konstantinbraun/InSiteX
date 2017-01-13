UPDATE Master_Roles_Dialogs
SET IsActive = 0
FROM Master_Roles_Dialogs m_r_d
WHERE m_r_d.DialogID = 3117
	AND EXISTS
	(
		SELECT 0
		FROM Master_Roles m_r
		WHERE m_r.SystemID = m_r_d.SystemID
			AND m_r.BpID = m_r_d.BpID
			AND m_r.RoleID = m_r_d.RoleID
			AND m_r.TypeID < 50
	)
