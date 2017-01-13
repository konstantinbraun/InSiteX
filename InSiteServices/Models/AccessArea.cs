using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiteServices.Models
{
    /// <summary>
    /// Represents the rights to access certain areas
    /// </summary>
    public class AccessArea
    {
        /// <summary>
        /// Access right ID as relation to parent row in AccessRight
        /// </summary>
        public int AccessRightID { get; set; }

        /// <summary>
        /// Access area ID
        /// </summary>
        public int AccessAreaID { get; set; }
        
        /// <summary>
        /// Name of access area
        /// </summary>
        public string AccessAreaName { get; set; }

        /// <summary>
        /// Building field ID
        /// </summary>
        public int BfID { get; set; }

        /// <summary>
        /// Building project ID
        /// </summary>
        public int BpID { get; set; }

        /// <summary>
        /// Time slot ID
        /// </summary>
        public int TimeSlotID { get; set; }

        /// <summary>
        /// Access allowed from DateTime
        /// </summary>
        public DateTime ValidFrom { get; set; }

        /// <summary>
        /// Access allowed until DateTime
        /// </summary>
        public DateTime ValidUntil { get; set; }

        /// <summary>
        /// Valid weekdays for this time slot
        /// </summary>
        public string ValidDays { get; set; }

        /// <summary>
        /// Daily time slot begins
        /// </summary>
        public TimeSpan TimeFrom { get; set; }

        /// <summary>
        /// Daily time slot ends
        /// </summary>
        public TimeSpan TimeUntil { get; set; }

        /// <summary>
        /// Additional rights
        /// </summary>
        public int AdditionalRights { get; set; }

        /// <summary>
        /// Initialization
        /// </summary>
        public AccessArea()
        {
            AccessAreaID = 0;
            AccessRightID = 0;
            AccessAreaName = string.Empty;
            BfID = 0;
            BpID = 0;
            TimeSlotID = 0;
            ValidDays = string.Empty;
            AdditionalRights = (int)Rights.None;
        }

    }
}