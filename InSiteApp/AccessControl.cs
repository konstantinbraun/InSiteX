using InSite.App.AccessServices;
using InSite.App.UserServices;
using System;
using System.Linq;
using System.Reflection;
using System.Resources;
using System.Web;

namespace InSite.App
{
    /// <summary>
    /// Methoden zur Verwaltung der Zutrittsrechte gegenüber dem Zutrittskontrollsystem
    /// </summary>
    public class AccessControl : IDisposable
    {
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        readonly AccessServiceClient access;

        readonly int systemID = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
        readonly int bpID = Convert.ToInt32(HttpContext.Current.Session["BpID"]);

        public AccessControl()
        {
            access = new AccessServiceClient();
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
                access.Close();
                logger.Debug("AccessServiceClient succesfully closed");
            }
        }

        ~AccessControl()
        {
            Dispose(false);
        }

        public void EmployeeChanged(int employeeID)
        {
            GetEmployees_Result employee = null;
            EmployeeChanged(employeeID, employee);
        }

        /// <summary>
        /// Rechteänderung bei einem Mitarbeiter verarbeiten
        /// </summary>
        /// <param name="employeeID">ID des Mitarbeiters</param>
        /// <param name="employee">Mitarbeiter Stammsatz(Optional)</param>
        public void EmployeeChanged(int employeeID, GetEmployees_Result employee)
        {
            access.EmployeeChanged(systemID, bpID, employeeID);
        }

        /// <summary>
        /// Rechteänderung bei einer Firma verarbeiten
        /// </summary>
        /// <param name="companyID"></param>
        /// <param name="withSubcontractors"></param>
        public void CompanyChanged(int companyID, bool withSubcontractors)
        {
            access.CompanyChanged(systemID, bpID, companyID, withSubcontractors);
        }

        /// <summary>
        /// Rechteänderung bei einem relevanten Dokument verarbeiten
        /// </summary>
        /// <param name="relevantDocumentID"></param>
        public void RelevantDocumentChanged(int relevantDocumentID)
        {
            access.RelevantDocumentChanged(systemID, bpID, relevantDocumentID);
        }

        /// <summary>
        /// Rechteänderung bei der Zuordnung eines Landes verarbeiten
        /// </summary>
        /// <param name="countryID"></param>
        public void CountryChanged(string countryID)
        {
            access.CountryChanged(systemID, bpID, countryID);
        }

        public void DocumentRuleChanged(int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID, int relevantDocumentID)
        {
            access.DocumentRuleChanged(countryGroupIDEmployer, countryGroupIDEmployee, employmentStatusID, relevantDocumentID);
        }

        /// <summary>
        /// Rechteänderung bei einer Dokumentenprüfregel verarbeiten
        /// </summary>
        /// <param name="countryGroupIDEmployer"></param>
        /// <param name="countryGroupIDEmployee"></param>
        /// <param name="employmentStatusID"></param>
        public void DocumentCheckingRuleChanged(int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID)
        {
            access.DocumentCheckingRuleChanged(systemID, bpID, countryGroupIDEmployer, countryGroupIDEmployee, employmentStatusID);
        }

        /// <summary>
        /// Rechteänderung bei einem Zeitfenster verarbeiten
        /// </summary>
        /// <param name="timeSlotID"></param>
        public void TimeSlotChanged(int timeSlotID)
        {
            access.TimeSlotChanged(systemID, bpID, timeSlotID);
        }

        /// <summary>
        /// Rechteänderung bei einem Kurzzeitausweis verarbeiten
        /// </summary>
        /// <param name="shortTermPassID"></param>
        public void ShortTermPassChanged(int shortTermPassID)
        {
            access.ShortTermPassChanged(systemID, bpID, shortTermPassID);
        }

        /// <summary>
        /// Prüfung, ob alle relevanten Dokumente für einen Mitarbeiter vorliegen
        /// </summary>
        /// <param name="employeeID"></param>
        /// <returns></returns>
        public bool AllRelevantDocumentsSubmitted(int employeeID)
        {
            return access.AllRelevantDocumentsSubmitted(systemID, bpID, employeeID);
        }
    }
}