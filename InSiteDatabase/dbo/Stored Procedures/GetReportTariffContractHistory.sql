CREATE PROCEDURE [dbo].[GetReportTariffContractHistory]
(
	@SystemID int,
	@BpID int,
	@CompanyID int
)
AS

SELECT        
	m_ct.SystemID, 
	m_ct.BpID, 
	m_ct.TariffScopeID, 
	m_ct.CompanyID, 
	m_ct.ValidFrom, 
	m_ct.CreatedFrom, 
	m_ct.CreatedOn, 
	m_ct.EditFrom, 
	m_ct.EditOn, 
	s_t.NameVisible AS NameVisibleTariff, 
	s_tc.NameVisible AS NameVisibleContract, 
    s_ts.NameVisible AS NameTariffScope, 
    s_twg.NameVisible AS WageGroupName,
	s_tw.Wage
FROM Master_CompanyTariffs AS m_ct 
	INNER JOIN System_TariffScopes AS s_ts 
		ON m_ct.SystemID = s_ts.SystemID 
			AND m_ct.TariffScopeID = s_ts.TariffScopeID 
	INNER JOIN System_TariffContracts AS s_tc 
		ON s_ts.SystemID = s_tc.SystemID 
			AND s_ts.TariffID = s_tc.TariffID 
			AND s_ts.TariffContractID = s_tc.TariffContractID 
	INNER JOIN System_Tariffs AS s_t 
		ON s_tc.SystemID = s_t.SystemID 
			AND s_tc.TariffID = s_t.TariffID 
	INNER JOIN System_TariffWageGroups AS s_twg 
		ON s_ts.SystemID = s_twg.SystemID 
			AND s_ts.TariffID = s_twg.TariffID 
			AND s_ts.TariffContractID = s_twg.TariffContractID 
			AND s_ts.TariffScopeID = s_twg.TariffScopeID
	INNER JOIN System_TariffWages AS s_tw
		ON s_twg.SystemID = s_tw.SystemID
			AND s_twg.TariffWageGroupID = s_tw.TariffWageGroupID
WHERE m_ct.SystemID = @SystemID 
	AND m_ct.BpID = @BpID 
	AND m_ct.CompanyID = @CompanyID
ORDER BY m_ct.ValidFrom DESC
