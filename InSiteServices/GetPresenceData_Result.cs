//------------------------------------------------------------------------------
// <auto-generated>
//     Der Code wurde von einer Vorlage generiert.
//
//     Manuelle Änderungen an dieser Datei führen möglicherweise zu unerwartetem Verhalten der Anwendung.
//     Manuelle Änderungen an dieser Datei werden überschrieben, wenn der Code neu generiert wird.
// </auto-generated>
//------------------------------------------------------------------------------

namespace InsiteServices
{
    using System;
    
    public partial class GetPresenceData_Result
    {
        public int SystemID { get; set; }
        public int BpID { get; set; }
        public int CompanyID { get; set; }
        public string NameVisible { get; set; }
        public string NameAdditional { get; set; }
        public int ParentID { get; set; }
        public int TradeID { get; set; }
        public Nullable<System.DateTime> PresenceDay { get; set; }
        public Nullable<int> EmployeeID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public Nullable<System.DateTime> AccessAt { get; set; }
        public Nullable<System.DateTime> ExitAt { get; set; }
        public Nullable<long> PresenceSeconds { get; set; }
        public int AccessAreaID { get; set; }
        public int TimeSlotID { get; set; }
        public Nullable<int> CountAs { get; set; }
        public string TreeLevel { get; set; }
        public int IndentLevel { get; set; }
        public int CompressLevel { get; set; }
        public bool AccessTimeManual { get; set; }
        public bool ExitTimeManual { get; set; }
        public Nullable<System.DateTime> DateFrom { get; set; }
        public Nullable<System.DateTime> DateUntil { get; set; }
        public string AccessAreaName { get; set; }
        public int PresenceLevel { get; set; }
    }
}
