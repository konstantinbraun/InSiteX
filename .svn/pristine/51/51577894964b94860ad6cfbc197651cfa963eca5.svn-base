BEGIN TRANSACTION

INSERT INTO Master_CompanyTariffs
(
	SystemID, 
	BpID, 
	TariffScopeID, 
	CompanyID, 
	ValidFrom, 
	CreatedFrom, 
	CreatedOn, 
	EditFrom, 
	EditOn
)
SELECT        
	m_c.SystemID, 
	m_c.BpID, 
	dbo.BestTariffScope(m_c.SystemID, m_c.BpID, MAX(s_ct.TariffScopeID)) AS BestTariffScope, 
	m_c.CompanyID, 
	MAX(s_ct.ValidFrom), 
	'System', 
	SYSDATETIME(), 
	'System', 
	SYSDATETIME()
FROM Master_Companies m_c
	INNER JOIN System_CompanyTariffs s_ct
		ON m_c.SystemID = s_ct.SystemID
			AND m_c.CompanyCentralID = s_ct.CompanyID
WHERE m_c.SystemID = 1 
	AND NOT EXISTS
    (
		SELECT 1
        FROM Master_CompanyTariffs AS m_ct
        WHERE m_ct.SystemID = m_c.SystemID 
			AND m_ct.CompanyID = m_c.CompanyID 
			AND m_ct.TariffScopeID = dbo.BestTariffScope(m_c.SystemID, m_c.BpID, s_ct.TariffScopeID)
	)
GROUP BY
	m_c.SystemID, 
	m_c.BpID, 
	m_c.CompanyID
ORDER BY
	m_c.SystemID, 
	m_c.BpID, 
	m_c.CompanyID, 
	BestTariffScope


ROLLBACK TRANSACTION

COMMIT TRANSACTION
