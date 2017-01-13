using InsiteServices.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.ServiceModel;

namespace InsiteServices
{
    [ServiceContract]
    public interface IUserService
    {
        [OperationContract]
        UserAssignments[] Login(string userName, string passWord, string sessionID);

        [OperationContract]
        int UpdateUser(string columnName, string columnValue, int userID, string sessionID);

        [OperationContract]
        int UpdatePwd(string oldPwd, string newPwd, int userID, string sessionID, string userName, bool ignore, bool needsPwdChange);

        [OperationContract]
        Master_BuildingProjects GetBpInfo(int bpID, string sessionID);

        [OperationContract]
        Master_BuildingProjects[] GetAllBpsInfo(string sessionID);

        [OperationContract]
        GetFieldsConfig_Result[] GetFieldsConfig(int systemID, int bpID, int roleID, int dialogID, int actionID, string languageID, string sessionID);

        [OperationContract]
        PrintPass_Result PrintPass(int systemID, int bpID, int employeeID, int replacementPassCaseID, string reason, string userName, string deactivationMessage, string sessionID);

        [OperationContract]
        int ActivatePass(int systemID, int bpID, int employeeID, string internalID, string userName, string sessionID);

        [OperationContract]
        int DeactivatePass(int systemID, int bpID, int employeeID, string internalID, string reason, string userName, string sessionID);

        [OperationContract]
        int LockPass(int systemID, int bpID, int employeeID, string reason, string userName, string sessionID);

        [OperationContract]
        bool IsFirstPass(int systemID, int bpID, int employeeID, string sessionID);

        [OperationContract]
        EmployeeRegistrationData ValidateRegistrationCode(string code, string sessionID);

        [OperationContract]
        bool LoginNameIsUnique(string loginName, string sessionID);

        [OperationContract]
        UserAssignments[] GetUsersWithRole(int systemID, int bpID, int typeID, string sessionID);

        [OperationContract]
        int GetAppliedRule(int systemID, int bpID, int employeeID, string sessionID);

        [OperationContract]
        UserAssignments GetUserWithLoginName(string loginName, string sessionID);

        [OperationContract]
        int GetNextID(int systemID, string idName, string sessionID);

        [OperationContract]
        int PrintShortTermPasses(int systemID, int bpID, int shortTermPassTypeID, int passCount, string userName, string sessionID);

        [OperationContract]
        int UpdateShortTermPass(int systemID, int bpID, int shortTermPassID, string internalID, string userName, string sessionID);

        [OperationContract]
        ShortTermPass GetShortTermPass(int systemID, int bpID, string internalID, string sessionID);

        [OperationContract]
        int GetTreeNodeID(int systemID, string dialogName, string sessionID);

        [OperationContract]
        int GetDialogID(int systemID, string dialogName, string sessionID);

        [OperationContract]
        int RowCount(string tableName, Tuple<string, int>[] whereInt, Tuple<string, string>[] whereString, string sessionID);

        [OperationContract]
        GetCompanyStatistics_Result GetCompanyStatistics(int systemID, int bpID, int companyID, string sessionID);

        [OperationContract]
        GetEmployees_Result[] GetEmployees(int systemID, int bpID, int companyCentralID, int companyID, int employeeID, string externalPassID, int employmentStatusID, int tradeID, int userID, string sessionID);

        [OperationContract]
        void CreateAccessRightEvent(Data_AccessRightEvents rightEvent, Data_AccessAreaEvents[] areaEvents, string deactivationMessage, string sessionID);

        [OperationContract]
        GetEmployeeAccessAreas_Result[] GetEmployeeAccessAreas(int systemID, int bpID, int employeeID, string sessionID);

        [OperationContract]
        HasValidDocumentRelevantFor_Result[] HasValidDocumentRelevantFor(int systemID, int bpID, int employeeID, string sessionID);

        [OperationContract]
        GetAccessRightEvents_Result[] GetAccessRightEvents(int systemID, int bpID, int employeeID, bool newestOnly, string sessionID);

        [OperationContract]
        GetAccessAreaEvents_Result[] GetAccessAreaEvents(int systemID, int bpID, int accessRightEventID, string sessionID);

