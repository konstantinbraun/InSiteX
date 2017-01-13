CREATE PROCEDURE [dbo].[GetEmployeeWageGroups]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@ValidFrom date
)

AS

DECLARE @TariffScopeID int;

SELECT TOP 1 @TariffScopeID = TariffScopeID
FROM Master_CompanyTariffs
WHERE SystemID = @SystemID
	AND BpID = @BpID
	AND CompanyID = @CompanyID
	AND ValidFrom <= @ValidFrom
ORDER BY ValidFrom DESC
;

WITH WorkGroup AS
(
	SELECT
		s_twg.TariffWageGroupID, 
		s_twg.NameVisible, 
		s_twg.DescriptionShort,
		s_tw.ValidFrom,
		ROW_NUMBER() OVER(PARTITION BY s_twg.TariffWageGroupID ORDER BY s_tw.ValidFrom DESC) AS rn
	FROM Master_CompanyTariffs AS m_ct 
		INNER JOIN System_TariffWageGroups AS s_twg 
			ON m_ct.SystemID = s_twg.SystemID 
				AND m_ct.TariffScopeID = s_twg.TariffScopeID 
		INNER JOIN System_TariffWages AS s_tw 
			ON s_twg.SystemID = s_tw.SystemID 
				AND s_twg.TariffID = s_tw.TariffID 
				AND s_twg.TariffContractID = s_tw.TariffContractID 
				AND s_twg.TariffScopeID = s_tw.TariffScopeID 
				AND s_twg.TariffWageGroupID = s_tw.TariffWageGroupID 
	WHERE m_ct.SystemID = @SystemID 
		AND m_ct.BpID = @BpID 
		AND m_ct.CompanyID = @CompanyID 
		AND s_tw.ValidFrom <= @ValidFrom
		AND m_ct.TariffScopeID = @TariffScopeID
)
SELECT 
	wg.TariffWageGroupID,
	wg.NameVisible,
	wg.DescriptionShort,
	wg.ValidFrom
FROM WorkGroup AS wg
WHERE wg.rn = 1
ORDER BY wg.NameVisible