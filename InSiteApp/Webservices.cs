using System;
using System.Linq;
using InSite.App.UserServices;
using System.Web;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Web.Services.Protocols;
using InSite.App.Constants;

namespace InSite.App
{
    public class Webservices : IDisposable
    {
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private readonly int systemID = 1;
        private readonly int bpID = 1;
        private readonly string userName = string.Empty;
        private readonly string sessionID;

        readonly UserServiceClient client;

        public Webservices()
        {
            client = new UserServiceClient();
            // logger.Debug("Try to initialize webservice ...");
            try
            {
                client.Open();
                // logger.Debug("Webservice succesfully initialized");
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }

            if (HttpContext.Current.Session["SystemID"] != null)
            {
                systemID = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            }
            if (HttpContext.Current.Session["BpID"] != null)
            {
                bpID = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            }
            if (HttpContext.Current.Session["LoginName"] != null)
            {
                userName = HttpContext.Current.Session["LoginName"].ToString();
            }
            sessionID = HttpContext.Current.Session.SessionID.ToString();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                client.Close();
                logger.Debug("Webservice succesfully closed");
            }
        }

        ~Webservices()
        {
            Dispose(false);
        }

        public UserAssignments[] Login(string userName, string passWord)
        {
            UserAssignments[] users = null;
            logger.DebugFormat("Try to login user {0}", userName);
            try
            {
                users = client.Login(userName, passWord, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }

            //            Helpers.SetUserSession(users);

            return users;
        }

        public int UpdateUser(string columnName, string columnValue)
        {
            int ret = 0;
            logger.DebugFormat("Try to update column {0} with value {1}", columnName, columnValue);
            try
            {
                ret = client.UpdateUser(columnName, columnValue, Convert.ToInt32(HttpContext.Current.Session["UserID"]), sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return ret;
        }

        public int UpdatePwd(int userID, string newPwd)
        {
            int ret = 0;
            logger.DebugFormat("Try to change pwd for user {0}", HttpContext.Current.Session["LoginName"].ToString());
            try
            {
                ret = client.UpdatePwd("", newPwd, userID, sessionID, HttpContext.Current.Session["LoginName"].ToString(), true, false);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return ret;
        }

        public int UpdatePwd(int userID, string newPwd, bool needsPwdChange)
        {
            int ret = 0;
            string loginName = "System";
            
            if (HttpContext.Current.Session["LoginName"] != null)
            {
                loginName = HttpContext.Current.Session["LoginName"].ToString();
            }
            
            logger.DebugFormat("Try to change pwd for user {0}", loginName);
            
            try
            {
                ret = client.UpdatePwd("", newPwd, userID, sessionID, loginName, true, needsPwdChange);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return ret;
        }

        public int UpdatePwd(string oldPwd, string newPwd)
        {
            int ret = 0;
            string loginName = "System";
            
            if (HttpContext.Current.Session["LoginName"] != null)
            {
                loginName = HttpContext.Current.Session["LoginName"].ToString();
            }
            
            logger.DebugFormat("Try to change pwd for user {0}", loginName);
            
            try
            {
                ret = client.UpdatePwd(oldPwd, newPwd, Convert.ToInt32(HttpContext.Current.Session["UserID"]), sessionID, loginName, false, false);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return ret;
        }

        public Master_BuildingProjects GetBpInfo(int bpID)
        {
            Master_BuildingProjects bp = new Master_BuildingProjects();
            // logger.DebugFormat("Try to get info on building project {0}", Convert.ToString(bpID));
            try
            {
                bp = client.GetBpInfo(bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }

            return bp;
        }

        public Master_BuildingProjects[] GetAllBpsInfo()
        {
            Master_BuildingProjects[] bps = null;
            // logger.DebugFormat("Try to get info on building project {0}", Convert.ToString(bpID));
            try
            {
                bps = client.GetAllBpsInfo(sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }

            return bps;
        }

        public GetFieldsConfig_Result[] GetFieldsConfig(int dialogID, int actionID, int roleID)
        {
            GetFieldsConfig_Result[] fc = null;
            logger.DebugFormat("Try to get info for dialog {0}; action {1}; role: {2}", dialogID, actionID, roleID);
            string languageID = HttpContext.Current.Session["LanguageID"].ToString();
            if (!languageID.Equals("de") && !languageID.Equals("en"))
            {
                languageID = "en";
            }

            try
            {
                fc = client.GetFieldsConfig(systemID, bpID, roleID, dialogID, actionID, languageID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }

            return fc;
        }

        public GetFieldsConfig_Result[] GetFieldsConfig(int dialogID, int actionID)
        {
            int roleID = Convert.ToInt32(HttpContext.Current.Session["RoleID"]);
            return GetFieldsConfig(dialogID, actionID, roleID);
        }

        public PrintPass_Result PrintPass(int employeeID, int replacementPassCaseID, string reason, string deactivationMessage)
        {
            PrintPass_Result result = new PrintPass_Result();
            try
            {
                result = client.PrintPass(systemID, bpID, employeeID, replacementPassCaseID, reason, userName, deactivationMessage, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int ActivatePass(int employeeID, string internalID)
        {
            int result;
            try
            {
                result = client.ActivatePass(systemID, bpID, employeeID, internalID, userName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int DeactivatePass(int employeeID, string internalID, string reason)
        {
            int result;
            try
            {
                result = client.DeactivatePass(systemID, bpID, employeeID, internalID, reason, userName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int LockPass(int employeeID, string internalID, string reason)
        {
            int result;
            try
            {
                result = client.LockPass(systemID, bpID, employeeID, reason, userName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public bool IsFirstPass(int employeeID)
        {
            bool result;
            try
            {
                result = client.IsFirstPass(systemID, bpID, employeeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public EmployeeRegistrationData ValidateRegistrationCode(string code)
        {
            EmployeeRegistrationData result = new EmployeeRegistrationData();
            try
            {
                result = client.ValidateRegistrationCode(code, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public bool LoginNameIsUnique(string loginName)
        {
            bool result = true;
            try
            {
                result = client.LoginNameIsUnique(loginName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public UserAssignments[] GetUsersWithRole(int typeID)
        {
            UserAssignments[] users = null;
            
            try
            {
                users = client.GetUsersWithRole(systemID, bpID, typeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }

            return users;
        }

        public int GetAppliedRule(int employeeID)
        {
            int result;
            try
            {
                result = client.GetAppliedRule(systemID, bpID, employeeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public UserAssignments GetUserWithLoginName(string loginName)
        {
            UserAssignments user = new UserAssignments();

            try
            {
                user = client.GetUserWithLoginName(loginName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }

            return user;
        }

        public int GetNextID(string idName)
        {
            int result;
            try
            {
                result = client.GetNextID(systemID, idName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int PrintShortTermPasses(int shortTermPassTypeID, int passCount)
        {
            int result;
            try
            {
                result = client.PrintShortTermPasses(systemID, bpID, shortTermPassTypeID, passCount, userName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int UpdateShortTermPass(int shortTermPassID, string internalID)
        {
            int result;
            try
            {
                result = client.UpdateShortTermPass(systemID, bpID, shortTermPassID, internalID, userName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public ShortTermPass GetShortTermPass(string internalID)
        {
            ShortTermPass result;
            try
            {
                result = client.GetShortTermPass(systemID, bpID, internalID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetTreeNodeID(string dialogName)
        {
            int result;
            try
            {
                result = client.GetTreeNodeID(systemID, dialogName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetDialogID(string dialogName)
        {
            int result;
            try
            {
                result = client.GetDialogID(systemID, dialogName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public string GetDialogResID(int dialogID)
        {
            string result;
            try
            {
                result = client.GetDialogResID(systemID, dialogID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int RowCount(string tableName, SqlParameterCollection where)
        {
            List<Tuple<string, int>> whereInt = new List<Tuple<string, int>>(); 
            List<Tuple<string, string>> whereString = new List<Tuple<string, string>>();

            foreach (SqlParameter par in where)
            {
                if (par.SqlDbType == SqlDbType.NVarChar || par.SqlDbType == SqlDbType.VarChar || par.SqlDbType == SqlDbType.Char)
                {
                    Tuple<string, string> parTuple = new Tuple<string, string>(par.ParameterName, par.Value.ToString());
                    whereString.Add(parTuple);
                }
                else
                {
                    Tuple<string, int> parTuple = new Tuple<string, int>(par.ParameterName, Convert.ToInt32(par.Value));
                    whereInt.Add(parTuple);
                }
            }

            int result;
            try
            {
                result = client.RowCount(tableName, whereInt.ToArray(), whereString.ToArray(), sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetCompanyStatistics_Result GetCompanyStatistics(int companyID)
        {
            GetCompanyStatistics_Result result;
            try
            {
                result = client.GetCompanyStatistics(systemID, bpID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetEmployees_Result[] GetEmployees(bool scale)
        {
            GetEmployees_Result[] results = GetEmployees(0, 0, "", 0, 0);
            return results;
        }

        public GetEmployees_Result[] GetEmployees(int companyID, int employeeID, string externalPassID, int employmentStatusID, int tradeID)
        {
            int companyCentralID = Convert.ToInt32(HttpContext.Current.Session["CompanyID"]);
            int userID = Convert.ToInt32(HttpContext.Current.Session["UserID"]);

            GetEmployees_Result[] result = null;
            try
            {
                result = client.GetEmployees(systemID, bpID, companyCentralID, companyID, employeeID, externalPassID, employmentStatusID, tradeID, userID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetEmployeeAccessAreas_Result[] GetEmployeeAccessAreas(int employeeID)
        {
            GetEmployeeAccessAreas_Result[] result = null;
            try
            {
                result = client.GetEmployeeAccessAreas(systemID, bpID, employeeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public void CreateAccessRightEvent(Data_AccessRightEvents rightEvent, Data_AccessAreaEvents[] areaEvents, string deactivationMessage)
        {
            try
            {
                client.CreateAccessRightEvent(rightEvent, areaEvents, deactivationMessage, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
        }

        public HasValidDocumentRelevantFor_Result[] HasValidDocumentRelevantFor(int employeeID)
        {
            HasValidDocumentRelevantFor_Result[] result = null;
            try
            {
                result = client.HasValidDocumentRelevantFor(systemID, bpID, employeeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetAccessRightEvents_Result[] GetAccessRightEvents(int employeeID, bool newestOnly)
        {
            GetAccessRightEvents_Result[] result = null;
            try
            {
                result = client.GetAccessRightEvents(systemID, bpID, employeeID, newestOnly, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetAccessAreaEvents_Result[] GetAccessAreaEvents(int accessRightEventID)
        {
            GetAccessAreaEvents_Result[] result = null;
            try
            {
                result = client.GetAccessAreaEvents(systemID, bpID, accessRightEventID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetRelevantDocuments_Result[] GetRelevantDocuments(int relevantDocumentID)
        {
            string languageID = HttpContext.Current.Session["LanguageID"].ToString();

            GetRelevantDocuments_Result[] result = null;
            try
            {
                result = client.GetRelevantDocuments(systemID, bpID, relevantDocumentID, languageID, sessionID);
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetEmployeeRelevantDocuments_Result[] GetEmployeeRelevantDocuments(int employeeID)
        {
            string languageID = HttpContext.Current.Session["LanguageID"].ToString();

            GetEmployeeRelevantDocuments_Result[] result = null;
            try
            {
                result = client.GetEmployeeRelevantDocuments(systemID, bpID, employeeID, languageID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetEmployeesWithTimeSlot_Result[] GetEmployeesWithTimeSlot(int timeSlotID)
        {
            GetEmployeesWithTimeSlot_Result[] result = null;
            try
            {
                result = client.GetEmployeesWithTimeSlot(systemID, bpID, timeSlotID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetEmployeesWithRelevantDocument_Result[] GetEmployeesWithRelevantDocument(int relevantDocumentID)
        {
            GetEmployeesWithRelevantDocument_Result[] result = null;
            try
            {
                result = client.GetEmployeesWithRelevantDocument(systemID, bpID, relevantDocumentID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int?[] GetEmployeesWithCountry(string countryID)
        {
            int?[] result = null;
            try
            {
                result = client.GetEmployeesWithCountry(systemID, bpID, countryID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int?[] GetEmployeesWithEmploymentStatus(int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID)
        {
            int?[] result = null;
            try
            {
                result = client.GetEmployeesWithEmploymentStatus(systemID, bpID, countryGroupIDEmployer, countryGroupIDEmployee, employmentStatusID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetShortTermPasses_Result[] GetShortTermPasses(int shortTermPassID)
        {
            GetShortTermPasses_Result[] result = null;
            try
            {
                result = client.GetShortTermPasses(systemID, bpID, shortTermPassID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetVisitorAccessAreas_Result[] GetVisitorAccessAreas(int shortTermVisitorID)
        {
            GetVisitorAccessAreas_Result[] result = null;
            try
            {
                result = client.GetVisitorAccessAreas(systemID, bpID, shortTermVisitorID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetEmployeeRelevantDocumentsToAdd_Result[] GetEmployeeRelevantDocumentsToAdd(int employeeID, int relevantFor)
        {
            GetEmployeeRelevantDocumentsToAdd_Result[] result = null;
            try
            {
                result = client.GetEmployeeRelevantDocumentsToAdd(systemID, bpID, employeeID, relevantFor, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetCompanyAdminUser_Result[] GetCompanyAdminUser(int companyCentralID)
        {
            GetCompanyAdminUser_Result[] result = null;
            try
            {
                result = client.GetCompanyAdminUser(systemID, companyCentralID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetCompanyAdminUserWithBP_Result[] GetCompanyAdminUserWithBP(int companyID)
        {
            GetCompanyAdminUserWithBP_Result[] result = null;
            try
            {
                result = client.GetCompanyAdminUserWithBP(systemID, bpID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetLockedMainContractor_Result[] GetLockedMainContractor(int companyID)
        {
            GetLockedMainContractor_Result[] result = null;
            try
            {
                result = client.GetLockedMainContractor(systemID, bpID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetMainContractorStatus(int companyID)
        {
            int result = 0;
            try
            {
                result = client.GetMainContractorStatus(systemID, bpID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetSubContractors_Result[] GetSubContractors(int companyID)
        {
            GetSubContractors_Result[] result = null;
            try
            {
                result = client.GetSubContractors(systemID, bpID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetEmployeePassStatus(int employeeID)
        {
            int result = 0;
            try
            {
                result = client.GetEmployeePassStatus(systemID, bpID, employeeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int SetProcessEvent(Data_ProcessEvents eventData, string fieldName, Tuple<string, string>[] values)
        {
            int userID = 0;
            if (HttpContext.Current.Session["UserID"] != null)
            {
                userID = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            }

            eventData.SystemID = systemID;
            eventData.BpID = bpID;
            eventData.UserIDInitiator = userID;
            eventData.TypeID = 1;
            eventData.StatusID = Status.WaitExecute;
            eventData.CreatedFrom = userName;
            eventData.CreatedOn = DateTime.Now;
            eventData.EditFrom = userName;
            eventData.EditOn = DateTime.Now;

            int result = 0;
            
            try
            {
                result = client.SetProcessEvent(eventData, fieldName, values, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int ProcessEventDone(Data_ProcessEvents eventData)
        {
            int userID = 0;
            if (HttpContext.Current.Session["UserID"] != null)
            {
                userID = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            }

            eventData.SystemID = systemID;
            eventData.BpID = bpID;
            eventData.UserIDExecutive = userID;
            eventData.TypeID = 1;
            eventData.StatusID = Status.Done;
            eventData.DoneFrom = userName;
            eventData.DoneOn = DateTime.Now;

            int result = 0;

            try
            {
                result = client.ProcessEventDone(eventData, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public string GetBpName(int bpID)
        {
            string result = "";
            try
            {
                result = client.GetBpName(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public string GetCompanyName(int companyID)
        {
            string result = "";
            try
            {
                result = client.GetCompanyName(systemID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetUnreadMailCount()
        {
            int userID = 0;
            if (HttpContext.Current.Session["UserID"] != null)
            {
                userID = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            }

            int result = 0;
            try
            {
                result = client.GetUnreadMailCount(systemID, userID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public int GetOpenProcessCount()
        {
            return GetOpenProcessCount(bpID);
        }

        public int GetOpenProcessCount(int bpIDProcess)
        {
            int userID = 0;
            if (HttpContext.Current.Session["UserID"] != null)
            {
                userID = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            }

            int result = 0;
            try
            {
                result = client.GetOpenProcessCount(systemID, bpIDProcess, userID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public Master_Roles[] GetRoles(int bpID)
        {
            int typeID = Convert.ToInt32(HttpContext.Current.Session["UserType"]);

            Master_Roles[] result = null;
            try
            {
                result = client.GetRoles(systemID, bpID, typeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetDefaultRoleID(int bpID)
        {
            int result = 0;
            try
            {
                result = client.GetDefaultRoleID(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public Master_AccessAreas[] GetAccessAreas(int bpID)
        {
            Master_AccessAreas[] result = null;
            try
            {
                result = client.GetAccessAreas(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetDefaultAccessAreaID(int bpID)
        {
            int result = 0;
            try
            {
                result = client.GetDefaultAccessAreaID(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetDefaultSTAccessAreaID(int bpID)
        {
            int result = 0;
            try
            {
                result = client.GetDefaultSTAccessAreaID(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public Master_TimeSlotGroups[] GetTimeSlotGroups(int bpID)
        {
            Master_TimeSlotGroups[] result = null;
            try
            {
                result = client.GetTimeSlotGroups(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetDefaultTimeSlotGroupID(int bpID)
        {
            int result = 0;
            try
            {
                result = client.GetDefaultTimeSlotGroupID(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int GetDefaultSTTimeSlotGroupID(int bpID)
        {
            int result = 0;
            try
            {
                result = client.GetDefaultSTTimeSlotGroupID(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int SetDefaultAccessAreaForUser(int employeeID, int accessAreaID, int timeSlotGroupID)
        {
            Master_EmployeeAccessAreas accessArea = new Master_EmployeeAccessAreas();
            accessArea.SystemID = systemID;
            accessArea.BpID = bpID;
            accessArea.EmployeeID = employeeID;
            accessArea.AccessAreaID = accessAreaID;
            accessArea.TimeSlotGroupID = timeSlotGroupID;
            accessArea.CreatedFrom = userName;
            accessArea.CreatedOn = DateTime.Now;
            accessArea.EditFrom = userName;
            accessArea.EditOn = DateTime.Now;

            int result = 0;
            try
            {
                result = client.SetDefaultAccessAreaForUser(accessArea, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int SetDefaultAccessAreaForVisitor(int shortTermVisitorID, int accessAreaID, int timeSlotGroupID)
        {
            Data_ShortTermAccessAreas accessArea = new Data_ShortTermAccessAreas();
            accessArea.SystemID = systemID;
            accessArea.BpID = bpID;
            accessArea.ShortTermVisitorID = shortTermVisitorID;
            accessArea.AccessAreaID = accessAreaID;
            accessArea.TimeSlotGroupID = timeSlotGroupID;
            accessArea.CreatedFrom = userName;
            accessArea.CreatedOn = DateTime.Now;
            accessArea.EditFrom = userName;
            accessArea.EditOn = DateTime.Now;

            int result = 0;
            try
            {
                result = client.SetDefaultAccessAreaForVisitor(accessArea, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public Master_Passes GetPassData(string chipID)
        {
            Master_Passes result = new Master_Passes();
            try
            {
                result = client.GetPassData(systemID, bpID, chipID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public System_Variables[] GetVariables(int fieldID)
        {
            System_Variables[] result = null;
            try
            {
                result = client.GetVariables(systemID, fieldID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public System_Variables[] GetVariablesByFieldName(string fieldName)
        {
            System_Variables[] result = null;
            try
            {
                result = client.GetVariablesByFieldName(systemID, fieldName, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public Master_Translations GetTranslation(string fieldName, string languageID, Tuple<string, string>[] values)
        {
            string languageIDClient = Helpers.CurrentLanguage();

            Master_Translations result = new Master_Translations();
            try
            {
                result = client.GetTranslation(systemID, bpID, fieldName, languageID, languageIDClient, values, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetShortTermVisitors_Result[] GetShortTermVisitors()
        {
            GetShortTermVisitors_Result[] result = null;
            try
            {
                result = client.GetShortTermVisitors(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public System_Tables[] GetHistoryTables()
        {
            System_Tables[] result = null;
            try
            {
                result = client.GetHistoryTables(sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public Master_Users GetUser(int userID)
        {
            Master_Users result = new Master_Users();
            try
            {
                result = client.GetUser(systemID, userID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public Master_Users[] GetUsers()
        {
            Master_Users[] result = null;
            try
            {
                result = client.GetUsers(systemID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetPresentPersonsCount_Result GetPresentPersonsCount()
        {
            GetPresentPersonsCount_Result result = new GetPresentPersonsCount_Result();
            try
            {
                result = client.GetPresentPersonsCount(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetPassBillings_Result[] GetPassBillings(int companyID, DateTime dateFrom, DateTime dateUntil, int level, string remarks)
        {
            GetPassBillings_Result[] result = null;
            try
            {
                result = client.GetPassBillings(systemID, bpID, companyID, 1, dateFrom, dateUntil, level, remarks, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetTariffData_Result[] GetTariffData(
            int tariffID,
            int tariffContractID,
            int tariffScopeID,
            int bpID,
            int companyID,
            DateTime dateFrom,
            DateTime dateUntil,
            int reportType)
        {
            GetTariffData_Result[] result = null;
            try
            {
                result = client.GetTariffData(
                    systemID,
                    tariffID,
                    tariffContractID,
                    tariffScopeID,
                    bpID,
                    companyID,
                    dateFrom,
                    dateUntil,
                    reportType,
                    sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetPresenceData_Result[] GetPresenceData(
            int companyID,
            DateTime dateFrom,
            DateTime dateUntil,
            bool nameIsVisible,
            int companyLevel,
            int compressLevel)
        {
            GetPresenceData_Result[] result = null;
            try
            {
                result = client.GetPresenceData(
                    systemID,
                    bpID,
                    companyID,
                    dateFrom,
                    dateUntil,
                    nameIsVisible,
                    companyLevel,
                    compressLevel,
                    sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetPresenceDataNow_Result[] GetPresenceDataNow(
            int companyID,
            int companyLevel,
            int accessAreaID,
            DateTime presenceDay,
            bool presentOnly)
        {
            GetPresenceDataNow_Result[] result = null;
            try
            {
                result = client.GetPresenceDataNow(
                    systemID,
                    bpID,
                    companyID,
                    companyLevel,
                    accessAreaID,
                    presenceDay,
                    presentOnly,
                    sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetTradeReportData_Result[] GetTradeReportData(
            DateTime dateFrom,
            DateTime dateUntil)
        {
            GetTradeReportData_Result[] result = null;
            try
            {
                result = client.GetTradeReportData(
                    systemID,
                    bpID,
                    dateFrom,
                    dateUntil,
                    sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetTemplates_Result[] GetTemplates(
            string dialogName,
            bool withFileData,
            int bpID)
        {
            GetTemplates_Result[] result = null;
            try
            {
                    result = client.GetTemplates(
                        systemID,
                        bpID,
                        dialogName,
                        withFileData,
                    sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public Master_Templates GetTemplate(int templateID)
        {
            Master_Templates result = new Master_Templates();
            try
            {
                result = client.GetTemplate(systemID, bpID, templateID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int SendMessage(int jobID, int receiverID, string subject, string body)
        {
            int result = 0;
            try
            {
                result = client.SendMessage(systemID, jobID, receiverID, subject, body, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public int SendMessageToUsersWithRight(int bpID, int jobID, int dialogID, int actionID, string subject, string body)
        {
            int result = 0;
            try
            {
                result = client.SendMessageToUsersWithRight(systemID, bpID, jobID, dialogID, actionID, subject, body, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetCompanyTariff_Result GetCompanyTariff(int companyID, int tariffScopeID)
        {
            GetCompanyTariff_Result result = new GetCompanyTariff_Result();
            try
            {
                result = client.GetCompanyTariff(systemID, companyID, tariffScopeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetReportMinWageData_Result[] GetReportMinWageData(DateTime monthFrom, DateTime monthUntil, int companyID)
        {
            GetReportMinWageData_Result[] result = null;
            try
            {
                result = client.GetReportMinWageData(systemID, bpID, monthFrom, monthUntil, companyID, sessionID);
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetCompanyInfo_Result[] GetCompanyInfo(int companyID)
        {
            GetCompanyInfo_Result[] result = null;
            try
            {
                result = client.GetCompanyInfo(systemID, bpID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetMWAttestationRequests_Result[] GetMWAttestationRequests(int companyID, int requestID)
        {
            GetMWAttestationRequests_Result[] result = null;
            try
            {
                result = client.GetMWAttestationRequests(systemID, bpID, companyID, requestID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public System_Dialogs GetDialog(int dialogID)
        {
            System_Dialogs result = null;
            try
            {
                result = client.GetDialog(systemID, dialogID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public Pass GetPass(int employeeID, bool withFileData)
        {
            Pass result = new Pass();
            try
            {
                result = client.GetPass(systemID, bpID, employeeID, withFileData, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public ShortTermPassPrint GetShortTermPassPrint(int printID)
        {
            ShortTermPassPrint result = new ShortTermPassPrint();
            try
            {
                result = client.GetShortTermPassPrint(systemID, bpID, printID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public string GetShortTermPassTemplate(int shortTermPassTypeID)
        {
            string result = string.Empty;
            try
            {
                result = client.GetShortTermPassTemplate(systemID, bpID, shortTermPassTypeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public string GetEmployeePassTemplate(int employeeID, int dialogID)
        {
            string result = string.Empty;
            try
            {
                result = client.GetEmployeePassTemplate(systemID, bpID, employeeID, dialogID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                throw;
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                throw;
            }
            return result;
        }

        public GetPresentPersonsPerAccessArea_Result[] GetPresentPersonsPerAccessArea()
        {
            GetPresentPersonsPerAccessArea_Result[] result = null;
            try
            {
                result = client.GetPresentPersonsPerAccessArea(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public GetMissingFirstAiders_Result[] GetMissingFirstAiders()
        {
            GetMissingFirstAiders_Result[] result = null;
            try
            {
                result = client.GetMissingFirstAiders(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public Master_AccessSystems GetLastUpdateAccessControl()
        {
            Master_AccessSystems result = null;
            try
            {
                result = client.GetLastUpdateAccessControl(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public DateTime GetLastBackupDate()
        {
            DateTime result = DateTime.MinValue;
            try
            {
                result = client.GetLastBackupDate(sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public DateTime GetLastCompressDate()
        {
            DateTime result = DateTime.MinValue;
            try
            {
                result = client.GetLastCompressDate(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public DateTime GetLastCorrectionDate()
        {
            DateTime result = DateTime.MinValue;
            try
            {
                result = client.GetLastCorrectionDate(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public GetPassInfo_Result[] GetPassInfo(string internalID)
        {
            GetPassInfo_Result[] result = null;
            try
            {
                result = client.GetPassInfo(internalID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public Master_CompanyContacts GetCompanyMWContact(int companyID)
        {
            Master_CompanyContacts result = null;
            try
            {
                result = client.GetCompanyMWContact(systemID, bpID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public Master_Users GetCompanyAdmin(int companyID)
        {
            Master_Users result = null;
            try
            {
                result = client.GetCompanyAdmin(systemID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public bool HasRightForDialog(int dialogID, int roleID)
        {
            bool result = false;
            try
            {
                result = client.HasRightForDialog(systemID, bpID, dialogID, roleID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public byte[] GetRelevantDocumentImage(int relevantDocumentID, int maxWidth, int maxHeight)
        {
            byte[] result = null;
            try
            {
                result = client.GetRelevantDocumentImage(systemID, bpID, relevantDocumentID, maxWidth, maxHeight, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            if (result != null)
            {
                return result;
            }
            else
            {
                return new byte[0];
            }
        }

        public void SetMailRead(int mailID, bool mailRead)
        {
            try
            {
                client.SetMailRead(systemID, mailID, mailRead, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
        }

        public Document GetDocument(int documentID)
        {
            Document result = null;
            try
            {
                result = client.GetDocument(systemID, documentID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public Document RenderReport(string reportParameter)
        {
            Document result = null;
            try
            {
                result = client.RenderReport(reportParameter, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public System_Help GetHelp(int dialogID, int fieldID)
        {
            string languageID = HttpContext.Current.Session["currentCulture"].ToString();
            System_Help result = null;
            try
            {
                result = client.GetHelp(systemID, dialogID, fieldID, languageID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public GetExpiringTariffs_Result[] GetExpiringTariffs()
        {
            GetExpiringTariffs_Result[] result = null;
            try
            {
                result = client.GetExpiringTariffs(systemID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public bool IsPassCaseFirstIssue(int replacementPassCaseID)
        {
            bool result = false;
            try
            {
                result = client.IsPassCaseFirstIssue(systemID, bpID, replacementPassCaseID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public GetEmployeeDuplicates_Result[] GetEmployeeDuplicates(int employeeID)
        {
            GetEmployeeDuplicates_Result[] result = null;
            try
            {
                result = client.GetEmployeeDuplicates(systemID, bpID, employeeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public GetCompanyCentralDuplicates_Result[] GetCompanyCentralDuplicates(int companyID)
        {
            GetCompanyCentralDuplicates_Result[] result = null;
            try
            {
                result = client.GetCompanyCentralDuplicates(systemID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public GetUserDuplicates_Result[] GetUserDuplicates(int userID)
        {
            GetUserDuplicates_Result[] result = null;
            try
            {
                result = client.GetUserDuplicates(systemID, userID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public System_Companies GetCompanyCentralInfo(int companyID)
        {
            System_Companies result = null;
            try
            {
                result = client.GetCompanyCentralInfo(systemID, companyID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public byte[] GetEmployeePhotoData(int employeeID)
        {
            byte[] result = null;
            try
            {
                result = client.GetEmployeePhotoData(systemID, bpID, employeeID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            return result;
        }

        public void UpdateThumbnails()
        {
            try
            {
                client.UpdateThumbnails(systemID, bpID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
        }

        public bool EmploymentStatusMWObligate(int employmentStatusID)
        {
            bool mwObligate = false;
            try
            {
                mwObligate = client.EmploymentStatusMWObligate(systemID, bpID, employmentStatusID, sessionID);
            }
            catch (SoapException ex)
            {
                logger.Error("SOAP exeption: ", ex);
            }
            catch (Exception ex)
            {
                logger.Error("Webservice error: ", ex);
            }
            return mwObligate;
        }

        public List<GetPresentFirstAiders_Result> GetAvailableFirstAiders()
        {
            List<GetPresentFirstAiders_Result>  aiders= new List<GetPresentFirstAiders_Result>();
            try
            {
                aiders = client.GetAvailableFirstAiders(systemID, bpID).ToList();
            }
            catch (SoapException ex)
            {
                logger.Error("SOAP exeption: ", ex);
            }
            catch (Exception ex)
            {
                logger.Error("Webservice error: ", ex);
            }
            return aiders;
        }
    }
}