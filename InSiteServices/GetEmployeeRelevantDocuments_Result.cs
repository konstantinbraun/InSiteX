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
    
    public partial class GetEmployeeRelevantDocuments_Result
    {
        public int SystemID { get; set; }
        public int BpID { get; set; }
        public int EmployeeID { get; set; }
        public byte RelevantFor { get; set; }
        public int RelevantDocumentID { get; set; }
        public string NameVisible { get; set; }
        public bool DocumentReceived { get; set; }
        public Nullable<System.DateTime> ExpirationDate { get; set; }
        public string IDNumber { get; set; }
        public string ToolTipExpiration { get; set; }
        public string ToolTipDocumentID { get; set; }
        public bool IsAccessRelevant { get; set; }
        public string CreatedFrom { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public string EditFrom { get; set; }
        public System.DateTime EditOn { get; set; }
        public bool RecExpirationDate { get; set; }
        public bool RecIDNumber { get; set; }
        public byte[] SampleData { get; set; }
    }
}
