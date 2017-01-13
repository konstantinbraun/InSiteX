using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using InSite.App.UserServices;
using Telerik.Web.UI;
using System.Collections.Generic;
using System.IO;
using System.Web.UI;
using InSite.App.Constants;

namespace InSite.App.Views
{
    public partial class RegisterEmployee : System.Web.UI.Page
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private int action = Actions.View;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        EmployeeRegistrationData data = new EmployeeRegistrationData();

        protected void Page_Load(object sender, EventArgs e)
        {
            data = (SessionData.SomeData["EmployeeRegistrationData"] as EmployeeRegistrationData);
            BuildingProject.Text = data.BpName;
            Company.Text = data.CompanyName;

            string path = ConfigurationManager.AppSettings["CaptchaAudio"].ToString() + "/Captcha." + Helpers.CurrentLanguage();

            if (Directory.Exists(Server.MapPath(path)))
            {
                RadCaptcha2.CaptchaImage.AudioFilesPath = path;
            }
            else
            {
                RadCaptcha2.CaptchaImage.AudioFilesPath = ConfigurationManager.AppSettings["CaptchaAudio"].ToString();
            }
        }

        public static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (!IsRadAsyncValid.Value)
                {
                    return;
                }

                BtnOK.Enabled = false;

                UploadedFile file = null;
                byte[] fileData = default(byte[]);
                Session["SystemID"] = data.SystemID;
                int employeeID = Helpers.GetNextID("EmployeeID");
                int addressID = Helpers.GetNextID("AddressID");

                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO Master_Addresses (SystemID, BpId, AddressID, Salutation, FirstName, LastName, Address1, Address2, Zip, City, State, CountryID, LanguageID, ");
                sql.Append("NationalityID, Phone, Email, BirthDate, PhotoFileName, PhotoData, CreatedFrom, CreatedOn, EditFrom, EditOn, Soundex) ");
                sql.Append("VALUES (@SystemID, @BpId, @AddressID, @Salutation, @FirstName, @LastName, @Address1, @Address2, @Zip, @City, @State, @CountryID, @LanguageID, ");
                sql.AppendLine("@NationalityID, @Phone, @Email, @BirthDate, @PhotoFileName, @PhotoData, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), dbo.SoundexGer(@LastName)); ");
                sql.Append("INSERT INTO Master_Employees (SystemID, BpID, EmployeeID, AddressID, CompanyID, TradeID, StaffFunction, EmploymentStatusID, MaxHrsPerMonth, ");
                sql.Append("AttributeID, Description, ExternalPassID, CreatedFrom, CreatedOn, EditFrom, EditOn, UserString1, UserString2, UserString3, UserString4, ");
                sql.Append("UserBit1, UserBit2, UserBit3, UserBit4, StatusID) ");
                sql.Append("VALUES (@SystemID, @BpID, @EmployeeID, @AddressID, @CompanyID, @TradeID, @StaffFunction, @EmploymentStatusID, @MaxHrsPerMonth, ");
                sql.Append("@AttributeID, @Description, @ExternalPassID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), @UserString1, @UserString2, @UserString3, ");
                sql.AppendLine("@UserString4, @UserBit1, @UserBit2, @UserBit3, @UserBit4, @StatusID); ");
                sql.Append("INSERT INTO Master_EmployeeRelevantDocuments (SystemID, BpID, EmployeeID, RelevantFor, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                sql.Append("SELECT r.SystemID, @BpID, @EmployeeID, r.RelevantFor, @UserName, SYSDATETIME(), @UserName, SYSDATETIME() ");
                sql.Append("FROM System_RelevantFor r ");
                sql.Append("WHERE r.SystemID = @SystemID ");
                sql.Append("AND NOT EXISTS (SELECT 1 FROM Master_EmployeeRelevantDocuments erd ");
                sql.AppendLine("WHERE erd.SystemID = @SystemID AND erd.BpID = @BpID AND erd.EmployeeID = @ReturnValue AND erd.RelevantFor = r.RelevantFor); ");

                int defaultAccessAreaID = Helpers.GetDefaultAccessAreaID(data.BpID);
                int defaultTimeSlotGroupID = Helpers.GetDefaultTimeSlotGroupID(data.BpID);
                if (defaultAccessAreaID > 0 && defaultTimeSlotGroupID > 0)
                {
                    sql.Append("INSERT INTO Master_EmployeeAccessAreas ");
                    sql.Append("(SystemID, BpID, EmployeeID, AccessAreaID, TimeSlotGroupID, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                    sql.Append("VALUES (@SystemID, @BpID, @EmployeeID, @AccessAreaID, @TimeSlotGroupID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) ");
                }

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = data.SystemID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = data.BpID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                par.Value = employeeID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AccessAreaID", SqlDbType.Int);
                par.Value = defaultAccessAreaID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@TimeSlotGroupID", SqlDbType.Int);
                par.Value = defaultTimeSlotGroupID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Salutation", SqlDbType.NVarChar, 50);
                par.Value = Salutation.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@FirstName", SqlDbType.NVarChar, 50);
                par.Value = FirstName.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LastName", SqlDbType.NVarChar, 50);
                par.Value = LastName.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Address1", SqlDbType.NVarChar, 100);
                par.Value = Address1.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Address2", SqlDbType.NVarChar, 100);
                par.Value = Address2.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Zip", SqlDbType.NVarChar, 20);
                par.Value = Zip.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@City", SqlDbType.NVarChar, 100);
                par.Value = City.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@State", SqlDbType.NVarChar, 100);
                par.Value = State.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CountryID", SqlDbType.NVarChar, 10);
                par.Value = CountryID.SelectedValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Phone", SqlDbType.NVarChar, 50);
                par.Value = Phone.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Email", SqlDbType.NVarChar, 200);
                par.Value = Email.Text;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BirthDate", SqlDbType.DateTime);
                if (BirthDate.SelectedDate != null)
                {
                    par.Value = BirthDate.SelectedDate;
                }
                else
                {
                    par.Value = DBNull.Value;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@NationalityID", SqlDbType.NVarChar, 10);
                par.Value = NationalityID.SelectedValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LanguageID", SqlDbType.NVarChar, 10);
                par.Value = LanguageID.SelectedValue;
                cmd.Parameters.Add(par);

                if (AsyncUpload1.UploadedFiles.Count > 0)
                {
                    file = AsyncUpload1.UploadedFiles[0];
                    fileData = new byte[file.InputStream.Length];
                    file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
                    Image img = Helpers.ByteArrayToImage(fileData);
                    img = Helpers.ScaleImage(img, 350, 450);
                    fileData = Helpers.ImageToByteArray(img, Helpers.ParseImageFormat(file.GetExtension()));
                }

                par = new SqlParameter("@PhotoFileName", SqlDbType.NVarChar, 200);
                if (AsyncUpload1.UploadedFiles.Count > 0)
                {
                    par.Value = Helpers.CleanFilename(file.GetName());
                }
                else
                {
                    par.Value = "";
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@PhotoData", SqlDbType.Image);
                if (AsyncUpload1.UploadedFiles.Count > 0)
                {
                    par.Value = fileData;
                }
                else
                {
                    par.Value = DBNull.Value;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = "System";
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AddressID", SqlDbType.Int);
                par.Value = addressID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                par.Value = data.CompanyID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@TradeID", SqlDbType.Int);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StaffFunction", SqlDbType.NVarChar, 100);
                par.Value = String.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@EmploymentStatusID", SqlDbType.Int);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@MaxHrsPerMonth", SqlDbType.Int);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AttributeID", SqlDbType.Int);
                // par.Value = Convert.ToInt32(AttributeID") as RadComboBox).SelectedValue);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Description", SqlDbType.NVarChar, 2000);
                par.Value = String.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ExternalPassID", SqlDbType.NVarChar, 50);
                par.Value = String.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString1", SqlDbType.NVarChar, 50);
                par.Value = String.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString2", SqlDbType.NVarChar, 50);
                par.Value = String.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString3", SqlDbType.NVarChar, 50);
                par.Value = String.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString4", SqlDbType.NVarChar, 50);
                par.Value = String.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit1", SqlDbType.Bit);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit2", SqlDbType.Bit);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit3", SqlDbType.Bit);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit4", SqlDbType.Bit);
                par.Value = 0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = Status.WaitReleaseCC;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ReturnValue", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(par);

                con.Open();
                try
                {
                    cmd.ExecuteNonQuery();

                    Helpers.DialogLogger(type, Actions.Create, employeeID.ToString(), Resources.Resource.lblActionCreate);

                    // Eintrag in Vorgangsverwaltung
                    string dialogName = "Employees";
                    string bpName = data.BpName;
                    string companyName = data.CompanyName;
                    string refName = FirstName.Text + " " + LastName.Text;
                    List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                    values.Add(new Tuple<string, string>("CompanyID", data.CompanyID.ToString()));
                    values.Add(new Tuple<string, string>("CompanyName", companyName));
                    values.Add(new Tuple<string, string>("BpName", bpName));
                    values.Add(new Tuple<string, string>("Salutation", Salutation.Text));
                    values.Add(new Tuple<string, string>("FirstName", FirstName.Text));
                    values.Add(new Tuple<string, string>("LastName", LastName.Text));
                    values.Add(new Tuple<string, string>("Address1", Address1.Text));
                    values.Add(new Tuple<string, string>("Address2", Address2.Text));
                    values.Add(new Tuple<string, string>("Zip", Zip.Text));
                    values.Add(new Tuple<string, string>("City", City.Text));
                    values.Add(new Tuple<string, string>("State", State.Text));
                    values.Add(new Tuple<string, string>("CountryName", CountryID.SelectedItem.Text));
                    values.Add(new Tuple<string, string>("Phone", Phone.Text));
                    values.Add(new Tuple<string, string>("Email", Email.Text));
                    values.Add(new Tuple<string, string>("BirthDate", BirthDate.SelectedDate.ToString()));
                    values.Add(new Tuple<string, string>("Nationality", NationalityID.SelectedItem.Text));
                    values.Add(new Tuple<string, string>("LanguageName", LanguageID.SelectedItem.Text));
                    Tuple<string, string>[] valuesArray = values.ToArray();

                    Master_Translations translation = Helpers.GetTranslation("PMHints_RegisterEmployee", Helpers.CurrentLanguage(), valuesArray);
                    string actionHint = translation.HtmlTranslated;

                    Session["BpID"] = data.BpID;

                    // Duplikatsuche
                    string employeeDuplicates = string.Empty;
                    GetEmployeeDuplicates_Result[] employees = Helpers.GetEmployeeDuplicates(employeeID);
                    if (employees != null && employees.Count() > 0)
                    {
                        StringBuilder duplicatesHint = new StringBuilder();
                        duplicatesHint.Append("<br />Mögliche Duplikate (Relevanz, Nachname, Vorname, Email, Geburtsdatum, PLZ):<br />");
                        duplicatesHint.Append("Possible duplicates (Relevance, Last name, First name, Email, Birth date, Zip):<br /><br />");
                        foreach (GetEmployeeDuplicates_Result employee in employees)
                        {
                            duplicatesHint.AppendFormat("{0}, {1}, {2}, {3}, {4}, {5}<br />", employee.Match.ToString(), employee.LastName, employee.FirstName, employee.Email, employee.BirthDate, employee.Zip);
                        }
                        employeeDuplicates = duplicatesHint.ToString();
                    }

                    if (!employeeDuplicates.Equals(string.Empty))
                    {
                        actionHint += employeeDuplicates;
                    }

                    // Recht Freigabe
                    GetCompanyInfo_Result[] companyInfo = Helpers.GetCompanyInfo(data.CompanyID);
                    int companyCentralID = 0;
                    if (companyInfo != null)
                    {
                        companyCentralID = companyInfo[0].CompanyCentralID;
                    }

                    Helpers.CreateProcessEvent("Employees", dialogName, companyName, Actions.Release, employeeID, refName, actionHint, companyCentralID, "PMHints_RegisterEmployee", valuesArray);

                    // Email an Mitarbeiter
                    translation = Helpers.GetTranslation("ConfirmationEmail_RegisterEmployee", LanguageID.SelectedItem.Value, valuesArray);

                    string subject = translation.DescriptionTranslated;
                    string bodyText = translation.HtmlTranslated;

                    if (!Email.Text.Equals(string.Empty))
                    {
                        Helpers.SendMail(Email.Text, subject, bodyText, true);
                    }

                    // Email an Firmenadministrator
                    GetCompanyAdminUserWithBP_Result[] result = Helpers.GetCompanyAdminUserWithBP(data.CompanyID);
                    if (result.Count() > 0)
                    {
                        string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/Main/Employees.aspx?ID=" + employeeID.ToString() + "&Action=" + Actions.Release.ToString());
                        values.Add(new Tuple<string, string>("Url", url));

                        valuesArray = values.ToArray();
                        translation = Helpers.GetTranslation("ConfirmationEmail_RegisterEmployeeAdmin", result[0].LanguageID, valuesArray);

                        subject = translation.DescriptionTranslated;
                        bodyText = translation.HtmlTranslated;

                        string email = result[0].Email;
                        if (!email.Equals(string.Empty))
                        {
                            if (!employeeDuplicates.Equals(string.Empty))
                            {
                                bodyText += "<br />" + employeeDuplicates;
                            }
                            Helpers.SendMail(email, subject, bodyText, true);
                        }
                    }

                    Session["BpID"] = null;

                    if (!Email.Text.Equals(string.Empty))
                    {
                        RadAjaxManager1.Redirect("~/Views/Login.aspx?Msg=ERS&amp;Email=" + Email.Text);
                    }
                    else
                    {
                        RadAjaxManager1.Redirect("~/Views/Login.aspx");
                    }
                }
                catch (SqlException ex)
                {
                    Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                    throw;
                }
                catch (System.Exception ex)
                {
                    Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                    throw;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        protected void RadCaptcha2_CaptchaValidate(object sender, Telerik.Web.UI.CaptchaValidateEventArgs e)
        {
            e.CancelDefaultValidation = false;
        }

        const int MaxTotalMBytes = 2; // 2 MB
        const int MaxTotalBytes = MaxTotalMBytes * 1024 * 1024;
        Int64 totalBytes;

        public bool? IsRadAsyncValid
        {
            get
            {
                if (Session["IsRadAsyncValid"] == null)
                {
                    Session["IsRadAsyncValid"] = true;
                }

                return Convert.ToBoolean(Session["IsRadAsyncValid"].ToString());
            }
            set
            {
                Session["IsRadAsyncValid"] = value;
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

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script.ToString(), true);
        }

        protected void GetHelp_Click(object sender, EventArgs e)
        {
            string url = "/InSiteApp" + (sender as RadButton).CommandArgument;
            ShowAsPopUp(url, "/InSiteApp/Resources/Icons/Help_16.png", false, Session["pageTitle"].ToString());
        }

        protected void ViewPrivacyStatement_Click(object sender, EventArgs e)
        {
            Session["SystemID"] = data.SystemID.ToString();
            Session["BpID"] = data.BpID.ToString();
            ShowAsPopUp("/InSiteApp/Views/HtmlViewer.aspx", "/InSiteApp/Resources/Icons/Help_16.png", false, Resources.Resource.lblPrivacyStatement);
            Session["SystemID"] = null;
            Session["BpID"] = null;
        }
    }
}