        [OperationContract]
        GetRelevantDocuments_Result[] GetRelevantDocuments(int systemID, int bpID, int relevantDocumentID, string languageID, string sessionID);

        [OperationContract]
        GetEmployeeRelevantDocuments_Result[] GetEmployeeRelevantDocuments(int systemID, int bpID, int employeeID, string languageID, string sessionID);

        [OperationContract]
        GetEmployeesWithTimeSlot_Result[] GetEmployeesWithTimeSlot(int systemID, int bpID, int timeSlotID, string sessionID);

        [OperationContract]
        GetEmployeesWithRelevantDocument_Result[] GetEmployeesWithRelevantDocument(int systemID, int bpID, int relevantDocumentID, string sessionID);

        [OperationContract]
        int?[] GetEmployeesWithCountry(int systemID, int bpID, string countryID, string sessionID);

        [OperationContract]
        int?[] GetEmployeesWithEmploymentStatus(int systemID, int bpID, int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID, string sessionID);

        [OperationContract]
        GetShortTermPasses_Result[] GetShortTermPasses(int systemID, int bpID, int shortTermPassID, string sessionID);

        [OperationContract]
        GetVisitorAccessAreas_Result[] GetVisitorAccessAreas(int systemID, int bpID, int shortTermVisitorID, string sessionID);

        [OperationContract]
        GetEmployeeRelevantDocumentsToAdd_Result[] GetEmployeeRelevantDocumentsToAdd(int systemID, int bpID, int employeeID, int relevantFor, string sessionID);

        [OperationContract]
        GetCompanyAdminUser_Result[] GetCompanyAdminUser(int systemID, int companyCentralID, string sessionID);

        [OperationContract]
        GetCompanyAdminUserWithBP_Result[] GetCompanyAdminUserWithBP(int systemID, int bpID, int companyID, string sessionID);

        [OperationContract]
        GetLockedMainContractor_Result[] GetLockedMainContractor(int systemID, int bpID, int companyID, string sessionID);

        [OperationContract]
        GetSubContractors_Result[] GetSubContractors(int systemID, int bpID, int companyID, string sessionID);

        [OperationContract]
        int GetEmployeePassStatus(int systemID, int bpID, int employeeID, string sessionID);

        [OperationContract]
        int SetProcessEvent(Data_ProcessEvents eventData, string fieldName, Tuple<string, string>[] values, string sessionID);

        [OperationContract]
        int ProcessEventDone(Data_ProcessEvents eventData, string sessionID);

        [OperationContract]
        string GetDialogResID(int systemID, int dialogID, string sessionID);

        [OperationContract]
        string GetBpName(int systemID, int bpID, string sessionID);

        [OperationContract]
        string GetCompanyName(int systemID, int companyID, string sessionID);

        [OperationContract]
        string GetBpCompanyName(int systemID, int bpID, int companyID, string sessionID);

        [OperationContract]
        int GetUnreadMailCount(int systemID, int userID, string sessionID);

        [OperationContract]
        int GetOpenProcessCount(int systemID, int bpID, int userID, string sessionID);

        [OperationContract]
        Master_Roles[] GetRoles(int systemID, int bpID, int typeID, string sessionID);

        [OperationContract]
        int GetDefaultRoleID(int systemID, int bpID, string sessionID);

        [OperationContract]
        Master_AccessAreas[] GetAccessAreas(int systemID, int bpID, string sessionID);

        [OperationContract]
        int GetDefaultAccessAreaID(int systemID, int bpID, string sessionID);

        [OperationContract]
        Master_TimeSlotGroups[] GetTimeSlotGroups(int systemID, int bpID, string sessionID);

        [OperationContract]
        int GetDefaultTimeSlotGroupID(int systemID, int bpID, string sessionID);

        [OperationContract]
        int GetDefaultSTAccessAreaID(int systemID, int bpID, string sessionID);

        [OperationContract]
        int GetDefaultSTTimeSlotGroupID(int systemID, int bpID, string sessionID);

