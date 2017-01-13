using System;
using System.Linq;
using System.Net;
using System.ServiceModel;

namespace InsiteServices
{
    [ServiceContract]
    public interface IContainerManagement
    {
        [OperationContract]
        string EmployeeData(int systemID, int bpID, int employeeID, int dataAction);

        [OperationContract]
        string CompanyData(int systemID, int bpID, int companyID, int dataAction);

        [OperationContract]
        string TradeData(int systemID, int bpID, int tradeID, int dataAction);
    }
}
