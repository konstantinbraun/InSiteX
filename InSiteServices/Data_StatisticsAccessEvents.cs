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
    
    public partial class Data_StatisticsAccessEvents
    {
        public int SystemID { get; set; }
        public int BfID { get; set; }
        public int BpID { get; set; }
        public System.DateTime StatisticsDate { get; set; }
        public int AccessAreaID { get; set; }
        public int PassType { get; set; }
        public int CountEnter { get; set; }
        public int CountExit { get; set; }
        public Nullable<System.DateTime> SnapshotTimestamp { get; set; }
    }
}
