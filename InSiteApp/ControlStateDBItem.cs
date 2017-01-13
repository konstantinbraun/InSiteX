using System;
using System.Linq;

namespace InSite.App
{
    public class ControlStateDBItem
    {
        public int SystemID { get; set; }

        public int UserID { get; set; }

        public string UserKey { get; set; }

        public string UserSettings { get; set; }

        public DateTime LastUpdate { get; set; }

        public ControlStateDBItem()
        {
            SystemID = 0;
            UserID = 0;
            UserKey = string.Empty;
            UserSettings = string.Empty;
        }
    }
}