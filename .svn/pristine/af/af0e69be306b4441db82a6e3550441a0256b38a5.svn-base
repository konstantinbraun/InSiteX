using System;
using System.Linq;

namespace InSite.App.Controls
{
    public partial class UsersToolTip : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string UserID
        {
            get
            {
                if (ViewState["UserID"] == null)
                {
                    return "";
                }
                return (string)ViewState["UserID"];
            }
            set
            {
                ViewState["UserID"] = value;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            this.SqlDataSource_User_Detail.SelectParameters["UserID"].DefaultValue = this.UserID;
            this.DataBind();
        }
    }
}