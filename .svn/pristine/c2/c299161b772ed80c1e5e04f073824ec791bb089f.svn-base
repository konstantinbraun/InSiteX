using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace InSite.App.Models
{
    public class clsBpContact
    {
        public int Id { get; set; }
        public int BpId { get; set; }
        public string FirstName { get; set; }
        public string  LastName { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Comments { get; set; }
        public bool IsZplContact { get; set; }
        public string BuildingProject { get; set; }

        public string FullName {
            get
            {
                return string.Format("{0} {1}", this.FirstName, this.LastName);
            }
        }

        public string ImageUrl
        {
            get
            {
                if (this.IsZplContact)
                    return "~/Resources/Icons/TitleIcon.png";
                else
                    return "~/Resources/Icons/Staff_16.png";
            }
        }
    }
}