using System;
using System.Linq;
using System.Configuration;

namespace InSite.App.ViewStatePersister
{
    public class CustomPageStatePersisterConfiguration
    {
        
        private const string CONFIGURATION_KEY = "CustomPageStatePersister";
        private const string CONFIGURATION_OFF = "off";
        private const string CONFIGURATION_COMPRESS = "compress";
        private const string CONFIGURATION_SQL = "sql";
        private const string CONFIGURATION_CACHE = "cache";
        private const string CONFIGURATION_CUSTOM = "custom";


        public bool IsSwitchOff {get;set;}
        public bool IsCompressed { get; set; }
        public bool IsSqlPersisted { get; set; }
        public bool IsCached { get; set; }
        public bool IsOnCustomPageOnly { get; set; }

        public CustomPageStatePersisterConfiguration()
        {
            IsSwitchOff = true;
            IsCompressed = false;
            IsSqlPersisted =false;
            IsCached = false;
            IsOnCustomPageOnly = false;

            string configString = ConfigurationManager.AppSettings[CONFIGURATION_KEY];
            if (!string.IsNullOrEmpty(configString))
            {
                configString = configString.ToLower();

                if (!configString.Contains(CONFIGURATION_OFF))
                    IsSwitchOff = false;

                if (configString.Contains(CONFIGURATION_COMPRESS))
                    IsCompressed = true;

                if (configString.Contains(CONFIGURATION_SQL))
                    IsSqlPersisted = true;

                if (configString.Contains(CONFIGURATION_CACHE))
                    IsCached = true;

                if (configString.Contains(CONFIGURATION_CUSTOM))
                    IsOnCustomPageOnly = true;

            }
        }


    }
}


