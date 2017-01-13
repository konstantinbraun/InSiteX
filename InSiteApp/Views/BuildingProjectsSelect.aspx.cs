using InSite.App.UserServices;
using System;
using System.Linq;
using Telerik.Web.UI;

namespace InSite.App.Views
{
    public partial class BuildingProjectsSelect : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        String msg = "";
        
        protected void Page_Load(object sender, EventArgs e)
        {
            RadListBoxBpSelect.Focus();

            if (!this.IsPostBack)
            {
                msg = Request.QueryString["Msg"];
                if (msg != null && msg.Equals("PleaseSelect"))
                {
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblBuildingProject, Resources.Resource.msgPleaseSelect);
                }

                InitBpSelect();
            }
        }

        protected void BtnSelect_Click(object sender, EventArgs e)
        {
            if (RadListBoxBpSelect.SelectedValue != null && !RadListBoxBpSelect.SelectedValue.Equals(string.Empty))
            {
                Session["BpID"] = RadListBoxBpSelect.SelectedValue;
                Webservices webservice = new Webservices();
                Master_BuildingProjects bp = webservice.GetBpInfo(Convert.ToInt32(Session["BpID"]));
                Session["BpName"] = bp.NameVisible;
                Session["PresenceLevel"] = bp.PresentType;
                int systemID = (int)Session["SystemID"];
                UserAssignments user = Helpers.GetUserAssignment(systemID, Convert.ToInt32(RadListBoxBpSelect.SelectedValue));
                Helpers.SetUserSession(user);

                log4net.GlobalContext.Properties["BpID"] = RadListBoxBpSelect.SelectedValue;
                RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect("/InSiteApp/Views/Dashboard.aspx?Msg=Welcome");
            }
            else
            {
                Helpers.Notification(this.Page.Master, Resources.Resource.lblBuildingProject, Resources.Resource.msgPleaseSelect);
            }
        }

        protected void RadListBoxBpSelect_DataBound(object sender, EventArgs e)
        {
            if (Session["BpID"] != null)
            {
                RadListBoxBpSelect.SelectedValue = Session["BpID"].ToString();
            }
        }

        private void InitBpSelect()
        {
            UserAssignments[] users = (SessionData.SomeData["User"] as UserAssignments[]);
            RadListBoxBpSelect.DataSource = users;
            RadListBoxBpSelect.DataBind();
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
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
    }
}