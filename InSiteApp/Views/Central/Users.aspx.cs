using InSite.App.Constants;
using InSite.App.Controls;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Central
{
    public partial class Users : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "UserID";
        private int action = Actions.View;

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        String msg = "";
        int lastID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            msg = Request.QueryString["UserID"];
            if (msg != null)
            {
                lastID = Convert.ToInt32(msg);
            }

            // Parameterabfrage für Vorgangsverwaltung
            msg = Request.QueryString["ID"];
            if (msg != null)
            {
                lastID = Convert.ToInt32(msg);
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

            GridColumn item1 = (sender as RadGrid).MasterTableView.Columns.FindByUniqueName("LastName");
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

        // RowClick abhandeln
        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            GridDataItem item = e.Item as GridDataItem;
            if (e.CommandName == "RowClick")
            {
                item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);
                item.Expanded = !item.Expanded;
            }

            if (e.CommandName == "Release")
            {
                action = Actions.Release;
                item.Edit = true;
                (sender as RadGrid).Rebind();
            }

            if (e.CommandName == "ReleaseIt")
            {
                RadTextBox tb = item.EditFormItem.FindControl("ReleaseOn") as RadTextBox;
                tb.Text = DateTime.Now.ToString();
                tb = item.EditFormItem.FindControl("ReleaseFrom") as RadTextBox;
                tb.Text = Session["LoginName"].ToString();

                tb = item.EditFormItem.FindControl("LockedFrom") as RadTextBox;
                tb.Text = "";
                tb = item.EditFormItem.FindControl("LockedOn") as RadTextBox;
                tb.Text = "";

                Session["ReleaseMessage"] = true;
            }

            if (e.CommandName == "Lock")
            {
                action = Actions.Lock;
                item.Edit = true;
                (sender as RadGrid).Rebind();
            }

            if (e.CommandName == "LockIt")
            {
                RadTextBox tb = item.EditFormItem.FindControl("LockedFrom") as RadTextBox;
                tb.Text = Session["LoginName"].ToString();
                tb = item.EditFormItem.FindControl("LockedOn") as RadTextBox;
                tb.Text = DateTime.Now.ToString();
            }

            if (e.CommandName == "Cancel")
            {
                lastID = -1;

                action = Actions.View;
            }

            if (e.CommandName == "Edit")
            {
                int statusID = Convert.ToInt32((item.FindControl("StatusID") as HiddenField).Value);
                int companyStatusID = Status.Released;
                if (!(item.FindControl("CompanyStatusID") as HiddenField).Value.Equals(string.Empty))
                {
                    companyStatusID = Convert.ToInt32((item.FindControl("CompanyStatusID") as HiddenField).Value);
                }
                if (statusID != Status.CreatedNotConfirmed && companyStatusID == Status.Released)
                {
                    action = Actions.Edit;
                }
                else
                {
                    e.Canceled = true;
                }

                Label userID = item.FindControl("UserID") as Label;
                if (userID != null)
                {
                    Session["SelectedUserID"] = userID.Text;
                }

                Label companyID = item.FindControl("CompanyID") as Label;
                if (companyID != null)
                {
                    Session["SelectedCompanyID"] = companyID.Text;
                }
            }

            if (e.CommandName == "InitInsert")
            {
                int nextID = Helpers.GetNextID("UserID");
                Session["NextUserID"] = nextID;
                Session["SelectedUserID"] = nextID;
                Session["SelectedCompanyID"] = 0;
                action = Actions.Create;
            }

            if (e.CommandName.Equals("AlphaFilter"))
            {
                Session["AlphaFilter"] = e.CommandArgument;
                RadGrid1.Rebind();
            }

            if (e.CommandName == RadGrid.ExportToExcelCommandName || e.CommandName == RadGrid.ExportToCsvCommandName || e.CommandName == RadGrid.ExportToPdfCommandName)
            {
                RadGrid1.ShowGroupPanel = false;
                RadGrid1.Rebind();
            }
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                string userID1 = (e.Item.FindControl("UserID") as Label).Text;
                string cmd = "function(sender, args) {openRadWindow(sender, args, '" + userID1 + "'); return false;}";
                (e.Item.FindControl("btnChangePwd") as RadButton).OnClientClicked = cmd;
                //GridEditableItem editItem = (GridEditableItem)e.Item;
                //RadTextBox tb = (RadTextBox)editItem["LoginName"].Controls[1];
                //tb.Attributes.Add("autocomplete", "off");
            }

            if (!(e.Item is GridEditFormInsertItem) && e.Item.IsInEditMode)
            {
                if (Helpers.IsSysAdmin())
                {
                    (e.Item.FindControl("ResetPwd") as RadButton).Visible = true;
                }
            }

            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                //Control target = e.Item.FindControl("targetControl");
                //if (!Object.Equals(target, null))
                //{
                //    if (!Object.Equals(this.RadToolTipManager1, null))
                //    {
                //        //Add the button (target) id to the tooltip manager              
                //        this.RadToolTipManager1.TargetControls.Add(target.ClientID, (e.Item as GridDataItem).GetDataKeyValue("UserID").ToString(), true);
                //    }
                //}
            }

            GridDataItem item = e.Item as GridDataItem;
            if (item != null)
            {
                ImageButton button = e.Item.FindControl("ReleaseButton") as ImageButton;
                button.Visible = true;
                button.Enabled = false;

                int statusID = Convert.ToInt32(((DataRowView)e.Item.DataItem)["StatusID"]);
                int companyStatusID = Status.Released;
                if (!(item.FindControl("CompanyStatusID") as HiddenField).Value.Equals(string.Empty))
                {
                    companyStatusID = Convert.ToInt32((item.FindControl("CompanyStatusID") as HiddenField).Value);
                }
                button.ToolTip = Status.GetStatusString(statusID);

                if (statusID == Status.Locked)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Red-X.png";
                    button.CommandName = "Release";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release) && companyStatusID == Status.Released)
                    {
                        button.Enabled = true;
                    }
                }
                else if (companyStatusID == Status.WaitRelease)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/requestCC.png";
                    button.CommandName = "";
                    button.Enabled = false;
                    button.ToolTip = Resources.Resource.msgAssignedCompanyWaitsForRelease;
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
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release) && companyStatusID == Status.Released)
                    {
                        button.Enabled = true;
                        button.CommandArgument = item.GetDataKeyValue("UserID").ToString();
                    }
                }

                if (lastID != 0 && Convert.ToInt32(item.GetDataKeyValue("UserID")) == lastID)
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
                if (action == Actions.Lock)
                {
                    button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }
            }

            if (e.Item is GridEditFormInsertItem)
            {
                GridEditableItem editableItem = (GridEditableItem)e.Item;
                Label userID = editableItem.FindControl("UserID") as Label;
                userID.Text = Session["NextUserID"].ToString();
            }

            if (e.Item is GridDataItem)
            {
                int statusID = Convert.ToInt32(((DataRowView)e.Item.DataItem)["StatusID"]);
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100) || statusID == Status.WaitRelease || statusID == Status.CreatedNotConfirmed;
                (item["deleteColumn"].Controls[0] as ImageButton).Visible = deleteColumnVisible;
            }
            // Aufruf durch Vorgangsverwaltung
            //if (e.Item is GridDataItem && lastID != 0 && e.Item.DataItem != null && action == Actions.Release)
            //{
            //    int currentID = Convert.ToInt32(item.GetDataKeyValue("UserID"));
            //    if (currentID == lastID)
            //    {
            //        int companyStatusID = Status.Released;
            //        if (!(item.FindControl("CompanyStatusID") as HiddenField).Value.Equals(string.Empty))
            //        {
            //            companyStatusID = Convert.ToInt32((item.FindControl("CompanyStatusID") as HiddenField).Value);
            //        }
            //        int statusID = Convert.ToInt32((item.FindControl("StatusID") as HiddenField).Value);
            //        if (statusID != Status.CreatedNotConfirmed && companyStatusID == Status.Released && (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, action)))
            //        {
            //            Helpers.SetAction(action);
            //            e.Item.Edit = true;
            //        }
            //    }
            //}
        }

        protected void RadDropDownList1_ItemDataBound(object sender, Telerik.Web.UI.DropDownListItemEventArgs e)
        {
            string flagHome = ConfigurationManager.AppSettings["FlagFilesHome"];
            string flagName = (e.Item.DataItem as DataRowView)["FlagName"].ToString();
            if (!flagName.Equals(string.Empty))
            {
                Image img = (Image)e.Item.FindControl("ItemImage");
                img.ImageUrl = string.Concat(flagHome, flagName);
                Label lbl = (Label)e.Item.FindControl("ItemText");
                lbl.Text = (e.Item.DataItem as DataRowView)["LanguageName"].ToString();
            }
        }

        protected void OnAjaxUpdate(object sender, ToolTipUpdateEventArgs args)
        {
            this.UpdateToolTip(args.Value, args.UpdatePanel);
        }

        private void UpdateToolTip(string elementID, UpdatePanel panel)
        {
            Control ctrl = Page.LoadControl("~/Controls/UsersToolTip.ascx");
            panel.ContentTemplateContainer.Controls.Add(ctrl);
            UsersToolTip details = (UsersToolTip)ctrl;
            details.UserID = elementID;
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

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormInsertItem insertItem = e.Item as GridEditFormInsertItem;

            if (!Helpers.LoginNameIsUnique((insertItem.FindControl("LoginName") as RadTextBox).Text))
            {
                e.Canceled = true;
                Helpers.Notification(this.Page.Master, Resources.Resource.lblUser, Resources.Resource.msgLoginNameNotUnique);
                (insertItem.FindControl("LoginName") as RadTextBox).Focus();
            }
            else
            {
                using (SqlConnection conn = new SqlConnection(ConnectionString))
                {
                    StringBuilder sql = new StringBuilder();
                    sql.Append("INSERT INTO Master_Users (SystemID, BpID, UserID, FirstName, LastName, CompanyID, LoginName, Password, RoleID, LanguageID, UseEmail, Soundex, ");
                    sql.Append("SkinName, Phone, Email, IsSysAdmin, IsVisible, StatusID, Salutation, GenderID, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                    sql.Append("VALUES (@SystemID, 0, @UserID, @FirstName, @LastName, @CompanyID, @LoginName, @Password, 0, @LanguageID, @UseEmail, dbo.SoundexGer(@LastName), @SkinName, ");
                    sql.AppendLine("@Phone, @Email, @IsSysAdmin, 1, @StatusID, @Salutation, 0, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) ");

                    SqlCommand cmd = new SqlCommand(sql.ToString(), conn);

                    cmd.Parameters.Add("@SystemID", SqlDbType.Int);
                    cmd.Parameters.Add("@UserID", SqlDbType.Int);
                    cmd.Parameters.Add("@FirstName", SqlDbType.NVarChar, 50);
                    cmd.Parameters.Add("@LastName", SqlDbType.NVarChar, 50);
                    cmd.Parameters.Add("@CompanyID", SqlDbType.Int);
                    cmd.Parameters.Add("@LoginName", SqlDbType.NVarChar, 50);
                    cmd.Parameters.Add("@Password", SqlDbType.NVarChar, 200);
                    // cmd.Parameters.Add("@RoleID", SqlDbType.Int);
                    cmd.Parameters.Add("@LanguageID", SqlDbType.NVarChar, 10);
                    cmd.Parameters.Add("@SkinName", SqlDbType.NVarChar, 50);
                    cmd.Parameters.Add("@Salutation", SqlDbType.NVarChar, 50);
                    cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 50);
                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 200);
                    cmd.Parameters.Add("@IsSysAdmin", SqlDbType.Bit);
                    // cmd.Parameters.Add("@IsVisible", SqlDbType.Bit);
                    cmd.Parameters.Add("@UserName", SqlDbType.NVarChar, 50);
                    SqlParameter par = new SqlParameter("@StatusID", SqlDbType.Int);
                    par.Value = Status.WaitRelease;
                    cmd.Parameters.Add(par);

                    cmd.Parameters["@SystemID"].Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters["@UserID"].Value = Convert.ToInt32((insertItem.FindControl("UserID") as Label).Text);
                    cmd.Parameters["@FirstName"].Value = (insertItem.FindControl("FirstName") as RadTextBox).Text;
                    cmd.Parameters["@LastName"].Value = (insertItem.FindControl("LastName") as RadTextBox).Text;
                    if ((insertItem.FindControl("CompanyID") as RadComboBox).SelectedValue.Equals(String.Empty))
                    {
                        cmd.Parameters["@CompanyID"].Value = 0;
                    }
                    else
                    {
                        cmd.Parameters["@CompanyID"].Value = Convert.ToInt32((insertItem.FindControl("CompanyID") as RadComboBox).SelectedValue);
                    }
                    cmd.Parameters["@LoginName"].Value = (insertItem.FindControl("LoginName") as RadTextBox).Text;
                    string hashedPassword = Helpers.HashPassword((insertItem.FindControl("Password") as RadTextBox).Text);
                    cmd.Parameters["@Password"].Value = hashedPassword;
                    // cmd.Parameters["@RoleID"].Value = Convert.ToInt32((insertItem["RoleID"].Controls[0] as RadComboBox).SelectedItem.Value);
                    cmd.Parameters["@LanguageID"].Value = (insertItem.FindControl("LanguageID") as RadComboBox).SelectedItem.Value;
                    // cmd.Parameters["@SkinName"].Value = (insertItem.FindControl("SkinName") as RadComboBox).SelectedItem.Value;
                    cmd.Parameters["@SkinName"].Value = "Office2010Silver";
                    cmd.Parameters["@Salutation"].Value = (insertItem.FindControl("Salutation") as RadComboBox).SelectedItem.Value;
                    cmd.Parameters["@Phone"].Value = (insertItem.FindControl("Phone") as RadTextBox).Text;
                    cmd.Parameters["@Email"].Value = (insertItem.FindControl("Email") as RadTextBox).Text;
                    cmd.Parameters["@IsSysAdmin"].Value = false;
                    // cmd.Parameters["@IsVisible"].Value = (insertItem["IsVisible"].Controls[0] as CheckBox).Checked;
                    cmd.Parameters["@UserName"].Value = Session["LoginName"].ToString();

                    par = new SqlParameter("@UseEmail", SqlDbType.Bit);
                    par.Value = (insertItem.FindControl("UseEmail") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        conn.Close();
                        lastID = Convert.ToInt32(cmd.Parameters["@UserID"].Value);

                        // Email an Admin
                        List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                        if (!(insertItem.FindControl("CompanyID") as RadComboBox).SelectedValue.Equals(String.Empty))
                        {
                            values.Add(new Tuple<string, string>("CompanyID", (insertItem.FindControl("CompanyID") as RadComboBox).SelectedValue));
                            values.Add(new Tuple<string, string>("CompanyName", (insertItem.FindControl("CompanyID") as RadComboBox).SelectedItem.Text));
                        }
                        values.Add(new Tuple<string, string>("UserID", (insertItem.FindControl("UserID") as Label).Text));
                        values.Add(new Tuple<string, string>("Salutation", (insertItem.FindControl("Salutation") as RadComboBox).SelectedValue));
                        values.Add(new Tuple<string, string>("FirstName", (insertItem.FindControl("FirstName") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("LastName", (insertItem.FindControl("LastName") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("LanguageName", (insertItem.FindControl("LanguageID") as RadComboBox).SelectedItem.Text));
                        values.Add(new Tuple<string, string>("Phone", (insertItem.FindControl("Phone") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("EmailUser", (insertItem.FindControl("Email") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("LoginName", (insertItem.FindControl("LoginName") as RadTextBox).Text));
                        string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Central/Users.aspx?UserID=" + (insertItem.FindControl("UserID") as Label).Text);
                        values.Add(new Tuple<string, string>("UrlUser", url));

                        // Duplikatsuche Benutzer
                        string userDuplicates = string.Empty;
                        GetUserDuplicates_Result[] users = Helpers.GetUserDuplicates(lastID);
                        if (users != null && users.Count() > 0)
                        {
                            StringBuilder duplicatesHint = new StringBuilder();
                            duplicatesHint.Append("<br />Mögliche Duplikate (Relevanz, Nachname, Vorname, Email, Firma):<br />");
                            duplicatesHint.Append("Possible duplicates (Relevance, Last name, First name, Email, Company):<br /><br />");
                            foreach (GetUserDuplicates_Result user in users)
                            {
                                duplicatesHint.AppendFormat("{0}, {1}, {2}, {3}, {4}<br />", user.Match.ToString(), user.LastName, user.FirstName, user.Email, user.NameVisible);
                            }
                            userDuplicates = duplicatesHint.ToString();
                        }

                        // Eintrag in Vorgangsverwaltung für Benutzer
                        string dialogName = GetGlobalResourceObject("Resource", Helpers.GetDialogResID("Users")).ToString();
                        string companyName = (insertItem.FindControl("CompanyID") as RadComboBox).SelectedItem.Text;
                        string refName = (insertItem.FindControl("FirstName") as RadTextBox).Text + " " + (insertItem.FindControl("LastName") as RadTextBox).Text;
                        int prevBpID = Convert.ToInt32(Session["BpID"]);
                        Session["BpID"] = 1;
                        Master_Translations translation = Helpers.GetTranslation("PMHints_RegisterUser", Helpers.CurrentLanguage(), values.ToArray());
                        Session["BpID"] = prevBpID;
                        string actionHint = translation.HtmlTranslated;
                        if (userDuplicates != string.Empty)
                        {
                            actionHint += userDuplicates;
                        }
                        Session["BpID"] = 0;
                        Helpers.CreateProcessEvent("Users", dialogName, companyName, Actions.Release, Convert.ToInt32((insertItem.FindControl("UserID") as Label).Text), refName, actionHint, "PMHints_RegisterUser", values.ToArray());
                        Session["BpID"] = prevBpID;

                        Helpers.DialogLogger(type, Actions.Create, lastID.ToString(), Resources.Resource.lblActionCreate);
                        SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                        // RadGrid1.EditIndexes.Clear();
                        // RadGrid1.Rebind();
                    }
                    catch (SqlException ex)
                    {
                        SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                    }
                    catch (System.Exception ex)
                    {
                        SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                    }
                }
            }
        }

        protected void BpID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadComboBox cb = (sender as RadComboBox).Parent.FindControl("RoleID") as RadComboBox;
            if (cb != null)
            {
                cb.Items.Clear();
                cb.DataSource = GetRolesData(Convert.ToInt32(e.Value));
                cb.DataBind();

                string defaultRoleID = Helpers.GetDefaultRoleID(Convert.ToInt32(e.Value)).ToString();

                foreach (RadComboBoxItem item in cb.Items)
                {
                    if (item.Value == defaultRoleID)
                    {
                        item.Selected = true;
                    }
                }
            }
        }

        private DataTable GetRolesData(int bpID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT DISTINCT r.RoleID, r.NameVisible, r.DescriptionShort ");
            sql.Append("FROM Master_Roles r, Master_UserBuildingProjects u, Master_Roles ur ");
            sql.Append("WHERE r.SystemID = @SystemID ");
            sql.Append("AND r.BpID = @BpID ");
            sql.Append("AND r.TypeID <= ur.TypeID ");
            sql.Append("AND r.TypeID <= @UserType ");
            sql.Append("AND (r.ShowInList = 1 OR @UserType = 100) ");
            sql.Append("AND u.SystemID = r.SystemID ");
            sql.Append("AND u.UserID = @EditingUserID ");
            sql.Append("AND u.BpID = r.BpID ");
            sql.Append("AND ur.SystemID = u.SystemID ");
            sql.Append("AND ur.BpID = u.BpID ");
            sql.Append("AND ur.RoleID = u.RoleID ");
            sql.Append("AND (ur.ShowInList = 1 OR @UserType = 100) ");
            sql.Append("ORDER BY NameVisible ");

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

            par = new SqlParameter("@EditingUserID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserType", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["UserType"]);
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
                throw;
            }
            catch (System.Exception ex)
            {
                throw;
            }
            finally
            {
                con.Close();
            }

            return dt;
        }

        protected void RadGridBP_InsertCommand(object sender, GridCommandEventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO Master_UserBuildingProjects (SystemID, UserID, BpID, RoleID, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
            sql.Append("VALUES (@SystemID, @UserID, @BpID, @RoleID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Value = Convert.ToInt32(((sender as RadGrid).Parent.FindControl("UserID") as Label).Text);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item.FindControl("BpID") as RadComboBox).SelectedValue);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@RoleID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item.FindControl("RoleID") as RadComboBox).SelectedValue);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = Session["LoginName"].ToString();
            cmd.Parameters.Add(par);

            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
                SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                (sender as RadGrid).MasterTableView.IsItemInserted = false;
                (sender as RadGrid).MasterTableView.Rebind();
            }
            catch (SqlException ex)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw;
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadGrid1_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormItem item = e.Item as GridEditFormItem;

            if (Page.IsValid)
            {
                StringBuilder sql = new StringBuilder();

                sql.Append("INSERT INTO History_Users SELECT * FROM Master_Users ");
                sql.AppendLine("WHERE [SystemID] = @SystemID AND [UserID] = @UserID; ");
                sql.Append("UPDATE Master_Users ");
                sql.Append("SET FirstName = @FirstName, LastName = @LastName, CompanyID = @CompanyID, LoginName = @LoginName, LanguageID = @LanguageID, ");
                sql.Append("SkinName = @SkinName, Phone = @Phone, Email = @Email, IsSysAdmin = @IsSysAdmin, IsVisible = 1, Salutation = @Salutation, EditFrom = @UserName, EditOn = SYSDATETIME(), ");
                sql.Append("ReleaseFrom = @ReleaseFrom, ReleaseOn = @ReleaseOn, LockedFrom = @LockedFrom, LockedOn = @LockedOn, StatusID = @StatusID, UseEmail = @UseEmail, Soundex = dbo.SoundexGer(@LastName) ");
                sql.Append("WHERE SystemID = @SystemID ");
                sql.Append("AND UserID = @UserID ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserID", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("UserID") as Label).Text);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@FirstName", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("FirstName") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LastName", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("LastName") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                if ((item.FindControl("CompanyID") as RadComboBox).SelectedValue.Equals(String.Empty))
                {
                    par.Value = 0;
                }
                else
                {
                    par.Value = Convert.ToInt32((item.FindControl("CompanyID") as RadComboBox).SelectedValue);
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LoginName", SqlDbType.NVarChar, 100);
                par.Value = (item.FindControl("LoginName") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LanguageID", SqlDbType.NVarChar, 10);
                par.Value = (item.FindControl("LanguageID") as RadComboBox).SelectedValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@SkinName", SqlDbType.NVarChar, 50);
                // par.Value = (item.FindControl("SkinName") as RadComboBox).SelectedValue;
                par.Value = "Office2010Silver";
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Salutation", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("Salutation") as RadComboBox).SelectedValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Phone", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("Phone") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Email", SqlDbType.NVarChar, 200);
                par.Value = (item.FindControl("Email") as RadTextBox).Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@IsSysAdmin", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UseEmail", SqlDbType.Bit);
                par.Value = (item.FindControl("UseEmail") as CheckBox).Checked;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
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

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();

                    if (statusID == Status.Released)
                    {
                        // Aktuellen Vorgang auf erledigt setzen
                        Data_ProcessEvents eventData = new Data_ProcessEvents();
                        eventData.DialogID = Helpers.GetDialogID(type.Name);
                        eventData.ActionID = Actions.Release;
                        eventData.RefID = Convert.ToInt32((item.FindControl("UserID") as Label).Text);
                        Helpers.ProcessEventDone(eventData);
                    }

                    Helpers.DialogLogger(type, Actions.Edit, (item.FindControl("UserID") as Label).Text, Resources.Resource.lblActionEdit);
                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                    action = Actions.View;
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

                if (Session["ReleaseMessage"] != null && Convert.ToBoolean(Session["ReleaseMessage"]))
                {
                    if ((item.FindControl("Email") as RadTextBox).Text != "" && (item.FindControl("UseEmail") as CheckBox).Checked)
                    {
                        // Email an Benutzer, wenn Freigabe erfolgt
                        string subject = Resources.Resource.lblUserRelease;
                        string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Login.aspx");
                        string body = string.Format(Resources.Resource.msgUserRelease, (item.FindControl("LoginName") as RadTextBox).Text, url);
                        Helpers.SendMail((item.FindControl("Email") as RadTextBox).Text, subject, body);
                    }
                    else
                    {
                        // Email an Firmenadministrator, wenn Benutzer keine Email Adresse hat
                        string subject = Resources.Resource.lblUserRelease;
                        string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Central/Users.aspx?UserID=" + (item.FindControl("UserID") as Label).Text);
                        string body = string.Format(Resources.Resource.msgUserRelease1, (item.FindControl("LoginName") as RadTextBox).Text, url);
                        GetCompanyAdminUser_Result[] result = Helpers.GetCompanyAdminUser(Convert.ToInt32((item.FindControl("CompanyID") as RadComboBox).SelectedValue));
                        if (result.Count() > 0)
                        {
                            string email = result[0].Email;
                            if (!email.Equals(string.Empty))
                            {
                                Helpers.SendMail(email, subject, body);
                            }
                        }
                    }
                    
                    Session["ReleaseMessage"] = null;
                }
            }
        }

        protected void CompanyID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Session["SelectedCompanyID"] = e.Value;
        }

        protected void RadGridBP_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e);

            if (e.CommandName == "Edit")
            {
                if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                {
                    ((sender as RadGrid).Parent.FindControl("btnUpdate") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancel") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnChangePwd") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("ResetPwd") as RadButton).Enabled = false;
                }
                else
                {
                    e.Canceled = true;
                }
            }

            if (e.CommandName == "Delete")
            {
                if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                {
                    e.Canceled = true;
                }
            }

            if (e.CommandName == "InitInsert")
            {
                if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                {
                    ((sender as RadGrid).Parent.FindControl("btnUpdate") as RadButton).Enabled = false;
                    ((sender as RadGrid).Parent.FindControl("btnCancel") as RadButton).Enabled = false;
                    ((sender as RadGrid).Parent.FindControl("btnChangePwd") as RadButton).Enabled = false;
                    ((sender as RadGrid).Parent.FindControl("ResetPwd") as RadButton).Enabled = false;
                }
                else
                {
                    e.Canceled = true;
                }
            }

            if (e.CommandName == "Cancel")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdate") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancel") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnChangePwd") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("ResetPwd") as RadButton).Enabled = true;
            }

            if (e.CommandName == "Update")
            {
                    ((sender as RadGrid).Parent.FindControl("btnUpdate") as RadButton).Enabled = true;
                    ((sender as RadGrid).Parent.FindControl("btnCancel") as RadButton).Enabled = true;
                    ((sender as RadGrid).Parent.FindControl("btnChangePwd") as RadButton).Enabled = true;
                    ((sender as RadGrid).Parent.FindControl("ResetPwd") as RadButton).Enabled = true;
            }

            if (e.CommandName == "PerformInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnUpdate") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancel") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnChangePwd") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("ResetPwd") as RadButton).Enabled = true;
            }
        }

        protected void RadGridBP_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGridBP_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem))
            {
                RadComboBox cb = e.Item.FindControl("RoleID") as RadComboBox;
                if (cb != null)
                {
                    cb.Items.Clear();
                    cb.DataSource = GetRolesData(Convert.ToInt32((e.Item.FindControl("BpID") as HiddenField).Value));
                    cb.DataBind();
                    foreach (RadComboBoxItem item in cb.Items)
                    {
                        if (item.Value == (e.Item.FindControl("RoleID1") as HiddenField).Value)
                        {
                            item.Selected = true;
                        }
                    }
                }
            }

            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                RadComboBox cb = e.Item.FindControl("BpID") as RadComboBox;
                if (cb != null)
                {
                    StringBuilder sql = new StringBuilder();
                    DataTable dt = new DataTable();

                    if (Session["SelectedCompanyID"] != null && Session["SelectedCompanyID"].ToString().Equals("0"))
                    {
                        sql.Append("SELECT DISTINCT bp.SystemID, bp.BpID, bp.NameVisible, bp.DescriptionShort, bp.TypeID, bp.BasedOn, bp.IsVisible, bp.CountryID, bp.BuilderName, ");
                        sql.Append("bp.PresentType, bp.MWCheck, bp.MWHours, bp.MWDeadline, bp.Address, bp.CreatedFrom, bp.CreatedOn, bp.EditFrom, bp.EditOn ");
                        sql.Append("FROM Master_BuildingProjects AS bp ");
                        sql.Append("INNER JOIN Master_UserBuildingProjects AS ubp1 ");
                        sql.Append("ON bp.SystemID = ubp1.SystemID AND bp.BpID = ubp1.BpID ");
                        sql.Append("WHERE bp.SystemID = @SystemID AND ubp1.UserID = @EditingUserID ");
                        sql.Append("AND NOT EXISTS (SELECT 1 FROM Master_UserBuildingProjects AS ubp2 ");
                        sql.Append("WHERE ubp2.SystemID = bp.SystemID AND ubp2.BpID = bp.BpID AND ubp2.UserID = @UserID) ");
                        sql.Append("ORDER BY bp.NameVisible ");
                    }
                    else
                    {
                        sql.Append("SELECT DISTINCT bp.SystemID, bp.BpID, bp.NameVisible, bp.DescriptionShort, bp.TypeID, bp.BasedOn, bp.IsVisible, bp.CountryID, bp.BuilderName, ");
                        sql.Append("bp.PresentType, bp.MWCheck, bp.MWHours, bp.MWDeadline, bp.Address, bp.CreatedFrom, bp.CreatedOn, bp.EditFrom, bp.EditOn ");
                        sql.Append("FROM Master_BuildingProjects AS bp ");
                        sql.Append("INNER JOIN Master_UserBuildingProjects AS ubp1 ");
                        sql.Append("ON bp.SystemID = ubp1.SystemID AND bp.BpID = ubp1.BpID ");
                        sql.Append("INNER JOIN Master_Companies AS mco ");
                        sql.Append("ON bp.SystemID = mco.SystemID AND bp.BpID = mco.BpID ");
                        sql.Append("WHERE bp.SystemID = @SystemID AND ubp1.UserID = @EditingUserID ");
                        sql.Append("AND NOT EXISTS (SELECT 1 FROM Master_UserBuildingProjects AS ubp2 ");
                        sql.Append("WHERE SystemID = bp.SystemID AND BpID = bp.BpID AND UserID = @UserID) ");
                        sql.Append("AND mco.CompanyCentralID = @CompanyID ");
                        sql.Append("ORDER BY bp.NameVisible ");
                    }
                    SqlConnection con = new SqlConnection(ConnectionString);
                    SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                    SqlParameter par = new SqlParameter();

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@EditingUserID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["SelectedUserID"]);
                    cmd.Parameters.Add(par);

                    if (!Session["SelectedCompanyID"].ToString().Equals("0"))
                    {
                        par = new SqlParameter("@CompanyID", SqlDbType.Int);
                        par.Value = Convert.ToInt32(Session["SelectedCompanyID"]);
                        cmd.Parameters.Add(par);
                    }

                    SqlDataAdapter adapter = new SqlDataAdapter();
                    adapter.SelectCommand = cmd;

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
                        
                    cb.Items.Clear();
                    if (dt.Rows.Count > 0)
                    {
                        cb.DataSource = dt;
                        cb.DataBind();
                    }
                }
            }
        }

        protected void RadGridBP_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE Master_UserBuildingProjects SET RoleID = @RoleID, EditFrom = @UserName, EditOn = SYSDATETIME() ");
            sql.Append("WHERE SystemID = @SystemID AND UserID = @UserID AND BpID = @BpID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Value = Convert.ToInt32(((sender as RadGrid).Parent.FindControl("UserID") as Label).Text);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item.FindControl("BpID") as HiddenField).Value);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@RoleID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item.FindControl("RoleID") as RadComboBox).SelectedValue);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = Session["LoginName"].ToString();
            cmd.Parameters.Add(par);

            con.Open();
            try
            {
                cmd.ExecuteNonQuery();
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                (sender as RadGrid).MasterTableView.Rebind();
            }
            catch (SqlException ex)
            {
                throw;
            }
            catch (System.Exception ex)
            {
                throw;
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("GetUsersData", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            if (SelectBp.SelectedValue != "")
            {
                par.Value = Convert.ToInt32(SelectBp.SelectedValue);
            }
            else
            {
                par.Value = 0;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyCentralID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["CompanyID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["UserID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserType", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["UserType"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@Filter", SqlDbType.Text, 50);
            par.Value = Session["AlphaFilter"].ToString();
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

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridFilteringItem)
            {
                // Formatierung für Datumsfilter
                //GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                //if (filteringItem != null)
                //{
                //    LiteralControl literal = filteringItem["EditOn"].Controls[0] as LiteralControl;
                //    literal.Text = Resources.Resource.lblFrom + " ";

                //    literal = filteringItem["EditOn"].Controls[3] as LiteralControl;
                //    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
                //}
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
                        if (Session["AlphaFilter"] != null && Session["AlphaFilter"].ToString().Equals(string.Empty + (char)i))
                        {
                            rb.ForeColor = System.Drawing.Color.Orange;
                            rb.Font.Bold = true;
                        }
                        else
                        {
                            rb.ForeColor = System.Drawing.Color.Black;
                            rb.Font.Bold = false;
                        }
                        rb.ButtonType = RadButtonType.SkinnedButton;
                        rb.GroupName = "AlphaFilterGroup";
                        rb.ToolTip = Resources.Resource.ttFilterByFirstLetter + " " + (char)i;
                        rb.CssClass = "AlphaButton";

                        placeHolder.Controls.Add(rb);
                    }

                    rb = new RadButton();
                    rb.Text = Resources.Resource.lblAll;
                    rb.CommandName = "AlphaFilter";
                    rb.CommandArgument = string.Empty;
                    rb.BorderStyle = BorderStyle.None;
                    if (Session["AlphaFilter"] == null || Session["AlphaFilter"].ToString().Equals(string.Empty))
                    {
                        rb.ForeColor = System.Drawing.Color.Orange;
                        rb.Font.Bold = true;
                    }
                    else
                    {
                        rb.ForeColor = System.Drawing.Color.Black;
                        rb.Font.Bold = false;
                    }
                    rb.ButtonType = RadButtonType.SkinnedButton;
                    rb.GroupName = "AlphaFilterGroup";
                    rb.ToolTip = Resources.Resource.ttFilterNoFirstLetter;

                    placeHolder.Controls.Add(rb);
                }
            }
        }

        protected void SelectBp_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadGrid1.Rebind();
        }

        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.AppendLine("UPDATE System_Companies SET UserID = 0 WHERE SystemID = @SystemID AND UserID = @UserID; ");
            sql.AppendLine("INSERT INTO History_Users SELECT * FROM Master_Users WHERE SystemID = @SystemID AND UserID = @UserID; ");
            sql.Append("DELETE FROM Master_UserBuildingProjects ");
            sql.AppendLine("WHERE SystemID = @SystemID AND UserID = @UserID; ");
            sql.Append("DELETE FROM Data_ProcessEvents ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = 0 AND DialogID = 92 AND RefID = @UserID; ");
            sql.AppendLine("DELETE FROM Master_Users WHERE SystemID = @SystemID AND UserID = @UserID; ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item.FindControl("UserID") as Label).Text);
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Delete, (e.Item.FindControl("UserID") as Label).Text, Resources.Resource.lblActionDelete);
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

        protected void ResetPwd_Click(object sender, EventArgs e)
        {
            int userID = 0;
            Label labelUserID = ((sender as RadButton).NamingContainer as GridEditFormItem).FindControl("UserID") as Label;
            if (labelUserID != null)
            {
                userID = Convert.ToInt32(labelUserID.Text);
            }

            Master_Users user = Helpers.GetUser(userID);

            if (!user.Email.Equals(string.Empty))
            {
                Random rnd = new Random();
                string newPassword = Helpers.GenerateCode(8, rnd.Next(1000, 9999));
                Webservices webservice = new Webservices();
                int ret = webservice.UpdatePwd(user.UserID, newPassword, true);
                if (ret == 0)
                {
                    // Email an User
                    string subject = Resources.Resource.lblResetPassword;
                    StringBuilder bodyText = new StringBuilder();
                    bodyText.AppendLine(string.Concat(Resources.Resource.lblNewPwd, ": ", newPassword));
                    Helpers.SendMail(user.Email, subject, bodyText.ToString());
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblResetPassword, Resources.Resource.msgResendPassword1, 10000, "none", "info");
                }
            }
        }

        protected void RadGridBP_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            int userID = 0;
            RadGrid radGridBp = (sender as RadGrid);
            userID = Convert.ToInt32(Session["SelectedUserID"]);
            radGridBp.DataSource = GetBpUserData(userID);
        }

        private DataTable GetBpUserData(int userID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT Master_BuildingProjects.NameVisible AS NameBp, Master_Roles.NameVisible AS NameRole, Master_UserBuildingProjects.SystemID, ");
            sql.Append("Master_UserBuildingProjects.UserID, Master_UserBuildingProjects.BpID, Master_UserBuildingProjects.RoleID ");
            sql.Append("FROM Master_UserBuildingProjects ");
            sql.Append("INNER JOIN Master_BuildingProjects ");
            sql.Append("ON Master_UserBuildingProjects.SystemID = Master_BuildingProjects.SystemID AND Master_UserBuildingProjects.BpID = Master_BuildingProjects.BpID ");
            sql.Append("INNER JOIN Master_Roles ");
            sql.Append("ON Master_UserBuildingProjects.SystemID = Master_Roles.SystemID AND Master_UserBuildingProjects.BpID = Master_Roles.BpID ");
            sql.Append("AND Master_UserBuildingProjects.RoleID = Master_Roles.RoleID ");
            sql.Append("WHERE (Master_UserBuildingProjects.SystemID = @SystemID) ");
            sql.Append("AND (Master_UserBuildingProjects.UserID = @UserID) ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);
            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Value = userID;
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
                SetMessage(Resources.Resource.lblActionSelect, String.Format(Resources.Resource.msgSelectFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionSelect, String.Format(Resources.Resource.msgSelectFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }

            return dt;
        }

        protected void RadGridBP_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("DELETE FROM Master_UserBuildingProjects ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND UserID = @UserID; ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item.FindControl("BpID") as HiddenField).Value);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SelectedUserID"]);
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
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
    }
}