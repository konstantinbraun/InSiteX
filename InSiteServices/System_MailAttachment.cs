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
    
    public partial class System_MailAttachment
    {
        public int Id { get; set; }
        public int SystemID { get; set; }
        public int MailID { get; set; }
        public int DocumentID { get; set; }
        public Nullable<System.DateTime> AttachmentRead { get; set; }
    
        public virtual System_Documents System_Documents { get; set; }
        public virtual System_Mailbox System_Mailbox { get; set; }
    }
}
