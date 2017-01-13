using InSite.App.Constants;
using System;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class Countries : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

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


        protected void RadGrid1_ItemInserted(object sender, GridInsertedEventArgs e)
        {
            // Insert-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, e.Exception.Message), "red");
            }
            else
            {
                SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
            }
        }

        protected void RadGrid1_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            // Update-Message
            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, e.Exception.Message), "red");
            }
            else
            {
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
            }
        }

        protected void RadGrid1_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        private void DisplayMessage(string command, string text, string color)
        {
            // Meldung in Statuszeile und per Notification
            Helpers.UpdateGridStatus(RadGrid1, command, text, color);
            Helpers.ShowMessage(Master, command, text, color);
        }

        private string messageTitle = null;
        private string gridMessage = null;
        private string messageColor = null;
        private void SetMessage(string command, string message, string color)
        {
            // Message-Variablen belegen
            messageTitle = command;
            gridMessage = message;
            messageColor = color;
        }

        protected void RadGrid1_PreRender(object sender, EventArgs e)
        {
            // Gefilterte Spalten hervorheben
            foreach (GridColumn item in (sender as RadGrid).MasterTableView.Columns)
            {
                string filterValue = item.CurrentFilterValue;
                if (filterValue != null && !filterValue.Equals(string.Empty))
                {
                    item.HeaderStyle.ForeColor = System.Drawing.Color.DarkRed;
                    item.HeaderStyle.Font.Bold = true;
                }
                else
                {
                    item.HeaderStyle.ForeColor = System.Drawing.Color.Black;
                    item.HeaderStyle.Font.Bold = false;
                }
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            if (e.CommandName == "RowClick")
            {
                GridDataItem item = e.Item.OwnerTableView.Items[e.CommandArgument as string];
                item.Expanded = !item.Expanded;
            }

            //if (e.CommandName == "RowClick" || e.CommandName == RadGrid.ExpandCollapseCommandName)
            //{
            //    foreach (GridItem item in e.Item.OwnerTableView.Items)
            //    {
            //        if (item.Expanded && item != e.Item.OwnerTableView.Items[e.CommandArgument as string])
            //        {
            //            item.Expanded = false;
            //        }
            //    }
            //}
        }

        protected void RadGrid1_DetailTableDataBind(object sender, GridDetailTableDataBindEventArgs e)
        {
            // Überschriften für Detailtabellen zusammenbauen
            if (e.DetailTableView.ParentItem.DataItem != null)
            {
                string parent = (e.DetailTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                e.DetailTableView.Caption = String.Concat(parent, ": ", Resources.Resource.lblCountries);
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            // Überschrift für erstes Register zusammenbauen
            if (e.Item is GridNestedViewItem)
            {
                DataRowView parentItem = ((GridNestedViewItem)e.Item).ParentItem.DataItem as DataRowView;
                if (parentItem != null)
                {
                    string parentText = parentItem["NameVisible"].ToString();
                    string tabText = string.Concat(parentText, ": ", Resources.Resource.lblCountries);
                    RadTabStrip tabStrip = (RadTabStrip)e.Item.FindControl("TabStrip1");
                    tabStrip.Tabs[0].Text = tabText;
                }
            }

            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGridCountries_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblCountries);

            if (e.CommandName == "RowClick")
            {
                GridDataItem item = e.Item.OwnerTableView.Items[e.CommandArgument as string];
                item.Expanded = !item.Expanded;
            }
        }

        protected void RadGridCountries_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void SqlDataSource_Countries_Deleting(object sender, SqlDataSourceCommandEventArgs e)
        {
            string ret = e.Command.Parameters["@original_CountryID"].Value.ToString();
            Helpers.DialogLogger(type, Actions.Delete, ret, Resources.Resource.lblActionDelete);
            Helpers.CountryChanged(ret);
        }

        protected void SqlDataSource_Countries_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            string ret = e.Command.Parameters["@original_CountryID"].Value.ToString();
            Helpers.DialogLogger(type, Actions.Edit, ret, Resources.Resource.lblActionUpdate);
            Helpers.CountryChanged(ret);
        }

        protected void SqlDataSource_Countries_Inserting(object sender, SqlDataSourceCommandEventArgs e)
        {
            string ret = e.Command.Parameters["@CountryID"].Value.ToString();
            Helpers.DialogLogger(type, Actions.Create, ret, Resources.Resource.lblActionCreate);
            Helpers.CountryChanged(ret);
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