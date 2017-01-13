using InSite.App.Constants;
using InSite.App.UserServices;
using System;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class DialogsFields : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

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

        public void RadGrid1_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            // Bezeichnung aus Ressource übersetzen
            if (e.Item.OwnerTableView.Name.Equals("Fields") || e.Item.OwnerTableView.Name.Equals("Dialogs"))
            {
                if (e.Item.DataItem != null)
                {
                    if ((e.Item.DataItem as DataRowView)["ResourceID"] != null)
                    {
                        string resourceID = (e.Item.DataItem as DataRowView)["ResourceID"].ToString();
                        if (!resourceID.Equals(string.Empty))
                        {
                            Label lbl = (Label)e.Item.FindControl("NameVisible");
                            if (lbl != null)
                            {
                                lbl.Text = (String)GetGlobalResourceObject("Resource", resourceID);
                            }
                        }
                    }
                }
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode && e.Item.OwnerTableView.Name.Equals("Translations"))
            {
                GridEditFormItem editFormItem = (GridEditFormItem)e.Item;

                bool hasVariables = Convert.ToBoolean((e.Item.DataItem as DataRowView)["HasVariables"]);
                // Feldübersetzung benutzt Variablen => Editor sichtbar machen
                editFormItem["DescriptionTranslated"].Parent.Visible = !hasVariables;
                editFormItem["HtmlTranslated"].Parent.Visible = hasVariables;
                RadEditor re = editFormItem.FindControl("HtmlTranslated") as RadEditor;
                if (hasVariables)
                {
                    // Feldübersetzung benutzt Variablen
                    if (re != null)
                    {
                        // Variablen für Feld ermitteln
                        int fieldID = Convert.ToInt32((e.Item.DataItem as DataRowView)["FieldID"]);
                        System_Variables[] variables = Helpers.GetVariables(fieldID);
                        re.Snippets.Clear();
                        if (variables != null && variables.Count() > 0)
                        {
                            // Variablen als Textbausteine zum Editor hinzufügen 
                            foreach(System_Variables variable in variables)
                            {
                                re.Snippets.Add(GetResource(variable.ResourceID), variable.VariablePattern);
                            }
                        }
                    }
                }
                else
                {
                    if (re != null)
                    {
                        re.Snippets.Clear();
                    }
                }
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
                String id = (e.Item as GridEditFormItem).GetDataKeyValue("DialogID").ToString() + "|";
                id += (e.Item as GridEditFormItem).GetDataKeyValue("FieldID").ToString();
                Helpers.DialogLogger(type, Actions.Edit, id.ToString(), Resources.Resource.lblActionUpdate);
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
                String id = (e.Item as GridDataItem).GetDataKeyValue("RoleID").ToString() + "|";
                id += (e.Item as GridDataItem).GetDataKeyValue("DialogID").ToString() + "|";
                id += (e.Item as GridDataItem).GetDataKeyValue("ActionID").ToString() + "|";
                id += (e.Item as GridDataItem).GetDataKeyValue("FieldID").ToString();
                Helpers.DialogLogger(type, Actions.Delete, id, Resources.Resource.lblActionDelete);
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

        public void RadGrid1_DetailTableDataBind(object sender, Telerik.Web.UI.GridDetailTableDataBindEventArgs e)
        {
            // Überschriften für Detailtabellen zusammenbauen
            if (e.DetailTableView.ParentItem.DataItem != null)
            {
                string parent = (String)GetGlobalResourceObject("Resource", (e.DetailTableView.ParentItem.DataItem as DataRowView)["ResourceID"].ToString());
                switch (e.DetailTableView.Name)
                {
                    case "Fields":
                        {
                            e.DetailTableView.Caption = String.Concat(parent, ": ", Resources.Resource.lblFields);
                            break;
                        }
                    case "Translations":
                        {
                            if (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem != null)
                            {
                                string parent1 = (String)GetGlobalResourceObject("Resource", (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem as DataRowView)["ResourceID"].ToString());
                                e.DetailTableView.Caption = String.Concat(parent1, "/", parent, ": ", Resources.Resource.lblTranslations);
                            }
                            break;
                        }
                }
            }
        }
 
        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            // Only one active edit form 
            RadGrid grid = (sender as RadGrid);
            if (e.CommandName == RadGrid.InitInsertCommandName)
            {
                grid.MasterTableView.ClearEditItems();
            }
            if (e.CommandName == RadGrid.EditCommandName)
            {
                e.Item.OwnerTableView.IsItemInserted = false;
            }

            if (e.CommandName == "Sort" || e.CommandName == "Page")
            {
                // RadToolTipManager1.TargetControls.Clear();
            }

            if (e.CommandName == "RowClick")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args[0].Equals("Expand"))
                {
                    int index = args[2].LastIndexOf('_');
                    int tableIndex = int.Parse(args[2].Substring(index + 1));
                    GridDataItem item = GetTableView(this.RadGrid1.MasterTableView, args[1]).Items[tableIndex];
                    item.Expanded = !item.Expanded;
                }
            }
        }

        private void ExpandCollapseAllRows(bool expand)
        {
            foreach (GridItem item in RadGrid1.MasterTableView.Items)
            {
                item.Expanded = expand;
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
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