using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace InSite.App.Views.Configuration
{
    public partial class BuildingProjectInfo : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected void Page_Load(object sender, EventArgs e)
        {
            Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT TypeID, BpID, NameVisible ");
            sql.Append("FROM Master_BuildingProjects ");
            sql.AppendFormat("WHERE (SystemID = {0}) ", Session["SystemID"]);
            sql.AppendFormat("UNION SELECT 0 TypeID, 0 BpID, '{0}' NameVisible ", Resources.Resource.lblNoTemplate);
            sql.Append("ORDER BY TypeID, NameVisible ");
            SqlDataSource_BasedOn.SelectCommand = sql.ToString();

            this.Page.Title = Session["BpName"].ToString();
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