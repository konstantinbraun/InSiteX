using System.ComponentModel.DataAnnotations;
using System.Drawing;

namespace InSite.App.Models
{
    public enum ReportVisibility
    {
        [Display (Name = "Nicht verfügbar")  ]
        NotVisible,
        [Display(Name = "Nur für Admins verfügbar")]
        VisibleForAdmins,
        [Display(Name = "Für alle verfügbar")]
        VisibleForUsers
    }
    public class clsReport
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string ReportData { get; set; }
        public ReportVisibility ReportVisibility { get; set; }

        public int ReportVisibilityInt
        {
            get
            {
                return (int)this.ReportVisibility;
            }
            set
            {
                ReportVisibility = (ReportVisibility)value;
            }
        }

        public Color ItemColor
        {
            get
            {
                if (string.IsNullOrEmpty(this.ReportData))
                    return Color.Red;
                else
                    return Color.Green;
            }
        }
    }
}