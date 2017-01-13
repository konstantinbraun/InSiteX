using System;
using Resources;
using System.Linq;

namespace InSite.App.Constants
{
    public class JobFrequency
    {
        public const int OnceOnly = 0;
        public const int Daily = 1;
        public const int Weekly = 2;
        public const int Monthly = 3;

        public string GetLocalizedString(int frequency)
        {
            string frequencyString = "";

            switch (frequency)
            {
                case OnceOnly:
                    frequencyString = Resource.lblOnceOnly;
                    break;
                case Daily:
                    frequencyString = Resource.lblDaily;
                    break;
                case Weekly:
                    frequencyString = Resource.lblWeekly;
                    break;
                case Monthly:
                    frequencyString = Resource.lblMonthly;
                    break;
                default:
                    frequencyString = Resource.lblOnceOnly;
                    break;
            }

            return frequencyString;
        }
    }
}