        [OperationContract]
        int SetDefaultAccessAreaForUser(Master_EmployeeAccessAreas accessArea, string sessionID);

        [OperationContract]
        int SetDefaultAccessAreaForVisitor(Data_ShortTermAccessAreas accessArea, string sessionID);

        [OperationContract]
        Master_Passes GetPassData(int systemID, int bpID, string chipID, string sessionID);

        [OperationContract]
        System_Variables[] GetVariables(int systemID, int fieldID, string sessionID);

        [OperationContract]
        int GetFieldID(int systemID, string fieldName, string sessionID);

        [OperationContract]
        System_Variables[] GetVariablesByFieldName(int systemID, string fieldName, string sessionID);

        [OperationContract]
        Master_Translations GetTranslation(int systemID, int bpID, string fieldName, string languageIDUser, string languageIDClient, Tuple<string, string>[] values, string sessionID);

        [OperationContract]
        GetShortTermVisitors_Result[] GetShortTermVisitors(int systemID, int bpID, string sessionID);

        [OperationContract]
        System_Tables[] GetHistoryTables(string sessionID);

        [OperationContract]
        Master_Users[] GetUsers(int systemID, string sessionID);

        [OperationContract]
        GetPresentPersonsCount_Result GetPresentPersonsCount(int systemID, int bpID, string sessionID);

        [OperationContract]
        GetPassBillings_Result[] GetPassBillings(int systemID, int bpID, int companyID, int evaluationPeriod, DateTime dateFrom, DateTime dateUntil, int level, string remarks, string sessionID);

        [OperationContract]
        GetTariffData_Result[] GetTariffData(int systemID, int tariffID, int tariffContractID, int tariffScopeID, int bpID, int companyID, DateTime dateFrom, DateTime dateUntil, int reportType, string sessionID);

        [OperationContract]
        GetPresenceData_Result[] GetPresenceData(
            int systemID,
            int bpID,
            int companyID,
            DateTime dateFrom,
            DateTime dateUntil,
            bool nameIsVisible,
            int companyLevel,
            int compressLevel,
            string sessionID);

        [OperationContract]
        GetPresenceDataNow_Result[] GetPresenceDataNow(
            int systemID,
            int bpID,
            int companyID,
            int companyLevel,
            int accessAreaID,
            DateTime presenceDay,
            bool presentOnly,
            string sessionID);

        [OperationContract]
        GetTradeReportData_Result[] GetTradeReportData(
            int systemID,
            int bpID,
            DateTime dateFrom,
            DateTime dateUntil,
            string sessionID);

        [OperationContract]
        GetTemplates_Result[] GetTemplates(
            int systemID,
            int bpID,
            string dialogName,
            bool withFileData,
            string sessionID);

        [OperationContract]
        Master_Templates GetTemplate(
            int systemID,
            int bpID,
            int templateID,
            string sessionID);

        [OperationContract]
        int SendMessage(int systemID, int jobID, int receiverID, string subject, string body, string sessionID);

        [OperationContract]
        int SendMessageToUsersWithRight(int systemID, int bpID, int jobID, int dialogID, int actionID, string subject, string body, string sessionID);

        [OperationContract]
        GetCompanyTariff_Result GetCompanyTariff(int systemID, int companyID, int tariffScopeID, string sessionID);

        [OperationContract]
        GetReportMinWageData_Result[] GetReportMinWageData(
            int systemID,
            int bpID,
            DateTime monthFrom,
            DateTime monthUntil,
            int companyID,
            string sessionID);

        [OperationContract]
        GetCompanyInfo_Result[] GetCompanyInfo(
            int systemID,
            int bpID,
            int companyID,
            string sessionID);

        [OperationContract]
        GetMWAttestationRequests_Result[] GetMWAttestationRequests(
            int systemID,
            int bpID,
            int companyID,
            int requestID,
            string sessionID);

        [OperationContract]
        System_Dialogs GetDialog(int systemID, int dialogID, string sessionID);

        [OperationContract]
        Pass GetPass(int systemID, int bpID, int employeeID, bool withFileData, string sessionID);

