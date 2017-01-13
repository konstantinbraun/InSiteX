using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InSite.App.Models
{
    public class clsAccessEvent
    {
        public int AccessEventId { get; set; }
        public int SystemId { get; set; }
        public int BpId { get; set; }
        public int AccessAreaId { get; set; }
        public string InternalId { get; set; }
        public DateTime? AccessOn { get; set; }
        public string OriginalMessage { get; set; }
        public bool  IsManualEntry { get; set; }
        public bool IsOnlineAccessEvent { get; set; }
        public int Result { get; set; }
        public int AccessTypeID { get; set; }
        public string AccessTypeToolTip
        {
            get
            {
                string ret;
                switch (AccessTypeID)
                {
                    case 0:
                        {
                            ret = Resources.Resource.lblAccessTypeLeaving;
                            break;
                        }
                    case 1:
                        {
                            ret = Resources.Resource.lblAccessTypeComing;
                            break;
                        }
                    default:
                        {
                            ret = Resources.Resource.lblAccessTypeUnknown;
                            break;
                        }
                }
                return ret;
            }
        }
        public string AccessTypeImage
        {
            get
            {
                if (AccessTypeID == 1)
                    return "~/Resources/Icons/enter-16.png";
                else
                    return "~/Resources/Icons/exit-16.png";
            }
        }
        public DateTime CreatedOn { get; set; }
        public DateTime EditOn { get; set; }
        public string EditFrom { get; set; }
        public string CreatedFrom { get; set; }

        public bool IsComing
        {
            get
            {
                if (AccessTypeID == 0)
                    return false;
                else
                    return true;
            }
        }

        public bool IsLeaving
        {
            get
            {
                if (AccessTypeID == 1)
                    return false;
                else
                    return true;
            }
        }

    }
}