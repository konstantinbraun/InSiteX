using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;

namespace InsiteServices
{
    [ServiceContract]
    public interface IAdminService
    {
        [OperationContract]
        void CompressPresenceData(string schedulerID);

        [OperationContract]
        void DatabaseBackup(string schedulerID);

        [OperationContract]
        DateTime GetLastBackupDate(string schedulerID);

        [OperationContract]
        System_Jobs GetJob(int systemID, int jobID);

        [OperationContract]
        bool UpdateJob(System_Jobs job);

        [OperationContract]
        int InsertJob(System_Jobs job);

        [OperationContract]
        bool DeleteJob(int systemID, int jobID);

        [OperationContract]
        System_Jobs[] GetDueJobs(int systemID, DateTime? dueTimestamp);

        [OperationContract]
        int RefreshJob(System_Jobs job);

        [OperationContract]
        void ExecuteDueJobs(int systemID);

        [OperationContract]
        void TerminateUnusedSessions();

        [OperationContract]
        void UpdateAccessRights(string schedulerID);

        [OperationContract]
        void AdditionAccessTimes(string schedulerID);
    }
}
