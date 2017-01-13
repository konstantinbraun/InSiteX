CREATE PROCEDURE [dbo].[GetCompanyTariff]
(
	@SystemID int,
	@CompanyID int,
	@TariffScopeID int
)
AS

SELECT        
	s_ct.SystemID, 
	s_ct.CompanyID, 
	s_ts.TariffID, 
	s_ts.TariffContractID, 
	s_ts.TariffScopeID, 
	s_ts.NameVisible AS TariffScopeName, 
	s_ct.ValidFrom, 
	s_tc.NameVisible AS TariffContractName, 
	s_t.NameVisible AS TariffName, 
	s_c.NameVisible AS CompanyName, 
	s_c.NameAdditional AS CompanyNameAdditional, 
    s_ct.EditFrom, 
	s_ct.EditOn
FROM System_CompanyTariffs AS s_ct 
	INNER JOIN System_Companies AS s_c 
		ON s_ct.SystemID = s_c.SystemID 
			AND s_ct.CompanyID = s_c.CompanyID 
	INNER JOIN System_TariffScopes AS s_ts 
		ON s_ct.SystemID = s_ts.SystemID 
			AND s_ct.TariffScopeID = s_ts.TariffScopeID 
	INNER JOIN System_TariffContracts AS s_tc 
		ON s_ts.SystemID = s_tc.SystemID 
			AND s_ts.TariffID = s_tc.TariffID 
			AND s_ts.TariffContractID = s_tc.TariffContractID 
	INNER JOIN System_Tariffs AS s_t 
		ON s_tc.SystemID = s_t.SystemID 
			AND s_tc.TariffID = s_t.TariffID
WHERE s_ct.SystemID = @SystemID 
	AND s_ct.CompanyID = @CompanyID
	AND s_ct.TariffScopeID = @TariffScopeID