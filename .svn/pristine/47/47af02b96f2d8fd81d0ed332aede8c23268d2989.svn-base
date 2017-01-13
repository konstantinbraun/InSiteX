using InSite.App.Constants;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace InSite.App.Views
{
    public partial class RegisterCompanyCentralVerify : System.Web.UI.Page
    {
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        String msg = "";
        protected int companyID = 0;
        protected string loginName = "";

        protected void Page_Load(object sender, EventArgs e)
        {
            msg = Request.QueryString["CompanyID"];
            if (msg != null)
            {
                companyID = Convert.ToInt32(msg);
            }
            loginName = Request.QueryString["LoginName"];
            UpdateCompany();
        }

        protected string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void UpdateCompany()
        {
            Session["SystemID"] = 1;
            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE Master_Users ");
            sql.Append("SET RequestFrom = @LoginName, RequestOn = SYSDATETIME(), StatusID = @StatusID ");
            sql.Append("FROM System_Companies ");
            sql.Append("INNER JOIN Master_Users ON System_Companies.SystemID = Master_Users.SystemID AND System_Companies.UserID = Master_Users.UserID ");
            sql.Append("WHERE System_Companies.CompanyID = @CompanyID AND System_Companies.CreatedFrom = @LoginName AND System_Companies.StatusID = @StatusIDOld; ");
            sql.AppendLine();
            sql.Append("UPDATE System_Companies ");
            sql.Append("SET RequestFrom = @LoginName, ");
            sql.Append("RequestOn = SYSDATETIME(), ");
            sql.Append("StatusID = @StatusID ");
            sql.Append("WHERE CompanyID = @CompanyID ");
            sql.Append("AND CreatedFrom = @LoginName ");
            sql.Append("AND StatusID = @StatusIDOld; ");
            sql.AppendLine();
            sql.Append("SELECT @RowCount = @@ROWCOUNT; ");

            int rowCount = 0;

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                SqlCommand cmd = new SqlCommand(sql.ToString(), conn);

                SqlParameter par = new SqlParameter("@LoginName", SqlDbType.NVarChar, 50);
                par.Value = loginName;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                par.Value = companyID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = Status.WaitRelease;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusIDOld", SqlDbType.Int);
                par.Value = Status.CreatedNotConfirmed;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@RowCount", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(par);

                if (conn.State != ConnectionState.Open)
                {
                    conn.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();
                    rowCount = Convert.ToInt32(cmd.Parameters["@RowCount"].Value);

                    if (rowCount > 0)
                    { 
                        Helpers.DialogLogger(type, Actions.Edit, companyID.ToString(), Resources.Resource.lblActionEdit);

                        cmd = new SqlCommand("GetUserInfo", conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        par = new SqlParameter("@LoginName", SqlDbType.NVarChar, 50);
                        par.Value = loginName;
                        cmd.Parameters.Add(par);
                        SqlDataAdapter adapter = new SqlDataAdapter();
                        adapter.SelectCommand = cmd;
                    
                        DataTable dt = new DataTable();

                        try
                        {
                            adapter.Fill(dt);
                        }
                        catch (Exception ex)
                        {
                            logger.Error("Exception: " + ex.Message);
                            if (ex.InnerException != null)
                            {
                                logger.Error("Inner Exception: " + ex.InnerException.Message);
                            }
                            logger.Debug("Exception Details: \n" + ex);
                            throw;
                        }

                        if (dt.Rows.Count > 0)
                        {
                            DataRow dr = dt.Rows[0];

                            // Email an Admin
                            List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                            values.Add(new Tuple<string, string>("CompanyID", companyID.ToString()));
                            values.Add(new Tuple<string, string>("CompanyName", dr["NameVisible"].ToString()));
                            values.Add(new Tuple<string, string>("Description", dr["Description"].ToString()));
                            values.Add(new Tuple<string, string>("Address1", dr["Address1"].ToString()));
                            values.Add(new Tuple<string, string>("Address2", dr["Address2"].ToString()));
                            values.Add(new Tuple<string, string>("Zip", dr["Zip"].ToString()));
                            values.Add(new Tuple<string, string>("City", dr["City"].ToString()));
                            values.Add(new Tuple<string, string>("State", dr["State"].ToString()));
                            values.Add(new Tuple<string, string>("CountryName", dr["CountryName"].ToString()));
                            values.Add(new Tuple<string, string>("WWW", dr["WWW"].ToString()));
                            values.Add(new Tuple<string, string>("TradeAssociation", dr["TradeAssociation"].ToString()));
                            values.Add(new Tuple<string, string>("UserID", dr["UserID"].ToString()));
                            values.Add(new Tuple<string, string>("Salutation", dr["Salutation"].ToString()));
                            values.Add(new Tuple<string, string>("FirstName", dr["FirstName"].ToString()));
                            values.Add(new Tuple<string, string>("LastName", dr["LastName"].ToString()));
                            values.Add(new Tuple<string, string>("LanguageName", dr["LanguageName"].ToString()));
                            values.Add(new Tuple<string, string>("Phone", dr["Phone"].ToString()));
                            values.Add(new Tuple<string, string>("EmailUser", dr["Email"].ToString()));
                            values.Add(new Tuple<string, string>("LoginName", loginName));
                            string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Central/CompaniesCentral.aspx?CompanyID=" + companyID.ToString());
                            values.Add(new Tuple<string, string>("UrlCompany", url));
                            url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Central/Users.aspx?UserID=" + dr["UserID"].ToString());
                            values.Add(new Tuple<string, string>("UrlUser", url));

                            Tuple<string, string>[] valuesArray = values.ToArray();
                            Session["BpID"] = 1;
                            Master_Translations translation = Helpers.GetTranslation("ConfirmationEmail_RegisterCompanyAdmin", Helpers.CurrentLanguage(), valuesArray);
                            Session["BpID"] = 0;

                            string subject = translation.DescriptionTranslated;
                            string bodyText = translation.HtmlTranslated;
                            string userDuplicates = string.Empty;
                            string companyDuplicates = string.Empty;

                            int userID = Convert.ToInt32(dr["UserID"].ToString());

                            // Duplikatsuche Benutzer
                            GetUserDuplicates_Result[] users = Helpers.GetUserDuplicates(userID);
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

                            // Duplikatsuche Firmen
                            GetCompanyCentralDuplicates_Result[] companies = Helpers.GetCompanyCentralDuplicates(companyID);
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
                                bodyText += "<br />" + companyDuplicates;
                            }
                            if (userDuplicates != string.Empty)
                            {
                                bodyText += "<br />" + userDuplicates;
                            }
                            Session["BpID"] = 1;
                            Helpers.SendMailToUsersWithRole(subject, bodyText, 50, "ConfirmationEmail_RegisterCompanyAdmin", valuesArray);
                            Session["BpID"] = 0;

                            // Eintrag in Vorgangsverwaltung für Benutzer
                            string dialogName = GetGlobalResourceObject("Resource", Helpers.GetDialogResID("Users")).ToString();
                            string companyName = dr["NameVisible"].ToString();
                            string refName = dr["FirstName"].ToString() + " " + dr["LastName"].ToString();
                            Session["BpID"] = 1;
                            translation = Helpers.GetTranslation("PMHints_RegisterUser", Helpers.CurrentLanguage(), values.ToArray());
                            Session["BpID"] = 0;
                            string actionHint = translation.HtmlTranslated;
                            if (userDuplicates != string.Empty)
                            {
                                actionHint += userDuplicates;
                            }
                            Helpers.CreateProcessEvent("Users", dialogName, companyName, Actions.Release, userID, refName, actionHint, "PMHints_RegisterUser", valuesArray);

                            // Eintrag in Vorgangsverwaltung für Firma
                            dialogName = GetGlobalResourceObject("Resource", Helpers.GetDialogResID("CompaniesCentral")).ToString();
                            companyName = dr["NameVisible"].ToString();
                            refName = dr["NameVisible"].ToString();
                            values.Clear();
                            values.Add(new Tuple<string, string>("CompanyID", companyID.ToString()));
                            values.Add(new Tuple<string, string>("CompanyName", dr["NameVisible"].ToString()));
                            values.Add(new Tuple<string, string>("Description", dr["Description"].ToString()));
                            values.Add(new Tuple<string, string>("Address1", dr["Address1"].ToString()));
                            values.Add(new Tuple<string, string>("Address2", dr["Address2"].ToString()));
                            values.Add(new Tuple<string, string>("Zip", dr["Zip"].ToString()));
                            values.Add(new Tuple<string, string>("City", dr["City"].ToString()));
                            values.Add(new Tuple<string, string>("State", dr["State"].ToString()));
                            values.Add(new Tuple<string, string>("CountryName", dr["CountryName"].ToString()));
                            values.Add(new Tuple<string, string>("WWW", dr["WWW"].ToString()));
                            values.Add(new Tuple<string, string>("TradeAssociation", dr["TradeAssociation"].ToString()));
                            url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Central/CompaniesCentral.aspx?CompanyID=" + companyID.ToString());
                            values.Add(new Tuple<string, string>("UrlCompany", url));

                            Session["BpID"] = 1;
                            translation = Helpers.GetTranslation("PMHints_RegisterCompany", Helpers.CurrentLanguage(), values.ToArray());
                            Session["BpID"] = 0;
                            actionHint = translation.HtmlTranslated;
                            if (companyDuplicates != string.Empty)
                            {
                                actionHint += companyDuplicates;
                            }
                            Helpers.CreateProcessEvent("CompaniesCentral", dialogName, companyName, Actions.Release, companyID, refName, actionHint, "PMHints_RegisterCompany", valuesArray);
                        }
                    }
                }
                catch (SqlException ex)
                {
                    Helpers.DialogLogger(type, Actions.Edit, "0", ex.Message);
                    throw;
                }
                catch (System.Exception ex)
                {
                    Helpers.DialogLogger(type, Actions.Edit, "0", ex.Message);
                    throw;
                }
                finally
                {
                    conn.Close();
                }
            }

            if (rowCount == 0)
            {
                VerifyOK.Visible = false;
                VerifyFailed.Visible = true;
            }
            else
            {
                VerifyOK.Visible = true;
                VerifyFailed.Visible = false;
            }
        }
    }
}