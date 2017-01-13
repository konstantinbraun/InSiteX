using System;
using System.Linq;
using Telerik.Web.UI;

namespace InSite.App.Views.Costumization
{
    public partial class Layout : App.BasePage
    {
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

            }
            RadDropDownListLayout.SelectedValue = Session["Skin"].ToString();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            RadSkinManager skinManager = (RadSkinManager)this.Page.Master.FindControl("RadSkinManager1");
            skinManager.Skin = Session["PreviousSkin"].ToString();
            Helpers.ChangeSkin(Session["PreviousSkin"].ToString());
            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
            if (Session["Referrer"] != null && !Session["Referrer"].ToString().Contains("Layout.aspx"))
            {
                ajax.Redirect(Session["Referrer"].ToString());
            }
            else
            {
                ajax.Redirect("/InSiteApp/Views/Dashboard.aspx");
            }
        }

        protected void btnOK_Click(object sender, EventArgs e)
        {
            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
            if (Session["Referrer"] != null && !Session["Referrer"].ToString().Contains("Layout.aspx"))
            {
                ajax.Redirect(Session["Referrer"].ToString());
            }
            else
            {
                ajax.Redirect("/InSiteApp/Views/Dashboard.aspx");
            }
        }

        protected void RadDropDownListLayout_SelectedIndexChanged(object sender, DropDownListEventArgs e)
        {
            RadSkinManager skinManager = (RadSkinManager)this.Page.Master.FindControl("RadSkinManager1");
            skinManager.Skin = e.Value.ToString();
            Helpers.ChangeSkin(e.Value.ToString());
            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
            ajax.Redirect("/InSiteApp/Views/Costumization/Layout.aspx");
        }
    }
}