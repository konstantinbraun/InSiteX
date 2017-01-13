using System;
using System.Linq;

namespace InSite.App.Controls
{
    public partial class FirstAidersToolTip : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string DetailID
        {
            get
            {
                if (ViewState["DetailID"] == null)
                {
                    return "";
                }
                return (string)ViewState["DetailID"];
            }
            set
            {
                ViewState["DetailID"] = value;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            base.OnPreRender(e);
            this.SqlDataSource_Details.SelectParameters["DetailID"].DefaultValue = this.DetailID;
            this.DataBind();
        }
    }
}