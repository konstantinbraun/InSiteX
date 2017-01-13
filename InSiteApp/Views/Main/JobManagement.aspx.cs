using InSite.App.Constants;
using InSite.App.AdminServices;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Services.Protocols;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Main
{
    public partial class JobManagement : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "JobID";
        private int action = Actions.View;

        private int lastID = 0;

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);

            fca = GetFieldsConfig(Helpers.GetDialogID(type.Name));
            ViewState["fca"] = fca;
            rights = GetRights(fca);
            ViewState["rights"] = rights;

            // View allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.View))
            {
                RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect("/InSiteApp/Views/Dashboard.aspx?Msg=NoViewRight");
            }

            // Insert allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Create))
            {
                RadGrid1.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = false;
            }

            // Edit allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
            {
                RadGrid1.MasterTableView.GetColumn("EditCommandColumn").Visible = false;
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Literal für Statusmeldungen
            Helpers.AddGridStatus(RadGrid1, Page);

            Helpers.GotoLastEdited(RadGrid1, lastID, idName);
        }

        protected void RadGrid1_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            GridDataItem item = e.Item as GridDataItem;

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

            // Deteilbereich ein- und ausblenden
            if (e.CommandName == RadGrid.ExpandCollapseCommandName && e.Item is GridDataItem)
            {
                item.ChildItem.FindControl("InnerContainer").Visible = !e.Item.Expanded;
            }

            if (e.CommandName == "RowClick")
            {
                // RowClick abhandeln
                item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);

                item.ChildItem.FindControl("InnerContainer").Visible = !e.Item.Expanded;

                item.Expanded = !item.Expanded;

                Helpers.SetAction(Actions.View);
            }

            if (e.CommandName == "PerformInsert")
            {

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

            // Detailbereich des ersten Elements einblenden
            if (!Page.IsPostBack)
            {
                // RadGrid1.MasterTableView.Items[0].Expanded = true;
                // RadGrid1.MasterTableView.Items[0].ChildItem.FindControl("InnerContainer").Visible = true;
            }
        }

        protected void RadGrid1_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;

            // Feldsteuerung
            if (e.Item is GridEditFormItem)
            {
                if (e.Item is GridEditFormInsertItem)
                {
                    // Insert
                    FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Create, e, false);
                }
                else
                {
                    if (Helpers.GetAction() == Actions.Release)
                    {
                        // Release
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Release, e, false);
                    }
                    else if (Helpers.GetAction() == Actions.Lock)
                    {
                        // Lock
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Lock, e, false);
                    }
                    else
                    {
                        // Edit
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Edit, e, false);
                    }
                }
            }
            else
            {
                // View
                FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.View, e, false);
            }

            if (item != null)
            {
                ImageButton button = e.Item.FindControl("ReleaseButton") as ImageButton;
                button.Visible = true;
                button.Enabled = false;

                int statusID = Convert.ToInt32((item.DataItem as DataRowView)["StatusID"]);
                button.ToolTip = Status.GetStatusString(statusID);

                if (statusID == Status.Done)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/release.png";
                    button.CommandName = "ExecuteNow";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.WaitExecute || statusID == Status.Created)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/schedule_22.png";
                    button.CommandName = "ExecuteNow";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.Executing)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/hourglass_22.png";
                }
                else if (statusID == Status.Deactivated)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Red-X.png";
                }
                else
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/schedule_22.png";
                }
                button.CommandArgument = item.GetDataKeyValue("JobID").ToString();
            }

            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                GridEditableItem editItem = e.Item as GridEditableItem;
                RadAutoCompleteBox acb = editItem.FindControl("Receiver") as RadAutoCompleteBox;
                if (acb != null)
                {
                    string valueReceiver = (editItem.FindControl("ReceiverValue") as HiddenField).Value;
                    string[] receivers = valueReceiver.Split(';');
                    for (int i = 0; i < receivers.Length; i++)
                    {
                        int userID = 0;
                        string receiver = receivers[i];
                        if (Helpers.IsValidEmail(receiver))
                        {
                            acb.Entries.Add(new AutoCompleteBoxEntry(receiver));
                        }
                        else if (Int32.TryParse(receiver, out userID))
                        {
                            Master_Users user = Helpers.GetUser(userID);
                            if (user != null)
                            {
                                string userName = user.LastName + ", " + user.FirstName;
                                acb.Entries.Add(new AutoCompleteBoxEntry(userName, userID.ToString()));
                            }
                        }
                    }
                }

                RadComboBox cb = editItem.FindControl("Frequency") as RadComboBox;
                Panel panelWeekly = editItem.FindControl("PanelWeekly") as Panel;
                Panel panelMonthly = editItem.FindControl("PanelMonthly") as Panel;

                switch (cb.SelectedValue)
                {
                    case "0":
                        panelWeekly.Visible = false;
                        panelMonthly.Visible = false;
                        break;
                    case "1":
                        panelWeekly.Visible = false;
                        panelMonthly.Visible = false;
                        break;
                    case "2":
                        panelWeekly.Visible = true;
                        panelMonthly.Visible = false;
                        break;
                    case "3":
                        panelWeekly.Visible = false;
                        panelMonthly.Visible = true;
                        break;
                    default:
                        panelWeekly.Visible = false;
                        panelMonthly.Visible = false;
                        break;
                }
            }

            if (e.Item is GridNestedViewItem)
            {
                GridNestedViewItem nestedViewItem = e.Item as GridNestedViewItem;
                HiddenField hf = nestedViewItem.FindControl("FrequencyValue") as HiddenField;
                Panel panelWeekly = nestedViewItem.FindControl("PanelWeekly") as Panel;
                Panel panelMonthly = nestedViewItem.FindControl("PanelMonthly") as Panel;

                switch (hf.Value)
                {
                    case "0":
                        panelWeekly.Visible = false;
                        panelMonthly.Visible = false;
                        break;
                    case "1":
                        panelWeekly.Visible = false;
                        panelMonthly.Visible = false;
                        break;
                    case "2":
                        panelWeekly.Visible = true;
                        panelMonthly.Visible = false;
                        break;
                    case "3":
                        panelWeekly.Visible = false;
                        panelMonthly.Visible = true;
                        break;
                    default:
                        panelWeekly.Visible = false;
                        panelMonthly.Visible = false;
                        break;
                }
            }

            if (e.Item is GridDataItem)
            {
                int statusID = Convert.ToInt32((item.DataItem as DataRowView)["StatusID"]);
                if (statusID == Status.Executing)
                {
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Enabled = false;
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Visible = false;

                    (item["deleteColumn"].Controls[0] as ImageButton).Enabled = false;
                    (item["deleteColumn"].Controls[0] as ImageButton).Visible = false;
                }
                else if (statusID == Status.Deactivated)
                {
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Enabled = false;
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Visible = false;
                }
            }

        }

        protected void RadGrid1_ItemUpdated(object sender, Telerik.Web.UI.GridUpdatedEventArgs e)
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
                lastID = Convert.ToInt32((e.Item as GridEditFormItem).GetDataKeyValue(idName));
                Helpers.DialogLogger(type, Actions.Edit, lastID.ToString(), Resources.Resource.lblActionUpdate);

                System_Jobs job;
                int statusID = 0;
                AdminServiceClient adminService = new AdminServiceClient();
                try
                {
                    job = adminService.GetJob(Convert.ToInt32(Session["SystemID"]), lastID);
                    statusID = adminService.RefreshJob(job);
                }
                catch (SoapException ex)
                {
                    logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                }
                catch (Exception ex)
                {
                    logger.ErrorFormat("Webservice error: {0}", ex.Message);
                }

                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                action = Actions.View;
            }
        }

        protected void RadGrid1_ItemCreated(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
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

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }
        }

        protected string GetFrequencyName(int frequency)
        {
            string frequencyName = string.Empty;

            switch(frequency)
            {
                case 0:
                    frequencyName = Resources.Resource.lblOnceOnly;
                    break;

                case 1:
                    frequencyName = Resources.Resource.lblDaily;
                    break;

                case 2:
                    frequencyName = Resources.Resource.lblWeekly;
                    break;

                case 3:
                    frequencyName = Resources.Resource.lblMonthly;
                    break;

                default:
                    frequencyName = Resources.Resource.lblUnknown;
                    break;
            }

            return frequencyName;
        }

        protected void Frequency_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Panel panelWeekly = ((sender as RadComboBox).NamingContainer as GridEditFormItem).FindControl("PanelWeekly") as Panel;
            Panel panelMonthly = ((sender as RadComboBox).NamingContainer as GridEditFormItem).FindControl("PanelMonthly") as Panel;

            switch (e.Value)
            {
                case "0":
                    panelWeekly.Visible = false;
                    panelMonthly.Visible = false;
                    break;
                case "1":
                    panelWeekly.Visible = false;
                    panelMonthly.Visible = false;
                    break;
                case "2":
                    panelWeekly.Visible = true;
                    panelMonthly.Visible = false;
                    break;
                case "3":
                    panelWeekly.Visible = false;
                    panelMonthly.Visible = true;
                    break;
                default:
                    panelWeekly.Visible = false;
                    panelMonthly.Visible = false;
                    break;
            }
        }

        protected void DayMo_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 0, (sender as CheckBox).Checked);
        }

        protected void DayTu_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 1, (sender as CheckBox).Checked);
        }

        protected void DayWe_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 2, (sender as CheckBox).Checked);
        }

        protected void DayTh_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 3, (sender as CheckBox).Checked);
        }

        protected void DayFr_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 4, (sender as CheckBox).Checked);
        }

        protected void DaySa_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 5, (sender as CheckBox).Checked);
        }

        protected void DaySu_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 6, (sender as CheckBox).Checked);
        }

        private string GetValidDays(string validDays, int dayPos, bool dayValid)
        {
            string dayValue;
            if (dayValid)
            {
                dayValue = "1";
            }
            else
            {
                dayValue = "0";
            }
            validDays = validDays.Remove(dayPos, 1).Insert(dayPos, dayValue);
            return validDays;
        }

        protected bool GetValidForDay(string validDays, int dayPos)
        {
            string dayValue = validDays.Substring(dayPos, 1);
            return (dayValue == "1");
        }

        protected void Receiver_EntryAdded(object sender, AutoCompleteEntryEventArgs e)
        {
            RadAutoCompleteBox acb = sender as RadAutoCompleteBox;
            HiddenField hf = (acb.NamingContainer as GridEditableItem).FindControl("ReceiverValue") as HiddenField;
            int userID = 0;
            hf.Value = string.Empty;
            for (int i = 0; i < acb.Entries.Count; i++)
            {
                AutoCompleteBoxEntry entry = acb.Entries[i];
                if (i > 0)
                {
                    hf.Value += ";";
                }
                if (Helpers.IsValidEmail(entry.Text))
                {
                    hf.Value += entry.Text;
                }
                else if (Int32.TryParse(entry.Value, out userID))
                {
                    hf.Value += entry.Value;
                }
            }
        }

        protected void Receiver_EntryRemoved(object sender, AutoCompleteEntryEventArgs e)
        {
            RadAutoCompleteBox acb = sender as RadAutoCompleteBox;
            HiddenField hf = (acb.NamingContainer as GridEditableItem).FindControl("ReceiverValue") as HiddenField;
            int userID = 0;
            hf.Value = string.Empty;
            for (int i = 0; i < acb.Entries.Count; i++)
            {
                AutoCompleteBoxEntry entry = acb.Entries[i];
                if (i > 0)
                {
                    hf.Value += ";";
                }
                if (Helpers.IsValidEmail(entry.Text))
                {
                    hf.Value += entry.Text;
                }
                else if (Int32.TryParse(entry.Value, out userID))
                {
                    hf.Value += entry.Value;
                }
            }
        }
    }
}