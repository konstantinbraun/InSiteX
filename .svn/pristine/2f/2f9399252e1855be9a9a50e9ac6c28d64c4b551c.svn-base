DECLARE @SystemID int = 1, @BpID int = 62;
INSERT INTO Master_CompanyTariffs ([SystemID], BpID, [TariffScopeID], CompanyID, [ValidFrom], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) 
SELECT s_ct.SystemID, @BpID, dbo.BestTariffScope(@SystemID, @BpID, s_ct.TariffScopeID), m_c.CompanyID, s_ct.ValidFrom, s_ct.CreatedFrom, s_ct.CreatedOn, s_ct.EditFrom, s_ct.EditOn 
FROM System_CompanyTariffs s_ct
	INNER JOIN Master_Companies m_c
		ON s_ct.SystemID = m_c.SystemID
			AND s_ct.CompanyID = m_c.CompanyCentralID
WHERE s_ct.SystemID = @SystemID
AND NOT EXISTS (
				SELECT 1
				FROM Master_CompanyTariffs m_ct2
				WHERE m_ct2.SystemID = s_ct.SystemID
					AND m_ct2.BpID = @BpID
					AND m_ct2.CompanyID = m_c.CompanyID
					AND m_ct2.TariffScopeID = dbo.BestTariffScope(@SystemID, @BpID, s_ct.TariffScopeID)
				)
ORDER BY m_c.CompanyID
