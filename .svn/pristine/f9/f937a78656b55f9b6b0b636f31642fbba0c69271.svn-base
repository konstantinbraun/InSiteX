using System;
using System.Linq;

namespace InsiteServices.Models
{
    /// <summary>
    /// Represents the access rights for a unique pass
    /// </summary>
    public class AccessRight
    {
        /// <summary>
        /// Access right ID as unique row ID
        /// </summary>
        public int AccessRightID { get; set; }

        /// <summary>
        /// InSite system ID
        /// </summary>
        public int SystemID { get; set; }

        /// <summary>
        /// Internal pass ID / Chip ID
        /// </summary>
        public string InternalID { get; set; }

        /// <summary>
        /// Printed pass ID
        /// </summary>
        public string ExternalID { get; set; }

        /// <summary>
        /// Employees first name
        /// </summary>
        public string EmployeeFirstName { get; set; }

        /// <summary>
        /// Employees last name
        /// </summary>
        public string EmployeeLastName { get; set; }

        /// <summary>
        /// Company name
        /// </summary>
        public string CompanyName { get; set; }

        /// <summary>
        /// Trade name
        /// </summary>
        public string TradeName { get; set; }

        /// <summary>
        /// Photo data as byte array
        /// </summary>
        public byte[] PhotoData { get; set; }

        /// <summary>
        /// Metric data as byte array
        /// </summary>
        public byte[] MetricData { get; set; }

        /// <summary>
        /// Message that is displayed to the employee 
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Begin of displaying message time slot
        /// </summary>
        public DateTime ShowMessageFrom { get; set; }

        /// <summary>
        /// End of displaying message time slot
        /// </summary>
        public DateTime ShowMessageUntil { get; set; }

        /// <summary>
        /// Access is denied 
        /// </summary>
        public bool LockFlag { get; set; }

        /// <summary>
        /// Reason(s) for access denial
        /// </summary>
        public string LockReason { get; set; }

        /// <summary>
        /// Language ID in format de-DE
        /// </summary>
        public string LanguageID { get; set; }

        /// <summary>
        /// Row created on
        /// </summary>
        public DateTime CreatedOn { get; set; }

        /// <summary>
        /// Row edited on
        /// </summary>
        public DateTime EditOn { get; set; }

        /// <summary>
        /// Acces right is valid until
        /// </summary>
        public DateTime ValidUntil { get; set; }

        /// <summary>
        /// Array of AccessArea objects
        /// Represents the rights to access certain areas
        /// </summary>
        public AccessArea[] AccessAreas { get; set; }

        public AccessRight()
        {
            SystemID = 0;
            InternalID = string.Empty;
            ExternalID = string.Empty;
            EmployeeFirstName = string.Empty;
            EmployeeLastName = string.Empty;
            CompanyName = string.Empty;
            TradeName = string.Empty;
            PhotoData = null;
            MetricData = null;
            Message = string.Empty;
            LockFlag = false;
            LockReason = string.Empty;
            LanguageID = string.Empty;
            AccessAreas = null;
        }
    }
}