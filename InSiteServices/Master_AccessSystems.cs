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
    
    public partial class Master_AccessSystems
    {
        public int SystemID { get; set; }
        public int BpID { get; set; }
        public int AccessSystemID { get; set; }
        public Nullable<System.DateTime> LastUpdate { get; set; }
        public bool AllTerminalsOnline { get; set; }
        public System.DateTime LastCompress { get; set; }
        public Nullable<System.DateTime> LastGetAccessEvents { get; set; }
        public Nullable<System.DateTime> CompressStartTime { get; set; }
        public Nullable<System.DateTime> LastGetAccessRights { get; set; }
        public Nullable<System.DateTime> LastUpdateAccessRights { get; set; }
        public Nullable<System.DateTime> LastOfflineState { get; set; }
        public Nullable<System.DateTime> LastAddition { get; set; }
    }
}
