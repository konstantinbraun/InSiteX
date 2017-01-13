using InSite.App.BLL;
using InSite.App.Constants;
using InSite.App.UserServices;
using InSite.App.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading;
using System.Web;
using Telerik.Web.UI;

namespace InSite.App.Views
{
    public partial class Login : System.Web.UI.Page
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private int action = Actions.View;
        private string currentPwd;
        private int minPwdLength = Convert.ToInt32(ConfigurationManager.AppSettings["MinPwdLength"]);
        private UserAssignments[] users;

        private String msg = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            UserName.Focus();

            dtoBpContact _contact = new dtoBpContact();
            Dictionary<string, List<clsBpContact>> ds = _contact.GetData();

            repContacts.Visible = ds.Count() > 0;
            repContacts.DataSource = ds;
            repContacts.DataBind();

            if (!this.IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                string login="";
                string pwd="";

                string[] keys = Request.Form.AllKeys;
                for (int i = 0; i < keys.Length; i++)
                {
                        login = Request.Form["LoginName"];
                        pwd= Request.Form["Password"];
                }

                if (!string.IsNullOrEmpty(login) && !string.IsNullOrEmpty(pwd))
                {

                    Webservices webservice = new Webservices();
                    users = webservice.Login(login, pwd);
                    if (users != null && users.Count() != 0 && users[0].UserID != 0)
                    {
                        logger.InfoFormat("User {0} successfully logged in", users[0].LoginName);
                        Helpers.DialogLogger(type, 1, "0", String.Format("User {0} successfully logged in", UserName.Text));
                        Session["IsLoggedIn"] = true;
                        Session["SystemID"] = users[0].SystemID;
                        SessionData.SomeData["User"] = users;
                        SessionData.SomeData["CurrentPwd"] = pwd;
                        if (!users[0].NeedsPwdChange)
                        {
                            if (users[0].BpID == 0 && users[0].RoleID == -1)
                            {
                                // Register company for building project
                                logger.DebugFormat("User {0} wants to register his company to a building project", users[0].LoginName);
                                if (users[0].CompanyID != 0)
                                {
                                    webservice = new Webservices();
                                    System_Companies company = webservice.GetCompanyCentralInfo(users[0].CompanyID);
                                    if (company != null && company.ReleaseOn != null && company.LockedOn == null)
                                    {
                                        Helpers.SetUserSession(users[0]);
                                        LoginPanel.Visible = false;
                                        PanelRegisterBp.Visible = true;
                                        CompanyName.Text = users[0].Company;
                                        InitBp();
                                    }
                                    else
                                    {
                                        logger.ErrorFormat("Company {0} not released", users[0].CompanyID);
                                        Notification.Title = Resources.Resource.lblLogin;
                                        Notification.Text = Resources.Resource.msgCompanyNotReleased;
                                        Notification.ContentIcon = "warning";
                                        Notification.ShowSound = "warning";
                                        Notification.AutoCloseDelay = 0;
                                        Notification.Show();
                                        PanelNotification.Update();
                                    }
                                }
                                else
                                {
                                    logger.Error("Company required");
                                    Notification.Title = Resources.Resource.lblLogin;
                                    Notification.Text = Resources.Resource.msgCompanyRequired;
                                    Notification.ContentIcon = "warning";
                                    Notification.ShowSound = "warning";
                                    Notification.AutoCloseDelay = 0;
                                    Notification.Show();
                                    PanelNotification.Update();
                                }
                            }
                            else if (Session["BpID"] == null && users.Count() > 1)
                            {
                                // Select building project
                                logger.DebugFormat("User {0} needs to select building project", users[0].LoginName);

                                LoginPanel.Visible = false;
                                RadGridBpSelect.Rebind();
                                PanelBpSelect.Visible = true;
                            }
                            else
                            {
                                // Switch to building project
                                Session["BpID"] = users[0].BpID;
                                Master_BuildingProjects bp = webservice.GetBpInfo(Convert.ToInt32(Session["BpID"]));
                                Session["BpName"] = bp.NameVisible;
                                Session["BpDescription"] = bp.DescriptionShort;
                                Session["PresenceLevel"] = bp.PresentType;
                                Session["AccessRightValidDays"] = bp.AccessRightValidDays;
                                Helpers.SetUserSession(users[0]);
                                logger.DebugFormat("User {0} connected to building project {1}", users[0].LoginName, bp.NameVisible);
                                RadAjaxManager1.Redirect("Dashboard.aspx?Msg=Welcome");
                            }
                        }
                    }
                }

                string action = Request.QueryString["Action"];
                if (action != null && !action.Equals(string.Empty))
                {
                    LoginPanel.Visible = false;
                    PanelBpSelect.Visible = true;
                    // RadGridBpSelect.Rebind();
                }
                else
                {
                    // UserName.Focus();
                }

                if (HttpContext.Current.Session["LoginName"] != null && (action == null || action.Equals(string.Empty)))
                {
                    Helpers.Logout();
                    UserName.Text = string.Empty;
                    Password.Text = string.Empty;
                }

                // Seitentitel ergänzen
                if (!LoginHead.Title.Equals(String.Empty))
                {
                    LoginHead.Title = Properties.AppDefaults.appName + " - " + LoginHead.Title;
                }
                else
                {
                    LoginHead.Title = Properties.AppDefaults.appName;
                }

                // Seitenüberschrift zusammenbauen
                // PageTitle.Text = LoginHead.Title;

                msg = Request.QueryString["Msg"];

                Helpers.DialogLogger(type, 1, "0", Resources.Resource.lblActionView);

                if (Request.UrlReferrer != null)
                {
                    string[] url = Request.UrlReferrer.ToString().Split(new char[] { '?' });
                    Session["Referrer"] = url[0];
                }
            }
            if (msg != null)
            {
                if (msg.Equals("PleaseLogin"))
                {
                    Notification.Title = Resources.Resource.lblLogin;
                    Notification.Text = Resources.Resource.msgPleaseLogin;
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "info";
                    Notification.AutoCloseDelay = 5000;
                    Notification.Show();
                    PanelNotification.Update();
                }

                if (msg.Equals("Timeout"))
                {
                    logger.Info("Session ended by timeout or logout");

                    Thread.Sleep(1000);

                    if (Session["IsLoggedIn"] != null && (bool)Session["IsLoggedIn"])
                    {
                        Helpers.Logout();
                    }
                    Notification.Title = Resources.Resource.lblLogin;
                    Notification.Text = Resources.Resource.msgTimeout;
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "info";
                    Notification.AutoCloseDelay = 0;
                    Notification.Show();
                    PanelNotification.Update();
                }

                if (msg.Equals("CRS") || msg.Equals("ERS"))
                {
                    logger.Info("Registration successful, email sent");

                    string email = Request.QueryString["Email"];
                    Notification.Title = Resources.Resource.lblCompanyMasterCentral;
                    Notification.Text = String.Format(Resources.Resource.msgRegistrationSuccess, email);
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "info";
                    Notification.AutoCloseDelay = 5000;
                    Notification.Show();
                    PanelNotification.Update();
                }
            }
            string path = ConfigurationManager.AppSettings["CaptchaAudio"].ToString() + "/Captcha." + Helpers.CurrentLanguage();

