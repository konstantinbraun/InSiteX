CREATE PROCEDURE [dbo].[GetExpiringTariffs]
	@SystemID int
AS

SELECT        
	System_Tariffs.SystemID, 
	System_Tariffs.TariffID, 
	System_TariffContracts.TariffContractID, 
	System_Tariffs.NameVisible AS TariffName, 
	System_TariffContracts.NameVisible AS TariffContractName, 
	System_TariffContracts.ValidTo
FROM System_Tariffs 
	INNER JOIN System_TariffContracts 
		ON System_Tariffs.SystemID = System_TariffContracts.SystemID 
			AND System_Tariffs.TariffID = System_TariffContracts.TariffID
WHERE System_Tariffs.SystemID = @SystemID 
	AND System_TariffContracts.ValidTo BETWEEN SYSDATETIME() AND DATEADD(MONTH, 3, SYSDATETIME())