CREATE PROCEDURE [dbo].[SwitchTariffScopeEastToWest]
(
	@SystemID int,
	@BpID int
)

AS

DECLARE @BpScopeID int;

SELECT @BpScopeID = s_ts_e.ScopeID
FROM Master_BuildingProjects AS m_bp
	INNER JOIN System_TariffScopes AS s_ts_e 
		ON m_bp.SystemID = s_ts_e.SystemID 
			AND m_bp.DefaultTariffScope = s_ts_e.TariffScopeID
;

-- Umsetzung nur, wenn BV auf West (ScopeID = 1) steht!
IF  (@BpScopeID = 1)
	BEGIN
		-- Tarifgebiete umsetzen
		UPDATE Master_CompanyTariffs
		SET TariffScopeID = s_ts_w.TariffScopeID
		FROM Master_CompanyTariffs 
			INNER JOIN System_TariffScopes AS s_ts_e 
				ON Master_CompanyTariffs.SystemID = s_ts_e.SystemID 
					AND Master_CompanyTariffs.TariffScopeID = s_ts_e.TariffScopeID 
			INNER JOIN System_TariffScopes AS s_ts_w 
				ON s_ts_e.SystemID = s_ts_w.SystemID 
					AND s_ts_e.TariffID = s_ts_w.TariffID 
					AND s_ts_e.TariffContractID = s_ts_w.TariffContractID
		WHERE Master_CompanyTariffs.SystemID = @SystemID 
			AND Master_CompanyTariffs.BpID = @BpID 
				AND (s_ts_e.ScopeID = 2 OR s_ts_e.ScopeID = 3) -- Ost und Berlin
				AND s_ts_w.ScopeID = 1 -- West
		;

	END

RETURN @BpScopeID;