        [OperationContract]
        ShortTermPassPrint GetShortTermPassPrint(int systemID, int bpID, int printID, string sessionID);

        [OperationContract]
        Master_Users GetUser(int systemID, int userID, string sessionID);

        [OperationContract]
        string GetShortTermPassTemplate(int systemID, int bpID, int shortTermPassTypeID, string sessionID);

        [OperationContract]
        string GetEmployeePassTemplate(int systemID, int bpID, int employeeID, int dialogID, string sessionID);

        [OperationContract]
        GetPresentPersonsPerAccessArea_Result[] GetPresentPersonsPerAccessArea(int systemID, int bpID, string sessionID);

        [OperationContract]
        GetMissingFirstAiders_Result[] GetMissingFirstAiders(int systemID, int bpID, string sessionID);

        [OperationContract]
        Master_AccessSystems GetLastUpdateAccessControl(int systemID, int bpID, string sessionID);

        [OperationContract]
        DateTime GetLastBackupDate(string sessionID);

        [OperationContract]
        DateTime GetLastCompressDate(int systemID, int bpID, string sessionID);

        [OperationContract]
        GetPassInfo_Result[] GetPassInfo(string internalID, string sessionID);

        [OperationContract]
        Master_CompanyContacts GetCompanyMWContact(int systemID, int bpID, int companyID, string sessionID);

        [OperationContract]
        Master_Users GetCompanyAdmin(int systemID, int companyID, string sessionID);

        [OperationContract]
        bool HasRightForDialog(int systemID, int bpID, int dialogID, int roleID, string sessionID);

        [OperationContract]
        byte[] GetRelevantDocumentImage(int systemID, int bpID, int relevantDocumentID, int maxWidth, int maxHeight, string sessionID);

        [OperationContract]
        void SetMailRead(int systemID, int mailID, bool mailRead, string sessionID);

        [OperationContract]
        Document GetDocument(int systemID, int documentID, string sessionID);

        [OperationContract]
        Document RenderReport(string reportParameter, string sessionID);

        [OperationContract]
        int SetAttachmentToMessage(int systemID, int jobID, int messageID, byte[] fileData, string fileName, string fileType, string sessionID);

        [OperationContract]
        System_Help GetHelp(int systemID, int dialogID, int fieldID, string languageID, string sessionID);

        [OperationContract]
        GetExpiringTariffs_Result[] GetExpiringTariffs(int systemID, string sessionID);

        [OperationContract]
        void SessionLogger(string sessionID, int sessionState, int? systemID, int? userID);

        [OperationContract]
        bool IsPassCaseFirstIssue(int systemID, int bpID, int replacementPassCaseID, string sessionID);

        [OperationContract]
        bool AllTerminalsOnline(int systemID, int bpID, string sessionID);

        [OperationContract]
        GetEmployeeDuplicates_Result[] GetEmployeeDuplicates(int systemID, int bpID, int employeeID, string sessionID);

        [OperationContract]
        GetCompanyCentralDuplicates_Result[] GetCompanyCentralDuplicates(int systemID, int companyID, string sessionID);

        [OperationContract]
        GetUserDuplicates_Result[] GetUserDuplicates(int systemID, int userID, string sessionID);

        [OperationContract]
        System_Companies GetCompanyCentralInfo(int systemID, int companyID, string sessionID);

        [OperationContract]
        DateTime GetLastCorrectionDate(int systemID, int bpID, string sessionID);

        [OperationContract]
        int GetMainContractorStatus(int systemID, int bpID, int companyID, string sessionID);

        [OperationContract]
        void UpdateThumbnails(int systemID, int bpID, string sessionID);

        [OperationContract]
        byte[] GetEmployeePhotoData(int systemID, int bpID, int employeeID, string sessionID);

        [OperationContract]
        bool EmploymentStatusMWObligate(int systemID, int bpID, int employmentStatusID, string sessionID);

        [OperationContract]
        List<GetPresentFirstAiders_Result> GetAvailableFirstAiders(int systemID, int bpID);

        [OperationContract]
        List<Data_AccessEvents> GetAccessHistoryForShortTermPasses(int systemId, int bpId, string internalId);
    }
}