using System;
using System.Linq;
using System.Web.UI;
using Telerik.Web.UI;

namespace InSite.App.Views.Costumization
{
    public partial class LogViewer : App.BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session["TreeViewNodeID"] = null;
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            GridFilteringItem filteringItem = e.Item as GridFilteringItem;
            if (filteringItem != null)
            {
                LiteralControl literalFrom = filteringItem["LoggingDate"].Controls[0] as LiteralControl;
                literalFrom.Text = Resources.Resource.lblFrom + " ";
                LiteralControl literalTo = filteringItem["LoggingDate"].Controls[3] as LiteralControl;
                literalTo.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
            }
        }

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }
        }
    }
}