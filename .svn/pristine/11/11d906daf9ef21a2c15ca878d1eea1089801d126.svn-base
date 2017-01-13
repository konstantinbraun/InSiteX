using System;
using System.Configuration;
using System.Linq;
using Telerik.Web.UI;

namespace InSite.App.Views.Central
{
    public partial class UserChangePassword : BasePagePopUp
    {
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        String msg = "";
        int userID = 0;

        int minPwdLength = Convert.ToInt32(ConfigurationManager.AppSettings["MinPwdLength"]);

        protected void Page_Load(object sender, EventArgs e)
        {
            NewPwd.PasswordStrengthSettings.PreferredPasswordLength = minPwdLength;
            NewPwd.Focus();
        
            msg = Request.QueryString["UserID"];
            if (msg != null)
            {
                userID = Convert.ToInt32(msg);
            }
        }

        protected void UnloadMe()
        {
            string script = "<script language='javascript' type='text/javascript'>Sys.Application.add_load(cancelAndClose);</script>";
            RadScriptManager.RegisterStartupScript(this, this.GetType(), "cancelAndClose", script, false);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            UnloadMe();
        }

        protected void btnOK_Click(object sender, EventArgs e)
        {
            Notification1.AutoCloseDelay = 5000;
            Notification1.Title = Resources.Resource.lblChangePwd;

            if (!NewPwd.Text.Equals(NewPwdRepeat.Text))
            {
                Notification1.Text = Resources.Resource.msgPwdNotEqual;
                Notification1.ContentIcon = "warning";
            }
            else if (NewPwd.Text.Length < minPwdLength)
            {
                Notification1.Text = String.Format(Resources.Resource.msgPwdLength, minPwdLength);
                Notification1.ContentIcon = "warning";
            }
            else if (NewPwd.Text.Equals(string.Empty))
            {
                Notification1.Text = Resources.Resource.msgPwdEmpty;
                Notification1.ContentIcon = "warning";
            }
            else
            {
                Webservices webservice = new Webservices();
                int ret = webservice.UpdatePwd(userID, NewPwd.Text);
                if (ret == 1)
                {
                    Notification1.Text = Resources.Resource.msgPwdOldPwdFalse;
                    Notification1.ContentIcon = "warning";
                }
                else if (ret == 0)
                {
                    Notification1.Text = Resources.Resource.msgPwdChanged;
                    Notification1.ContentIcon = "info";
                    NewPwd.Text = string.Empty;
                    NewPwdRepeat.Text = string.Empty;
                    UnloadMe();
                }
                else
                {
                    Notification1.Text = Resources.Resource.msgGeneralFailure;
                    Notification1.ContentIcon = "warning";
                }
            }
            Notification1.Show();
        }

    }
}