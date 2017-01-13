CREATE VIEW [dbo].[View_MasterCompanies_Data_PresenceCompany]
	AS 
	SELECT 
		m_c.SystemID,
		m_c.BpID,
		m_c.CompanyID,
		m_c.ParentID,
		d_pc.PresenceDay,
		MAX(CAST(ISNULL(d_pc.CountAs, 0) AS int)) AS CountAs,
		SUM(ISNULL(d_pc.PresenceSeconds, 0)) AS PresenceSeconds
	FROM Master_Companies m_c
		LEFT OUTER JOIN Data_PresenceCompany d_pc
			ON m_c.SystemID = d_pc.SystemID
				AND m_c.BpID = d_pc.BpID
				AND m_c.CompanyID = d_pc.CompanyID
	GROUP BY
		m_c.SystemID,
		m_c.BpID,
		m_c.CompanyID,
		m_c.ParentID,
		d_pc.PresenceDay
		