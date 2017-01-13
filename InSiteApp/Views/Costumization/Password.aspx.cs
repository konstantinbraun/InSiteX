using InSite.App.UserServices;
using System;
using System.Configuration;
using System.Linq;
using System.Web.UI;
using Telerik.Web.UI;

namespace InSite.App.Views.Costumization
{
    public partial class Password : App.BasePage
    {
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        String msg = "";

        int minPwdLength = Convert.ToInt32(ConfigurationManager.AppSettings["MinPwdLength"]);

        protected void Page_Load(object sender, EventArgs e)
        {
            NewPwd.PasswordStrengthSettings.PreferredPasswordLength = minPwdLength;
            OldPwd.Focus();

            msg = Request.QueryString["Msg"];
            if (msg != null && msg.Equals("PleaseChange"))
            {
                Helpers.Notification(this.Page.Master, Resources.Resource.lblPassword, Resources.Resource.msgPleaseChangePwd);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
            ajax.Redirect(Session["Referrer"].ToString());
        }

        protected void btnOK_Click(object sender, EventArgs e)
        {
            RadNotification notification = (RadNotification)this.Page.Master.FindControl("Notification");
            notification.AutoCloseDelay = 5000;
            notification.Title = Resources.Resource.lblChangePwd;

            if (OldPwd.Text.Equals(NewPwd.Text))
            {
                notification.Text = Resources.Resource.msgPwdEqualsOld;
                notification.ContentIcon = "warning";
            }
            else if (!NewPwd.Text.Equals(NewPwdRepeat.Text))
            {
                notification.Text = Resources.Resource.msgPwdNotEqual;
                notification.ContentIcon = "warning";
            }
            else if (NewPwd.Text.Length < minPwdLength)
            {
                notification.Text = String.Format(Resources.Resource.msgPwdLength, minPwdLength);
                notification.ContentIcon = "warning";
            }
            else if (NewPwd.Text.Equals(string.Empty) || OldPwd.Text.Equals(string.Empty))
            {
                notification.Text = Resources.Resource.msgPwdEmpty;
                notification.ContentIcon = "warning";
            }
            else
            {
                Webservices webservice = new Webservices();
                int ret = webservice.UpdatePwd(OldPwd.Text, NewPwd.Text);
                if (ret == 1)
                {
                    notification.Text = Resources.Resource.msgPwdOldPwdFalse;
                    notification.ContentIcon = "warning";
                }
                else
                {
                    notification.Text = Resources.Resource.msgPwdChanged;
                    notification.ContentIcon = "info";
                    OldPwd.Text = string.Empty;
                    NewPwd.Text = string.Empty;
                    NewPwdRepeat.Text = string.Empty;

                    UserAssignments user = Helpers.GetCurrentUserAssignment();
                    if (user.NeedsPwdChange)
                    {
                        user.NeedsPwdChange = false;
                        Helpers.SetCurrentUserAssignment(user);

                        RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
                        if (Session["BpID"] == null || Convert.ToInt32(Session["BpID"]) == 0)
                        {
                            ajax.Redirect("/InSiteApp/Views/BuildingProjectsSelect.aspx?Msg=PleaseSelect");
                        }
                        else
                        {
                            Master_BuildingProjects bp = webservice.GetBpInfo(Convert.ToInt32(Session["BpID"]));
                            Session["BpName"] = bp.NameVisible;
                            ajax.Redirect("/InSiteApp/Views/Dashboard.aspx?Msg=Welcome");
                        }
                    }
                }
            }
            notification.Show();
            UpdatePanel panel = this.Page.Master.FindControl("PanelNotification") as UpdatePanel;
            if (panel != null && panel.UpdateMode == UpdatePanelUpdateMode.Conditional)
            {
                panel.Update();
            }
        }
    }
}