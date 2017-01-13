using InSite.App.UserServices;
using System;
using System.Linq;
using Telerik.Web.UI;

namespace InSite.App.Views.Main
{
    public partial class EmployeeAccessRightInfo : BasePagePopUp
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        int employeeID = 0;
        string msg = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.Title = Resources.Resource.lblAccessRightsInfo;

                msg = Request.QueryString["EmployeeID"];
                if (msg != null)
                {
                    employeeID = Convert.ToInt32(msg);
                    EmployeeID1.Text = msg;
                }

                if (!Helpers.IsFirstPass(employeeID))
                {
                    Webservices webservice = new Webservices();
                    GetEmployees_Result employeeResult = webservice.GetEmployees(0, employeeID, "", 0, 0)[0];
                    GetAccessRightEvents_Result rightResult = webservice.GetAccessRightEvents(employeeID, true)[0];
                    GetAccessAreaEvents_Result[] areasResult = webservice.GetAccessAreaEvents(rightResult.AccessRightEventID);

                    FirstName.Text = employeeResult.FirstName;
                    LastName.Text = employeeResult.LastName;
                    ExternalPassID.Text = rightResult.ExternalID;
                    InternalPassID.Text = rightResult.InternalID;
                    IsActive.Checked = rightResult.IsActive;
                    if (rightResult.ValidUntil != null)
                    {
                        ValidUntil.Text = string.Format("{0:g}", ((DateTime)rightResult.ValidUntil));
                    }
                    AccessAllowed.Checked = rightResult.AccessAllowed;
                    if (rightResult.AccessDenialReason != null)
                    {
                        DenialReasons.Text = rightResult.AccessDenialReason.Replace(Environment.NewLine, "<br/>");
                    }
                    Message.Text = rightResult.Message;
                    MessageFrom.Text = string.Format("{0:g}", ((DateTime)rightResult.MessageFrom));
                    MessageUntil.Text = string.Format("{0:g}", ((DateTime)rightResult.MessageUntil));
                    DeliveredAt.Text = rightResult.DeliveredAt.ToString();
                    DeliveryMessage.Text = rightResult.DeliveryMessage;

                    AssignedAreasInfo.DataSource = areasResult;
                    AssignedAreasInfo.Rebind();
                }
                else
                {
                    UnloadMe();
                }
            }
        }

        protected void UnloadMe()
        {
            string script = "<script language='javascript' type='text/javascript'>Sys.Application.add_load(cancelAndClose);</script>";
            RadScriptManager.RegisterStartupScript(this, this.GetType(), "cancelAndClose", script, false);
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            UnloadMe();
        }
    }
}