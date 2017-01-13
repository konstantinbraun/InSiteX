using InSite.App.Constants;
using InSite.App.CMServices;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class TradeGroups : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "TradeGroupID";

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

        protected void SqlDataSource_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            String ret = e.Command.Parameters["@ReturnValue"].Value.ToString();
            Helpers.DialogLogger(type, Actions.Create, ret, Resources.Resource.lblActionCreate);

            // Behältermanagement aktualisieren
            ContainerManagementClient client = new ContainerManagementClient();
            int systemID = Convert.ToInt32(Session["SystemID"]);
            int bpID = Convert.ToInt32(Session["BpID"]);
            try
            {
                client.TradeData(systemID, bpID, Convert.ToInt32(ret), Actions.Insert);
            }
            catch (WebException ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
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

                // Behältermanagement aktualisieren
                ContainerManagementClient client = new ContainerManagementClient();
                int systemID = Convert.ToInt32(Session["SystemID"]);
                int bpID = Convert.ToInt32(Session["BpID"]);
                try
                {
                    client.TradeData(systemID, bpID, Convert.ToInt32((e.Item as GridDataItem).GetDataKeyValue(idName)), Actions.Delete);
                }
                catch (WebException ex)
                {
                    logger.Error("Exception: " + ex.Message);
                    if (ex.InnerException != null)
                    {
                        logger.Error("Inner Exception: " + ex.InnerException.Message);
                    }
                    logger.Debug("Exception Details: \n" + ex);
                }
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

        protected void RadGrid1_DetailTableDataBind(object sender, GridDetailTableDataBindEventArgs e)
        {
            // Überschriften für Detailtabellen zusammenbauen
            if (e.DetailTableView.ParentItem.DataItem != null)
            {
                string parent = (e.DetailTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                e.DetailTableView.Caption = String.Concat(parent, ": ", Resources.Resource.lblTrades);
            }
        }

        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            if (e.Item.OwnerTableView.Name.Equals("TradeGroups"))
            {
                switch (e.CommandName)
                {
                    case RadGrid.UpdateCommandName:
                        {
                            GridEditableItem editedItem = (GridEditableItem)e.Item;
                            SqlDataSource_TradeGroups.UpdateParameters["PassColor"].DefaultValue = ColorTranslator.ToHtml(((RadColorPicker)editedItem.FindControl("RadColorPicker1")).SelectedColor);
                            break;
                        }
                    case RadGrid.PerformInsertCommandName:
                        {
                            GridEditableItem insertItem = (GridEditableItem)e.Item;
                            SqlDataSource_TradeGroups.InsertParameters["PassColor"].DefaultValue = ColorTranslator.ToHtml(((RadColorPicker)insertItem.FindControl("RadColorPicker1")).SelectedColor);
                            break;
                        }
                }
            }

            // RowClick abhandeln
            if (e.CommandName == "RowClick")
            {
                GridDataItem item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);
                item.Expanded = !item.Expanded;
            }
        }

        protected void RadGridTrades_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblTrades);

            // RowClick abhandeln
            if (e.CommandName == "RowClick")
            {
                GridDataItem item = e.Item.OwnerTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue("TradeID").ToString(), Resources.Resource.lblActionView);
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
                    string tabText = string.Concat(parentText, ": ", Resources.Resource.lblTrades);
                    RadTabStrip tabStrip = (RadTabStrip)e.Item.FindControl("TabStrip1");
                    tabStrip.Tabs[0].Text = tabText;
                }
            }

            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGridTrades_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue("TradeID").ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        protected void RadGridTrades_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            // Update-Message
            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, e.Exception.Message), "red");

                // Behältermanagement aktualisieren
                ContainerManagementClient client = new ContainerManagementClient();
                int systemID = Convert.ToInt32(Session["SystemID"]);
                int bpID = Convert.ToInt32(Session["BpID"]);
                try
                {
                    client.TradeData(systemID, bpID, Convert.ToInt32((e.Item as GridEditFormItem).GetDataKeyValue("TradeID")), Actions.Update);
                }
                catch (WebException ex)
                {
                    logger.Error("Exception: " + ex.Message);
                    if (ex.InnerException != null)
                    {
                        logger.Error("Inner Exception: " + ex.InnerException.Message);
                    }
                    logger.Debug("Exception Details: \n" + ex);
                }
            }
            else
            {
                Helpers.DialogLogger(type, Actions.Edit, (e.Item as GridEditFormItem).GetDataKeyValue("TradeID").ToString(), Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
            }
        }

        protected void RadGridTrades_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGridTrades_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                (item["deleteColumn"].Controls[0] as ImageButton).Visible = DeleteColumnVisible();
            }
        }

        protected bool DeleteColumnVisible()
        {

            string tableName = "Master_Companies";

            SqlParameterCollection collection = (SqlParameterCollection)typeof(SqlParameterCollection).GetConstructor(BindingFlags.NonPublic | BindingFlags.Instance, null, Type.EmptyTypes, null).Invoke(null);
            SqlParameter par;

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            collection.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            collection.Add(par);

            int rowCount = 0;
            Webservices webservice = new Webservices();
            rowCount = webservice.RowCount(tableName, collection);
            if (rowCount == 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                (item["deleteColumn"].Controls[0] as ImageButton).Visible = DeleteColumnVisible();
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