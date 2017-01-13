using InSite.App.UserServices;
using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Costumization
{
    public partial class Languages : App.BasePage
    {
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected void Page_Load(object sender, EventArgs e)
        {

            // RadSplitBar splitBar = (RadSplitBar)this.Page.Master.FindControl("RadSplitBar1");
            // RadPane pane = (RadPane)splitBar.FindControl("RadPaneTree");
            // pane.Collapsed = true;
        }

        protected void RadDropDownList1_ItemDataBound(object sender, Telerik.Web.UI.DropDownListItemEventArgs e)
        {
            string flagHome = ConfigurationManager.AppSettings["FlagFilesHome"];
            string flagName = (e.Item.DataItem as DataRowView)["FlagName"].ToString();
            if (!flagName.Equals(string.Empty))
            {
                Image img = (Image)e.Item.FindControl("ItemImage");
                img.ImageUrl = string.Concat(flagHome, flagName);
                Label lbl = (Label)e.Item.FindControl("ItemText");
                lbl.Text = (e.Item.DataItem as DataRowView)["LanguageName"].ToString();
            }
        }

        private void SetCurrentCulture(string currentCulture, bool transfer)
        {
            Session["currentCulture"] = currentCulture;
            UserAssignments user = Helpers.GetCurrentUserAssignment();
            user.LanguageID = currentCulture;
            Helpers.SetCurrentUserAssignment(user);
            Webservices webservice = new Webservices();
            webservice.UpdateUser("LanguageID", currentCulture);
            // this.Page.Master.FindControl("RadTreeView2").DataBind();
            if (transfer)
            {
                RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect(Request.Path);
            }
        }

        protected void RadDropDownList1_DataBound(object sender, EventArgs e)
        {
            UserAssignments user = Helpers.GetCurrentUserAssignment();
            string currentCulture = user.LanguageID;
            if (currentCulture.Length > 2)
            {
                currentCulture = currentCulture.Substring(0, 2) + "-" + currentCulture.Substring(3, 2).ToUpper();
            }
            string currentValue = "de";
            foreach (DropDownListItem item in RadDropDownList1.Items)
            {
                if (item.Value.Contains(currentCulture))
                {
                    currentValue = item.Value;
                }
            }

            RadDropDownList1.FindItemByValue(currentValue).Selected = true;
        }

        protected void RadDropDownList1_ItemSelected(object sender, Telerik.Web.UI.DropDownListEventArgs e)
        {
            string currentCulture = e.Value.ToString();
            SetCurrentCulture(currentCulture, true);
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            SetCurrentCulture(Session["previousCulture"].ToString(), false);
            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
            ajax.Redirect("/InSiteApp/Views/Dashboard.aspx");
        }

        protected void btnOK_Click(object sender, EventArgs e)
        {
            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
            ajax.Redirect("/InSiteApp/Views/Dashboard.aspx");
        }
    }
}