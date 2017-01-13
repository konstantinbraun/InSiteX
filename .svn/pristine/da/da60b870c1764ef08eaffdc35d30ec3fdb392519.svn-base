using InSite.App.Constants;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Linq.Dynamic;
using OfficeOpenXml;

namespace InSite.App.Views.Main
{
    public partial class AccessHistory : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "AccessEventID";

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;
        private int lastID = 0;
        private int action = Actions.View;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);
                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
                RefreshPresentPersonsCount();
            }

            fca = GetFieldsConfig(Helpers.GetDialogID(type.Name));
            ViewState["fca"] = fca;
            rights = GetRights(fca);
            ViewState["rights"] = rights;

            // View allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.View))
            {
                RadAjaxManager ajax = (RadAjaxManager) this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect("/InSiteApp/Views/Dashboard.aspx?Msg=NoViewRight");
            }

            // Edit allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
            {
                RadGrid1.MasterTableView.GetColumn("EditCommandColumn").Visible = false;
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);

            RadGrid1.ShowGroupPanel = true;
            RadGrid1.Columns.FindByUniqueName("Timestamp1").Visible = false;
            GridColumn timestamp = RadGrid1.Columns.FindByUniqueName("Timestamp");
            timestamp.Visible = true;

            Helpers.SetAction(Actions.View);
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Literal für Statusmeldungen
                Helpers.AddGridStatus(RadGrid1, Page);

                Helpers.GotoLastEdited(RadGrid1, lastID, idName);
            }

            // Insert allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Create))
            {
                GridCommandItem cmdItem = (GridCommandItem) RadGrid1.MasterTableView.GetItems(GridItemType.CommandItem)[0];
                RadButton insertButton = (RadButton) cmdItem.FindControl("btnInitInsert");
                insertButton.Visible = false;
            }
        }

        private DataTable GetValidAccessAreas(int employeeID, DateTime accessTime, bool coming)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT DISTINCT m_aa.SystemID, m_aa.BpID, m_aa.AccessAreaID, m_aa.NameVisible, m_aa.DescriptionShort, m_aa.AccessTimeRelevant, m_aa.CheckInCompelling, ");
            sql.Append("m_aa.UniqueAccess, m_aa.CheckOutCompelling, m_aa.CompleteAccessTimes, m_aa.PresentTimeHours, m_aa.PresentTimeMinutes, m_aa.CreatedFrom, m_aa.CreatedOn, ");
            sql.Append("m_aa.EditFrom, m_aa.EditOn ");
            sql.Append("FROM Master_AccessAreas AS m_aa ");
            sql.Append("INNER JOIN Master_EmployeeAccessAreas AS m_eaa ");
            sql.Append("ON m_aa.SystemID = m_eaa.SystemID AND m_aa.BpID = m_eaa.BpID AND m_aa.AccessAreaID = m_eaa.AccessAreaID ");
            sql.Append("INNER JOIN Master_TimeSlots AS m_ts ");
            sql.Append("ON m_eaa.SystemID = m_ts.SystemID AND m_eaa.BpID = m_ts.BpID AND m_eaa.TimeSlotGroupID = m_ts.TimeSlotGroupID ");
            sql.Append("WHERE m_aa.SystemID = @SystemID ");
            sql.Append("AND m_aa.BpID = @BpID ");
            sql.Append("AND m_eaa.EmployeeID = @EmployeeID ");
            if (coming)
            {
                sql.Append("AND DATETIMEFROMPARTS(YEAR(m_ts.ValidFrom), MONTH(m_ts.ValidFrom), DAY(m_ts.ValidFrom), ");
                sql.Append("DATEPART(hh, m_ts.TimeFrom), DATEPART(n, m_ts.TimeFrom), DATEPART(s, m_ts.TimeFrom), 0) <= @AccessTime ");
                sql.Append("AND DATETIMEFROMPARTS(YEAR(m_ts.ValidUntil), MONTH(m_ts.ValidUntil), DAY(m_ts.ValidUntil), ");
                sql.Append("DATEPART(hh, m_ts.TimeUntil), DATEPART(n, m_ts.TimeUntil), DATEPART(s, m_ts.TimeUntil), 0) >= @AccessTime ");
            }

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = employeeID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessTime", SqlDbType.DateTime);
            par.Value = accessTime;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            catch (System.Exception ex)
            {
                logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            finally
            {
                con.Close();
            }

            return dt;
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;

            if (e.Item is GridEditableItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem))
            {
                DataRowView dataRow = e.Item.DataItem as DataRowView;
                if (dataRow != null)
                {
                    DateTime timestamp = Convert.ToDateTime(dataRow["Timestamp"]);
                    bool coming = (Convert.ToInt32(dataRow["AccessTypeID"]) == 1 ? true : false);
                    int accessAreaID = Convert.ToInt32(dataRow["AccessAreaID"]);
                    int employeeID = Convert.ToInt32(dataRow["EmployeeID"]);

                    GridEditableItem editItem = e.Item as GridEditableItem;
                    if (editItem != null)
                    {
                        RadDateTimePicker dtp = editItem.FindControl("AccessOn") as RadDateTimePicker;
                        if (dtp != null)
                        {
                            dtp.SelectedDate = timestamp;
                        }

                        RadButton btn = editItem.FindControl("Access") as RadButton;
                        if (btn != null)
                        {
                            btn.Checked = coming;
                        }
                        btn = editItem.FindControl("Exit") as RadButton;
                        if (btn != null)
                        {
                            btn.Checked = !coming;
                        }

                        RadComboBox cb = editItem.FindControl("AccessAreaID") as RadComboBox;
                        if (cb != null)
                        {
                            cb.Items.Clear();
                            cb.DataSource = GetValidAccessAreas(employeeID, timestamp, coming);
                            cb.DataBind();
                            cb.SelectedValue = accessAreaID.ToString();
                        }

                        RadTextBox tb = editItem.FindControl("Remark") as RadTextBox;
                        if (tb != null)
                        {
                            tb.Text = dataRow["Remark"].ToString();
                        }
                    }
                }
            }

            if (e.Item is GridDataItem)
            {
                GetEmployees_Result employee = e.Item.DataItem as GetEmployees_Result;
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100);
                (item["deleteColumn"].Controls[0] as ImageButton).Visible = deleteColumnVisible;

                if (lastID != 0 && Convert.ToInt32(item.GetDataKeyValue(idName)) == lastID)
                {
                    item.Selected = true;
                }
            }

        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblEmplAccess2);

            GridDataItem item = e.Item as GridDataItem;

            // Only one active edit form 
            RadGrid grid = (sender as RadGrid);
            if (e.CommandName == RadGrid.InitInsertCommandName)
            {
                grid.MasterTableView.ClearEditItems();
                Helpers.SetAction(Actions.View);
            }
            if (e.CommandName == RadGrid.EditCommandName)
            {
                e.Item.OwnerTableView.IsItemInserted = false;
                Helpers.SetAction(Actions.View);
            }

            if (e.CommandName == "ExpandCollapse")
            {
                Timer1.Enabled = item.Expanded;
            }

            if (e.CommandName == "RowClick")
            {
                // RowClick abhandeln
                item = e.Item.OwnerTableView.Items[e.CommandArgument as string];
                item.Expanded = !item.Expanded;
                Timer1.Enabled = !item.Expanded;
            }

            if (e.CommandName == RadGrid.ExportToExcelCommandName)
            {
                e.Canceled = true;

                RadGrid1.ShowGroupPanel = false;
                RadGrid1.Columns.FindByUniqueName("Timestamp").Visible = false;
                RadGrid1.Columns.FindByUniqueName("Timestamp1").Visible = true;

                RadGrid1.MasterTableView.ExportToExcel();
            }

            if (e.CommandName.Equals(RadGrid.InitInsertCommandName))
            {
                Timer1.Enabled = false;
                Helpers.SetAction(Actions.Create);
            }

            if (e.CommandName.Equals(RadGrid.EditCommandName))
            {
                Timer1.Enabled = false;
                Helpers.SetAction(Actions.Edit);
            }

            if (e.CommandName.Equals(RadGrid.DeleteCommandName))
            {
                Timer1.Enabled = false;
                Helpers.SetAction(Actions.Delete);
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridFilteringItem)
            {
                GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                if (filteringItem != null)
                {
                    LiteralControl literal = filteringItem["Timestamp"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";
                    literal = filteringItem["Timestamp"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";

                    literal = filteringItem["CreatedOn"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";
                    literal = filteringItem["CreatedOn"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
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

        public string GetAccessType(int accessType)
        {
            string ret = "";
            switch (accessType)
            {
                case 0:
                    {
                        ret = Resources.Resource.lblAccessTypeLeaving;
                        break;
                    }
                case 1:
                    {
                        ret = Resources.Resource.lblAccessTypeComing;
                        break;
                    }
                default:
                    {
                        ret = Resources.Resource.lblAccessTypeUnknown;
                        break;
                    }
            }
            return ret;
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            RadGrid1.Rebind();
            RefreshPresentPersonsCount();
        }

        private void RefreshPresentPersonsCount()
        {
            GetPresentPersonsCount_Result persons = Helpers.GetPresentPersonsCount();

            LabelEmployeesPresent.Text = persons.EmployeesCount.ToString();

            if (persons.EmployeesFaultyCount > 0)
            {
                LabelEmployeesFaulty.Text = persons.EmployeesFaultyCount.ToString();
                LabelEmployeesFaulty.Visible = true;
                LabelEmployeesFaultyHeader.Visible = true;
                LabelEmployeesFaultyHeader.Text = Resources.Resource.lblEmployeesFaulty + ":";
            }
            else
            {
                LabelEmployeesFaulty.Text = string.Empty;
                LabelEmployeesFaulty.Visible = false;
                LabelEmployeesFaultyHeader.Visible = false;
            }

            LabelVisitorsPresent.Text = persons.VisitorCount.ToString();

            if (persons.VisitorFaultyCount > 0)
            {
                LabelVisitorsFaulty.Text = persons.VisitorFaultyCount.ToString();
                LabelVisitorsFaulty.Visible = true;
                LabelVisitorsFaultyHeader.Visible = true;
                LabelVisitorsFaultyHeader.Text = Resources.Resource.lblVisitorsFaulty + ":";
            }
            else
            {
                LabelVisitorsFaulty.Text = string.Empty;
                LabelVisitorsFaulty.Visible = false;
                LabelVisitorsFaultyHeader.Visible = false;
            }

            if (persons.LastAccess != null)
            {
                LabelLastAccess.Text = ((DateTime) persons.LastAccess).ToString("G");
            }

            if (persons.LastExit != null)
            {
                LabelLastExit.Text = ((DateTime) persons.LastExit).ToString("G");
            }

            Webservices webservice = new Webservices();
            Master_AccessSystems accessSystem = webservice.GetLastUpdateAccessControl();
            if (accessSystem != null)
            {
                DateTime lastUpdate = new DateTime(2000, 1, 1);
                if (accessSystem.LastUpdate != null)
                {
                    lastUpdate = (DateTime) accessSystem.LastUpdate;
                    LabelLastUpdate.Text = lastUpdate.ToString("G");
                }
                else
                {
                    LabelLastUpdate.Text = Resources.Resource.lblNever;
                }

                TimeSpan timeSpan = DateTime.Now - lastUpdate;

                if (timeSpan.TotalSeconds > Convert.ToDouble(ConfigurationManager.AppSettings["ACSOfflineTrigger"]))
                {
                    Signal.ImageUrl = "/InSiteApp/Resources/Icons/Offline_24.png";
                    Signal.ToolTip = Resources.Resource.msgAccessControlSystemOffline + "!";
                    SignalText.Text = Resources.Resource.msgAccessControlSystemOffline + "!";
                    SignalText.ForeColor = System.Drawing.Color.Red;
                    Terminals.ImageUrl = "/InSiteApp/Resources/Icons/TerminalsOffline_24.png";
                    Terminals.ToolTip = Resources.Resource.msgAccessTerminalsOffline + "!";
                    TerminalsText.Text = Resources.Resource.msgAccessTerminalsOffline + "!";
                    TerminalsText.ForeColor = System.Drawing.Color.Red;
                }
                else
                {
                    Signal.ImageUrl = "/InSiteApp/Resources/Icons/Online_24.png";
                    Signal.ToolTip = Resources.Resource.msgAccessControlSystemOnline;
                    SignalText.Text = Resources.Resource.msgAccessControlSystemOnline;
                    SignalText.ForeColor = System.Drawing.Color.Black;
                    if (accessSystem.AllTerminalsOnline)
                    {
                        Terminals.ImageUrl = "/InSiteApp/Resources/Icons/TerminalsOnline_24.png";
                        Terminals.ToolTip = Resources.Resource.msgAccessTerminalsOnline;
                        TerminalsText.Text = Resources.Resource.msgAccessTerminalsOnline;
                        TerminalsText.ForeColor = System.Drawing.Color.Black;
                    }
                    else
                    {
                        Terminals.ImageUrl = "/InSiteApp/Resources/Icons/TerminalsOffline_24.png";
                        Terminals.ToolTip = Resources.Resource.msgAccessTerminalsOffline + "!";
                        TerminalsText.Text = Resources.Resource.msgAccessTerminalsOffline + "!";
                        TerminalsText.ForeColor = System.Drawing.Color.Red;
                    }
                }
            }

            DateTime lastCorrection = webservice.GetLastCorrectionDate();
            LastCorrection.Text = lastCorrection.ToString("G");
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {

            RadGrid1.DataSource = GetDataSource();
        }

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText.Replace(" ", "-");
            }

            if (e.Action == GridGroupsChangingAction.Group)
            {
                RadGrid1.MasterTableView.GetColumnSafe(e.Expression.GroupByFields[0].FieldName).Visible = false;
            }
            else if (e.Action == GridGroupsChangingAction.Ungroup)
            {
                RadGrid1.MasterTableView.GetColumnSafe(e.Expression.GroupByFields[0].FieldName).Visible = true;
            }
        }

        private DataTable GetDataSource()
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("GetAccessHistory", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter par;

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = Convert.ToInt32(Session["CompanyID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = Convert.ToInt32(Session["UserID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@PresentState", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = Convert.ToInt32(PresentFilter.SelectedValue);
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                // logger.InfoFormat("Try to execute {0}", cmd.CommandText);
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            catch (System.Exception ex)
            {
                logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            finally
            {
                con.Close();
            }

            return dt;
        }

        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("DELETE FROM Data_AccessEvents ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND AccessEventID = @AccessEventID; ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessEventID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item as GridDataItem).GetDataKeyValue("AccessEventID"));
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue("AccessEventID").ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
                Helpers.SetAction(Actions.View);
            }
            catch (SqlException ex)
            {
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        protected void AccessOn_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            GridEditableItem item = (sender as RadDateTimePicker).NamingContainer as GridEditableItem;
            if (item != null)
            {
                int employeeID = Convert.ToInt32((item.FindControl("EmployeeID") as RadComboBox).SelectedValue);
                RadButton rb = item.FindControl("Access") as RadButton;
                bool coming = true;
                if (rb != null)
                {
                    coming = rb.Checked;
                }
                DateTime accessTime = DateTime.Now;
                if (e.NewDate != null)
                {
                    accessTime = (DateTime) e.NewDate;
                }
                RadComboBox rc = item.FindControl("AccessAreaID") as RadComboBox;
                if (rc != null)
                {
                    string accessAreaID = rc.SelectedValue;
                    rc.Items.Clear();
                    rc.DataSource = GetValidAccessAreas(employeeID, accessTime, coming);
                    rc.DataBind();
                    if (!(item is GridEditFormInsertItem))
                    {
                        rc.SelectedValue = accessAreaID;
                    }
                }
            }
        }

        protected void Access_ToggleStateChanged(object sender, ButtonToggleStateChangedEventArgs e)
        {
            GridEditFormItem item = (sender as RadButton).NamingContainer as GridEditFormItem;
            if (item != null)
            {
                int employeeID = Convert.ToInt32((item.FindControl("EmployeeID") as RadComboBox).SelectedValue);
                RadButton rb = sender as RadButton;
                bool coming = true;
                if (rb != null)
                {
                    coming = rb.Checked;
                }
                RadDateTimePicker rdtp = item.FindControl("AccessOn") as RadDateTimePicker;
                DateTime accessTime = DateTime.Now;
                if (rdtp != null)
                {
                    accessTime = (DateTime) rdtp.SelectedDate;
                }
                RadComboBox rc = item.FindControl("AccessAreaID") as RadComboBox;
                if (rc != null)
                {
                    rc.Items.Clear();
                    rc.DataSource = GetValidAccessAreas(employeeID, accessTime, coming);
                    rc.DataBind();
                }
            }
        }

        protected void Exit_ToggleStateChanged(object sender, ButtonToggleStateChangedEventArgs e)
        {
            GridEditFormItem item = (sender as RadButton).NamingContainer as GridEditFormItem;
            if (item != null)
            {
                GridEditFormItem itemEmployee = item.NamingContainer.NamingContainer.NamingContainer.NamingContainer as GridEditFormItem;
                int employeeID = Convert.ToInt32((itemEmployee.FindControl("EmployeeID") as Label).Text);
                RadButton rb = sender as RadButton;
                bool coming = true;
                if (rb != null)
                {
                    coming = !rb.Checked;
                }
                RadDateTimePicker rdtp = item.FindControl("AccessOn") as RadDateTimePicker;
                DateTime accessTime = DateTime.Now;
                if (rdtp != null)
                {
                    accessTime = (DateTime) rdtp.SelectedDate;
                }
                RadComboBox rc = item.FindControl("AccessAreaID") as RadComboBox;
                if (rc != null)
                {
                    rc.Items.Clear();
                    rc.DataSource = GetValidAccessAreas(employeeID, accessTime, coming);
                    rc.DataBind();
                }
            }
        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;

            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO Data_AccessEvents(SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, ");
            sql.Append("AccessType, AccessResult, MessageShown, DenialReason, Remark, CreatedOn, CreatedFrom, IsManualEntry, EditOn, EditFrom, PassType) ");
            sql.Append("SELECT SystemID, 0, BpID, @AccessAreaID, 0, 0, EmployeeID, InternalID, 0, @AccessOn, @AccessType, 1, 1, 0, @Remark, SYSDATETIME(), @UserName, 1, SYSDATETIME(), @UserName, 1 ");
            sql.Append("FROM Master_Passes ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND EmployeeID = @EmployeeID ");
            sql.AppendLine("AND ActivatedOn IS NOT NULL; ");
            sql.AppendLine("SELECT @AccessEventID = SCOPE_IDENTITY(); ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = Convert.ToInt32((item.FindControl("EmployeeID") as RadComboBox).SelectedValue);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessAreaID", SqlDbType.Int);
            if (!(item.FindControl("AccessAreaID") as RadComboBox).SelectedValue.Equals(string.Empty))
            {
                par.Value = Convert.ToInt32((item.FindControl("AccessAreaID") as RadComboBox).SelectedValue);
            }
            else
            {
                par.Value = 0;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessOn", SqlDbType.DateTime);
            if ((item.FindControl("AccessOn") as RadDateTimePicker).SelectedDate != null)
            {
                par.Value = (DateTime) (item.FindControl("AccessOn") as RadDateTimePicker).SelectedDate;
            }
            else
            {
                par.Value = DateTime.Now;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessType", SqlDbType.Int);
            par.Value = ((item.FindControl("Access") as RadButton).Checked) ? 1 : 0;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@Remark", SqlDbType.NVarChar, 200);
            par.Value = (item.FindControl("Remark") as RadTextBox).Text;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = Session["LoginName"].ToString();
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessEventID", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                lastID = Convert.ToInt32(cmd.Parameters["@AccessEventID"].Value);
                SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                Helpers.SetAction(Actions.View);
                RadGrid1.CurrentPageIndex = 0;
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                logger.ErrorFormat("Runtime Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }

            RefreshPresentPersonsCount();
            Timer1.Enabled = true;
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            ExportExcel();
        }

        private void ExportExcel()
        {
            // Gefilterte Daten aus dem Grid
            var gridData = new DataTable();
            var filteredData = new DataTable();
            string filterExpression = RadGrid1.MasterTableView.FilterExpression;
            gridData = GetDataSource();
            if (filterExpression == string.Empty)
            {
                filteredData = gridData;
            }
            else
            {
                filteredData = gridData.AsEnumerable().AsQueryable().Where(filterExpression).CopyToDataTable();
            }

            ExcelPackage pck = new ExcelPackage();

            pck.Workbook.Properties.Title = Resources.Resource.lblEmplAccess2;
            pck.Workbook.Properties.Author = Session["LoginName"].ToString();
            if (Session["CompanyID"] != null && Convert.ToInt32(Session["CompanyID"]) > 0)
            {
                pck.Workbook.Properties.Company = Helpers.GetCompanyName(Convert.ToInt32(Session["CompanyID"]));
            }
            pck.Workbook.Properties.Manager = Resources.Resource.appName;

            // Kopfdaten
            ExcelWorksheet ws = pck.Workbook.Worksheets.Add(Resources.Resource.lblParameters);

            ws.Cells[1, 1].Value = Resources.Resource.lblEmplAccess2;
            ws.Cells[1, 1].Style.Font.Bold = true;
            ws.Cells[1, 1].Style.Font.Size = 16;

            ws.Cells[3, 1].Value = Resources.Resource.lblSystem + ":";
            ws.Cells[3, 2].Value = Session["SystemID"].ToString();

            ws.Cells[4, 1].Value = Resources.Resource.lblBuildingProject + ":";
            ws.Cells[4, 2].Value = Session["BpName"].ToString();

            ws.Cells[5, 1].Value = Resources.Resource.lblState + ":";
            ws.Cells[5, 2].Value = DateTime.Now.ToString("ddd, dd.MM.yyyy HH:mm");

            ws.Cells[6, 1].Value = Resources.Resource.lblUser + ":";
            ws.Cells[6, 2].Value = Session["LoginName"].ToString();

            ExcelRange parameters = ws.Cells[1, 1, 6, 2];
            parameters.AutoFitColumns();

            Helpers.ProtectWorksheet(ref ws);

            // Detaildaten
            ws = pck.Workbook.Worksheets.Add(Resources.Resource.lblData);

            // Kopfzeile
            ws.Cells[1, 1].Value = Resources.Resource.lblTimeStamp;
            ws.Cells[1, 2].Value = Resources.Resource.lblDirection;
            ws.Cells[1, 3].Value = Resources.Resource.lblResult;
            ws.Cells[1, 4].Value = Resources.Resource.lblOnline;
            ws.Cells[1, 5].Value = Resources.Resource.lblManual;
            ws.Cells[1, 6].Value = Resources.Resource.lblType;
            ws.Cells[1, 7].Value = Resources.Resource.lblPassHolder;
            ws.Cells[1, 8].Value = Resources.Resource.lblCompany;
            ws.Cells[1, 9].Value = Resources.Resource.lblAccessArea;
            ws.Cells[1, 10].Value = Resources.Resource.lblChipID;
            ws.Cells[1, 11].Value = Resources.Resource.lblPassID;
            ws.Cells[1, 12].Value = Resources.Resource.lblEntry;
            ws.Cells[1, 13].Value = Resources.Resource.lblDenialReason;

            // Daten
            int rowNum = 1;
            foreach (DataRow row in filteredData.Rows)
            {
                rowNum++;

                ws.Cells[rowNum, 1].Value = row["Timestamp"].ToString();
                ws.Cells[rowNum, 1].Style.Numberformat.Format = "DD.MM.YYYY hh:mm:ss";
                ws.Cells[rowNum, 1].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Right;

                string direction = row["AccessTypeID"].ToString();
                if (direction == "1")
                {
                    ws.Cells[rowNum, 2].Value = Resources.Resource.lblAccessTypeComing;
                }
                else
                {
                    ws.Cells[rowNum, 2].Value = Resources.Resource.lblAccessTypeLeaving;
                }

                string result = row["Result"].ToString();
                if (result == "1")
                {
                    ws.Cells[rowNum, 3].Value = Resources.Resource.lblOK;
                }
                else
                {
                    ws.Cells[rowNum, 3].Value = Resources.Resource.lblError;
                }

                ws.Cells[rowNum, 4].Value = row["IsOnlineAccessEvent"].ToString();

                ws.Cells[rowNum, 5].Value = row["IsManualEntry"].ToString();

                ws.Cells[rowNum, 6].Value = row["PassType"].ToString();

                ws.Cells[rowNum, 7].Value = row["EmployeeName"].ToString();

                ws.Cells[rowNum, 8].Value = row["CompanyName"].ToString();

                ws.Cells[rowNum, 9].Value = row["NameVisible"].ToString();

                ws.Cells[rowNum, 10].Value = row["InternalID"].ToString();

                ws.Cells[rowNum, 11].Value = row["ExternalPassID"].ToString();

                ws.Cells[rowNum, 12].Value = row["EntryID"].ToString();

                ws.Cells[rowNum, 13].Value = row["OriginalMessage"].ToString();
            }

            // Autofilter und autofit
            ExcelRange dataCells = ws.Cells[1, 1, rowNum + 1, 13];
            dataCells.AutoFilter = true;
            dataCells.AutoFitColumns();

            // Kopfzeile fett und fixiert
            ExcelRange headLine = ws.Cells[1, 1, 1, 13];
            headLine.Style.Font.Bold = true;
            ws.View.FreezePanes(2, 2);

            string fileDate = DateTime.Now.ToString("yyyyMMddHHmm");
            byte[] fileData = null;
            string suffix;
            string content;

            fileData = pck.GetAsByteArray();
            suffix = "xlsx";
            content = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";

            Response.Clear();
            Response.AppendHeader("Content-Length", fileData.Length.ToString());
            Response.ContentType = content;
            Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblEmplAccess2 + "_" + fileDate + "." + suffix));
            Response.BinaryWrite(fileData);
            Response.End();

        }

        protected void RadContextMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            int radGridClickedRowIndex;

            radGridClickedRowIndex = Convert.ToInt32(Request.Form["radGridClickedRowIndex"]);

            switch (e.Item.Value)
            {
                case "Edit":
                    RadGrid1.Items[radGridClickedRowIndex].Edit = true;
                    RadGrid1.Rebind();
                    break;
                case "Add":
                    RadGrid1.MasterTableView.IsItemInserted = true;
                    RadGrid1.Rebind();
                    break;
                case "Delete":
                    RadGrid1.MasterTableView.PerformDelete(RadGrid1.Items[radGridClickedRowIndex]);
                    break;
            }
        }

        protected void PresentFilter_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadGrid1.Rebind();
        }

        protected void AutoRefresh_CheckedChanged(object sender, EventArgs e)
        {
            Timer1.Enabled = (sender as CheckBox).Checked;
        }
    }
}