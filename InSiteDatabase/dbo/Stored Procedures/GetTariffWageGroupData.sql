CREATE PROCEDURE [dbo].[GetTariffWageGroupData]
(
	@SystemID int,
	@BpID int,
	@CompanyID int,
	@ValidFrom date
)
AS

DECLARE @TariffWages table
(
	SystemID int,
	TariffID int,
	TariffContractID int,
	TariffScopeID int,
	TariffWageGroupID int,
	TariffWageID int,
    NameVisible nvarchar(50),
    DescriptionShort nvarchar(200)
)

WITH cte AS
(
	SELECT 
		s_twg.SystemID,
		s_twg.TariffID,
		s_twg.TariffContractID,
		s_twg.TariffScopeID,
		s_twg.TariffWageGroupID,
		s_tw.TariffWageID,
		s_twg.NameVisible, 
		s_twg.DescriptionShort,
        ROW_NUMBER() OVER (PARTITION BY s_twg.TariffWageGroupID ORDER BY s_tw.ValidFrom DESC) AS rn
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
)
INSERT INTO @TariffWages
(
	SystemID,
	TariffID,
	TariffContractID,
	TariffScopeID,
	TariffWageGroupID,
	TariffWageID,
	NameVisible, 
	DescriptionShort
)
SELECT 
	SystemID,
	TariffID,
	TariffContractID,
	TariffScopeID,
	TariffWageGroupID,
	TariffWageID,
	NameVisible, 
	DescriptionShort
FROM cte
WHERE rn = 1

SELECT 
	TariffWageGroupID,
	NameVisible, 
	DescriptionShort
FROM @TariffWages
ORDER BY NameVisible

RETURN 0
