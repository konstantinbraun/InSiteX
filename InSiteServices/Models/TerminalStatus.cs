using System;

namespace InsiteServices.Models
{
    public class TerminalStatus
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
        /// Terminal ID
        /// </summary>
        public int TerminalID { get; set; }

        /// <summary>
        /// Designation of terminal
        /// </summary>
        public string Designation { get; set; }

        /// <summary>
        /// Online status of Terminal
        /// </summary>
        public bool IsOnline { get; set; }

        /// <summary>
        /// Terminal type: 1=Speedy, 2=Handheld
        /// </summary>
        public int TerminalType { get; set; }

        /// <summary>
        /// Firmware version of terminal
        /// </summary>
        public string FirmwareVersion { get; set; }

        /// <summary>
        /// Software version of terminal application
        /// </summary>
        public string SoftwareVersion { get; set; }

        /// <summary>
        /// Activation status of terminal
        /// </summary>
        public bool IsActivated { get; set; }

        /// <summary>
        /// Timestamp for status item
        /// </summary>
        public DateTime StatusTimestamp { get; set; }

        public TerminalStatus()
        {
            SystemID = 0;
            BfID = 0;
            BpID = 0;
            AccessAreaID = 0;
            TerminalID = 0;
            Designation = string.Empty;
            IsOnline = false;
            TerminalType = 0;
            FirmwareVersion = string.Empty;
            SoftwareVersion = string.Empty;
            IsActivated = false;
            StatusTimestamp = DateTime.Now;
        }
    }
}