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
    
    public partial class System_JobTable
    {
        public int Id { get; set; }
        public int SystemID { get; set; }
        public string JobName { get; set; }
        public int UserID { get; set; }
        public System.DateTime RequestedStart { get; set; }
        public short JobPriority { get; set; }
        public short JobType { get; set; }
        public string JobParameter { get; set; }
        public short JobState { get; set; }
        public Nullable<System.DateTime> JobStarted { get; set; }
        public Nullable<System.DateTime> JobTerminated { get; set; }
        public System.DateTime JobCreated { get; set; }
        public string JobMessage { get; set; }
    }
}
