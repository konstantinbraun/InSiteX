using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiteServices.Models
{
    public class AccessStructure
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
        /// Name of entry
        /// </summary>
        public string EntryName { get; set; }

        /// <summary>
        /// Point of entrance (lane) name 
        /// </summary>
        public string PoeName { get; set; }

        /// <summary>
        /// Row created on
        /// </summary>
        public DateTime CreatedOn { get; set; }

        /// <summary>
        /// Row edited on
        /// </summary>
        public DateTime EditOn { get; set; }

        /// <summary>
        /// Manual access allowed
        /// </summary>
        public bool AllowManualAccess { get; set; }

        /// <summary>
        /// Access direction
        /// </summary>
        public int AccessDirection { get; set; }

        /// <summary>
        /// Allowed number of manual accesses
        /// </summary>
        public int AccessCount { get; set; }

        /// <summary>
        /// Initialize structure
        /// </summary>
        public AccessStructure()
        {
            SystemID = 0;
            BfID = 0;
            BpID = 0;
            AccessAreaID = 0;
            EntryID = "0";
            PoeID = "0";
            EntryName = string.Empty;
            PoeName = string.Empty;
            AllowManualAccess = false;
            AccessDirection = 0;
            AccessCount = 0;
        }
    }
}