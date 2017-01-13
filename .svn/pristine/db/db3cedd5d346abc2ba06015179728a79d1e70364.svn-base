using InSite.App.Constants;
using InSite.App.CMServices;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Central
{
    public partial class CompaniesCentral : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "CompanyID";
        private int action = Actions.View;
        private int lastID = 0;
        private int lastTariff = 0;

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        String msg = "";
        int companyID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            msg = Request.QueryString["CompanyID"];
            if (msg != null)
            {
                companyID = Convert.ToInt32(msg);
                lastID = companyID;
            }

            // Parameterabfrage für Vorgangsverwaltung
            msg = Request.QueryString["ID"];
            if (msg != null)
            {
                companyID = Convert.ToInt32(msg);
                lastID = companyID;
            }
            msg = Request.QueryString["Action"];
            if (msg != null)
            {
                action = Convert.ToInt32(msg);
            }
            Helpers.SetAction(action);

            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);

                Session["AlphaFilter"] = string.Empty;
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

        protected void SqlDataSource_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            lastID = Convert.ToInt32(e.Command.Parameters["@ReturnValue"].Value);
            Helpers.DialogLogger(type, Actions.Create, lastID.ToString(), Resources.Resource.lblActionCreate);
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
                lastID = Convert.ToInt32((e.Item as GridEditFormItem).GetDataKeyValue(idName));
                Helpers.DialogLogger(type, Actions.Edit, lastID.ToString(), Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                action = Actions.View;
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
                action = Actions.View;
                lastID = 0;
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

            GridColumn item1 = (sender as RadGrid).MasterTableView.Columns.FindByUniqueName("NameVisible");
            if (item1 != null)
            {
                string filterValue = item1.CurrentFilterValue;
                if ((Session["AlphaFilter"] != null && !Session["AlphaFilter"].ToString().Equals(string.Empty)) || (filterValue != null && !filterValue.Equals(string.Empty)))
                {
                    item1.HeaderStyle.ForeColor = System.Drawing.Color.DarkRed;
                    item1.HeaderStyle.Font.Bold = true;

                }
                else
                {
                    item1.HeaderStyle.ForeColor = System.Drawing.Color.Black;
                    item1.HeaderStyle.Font.Bold = false;
                }
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }

            // Aufruf durch Vorgangsverwaltung
            if (lastID != 0 && action == Actions.Release)
            {
                Helpers.GotoLastEdited(RadGrid1, lastID, idName, true);
            }
        }

        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            GridDataItem item = e.Item as GridDataItem;

            // Deteilbereich ein- und ausblenden
            if (e.CommandName == RadGrid.ExpandCollapseCommandName && e.Item is GridDataItem)
            {
                item.ChildItem.FindControl("InnerContainer").Visible = !e.Item.Expanded;
            }

            if (e.CommandName == "RowClick")
            {
                item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);

                item.ChildItem.FindControl("InnerContainer").Visible = !e.Item.Expanded;
                
                item.Expanded = !item.Expanded;
                action = Actions.View;
            }

            if (e.CommandName == "Release")
            {
                int statusID = Convert.ToInt32((item.FindControl("StatusID") as HiddenField).Value);
                if (statusID != Status.CreatedNotConfirmed)
                {
                    action = Actions.Release;
                    item.Edit = true;
                    (sender as RadGrid).Rebind();
                }
            }

            if (e.CommandName == "ReleaseIt")
            {
                RadTextBox tb = item.EditFormItem.FindControl("ReleaseOn") as RadTextBox;
                tb.Text = DateTime.Now.ToString();
                tb = item.EditFormItem.FindControl("ReleaseFrom") as RadTextBox;
                tb.Text = Session["LoginName"].ToString();
            }

            if (e.CommandName == "Cancel")
            {
                lastID = -1;

                action = Actions.View;
            }

            if (e.CommandName == "Edit")
            {
                int statusID = Convert.ToInt32((item.FindControl("StatusID") as HiddenField).Value);
                companyID = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);
                Session["SelectedCompanyID"] = companyID;
                if (statusID != Status.CreatedNotConfirmed)
                {
                    action = Actions.Edit;
                }
                else
                {
                    e.Canceled = true;
                }
            }

            if (e.CommandName == "InitInsert")
            {
                companyID = Helpers.GetNextID("CompanyCentralID");
                Session["NextCompanyCentralID"] = companyID;
                Session["SelectedCompanyID"] = companyID;
                action = Actions.Create;
            }

            if (e.CommandName == "RequestBp")
            {
                int companyID = Convert.ToInt32(e.CommandArgument);

                Webservices webservice = new Webservices();
                System_Companies company = webservice.GetCompanyCentralInfo(companyID);
                if (company != null && company.ReleaseOn != null && company.LockedOn == null)
                {
                    (this.Master as SiteMaster).ShowAsPopUp(String.Concat("~/Views/Central/RegisterToBp.aspx?CompanyID=", companyID.ToString()), "/InSiteApp/Resources/Icons/applications-development-5.png", true, Session["pageTitle"].ToString());
                }
                else
                {
                    logger.ErrorFormat("Company {0} not released", companyID);
                    Helpers.ShowMessage(this.Master, Resources.Resource.lblCompanyMasterCentral, Resources.Resource.msgCompanyNotReleased, "red");
                }
            }

            if (e.CommandName == "PerformInsert")
            {
                Session["NoExit"] = e.CommandArgument.Equals("NoExit");
            }

            if (e.CommandName == "Update")
            {
                Session["NoExit"] = e.CommandArgument.Equals("NoExit");
            }

            if (e.CommandName.Equals("AlphaFilter"))
            {
                Session["AlphaFilter"] = e.CommandArgument;
                RadGrid1.Rebind();
            }
        }

        private void ReleaseIt(string companyID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE System_Companies ");
            sql.Append("SET ReleaseFrom = @UserName, ");
            sql.Append("ReleaseOn = SYSDATETIME() ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND CompanyID = @CompanyID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = Convert.ToInt32(companyID);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = HttpContext.Current.Session["LoginName"].ToString();
            cmd.Parameters.Add(par);

            con.Open();
            try
            {
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Release, companyID.ToString(), Resources.Resource.lblActionRelease);
                SetMessage(Resources.Resource.lblActionRelease, Resources.Resource.msgReleaseOK, "green");
                RadGrid1.Rebind();
            }
            catch (SqlException ex)
            {
                SetMessage(Resources.Resource.lblActionRelease, String.Format(Resources.Resource.msgReleaseFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionRelease, String.Format(Resources.Resource.msgReleaseFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;
            if (item != null)
            {
                ImageButton button = e.Item.FindControl("ReleaseButton") as ImageButton;
                button.Visible = true;
                button.Enabled = false;

                int statusID = Convert.ToInt32(((DataRowView)e.Item.DataItem)["StatusID"]);
                button.ToolTip = Status.GetStatusString(statusID);

                if (statusID == Status.Locked)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Red-X.png";
                    button.CommandName = "Release";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.Released)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/release.png";
                    button.CommandName = "";
                    button.Enabled = false;
                }
                else if (statusID == Status.CreatedNotConfirmed)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/important-icon.png";
                    button.CommandName = "";
                    button.Enabled = false;
                    if (item.Edit)
                    {
                        item.Edit = false;
                    }
                }
                else
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/request.png";
                    button.CommandName = "Release";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release))
                    {
                        button.Enabled = true;
                        button.CommandArgument = item.GetDataKeyValue("CompanyID").ToString();
                    }
                }

                if (companyID != 0 && Convert.ToInt32(item.GetDataKeyValue("CompanyID")) == companyID)
                {
                    item.Selected = true;
                }
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editFormItem = (GridEditFormItem)e.Item;
                RadButton button = (editFormItem.FindControl("ReleaseIt") as RadButton);
                if (button != null)
                {
                    if (action == Actions.Release)
                    {
                        button.Visible = true;
                    }
                    else
                    {
                        button.Visible = false;
                    }
                }
                button = (editFormItem.FindControl("LockIt") as RadButton);
                if (button != null)
                {
                    if (action == Actions.Lock)
                    {
                        button.Visible = true;
                    }
                    else
                    {
                        button.Visible = false;
                    }
                }

                RadComboBox cb = editFormItem.FindControl("CountryID") as RadComboBox;
                if (cb != null)
                {
                    cb.Items.Clear();
                    cb.DataSource = Helpers.GetRegions(Helpers.GetCultures(CultureTypes.AllCultures));
                    cb.DataBind();
                }
                foreach (RadComboBoxItem cbItem in cb.Items)
                {
                    if (cbItem.Value == (editFormItem.FindControl("CountryID1") as HiddenField).Value)
                    {
                        cbItem.Selected = true;
                    }
                }
            }

            if (e.Item is GridNestedViewItem && e.Item.DataItem != null)
            {
                GridNestedViewItem nestedViewItem = (GridNestedViewItem)e.Item;
                RadComboBox cbUserID = nestedViewItem.FindControl("UserID1") as RadComboBox;
                if (cbUserID != null)
                {
                    RadComboBoxItem rcbi = cbUserID.FindItemByValue((e.Item.DataItem as DataRowView)["UserID"].ToString());
                    if (rcbi != null)
                    {
                        rcbi.Selected = true;
                    }
                }
            }

            if (e.Item is GridEditFormItem && !(e.Item is GridEditFormInsertItem))
            {
                GridEditFormItem editFormItem = e.Item as GridEditFormItem;

                CheckBox cb = editFormItem.FindControl("MinWageAttestation") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["MinWageAttestation"]);
                }

                RadComboBox cbUserID = editFormItem.FindControl("UserID") as RadComboBox;
                if (cbUserID != null)
                {
                    RadComboBoxItem rcbi = cbUserID.FindItemByValue((e.Item.DataItem as DataRowView)["UserID"].ToString());
                    if (rcbi != null)
                    {
                        rcbi.Selected = true;
                    }
                }
            }

            if (e.Item is GridDataItem)
            {
                int statusID = Convert.ToInt32(((DataRowView)e.Item.DataItem)["StatusID"]);
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100) || statusID == Status.WaitRelease || statusID == Status.CreatedNotConfirmed;
                if (deleteColumnVisible)
                {
                    (item["deleteColumn"].Controls[0] as ImageButton).Visible = true;
                }
                else
                {
                    (item["deleteColumn"].Controls[0] as ImageButton).Visible = false;
                }
            }

            if (e.Item is GridEditFormInsertItem)
            {
                GridEditableItem editableItem = (GridEditableItem)e.Item;
                Label companyID = editableItem.FindControl("CompanyID") as Label;
                companyID.Text = Session["NextCompanyCentralID"].ToString();
                HiddenField companyID1 = editableItem.FindControl("CompanyID1") as HiddenField;
                companyID1.Value = Session["NextCompanyCentralID"].ToString();
            }
            // Aufruf durch Vorgangsverwaltung
            //if (e.Item is GridDataItem && companyID != 0 && e.Item.DataItem != null && action == Actions.Release)
            //{
            //    int currentID = Convert.ToInt32(item.GetDataKeyValue("CompanyID"));
            //    if (currentID == companyID)
            //    {
            //        int statusID = Convert.ToInt32((item.FindControl("StatusID") as HiddenField).Value);
            //        if (statusID != Status.CreatedNotConfirmed && (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, action)))
            //        {
            //            Helpers.SetAction(action);
            //            e.Item.Edit = true;
            //        }
            //    }
            //}
        }

        protected void SqlDataSource_CompaniesCentral_Inserting(object sender, SqlDataSourceCommandEventArgs e)
        {
            // Duplikatprüfung
            string nameVisible = e.Command.Parameters["@NameVisible"].Value.ToString();
            string nameAdditional;
            if (e.Command.Parameters["@NameAdditional"].Value == null)
            {
                nameAdditional = "";
            }
            else
            {
                nameAdditional = e.Command.Parameters["@NameAdditional"].Value.ToString();
            }
            string zip;
            if (e.Command.Parameters["@Zip"].Value == null)
            {
                zip = "";
            }
            else
            {
                zip = e.Command.Parameters["@Zip"].Value.ToString();
            }

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT c.SystemID, c.CompanyID, c.NameVisible, c.NameAdditional, c.Description, c.AddressID, c.IsVisible, c.IsValid, c.TradeAssociation, c.BlnSOKA, ");
            sql.Append("c.UserID, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, a.Address1, a.Address2, a.Zip, a.City, a.[State], a.CountryID, a.Phone, a.Email, a.WWW, ");
            sql.Append("c.RequestFrom, c.RequestOn, c.ReleaseFrom, c.ReleaseOn, c.LockedFrom, c.LockedOn ");
            sql.Append("FROM System_Companies AS c ");
            sql.Append("LEFT OUTER JOIN System_Addresses AS a ");
            sql.Append("ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID ");
            sql.Append("WHERE c.SystemID = @SystemID ");
            sql.Append("AND c.NameVisible = @NameVisible ");
            sql.Append("AND c.NameAdditional = @NameAdditional ");
            sql.Append("AND a.Zip = @Zip ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@NameVisible", SqlDbType.NVarChar, 200);
            par.Value = nameVisible;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@NameAdditional", SqlDbType.NVarChar, 200);
            par.Value = nameAdditional;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@Zip", SqlDbType.NVarChar, 20);
            par.Value = zip;
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

            if (dt.Rows.Count > 0)
            {
                SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgRecordAlreadyExists, "red");
                e.Cancel = true;
            }
        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormItem item = e.Item as GridEditFormItem;

            if (Page.IsValid)
            {
                StringBuilder sql = new StringBuilder();

                sql.Append("INSERT INTO System_Addresses (SystemID, Address1, Address2, Zip, City, State, CountryID, Phone, Email, WWW, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                sql.Append("VALUES (@SystemID, @Address1, @Address2, @Zip, @City, @State, @CountryID, @Phone, @Email, @WWW, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()); ");
                sql.Append("SELECT @AddressID = SCOPE_IDENTITY(); ");
                sql.Append("INSERT INTO System_Companies (SystemID, CompanyID, NameVisible, NameAdditional, Description, AddressID, IsVisible, IsValid, TradeAssociation, ");
                sql.Append("BlnSOKA, MinWageAttestation, UserID, StatusID, CreatedFrom, CreatedOn, EditFrom, EditOn, Soundex) ");
                sql.Append("VALUES (@SystemID, @CompanyID, @NameVisible, @NameAdditional, '', @AddressID, 1, 1, @TradeAssociation, 1, @MinWageAttestation, @UserID, @StatusID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), dbo.SoundexGer(@NameVisible)); ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@NameVisible", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("NameVisible") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@NameAdditional", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("NameAdditional") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@TradeAssociation", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("TradeAssociation") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = Status.Created;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                int userID = 0;
                par = new SqlParameter("@UserID", SqlDbType.Int);
                if (!(item.FindControl("UserID") as RadComboBox).SelectedValue.Equals(String.Empty))
                {
                    userID = Convert.ToInt32((item.FindControl("UserID") as RadComboBox).SelectedValue);
                }
                par.Value = userID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Address1", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("Address1") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Address2", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("Address2") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Zip", SqlDbType.NVarChar, 20);
                par.Value = (item.FindControl("Zip") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@City", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("City") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@State", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("State") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CountryID", SqlDbType.NVarChar, 10);
                par.Value = (item.FindControl("CountryID") as RadComboBox).SelectedValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Phone", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("Phone") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Email", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("Email") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@WWW", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("WWW") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@MinWageAttestation", SqlDbType.Bit);
                par.Value = (item.FindControl("MinWageAttestation") as CheckBox).Checked;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AddressID", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();
                    lastID = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);

                    // Eintrag in Vorgangsverwaltung
                    string dialogName = GetGlobalResourceObject("Resource", Helpers.GetDialogResID(type.Name)).ToString();
                    string companyName = (item.FindControl("NameVisible") as RadTextBox).Text;
                    string refName = (item.FindControl("NameVisible") as RadTextBox).Text;

                    List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                    values.Add(new Tuple<string, string>("CompanyID", lastID.ToString()));
                    values.Add(new Tuple<string, string>("CompanyName", (item.FindControl("NameVisible") as RadTextBox).Text));
                    values.Add(new Tuple<string, string>("Description", (item.FindControl("NameAdditional") as RadTextBox).Text));
                    values.Add(new Tuple<string, string>("Address1", (item.FindControl("Address1") as RadTextBox).Text));
                    values.Add(new Tuple<string, string>("Address2", (item.FindControl("Address2") as RadTextBox).Text));
                    values.Add(new Tuple<string, string>("Zip", (item.FindControl("Zip") as RadTextBox).Text));
                    values.Add(new Tuple<string, string>("City", (item.FindControl("City") as RadTextBox).Text));
                    values.Add(new Tuple<string, string>("State", (item.FindControl("State") as RadTextBox).Text));
                    values.Add(new Tuple<string, string>("CountryName", (item.FindControl("CountryID") as RadComboBox).SelectedItem.Text));
                    values.Add(new Tuple<string, string>("WWW", (item.FindControl("WWW") as RadTextBox).Text));
                    values.Add(new Tuple<string, string>("TradeAssociation", (item.FindControl("TradeAssociation") as RadTextBox).Text));
                    string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Central/CompaniesCentral.aspx?CompanyID=" + companyID.ToString());
                    values.Add(new Tuple<string, string>("UrlCompany", url));

                    Master_Translations translation = Helpers.GetTranslation("PMHints_RegisterCompany", Helpers.CurrentLanguage(), values.ToArray());
                    string actionHint = translation.HtmlTranslated;

                    int bpID = Convert.ToInt32(Session["BpID"]);

                    string companyDuplicates = string.Empty;

                    // Duplikatsuche Firmen
                    GetCompanyCentralDuplicates_Result[] companies = Helpers.GetCompanyCentralDuplicates(lastID);
                    if (companies != null && companies.Count() > 0)
                    {
                        StringBuilder duplicatesHint = new StringBuilder();
                        duplicatesHint.Append("<br />Mögliche Duplikate (Bezeichnung, Zusatzbezeichnung, Adresse 1, PLZ, Ort, Land):<br />");
                        duplicatesHint.Append("Possible duplicates (Designation, Additional name, Address 1, Zip, City, Country):<br /><br />");
                        foreach (GetCompanyCentralDuplicates_Result company in companies)
                        {
                            duplicatesHint.AppendFormat("{0}, {1}, {2}, {3}, {4}, {5}<br />", company.NameVisible, company.NameAdditional, company.Address1, company.Zip, company.City, company.CountryID);
                        }
                        companyDuplicates = duplicatesHint.ToString();
                    }
                    if (companyDuplicates != string.Empty)
                    {
                        actionHint += companyDuplicates;
                    }

                    Session["BpID"] = 0;
                    Helpers.CreateProcessEvent(type.Name, dialogName, companyName, Actions.Release, lastID, refName, actionHint, "PMHints_RegisterCompany", values.ToArray());
                    Session["BpID"] = bpID;

                    Helpers.DialogLogger(type, Actions.Create, lastID.ToString(), Resources.Resource.lblActionInsert);
                    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgUpdateOK, "green");

                    if (Convert.ToBoolean(Session["NoExit"]))
                    {
                        action = Actions.Edit;
                        Helpers.SetAction(Actions.Edit);
                        Helpers.GotoLastEdited(RadGrid1, lastID, idName, true);
                        Session["NoExit"] = false;
                    }
                    else
                    {
                        action = Actions.View;
                    }
                }
                catch (SqlException ex)
                {
                    SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }
                catch (System.Exception ex)
                {
                    SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
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
        }

        protected void RadGrid1_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormItem item = e.Item as GridEditFormItem;

            if (Page.IsValid)
            {
                StringBuilder sql = new StringBuilder();

                sql.Append("INSERT INTO History_S_Companies SELECT * FROM System_Companies ");
                sql.AppendLine("WHERE [SystemID] = @SystemID AND CompanyID = @CompanyID; ");
                sql.Append("INSERT INTO History_S_Addresses SELECT * FROM System_Addresses ");
                sql.AppendLine("WHERE [SystemID] = @SystemID AND AddressID = @AddressID; ");
                sql.Append("UPDATE System_Companies ");
                sql.Append("SET NameVisible = @NameVisible, NameAdditional = @NameAdditional, TradeAssociation = @TradeAssociation, UserID = @UserID, StatusID = @StatusID, EditFrom = @UserName, ");
                sql.Append("EditOn = SYSDATETIME(), ReleaseFrom = @ReleaseFrom, ReleaseOn = @ReleaseOn, LockedFrom = @LockedFrom, LockedOn = @LockedOn, MinWageAttestation = @MinWageAttestation, Soundex = dbo.SoundexGer(@NameVisible) ");
                sql.AppendLine("WHERE SystemID = @SystemID AND CompanyID = @CompanyID; ");
                sql.Append("UPDATE System_Addresses SET Address1 = @Address1, Address2 = @Address2, Zip = @Zip, City = @City, State = @State, CountryID = @CountryID, Phone = @Phone, ");
                sql.Append("Email = @Email, WWW = @WWW, EditFrom = @UserName, EditOn = SYSDATETIME() WHERE SystemID = @SystemID AND AddressID = @AddressID");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@NameVisible", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("NameVisible") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@NameAdditional", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("NameAdditional") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@TradeAssociation", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("TradeAssociation") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@MinWageAttestation", SqlDbType.Bit);
                par.Value = (item.FindControl("MinWageAttestation") as CheckBox).Checked;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                int statusID = 0;
                string releaseOn = (item.FindControl("ReleaseOn") as RadTextBox).Text;
                string lockedOn = (item.FindControl("LockedOn") as RadTextBox).Text;
                if (lockedOn != null && !lockedOn.Equals(string.Empty))
                {
                    // Status: Locked
                    statusID = Status.Locked;
                }
                else if (releaseOn != null && !releaseOn.Equals(string.Empty) && (lockedOn == null || lockedOn.Equals(string.Empty)))
                {
                    // Status: Released
                    statusID = Status.Released;
                }
                else
                {
                    // Status: Waiting to release
                    statusID = Status.WaitRelease;
                }
                par.Value = statusID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ReleaseFrom", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("ReleaseFrom") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ReleaseOn", SqlDbType.DateTime);
                string parString = releaseOn;
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
                par.Value = (item.FindControl("LockedFrom") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LockedOn", SqlDbType.DateTime);
                parString = lockedOn;
                if (parString.Equals(String.Empty))
                {
                    par.Value = DBNull.Value;
                }
                else
                {
                    par.Value = parString;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);
                cmd.Parameters.Add(par);

                int userID = 0;
                par = new SqlParameter("@UserID", SqlDbType.Int);
                if (!(item.FindControl("UserID") as RadComboBox).SelectedValue.Equals(String.Empty))
                {
                    userID = Convert.ToInt32((item.FindControl("UserID") as RadComboBox).SelectedValue);
                }
                par.Value = userID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Address1", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("Address1") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Address2", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("Address2") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Zip", SqlDbType.NVarChar, 20);
                par.Value = (item.FindControl("Zip") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@City", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("City") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@State", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("State") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CountryID", SqlDbType.NVarChar, 10);
                par.Value = (item.FindControl("CountryID") as RadComboBox).SelectedValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Phone", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("Phone") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Email", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("Email") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@WWW", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("WWW") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AddressID", SqlDbType.Int);
                par.Value = (item.FindControl("AddressID") as HiddenField).Value;
                cmd.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();

                    // Behältermanagement aktualisieren
                    ContainerManagementClient client = new ContainerManagementClient();
                    int systemID = Convert.ToInt32(Session["SystemID"]);
                    try
                    {
                        client.CompanyData(systemID, 0, Convert.ToInt32((item.FindControl("CompanyID") as Label).Text), Actions.Update);
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

                    if (statusID == Status.Released)
                    {
                        // Aktuellen Vorgang auf erledigt setzen
                        Data_ProcessEvents eventData = new Data_ProcessEvents();
                        eventData.DialogID = Helpers.GetDialogID(type.Name);
                        eventData.ActionID = Actions.Release;
                        eventData.RefID = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);
                        eventData.StatusID = Status.Done;
                        Helpers.ProcessEventDone(eventData);

                        // Benutzerinformationen
                        Master_Users user = Helpers.GetUser(userID);
                        if (user != null)
                        {
                            // Email an registrierenden Benutzer
                            List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                            values.Add(new Tuple<string, string>("CompanyID", (item.FindControl("CompanyID") as Label).Text));
                            values.Add(new Tuple<string, string>("CompanyName", (item.FindControl("NameVisible") as RadTextBox).Text));
                            values.Add(new Tuple<string, string>("Description", (item.FindControl("NameAdditional") as RadTextBox).Text));
                            values.Add(new Tuple<string, string>("CountryName", (item.FindControl("CountryID") as RadComboBox).SelectedItem.Text));
                            values.Add(new Tuple<string, string>("WWW", (item.FindControl("WWW") as RadTextBox).Text));
                            values.Add(new Tuple<string, string>("TradeAssociation", (item.FindControl("TradeAssociation") as RadTextBox).Text));
                            string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Central/CompaniesCentral.aspx?CompanyID=" + (item.FindControl("CompanyID") as Label).Text);
                            values.Add(new Tuple<string, string>("UrlCompany", url));

                            Tuple<string, string>[] valuesArray = values.ToArray();
                            Master_Translations translation = Helpers.GetTranslation("ConfirmationEmail_CompanyReleased", user.LanguageID, valuesArray);

                            string subject = translation.DescriptionTranslated;
                            string bodyText = translation.HtmlTranslated;

                            Helpers.SendMail(user.Email, subject, bodyText, true);
                        }
                    }

                    Helpers.DialogLogger(type, Actions.Edit, (item.FindControl("CompanyID") as Label).Text, Resources.Resource.lblActionEdit);
                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                    action = Actions.View;

                    if (Convert.ToBoolean(Session["NoExit"]))
                    {
                        action = Actions.Edit;
                        Helpers.SetAction(Actions.Edit);
                        e.Canceled = true;
                        Session["NoExit"] = false;
                    }
                    else
                    {
                        action = Actions.View;
                        Helpers.SetAction(Actions.View);
                    }
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

                // Message anzeigen
                if (!string.IsNullOrEmpty(gridMessage))
                {
                    DisplayMessage(messageTitle, gridMessage, messageColor);
                }
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editFormItem = (GridEditFormItem)e.Item;

                if (e.Item is GridEditFormInsertItem)
                {
                    CheckBox cb = (CheckBox)e.Item.FindControl("MinWageAttestation");
                    if (cb != null)
                    {
                        // cb.Checked = true;
                    }
                }

                if (action == Actions.Lock || action == Actions.Release)
                {
                    RadTabStrip ts = editFormItem.FindControl("RadTabStrip1") as RadTabStrip;
                    ts.Tabs[0].Selected = false;
                    ts.Tabs[2].Selected = true;
                    ts.Tabs[2].PageView.Selected = true;
                }
            }

            if (e.Item is GridFilteringItem)
            {
                // Formatierung für Datumsfilter
                GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                if (filteringItem != null)
                {
                    LiteralControl literal = filteringItem["EditOn"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["EditOn"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
                }
            }

            if (e.Item is GridCommandItem)
            {
                GridCommandItem commandItem = (e.Item as GridCommandItem);
                PlaceHolder placeHolder = commandItem.FindControl("AlphaFilter") as PlaceHolder;
                if (placeHolder != null)
                {
                    RadButton rb;

                    for (int i = 65; i <= 65 + 25; i++)
                    {
                        rb = new RadButton();

                        rb.Text = string.Empty + (char)i;
                        rb.CommandName = "AlphaFilter";
                        rb.CommandArgument = string.Empty + (char)i;
                        rb.Width = new Unit(25, UnitType.Pixel);
                        rb.BorderStyle = BorderStyle.None;
                        if ( Session["AlphaFilter"] != null && Session["AlphaFilter"].ToString().Equals(string.Empty + (char)i))
                        {
                            rb.ForeColor = Color.Orange;
                            rb.Font.Bold = true;
                        }
                        else
                        {
                            rb.ForeColor = Color.Black;
                            rb.Font.Bold = false;
                        }
                        rb.ButtonType = RadButtonType.SkinnedButton;
                        rb.GroupName = "AlphaFilterGroup";
                        rb.CssClass = "AlphaButton";
                        rb.ToolTip = Resources.Resource.ttFilterByFirstLetter + " " + (char)i;

                        placeHolder.Controls.Add(rb);
                    }

                    rb = new RadButton();
                    rb.Text = Resources.Resource.lblAll;
                    rb.CommandName = "AlphaFilter";
                    rb.CommandArgument = string.Empty;
                    rb.BorderStyle = BorderStyle.None;
                    if (Session["AlphaFilter"] != null && Session["AlphaFilter"].ToString().Equals(string.Empty))
                    {
                        rb.ForeColor = Color.Orange;
                        rb.Font.Bold = true;
                    }
                    else
                    {
                        rb.ForeColor = Color.Black;
                        rb.Font.Bold = false;
                    }
                    rb.ButtonType = RadButtonType.SkinnedButton;
                    rb.GroupName = "AlphaFilterGroup";
                    rb.ToolTip = Resources.Resource.ttFilterNoFirstLetter;

                    placeHolder.Controls.Add(rb);
                }
            }
        }

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
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

        protected void ValidatorRadGridTariffs_ServerValidate(object source, ServerValidateEventArgs args)
        {
            RadGrid rg = (RadGrid)(((GridEditFormItem)((CustomValidator)source).NamingContainer)).FindControl("RadGridTariffs");
            if (rg != null)
            {
                if (!rg.MasterTableView.IsItemInserted && rg.MasterTableView.Items.Count == 0)
                {
                    args.IsValid = false;
                }
            }
        }

        protected void RadGridTariffs_PreRender(object sender, EventArgs e)
        {
            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }

            RadGrid radGridTariffs = sender as RadGrid;

            if (radGridTariffs.MasterTableView.IsItemInserted)
            {
                (radGridTariffs.MasterTableView.GetColumn("TariffScopeID") as GridTemplateColumn).ReadOnly = false;
            }
            else
            {
                (radGridTariffs.MasterTableView.GetColumn("TariffScopeID") as GridTemplateColumn).ReadOnly = true;
            }
        }

        protected void RadGridTariffs_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGridTariffs_ItemInserted(object sender, GridInsertedEventArgs e)
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

                // Benachrichtigung an alle Benutzer mit Recht "Freigabe Firma für BV"
                GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;
                List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                int tariffScopeID = Convert.ToInt32((item.FindControl("TariffScopeID") as RadComboBox).SelectedValue);
                companyID = Convert.ToInt32(Session["SelectedCompanyID"]);
                GetCompanyTariff_Result tariff = Helpers.GetCompanyTariff(companyID, tariffScopeID);

                if (tariff != null)
                {
                    values.Add(new Tuple<string, string>("CompanyID", companyID.ToString()));
                    values.Add(new Tuple<string, string>("CompanyName", tariff.CompanyName));
                    values.Add(new Tuple<string, string>("Tariff", tariff.TariffName));
                    values.Add(new Tuple<string, string>("TariffContract", tariff.TariffContractName));
                    values.Add(new Tuple<string, string>("TariffScope", tariff.TariffScopeName));
                    values.Add(new Tuple<string, string>("ValidFrom", tariff.ValidFrom.ToShortDateString()));
                    Tuple<string, string>[] valuesArray = values.ToArray();
                    Master_Translations translation = Helpers.GetTranslation("InternalMessageTemplates_CompanyTariffs", Helpers.CurrentLanguage(), valuesArray);
                    string subject = translation.DescriptionTranslated;
                    string bodyText = translation.HtmlTranslated;

                    Webservices webservice = new Webservices();
                    Master_BuildingProjects[] bps = webservice.GetAllBpsInfo();
                    foreach (Master_BuildingProjects bp in bps)
                    {
                        if (bp.MWCheck)
                        {
                            string messageText = Resources.Resource.lblBuildingProject + " " + bp.BpID.ToString() + " (" + bp.NameVisible + "): " + bodyText;
                            Helpers.SendMessageToUsersWithRight(bp.BpID, companyID, Helpers.GetDialogID(type.Name), Actions.ReleaseBp, subject, messageText);
                        }
                    }
                }
            }
        }

        protected void RadGridTariffs_ItemUpdated(object sender, GridUpdatedEventArgs e)
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
                Helpers.DialogLogger(type, Actions.Edit, (e.Item as GridEditFormItem).GetDataKeyValue("TariffScopeID").ToString(), Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");

                // Benachrichtigung an alle Benutzer mit Recht "Freigabe Firma für BV"
                GridEditFormItem item = e.Item as GridEditFormItem;
                List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                int tariffScopeID = Convert.ToInt32(item.GetDataKeyValue("TariffScopeID"));
                companyID = Convert.ToInt32(item.GetDataKeyValue("CompanyID"));
                GetCompanyTariff_Result tariff = Helpers.GetCompanyTariff(companyID, tariffScopeID);

                values.Add(new Tuple<string, string>("CompanyID", companyID.ToString()));
                values.Add(new Tuple<string, string>("CompanyName", tariff.CompanyName));
                values.Add(new Tuple<string, string>("Tariff", tariff.TariffName));
                values.Add(new Tuple<string, string>("TariffContract", tariff.TariffContractName));
                values.Add(new Tuple<string, string>("TariffScope", tariff.TariffScopeName));
                values.Add(new Tuple<string, string>("ValidFrom", tariff.ValidFrom.ToShortDateString()));
                Tuple<string, string>[] valuesArray = values.ToArray();
                Master_Translations translation = Helpers.GetTranslation("InternalMessageTemplates_CompanyTariffs", Helpers.CurrentLanguage(), valuesArray);
                string subject = translation.DescriptionTranslated;
                string bodyText = translation.HtmlTranslated;

                Webservices webservice = new Webservices();
                Master_BuildingProjects[] bps = webservice.GetAllBpsInfo();
                foreach (Master_BuildingProjects bp in bps)
                {
                    if (bp.MWCheck)
                    {
                        string messageText = Resources.Resource.lblBuildingProject + " " + bp.BpID.ToString() + " (" + bp.NameVisible + "): " + bodyText;
                        Helpers.SendMessageToUsersWithRight(bp.BpID, companyID, Helpers.GetDialogID(type.Name), Actions.ReleaseBp, subject, messageText);
                    }
                }
            }
        }

        protected void RadGridTariffs_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue("TariffScopeID").ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        protected void RadGridTariffs_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblTariffs);

            if (e.CommandName == "RowClick")
            {
                GridDataItem item = e.Item.OwnerTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue("TariffScopeID").ToString(), Resources.Resource.lblActionView);
                item.Expanded = !item.Expanded;
            }

            if (e.CommandName == "Edit")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffsNoExit") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = false;
            }

            if (e.CommandName == "InitInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffsNoExit") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = false;
            }

            if (e.CommandName == "Cancel")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffsNoExit") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
            }

            if (e.CommandName == "Update")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffsNoExit") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
            }

            if (e.CommandName == "PerformInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffsNoExit") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
            }
        }

        protected void TariffScopeID_ItemDataBound(object sender, RadComboBoxItemEventArgs e)
        {
            if (e.Item.Index % 2 == 0)
            {
                e.Item.BackColor = Color.FromArgb(240, 240, 240);
            }
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            if (Session["AlphaFilter"] != null && !Session["AlphaFilter"].ToString().Equals(string.Empty))
            {
            }
            int bpId = Convert.ToInt32(SelectBp.SelectedValue);

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT UPPER(LEFT (s_c.NameVisible, 1)) AS FirstChar, s_c.SystemID, s_c.CompanyID, s_c.NameVisible, s_c.NameAdditional, s_c.Description, s_c.AddressID, s_c.IsVisible, s_c.IsValid, ");
            sql.Append("s_c.TradeAssociation, s_c.BlnSOKA, s_c.UserID, s_c.StatusID, s_c.CreatedFrom, s_c.CreatedOn, s_c.EditFrom, s_c.EditOn, s_a.Address1, s_a.Address2, ");
            sql.Append("s_a.Zip, s_a.City, s_a.State, s_a.CountryID, s_a.Phone, s_a.Email, s_a.WWW, s_c.RequestFrom, s_c.RequestOn, s_c.ReleaseFrom, s_c.ReleaseOn, ");
            sql.Append("s_c.LockedFrom, s_c.LockedOn, s_l.FlagName, s_c.MinWageAttestation, s_l.CountryName, s_c.Soundex AS Duplicates ");
            sql.Append("FROM View_Countries AS s_l ");
            sql.Append("INNER JOIN System_Addresses AS s_a ");
            sql.Append("ON s_l.CountryID = s_a.CountryID ");
            sql.Append("RIGHT OUTER JOIN System_Companies AS s_c ");
            sql.Append("ON s_a.SystemID = s_c.SystemID AND s_a.AddressID = s_c.AddressID ");

            if (bpId>0)
                sql.Append("LEFT OUTER JOIN Master_Companies AS mc ON mc.CompanyCentralID = s_c.CompanyID ");

            sql.Append("WHERE s_c.SystemID = @SystemID ");
            sql.Append("AND s_c.CompanyID = (CASE WHEN @CompanyID = 0 THEN s_c.CompanyID ELSE @CompanyID END) ");
            if (Session["AlphaFilter"] != null && !Session["AlphaFilter"].ToString().Equals(string.Empty))
            {
                sql.AppendFormat("AND UPPER(LEFT(s_c.NameVisible, 1)) = '{0}' ", Session["AlphaFilter"].ToString());
            }

            if (bpId > 0)
                sql.Append(string.Format ("AND  mc.BpID = {0} ", bpId));


            sql.Append("ORDER BY s_c.NameVisible ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value =   Convert.ToInt32(Session["CompanyID"]);
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
                RadGrid1.DataSource = dt;
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
        }

        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("DeleteSystemCompany", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item.FindControl("CompanyID") as Label).Text);
            cmd.Parameters.Add(par);
            
            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Delete, (e.Item.FindControl("CompanyID") as Label).Text, Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
                action = Actions.View;
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


        //protected void SelectBp_SelectedIndexChanged1(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        //{
        //    RadGrid1.Rebind();
        //}
    }
}