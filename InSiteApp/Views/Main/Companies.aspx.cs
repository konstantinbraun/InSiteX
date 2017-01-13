using InSite.App.Constants;
using InSite.App.Controls;
using InSite.App.CMServices;
using InSite.App.UserServices;
using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Main
{
    public partial class Companies : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "CompanyID";
        private int action = Actions.View;

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        String msg = "";
        int companyID = 0;
        int lastCompanyID = 0;
        int lastLevel = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            msg = Request.QueryString["CompanyID"];
            if (msg != null)
            {
                companyID = Convert.ToInt32(msg);
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

            // Parameterabfrage für Vorgangsverwaltung
            msg = Request.QueryString["ID"];
            if (msg != null)
            {
                companyID = Convert.ToInt32(msg);
                lastCompanyID = companyID;
                Session["LastEdited"] = true;
                Session["ShowCompanyTree"] = false;
            }
            msg = Request.QueryString["Action"];
            if (msg != null)
            {
                action = Convert.ToInt32(msg);
                Helpers.SetAction(action);
                if (action != Actions.Edit && action != Actions.Release && action != Actions.ReleaseBp)
                {
                    Session["LastEdited"] = false;
                }
            }

            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);

                //if (Session["ShowCompanyTree"] == null)
                //{
                    Session["ShowCompanyTree"] = true;
                //}

            //    RadTreeList1.DataSource = GetCompaniesData();
            //    RadTreeList1.DataBind();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Literal für Statusmeldungen
            Helpers.AddTreeListStatus(RadTreeList1, Page);
            //Convert.ToInt32(HttpContext.Current.Session["CompanyID"]) == 0 && 
            if (Convert.ToBoolean(Session["ShowCompanyTree"]))
            {
                RadTreeList1.ShowTreeLines = true;
                SwitchToTree.Checked = true;
                SwitchToList.Checked = false;
                if (!IsPostBack)
                {
                    if (SearchText.Text.Equals(String.Empty) && companyID == 0)
                    {
                        RadTreeList1.ExpandToLevel(3);
                    }
                    else
                    {
                        RadTreeList1.ExpandAllItems();
                    }
                }
                else
                {
                    if (lastLevel != 0)
                    {
                        RadTreeList1.ExpandToLevel(lastLevel);
                        lastLevel = 0;
                    }
                }
            }
            else
            {
                RadTreeList1.ShowTreeLines = false;
                SwitchToTree.Checked = false;
                SwitchToList.Checked = true;
            }

            Helpers.GotoLastEditedTL(RadTreeList1, lastCompanyID, idName, false);
        }

        protected void SqlDataSource_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            String ret = e.Command.Parameters["@ReturnValue"].Value.ToString();
            Helpers.DialogLogger(type, Actions.Create, ret, Resources.Resource.lblActionCreate);
        }

        private void DisplayMessage(string command, string text, string color)
        {
            // Meldung in Statuszeile und per Notification
            Helpers.UpdateTreeListStatus(RadTreeList1, command, text, color);
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

        protected void RadGridTariffs_PreRender(object sender, EventArgs e)
        {
            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        protected void AvailableTrades_Dropped(object sender, RadListBoxDroppedEventArgs e)
        {
            RadListBoxItem item = e.SourceDragItems as RadListBoxItem;
        }

        protected void AssignedTrades_Dropped(object sender, RadListBoxDroppedEventArgs e)
        {
            RadListBoxItem item = e.SourceDragItems as RadListBoxItem;
        }

        protected void AvailableTrades_Transferred(object sender, RadListBoxTransferredEventArgs e)
        {
            if (e.Items.Count > 0)
            {
                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand("MoveCompanyTrade", con);
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
                par.Value = Convert.ToInt32((e.SourceListBox.Parent.FindControl("CompanyID") as Label).Text);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@TradeID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@User", SqlDbType.NVarChar, 50);
                par.Direction = ParameterDirection.Input;
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                foreach (RadListBoxItem item in e.Items)
                {
                    cmd.Parameters["@TradeID"].Value = item.Value;

                    con.Open();
                    try
                    {
                        logger.InfoFormat("Try to execute {0}", cmd.CommandText);
                        cmd.ExecuteNonQuery();
                    }
                    catch (SqlException ex)
                    {
                        logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                        throw;
                    }
                    catch (System.Exception ex)
                    {
                        logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                        throw;
                    }
                    finally
                    {
                        con.Close();
                    }
                }
            }
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

        protected void RadTreeList1_DeleteCommand(object sender, TreeListCommandEventArgs e)
        {
            TreeListDataItem item = e.Item as TreeListDataItem;

            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO History_Companies (SystemID, BpID, CompanyID, CompanyCentralID, ParentID, NameVisible, NameAdditional, Description, AddressID, IsVisible, ");
            sql.Append("IsValid, TradeAssociation, IsPartner, BlnSOKA, MinWageAttestation, UserString1, UserString2, UserString3, UserString4, UserBit1, UserBit2, UserBit3, ");
            sql.Append("UserBit4, CreatedFrom, CreatedOn, EditFrom, EditOn, LockSubContractors, MinWageAccessRelevance, PassBudget, StatusID, AllowSubcontractorEdit) ");
            sql.Append("SELECT SystemID, BpID, CompanyID, CompanyCentralID, ParentID, NameVisible, NameAdditional, Description, AddressID, IsVisible, ");
            sql.Append("IsValid, TradeAssociation, IsPartner, BlnSOKA, MinWageAttestation, UserString1, UserString2, UserString3, UserString4, UserBit1, UserBit2, UserBit3, ");
            sql.Append("UserBit4, CreatedFrom, CreatedOn, EditFrom, EditOn, LockSubContractors, MinWageAccessRelevance, PassBudget, StatusID, AllowSubcontractorEdit ");
            sql.Append("FROM Master_Companies ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND CompanyID = @CompanyID; ");
            sql.Append("DELETE FROM Master_Employees ");
            sql.AppendLine("WHERE [SystemID] = @SystemID AND BpID = @BpID AND [CompanyID] = @CompanyID; ");
            sql.Append("DELETE FROM Master_CompanyAdditions ");
            sql.AppendLine("WHERE [SystemID] = @SystemID AND BpID = @BpID AND [CompanyID] = @CompanyID; ");
            sql.Append("DELETE FROM Master_CompanyContacts ");
            sql.AppendLine("WHERE [SystemID] = @SystemID AND BpID = @BpID AND [CompanyID] = @CompanyID; ");
            sql.Append("DELETE FROM Master_CompanyTariffs ");
            sql.AppendLine("WHERE [SystemID] = @SystemID AND BpID = @BpID AND [CompanyID] = @CompanyID; ");
            sql.Append("DELETE FROM Master_CompanyTrades ");
            sql.AppendLine("WHERE [SystemID] = @SystemID AND BpID = @BpID AND [CompanyID] = @CompanyID; ");
            sql.Append("DELETE FROM Data_ProcessEvents ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND DialogID = 2 AND RefID = @CompanyID; ");
            sql.Append("DELETE FROM Master_Companies ");
            sql.AppendLine("WHERE [SystemID] = @SystemID AND BpID = @BpID AND [CompanyID] = @CompanyID; ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = Session["LoginName"].ToString();
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = Convert.ToInt32(item.GetDataKeyValue("CompanyID"));
            cmd.Parameters.Add(par);
            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Delete, companyID.ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");

                action = Actions.View;
                Helpers.SetAction(Actions.View);
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

        protected void RadTreeList1_InsertCommand(object sender, TreeListCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                TreeListEditFormInsertItem item = e.Item as TreeListEditFormInsertItem;
                RadDropDownList ddl = (item.FindControl("CompanyCentralID") as RadDropDownList);
                if (ddl.SelectedItem == null)
                {
                    e.Canceled = true;
                    ddl.Focus();
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblActionInsert, Resources.Resource.msgPleaseSelect);
                }
                else
                {
                    StringBuilder sql = new StringBuilder();
                    sql.Append("INSERT INTO [Master_Companies] ([SystemID], BpID, CompanyID, CompanyCentralID, ParentID, [NameVisible], NameAdditional, [Description], [AddressID], [IsVisible], [IsValid], TradeAssociation, ");
                    sql.Append("IsPartner, BlnSOKA, MinWageAttestation, UserString1, UserString2, UserString3, UserString4, UserBit1, UserBit2, UserBit3, UserBit4, [CreatedFrom], [CreatedOn], ");
                    sql.Append("[EditFrom], [EditOn], LockSubContractors, MinWageAccessRelevance, PassBudget, StatusID, AllowSubcontractorEdit) ");
                    sql.Append("SELECT @SystemID, @BpID, @CompanyID, @CompanyCentralID, @ParentID, NameVisible, NameAdditional, Description, AddressID, 1, 1, TradeAssociation, @IsPartner, @BlnSOKA, ");
                    sql.Append("@MinWageAttestation, @UserString1, @UserString2, @UserString3, @UserString4, @UserBit1, @UserBit2, @UserBit3, @UserBit4, @UserName, SYSDATETIME(), @UserName, ");
                    sql.Append("SYSDATETIME(), @LockSubContractors, @MinWageAccessRelevance, @PassBudget, @StatusID, @AllowSubcontractorEdit ");
                    sql.AppendLine("FROM System_Companies WHERE SystemID = @SystemID AND CompanyID = @CompanyCentralID; ");
                    sql.Append("INSERT INTO [Master_CompanyTariffs] ([SystemID], BpID, [TariffScopeID], CompanyID, [ValidFrom], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) ");
                    sql.Append("SELECT [SystemID], @BpID, dbo.BestTariffScope(@SystemID, @BpID, TariffScopeID), @CompanyID, [ValidFrom], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn] ");
                    sql.Append("FROM System_CompanyTariffs WHERE SystemID = @SystemID AND CompanyID = @CompanyCentralID ");

                    SqlConnection con = new SqlConnection(ConnectionString);
                    SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                    SqlParameter par = new SqlParameter();

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BpID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["BpID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                    par.Value = Session["LoginName"].ToString();
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@CompanyID", SqlDbType.Int);
                    par.Value = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@CompanyCentralID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(ddl.SelectedValue);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AddressID", SqlDbType.Int);
                    par.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(par);

                    int parentValue = 0;
                    RadDropDownTree rddt = (item.FindControl("ParentID") as RadDropDownTree);
                    if (rddt != null && !rddt.SelectedValue.Equals(string.Empty))
                    {
                        parentValue = Convert.ToInt32(rddt.SelectedValue);
                    }
                    par = new SqlParameter("@ParentID", SqlDbType.Int);
                    par.Value = parentValue;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Description", SqlDbType.NVarChar, 2000);
                    par.Value = (item.FindControl("Description") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@TradeAssociation", SqlDbType.NVarChar, 200);
                    par.Value = (item.FindControl("TradeAssociation") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BlnSOKA", SqlDbType.Bit);
                    par.Value = (item.FindControl("BlnSOKA") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@IsPartner", SqlDbType.Bit);
                    par.Value = (item.FindControl("IsPartner") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@MinWageAttestation", SqlDbType.Bit);
                    par.Value = (item.FindControl("MinWageAttestation") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@MinWageAccessRelevance", SqlDbType.Bit);
                    par.Value = 0;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AllowSubcontractorEdit", SqlDbType.Bit);
                    par.Value = (item.FindControl("AllowSubcontractorEdit") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@PassBudget", SqlDbType.Decimal, 12);
                    decimal passBudget = 0;
                    if (!(item.FindControl("PassBudget") as RadTextBox).Text.Equals(string.Empty))
                    {
                        passBudget = Convert.ToDecimal((item.FindControl("PassBudget") as RadTextBox).Text);
                    }
                    par.Value = passBudget;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@LockSubContractors", SqlDbType.Bit);
                    par.Value = (item.FindControl("LockSubContractors") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString1", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString1") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString2", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString2") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString3", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString3") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString4", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString4") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit1", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit1") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit2", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit2") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit3", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit3") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit4", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit4") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@StatusID", SqlDbType.Int);
                    par.Value = Status.WaitRelease;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ReturnValue", SqlDbType.Int);
                    par.Direction = ParameterDirection.Output;
                    cmd.Parameters.Add(par);

                    con.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();

                        lastCompanyID = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);
                        if (item.ParentItem != null)
                        {
                            lastLevel = item.ParentItem.HierarchyIndex.NestedLevel + 1;
                        }
                        else
                        {
                            lastLevel = 0;
                        }

                        // Behältermanagement aktualisieren
                        ContainerManagementClient client = new ContainerManagementClient();
                        int systemID = Convert.ToInt32(Session["SystemID"]);
                        int bpID = Convert.ToInt32(Session["BpID"]);
                        int companyCentralID = Convert.ToInt32(ddl.SelectedValue);
                        try
                        {
                            client.CompanyData(systemID, bpID, companyCentralID, Actions.Insert);
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

                        Helpers.DialogLogger(type, Actions.Create, companyID.ToString(), Resources.Resource.lblActionCreate);
                        SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");

                        // Eintrag in Vorgangsverwaltung
                        Data_ProcessEvents eventData = new Data_ProcessEvents();
                        eventData.DialogID = Helpers.GetDialogID(type.Name);
                        eventData.ActionID = Actions.ReleaseBp;
                        eventData.RefID = lastCompanyID;
                        eventData.NameVisible = "Firmenstamm BV";
                        eventData.DescriptionShort = "Daten komplett und stimmig?";
                        eventData.CompanyCentralID = Convert.ToInt32(ddl.SelectedValue);
                        List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                        Helpers.SetProcessEvent(eventData, string.Empty, values.ToArray());

                        if (Convert.ToBoolean(Session["NoExit"]))
                        {
                            action = Actions.Edit;
                            Helpers.SetAction(Actions.Edit);
                            Helpers.GotoLastEditedTL(RadTreeList1, lastCompanyID, idName, true);
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

                    // Message anzeigen
                    if (!string.IsNullOrEmpty(gridMessage))
                    {
                        DisplayMessage(messageTitle, gridMessage, messageColor);
                    }
                }
            }
        }

        protected void RadTreeList1_UpdateCommand(object sender, TreeListCommandEventArgs e)
        {
            // Tarifgebiet zugeordnet, wenn Firma ML-Pflichtig?
            if (Page.IsValid)
            {
                action = Helpers.GetAction();

                TreeListEditFormItem item = e.Item as TreeListEditFormItem;

                int parentValue = 0;
                RadDropDownTree rddt = (item.FindControl("ParentID") as RadDropDownTree);
                if (rddt != null && !rddt.SelectedValue.Equals(string.Empty))
                {
                    int pos = rddt.SelectedValue.IndexOf(",");
                    if (pos != -1)
                    {
                        rddt.SelectedValue = rddt.SelectedValue.Substring(0, pos);
                    }
                    parentValue = Convert.ToInt32(rddt.SelectedValue);
                }
                lastCompanyID = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);

                // Firma darf nicht ihr eigener Auftraggeber sein
                if (parentValue == lastCompanyID)
                {
                    e.Canceled = true;
                    rddt.Focus();
                    // Benutzer benachrichtigen
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblActionUpdate, Resources.Resource.msgNotSelfClient);
                }
                else
                {

                    // bool accessRelevantChanges = false;
                    bool accessRelevantChanges = true;

                    StringBuilder sql = new StringBuilder();

                    sql.Append("INSERT INTO History_Companies (SystemID, BpID, CompanyID, CompanyCentralID, ParentID, NameVisible, NameAdditional, Description, AddressID, IsVisible, ");
                    sql.Append("IsValid, TradeAssociation, IsPartner, BlnSOKA, MinWageAttestation, UserString1, UserString2, UserString3, UserString4, UserBit1, UserBit2, UserBit3, ");
                    sql.Append("UserBit4, CreatedFrom, CreatedOn, EditFrom, EditOn, LockSubContractors, MinWageAccessRelevance, PassBudget, StatusID, AllowSubcontractorEdit) ");
                    sql.Append("SELECT SystemID, BpID, CompanyID, CompanyCentralID, ParentID, NameVisible, NameAdditional, Description, AddressID, IsVisible, ");
                    sql.Append("IsValid, TradeAssociation, IsPartner, BlnSOKA, MinWageAttestation, UserString1, UserString2, UserString3, UserString4, UserBit1, UserBit2, UserBit3, ");
                    sql.Append("UserBit4, CreatedFrom, CreatedOn, EditFrom, EditOn, LockSubContractors, MinWageAccessRelevance, PassBudget, StatusID, AllowSubcontractorEdit FROM Master_Companies ");
                    sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND CompanyID = @CompanyID; ");
                    sql.Append("UPDATE [Master_Companies] SET [Description] = @Description, [IsVisible] = 1, ");
                    sql.Append("[IsValid] = 1, TradeAssociation = @TradeAssociation, IsPartner = @IsPartner, BlnSOKA = @BlnSOKA, MinWageAttestation = @MinWageAttestation, StatusID = @StatusID, ");
                    sql.Append("UserString1 = @UserString1, UserString2 = @UserString2, UserString3 = @UserString3, UserString4 = @UserString4, UserBit1 = @UserBit1, UserBit2 = @UserBit2, ");
                    sql.Append("UserBit3 = @UserBit3, UserBit4 = @UserBit4, [EditFrom] = @UserName, [EditOn] = SYSDATETIME(), ReleaseFrom = @ReleaseFrom, ReleaseOn = @ReleaseOn, ");
                    sql.Append("LockedFrom = @LockedFrom, LockedOn = @LockedOn, RegistrationCode = @RegistrationCode, CodeValidUntil = @CodeValidUntil, LockSubContractors = @LockSubContractors, ");
                    sql.Append("MinWageAccessRelevance = @MinWageAccessRelevance, PassBudget = @PassBudget, ParentID = @ParentID, AllowSubcontractorEdit = @AllowSubcontractorEdit ");
                    sql.AppendLine("WHERE [SystemID] = @SystemID AND BpID = @BpID AND [CompanyID] = @CompanyID; ");

                    int prevStatusID = Convert.ToInt32((item.FindControl("StatusID") as HiddenField).Value);
                    int statusID = 0;
                    string releaseOn = (item.FindControl("ReleaseOn") as Label).Text;
                    string lockedOn = (item.FindControl("LockedOn") as Label).Text;
                    if (lockedOn != null && !lockedOn.Equals(string.Empty))
                    {
                        // Status: Locked
                        statusID = Status.Locked;
                    }
                    else if (releaseOn != null && !releaseOn.Equals(string.Empty) && (lockedOn == null || lockedOn.Equals(string.Empty)))
                    {
                        // Status: Released for central company master and building project
                        statusID = Status.Released;
                    }
                    else
                    {
                        // Status: Waiting to release for central company master and building project
                        statusID = Status.WaitRelease;
                    }

                    if (item.SavedOldValues["StatusID"] != null && !item.SavedOldValues["StatusID"].ToString().Equals(statusID.ToString()))
                    {
                        accessRelevantChanges = true;
                    }

                    SqlConnection con = new SqlConnection(ConnectionString);
                    SqlCommand cmd = new SqlCommand();
                    cmd.Connection = con;
                    SqlParameter par = new SqlParameter();

                    if (prevStatusID == Status.WaitRelease && statusID == Status.Released)
                    {
                        sql.Append("INSERT INTO Master_UserBuildingProjects ");
                        sql.Append("(SystemID, UserID, BpID, RoleID, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                        sql.Append("SELECT s_c.SystemID, s_c.UserID, @BpID, @DefaultRoleID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME() ");
                        sql.Append("FROM System_Companies s_c ");
                        sql.Append("WHERE SystemID = @SystemID AND CompanyID = @CompanyCentralID AND s_c.UserID > 0 ");
                        sql.AppendLine("AND NOT EXISTS (SELECT 0 FROM Master_UserBuildingProjects m_ubp WHERE m_ubp.SystemID = s_c.SystemID AND m_ubp.UserID = s_c.UserID); ");

                        par = new SqlParameter("@CompanyCentralID", SqlDbType.Int);
                        par.Value = Convert.ToInt32((item.FindControl("CompanyCentralID1") as HiddenField).Value);
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@DefaultRoleID", SqlDbType.Int);
                        par.Value = Helpers.GetDefaultRoleID(Convert.ToInt32(Session["BpID"]));
                        cmd.Parameters.Add(par);
                    }

                    cmd.CommandText = sql.ToString();

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BpID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["BpID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                    par.Value = Session["LoginName"].ToString();
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@CompanyID", SqlDbType.Int);
                    par.Value = lastCompanyID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ParentID", SqlDbType.Int);
                    par.Value = parentValue;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AddressID", SqlDbType.Int);
                    par.Value = Convert.ToInt32((item.FindControl("AddressID") as HiddenField).Value);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Description", SqlDbType.NVarChar, 2000);
                    par.Value = (item.FindControl("Description") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@TradeAssociation", SqlDbType.NVarChar, 200);
                    par.Value = (item.FindControl("TradeAssociation") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BlnSOKA", SqlDbType.Bit);
                    par.Value = (item.FindControl("BlnSOKA") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@IsPartner", SqlDbType.Bit);
                    par.Value = (item.FindControl("IsPartner") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@MinWageAttestation", SqlDbType.Bit);
                    par.Value = (item.FindControl("MinWageAttestation") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AllowSubcontractorEdit", SqlDbType.Bit);
                    par.Value = (item.FindControl("AllowSubcontractorEdit") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@MinWageAccessRelevance", SqlDbType.Bit);
                    par.Value = 0;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@PassBudget", SqlDbType.Decimal, 12);
                    par.Value = Convert.ToDecimal((item.FindControl("PassBudget") as RadTextBox).Text);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@LockSubContractors", SqlDbType.Bit);
                    par.Value = (item.FindControl("LockSubContractors") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@StatusID", SqlDbType.Int);
                    par.Value = statusID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString1", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString1") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString2", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString2") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString3", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString3") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString4", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString4") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit1", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit1") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit2", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit2") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit3", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit3") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit4", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit4") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ReleaseFrom", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("ReleaseFrom") as Label).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ReleaseOn", SqlDbType.DateTime);
                    string parString = (item.FindControl("ReleaseOn") as Label).Text;
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

                    par = new SqlParameter("@RegistrationCode", SqlDbType.NVarChar, 20);
                    par.Value = (item.FindControl("RegistrationCode") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@CodeValidUntil", SqlDbType.DateTime);
                    RadDatePicker rdp = (item.FindControl("CodeValidUntil") as RadDatePicker);
                    if (rdp.SelectedDate == null)
                    {
                        par.Value = DBNull.Value;
                    }
                    else
                    {
                        par.Value = rdp.SelectedDate;
                    }
                    cmd.Parameters.Add(par);

                    con.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();

                        Helpers.DialogLogger(type, Actions.Edit, (item.FindControl("CompanyID") as Label).Text, Resources.Resource.lblActionEdit);
                        SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");

                        GetCompanyInfo_Result[] company = Helpers.GetCompanyInfo(Convert.ToInt32((item.FindControl("CompanyID") as Label).Text));

                        // Email an registrierenden Benutzer
                        List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                        values.Add(new Tuple<string, string>("CompanyID", company[0].CompanyID.ToString()));
                        values.Add(new Tuple<string, string>("CompanyName", company[0].NameVisible));
                        values.Add(new Tuple<string, string>("Description", company[0].NameAdditional));
                        values.Add(new Tuple<string, string>("ClientID", company[0].ClientCompanyID.ToString()));
                        values.Add(new Tuple<string, string>("ClientName", company[0].ClientNameVisible));
                        values.Add(new Tuple<string, string>("ClientDescription", company[0].ClientNameAdditional));
                        values.Add(new Tuple<string, string>("BpName", Session["BpName"].ToString()));
                        values.Add(new Tuple<string, string>("CountryName", (item.FindControl("CountryID") as RadComboBox).SelectedItem.Text));
                        string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Main/Companies.aspx?CompanyID=" + company[0].CompanyID.ToString());
                        values.Add(new Tuple<string, string>("UrlCompany", url));

                        if ((prevStatusID == Status.WaitRelease || prevStatusID == Status.Locked) && statusID == Status.Released)
                        {
                            // Aktuellen Vorgang auf erledigt setzen
                            Data_ProcessEvents eventData = new Data_ProcessEvents();
                            eventData.DialogID = Helpers.GetDialogID(type.Name);
                            eventData.ActionID = Actions.ReleaseBp;
                            eventData.RefID = Convert.ToInt32((item.FindControl("CompanyID") as Label).Text);
                            eventData.StatusID = Status.Done;

                            Helpers.ProcessEventDone(eventData);

                            // Benutzerinformationen
                            Master_Users user = Helpers.GetUser(company[0].UserID);
                            if (user != null)
                            {
                                Tuple<string, string>[] valuesArray = values.ToArray();
                                Master_Translations translation = Helpers.GetTranslation("ConfirmationEmail_CompanyReleasedBp", user.LanguageID, valuesArray);

                                string subject = translation.DescriptionTranslated;
                                string bodyText = translation.HtmlTranslated;

                                Helpers.SendMail(user.Email, subject, bodyText, true);
                            }
                        }

                        if (prevStatusID == Status.Released && statusID == Status.Locked)
                        {
                            // Vorgang für Weiterverarbeitung
                            string dialogName = GetResource(Helpers.GetDialogResID(type.Name));
                            string companyName = Helpers.GetCompanyName(Convert.ToInt32((item.FindControl("CompanyCentralID1") as HiddenField).Value));
                            string refName = companyName;
                            string actionHint = "Firma wurde für BV gesperrt. Sperrgrund beseitigen!";
                            Helpers.CreateProcessEvent(type.Name, dialogName, companyName, Actions.ReleaseBp, Convert.ToInt32((item.FindControl("CompanyID") as Label).Text), refName, actionHint, "ConfirmationEmail_CompanyReleasedBp", values.ToArray());
                        }

                        if (Convert.ToBoolean(Session["NoExit"]))
                        {
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

                    if (accessRelevantChanges)
                    {
                        if ((Session["CheckSubContractors"] != null && Convert.ToBoolean(Session["CheckSubContractors"])))
                        {
                            CheckBox cb = item.FindControl("LockSubContractors") as CheckBox;
                            if (cb != null)
                            {
                                Helpers.CompanyChanged(Convert.ToInt32((item.FindControl("CompanyID") as Label).Text), true);
                            }
                            Session["CheckSubContractors"] = false;
                        }
                        else
                        {
                            Helpers.CompanyChanged(Convert.ToInt32((item.FindControl("CompanyID") as Label).Text), false);
                        }
                    }
                }
            }
        }

        protected void RadTreeList1_PreRender(object sender, EventArgs e)
        {
            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }

            if (lastCompanyID != 0 && ((action == Actions.ReleaseBp && HasRight(rights, Actions.ReleaseBp)) ||
                                       (action == Actions.Edit && HasRight(rights, Actions.Edit))))
            {
                Helpers.GotoLastEditedTL(RadTreeList1, lastCompanyID, idName, true);
            }

            RadTreeList tl = sender as RadTreeList;
            TreeListColumn bc = tl.GetColumnSafe("ParentNameVisible");
            if (bc != null)
            {
                if (Convert.ToBoolean(Session["ShowCompanyTree"]))
                {
                    bc.Visible = false;
                }
                else
                {
                    bc.Visible = true;
                }
            }
        }

        protected void RadTreeList1_ItemCommand(object sender, TreeListCommandEventArgs e)
        {
            TreeListDataItem item = (e.Item as TreeListDataItem);
            HiddenField hf = null;
            if (item != null)
            {
                hf = item.FindControl("StatusID") as HiddenField;
            }
            int statusID = Status.Released;
            if (hf != null && !hf.Value.Equals(string.Empty))
            {
                statusID = Convert.ToInt32((hf).Value);
            }

            if (e.CommandName == RadTreeList.ExpandCollapseCommandName)
            {
                RadTreeList1.DataSource = GetCompaniesData();
                RadTreeList1.DataBind();
            }

            if (e.CommandName == "ItemClick")
            {
                TreeListDetailTemplateItem treeListDetailItem = item.DetailItem;
                if (!treeListDetailItem.Visible)
                {
                    Panel panel = (Panel)treeListDetailItem.FindControl("PanelDetail");

                    CompanyDetails uctl = (CompanyDetails)Page.LoadControl("~/Controls/CompanyDetails.ascx");
                    uctl.ID = "uctl1";
                    uctl.CompanyID = Convert.ToInt32(item.GetDataKeyValue(idName));
                    panel.Controls.Add(uctl);
                }
                treeListDetailItem.Visible = !treeListDetailItem.Visible;
                item.Selected = treeListDetailItem.Visible;
            }

            if (e.CommandName == "Edit")
            {
                if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
                {
                    e.Canceled = true;
                }
                else
                {
                    Helpers.ChangeEditFormCaptionTV(e, false, this.Header.Title);

                    item.Selected = true;
                }
            }

            if (e.CommandName == "InitInsert")
            {
                if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Create) || statusID != Status.Released)
                {
                    e.Canceled = true;
                }
                else
                {
                    Helpers.ChangeEditFormCaptionTV(e, true, this.Header.Title);

                    RadTreeList tl = (sender as RadTreeList);
                    foreach (TreeListDataItem tlItem in tl.Items)
                    {
                        tlItem.Selected = false;
                    }

                    int nextID = Helpers.GetNextID("CompanyID");
                    Session["NextCompanyID"] = nextID;
                    action = Actions.Create;
                }
            }

            if (e.CommandName == "CancelAll")
            {
                e.Item.OwnerTreeList.EditIndexes.Clear();
                e.Item.OwnerTreeList.InsertIndexes.Clear();
                e.Item.OwnerTreeList.Rebind();
            }

            if (e.CommandName == "Release" && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
            {
                int companyID = Convert.ToInt32(item.GetDataKeyValue("CompanyID"));
                if (Helpers.GetMainContractorStatus(companyID) == Status.Released)
                {
                    action = Actions.ReleaseBp;
                    item.Edit = true;
                    (sender as RadTreeList).Rebind();
                }
                else
                {
                    e.Canceled = true;
                }
            }

            if (e.CommandName == "ReleaseIt")
            {
                //string companyID = (e.CommandArgument as string);
                //ReleaseIt(companyID);
                TreeListEditFormItem item1 = e.Item as TreeListEditFormItem;
                Label label = item1.FindControl("ReleaseFrom") as Label;
                label.Text = Session["LoginName"].ToString();
                label = item1.FindControl("ReleaseOn") as Label;
                label.Text = DateTime.Now.ToString();

                label = item1.FindControl("LockedFrom") as Label;
                label.Text = "";
                label = item1.FindControl("LockedOn") as Label;
                label.Text = "";

                CheckBox cb = item1.FindControl("LockSubContractors") as CheckBox;
                cb.Checked = false;
                Session["CheckSubContractors"] = true;
            }

            if (e.CommandName == "Lock" && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Lock))
            {
                action = Actions.Lock;
                item.Edit = true;
                (sender as RadTreeList).Rebind();
            }

            if (e.CommandName == "LockIt")
            {
                //string companyID = (e.CommandArgument as string);
                //LockIt(companyID);
                TreeListEditFormItem item1 = e.Item as TreeListEditFormItem;
                Label label = item1.FindControl("LockedFrom") as Label;
                label.Text = Session["LoginName"].ToString();
                label = item1.FindControl("LockedOn") as Label;
                label.Text = DateTime.Now.ToString();

                Session["CheckSubContractors"] = true;
            }

            if (e.CommandName.Equals("GenerateCode"))
            {
                TreeListEditFormItem item1 = e.Item as TreeListEditFormItem;
                RadTextBox tb = (item1.FindControl("RegistrationCode") as RadTextBox);
                tb.Text = Helpers.GenerateCode(10, 0);
                RadDatePicker dp = (item1.FindControl("CodeValidUntil") as RadDatePicker);
                dp.SelectedDate = DateTime.Now.AddDays(7);
                //tb.Text = Helpers.GenerateCode(10, Convert.ToInt32(e.CommandArgument));
            }

            if (e.CommandName == "CustomItemsDropped" && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Move))
            {
                //TreeListDataItem origin = e.Item as TreeListDataItem;
                //string parentID = e.CommandArgument.ToString();

                //StringBuilder sql = new StringBuilder();
                //sql.Append("UPDATE Master_Companies ");
                //sql.Append("SET ParentID = @Destination, ");
                //sql.Append("EditFrom = @UserName, ");
                //sql.Append("EditOn = SYSDATETIME() ");
                //sql.Append("WHERE SystemID = @SystemID ");
                //sql.Append("AND BpID = @BpID ");
                //sql.Append("AND CompanyID = @CompanyID ");

                //SqlConnection con = new SqlConnection(ConnectionString);
                //SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                //SqlParameter par = new SqlParameter();

                //par = new SqlParameter("@Destination", SqlDbType.Int);
                //if (parentID.Equals(""))
                //{
                //    par.Value = 0;
                //}
                //else
                //{
                //    par.Value = Convert.ToInt32(parentID);
                //}
                //cmd.Parameters.Add(par);

                //par = new SqlParameter("@SystemID", SqlDbType.Int);
                //par.Value = Convert.ToInt32(Session["SystemID"]);
                //cmd.Parameters.Add(par);

                //par = new SqlParameter("@BpID", SqlDbType.Int);
                //par.Value = Convert.ToInt32(Session["BpID"]);
                //cmd.Parameters.Add(par);

                //par = new SqlParameter("@CompanyID", SqlDbType.Int);
                //par.Value = Convert.ToInt32(origin.GetDataKeyValue("CompanyID"));
                //cmd.Parameters.Add(par);

                //par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                //par.Value = Session["LoginName"].ToString();
                //cmd.Parameters.Add(par);

                //con.Open();
                //try
                //{
                //    cmd.ExecuteNonQuery();

                //    Helpers.DialogLogger(type, Actions.Edit, origin.GetDataKeyValue("CompanyID").ToString(), Resources.Resource.lblActionCreate);
                //    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");

                //    //RadTreeList1.Rebind();
                //    RadTreeList1.ExpandToLevel(4);
                //}
                //catch (SqlException ex)
                //{
                //    SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                //}
                //catch (System.Exception ex)
                //{
                //    SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                //}
                //finally
                //{
                //    con.Close();
                //}

                //// Message anzeigen
                //if (!string.IsNullOrEmpty(gridMessage))
                //{
                //    DisplayMessage(messageTitle, gridMessage, messageColor);
                //}
            }

            if (e.CommandName == "ShowDetails")
            {
                item.DetailItem.Visible = !item.DetailItem.Visible;
                item.Selected = item.DetailItem.Visible;
            }

            if (e.CommandName == "PerformInsert")
            {
                Session["NoExit"] = e.CommandArgument.Equals("NoExit");
            }

            if (e.CommandName == "Update")
            {
                Session["NoExit"] = e.CommandArgument.Equals("NoExit");
            }

            if (e.CommandName == "Delete")
            {
                if (Helpers.IsMaster())
                {
                    action = Actions.Delete;
                }
                else
                {
                    e.Canceled = true;
                }
            }
        }

        private void ReleaseIt(string companyID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE Master_Companies ");
            sql.Append("SET ReleaseFrom = @UserName, ");
            sql.Append("ReleaseOn = SYSDATETIME(), ");
            sql.Append("LockedFrom = '', ");
            sql.Append("LockedOn = NULL ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND CompanyID = @CompanyID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
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

                Helpers.DialogLogger(type, Actions.ReleaseBp, companyID.ToString(), Resources.Resource.lblActionReleaseBp);
                SetMessage(Resources.Resource.lblActionReleaseBp, Resources.Resource.msgReleaseOK, "green");
                RadTreeList1.Rebind();
            }
            catch (SqlException ex)
            {
                SetMessage(Resources.Resource.lblActionReleaseBp, String.Format(Resources.Resource.msgReleaseFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionReleaseBp, String.Format(Resources.Resource.msgReleaseFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }
        }

        private void LockIt(string companyID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("IF ((SELECT LockedOn ");
            sql.Append("FROM Master_Companies ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND CompanyID = @CompanyID) IS NULL) ");
            sql.AppendLine("SELECT @IsLocked = 0 ELSE SELECT @IsLocked = 1 ");
            sql.Append("IF (@IsLocked = 0) ");
            sql.Append("UPDATE Master_Companies ");
            sql.Append("SET LockedFrom = @UserName, ");
            sql.Append("LockedOn = SYSDATETIME() ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND CompanyID = @CompanyID ");
            sql.Append("ELSE ");
            sql.Append("UPDATE Master_Companies ");
            sql.Append("SET LockedFrom = '', ");
            sql.Append("LockedOn = NULL ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND CompanyID = @CompanyID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@IsLocked", SqlDbType.Bit);
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
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
                bool isLocked = Convert.ToBoolean(cmd.Parameters["@IsLocked"].Value);

                if (isLocked)
                {
                    Helpers.DialogLogger(type, Actions.Unlock, companyID.ToString(), Resources.Resource.lblActionUnlock);
                    SetMessage(Resources.Resource.lblActionUnlock, Resources.Resource.msgUnlockOK, "green");
                }
                else
                {
                    Helpers.DialogLogger(type, Actions.Lock, companyID.ToString(), Resources.Resource.lblActionLock);
                    SetMessage(Resources.Resource.lblActionLock, Resources.Resource.msgLockOK, "green");
                }
                RadTreeList1.Rebind();
            }
            catch (SqlException ex)
            {
                SetMessage(Resources.Resource.lblActionReleaseBp, String.Format(Resources.Resource.msgReleaseFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionReleaseBp, String.Format(Resources.Resource.msgReleaseFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadTreeList1_ItemDrop(object sender, TreeListItemDragDropEventArgs e)
        {

            HiddenField status = e.DraggedItems[0].FindControl("StatusID") as HiddenField;
            int statusID = 0;
            if (status != null)
            {
                statusID = Convert.ToInt32(status.Value);
            }

            if (statusID == Status.Released)
            {
                status = e.DestinationDataItem.FindControl("StatusID") as HiddenField;
                if (status != null)
                {
                    statusID = Convert.ToInt32(status.Value);
                }
                if (statusID == Status.Released)
                {
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Move))

                        ((RadWindowManager)this.Master.FindControl("RadWindowManager1")).RadConfirm(Resources.Resource.qstMoveRow, "confirmMoveCallBackFn", 300, 150, null, Resources.Resource.lblActionMove);
                    Session["ConfirmAction"] = "Move";

                    Session["Origin"] = e.DraggedItems[0];
                    Session["Destination"] = e.DestinationDataItem;
                    Session["Master"] = this.Master;
                }
                else
                {
                    e.Canceled = true;
                    Helpers.Notification(this.Master, Resources.Resource.lblCompany, Resources.Resource.msgNoMoveIfNotReleasedParent);
                }
            }
            else
            {
                e.Canceled = true;
                Helpers.Notification(this.Master, Resources.Resource.lblCompany, Resources.Resource.msgNoEditIfNotReleased);
            }
        }

        [WebMethod]
        public static void CompleteMoveTask(bool? userResponse)
        {
            //null will be received if the user closes the dialog via the [X] button
            if (userResponse == true)
            {
                if (HttpContext.Current.Session["ConfirmAction"].ToString() == "Move")
                {
                    TreeListDataItem origin = (TreeListDataItem)HttpContext.Current.Session["Origin"];

                    HiddenField status = origin.FindControl("StatusID") as HiddenField;
                    int statusID = 0;
                    if (status != null)
                    {
                        statusID = Convert.ToInt32(status.Value);
                    }

                    if (statusID == Status.Released)
                    {
                        TreeListDataItem destination = (TreeListDataItem)HttpContext.Current.Session["Destination"];

                        StringBuilder sql = new StringBuilder();
                        sql.Append("UPDATE Master_Companies ");
                        sql.Append("SET ParentID = @Destination, ");
                        sql.Append("EditFrom = @UserName, ");
                        sql.Append("EditOn = SYSDATETIME() ");
                        sql.Append("WHERE SystemID = @SystemID ");
                        sql.Append("AND BpID = @BpID ");
                        sql.Append("AND CompanyID = @CompanyID ");

                        SqlConnection con = new SqlConnection(ConnectionString);
                        SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                        SqlParameter par = new SqlParameter();

                        par = new SqlParameter("@Destination", SqlDbType.Int);
                        if (destination == null)
                        {
                            par.Value = 0;
                        }
                        else
                        {
                            par.Value = Convert.ToInt32(destination.GetDataKeyValue("CompanyID"));
                        }
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@SystemID", SqlDbType.Int);
                        par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@BpID", SqlDbType.Int);
                        par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@CompanyID", SqlDbType.Int);
                        par.Value = Convert.ToInt32(origin.GetDataKeyValue("CompanyID"));
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                        par.Value = HttpContext.Current.Session["LoginName"].ToString();
                        cmd.Parameters.Add(par);

                        con.Open();
                        try
                        {
                            cmd.ExecuteNonQuery();

                            Helpers.DialogLogger(type, Actions.Move, origin.GetDataKeyValue("CompanyID").ToString(), Resources.Resource.lblActionMove);
                            // SetMessage(Resources.Resource.lblActionMove, Resources.Resource.msgMoveOK, "green");
                            // RadTreeList1.Rebind();
                            // RadTreeList1.ExpandToLevel(4);
                        }
                        catch (SqlException ex)
                        {
                            // SetMessage(Resources.Resource.lblActionMove, String.Format(Resources.Resource.msgMoveFailed, ex.Message), "red");
                        }
                        catch (System.Exception ex)
                        {
                            // SetMessage(Resources.Resource.lblActionMove, String.Format(Resources.Resource.msgMoveFailed, ex.Message), "red");
                        }
                        finally
                        {
                            con.Close();
                        }
                        // Message anzeigen
                        //if (!string.IsNullOrEmpty(gridMessage))
                        // {
                        //     DisplayMessage(messageTitle, gridMessage, messageColor);
                        // }
                    }
                    else
                    {
                        Helpers.Notification((HttpContext.Current.Handler as Page).Master, Resources.Resource.lblCompany, Resources.Resource.msgNoEditIfNotReleased);
                    }
                }
            }
            else
            {
                //Cancel or the [x] button were pressed
                // throw new Exception((HttpContext.Current.Handler as Page).Session["ConfirmAction"].ToString());
            }
        }

        protected void RadTreeList1_ItemDeleted(object sender, TreeListDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                Helpers.DialogLogger(type, Actions.Delete, (e.Item as TreeListDataItem).GetDataKeyValue("CompanyID").ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        protected void RadTreeList1_ItemInserted(object sender, TreeListInsertedEventArgs e)
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

        protected void RadTreeList1_ItemUpdated(object sender, TreeListUpdatedEventArgs e)
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
                string idValue = "";
                if (e.Item.GetType() == typeof(TreeListDataItem) && ((TreeListDataItem)e.Item).FindControl("CompanyID") != null)
                {
                    idValue = (((TreeListDataItem)e.Item).FindControl("CompanyID") as HiddenField).Value;
                }
                else if (e.Item.GetType() == typeof(TreeListEditFormItem))
                {
                    idValue = ((e.Item as TreeListEditFormItem).FindControl("CompanyID") as Label).Text;
                }
                Helpers.DialogLogger(type, Actions.Edit, idValue, Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
            }
        }

        protected void RadTreeList1_ItemDataBound(object sender, TreeListItemDataBoundEventArgs e)
        {
            // Feldsteuerung
            if (e.Item is TreeListEditFormItem)
            {
                if (e.Item is TreeListEditFormInsertItem)
                {
                    // Insert
                    FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Create, e, false);
                }
                else
                {
                    if (action == Actions.ReleaseBp)
                    {
                        // Release
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.ReleaseBp, e, false);
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

            TreeListDataItem item = e.Item as TreeListDataItem;

            if (item != null)
            {
                // Status Button aktualisieren
                ImageButton button = e.Item.FindControl("ReleaseButton") as ImageButton;
                button.Visible = true;
                button.Enabled = false;

                int statusID = Convert.ToInt32((item.DataItem as DataRowView)["StatusID"]);
                button.ToolTip = Status.GetStatusString(statusID);

                if (statusID == Status.Locked)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Red-X.png";
                    button.CommandName = "Release";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.Released)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/release.png";
                    button.CommandName = "Lock";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Lock))
                    {
                        button.Enabled = true;
                    }
                }
                else
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/request.png";
                    button.CommandName = "Release";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                    {
                        button.Enabled = true;
                    }
                }
                button.CommandArgument = item.GetDataKeyValue("CompanyID").ToString();

                // Sperr Button aktualisieren
                button = e.Item.FindControl("LockedButton") as ImageButton;
                Webservices webservice = new Webservices();
                GetLockedMainContractor_Result[] lockedMainContractors = webservice.GetLockedMainContractor(Convert.ToInt32(item.GetDataKeyValue("CompanyID")));
                int lockedCount = lockedMainContractors.Count();
                bool lockSubContractors = Convert.ToBoolean((item.DataItem as DataRowView)["LockSubContractors"]);

                if (lockedCount > 0)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Locked_AG.png";
                    button.CommandName = "";
                    button.Enabled = false;
                    button.Visible = true;
                    button.ToolTip = Resources.Resource.statLockedByMainContractor;
                }
                else if (lockSubContractors && statusID == Status.Locked)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Locked_NU.png";
                    button.CommandName = "";
                    button.Enabled = false;
                    button.Visible = true;
                    button.ToolTip = Resources.Resource.statLockedIncludingSubContractors;
                }
                else
                {
                    button.Visible = false;
                }
            }

            if (e.Item is TreeListDataItem)
            {
                TreeListDataItem dataItem = (TreeListDataItem)e.Item;

                // Hinzufügen und Bearbeiten erlaubt?
                dataItem["EditCommandColumn"].Controls[0].Visible = HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Create);
                dataItem["EditCommandColumn"].Controls[2].Visible = HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit);

                if (companyID != 0 && Convert.ToInt32(dataItem.GetDataKeyValue("CompanyID")) == companyID)
                {
                    dataItem.Selected = true;
                }
            }

            if (e.Item is TreeListEditFormItem)
            {
                TreeListEditFormItem editFormItem = (TreeListEditFormItem)e.Item;
                RadButton button = (editFormItem.FindControl("ReleaseIt") as RadButton);
                if (action == Actions.ReleaseBp && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                {
                    button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }

                button = (editFormItem.FindControl("LockIt") as RadButton);
                if (action == Actions.Lock && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Lock))
                {
                    button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }

                if (action == Actions.Lock || action == Actions.ReleaseBp)
                {
                    RadTabStrip ts = editFormItem.FindControl("RadTabStrip1") as RadTabStrip;
                    ts.Tabs[0].Selected = false;
                    ts.Tabs[2].Selected = true;
                    ts.Tabs[2].PageView.Selected = true;
                }
            }

            if (e.Item is TreeListEditFormInsertItem)
            {
                TreeListEditFormInsertItem insertItem = e.Item as TreeListEditFormInsertItem;

                RadComboBox ddl = (RadComboBox)insertItem.FindControl("CountryID");
                if (ddl != null)
                {
                    RadComboBoxItem rcbi = ddl.FindItemByValue(Session["LanguageID"].ToString().Substring(0));
                    if (rcbi != null)
                    {
                        rcbi.Selected = true;
                    }
                }

                Label labelCompanyID = insertItem.FindControl("CompanyID") as Label;
                labelCompanyID.Text = Session["NextCompanyID"].ToString();
                HiddenField hf = insertItem.FindControl("CompanyID3") as HiddenField;
                hf.Value = Session["NextCompanyID"].ToString();

                Webservices webservice = new Webservices();
                Master_BuildingProjects bp = webservice.GetBpInfo(Convert.ToInt32(Session["BpID"]));
                if (bp != null)
                {
                    CheckBox cb = insertItem.FindControl("MinWageAttestation") as CheckBox;
                    if (cb != null)
                    {
                        cb.Checked = bp.MWCheck;
                    }
                }
            }

            if (e.Item is TreeListEditFormItem && !(e.Item is TreeListEditFormInsertItem))
            {
                TreeListEditFormItem editFormItem = e.Item as TreeListEditFormItem;

                CheckBox cb = editFormItem.FindControl("IsPartner") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["IsPartner"]);
                }

                cb = editFormItem.FindControl("BlnSOKA") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["BlnSOKA"]);
                }

                cb = editFormItem.FindControl("MinWageAttestation") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["MinWageAttestation"]);
                }

                cb = editFormItem.FindControl("AllowSubcontractorEdit") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["AllowSubcontractorEdit"]);
                }

                cb = editFormItem.FindControl("UserBit1") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["UserBit1"]);
                }

                cb = editFormItem.FindControl("UserBit2") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["UserBit2"]);
                }

                cb = editFormItem.FindControl("UserBit3") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["UserBit3"]);
                }

                cb = editFormItem.FindControl("UserBit4") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = Convert.ToBoolean((editFormItem.DataItem as DataRowView)["UserBit4"]);
                }
            }

            if (e.Item is TreeListEditFormItem)
            {
                TreeListEditFormItem editFormItem = e.Item as TreeListEditFormItem;

                Webservices webservice = new Webservices();
                if ((editFormItem.DataItem as DataRowView) != null)
                {
                    GetCompanyStatistics_Result result = webservice.GetCompanyStatistics(Convert.ToInt32((editFormItem.DataItem as DataRowView)["CompanyID"]));

                    Label label = editFormItem.FindControl("SubcontratorDirect") as Label;
                    if (label != null)
                    {
                        label.Text = result.SubContractorsDirect.ToString();
                    }

                    label = editFormItem.FindControl("SubcontractorTotal") as Label;
                    if (label != null)
                    {
                        label.Text = result.SubContractorsTotal.ToString();
                    }

                    label = editFormItem.FindControl("EmployeesDirect") as Label;
                    if (label != null)
                    {
                        label.Text = result.EmployeesSelf.ToString();
                    }

                    label = editFormItem.FindControl("EmployeesTotal") as Label;
                    if (label != null)
                    {
                        label.Text = result.EmployeesTotal.ToString();
                    }
                }
            }

            if (e.Item is TreeListEditFormInsertItem)
            {
                TreeListEditFormItem editableItem = (TreeListEditFormItem)e.Item;
                if (editableItem.ParentItem != null)
                {
                    string parentID = editableItem.ParentItem.GetDataKeyValue("CompanyID").ToString();
                    RadDropDownTree rddt = (editableItem.FindControl("ParentID") as RadDropDownTree);
                    if (rddt != null)
                    {
                        rddt.SelectedValue = parentID;
                    }
                }
            }

            // Aufruf durch Vorgangsverwaltung
            if (item != null && companyID != 0 && e.Item != null && action == Actions.ReleaseBp)
            {
                //int currentID = Convert.ToInt32(item.GetDataKeyValue("CompanyID"));
                //if (currentID == companyID)
                //{
                //    Helpers.SetAction(Actions.ReleaseBp);
                //    item.Edit = true;
                //}
            }
        }

        public bool Hide(Control c)
        {
            c.Visible = false;
            return true;
        }

        protected void RadFilter1_ApplyExpressions(object sender, RadFilterApplyExpressionsEventArgs e)
        {
            RadFilterSqlQueryProvider provider = new RadFilterSqlQueryProvider();
            provider.ProcessGroup(e.ExpressionRoot);
            FilterExpression = provider.Result;
            RadTreeList1.Rebind();
        }

        private string FilterExpression
        {
            get
            {
                return ViewState["FilterExpression"] != null ? ViewState["FilterExpression"].ToString() : string.Empty;
            }
            set
            {
                ViewState["FilterExpression"] = value;
            }
        }

        protected void RadTreeList1_ItemCreated(object sender, TreeListItemCreatedEventArgs e)
        {
            // Feldsteuerung
            if (e.Item is TreeListEditFormItem)
            {
                if (e.Item is TreeListEditFormInsertItem)
                {
                    // Insert
                    FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Create, e, true);
                }
                else
                {
                    if (action == Actions.ReleaseBp)
                    {
                        // Release
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.ReleaseBp, e, true);
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

            if (e.Item is TreeListEditableItem)
            {
                if (e.Item is TreeListEditFormInsertItem)
                {
                    //RadTabStrip tabStrip = (RadTabStrip)e.Item.FindControl("RadTabStrip1");
                    //tabStrip.Tabs[2].Visible = false;
                    //tabStrip.Tabs[3].Visible = false;
                    //tabStrip.Tabs[4].Visible = false;
                    CheckBox cb = (CheckBox)e.Item.FindControl("IsPartner");
                    if (cb != null)
                    {
                        cb.Checked = false;
                    }
                    cb = (CheckBox)e.Item.FindControl("BlnSOKA");
                    if (cb != null)
                    {
                        cb.Checked = true;
                    }
                    cb = (CheckBox)e.Item.FindControl("MinWageAttestation");
                    if (cb != null)
                    {
                        cb.Checked = true;
                    }
                }
            }

            if (e.Item is TreeListPagerItem)
            {
                TreeListPagerItem pagerItem = e.Item as TreeListPagerItem;

                if (pagerItem != null)
                {
                    RadComboBox combo = e.Item.FindControl("PageSizeComboBox") as RadComboBox;
                    if (combo != null)
                    {
                        combo.Items.Clear();
                        IList<int> defaultPageSizes = new List<int>();
                        defaultPageSizes.Add(15);
                        defaultPageSizes.Add(25);
                        defaultPageSizes.Add(50);
                        defaultPageSizes.Add(100);
                        foreach (int size in defaultPageSizes)
                        {
                            RadComboBoxItem item = new RadComboBoxItem(size.ToString(), size.ToString());
                            combo.Items.Add(item);
                        }
                        RadComboBoxItem comboBoxItem = combo.Items.FindItemByValue(pagerItem.OwnerTreeList.PageSize.ToString());
                        if (comboBoxItem != null)
                        {
                            comboBoxItem.Selected = true;
                        }
                    }
                }
            }
        }

        protected void StartSearch_Click(object sender, EventArgs e)
        {
            RadTreeList1.ExpandAllItems();
            Session["ShowCompanyTree"] = false;
            RadTreeList1.ShowTreeLines = false;
            RadTreeList1.DataSource = GetCompaniesData();
            RadTreeList1.DataBind();
            SwitchToTree.Checked = false;
            SwitchToList.Checked = true;
        }

        protected void ResetSearch_Click(object sender, EventArgs e)
        {
            SearchText.Text = "";
            Session["ShowCompanyTree"] = true;
            RadTreeList1.ShowTreeLines = true;
            RadTreeList1.DataSource = GetCompaniesData();
            RadTreeList1.DataBind();
            SwitchToTree.Checked = true;
            SwitchToList.Checked = false;
        }

        private DataTable GetCompaniesData()
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("GetCompaniesData", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyCentralID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["CompanyID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            if (Session["LastEdited"] != null && Convert.ToBoolean(Session["LastEdited"]))
            {
                par.Value = lastCompanyID;
            }
            else
            {
                par.Value = 0;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@ShowList", SqlDbType.Int);
            if (Convert.ToBoolean(Session["ShowCompanyTree"]))
            {
                par.Value = 0;
            }
            else
            {
                par.Value = 1;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@SearchText", SqlDbType.NVarChar, 50);
            String searchText = "";
            if (!SearchText.Text.Equals(String.Empty))
            {
                searchText = String.Concat("%", SearchText.Text, "%");
            }
            par.Value = searchText;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            int userID = Convert.ToInt32(Session["UserID"]);
            par.Value = userID;
            cmd.Parameters.Add(par);

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

        protected void RadTreeList1_NeedDataSource(object sender, TreeListNeedDataSourceEventArgs e)
        {
            RadTreeList1.DataSource = GetCompaniesData();
        }

        protected void ToolBar1_ButtonClick(object sender, RadToolBarEventArgs e)
        {
            RadToolBarButton btn = e.Item as RadToolBarButton;
            int level = Convert.ToInt16(btn.Value);
            if (level == 99)
            {
                RadTreeList1.ExpandAllItems();
            }
            else
            {
                RadTreeList1.CollapseAllItems();
                RadTreeList1.ExpandToLevel(level);
            }
            RadTreeList1.Rebind();
        }

        protected void RadGridContacts_ItemInserted(object sender, GridInsertedEventArgs e)
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
                e.KeepInInsertMode = false;
            }
        }

        protected void RadGridContacts_PreRender(object sender, EventArgs e)
        {
            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        protected void RadGridContacts_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue("ContactID").ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        protected void RadGridContacts_ItemUpdated(object sender, GridUpdatedEventArgs e)
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
                Helpers.DialogLogger(type, Actions.Edit, (e.Item as GridEditFormItem).GetDataKeyValue("ContactID").ToString(), Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                e.KeepInEditMode = false;
            }
        }

        protected void RadGridContacts_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblContact);

            // RowClick abhandeln
            if (e.CommandName == "RowClick")
            {
                GridDataItem item = ((RadGrid)sender).MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);
                item.Expanded = !item.Expanded;
            }

            if (e.CommandName == "Edit")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvancedNoExit") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvanced") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelAdvanced") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = false;
            }

            if (e.CommandName == "InitInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvancedNoExit") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvanced") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelAdvanced") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = false;
            }

            if (e.CommandName == "Cancel")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvancedNoExit") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvanced") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelAdvanced") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
            }

            if (e.CommandName == "Update")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvancedNoExit") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvanced") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelAdvanced") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
            }

            if (e.CommandName == "PerformInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvancedNoExit") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAdvanced") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelAdvanced") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
            }
        }

        protected void AvailableAttributes_Transferred(object sender, RadListBoxTransferredEventArgs e)
        {
            if (e.Items.Count > 0)
            {
                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand("MoveCompanyAttribute", con);
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
                par.Value = Convert.ToInt32((e.SourceListBox.Parent.FindControl("CompanyID") as Label).Text);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AttributeID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@User", SqlDbType.NVarChar, 50);
                par.Direction = ParameterDirection.Input;
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                foreach (RadListBoxItem item in e.Items)
                {
                    cmd.Parameters["@AttributeID"].Value = item.Value;

                    con.Open();
                    try
                    {
                        logger.InfoFormat("Try to execute {0}", cmd.CommandText);
                        cmd.ExecuteNonQuery();
                    }
                    catch (SqlException ex)
                    {
                        logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                        throw;
                    }
                    catch (System.Exception ex)
                    {
                        logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                        throw;
                    }
                    finally
                    {
                        con.Close();
                    }
                }
            }
        }

        protected void ValidatorRadGridContacts_ServerValidate(object source, ServerValidateEventArgs args)
        {
            RadGrid rg = (RadGrid)(((TreeListEditFormItem)((CustomValidator)source).NamingContainer)).FindControl("RadGridContacts");
            if (rg != null)
            {
                if (!rg.MasterTableView.IsItemInserted && rg.MasterTableView.Items.Count == 0)
                {
                    args.IsValid = false;
                }
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

        protected void ValidatorAssignedTrades_ServerValidate(object source, ServerValidateEventArgs args)
        {
            RadListBox lb = (RadListBox)(((TreeListEditFormItem)((CustomValidator)source).NamingContainer)).FindControl("AssignedTrades");
            if (lb != null)
            {
                if (lb.Items.Count == 0)
                {
                    args.IsValid = false;
                }
            }
        }

        protected void ValidatorAssignedAttributes_ServerValidate(object source, ServerValidateEventArgs args)
        {
            RadListBox lb = (RadListBox)(((TreeListEditFormItem)((CustomValidator)source).NamingContainer)).FindControl("AssignedAttributes");
            if (lb != null)
            {
                if (lb.Items.Count == 0)
                {
                    args.IsValid = false;
                }
            }
        }

        protected void SwitchToTree_CheckedChanged(object sender, EventArgs e)
        {
            Session["ShowCompanyTree"] = (sender as RadButton).Checked;
            RadTreeList1.ShowTreeLines = (sender as RadButton).Checked;
            RadTreeList1.Rebind();
        }

        protected void RadGridContacts_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGridTariffs_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
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

        private DataTable GetTariffScopes(int tariffContractID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT NameVisible, DescriptionShort, TariffScopeID FROM System_TariffScopes AS s_ts ");
            sql.Append("WHERE (SystemID = @SystemID) ");
            sql.Append("AND (TariffContractID = @TariffContractID) ");
            sql.Append("ORDER BY NameVisible");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@TariffContractID", SqlDbType.Int);
            par.Value = tariffContractID;
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

        protected void RadGridTariffs_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editFormItem = (GridEditFormItem)e.Item;
                RadDropDownList rddl = editFormItem.FindControl("TariffScopeID") as RadDropDownList;
                if (rddl != null)
                {
                    int tariffContractID = Convert.ToInt32((editFormItem.DataItem as DataRowView)["TariffContractID"]);
                    rddl.DataSource = GetTariffScopes(tariffContractID);
                    rddl.DataBind();
                    int tariffScopeID = Convert.ToInt32((editFormItem.DataItem as DataRowView)["TariffScopeID"]);
                    Session["Original_TariffScopeID"] = tariffScopeID;
                    DropDownListItem ddli = rddl.FindItemByValue(tariffScopeID.ToString());
                    if (ddli != null)
                    {
                        ddli.Selected = true;
                    }
                }
            }
        }

        protected void RadGridTariffs_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormItem item = e.Item as GridEditFormItem;

            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE [Master_CompanyTariffs] ");
            sql.Append("SET [TariffScopeID] = @TariffScopeID, [EditFrom] = @UserName, [EditOn] = SYSDATETIME() ");
            sql.Append("WHERE [SystemID] = @SystemID ");
            sql.Append("AND [BpID] = @BpID ");
            sql.Append("AND [CompanyID] = @CompanyID ");
            sql.Append("AND [TariffScopeID] = @original_TariffScopeID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@TariffScopeID", SqlDbType.Int);
            int tariffScopeID = Convert.ToInt32((item.FindControl("TariffScopeID") as RadDropDownList).SelectedValue);
            par.Value = tariffScopeID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = Session["LoginName"].ToString();
            cmd.Parameters.Add(par);

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            int companyID = Convert.ToInt32((item.FindControl("CompanyID") as HiddenField).Value);
            par.Value = companyID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@original_TariffScopeID", SqlDbType.Int);
            tariffScopeID = Convert.ToInt32(Session["Original_TariffScopeID"]);
            par.Value = tariffScopeID;
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
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
        }

        protected void SelectLevel_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            int level = Convert.ToInt16(e.Value);
            if (level == 99)
            {
                RadTreeList1.ExpandAllItems();
            }
            else
            {
                RadTreeList1.CollapseAllItems();
                RadTreeList1.ExpandToLevel(level);
            }
            // RadTreeList1.Rebind();
        }

        protected void RadGridContacts_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item is GridEditFormInsertItem)
            {
                HiddenField hf = ((sender as RadGrid).NamingContainer as TreeListEditableItem).FindControl("CompanyCentralID1") as HiddenField;
                if (hf != null && !hf.Value.Equals(string.Empty))
                {
                    Master_Users user = Helpers.GetCompanyAdmin(Convert.ToInt32(hf.Value));
                    if (user != null)
                    {
                        GridEditableItem item = e.Item as GridEditableItem;
                        RadTextBox tb = item.FindControl("LastName") as RadTextBox;
                        if (tb != null)
                        {
                            tb.Text = user.LastName;
                        }
                        tb = item.FindControl("FirstName") as RadTextBox;
                        if (tb != null)
                        {
                            tb.Text = user.FirstName;
                        }
                        tb = item.FindControl("Email") as RadTextBox;
                        if (tb != null)
                        {
                            tb.Text = user.Email;
                        }
                        tb = item.FindControl("Phone") as RadTextBox;
                        if (tb != null)
                        {
                            tb.Text = user.Phone;
                        }
                    }
                }
            }
        }

        protected void btnExportExcel_Click(object sender, EventArgs e)
        {
            //RadTreeList1.ExportSettings.IgnorePaging = true;
            //RadTreeList1.ExportSettings.OpenInNewWindow = true;
            //RadTreeList1.ExportSettings.ExportMode = TreeListExportMode.ReplaceControls;
            //RadTreeList1.Rebind();
            //RadTreeList1.ExportSettings.Excel.Format = TreeListExcelFormat.Xlsx;
            //RadTreeList1.ExportToExcel();
            DataTable dt = GetCompaniesData();
            if (dt == null || dt.Rows.Count == 0)
            {
                Helpers.Notification(this.Page.Master, Resources.Resource.lblCompaniesBP, Resources.Resource.msgNoDataFound);
            }
            else
            {
                ExcelPackage pck = new ExcelPackage();

                pck.Workbook.Properties.Title = Resources.Resource.lblMinWageReportCompany;
                pck.Workbook.Properties.Author = Session["LoginName"].ToString();
                if (Session["CompanyID"] != null && Convert.ToInt32(Session["CompanyID"]) > 0)
                {
                    pck.Workbook.Properties.Company = Helpers.GetCompanyName(Convert.ToInt32(Session["CompanyID"]));
                }
                pck.Workbook.Properties.Manager = Resources.Resource.appName;

                // Kopfdaten
                ExcelWorksheet ws = pck.Workbook.Worksheets.Add(Resources.Resource.lblParameters);

                ws.Cells[1, 1].Value = Resources.Resource.lblCompaniesBP;
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
                ws.Cells[1, 1].Value = Resources.Resource.lblID;
                ws.Cells[1, 2].Value = Resources.Resource.lblNameVisible;
                ws.Cells[1, 3].Value = Resources.Resource.lblNameAdditional;
                ws.Cells[1, 4].Value = Resources.Resource.lblAddress1;
                ws.Cells[1, 5].Value = Resources.Resource.lblAddrCity;
                ws.Cells[1, 6].Value = Resources.Resource.lblCountry;
                ws.Cells[1, 7].Value = Resources.Resource.lblEditOn;
                ws.Cells[1, 8].Value = Resources.Resource.lblClient;

                // Daten
                int rowNum = 1;
                foreach (DataRow row in dt.Rows)
                {
                    rowNum++;

                    ws.Cells[rowNum, 1].Value = row["CompanyID"].ToString();
                    ws.Cells[rowNum, 2].Value = row["NameVisible"].ToString();
                    ws.Cells[rowNum, 3].Value = row["NameAdditional"].ToString();
                    ws.Cells[rowNum, 4].Value = row["Address1"].ToString();
                    ws.Cells[rowNum, 5].Value = row["City"].ToString();
                    ws.Cells[rowNum, 6].Value = row["CountryName"].ToString();
                    ws.Cells[rowNum, 7].Value = Convert.ToDateTime(row["EditOn"]).ToString("dd.MM.yyyy HH:mm");
                    ws.Cells[rowNum, 8].Value = row["ParentNameVisible"].ToString();
                }

                // Autofilter und autofit
                ExcelRange dataCells = ws.Cells[1, 1, rowNum + 1, 8];
                dataCells.AutoFilter = true;
                dataCells.AutoFitColumns();

                // Kopfzeile fett und fixiert
                ExcelRange headLine = ws.Cells[1, 1, 1, 8];
                headLine.Style.Font.Bold = true;
                ws.View.FreezePanes(2, 1);

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
                Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblCompaniesBP + "_" + fileDate + "." + suffix));
                Response.BinaryWrite(fileData);
                Response.End();
            }
        }

        protected void RadTreeList1_PageIndexChanged(object source, Telerik.Web.UI.TreeListPageChangedEventArgs e)
        {
            //RadTreeList1.CurrentPageIndex = e.NewPageIndex;
            //RadTreeList1.DataSource = GetCompaniesData();
            //RadTreeList1.DataBind();
        }

        protected void RadTreeList1_PageSizeChanged(object source, Telerik.Web.UI.TreeListPageSizeChangedEventArgs e)
        {
      //      RadTreeList1.DataSource = GetCompaniesData();
      //      RadTreeList1.DataBind();
        }
    }
}