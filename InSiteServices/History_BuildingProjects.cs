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
    
    public partial class History_BuildingProjects
    {
        public int SystemID { get; set; }
        public int BpID { get; set; }
        public string NameVisible { get; set; }
        public string DescriptionShort { get; set; }
        public byte TypeID { get; set; }
        public int BasedOn { get; set; }
        public bool IsVisible { get; set; }
        public string CountryID { get; set; }
        public string BuilderName { get; set; }
        public byte PresentType { get; set; }
        public bool MWCheck { get; set; }
        public int MWHours { get; set; }
        public int MWDeadline { get; set; }
        public int MWLackTrigger { get; set; }
        public bool MinWageAccessRelevance { get; set; }
        public string Address { get; set; }
        public int DefaultRoleID { get; set; }
        public int DefaultAccessAreaID { get; set; }
        public int DefaultTimeSlotGroupID { get; set; }
        public int DefaultSTAccessAreaID { get; set; }
        public int DefaultSTTimeSlotGroupID { get; set; }
        public bool PrintPassOnCompleteDocs { get; set; }
        public int DefaultTariffScope { get; set; }
        public string ContainerManagementName { get; set; }
        public int AccessRightValidDays { get; set; }
        public string CreatedFrom { get; set; }
        public System.DateTime CreatedOn { get; set; }
        public string EditFrom { get; set; }
        public System.DateTime EditOn { get; set; }
    }
}
