using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiteServices.Models
{
    public class AccessEvent
    {
        /// <summary>
        /// InSite system ID
        /// </summary>
        public int SystemID { get; set; }

        /// <summary>
        /// Building field ID
        /// </summary>
        public int BfID { get; set; }

        /// <summary>
        /// Building project ID
        /// </summary>
        public int BpID { get; set; }

        /// <summary>
        /// Access area ID
        /// </summary>
        public int AccessAreaID { get; set; }

        /// <summary>
        /// Entry ID 
        /// </summary>
        public string EntryID { get; set; }

        /// <summary>
        /// Point of entrance ID 
        /// </summary>
        public string PoeID { get; set; }

        /// <summary>
        /// Internal pass ID / Chip ID
        /// </summary>
        public string InternalID { get; set; }

        /// <summary>
        /// Event registered while access control is online
        /// </summary>
        public bool IsOnlineAccessEvent { get; set; }

        /// <summary>
        /// Access timestamp
        /// </summary>
        public DateTime AccessOn { get; set; }

        /// <summary>
        /// Kind of access (coming / leaving)
        /// </summary>
        public int AccessType { get; set; }

        /// <summary>
        /// Numerical representation of access result
        /// </summary>
        public int AccessResult { get; set; }

        /// <summary>
        /// Message was shown to employee
        /// </summary>
        public bool MessageShown { get; set; }

        /// <summary>
        /// Numerical representation of denial reason
        /// </summary>
        public int DenialReason { get; set; }

        /// <summary>
        /// Unique ID of access event or 0
        /// </summary>
        public int? AccessEventID { get; set; }

        /// <summary>
        /// Is system event
        /// </summary>
        public bool IsSystemEvent { get; set; }

        public AccessEvent()
        {
            SystemID = 0;
            BfID = 0;
            BpID = 0;
            AccessAreaID = 0;
            EntryID = "0";
            PoeID = "0";
            InternalID = string.Empty;
            IsOnlineAccessEvent = false;
            AccessOn = DateTime.Now;
            AccessType = 0;
            AccessResult = 0;
            MessageShown = false;
            DenialReason = 0;
            AccessEventID = 0;
            IsSystemEvent = false;
        }
        
        public override string ToString()
        {
            string toString = string.Empty;
            
            toString += string.Concat("SystemID: ", SystemID.ToString(), "\r\n");
            toString += string.Concat("BfID: ", BfID.ToString(), "\r\n");
            toString += string.Concat("BpID: ", BpID.ToString(), "\r\n");
            toString += string.Concat("AccessAreaID: ", AccessAreaID.ToString(), "\r\n");
            toString += string.Concat("EntryID: ", EntryID.ToString(), "\r\n");
            toString += string.Concat("PoeID: ", PoeID.ToString(), "\r\n");
            toString += string.Concat("InternalID: ", InternalID, "\r\n");
            toString += string.Concat("IsOnlineAccessEvent: ", IsOnlineAccessEvent.ToString(), "\r\n");
            toString += string.Concat("AccessOn: ", AccessOn.ToString("G"), "\r\n");
            toString += string.Concat("AccessType: ", AccessType.ToString(), "\r\n");
            toString += string.Concat("AccessResult: ", AccessResult.ToString(), "\r\n");
            toString += string.Concat("MessageShown: ", MessageShown.ToString(), "\r\n");
            toString += string.Concat("DenialReason: ", DenialReason.ToString(), "\r\n");
            toString += string.Concat("AccessEventID: ", AccessEventID.ToString(), "\r\n");
            toString += string.Concat("IsSystemEvent: ", IsSystemEvent.ToString());

            return toString;
        }
    }
}