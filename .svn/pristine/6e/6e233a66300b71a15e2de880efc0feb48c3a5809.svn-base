using InSite.App.Constants;
using InSite.App.Controls;
using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class RolesRights : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "RoleID";

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

        public void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem)
            {
                if (e.Item.OwnerTableView.Name.Equals("Roles"))
                {
                    this.RadToolTipManager1.TargetControls.Add(e.Item.ClientID, (e.Item as GridDataItem).GetDataKeyValue("RoleID").ToString() + ":0", true);
                }
                else if (e.Item.OwnerTableView.Name.Equals("Dialogs"))
                {
                    this.RadToolTipManager1.TargetControls.Add(e.Item.ClientID, (e.Item as GridDataItem).GetDataKeyValue("DialogID").ToString() + ":1", true);
                }
                else if (e.Item.OwnerTableView.Name.Equals("Actions"))
                {
                    this.RadToolTipManager1.TargetControls.Add(e.Item.ClientID, (e.Item as GridDataItem).GetDataKeyValue("ActionID").ToString() + ":2", true);
                }
                else if (e.Item.OwnerTableView.Name.Equals("Fields"))
                {
                    this.RadToolTipManager1.TargetControls.Add(e.Item.ClientID, (e.Item as GridDataItem).GetDataKeyValue("FieldID").ToString() + ":3", true);
                }
            }

            if (e.Item.OwnerTableView.Name.Equals("Fields") || e.Item.OwnerTableView.Name.Equals("Dialogs") || e.Item.OwnerTableView.Name.Equals("Actions"))
            {
                if (e.Item.DataItem != null)
                {
                    // Übersetzungen aus den lokalen Ressourcen
                    if ((e.Item.DataItem as DataRowView)["ResourceID"] != null)
                    {
                        string resourceID = (e.Item.DataItem as DataRowView)["ResourceID"].ToString();
                        if (!resourceID.Equals(string.Empty))
                        {
                            Label l = (Label)e.Item.FindControl("NameVisible");
                            if (l != null)
                            {
                                l.Text = (String)GetGlobalResourceObject("Resource", resourceID);
                            }
                        }
                    }
                }
            }
        
            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100);
                ImageButton btn = (item["deleteColumn"].Controls[0] as ImageButton);
                btn.Visible = deleteColumnVisible;
            }
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

        // RowClick abhandeln
        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            GridDataItem item = e.Item as GridDataItem;

            if (e.CommandName == "Sort" || e.CommandName == "Page" || e.CommandName == "Filter")
            {
                RadToolTipManager1.TargetControls.Clear();
            }

            // Deteilbereich ein- und ausblenden
            if (e.CommandName == RadGrid.ExpandCollapseCommandName && e.Item is GridDataItem)
            {
                // item.Expanded = !item.Expanded;
            }

            if (e.CommandName == "RowClick")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args[0].Equals("Expand"))
                {
                    int index = args[2].LastIndexOf('_');
                    int tableIndex = int.Parse(args[2].Substring(index + 1));
                    item = GetTableView(this.RadGrid1.MasterTableView, args[1]).Items[tableIndex];
                    item.Expanded = !item.Expanded;
                }
            }
        }

        protected void OnAjaxUpdate(object sender, ToolTipUpdateEventArgs args)
        {
            this.UpdateToolTip(args.Value, args.UpdatePanel);
        }

        private void UpdateToolTip(string elementID, UpdatePanel panel)
        {
            Control ctrl = null;

            string[] vals = elementID.Split(new char[] { ':' });
            if (vals.Length > 1)
            {
                switch (vals[1])
                {
                    case "0":
                        {
                            ctrl = Page.LoadControl("/InSiteApp/Controls/RolesToolTip.ascx");
                            RolesToolTip details = (RolesToolTip)ctrl;
                            details.DetailID = vals[0];
                            break;
                        }
                    case "1":
                        {
                            ctrl = Page.LoadControl("/InSiteApp/Controls/DialogsToolTip.ascx");
                            DialogsToolTip details = (DialogsToolTip)ctrl;
                            details.DetailID = vals[0];
                            break;
                        }
                    case "2":
                        {
                            ctrl = Page.LoadControl("/InSiteApp/Controls/ActionsToolTip.ascx");
                            ActionsToolTip details = (ActionsToolTip)ctrl;
                            details.DetailID = vals[0];
                            break;
                        }
                    case "3":
                        {
                            ctrl = Page.LoadControl("/InSiteApp/Controls/FieldsToolTip.ascx");
                            FieldsToolTip details = (FieldsToolTip)ctrl;
                            details.DetailID = vals[0];
                            break;
                        }
                }

                try
                {
                    panel.ContentTemplateContainer.Controls.Add(ctrl);
                }
                catch (Exception ex)
                {
                }
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
                    // string parentText = parentItem["NameVisible"].ToString();
                    // string tabText = string.Concat(parentText, ": ", Resources.Resource.lblDialogs);
                    // RadTabStrip tabStrip = (RadTabStrip)e.Item.FindControl("TabStrip1");
                    // tabStrip.Tabs[0].Text = tabText;
                }
            }

            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGrid1_DetailTableDataBind(object sender, GridDetailTableDataBindEventArgs e)
        {
            // Überschriften für Detailtabellen zusammenbauen
            if (e.DetailTableView.ParentItem.DataItem != null)
            {
                string parent = (e.DetailTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                switch (e.DetailTableView.Name)
                {
                    case "Dialogs":
                        {
                            e.DetailTableView.Caption = String.Concat(parent, ": ", Resources.Resource.lblDialogs);
                            break;
                        }
                    case "Actions":
                        {
                            if (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem != null)
                            {
                                parent = (String)GetGlobalResourceObject("Resource", (e.DetailTableView.ParentItem.DataItem as DataRowView)["ResourceID"].ToString());
                                string parent1 = (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                                // string parent1 = (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                                e.DetailTableView.Caption = String.Concat(parent1, "/", parent, ": ", Resources.Resource.lblActions);
                            }
                            break;
                        }
                    case "Fields":
                        {
                            if (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.OwnerTableView.ParentItem.DataItem != null)
                            {
                                parent = (String)GetGlobalResourceObject("Resource", (e.DetailTableView.ParentItem.DataItem as DataRowView)["ResourceID"].ToString());
                                string parent1 = (String)GetGlobalResourceObject("Resource", (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem as DataRowView)["ResourceID"].ToString());
                                // string parent1 = (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                                string parent2 = (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.OwnerTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                                // string parent2 = (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.OwnerTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                                e.DetailTableView.Caption = String.Concat(parent2, "/", parent1, "/", parent, ": ", Resources.Resource.lblFields);
                            }
                            break;
                        }
                }
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