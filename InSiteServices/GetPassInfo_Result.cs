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
    
    public partial class GetPassInfo_Result
    {
        public Nullable<int> SystemID { get; set; }
        public Nullable<int> BpID { get; set; }
        public Nullable<int> PassID { get; set; }
        public Nullable<int> StatusID { get; set; }
        public Nullable<int> OwnerID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string ExternalID { get; set; }
        public Nullable<int> PassType { get; set; }
        public Nullable<System.DateTime> PrintedOn { get; set; }
        public Nullable<System.DateTime> AssignedOn { get; set; }
        public Nullable<System.DateTime> ActivatedOn { get; set; }
        public Nullable<System.DateTime> DeactivatedOn { get; set; }
        public Nullable<System.DateTime> LockedOn { get; set; }
        public Nullable<bool> IsDuplicate { get; set; }
    }
}