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
    
    public partial class System_TariffWages
    {
        public int SystemID { get; set; }
        public int TariffID { get; set; }
        public int TariffContractID { get; set; }
        public int TariffScopeID { get; set; }
        public int TariffWageGroupID { get; set; }
        public int TariffWageID { get; set; }
        public string NameVisible { get; set; }
        public string DescriptionShort { get; set; }
        public System.DateTime ValidFrom { get; set; }
        public decimal Wage { get; set; }
        public string CreatedFrom { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public string EditFrom { get; set; }
        public System.DateTime EditOn { get; set; }
    }
}
