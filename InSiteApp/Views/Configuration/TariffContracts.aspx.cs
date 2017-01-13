using InSite.App.Constants;
using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class TariffContracts : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "TariffContractID";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            }
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

        protected void SqlDataSource_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            String ret = e.Command.Parameters["@ReturnValue"].Value.ToString();
            Helpers.DialogLogger(type, Actions.Create, ret, Resources.Resource.lblActionCreate);
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
                Helpers.DialogLogger(type, Actions.Edit, (e.Item as GridEditFormItem).GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionUpdate);
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
                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionDelete);
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

        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            // RowClick abhandeln
            if (e.CommandName == "RowClick")
            {
                GridDataItem item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);
                item.Expanded = !item.Expanded;
            }
        }

        protected void RadGridTariffData_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblTariffData);

            // RowClick abhandeln
            if (e.CommandName == "RowClick")
            {
                GridDataItem item = e.Item.OwnerTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue("TariffDataID").ToString(), Resources.Resource.lblActionView);
                item.Expanded = !item.Expanded;
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
                    string tabText = string.Concat(parentText, ": ", Resources.Resource.lblTariffData);
                    RadTabStrip tabStrip = (RadTabStrip)e.Item.FindControl("TabStrip1");
                    tabStrip.Tabs[0].Text = tabText;

                    Session["tariffValue1Name"] = parentItem["TariffValue1Name"].ToString();
                    Session["tariffValue2Name"] = parentItem["TariffValue2Name"].ToString();
                    Session["tariffValue3Name"] = parentItem["TariffValue3Name"].ToString();
                    Session["tariffValue4Name"] = parentItem["TariffValue4Name"].ToString();
                }
            }
            if (e.Item is GridHeaderItem)
            {
                GridHeaderItem header = (GridHeaderItem)e.Item;
                ((LiteralControl)header["TariffValue1Name"].Controls[0]).Text = String.Format((String)GetGlobalResourceObject("Resource", "lblTariffXValueHeader"), "1");
                ((LiteralControl)header["TariffValue2Name"].Controls[0]).Text = String.Format((String)GetGlobalResourceObject("Resource", "lblTariffXValueHeader"), "2");
                ((LiteralControl)header["TariffValue3Name"].Controls[0]).Text = String.Format((String)GetGlobalResourceObject("Resource", "lblTariffXValueHeader"), "3");
                ((LiteralControl)header["TariffValue4Name"].Controls[0]).Text = String.Format((String)GetGlobalResourceObject("Resource", "lblTariffXValueHeader"), "4");
            }
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100);
                (item["deleteColumn"].Controls[0] as ImageButton).Visible = deleteColumnVisible;
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem insertItem = (GridEditFormItem)e.Item;
                TableCell cell = (TableCell)insertItem["TariffValue1Name"].Parent.Controls[0];
                cell.Font.Size = 8;
                cell.Text = String.Format((String)GetGlobalResourceObject("Resource", "lblTariffXValueHeader"), "1") + ": ";
                cell = (TableCell)insertItem["TariffValue2Name"].Parent.Controls[0];
                cell.Font.Size = 8;
                cell.Text = String.Format((String)GetGlobalResourceObject("Resource", "lblTariffXValueHeader"), "2") + ": ";
                cell = (TableCell)insertItem["TariffValue3Name"].Parent.Controls[0];
                cell.Font.Size = 8;
                cell.Text = String.Format((String)GetGlobalResourceObject("Resource", "lblTariffXValueHeader"), "3") + ": ";
                cell = (TableCell)insertItem["TariffValue4Name"].Parent.Controls[0];
                cell.Font.Size = 8;
                cell.Text = String.Format((String)GetGlobalResourceObject("Resource", "lblTariffXValueHeader"), "4") + ": ";

            }
        }

        protected void RadGridTariffData_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100);
                (item["deleteColumn"].Controls[0] as ImageButton).Visible = deleteColumnVisible;
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem insertItem = (GridEditFormItem)e.Item;
                TableCell cell = (TableCell)insertItem["TariffValue1"].Parent.Controls[0];
                cell.Font.Size = 8;
                cell.Text = Session["tariffValue1Name"].ToString() + ": ";
                cell = (TableCell)insertItem["TariffValue2"].Parent.Controls[0];
                cell.Font.Size = 8;
                cell.Text = Session["tariffValue2Name"].ToString() + ": ";
                cell = (TableCell)insertItem["TariffValue3"].Parent.Controls[0];
                cell.Font.Size = 8;
                cell.Text = Session["tariffValue3Name"].ToString() + ": ";
                cell = (TableCell)insertItem["TariffValue4"].Parent.Controls[0];
                cell.Font.Size = 8;
                cell.Text = Session["tariffValue4Name"].ToString() + ": ";

            }
        }

        protected void RadGridTariffData_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridHeaderItem)
            {
                GridHeaderItem header = (GridHeaderItem)e.Item;

                ((LiteralControl)header["TariffValue1"].Controls[0]).Text = Session["tariffValue1Name"].ToString();
                ((LiteralControl)header["TariffValue2"].Controls[0]).Text = Session["tariffValue2Name"].ToString();
                ((LiteralControl)header["TariffValue3"].Controls[0]).Text = Session["tariffValue3Name"].ToString();
                ((LiteralControl)header["TariffValue4"].Controls[0]).Text = Session["tariffValue4Name"].ToString();
            }
        }

        protected void RadGridTariffData_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue("TariffDataID").ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        protected void RadGridTariffData_ItemUpdated(object sender, GridUpdatedEventArgs e)
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
                Helpers.DialogLogger(type, Actions.Edit, (e.Item as GridEditFormItem).GetDataKeyValue("TariffDataID").ToString(), Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
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