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
    using System.Collections.Generic;
    
    public partial class Data_ShortTermPassesPrint
    {
        public int SystemID { get; set; }
        public int BpID { get; set; }
        public int PrintID { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public byte[] FileData { get; set; }
        public string PrintedFrom { get; set; }
        public Nullable<System.DateTime> PrintedOn { get; set; }
    }
}
