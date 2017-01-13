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
    
    public partial class GetPassBillings_Result
    {
        public int SystemID { get; set; }
        public int BpID { get; set; }
        public int CompanyID { get; set; }
        public int ParentID { get; set; }
        public int IsMainContractor { get; set; }
        public string CompanyName { get; set; }
        public string NameAdditional { get; set; }
        public string Address1 { get; set; }
        public string Address2 { get; set; }
        public string Zip { get; set; }
        public string City { get; set; }
        public string CountryID { get; set; }
        public int EmployeeID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string ReplacementCase { get; set; }
        public int PassID { get; set; }
        public string ExternalID { get; set; }
        public string Reason { get; set; }
        public Nullable<System.DateTime> PrintedOn { get; set; }
        public string PrintedFrom { get; set; }
        public int PrintCount { get; set; }
        public Nullable<System.DateTime> ActivatedOn { get; set; }
        public string ActivatedFrom { get; set; }
        public int ActiveCount { get; set; }
        public Nullable<System.DateTime> LockedOn { get; set; }
        public string LockedFrom { get; set; }
        public int LockCount { get; set; }
        public decimal Cost { get; set; }
        public string Currency { get; set; }
        public Nullable<bool> CreditForOldPass { get; set; }
        public string InvoiceTo { get; set; }
        public Nullable<bool> WillBeCharged { get; set; }
        public string Remarks { get; set; }
        public string TreeLevel { get; set; }
        public decimal PassBudget { get; set; }
        public int FirstPassCount { get; set; }
        public int SecondPassCount { get; set; }
    }
}