            if (Directory.Exists(Server.MapPath(path)))
            {
                CaptchaRequestNewPassword.CaptchaImage.AudioFilesPath = path;
            }
            else
            {
                CaptchaRequestNewPassword.CaptchaImage.AudioFilesPath = ConfigurationManager.AppSettings["CaptchaAudio"].ToString();
            }
        }

        protected void BtnResetPassword_Click(object sender, EventArgs e)
        {
            LoginPanel.Visible = false;
            PanelResetPassword.Visible = true;
            UserName.Text = String.Empty;
            Password.Text = String.Empty;
            UserName1.Focus();
        }

        protected void BtnLogin_Click(object sender, EventArgs e)
        {
            DoLogin(false);
        }

        private void DoLogin(bool requestBp)
        {
            if (UserName.Text.Equals(String.Empty))
            {
                UserName.Focus();
                Notification.Title = Resources.Resource.lblLogin;
                Notification.Text = Resources.Resource.msgUserNameObligate;
                Notification.ShowSound = "none";
                Notification.ContentIcon = "warning";
                Notification.AutoCloseDelay = 5000;
                Notification.Show();
                PanelNotification.Update();
            }
            else if (Password.Text.Equals(String.Empty))
            {
                Password.Focus();
                Notification.Title = Resources.Resource.lblLogin;
                Notification.Text = Resources.Resource.msgPasswordObligate;
                Notification.ShowSound = "none";
                Notification.ContentIcon = "warning";
                Notification.AutoCloseDelay = 5000;
                Notification.Show();
                PanelNotification.Update();
            }
            else
            {
                currentPwd = Password.Text;
                Webservices webservice = new Webservices();
                users = webservice.Login(UserName.Text.ToString(), currentPwd);
                if (users != null && users.Count() != 0 && users[0].UserID != 0)
                {
                    logger.InfoFormat("User {0} successfully logged in", users[0].LoginName);
                    Helpers.DialogLogger(type, 1, "0", String.Format("User {0} successfully logged in", UserName.Text));
                    Session["IsLoggedIn"] = true;
                    Session["SystemID"] = users[0].SystemID;
                    SessionData.SomeData["User"] = users;
                    SessionData.SomeData["CurrentPwd"] = currentPwd;
                    if (users[0].NeedsPwdChange)
                    {
                        logger.DebugFormat("User {0} needs to change password", users[0].LoginName);
                        LoginPanel.Visible = false;
                        PanelNewPassword.Visible = true;
                    }
                    else
                    {
                        if (requestBp || users[0].BpID == 0 && users[0].RoleID == -1)
                        {
                            // Register company for building project
                            logger.DebugFormat("User {0} wants to register his company to a building project", users[0].LoginName);
                            if (users[0].CompanyID != 0)
                            {
                                webservice = new Webservices();
                                System_Companies company = webservice.GetCompanyCentralInfo(users[0].CompanyID);
                                if (company != null && company.ReleaseOn != null && company.LockedOn == null)
                                {
                                    Helpers.SetUserSession(users[0]);
                                    LoginPanel.Visible = false;
                                    PanelRegisterBp.Visible = true;
                                    CompanyName.Text = users[0].Company;
                                    InitBp();
                                }
                                else
                                {
                                    logger.ErrorFormat("Company {0} not released", users[0].CompanyID);
                                    Notification.Title = Resources.Resource.lblLogin;
                                    Notification.Text = Resources.Resource.msgCompanyNotReleased;
                                    Notification.ContentIcon = "warning";
                                    Notification.ShowSound = "warning";
                                    Notification.AutoCloseDelay = 0;
                                    Notification.Show();
                                    PanelNotification.Update();
                                }
                            }
                            else
                            {
                                logger.Error("Company required");
                                Notification.Title = Resources.Resource.lblLogin;
                                Notification.Text = Resources.Resource.msgCompanyRequired;
                                Notification.ContentIcon = "warning";
                                Notification.ShowSound = "warning";
                                Notification.AutoCloseDelay = 0;
                                Notification.Show();
                                PanelNotification.Update();
                            }
                        }
                        else if (Session["BpID"] == null && users.Count() > 1)
                        {
                            // Select building project
                            logger.DebugFormat("User {0} needs to select building project", users[0].LoginName);

                            LoginPanel.Visible = false;
                            RadGridBpSelect.Rebind();
                            PanelBpSelect.Visible = true;
                        }
                        else
                        {
                            // Switch to building project
                            Session["BpID"] = users[0].BpID;
                            Master_BuildingProjects bp = webservice.GetBpInfo(Convert.ToInt32(Session["BpID"]));
                            Session["BpName"] = bp.NameVisible;
                            Session["BpDescription"] = bp.DescriptionShort;
                            Session["PresenceLevel"] = bp.PresentType;
                            Session["AccessRightValidDays"] = bp.AccessRightValidDays;
                            Helpers.SetUserSession(users[0]);
                            logger.DebugFormat("User {0} connected to building project {1}", users[0].LoginName, bp.NameVisible);
                            RadAjaxManager1.Redirect("Dashboard.aspx?Msg=Welcome");
                        }
                    }
                }
                else
                {
                    logger.InfoFormat("User {0} login failed!", UserName.Text);
                    Helpers.DialogLogger(type, 1, "0", String.Format("User {0} login failed!", UserName.Text));

                    int loginAttempts = Convert.ToInt32(Session["AdvertID"]);
                    loginAttempts++;
                    Session["AdvertID"] = loginAttempts;
                    int timeout = Convert.ToInt32(1000 * Math.Pow(2, (loginAttempts - 1)));

                    Notification.Title = Resources.Resource.lblLogin;
                    Notification.Text = Resources.Resource.msgLoginFailed;
                    Notification.ContentIcon = "warning";
                    Notification.ShowSound = "warning";
                    Notification.AutoCloseDelay = 0;
                    Notification.Show();
                    PanelNotification.Update();

                    System.Threading.Thread.Sleep(timeout);
                }
            }
        }

        protected void BtnRegisterEmployee_Click(object sender, EventArgs e)
        {
            Notification.Title = Resources.Resource.lblRegisterEmployee;
            if (RegistrationCode.Text.Equals(String.Empty))
            {
                Notification.Text = Resources.Resource.msgCodeObligate;
                Notification.ShowSound = "none";
                Notification.ContentIcon = "warning";
                Notification.AutoCloseDelay = 5000;
                Notification.Show();
                RegistrationCode.Focus();
                PanelNotification.Update();
            }
            else
            {
                logger.Info("Employee registration called");
                Webservices webservice = new Webservices();
                EmployeeRegistrationData data = webservice.ValidateRegistrationCode(RegistrationCode.Text);
                if (data.ReturnCode == 0)
                {
                    // Code ok
                    SessionData.SomeData["EmployeeRegistrationData"] = data;

                    // Registrierungsformular aufrufen
                    RadAjaxManager1.Redirect("RegisterEmployee.aspx");
                }
                else if (data.ReturnCode == -1)
                {
                    // Code nicht mehr gültig
                    Notification.Text = Resources.Resource.msgCodeNoLongerValid;
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "warning";
                    Notification.AutoCloseDelay = 5000;
                    Notification.Show();
                    PanelNotification.Update();

                    RegistrationCode.Focus();
                }
                else if (data.ReturnCode == -2)
                {
                    // Code nicht gefunden
                    Notification.Text = Resources.Resource.msgCodeWrong;
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "warning";
                    Notification.AutoCloseDelay = 5000;
                    Notification.Show();
                    PanelNotification.Update();

                    RegistrationCode.Focus();
                }
                else if (data.ReturnCode == -5)
                {
                    // Gültigkeitsdatum für Code nicht vorhanden
                    Notification.Text = Resources.Resource.msgCodeDateMissing;
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "warning";
                    Notification.AutoCloseDelay = 5000;
                    Notification.Show();
                    PanelNotification.Update();

                    RegistrationCode.Focus();
                }
                else
                {
                    // Allgemeiner Fehler
                    Notification.Text = Resources.Resource.msgGeneralFailure;
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "warning";
                    Notification.AutoCloseDelay = 5000;
                    Notification.Show();
                    PanelNotification.Update();

                    RegistrationCode.Focus();
                }
            }
        }

        protected void BtnSelect_Click(object sender, EventArgs e)
        {
            if (RadGridBpSelect.SelectedValue != null && !RadGridBpSelect.SelectedValue.Equals(string.Empty))
            {
                Webservices webservice = new Webservices();
                Master_BuildingProjects bp = webservice.GetBpInfo(Convert.ToInt32(RadGridBpSelect.SelectedValue));
                Session["BpID"] = bp.BpID;
                Session["BpName"] = bp.NameVisible;
                Session["BpDescription"] = bp.DescriptionShort;
                Session["PresenceLevel"] = bp.PresentType;
                Session["AccessRightValidDays"] = bp.AccessRightValidDays;
                logger.InfoFormat("User selected building project {0} ({1})", bp.BpID, bp.NameVisible);
                int systemID = (int)Session["SystemID"];
                UserAssignments user = Helpers.GetUserAssignment(systemID, Convert.ToInt32(RadGridBpSelect.SelectedValue));
                Helpers.SetUserSession(user);

                log4net.GlobalContext.Properties["BpID"] = RadGridBpSelect.SelectedValue;
                if (Session["RawUrl"] != null)
                {
                    string url = Uri.EscapeUriString(Session["RawUrl"].ToString());
                    Session["RawUrl"] = null;
                    RadAjaxManager1.Redirect(url);
                }
                else
                { 
                    RadAjaxManager1.Redirect("Dashboard.aspx?Msg=Welcome");
                }
            }
            else
            {
                Notification.Title = Resources.Resource.lblBuildingProject;
                Notification.Text = Resources.Resource.msgPleaseSelect;
                Notification.AutoCloseDelay = 5000;
                Notification.ShowSound = "none";
                Notification.ContentIcon = "info";
                Notification.Show();
                PanelNotification.Update();
            }
        }

        private static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void InitBp()
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT SystemID, BpID, NameVisible, DescriptionShort ");
            sql.Append("FROM Master_BuildingProjects AS b ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND IsVisible = 1 ");
            sql.Append("AND TypeID = 1 ");
            sql.Append("AND NOT EXISTS (SELECT 1 FROM Master_Companies WHERE (SystemID = b.SystemID) AND BpID = b.BpID AND (CompanyCentralID = @CompanyID)) ");
            sql.Append("ORDER BY NameVisible ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["CompanyID"]);
            cmd.Parameters.Add(par);

            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
                BpID.Items.Clear();
                BpID.DataSource = dt;
                BpID.DataBind();
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                throw;
            }
            finally
            {
                con.Close();
            }
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            PanelRegisterBp.Visible = false;
            PanelResetPassword.Visible = false;
            PanelNewPassword.Visible = false;
            PanelBpSelect.Visible = false;
            LoginPanel.Visible = true;
            Helpers.Logout();
            UserName.Focus();
        }

        protected void BtnRegisterBp_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                BtnRegisterBp.Enabled = false;
                int companyID = Helpers.GetNextID("CompanyID");

                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO [Master_Companies] ([SystemID], BpID, CompanyID, CompanyCentralID, ParentID, [NameVisible], NameAdditional, [Description], [AddressID], [IsVisible], [IsValid], TradeAssociation, ");
                sql.Append("IsPartner, BlnSOKA, MinWageAttestation, UserString1, UserString2, UserString3, UserString4, UserBit1, UserBit2, UserBit3, UserBit4, [CreatedFrom], [CreatedOn], ");
                sql.Append("[EditFrom], [EditOn], StatusID, RequestFrom, RequestOn) ");
                sql.Append("SELECT @SystemID, @BpID, @CompanyID, @CompanyCentralID, @ParentID, NameVisible, NameAdditional, Description, AddressID, 1, 1, TradeAssociation, @IsPartner, @BlnSOKA, ");
                sql.Append("@MinWageAttestation, @UserString1, @UserString2, @UserString3, @UserString4, @UserBit1, @UserBit2, @UserBit3, @UserBit4, @UserName, SYSDATETIME(), ");
                sql.Append("@UserName, SYSDATETIME(), @StatusID, @UserName, SYSDATETIME() ");
                sql.AppendLine("FROM System_Companies WHERE SystemID = @SystemID AND CompanyID = @CompanyCentralID; ");
                sql.Append("INSERT INTO [Master_CompanyTariffs] ([SystemID], BpID, [TariffScopeID], CompanyID, [ValidFrom], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) ");
                sql.Append("SELECT [SystemID], @BpID, dbo.BestTariffScope(SystemID, @BpID, TariffScopeID), @CompanyID, [ValidFrom], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn] ");
                sql.Append("FROM System_CompanyTariffs WHERE SystemID = @SystemID AND CompanyID = @CompanyCentralID ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(BpID.SelectedValue);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyCentralID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["CompanyID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                par.Value = companyID;
                cmd.Parameters.Add(par);

                int parentValue;
                if (CompanyID.SelectedItem != null)
                {
                    parentValue = Convert.ToInt32(CompanyID.SelectedValue);
                }
                else
                {
                    parentValue = 0;
                }
                par = new SqlParameter("@ParentID", SqlDbType.Int);
                par.Value = parentValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Description", SqlDbType.NVarChar, 2000);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@TradeAssociation", SqlDbType.NVarChar, 200);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BlnSOKA", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@IsPartner", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@MinWageAttestation", SqlDbType.Bit);
                Webservices webservice = new Webservices();
                Master_BuildingProjects bp = webservice.GetBpInfo(Convert.ToInt32(BpID.SelectedValue));
                if (bp != null)
                {
                    par.Value = bp.MWCheck;
                }
                else
                {
                    par.Value = false;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString1", SqlDbType.NVarChar, 50);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString2", SqlDbType.NVarChar, 50);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString3", SqlDbType.NVarChar, 50);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString4", SqlDbType.NVarChar, 50);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit1", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit2", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit3", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit4", SqlDbType.Bit);
                par.Value = false;
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

                    Helpers.DialogLogger(type, Actions.Create, companyID.ToString(), Resources.Resource.lblActionCreate);

                    // Eintrag in Vorgangsverwaltung
                    Session["BpID"] = BpID.SelectedValue;
                    string dialogName = GetGlobalResourceObject("Resource", Helpers.GetDialogResID("Companies")).ToString();
                    string companyName = CompanyName.Text;
                    string refName = companyName;
                    List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                    values.Add(new Tuple<string, string>("CompanyID", companyID.ToString()));
                    values.Add(new Tuple<string, string>("CompanyName", CompanyName.Text));
                    values.Add(new Tuple<string, string>("ClientID", CompanyID.SelectedValue.ToString()));
                    values.Add(new Tuple<string, string>("ClientName", CompanyID.SelectedItem.Text));
                    values.Add(new Tuple<string, string>("UserID", Session["UserID"].ToString()));
                    values.Add(new Tuple<string, string>("UserName", Session["LoginName"].ToString()));

                    Master_Translations translation = Helpers.GetTranslation("PMHints_RegisterCompanyBp", Helpers.CurrentLanguage(), values.ToArray());
                    string actionHint = translation.HtmlTranslated;

                    Helpers.CreateProcessEvent("Companies", dialogName, companyName, Actions.ReleaseBp, companyID, refName, actionHint, Convert.ToInt32(Session["CompanyID"]), "PMHints_RegisterCompanyBp", values.ToArray());

                    //string subject = Resources.Resource.lblRequestBp;
                    //string url = ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Main/Companies.aspx?CompanyID=" + companyID.ToString();
                    //string body = string.Format(Resources.Resource.msgRequestCompanyForBp, Session["LoginName"].ToString(), Session["CompanyID"].ToString(), BpID.SelectedItem.Text, url);
                    //Helpers.SendMailToUsersWithRole(subject, body, 30);

                    action = Actions.View;

                    Session["BpID"] = null;

                    PanelRegisterBp.Visible = false;
                    LoginPanel.Visible = true;
                    UserName.Focus();

                    Notification.Title = Resources.Resource.lblBuildingProject;
                    Notification.Text = Resources.Resource.msgCompanyRegToBp;
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "info";
                    Notification.AutoCloseDelay = 5000;
                    Notification.Show();
                    PanelNotification.Update();
                }
                catch (SqlException ex)
                {
                    logger.Error("SqlException: ", ex);
                    Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                    throw;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        protected void BpID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            InitCompany();
        }

        protected void InitCompany()
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT c.SystemID, c.BpID, c.CompanyID, ");
            sql.Append("c.NameVisible + (CASE WHEN c.NameAdditional IS NULL THEN '' ELSE ', ' + c.NameAdditional END) + (CASE WHEN a.City IS NULL THEN '' ELSE ', ' + a.City END) AS CompanyName ");
            sql.Append("FROM Master_Companies AS c ");
            sql.Append("INNER JOIN System_Addresses AS a ON c.SystemID = a.SystemID AND c.AddressID = a.AddressID ");
            sql.Append("WHERE (c.SystemID = @SystemID) AND (c.BpID = @BpID) AND NOT (c.ReleaseOn IS NULL) AND LockedOn IS NULL AND c.StatusID = 20 ");
            sql.Append("ORDER BY c.NameVisible");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(BpID.SelectedValue);
            cmd.Parameters.Add(par);

            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
                CompanyID.Items.Clear();
                CompanyID.DataSource = dt;
                CompanyID.DataBind();
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                throw;
            }
            finally
            {
                con.Close();
            }
        }

        protected void BtnRequestBp_Click(object sender, EventArgs e)
        {
            BtnRequestBp.Enabled = false;
            DoLogin(true);
        }

        protected void BtnRequestNewPassword_Click(object sender, EventArgs e)
        {
            if (!UserName1.Text.Equals(string.Empty) && CaptchaRequestNewPassword.IsValid)
            {
                logger.DebugFormat("User {0} wants to reset password", UserName.Text);
                Helpers.DialogLogger(type, 1, "0", String.Format("User {0} wants to reset password", UserName.Text));

                UserAssignments user = Helpers.GetUserWithLoginName(UserName1.Text);

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

                        PanelRegisterBp.Visible = false;
                        PanelResetPassword.Visible = false;
                        LoginPanel.Visible = true;
                        Helpers.Logout();
                        UserName.Focus();

                        Notification.Title = Resources.Resource.lblResetPassword;
                        Notification.Text = Resources.Resource.msgResendPassword;
                        Notification.AutoCloseDelay = 10000;
                        Notification.ShowSound = "none";
                        Notification.ContentIcon = "info";
                        Notification.Show();
                        PanelNotification.Update();
                    }
                }
            }
        }

        protected void BtnNewPassword_Click(object sender, EventArgs e)
        {
            BtnNewPassword.Enabled = false;
            users = SessionData.SomeData["User"] as UserAssignments[];
            currentPwd = SessionData.SomeData["CurrentPwd"].ToString();
            Notification.AutoCloseDelay = 5000;
            Notification.ShowSound = "none";
            Notification.Title = Resources.Resource.lblChangePwd;

            if (currentPwd.Equals(NewPwd.Text))
            {
                Notification.Text = Resources.Resource.msgPwdEqualsOld;
                Notification.ContentIcon = "warning";
            }
            if (!NewPwd.Text.Equals(NewPwdRepeat.Text))
            {
                Notification.Text = Resources.Resource.msgPwdNotEqual;
                Notification.ContentIcon = "warning";
            }
            else if (NewPwd.Text.Length < minPwdLength)
            {
                Notification.Text = String.Format(Resources.Resource.msgPwdLength, minPwdLength);
                Notification.ContentIcon = "warning";
            }
            else
            {
                Session["LoginName"] = users[0].LoginName;
                Session["UserID"] = users[0].UserID;
                Webservices webservice = new Webservices();
                int ret = webservice.UpdatePwd(currentPwd, NewPwd.Text);
                if (ret == 1)
                {
                    Notification.Text = Resources.Resource.msgPwdOldPwdFalse;
                    Notification.ContentIcon = "warning";
                }
                else
                {
                    Notification.Text = Resources.Resource.msgPwdChanged;
                    Notification.ContentIcon = "info";
                    NewPwd.Text = string.Empty;
                    NewPwdRepeat.Text = string.Empty;
                    foreach (UserAssignments user in users)
                    {
                        user.NeedsPwdChange = false;
                    }
                    SessionData.SomeData["User"] = users;

                    if (Session["BpID"] == null && users.Count() > 1)
                    {
                        // Select building project
                        logger.DebugFormat("User {0} needs to select building project", users[0].LoginName);

                        LoginPanel.Visible = false;
                        PanelNewPassword.Visible = false;
                        PanelBpSelect.Visible = true;
                        RadGridBpSelect.Rebind();
                    }
                    else
                    {
                        // Switch to building project
                        Session["BpID"] = users[0].BpID;
                        Master_BuildingProjects bp = webservice.GetBpInfo(Convert.ToInt32(Session["BpID"]));
                        Session["BpName"] = bp.NameVisible;
                        Helpers.SetUserSession(users[0]);
                        logger.DebugFormat("User {0} connected to building project {1}", users[0].LoginName, bp.NameVisible);
                        RadAjaxManager1.Redirect("Dashboard.aspx?Msg=Welcome");
                    }
                }
            }
            Notification.Show();
            PanelNotification.Update();
        }

        protected void CaptchaRequestNewPassword_CaptchaValidate(object sender, CaptchaValidateEventArgs e)
        {
            e.CancelDefaultValidation = false;
        }

        protected void RadGridBpSelect_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            UserAssignments[] users = (SessionData.SomeData["User"] as UserAssignments[]);
            RadGridBpSelect.DataSource = users;
        }

        protected void RadGridBpSelect_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.RowIndex == 0)
            {
                e.Item.Selected = false;
            }
        }

        private void ShowAsPopUp(string navigateUrl, string iconUrl, bool modal, string title)
        {
            if (iconUrl.Equals(string.Empty))
            {
                iconUrl = "/InSiteApp/Resources/Icons/TitleIcon.png";
            }
            else
            {
                iconUrl = iconUrl.Replace("~", "/InSiteApp");
            }

            StringBuilder script = new StringBuilder();
            script.AppendLine("function f(){");
            script.AppendLine("var radWindow = $find(\"" + RadWindowPopUp.ClientID + "\");");
            script.AppendLine("radWindow.setUrl(\"" + navigateUrl + "\");");
            script.AppendLine("radWindow.set_iconUrl(\"" + iconUrl + "\");");
            script.AppendLine("radWindow.set_title(\"" + title + "\");");
            if (modal)
            {
                script.AppendLine("radWindow.set_modal(true);");
            }
            else
            {
                script.AppendLine("radWindow.set_left(0);");
                script.AppendLine("radWindow.set_modal(false);");
            }
            script.AppendLine("radWindow.show();");
            script.AppendLine("Sys.Application.remove_load(f);");
            script.AppendLine("}");
            script.AppendLine("Sys.Application.add_load(f);");

            System.Web.UI.ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script.ToString(), true);
        }

        protected void GetHelp_Click(object sender, EventArgs e)
        {
            string url = "/InSiteApp" + (sender as RadButton).CommandArgument;
            ShowAsPopUp(url, "/InSiteApp/Resources/Icons/Help_16.png", false, Session["pageTitle"].ToString());
        }
    }
}