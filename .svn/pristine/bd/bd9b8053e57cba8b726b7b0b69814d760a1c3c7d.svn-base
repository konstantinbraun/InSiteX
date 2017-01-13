using InSite.App.Constants;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Telerik.Web.UI.GridExcelBuilder;

namespace InSite.App.Views.Main
{
    public partial class ShortTermPasses : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "ShortTermVisitorID";
        private int action = Actions.View;

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        private int lastID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);

            if (Session["PassRole"] != null)
            {
                fca = GetFieldsConfig(Helpers.GetDialogID(type.Name), Convert.ToInt32(Session["PassRole"]));
            }
            else
            {
                fca = GetFieldsConfig(Helpers.GetDialogID(type.Name));
            }
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

        private void ShowScannerPanel(bool show)
        {
            System.Diagnostics.Debug.Write(String.Format("ShowScannerPanel({0})\n", show));

            RadScriptBlockReader.Visible = show;
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            //System.Diagnostics.Debug.Write("Page.LoadComplete\n");
            // Literal für Statusmeldungen
            Helpers.AddGridStatus(RadGrid1, Page);

            Helpers.GotoLastEdited(RadGrid1, lastID, idName);
        }

        protected void RadGrid1_ItemDeleted(object sender, Telerik.Web.UI.GridDeletedEventArgs e)
        {
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

        protected void RadGrid1_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item.IsInEditMode)
            {
                GridEditableItem editItem = (GridEditableItem)e.Item;
                RadComboBox cbEmployee = editItem.FindControl("AssignedEmployeeID1") as RadComboBox;
                RadComboBox cbCompany = editItem.FindControl("AssignedCompanyID1") as RadComboBox;
                if (cbCompany != null)
                {
                    int companyID = 0;
                    if (!cbCompany.SelectedValue.Equals(String.Empty))
                    {
                        companyID = Convert.ToInt32(cbCompany.SelectedValue);
                    }
                    cbEmployee.DataSource = InitEmployees(companyID);
                    cbEmployee.DataBind();
                }

                if (!(e.Item is IGridInsertItem))
                {
                    cbEmployee.SelectedValue = ((GetShortTermVisitors_Result)e.Item.DataItem).AssignedEmployeeID.ToString();
                }

                cbEmployee = editItem.FindControl("AssignedEmployeeID2") as RadComboBox;
                cbCompany = editItem.FindControl("AssignedCompanyID2") as RadComboBox;
                if (cbCompany != null)
                {
                    int companyID = 0;
                    if (!cbCompany.SelectedValue.Equals(String.Empty))
                    {
                        companyID = Convert.ToInt32(cbCompany.SelectedValue);
                    }
                    cbEmployee.DataSource = InitEmployees(companyID);
                    cbEmployee.DataBind();
                }

                if (e.Item is GridEditFormInsertItem)
                {
                    Label shortTermVisitorID = editItem.FindControl("ShortTermVisitorID") as Label;
                    shortTermVisitorID.Text = Session["NextShortTermVisitorID"].ToString();
                }
            }

            // Feldsteuerung
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                if (e.Item is GridEditFormInsertItem)
                {
                    // Insert
                    FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Create, e, false);
                }
                else
                {
                    if (action == Actions.Activate || action == Actions.Deactivate)
                    {
                        // Release
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Release, e, false);
                    }
                    else if (action == Actions.Lock)
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

            if (e.Item is GridCommandItem)
            {
                string cmd = "function(sender, args) {openRadWindow(11); return false;}";
                RadButton btn = (e.Item.FindControl("btnPrintPasses") as RadButton);
                btn.OnClientClicked = cmd;

                cmd = "function(sender, args) {openRadWindow(14); return false;}";
                btn = (e.Item.FindControl("btnAssignPasses") as RadButton);
                btn.OnClientClicked = cmd;

                // Insert allowed?
                if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Create))
                {
                    btn = (e.Item.FindControl("btnInitInsert") as RadButton);
                    btn.Enabled = false;
                    btn.Visible = false;
                }
            }

            GridDataItem item = e.Item as GridDataItem;
            if (item != null)
            {
                ImageButton button = e.Item.FindControl("ReleaseButton") as ImageButton;
                button.Visible = true;
                button.Enabled = false;

                int statusID = ((GetShortTermVisitors_Result)e.Item.DataItem).StatusID;
                button.ToolTip = Status.GetStatusString(statusID);

                if (statusID == Status.Printed)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/printer.png";
                    button.CommandName = "AssignPasses";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Assign))
                    {
                        button.Enabled = true;
                    }
                }
                //else if (statusID == Status.Assigned)
                //{
                //    button.ImageUrl = "/InSiteApp/Resources/Icons/mail-attachment-2.png";
                //    button.CommandName = "Activate";
                //    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Activate))
                //    {
                //        button.Enabled = true;
                //    }
                //}
                else if (statusID == Status.Activated)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/release.png";
                    button.CommandName = "Deactivate";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.Deactivated || statusID == Status.Assigned)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/locked.png";
                    button.CommandName = "Lock";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Lock))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.Invalid)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/request.png";
                    button.CommandName = "Edit";
                    button.Enabled = true;
                }
                else if (statusID == Status.Locked)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Red-X.png";
                    button.CommandName = "";
                    button.Enabled = false;
                }
                else if (statusID == Status.Expired)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/request.png";
                    button.CommandName = "Deactivate";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release))
                    {
                        button.Enabled = true;
                    }
                }
                else
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/request.png";
                    button.CommandName = "";
                    button.Enabled = false;
                }
            }

            if (e.Item is GridDataItem)
            {
                int statusID = ((GetShortTermVisitors_Result)item.DataItem).StatusID;
                if (statusID == Status.Activated)
                {
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Enabled = true;
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Visible = true;
                }
                else
                {
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Enabled = false;
                    (item["EditCommandColumn"].Controls[0] as ImageButton).Visible = false;
                }
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editFormItem = (GridEditFormItem)e.Item;

                RadButton button = (editFormItem.FindControl("btnDeactivate") as RadButton);
                if (action == Actions.Deactivate && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release))
                {
                    button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }

                button = (editFormItem.FindControl("btnActivate") as RadButton);
                if (action == Actions.Activate && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Create))
                {
                    //button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }

                button = (editFormItem.FindControl("btnLock") as RadButton);
                if (action == Actions.Lock && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Lock))
                {
                    button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }

                // Daten von gescanntem Pass übernehmen
                if (SessionData.SomeData.ContainsKey("ShortTermPassData"))
                {
                    ShortTermPass pass = SessionData.SomeData["ShortTermPassData"] as ShortTermPass;
                    Session["MyShortTermPassID"] = pass.ShortTermPassID;

                    Label lbl = editFormItem.FindControl("InternalID") as Label;
                    if (lbl != null && !pass.InternalID.Equals(string.Empty))
                    {
                        lbl.Text = pass.InternalID;
                    }

                    lbl = editFormItem.FindControl("TypeName") as Label;
                    if (lbl != null && !pass.ShortTermPassTypeName.Equals(string.Empty))
                    {
                        lbl.Text = pass.ShortTermPassTypeName;
                    }

                    lbl = editFormItem.FindControl("Status") as Label;
                    if (lbl != null)
                    {
                        if (pass.StatusID != 0)
                        {
                            lbl.Text = Status.GetStatusString(pass.StatusID);
                        }
                        else
                        {
                            HiddenField hf = editFormItem.FindControl("StatusID") as HiddenField;
                            if (hf != null)
                            {
                                lbl.Text = Status.GetStatusString(Convert.ToInt32(hf.Value));
                            }
                        }
                    }

                    lbl = editFormItem.FindControl("ShortTermPassID") as Label;
                    if (lbl != null && pass.ShortTermPassID != 0)
                    {
                        lbl.Text = pass.ShortTermPassID.ToString();
                    }

                    if (e.Item is GridEditFormInsertItem)
                    {
                        RadDateTimePicker rdtp = editFormItem.FindControl("AccessAllowedUntil") as RadDateTimePicker;
                        if (rdtp != null)
                        {
                            rdtp.SelectedDate = DateTime.Now.AddDays(pass.ValidDays).AddHours(pass.ValidHours).AddMinutes(pass.ValidMinutes);
                        }
                    }
                }
                else
                {
                    Label lbl = editFormItem.FindControl("Status") as Label;
                    if (lbl != null)
                    {
                        HiddenField hf = editFormItem.FindControl("StatusID") as HiddenField;
                        if (hf != null && !hf.Value.Equals(string.Empty))
                        {
                            lbl.Text = Status.GetStatusString(Convert.ToInt32(hf.Value));
                        }
                        else
                        {
                            lbl.Text = Status.GetStatusString(Status.Assigned);
                        }
                    }
                }
            }
        }

        protected void RadGrid1_InsertCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;

                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO Data_ShortTermVisitors(SystemID, BpID, ShortTermVisitorID, ShortTermPassID, Salutation, FirstName, LastName, Company, NationalityID, IdentifiedWith, DocumentID, AssignedCompanyID, ");
                sql.Append("AssignedEmployeeID, AccessAllowedUntil, CreatedFrom, CreatedOn, EditFrom, EditOn, ");
                sql.Append("ShortTermPassTypeID, PassStatusID, PassInternalID, PassActivatedFrom, PassActivatedOn) ");
                sql.Append("SELECT SystemID, BpID, @ShortTermVisitorID, ShortTermPassID, @Salutation, @FirstName, @LastName, @Company, @NationalityID, @IdentifiedWith, @DocumentID, @AssignedCompanyID, @AssignedEmployeeID, ");
                sql.Append("@AccessAllowedUntil, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), ");
                sql.Append("ShortTermPassTypeID, @StatusID, InternalID, @UserName, SYSDATETIME() ");
                sql.Append("FROM Data_ShortTermPasses ");
                sql.Append("WHERE SystemID = @SystemID ");
                sql.Append("AND BpID = @BpID ");
                sql.AppendLine("AND InternalID = @InternalID; ");

                sql.Append("UPDATE Data_ShortTermPasses ");
                sql.Append("SET ActivatedFrom = @UserName, ");
                sql.Append("ActivatedOn = SYSDATETIME(), ");
                sql.Append("DeactivatedFrom = '', ");
                sql.Append("DeactivatedOn = NULL, ");
                sql.Append("StatusID = @StatusID, ");
                sql.Append("ShortTermVisitorID = @ShortTermVisitorID ");
                sql.Append("WHERE SystemID = @SystemID ");
                sql.Append("AND BpID = @BpID ");
                sql.Append("AND InternalID = @InternalID; ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@InternalID", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("InternalID") as Label).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Salutation", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("Salutation") as RadComboBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@FirstName", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("FirstName") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LastName", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("LastName") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Company", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("Company") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@IdentifiedWith", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("IdentifiedWith") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@NationalityID", SqlDbType.NVarChar, 10);
                if ((item.FindControl("NationalityID") as RadComboBox).SelectedValue != null)
                {
                    par.Value = (item.FindControl("NationalityID") as RadComboBox).SelectedValue;
                }
                else
                {
                    par.Value = string.Empty;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DocumentID", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("DocumentID") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AssignedCompanyID", SqlDbType.NVarChar, 10);
                if ((item.FindControl("AssignedCompanyID1") as RadComboBox).SelectedValue != String.Empty && (item.FindControl("AssignedCompanyID1") as RadComboBox).SelectedValue != "0")
                {
                    par.Value = Convert.ToInt32((item.FindControl("AssignedCompanyID1") as RadComboBox).SelectedValue);
                }
                else if ((item.FindControl("AssignedCompanyID2") as RadComboBox).SelectedValue != String.Empty && (item.FindControl("AssignedCompanyID2") as RadComboBox).SelectedValue != "0")
                {
                    par.Value = Convert.ToInt32((item.FindControl("AssignedCompanyID2") as RadComboBox).SelectedValue);
                }
                else
                {
                    par.Value = 0;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AssignedEmployeeID", SqlDbType.NVarChar, 10);
                if ((item.FindControl("AssignedEmployeeID1") as RadComboBox).SelectedValue != String.Empty && (item.FindControl("AssignedEmployeeID1") as RadComboBox).SelectedValue != "0")
                {
                    par.Value = Convert.ToInt32((item.FindControl("AssignedEmployeeID1") as RadComboBox).SelectedValue);
                }
                else if ((item.FindControl("AssignedEmployeeID2") as RadComboBox).SelectedValue != String.Empty && (item.FindControl("AssignedEmployeeID2") as RadComboBox).SelectedValue != "0")
                {
                    par.Value = Convert.ToInt32((item.FindControl("AssignedEmployeeID2") as RadComboBox).SelectedValue);
                }
                else
                {
                    par.Value = 0;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AccessAllowedUntil", SqlDbType.DateTime);
                if ((item.FindControl("AccessAllowedUntil") as RadDateTimePicker).SelectedDate != null)
                {
                    par.Value = (item.FindControl("AccessAllowedUntil") as RadDateTimePicker).SelectedDate;
                }
                else
                {
                    par.Value = DBNull.Value;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ShortTermVisitorID", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("ShortTermVisitorID") as Label).Text);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = Status.Activated;
                cmd.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();

                    Helpers.ShortTermPassChanged(Convert.ToInt32((item.FindControl("ShortTermPassID") as Label).Text));
                    lastID = Convert.ToInt32((item.FindControl("ShortTermVisitorID") as Label).Text);
                    Helpers.DialogLogger(type, Actions.Create, lastID.ToString(), Resources.Resource.lblActionCreate);
                    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                    action = Actions.View;
                    RadGrid1.MasterTableView.IsItemInserted = false;
                    RadGrid1.MasterTableView.Rebind();
                    lastID = 0;
                    SessionData.SomeData.Remove("ShortTermPassData");
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

        protected void RadGrid1_UpdateCommand(object sender, Telerik.Web.UI.GridCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                GridEditFormItem item = e.Item as GridEditFormItem;

                int statusID = 0;
                int passStatusID = 0;
                string activatedOn = (item.FindControl("ActivatedOn") as Label).Text;
                string deactivatedOn = (item.FindControl("DeactivatedOn") as Label).Text;
                string lockedOn = (item.FindControl("LockedOn") as Label).Text;
                if (!String.IsNullOrEmpty(lockedOn))
                {
                    // Status: Locked
                    statusID = Status.Locked;
                    passStatusID = Status.Locked;
                }
                else if (!String.IsNullOrEmpty(activatedOn) && String.IsNullOrEmpty(deactivatedOn))
                {
                    // Status: Activated
                    statusID = Status.Activated;
                    passStatusID = Status.Activated;
                }
                else if (!String.IsNullOrEmpty(activatedOn) && !String.IsNullOrEmpty(deactivatedOn))
                {
                    // Status: Deactivated
                    statusID = Status.Assigned;
                    passStatusID = Status.Deactivated;
                }

                StringBuilder sql = new StringBuilder();
                sql.Append("UPDATE Data_ShortTermVisitors ");
                sql.Append("SET Salutation = @Salutation, FirstName = @FirstName, LastName = @LastName, NationalityID = @NationalityID, ");
                sql.Append("Company = @Company, IdentifiedWith = @IdentifiedWith, DocumentID = @DocumentID, AssignedCompanyID = @AssignedCompanyID, AssignedEmployeeID = @AssignedEmployeeID, ");
                sql.Append("AccessAllowedUntil = @AccessAllowedUntil, EditFrom = @UserName, EditOn = SYSDATETIME(), ");
                sql.Append("PassStatusID = @PassStatusID, PassActivatedFrom = @ActivatedFrom, PassActivatedOn = @ActivatedOn, PassDeactivatedFrom = @DeactivatedFrom, ");
                sql.Append("PassDeactivatedOn = @DeactivatedOn, PassLockedFrom = @LockedFrom, PassLockedOn = @LockedOn ");
                sql.Append("WHERE SystemID = @SystemID ");
                sql.Append("AND BpID = @BpID ");
                sql.AppendLine("AND ShortTermVisitorID = @ShortTermVisitorID; ");

                sql.Append("UPDATE Data_ShortTermPasses ");
                sql.Append("SET ActivatedFrom = @ActivatedFrom, ");
                sql.Append("ActivatedOn = @ActivatedOn, ");
                sql.Append("ShortTermVisitorID = (CASE WHEN @DeactivatedOn IS NOT NULL THEN NULL ELSE ShortTermVisitorID END), ");
                sql.Append("DeactivatedFrom = @DeactivatedFrom, ");
                sql.Append("DeactivatedOn = @DeactivatedOn, ");
                sql.Append("LockedFrom = @LockedFrom, ");
                sql.Append("LockedOn = @LockedOn, ");
                sql.Append("StatusID = @StatusID ");
                sql.Append("WHERE SystemID = @SystemID ");
                sql.Append("AND BpID = @BpID ");
                sql.AppendLine("AND InternalID = @InternalID; ");

                if (statusID == Status.Locked)
                {
                    sql.Append("UPDATE Data_ShortTermVisitors ");
                    sql.Append("SET PassStatusID = @PassStatusID, PassLockedFrom = @LockedFrom, PassLockedOn = @LockedOn ");
                    sql.Append("WHERE SystemID = @SystemID ");
                    sql.Append("AND BpID = @BpID ");
                    sql.AppendLine("AND PassInternalID = @InternalID; ");
                }

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Salutation", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("Salutation") as RadComboBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ShortTermVisitorID", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("ShortTermVisitorID") as Label).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@FirstName", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("FirstName") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LastName", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("LastName") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Company", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("Company") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@NationalityID", SqlDbType.NVarChar, 10);
                par.Value = (item.FindControl("NationalityID") as RadComboBox).SelectedValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@IdentifiedWith", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("IdentifiedWith") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DocumentID", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("DocumentID") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AssignedCompanyID", SqlDbType.NVarChar, 10);
                if ((item.FindControl("AssignedCompanyID1") as RadComboBox).SelectedValue != String.Empty && (item.FindControl("AssignedCompanyID1") as RadComboBox).SelectedValue != "0")
                {
                    par.Value = Convert.ToInt32((item.FindControl("AssignedCompanyID1") as RadComboBox).SelectedValue);
                }
                else if ((item.FindControl("AssignedCompanyID2") as RadComboBox).SelectedValue != String.Empty && (item.FindControl("AssignedCompanyID2") as RadComboBox).SelectedValue != "0")
                {
                    par.Value = Convert.ToInt32((item.FindControl("AssignedCompanyID2") as RadComboBox).SelectedValue);
                }
                else
                {
                    par.Value = 0;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AssignedEmployeeID", SqlDbType.NVarChar, 10);
                if ((item.FindControl("AssignedEmployeeID1") as RadComboBox).SelectedValue != String.Empty && (item.FindControl("AssignedEmployeeID1") as RadComboBox).SelectedValue != "0")
                {
                    par.Value = Convert.ToInt32((item.FindControl("AssignedEmployeeID1") as RadComboBox).SelectedValue);
                }
                else if ((item.FindControl("AssignedEmployeeID2") as RadComboBox).SelectedValue != String.Empty && (item.FindControl("AssignedEmployeeID2") as RadComboBox).SelectedValue != "0")
                {
                    par.Value = Convert.ToInt32((item.FindControl("AssignedEmployeeID2") as RadComboBox).SelectedValue);
                }
                else
                {
                    par.Value = 0;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AccessAllowedUntil", SqlDbType.DateTime);
                if ((item.FindControl("AccessAllowedUntil") as RadDateTimePicker).SelectedDate != null)
                {
                    par.Value = (item.FindControl("AccessAllowedUntil") as RadDateTimePicker).SelectedDate;
                }
                else
                {
                    par.Value = DBNull.Value;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                par = new SqlParameter("@InternalID", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("InternalID") as Label).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ActivatedFrom", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("ActivatedFrom") as Label).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ActivatedOn", SqlDbType.DateTime);
                string parString = (item.FindControl("ActivatedOn") as Label).Text;
                if (parString.Equals(String.Empty))
                {
                    par.Value = DBNull.Value;
                }
                else
                {
                    par.Value = parString;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DeactivatedFrom", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("DeactivatedFrom") as Label).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DeactivatedOn", SqlDbType.DateTime);
                parString = (item.FindControl("DeactivatedOn") as Label).Text;
                if (parString.Equals(String.Empty))
                {
                    par.Value = DBNull.Value;
                }
                else
                {
                    par.Value = parString;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LockedFrom", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("LockedFrom") as Label).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LockedOn", SqlDbType.DateTime);
                parString = (item.FindControl("LockedOn") as Label).Text;
                if (parString.Equals(String.Empty))
                {
                    par.Value = DBNull.Value;
                }
                else
                {
                    par.Value = parString;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = statusID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@PassStatusID", SqlDbType.Int);
                par.Value = passStatusID;
                cmd.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();
                    lastID = Convert.ToInt32((item.FindControl("ShortTermVisitorID") as Label).Text);

                    Helpers.DialogLogger(type, Actions.Edit, lastID.ToString(), Resources.Resource.lblActionEdit);
                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                    action = Actions.View;
                    SessionData.SomeData.Remove("ShortTermPassData");
                }
                catch (SqlException ex)
                {
                    SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }
                catch (System.Exception ex)
                {
                    SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }
                finally
                {
                    con.Close();
                }

                Helpers.ShortTermPassChanged(Convert.ToInt32((item.FindControl("ShortTermPassID") as Label).Text));
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
                if (e.AffectedRows > 0)
                {
                    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                    action = Actions.View;
                }
                else
                {
                    e.KeepInInsertMode = true;
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

            // Detailbereich des ersten Elements einblenden
            if (!Page.IsPostBack)
            {
                // RadGrid1.MasterTableView.Items[0].Expanded = true;
                // RadGrid1.MasterTableView.Items[0].ChildItem.FindControl("InnerContainer").Visible = true;
            }
        }

        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
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

            if (e.CommandName == "ExportToExcel" || e.CommandName == "ExportToCSV" || e.CommandName == "ExportToPdf")
            {
                e.Canceled = true;

                if (e.CommandName == "ExportToExcel")
                {
                    RadGrid1.ExportSettings.Excel.Format = GridExcelExportFormat.Xlsx;
                    string fileDate = DateTime.Now.ToString("yyyyMMddHHmm");
                    RadGrid1.ExportSettings.FileName = Resources.Resource.lblShortTermPasses + "_" + fileDate;
                    RadGrid1.ShowGroupPanel = false;
                    RadGrid1.MasterTableView.ExportToExcel();
                }

                if (e.CommandName == "ExportToCSV")
                {
                    grid.ExportSettings.Csv.ColumnDelimiter = GridCsvDelimiter.Semicolon;
                    grid.ExportSettings.Csv.EncloseDataWithQuotes = true;
                    grid.ExportSettings.Csv.RowDelimiter = GridCsvDelimiter.NewLine;
                    grid.MasterTableView.ExportToCSV();
                }

                if (e.CommandName == "ExportToPdf")
                {
                    grid.ExportSettings.Pdf.ForceTextWrap = true;
                    grid.MasterTableView.ExportToPdf();
                }
            }

            if (e.CommandName == "PassChecked" && SessionData.SomeData.ContainsKey("ShortTermPassData"))
            {
                ShortTermPass pass = SessionData.SomeData["ShortTermPassData"] as ShortTermPass;
                Session["MyShortTermPassID"] = pass.ShortTermPassID;

                // Besucher erfassen und Pass aktivieren
                if (pass.StatusID == Status.Assigned)
                {
                    Helpers.ChangeEditFormCaption(e, true, Resources.Resource.lblShortTermPasses);

                    fca = GetFieldsConfig(Helpers.GetDialogID(type.Name), pass.RoleID);
                    ViewState["fca"] = fca;
                    rights = GetRights(fca);
                    ViewState["rights"] = rights;

                    int nextID = Helpers.GetNextID("ShortTermVisitorID");
                    Session["NextShortTermVisitorID"] = nextID;
                    Session["MyShortTermVisitorID"] = nextID;

                    // Default Zutrittsbereich zuordnen
                    int defaultAccessAreaID = Helpers.GetDefaultSTAccessAreaID(Convert.ToInt32(Session["BpID"]));
                    int defaultTimeSlotGroupID = Helpers.GetDefaultSTTimeSlotGroupID(Convert.ToInt32(Session["BpID"]));
                    Helpers.SetDefaultAccessAreaForVisitor(nextID, defaultAccessAreaID, defaultTimeSlotGroupID);

                    action = Actions.Create;
                    RadGrid1.MasterTableView.IsItemInserted = true;
                    RadGrid1.Rebind();
                }
                // Pass deaktivieren
                else if (pass.StatusID == Status.Activated)
                {
                    string shortTermPassID = pass.ShortTermPassID.ToString();
                    for (int i = 0; i < RadGrid1.MasterTableView.PageCount; i++)
                    {
                        RadGrid1.CurrentPageIndex = i;
                        RadGrid1.Rebind();

                        foreach (GridDataItem gridDataItem in RadGrid1.MasterTableView.Items)
                        {
                            if ((gridDataItem["ShortTermPassID"].Controls[1] as Label).Text.Equals(shortTermPassID))
                            {
                                Helpers.ChangeEditFormCaption(e, false, Resources.Resource.lblShortTermPasses);
                                action = Actions.Deactivate;
                                gridDataItem.Edit = true;
                                (sender as RadGrid).Rebind();
                                i = RadGrid1.MasterTableView.PageCount;
                                break;
                            }
                        }
                    }
                }
                // Pass reaktivieren oder sperren
                else if (pass.StatusID == Status.Deactivated)
                {
                    //string shortTermPassID = pass.ShortTermPassID.ToString();
                    //foreach (GridDataItem gridDataItem in RadGrid1.MasterTableView.Items)
                    //{
                    //    if ((gridDataItem["ShortTermPassID"].Controls[1] as Label).Text.Equals(shortTermPassID))
                    //    {
                    //        Helpers.ChangeEditFormCaption(e, false, Resources.Resource.lblShortTermPasses);
                    //        action = Actions.Activate;
                    //        gridDataItem.Edit = true;
                    //        (sender as RadGrid).Rebind();
                    //        i = RadGrid1.MasterTableView.PageCount;
                    //        break;
                    //    }
                    //}
                }
                ShowScannerPanel(true);
            }

            if (e.CommandName == "RowClick")
            {
                // RowClick abhandeln
                item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);

                item.ChildItem.FindControl("InnerContainer").Visible = !e.Item.Expanded;

                item.Expanded = !item.Expanded;

                action = Actions.View;
            }

            if (e.CommandName == "Activate")
            {
                action = Actions.Activate;
                item.Edit = true;
                (sender as RadGrid).Rebind();
                ShowScannerPanel(false);
            }

            if (e.CommandName == "ActivateIt")
            {
                Label label = item.EditFormItem.FindControl("DeactivatedOn") as Label;
                label.Text = "";
                label = item.EditFormItem.FindControl("DeactivatedFrom") as Label;
                label.Text = "";
                label = item.EditFormItem.FindControl("ActivatedOn") as Label;
                label.Text = DateTime.Now.ToString();
                label = item.EditFormItem.FindControl("ActivatedFrom") as Label;
                label.Text = Session["LoginName"].ToString();
            }

            if (e.CommandName == "Deactivate")
            {
                action = Actions.Deactivate;
                item.Edit = true;
                (sender as RadGrid).Rebind();
                ShowScannerPanel(false);
            }

            if (e.CommandName.Equals("Update"))
            {
                if (e.CommandArgument.Equals("DeactivateIt"))
                {
                    GridEditableItem editItem = e.Item as GridEditableItem;
                    Label label = editItem.FindControl("DeactivatedOn") as Label;
                    label.Text = DateTime.Now.ToString();
                    label = editItem.FindControl("DeactivatedFrom") as Label;
                    label.Text = Session["LoginName"].ToString();
                }
                ShowScannerPanel(true);
            }

            if (e.CommandName == "Lock" && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
            {
                action = Actions.Lock;
                item.Edit = true;
                (sender as RadGrid).Rebind();
                ShowScannerPanel(false);
            }

            if (e.CommandName == "LockIt")
            {
                Label label = item.EditFormItem.FindControl("LockedFrom") as Label;
                label.Text = Session["LoginName"].ToString();
                label = item.EditFormItem.FindControl("LockedOn") as Label;
                label.Text = DateTime.Now.ToString();
            }

            if (e.CommandName == "Cancel")
            {
                lastID = -1;
                action = Actions.View;
                ShowScannerPanel(true);
                SessionData.SomeData.Remove("ShortTermPassData");
            }

            if (e.CommandName == "Edit")
            {
                if (!(item["StatusID"].Controls[1] as HiddenField).Value.Equals(Status.Deactivated.ToString()) && !(item["StatusID"].Controls[1] as HiddenField).Value.Equals(Status.Locked.ToString()))
                {
                    action = Actions.Edit;
                }
                else
                {
                    e.Canceled = true;
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblActionEdit, Resources.Resource.msgNoEditOnDeactivatedPass);
                }
                ShowScannerPanel(false);
            }

            if (e.CommandName == "InitInsert")
            {
                int nextID = Helpers.GetNextID("ShortTermVisitorID");
                Session["NextShortTermVisitorID"] = nextID;

                // Default Zutrittsbereich zuordnen
                int defaultAccessAreaID = Helpers.GetDefaultSTAccessAreaID(Convert.ToInt32(Session["BpID"]));
                int defaultTimeSlotGroupID = Helpers.GetDefaultSTTimeSlotGroupID(Convert.ToInt32(Session["BpID"]));
                Helpers.SetDefaultAccessAreaForVisitor(nextID, defaultAccessAreaID, defaultTimeSlotGroupID);

                action = Actions.Create;
                ShowScannerPanel(false);
            }

            if (e.CommandName == "HideScanner")
            {
                if (Convert.ToBoolean(e.CommandArgument))
                {
                    ShowScannerPanel(false);
                }
                else
                {
                    ShowScannerPanel(true);
                }
            }
            if (e.CommandName == "EditPass")
            {
                this.EditPass();
            }
        }

        protected void AssignedCompanyID1_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadComboBox cb = (sender as RadComboBox).Parent.FindControl("AssignedEmployeeID1") as RadComboBox;
            if (cb != null)
            {
                cb.Text = "";
                cb.Items.Clear();
                cb.DataSource = InitEmployees(Convert.ToInt32(e.Value));
                cb.DataBind();
            }
        }

        protected void AssignedCompanyID2_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadComboBox cb = (sender as RadComboBox).Parent.FindControl("AssignedEmployeeID2") as RadComboBox;
            if (cb != null)
            {
                cb.Text = "";
                cb.Items.Clear();
                cb.DataSource = InitEmployees(Convert.ToInt32(e.Value));
                cb.DataBind();
            }
        }

        protected DataTable InitEmployees(int selectedCompanyID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT m_e.EmployeeID, m_a.FirstName + ' ' + m_a.LastName AS EmployeeName ");
            sql.Append("FROM Master_Employees AS m_e ");
            sql.Append("INNER JOIN Master_Companies AS m_c ");
            sql.Append("ON m_e.SystemID = m_c.SystemID ");
            sql.Append("AND m_e.BpID = m_c.BpID ");
            sql.Append("AND m_e.CompanyID = m_c.CompanyID ");
            sql.Append("INNER JOIN Master_Addresses AS m_a ");
            sql.Append("ON m_e.SystemID = m_a.SystemID ");
            sql.Append("AND m_e.BpID = m_a.BpID ");
            sql.Append("AND m_e.AddressID = m_a.AddressID ");
            sql.Append("WHERE m_e.SystemID = @SystemID ");
            sql.Append("AND m_e.BpID = @BpID ");
            sql.Append("AND m_e.ReleaseBOn IS NOT NULL ");
            sql.Append("AND m_e.LockedOn IS NULL ");
            sql.Append("AND m_c.CompanyID = @SelectedCompanyID ");
            sql.Append("AND m_c.ReleaseOn IS NOT NULL ");
            sql.Append("AND m_c.LockedOn IS NULL ");
            sql.Append("AND m_c.CompanyCentralID = (CASE WHEN @CompanyID = 0 THEN m_c.CompanyCentralID ELSE @CompanyID END) ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@SelectedCompanyID", SqlDbType.Int);
            par.Value = selectedCompanyID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["CompanyID"]);
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
                Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
                SetMessage(Resources.Resource.lblActionSelect, String.Format(Resources.Resource.msgSelectFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
                SetMessage(Resources.Resource.lblActionSelect, String.Format(Resources.Resource.msgSelectFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }

            return dt;
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            // Feldsteuerung
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                if (e.Item is GridEditFormInsertItem || e.Item is GridDataInsertItem)
                {
                    // Insert
                    FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Create, e, true);
                }
                else
                {
                    if (action == Actions.Activate || action == Actions.Deactivate)
                    {
                        // Release
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Release, e, true);
                    }
                    else if (action == Actions.Lock)
                    {
                        // Lock
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Lock, e, true);
                    }
                    else
                    {
                        // Edit
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Edit, e, true);
                    }
                }
            }
            else
            {
                // View
                FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.View, e, true);
            }

            if (e.Item is GridFilteringItem)
            {
                GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                if (filteringItem != null)
                {
                    LiteralControl literal = filteringItem["AccessAllowedUntil"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["AccessAllowedUntil"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";

                    literal = filteringItem["ActivatedOn"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["ActivatedOn"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";

                    literal = filteringItem["DeactivatedOn"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["DeactivatedOn"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
                }
            }
        }

        protected void AssignedEmployeeID1_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
        {
            RadComboBox cbEmployee = sender as RadComboBox;
            RadComboBox cbCompany = cbEmployee.Parent.FindControl("AssignedCompanyID1") as RadComboBox;
            if (cbCompany != null)
            {
                int companyID = 0;
                if (!cbCompany.SelectedValue.Equals(String.Empty))
                {
                    companyID = Convert.ToInt32(cbCompany.SelectedValue);
                }
                cbEmployee.DataSource = InitEmployees(companyID);
                cbEmployee.DataBind();
            }
        }

        protected void AssignedEmployeeID2_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
        {
            RadComboBox cbEmployee = sender as RadComboBox;
            RadComboBox cbCompany = cbEmployee.Parent.FindControl("AssignedCompanyID2") as RadComboBox;
            if (cbCompany != null)
            {
                int companyID = 0;
                if (!cbCompany.SelectedValue.Equals(String.Empty))
                {
                    companyID = Convert.ToInt32(cbCompany.SelectedValue);
                }
                cbEmployee.DataSource = InitEmployees(companyID);
                cbEmployee.DataBind();
            }
        }

        protected void AvailableAreas_Transferred(object sender, RadListBoxTransferredEventArgs e)
        {
            if (e.Items.Count > 0)
            {
                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand("MoveShortTermAccessArea", con);
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

                par = new SqlParameter("@ShortTermVisitorID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                par.Value = Convert.ToInt32((e.SourceListBox.Parent.FindControl("ShortTermVisitorID") as Label).Text);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AccessAreaID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@User", SqlDbType.NVarChar, 50);
                par.Direction = ParameterDirection.Input;
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                foreach (RadListBoxItem item in e.Items)
                {
                    cmd.Parameters["@AccessAreaID"].Value = item.Value;

                    con.Open();
                    try
                    {
                        logger.InfoFormat("Try to execute {0}", cmd.CommandText);
                        cmd.ExecuteNonQuery();
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
                }
            }
        }

        protected void ValidatorAssignedAreas_ServerValidate(object source, ServerValidateEventArgs args)
        {
            RadListBox lb = (RadListBox)(((GridEditFormItem)((CustomValidator)source).NamingContainer)).FindControl("AssignedAreas");
            if (lb != null)
            {
                if (lb.Items.Count == 0)
                {
                    args.IsValid = false;
                }
            }
        }

        protected void RadGrid1_ExcelMLWorkBookCreated(object sender, Telerik.Web.UI.GridExcelBuilder.GridExcelMLWorkBookCreatedEventArgs e)
        {
            // Neues Arbeitsblatt
            WorkBook workbook = e.WorkBook;
            WorksheetElement worksheet = new WorksheetElement(Resources.Resource.lblParameters);
            worksheet.Table = new TableElement();

            // Neue Kopfzeile
            RowElement row = new RowElement();

            StyleElement style = new StyleElement("headerBold");
            style.FontStyle.Bold = true;
            workbook.Styles.Add(style);

            style = new StyleElement("reportName");
            style.FontStyle.Bold = true;
            style.FontStyle.Size = 16;
            workbook.Styles.Add(style);

            CellElement cell = new CellElement();
            cell.Data.DataItem = Resources.Resource.lblShortTermPasses;
            cell.StyleValue = "reportName";
            row.Cells.Add(cell);

            worksheet.Table.Rows.Add(row);

            // Leerzeile
            row = new RowElement();
            worksheet.Table.Rows.Add(row);

            row = new RowElement();

            cell = new CellElement();
            cell.Data.DataItem = Resources.Resource.lblFieldName;
            cell.StyleValue = "headerBold";
            row.Cells.Add(cell);

            cell = new CellElement();
            cell.Data.DataItem = Resources.Resource.lblFilter;
            cell.StyleValue = "headerBold";
            row.Cells.Add(cell);

            cell = new CellElement();
            cell.Data.DataItem = Resources.Resource.lblValue;
            cell.StyleValue = "headerBold";
            row.Cells.Add(cell);

            worksheet.Table.Rows.Add(row);

            foreach (GridColumn item in (sender as RadGrid).MasterTableView.Columns)
            {
                if (!item.HeaderText.Equals(string.Empty))
                {
                    // Filterinformationen für alle sichtbaren Spalten
                    string filterFunction = item.CurrentFilterFunction.ToString();
                    string filterValue = item.CurrentFilterValue;
                    row = new RowElement();

                    cell = new CellElement();
                    cell.Data.DataItem = item.HeaderText + ": ";
                    row.Cells.Add(cell);

                    cell = new CellElement();
                    cell.Data.DataItem = filterFunction;
                    row.Cells.Add(cell);

                    cell = new CellElement();
                    cell.Data.DataItem = filterValue;
                    row.Cells.Add(cell);

                    worksheet.Table.Rows.Add(row);
                }
            }

            workbook.Worksheets.Insert(0, worksheet);

            workbook.Worksheets[1].Name = Resources.Resource.lblData;


        }

        protected void RadGrid1_ExcelMLExportRowCreated(object sender, Telerik.Web.UI.GridExcelBuilder.GridExportExcelMLRowCreatedArgs e)
        {
            CellElement cell = e.Row.Cells.GetCellByName("StatusID");
            if (cell != null && cell.Data.DataItem != null && !cell.StyleValue.Equals("headerStyle"))
            {
                cell.Data.DataItem = Status.GetStatusString(Convert.ToInt32(cell.Data.DataItem));
            }
        }

        protected void RadGrid1_ExcelMLExportStylesCreated(object sender, GridExportExcelMLStyleCreatedArgs e)
        {
            IStylesCollection styles = e.Styles;
            foreach (StyleElement style in e.Styles)
            {
                switch (style.Id)
                {
                    case "headerStyle":
                        {
                            style.FontStyle.Bold = true;
                            style.InteriorStyle.Color = Color.Silver;
                            break;
                        }

                    case "itemStyle":
                        {
                            break;
                        }

                    case "alternatingItemStyle":
                        {
                            break;
                        }

                    case "dataItemStyle":
                        {
                            break;
                        }

                    case "alternatingDataItemStyle":
                        {
                            break;
                        }
                }
            }
        }

        protected void RadGrid1_ExportCellFormatting(object sender, ExportCellFormattingEventArgs e)
        {
            TableCell cell = e.Cell;
            GridColumn column = e.FormattedColumn;
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid1.DataSource = Helpers.GetShortTermVisitors();
        }

        protected void RadGrid1_PdfExporting(object sender, GridPdfExportingArgs e)
        {

        }

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }
        }

        protected void BtnEditPass_Click(object sender, EventArgs e)
        {
            EditPass();
        }

        private void EditPass()
        {
            if (SessionData.SomeData.ContainsKey("ShortTermPassData"))
            {
                ShortTermPass pass = SessionData.SomeData["ShortTermPassData"] as ShortTermPass;
                Session["MyShortTermPassID"] = pass.ShortTermPassID;

                // Besucher erfassen und Pass aktivieren
                if (pass.StatusID == Status.Assigned)
                {
                    fca = GetFieldsConfig(Helpers.GetDialogID(type.Name), pass.RoleID);
                    ViewState["fca"] = fca;
                    rights = GetRights(fca);
                    ViewState["rights"] = rights;

                    int nextID = Helpers.GetNextID("ShortTermVisitorID");
                    Session["NextShortTermVisitorID"] = nextID;

                    // Default Zutrittsbereich zuordnen
                    int defaultAccessAreaID = Helpers.GetDefaultSTAccessAreaID(Convert.ToInt32(Session["BpID"]));
                    int defaultTimeSlotGroupID = Helpers.GetDefaultSTTimeSlotGroupID(Convert.ToInt32(Session["BpID"]));
                    Helpers.SetDefaultAccessAreaForVisitor(nextID, defaultAccessAreaID, defaultTimeSlotGroupID);

                    action = Actions.Create;
                    RadGrid1.MasterTableView.IsItemInserted = true;
                    RadGrid1.Rebind();
                }
                // Pass deaktivieren
                else if (pass.StatusID == Status.Activated)
                {
                    string shortTermPassID = pass.ShortTermPassID.ToString();
                    for (int i = 0; i < RadGrid1.MasterTableView.PageCount; i++)
                    {
                        RadGrid1.CurrentPageIndex = i;
                        RadGrid1.Rebind();

                        foreach (GridDataItem gridDataItem in RadGrid1.MasterTableView.Items)
                        {
                            if ((gridDataItem["ShortTermPassID"].Controls[1] as Label).Text.Equals(shortTermPassID))
                            {
                                action = Actions.Deactivate;
                                gridDataItem.Edit = true;
                                RadGrid1.Rebind();
                                i = RadGrid1.MasterTableView.PageCount;
                                break;
                            }
                        }
                    }
                }
                // Pass reaktivieren oder sperren
                else if (pass.StatusID == Status.Deactivated)
                {
                    string shortTermPassID = pass.ShortTermPassID.ToString();
                    for (int i = 0; i < RadGrid1.MasterTableView.PageCount; i++)
                    {
                        RadGrid1.CurrentPageIndex = i;
                        RadGrid1.Rebind();

                        foreach (GridDataItem gridDataItem in RadGrid1.MasterTableView.Items)
                        {
                            if ((gridDataItem["ShortTermPassID"].Controls[1] as Label).Text.Equals(shortTermPassID))
                            {
                                action = Actions.Activate;
                                gridDataItem.Edit = true;
                                RadGrid1.Rebind();
                                i = RadGrid1.MasterTableView.PageCount;
                                break;
                            }
                        }
                    }
                }
                ShowScannerPanel(false);
            }
        }

        protected void AssignedAreas_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblAssignedAreas);

            if (e.CommandName.Equals("Delete"))
            {
                // Zutrittsrelevantes Ereignis 
                // e.Canceled = true;
            }

            if (e.CommandName.Equals("Cancel") || e.CommandName == "PerformInsert" || e.CommandName == "Update")
            {
                ((sender as RadGrid).NamingContainer.FindControl("btnUpdateShortTermPass") as RadButton).Enabled = true;
                ((sender as RadGrid).NamingContainer.FindControl("btnCancel") as RadButton).Enabled = true;
                if (!e.CommandName.Equals("Cancel"))
                {
                    RadGrid1.Rebind();
                }
            }

            if (e.CommandName == "Edit" || e.CommandName == "InitInsert")
            {
                ((sender as RadGrid).NamingContainer.FindControl("btnUpdateShortTermPass") as RadButton).Enabled = false;
                ((sender as RadGrid).NamingContainer.FindControl("btnCancel") as RadButton).Enabled = false;
            }
        }

        protected void AssignedAreas_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                (sender as RadGrid).MasterTableView.Rebind();
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
                // RadGrid1.DataBind();
            }
        }

        protected void AssignedAreas_ItemInserted(object sender, GridInsertedEventArgs e)
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
                    Helpers.ShortTermPassChanged(Convert.ToInt32(Session["MyShortTermPassID"]));
                    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                    //(sender as RadGrid).DataBind();
                    //(sender as RadGrid).Rebind();
                    (e.Item as GridItem).FireCommandEvent("RebindGrid", null);
                }
                else
                {
                    e.KeepInInsertMode = true;
                }
            }
        }

        protected void AssignedAreas_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            // Update-Message
            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, e.Exception.Message), "red");
                Helpers.ShortTermPassChanged(Convert.ToInt32(Session["MyShortTermPassID"]));
            }
            else
            {
                if (e.AffectedRows > 0)
                {
                    (sender as RadGrid).MasterTableView.Rebind();
                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                }
                else
                {
                    e.KeepInEditMode = true;
                }
            }
        }

        protected void AssignedAreas_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem) && e.Item.DataItem != null)
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                RadComboBox cb = item.FindControl("AccessAreaID") as RadComboBox;

                if (cb != null)
                {
                    cb.Items.Clear();
                    string accessAreaID = ((DataRowView)e.Item.DataItem)["AccessAreaID"].ToString();
                    string accessAreaName = ((DataRowView)e.Item.DataItem)["AccessAreaName"].ToString();
                    RadComboBoxItem cbItem = new RadComboBoxItem(accessAreaName, accessAreaID);
                    cbItem.Selected = true;
                    cb.Items.Add(cbItem);
                    cbItem.DataBind();
                }
            }
        }

        public string GetAccessState(int accessState)
        {
            string ret;
            switch (accessState)
            {
                case 0:
                    {
                        ret = Resources.Resource.lblAccessStateAbsent;
                        break;
                    }
                case 1:
                    {
                        ret = Resources.Resource.lblAccessStatePresent;
                        break;
                    }
                case 2:
                    {
                        ret = Resources.Resource.lblAccessStateUndefined;
                        break;
                    }
                case 3:
                    {
                        ret = Resources.Resource.lblAccessStateNoAccess;
                        break;
                    }
                default:
                    {
                        ret = Resources.Resource.lblAccessStateUndefined;
                        break;
                    }
            }
            return ret;
        }

        public static string GetChipId()
        {
            return "test";
        }

    }
}