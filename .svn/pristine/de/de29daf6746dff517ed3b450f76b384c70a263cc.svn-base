using InSite.App.Constants;
using InSite.App.Models;
using Stimulsoft.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using InSite.App.Models.Extensions;
using System.IO;
using InSite.App.CustomControls;

namespace InSite.App.Views.Central
{
    public partial class ReportConfiguration : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "TariffID";
        private string messageTitle = null;
        private string gridMessage = null;
        private string messageColor = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);
                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            }
            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Literal für Statusmeldungen
            Helpers.AddGridStatus(RadGrid1, Page);
        }

        private void DisplayMessage(string command, string text, string color)
        {
            // Meldung in Statuszeile und per Notification
            Helpers.UpdateGridStatus(RadGrid1, command, text, color);
            Helpers.ShowMessage(Master, command, text, color);
        }

        private void SetMessage(string command, string message, string color)
        {
            // Message-Variablen belegen
            messageTitle = command;
            gridMessage = message;
            messageColor = color;
        }

        public string GetDisplayText(int value)
        {
            return ((ReportVisibility)value).GetDisplayName();
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;

            if (e.CommandName == "ExpandCollapse")
            {
                foreach (GridDataItem otheritem in RadGrid1.MasterTableView.Items)
                {
                    if (item.GetDataKeyValue("Id").ToString() != otheritem.GetDataKeyValue("Id").ToString())
                        otheritem.Expanded = false;
                }

                foreach (GridNestedViewItem item1 in RadGrid1.MasterTableView.GetItems(GridItemType.NestedView)) // loop through the nested items of a NestedView Template 
                {
                    wcBpSwitcher switcher = (wcBpSwitcher)item1.FindControl("BpSwitcher");
                    switcher.MasterId = (int)item.GetDataKeyValue("Id");
                    switcher.Initalize(new BuildingProjectSwitcher());

                    switcher = (wcBpSwitcher)item1.FindControl("RoleSwitcher");
                    switcher.MasterId = (int)item.GetDataKeyValue("Id");
                    switcher.Initalize(new RoleSwitcher());
                }
            }
        }
    }
}