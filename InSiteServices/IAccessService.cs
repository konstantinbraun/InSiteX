using InsiteServices.Models;
using System;
using System.Linq;
using System.ServiceModel;

namespace InsiteServices
{
    [ServiceContract]
    public interface IAccessService
    {
        [OperationContract]
        void PutSystemState(int accessSystemID, string authID, int bpID, bool allTerminalsOnline);

        [OperationContract]
        void PutTerminalStatus(int accessSystemID, string authID, TerminalStatus[] status);

        [OperationContract]
        AccessRight[] GetAccessRights(int accessSystemID, string authID, bool initial);

        [OperationContract]
        int PutAccessEvent(int accessSystemID, string authID, AccessEvent[] accessEvents);

        [OperationContract]
        AccessEvent[] GetAccessEvents(int accessSystemID, string authID, int lastID);

        [OperationContract]
        void EmployeeChanged(int systemID, int bpID, int employeeID);

        [OperationContract]
        void CompanyChanged(int systemID, int bpID, int companyID, bool withSubcontractors);

        [OperationContract]
        void RelevantDocumentChanged(int systemID, int bpID, int relevantDocumentID);

        [OperationContract]
        void CountryChanged(int systemID, int bpID, string countryID);

        [OperationContract]
        void DocumentRuleChanged(int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID, int relevantDocumentID);

        [OperationContract]
        void DocumentCheckingRuleChanged(int systemID, int bpID, int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID);

        [OperationContract]
        void TimeSlotChanged(int systemID, int bpID, int timeSlotID);

        [OperationContract]
        void ShortTermPassChanged(int systemID, int bpID, int shortTermPassID);

        [OperationContract]
        bool AllRelevantDocumentsSubmitted(int systemID, int bpID, int employeeID);
    }
}