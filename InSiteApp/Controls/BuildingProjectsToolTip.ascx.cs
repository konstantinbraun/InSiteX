using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace InSite.App.Controls
{
    public partial class BuildingProjectsToolTip : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public string BpID
        {
            get
            {
                if (ViewState["BpID"] == null)
                {
                    return "";
                }
                return (string)ViewState["BpID"];
            }
            set
            {
                ViewState["BpID"] = value;
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT TypeID, BpID, NameVisible ");
            sql.Append("FROM Master_BuildingProjects ");
            sql.AppendFormat("WHERE (SystemID = {0}) ", Session["SystemID"]);
            sql.AppendFormat("UNION SELECT 0 TypeID, 0 BpID, '{0}' NameVisible ", Resources.Resource.lblNoTemplate);
            sql.Append("ORDER BY TypeID, NameVisible ");
            SqlDataSource_BasedOn.SelectCommand = sql.ToString();

            base.OnPreRender(e);
            this.SqlDataSource_BPDetails.SelectParameters["BpID"].DefaultValue = this.BpID;
            this.DataBind();
        }

        protected void RadDropDownList3_ItemDataBound(object sender, Telerik.Web.UI.DropDownListItemEventArgs e)
        {
            string flagHome = ConfigurationManager.AppSettings["FlagFilesHome"];
            string flagName = (e.Item.DataItem as DataRowView)["FlagName"].ToString();
            if (!flagName.Equals(string.Empty))
            {
                Image img = (Image)e.Item.FindControl("ItemImage");
                img.ImageUrl = string.Concat(flagHome, flagName);
                Label lbl = (Label)e.Item.FindControl("ItemText");
                lbl.Text = (e.Item.DataItem as DataRowView)["CountryName"].ToString();
            }
        }
    }
}