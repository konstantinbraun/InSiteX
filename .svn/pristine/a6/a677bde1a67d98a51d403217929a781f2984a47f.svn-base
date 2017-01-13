CREATE PROCEDURE [dbo].[DeleteBuildingProject]
(
	@SystemID int,
	@BpID int
)
AS

INSERT INTO History_BuildingProjects SELECT * FROM Master_BuildingProjects WHERE SystemID = @SystemID AND BpID = @BpID

DELETE FROM Master_AccessAreas WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_AccessSystems WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Actions_Fields WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Addresses WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_AllowedLanguages WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_AttributesBuildingProject WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_AttributesCompany WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_BuildingProjects WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Companies WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_CompanyAdditions WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_CompanyContacts WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_CompanyTariffs WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_CompanyTrades WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_ConcatActions WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Countries WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_CountryGroups WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Dialogs_Actions WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_DocumentCheckingRules WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_DocumentRules WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_EmployeeAccessAreas WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_EmployeeMinWageAttestation WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_EmployeeQualification WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_EmployeeRelevantDocuments WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Employees WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_EmployeeWageGroupAssignment WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_EmploymentStatus WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_FirstAiders WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Passes WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_RelevantDocuments WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_ReplacementPassCases WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Rights WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Roles WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Roles_Dialogs WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Roles_Users WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_ShortTermPassTypes WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_StaffRoles WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_States WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_TariffContracts WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_TariffData WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Templates WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_TimeSlotGroups WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_TimeSlots WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_TradeGroups WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Trades WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_Translations WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM Master_UserBuildingProjects WHERE SystemID = @SystemID AND BpID = @BpID

DELETE FROM History_AccessAreas WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Actions_Fields WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Addresses WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_AllowedLanguages WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Companies WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Countries WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_CountryGroups WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Dialogs_Actions WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_DocumentCheckingRules WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_DocumentRules WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Employees WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_EmploymentStatus WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_FirstAiders WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_RelevantDocuments WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Roles WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Roles_Dialogs WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_ShortTermPassTypes WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_StaffRoles WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_TariffContracts WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_TariffData WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_TimeSlotGroups WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_TimeSlots WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_TradeGroups WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Trades WHERE SystemID = @SystemID AND BpID = @BpID
DELETE FROM History_Translations WHERE SystemID = @SystemID AND BpID = @BpID
