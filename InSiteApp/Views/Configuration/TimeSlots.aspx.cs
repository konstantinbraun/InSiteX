using InSite.App.Constants;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class TimeSlots : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "TimeSlotGroupID";
        private int action = Actions.View;

        private int lastID = 0;

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

        protected void RadGrid1_ItemInserted(object sender, Telerik.Web.UI.GridInsertedEventArgs e)
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
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");

                Helpers.TimeSlotChanged(Convert.ToInt32(e.Item.GetDataKeyValue("TimeSlotID")));
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

        protected void RadGrid1_ItemCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            if (e.CommandName == "RowClick")
            {
                GridDataItem item = e.Item.OwnerTableView.Items[e.CommandArgument as string];
                item.Expanded = !item.Expanded;
            }
        }

        protected void RadGrid1_ItemCreated(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            // Überschrift für erstes Register zusammenbauen
            //if (e.Item is GridNestedViewItem)
            //{
            //    DataRowView parentItem = ((GridNestedViewItem)e.Item).ParentItem.DataItem as DataRowView;
            //    if (parentItem != null)
            //    {
            //        string parentText = parentItem["NameVisible"].ToString();
            //        string tabText = string.Concat(parentText, ": ", Resources.Resource.lblCountries);
            //        RadTabStrip tabStrip = (RadTabStrip)e.Item.FindControl("TabStrip1");
            //        tabStrip.Tabs[0].Text = tabText;
            //    }
            //}

            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;
                StringBuilder sql = new StringBuilder();
                SqlConnection con = new SqlConnection(ConnectionString);
                SqlParameter par = new SqlParameter();

                if (e.Item.OwnerTableView.Name.Equals("TimeSlotGroups"))
                {
                    sql.Append("INSERT INTO Master_TimeSlotGroups (SystemID, BpID, NameVisible, DescriptionShort, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                    sql.AppendLine("VALUES (@SystemID, @BpID, @NameVisible, @DescriptionShort, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()); ");
                    sql.Append("SELECT @TimeSlotGroupID = SCOPE_IDENTITY(); ");

                    SqlCommand cmd = new SqlCommand(sql.ToString(), con);

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BpID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@NameVisible", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("NameVisible") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@DescriptionShort", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("DescriptionShort") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                    par.Value = Session["LoginName"].ToString();
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@TimeSlotGroupID", SqlDbType.Int);
                    par.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(par);

                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    try
                    {
                        cmd.ExecuteNonQuery();

                        if (cmd.Parameters["@TimeSlotGroupID"].Value != DBNull.Value)
                        {
                            lastID = Convert.ToInt32(cmd.Parameters["@TimeSlotGroupID"].Value);
                        }

                        Helpers.DialogLogger(type, Actions.Create, lastID.ToString(), Resources.Resource.lblActionCreate);
                        SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                        action = Actions.View;
                        RadGrid1.MasterTableView.IsItemInserted = false;
                        RadGrid1.MasterTableView.Rebind();
                        lastID = 0;
                    }
                    catch (SqlException ex)
                    {
                        SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
                    }
                    catch (System.Exception ex)
                    {
                        SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
                    }
                    finally
                    {
                        con.Close();
                    }
                }
                else if (e.Item.OwnerTableView.Name.Equals("TimeSlots"))
                {
                    sql.Append("INSERT INTO Master_TimeSlots (SystemID, BpID, TimeSlotGroupID, NameVisible, DescriptionShort, ValidFrom, ValidUntil, ValidDays, TimeFrom, TimeUntil, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                    sql.AppendLine("VALUES (@SystemID, @BpID, @TimeSlotGroupID, @NameVisible, @DescriptionShort, @ValidFrom, @ValidUntil, @ValidDays, @TimeFrom, @TimeUntil, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()); ");
                    sql.Append("SELECT @TimeSlotID = SCOPE_IDENTITY(); ");

                    SqlCommand cmd = new SqlCommand(sql.ToString(), con);

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BpID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@TimeSlotGroupID", SqlDbType.Int);
                    par.Value = Convert.ToInt32((e.Item as GridEditableItem).OwnerTableView.ParentItem.GetDataKeyValue("TimeSlotGroupID"));
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@NameVisible", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("NameVisible") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@DescriptionShort", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("DescriptionShort") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ValidFrom", SqlDbType.DateTime);
                    if ((item.FindControl("ValidFrom") as RadDatePicker).SelectedDate != null)
                    {
                        par.Value = (item.FindControl("ValidFrom") as RadDatePicker).SelectedDate;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ValidUntil", SqlDbType.DateTime);
                    if ((item.FindControl("ValidUntil") as RadDatePicker).SelectedDate != null)
                    {
                        par.Value = (item.FindControl("ValidUntil") as RadDatePicker).SelectedDate;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ValidDays", SqlDbType.Char, 7);
                    par.Value = (item.FindControl("ValidDays") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@TimeFrom", SqlDbType.Time);
                    if ((item.FindControl("TimeFrom") as RadTimePicker).SelectedTime != null)
                    {
                        par.Value = (item.FindControl("TimeFrom") as RadTimePicker).SelectedTime;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@TimeUntil", SqlDbType.Time);
                    if ((item.FindControl("TimeUntil") as RadTimePicker).SelectedTime != null)
                    {
                        par.Value = (item.FindControl("TimeUntil") as RadTimePicker).SelectedTime;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                    par.Value = Session["LoginName"].ToString();
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@TimeSlotID", SqlDbType.Int);
                    par.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(par);

                    if (con.State != ConnectionState.Open)
                    {
                        con.Open();
                    }
                    try
                    {
                        cmd.ExecuteNonQuery();

                        if (cmd.Parameters["@TimeSlotID"].Value != DBNull.Value)
                        {
                            lastID = Convert.ToInt32(cmd.Parameters["@TimeSlotID"].Value);
                            Helpers.TimeSlotChanged(lastID);
                        }

                        Helpers.DialogLogger(type, Actions.Create, lastID.ToString(), Resources.Resource.lblActionCreate);
                        SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                        action = Actions.View;
                        e.Item.OwnerTableView.IsItemInserted = false;
                        e.Item.OwnerTableView.Rebind();
                        lastID = 0;
                    }
                    catch (SqlException ex)
                    {
                        SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
                    }
                    catch (System.Exception ex)
                    {
                        SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
                    }
                    finally
                    {
                        con.Close();
                    }
                }
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

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }
        }
    }
}