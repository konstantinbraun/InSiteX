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
    
    public partial class GetTemplates_Result
    {
        public int SystemID { get; set; }
        public int BpID { get; set; }
        public int TemplateID { get; set; }
        public string NameVisible { get; set; }
        public string DescriptionShort { get; set; }
        public string FileName { get; set; }
        public byte[] FileData { get; set; }
        public string FileType { get; set; }
        public int DialogID { get; set; }
        public bool IsDefault { get; set; }
        public string CreatedFrom { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public string EditFrom { get; set; }
        public System.DateTime EditOn { get; set; }
    }
}
