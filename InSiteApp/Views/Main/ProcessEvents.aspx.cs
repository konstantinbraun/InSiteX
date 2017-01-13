using InSite.App.Constants;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Main
{
    public partial class ProcessEvents : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "ProcessEventID";
        private int action = Actions.View;

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        private int lastID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);

                string msg = Request.QueryString["Type"];
                if (msg != null)
                {
                    Session["ProcessBpID"] = msg;
                    Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name + "?Type=" + msg);
                }
                else
                {
                    Session["ProcessBpID"] = Session["BpID"];
                    Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);
                }
            }

            string viewName;

            if (Session["ProcessBpID"].ToString().Equals("0"))
            {
                this.Title = Resources.Resource.lblProcessManagementCentral;
                viewName = "ProcessEventsCentral";
            }
            else
            {
                this.Title = Resources.Resource.lblProcessManagement;
                viewName = "ProcessEvents";
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);

            fca = GetFieldsConfig(Helpers.GetDialogID(viewName));
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

            if (e.CommandName == "SetDone")
            {
                Helpers.SetAction(Actions.Edit);
                Label label = item.EditFormItem.FindControl("DoneOn") as Label;
                label.Text = DateTime.Now.ToString();
                label = item.EditFormItem.FindControl("DoneFrom") as Label;
                label.Text = Session["LoginName"].ToString();
                HiddenField hf = item.EditFormItem.FindControl("StatusID") as HiddenField;
                hf.Value = Status.Done.ToString();
            }

            if (e.CommandName == "Execute")
            {
                Helpers.SetAction(Actions.Release);
                item.Edit = true;
                (sender as RadGrid).Rebind();
            }

            if (e.CommandName == "BeginProcess")
            {
                string processUrl = (e.Item.FindControl("ProcessUrl") as HiddenField).Value;
                RadAjaxManager ajaxManager = Master.FindControl("RadAjaxManager1") as RadAjaxManager;
                if (ajaxManager != null && !processUrl.Equals(string.Empty))
                {
                    ajaxManager.Redirect(processUrl);
                }
            }

            if (e.CommandName == "PerformInsert")
            {

            }

            if (e.CommandName == "Update")
            {
                GridEditableItem editedItem = (GridEditableItem)e.Item;
                SqlDataSource_ProcessEvents.UpdateParameters["UserIDExecutive"].DefaultValue = (editedItem.FindControl("UserIDExecutive") as RadComboBox).SelectedValue;
            }

            if (e.CommandName == RadGrid.ExportToExcelCommandName || e.CommandName == RadGrid.ExportToCsvCommandName || e.CommandName == RadGrid.ExportToPdfCommandName)
            {
                RadGrid1.ShowGroupPanel = false;
                RadGrid1.Rebind();
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

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditableItem editableItem = (GridEditableItem)e.Item;
                int companyCentralID = Convert.ToInt32((editableItem.FindControl("CompanyCentralID") as RadComboBox).SelectedValue);
                int bpID = Convert.ToInt32((editableItem.FindControl("BpID") as RadComboBox).SelectedValue);
                DataTable dt = InitUsers(companyCentralID, bpID);

                RadComboBox cb = editableItem.FindControl("UserIDExecutive") as RadComboBox;
                if (cb != null)
                {
                    cb.Items.Clear();
                    cb.DataSource = dt;
                    cb.DataBind();
                }
                foreach (RadComboBoxItem cbItem in cb.Items)
                {
                    if (cbItem.Value == (e.Item.FindControl("UserIDExecutive1") as HiddenField).Value)
                    {
                        cbItem.Selected = true;
                    }
                }
            }

            if (item != null)
            {
                ImageButton button = e.Item.FindControl("ReleaseButton") as ImageButton;
                button.Visible = true;
                button.Enabled = false;

                int statusID = Convert.ToInt32((item.DataItem as DataRowView)["StatusID"]);
                int typeID = Convert.ToInt32((item.DataItem as DataRowView)["TypeID"]);
                button.ToolTip = Status.GetStatusString(statusID);

                if (statusID == Status.Done)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/release.png";
                    button.Enabled = false;
                }
                else if (statusID == Status.WaitExecute && typeID == 2)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/request.png";
                    button.CommandName = "Execute";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.WaitExecute && typeID == 1)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/view-refresh-3.png";
                    button.CommandName = "BeginProcess";
                    button.Enabled = true;
                }
                else
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Red-X.png";
                    button.Enabled = false;
                }
                button.CommandArgument = item.GetDataKeyValue("ProcessEventID").ToString();
            }

            if (e.Item is GridDataItem)
            {
                int userIDInitiator = Convert.ToInt32((item.DataItem as DataRowView)["UserIDInitiator"]);
                int typeID = Convert.ToInt32((item.DataItem as DataRowView)["TypeID"]);
                int statusID = Convert.ToInt32((item.DataItem as DataRowView)["StatusID"]);
                int userID = Convert.ToInt32(Session["UserID"]);
                if (typeID == 1 || userIDInitiator != userID)
                {
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Enabled = false;
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Visible = false;

                    (item["deleteColumn"].Controls[0] as ImageButton).Enabled = false;
                    (item["deleteColumn"].Controls[0] as ImageButton).Visible = false;
                }
                if (statusID == Status.Done)
                {
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Enabled = false;
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Visible = false;
                }
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editFormItem = (GridEditFormItem)e.Item;
                RadButton button = (editFormItem.FindControl("SetDone") as RadButton);
                if (button != null)
                {
                    if (Helpers.GetAction() == Actions.Release)
                    {
                        button.Visible = true;
                    }
                    else
                    {
                        button.Visible = false;
                    }
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
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                action = Actions.View;
            }
        }

        protected void RadGrid1_ItemCreated(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
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
                if (e.AffectedRows > 0)
                {
                    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                    Helpers.SetAction(Actions.View);
                }
                else
                {
                    e.KeepInInsertMode = true;
                }
            }
        }

        protected void BpID_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int bpID = Convert.ToInt32(e.Value);
            RadComboBox cb = (sender as RadComboBox).Parent.FindControl("CompanyCentralID") as RadComboBox;
            int companyCentralID = 0;
            if (cb != null && !cb.SelectedValue.Equals(string.Empty))
            {
                companyCentralID = Convert.ToInt32(cb.SelectedValue);
            }

            DataTable dt = InitUsers(companyCentralID, bpID);

            cb = (sender as RadComboBox).Parent.FindControl("UserIDExecutive") as RadComboBox;
            if (cb != null)
            {
                cb.Items.Clear();
                cb.DataSource = dt;
                cb.DataBind();
            }
        }

        protected void CompanyCentralID_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int companyCentralID = Convert.ToInt32(e.Value);
            RadComboBox cb = (sender as RadComboBox).Parent.FindControl("BpID") as RadComboBox;
            int bpID = 0;
            if (cb != null && !cb.SelectedValue.Equals(string.Empty))
            {
                bpID = Convert.ToInt32(cb.SelectedValue);
            }

            DataTable dt = InitUsers(companyCentralID, bpID);

            cb = (sender as RadComboBox).Parent.FindControl("UserIDExecutive") as RadComboBox;
            if (cb != null)
            {
                cb.Items.Clear();
                cb.DataSource = dt;
                cb.DataBind();
            }
        }

        private DataTable InitUsers(int companyCentralID, int bpID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT DISTINCT Master_Users.UserID, Master_Users.FirstName, Master_Users.LastName, Master_Users.LoginName, ");
            sql.Append("(Master_Users.LastName + ', ' + Master_Users.FirstName) AS UserName ");
            sql.Append("FROM Master_Users ");
            sql.Append("LEFT OUTER JOIN Master_UserBuildingProjects "); 
            sql.Append("ON Master_Users.SystemID = Master_UserBuildingProjects.SystemID ");
            sql.Append("AND Master_Users.UserID = Master_UserBuildingProjects.UserID ");
            sql.Append("WHERE Master_Users.SystemID = @SystemID ");
            sql.Append("AND Master_Users.CompanyID = (CASE WHEN @CompanyCentralID = 0 THEN Master_Users.CompanyID ELSE @CompanyCentralID END) ");
            sql.Append("AND Master_UserBuildingProjects.BpID = (CASE WHEN @BpID = 0 THEN Master_UserBuildingProjects.BpID ELSE @BpID END) ");
            sql.Append("ORDER BY UserName ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = bpID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyCentralID", SqlDbType.Int);
            par.Value = companyCentralID;
            cmd.Parameters.Add(par);

            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
            }
            catch (System.Exception ex)
            {
                Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
            }
            finally
            {
                con.Close();
            }

            return dt;
        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO Data_ProcessEvents(SystemID, BpID, CompanyCentralID, UserIDInitiator, UserIDExecutive, NameVisible, DescriptionShort, ");
                sql.Append("DialogID, ActionID, RefID, StatusID, TypeID, DoneFrom, DoneOn, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                sql.Append("VALUES (@SystemID, @BpID, @CompanyCentralID, @UserIDInitiator, @UserIDExecutive, @NameVisible, @DescriptionShort, ");
                sql.Append("@DialogID, @ActionID, @RefID, @StatusID, @TypeID, @DoneFrom, @DoneOn, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()); ");
                sql.Append("SELECT @ProcessEventID = SCOPE_IDENTITY(); ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);

                GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;

                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("BpID") as RadComboBox).SelectedValue);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyCentralID", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("CompanyCentralID") as RadComboBox).SelectedValue);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserIDInitiator", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["UserID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserIDExecutive", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("UserIDExecutive") as RadComboBox).SelectedValue);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@NameVisible", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("NameVisible") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DescriptionShort", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("DescriptionShort") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DialogID", SqlDbType.Int);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ActionID", SqlDbType.Int);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@RefID", SqlDbType.Int);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = Status.WaitExecute;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@TypeID", SqlDbType.Int);
                par.Value = 2;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DoneFrom", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("DoneFrom") as Label).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DoneOn", SqlDbType.DateTime);
                Label lbl = item.FindControl("DoneFrom") as Label;
                if (lbl != null && !lbl.Text.Equals(string.Empty))
                {
                    par.Value = (item.FindControl("DoneFrom") as Label).Text;
                }
                else
                {
                    par.Value = DBNull.Value;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ProcessEventID", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();

                    if (cmd.Parameters["@ProcessEventID"].Value != DBNull.Value)
                    {
                        lastID = Convert.ToInt32(cmd.Parameters["@ProcessEventID"].Value);
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

        protected void SqlDataSource_ProcessEvents_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
        {

        }
    }
}