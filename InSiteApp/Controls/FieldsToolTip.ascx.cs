using System;
using System.Linq;
using System.Web.UI.WebControls;

namespace InSite.App.Controls
{
    public partial class FieldsToolTip : System.Web.UI.UserControl
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

            HiddenField hf = (HiddenField)FieldToolTip.FindControl("ResourceID");
            if (hf != null && hf.Value != null && !hf.Value.Equals(string.Empty))
            {
                ((Label)FieldToolTip.FindControl("NameVisible")).Text = (String)GetGlobalResourceObject("Resource", hf.Value);
            }
        }
    }    
}