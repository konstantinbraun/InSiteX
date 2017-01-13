using InSite.App.UserServices;
using System;
using System.Linq;

namespace InSite.App.Controls
{
    public partial class EmployeeDetails : System.Web.UI.UserControl
    {
        public int EmployeeID { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            Webservices webservice = new Webservices();
            GetEmployees_Result[] result = webservice.GetEmployees(0, EmployeeID, "", 0, 0);
            EmployeeDetailsFormView.DataSource = result;
            EmployeeDetailsFormView.DataBind();
        }

        public String GetRelevantFor(int relevantFor)
        {
            string ret = "";
            switch (relevantFor)
            {
                case 0:
                    {
                        ret = Resources.Resource.selRDNone;
                        break;
                    }
                case 1:
                    {
                        ret = Resources.Resource.selRDLaborRight;
                        break;
                    }
                case 2:
                    {
                        ret = Resources.Resource.selRDResidenceRight;
                        break;
                    }
                case 3:
                    {
                        ret = Resources.Resource.selRDLegitimation;
                        break;
                    }
                case 4:
                    {
                        ret = Resources.Resource.selRDInsurance;
                        break;
                    }
                case 5:
                    {
                        ret = Resources.Resource.selRDInsuranceAdditional;
                        break;
                    }
                default:
                    {
                        ret = Resources.Resource.selRDNone;
                        break;
                    }
            }
            return ret;
        }

        public String GetResource(String resourceName)
        {
            object res = GetGlobalResourceObject("Resource", resourceName);
            if (res != null)
            {
                return res.ToString();
            }
            else
            {
                return "";
            }
        }

        public string GetAccessState(int accessState)
        {
            string ret;
            switch (accessState)
            {
                case 0:
                    {
                        ret = Resources.Resource.lblAccessStateAbsent;
                        break;
                    }
                case 1:
                    {
                        ret = Resources.Resource.lblAccessStatePresent;
                        break;
                    }
                case 2:
                    {
                        ret = Resources.Resource.lblAccessStateUndefined;
                        break;
                    }
                case 3:
                    {
                        ret = Resources.Resource.lblAccessStateNoAccess;
                        break;
                    }
                default:
                    {
                        ret = Resources.Resource.lblAccessStateUndefined;
                        break;
                    }
            }
            return ret;
        }

        public string GetAccessType(int accessType)
        {
            string ret = "";
            switch (accessType)
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
}