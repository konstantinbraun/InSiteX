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
    
    public partial class GetAccessHistoryEmployee_Result
    {
        public int AccessEventID { get; set; }
        public int SystemID { get; set; }
        public int BpID { get; set; }
        public Nullable<System.DateTime> Timestamp { get; set; }
        public string NameVisible { get; set; }
        public int AccessTypeID { get; set; }
        public int Result { get; set; }
        public int AccessAreaID { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public int EmployeeID { get; set; }
        public bool IsManualEntry { get; set; }
        public string Remark { get; set; }
        public string CreatedFrom { get; set; }
        public System.DateTime EditOn { get; set; }
        public string EditFrom { get; set; }
        public bool IsOnlineAccessEvent { get; set; }
        public int DenialReason { get; set; }
        public string OriginalMessage { get; set; }
    }
}
