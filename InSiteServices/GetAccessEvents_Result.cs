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
    
    public partial class GetAccessEvents_Result
    {
        public int AccessEventID { get; set; }
        public int SystemID { get; set; }
        public int BfID { get; set; }
        public int BpID { get; set; }
        public int AccessAreaID { get; set; }
        public int EntryID { get; set; }
        public int PoeID { get; set; }
        public int OwnerID { get; set; }
        public string InternalID { get; set; }
        public bool IsOnlineAccessEvent { get; set; }
        public Nullable<System.DateTime> AccessOn { get; set; }
        public int AccessType { get; set; }
        public int AccessResult { get; set; }
        public bool MessageShown { get; set; }
        public int DenialReason { get; set; }
        public bool IsManualEntry { get; set; }
        public bool AddedBySystem { get; set; }
        public string Remark { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public string CreatedFrom { get; set; }
        public System.DateTime EditOn { get; set; }
        public string EditFrom { get; set; }
    }
}
