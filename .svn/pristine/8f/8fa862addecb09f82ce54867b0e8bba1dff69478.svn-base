using InSite.App.Constants;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.UI;
using Telerik.Web.UI;

namespace InSite.App.Views
{
    public partial class RegisterCompanyCentral : System.Web.UI.Page
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private int action = Actions.View;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
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

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
        }

        protected string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
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

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (!Helpers.LoginNameIsUnique(LoginName.Text))
                {
                    Notification.Title = Resources.Resource.lblUser;
                    Notification.Text = Resources.Resource.msgLoginNameNotUnique;
                    Notification.Show();
                    LoginName.Focus();
                }
                else
                {
                    BtnOK.Enabled = false;
                    using (SqlConnection conn = new SqlConnection(ConnectionString))
                    {
                        Session["SystemID"] = 1;
                        int companyID = Helpers.GetNextID("CompanyCentralID");
                        int userID = Helpers.GetNextID("UserID");
                        List<Tuple<string, string>> values = new List<Tuple<string, string>>();

                        // Firma speichern
                        StringBuilder sql = new StringBuilder();
                        sql.Append("INSERT INTO System_Addresses (SystemID, Address1, Address2, Zip, City, State, CountryID, Phone, Email, WWW, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                        sql.Append("VALUES (@SystemID, @Address1, @Address2, @Zip, @City, @State, @CountryID, @Phone, @Email, @WWW, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()); ");
                        sql.AppendLine("SELECT @AddressID = SCOPE_IDENTITY(); ");
                        sql.Append("INSERT INTO System_Companies (SystemID, CompanyID, NameVisible, NameAdditional, Description, AddressID, IsVisible, IsValid, TradeAssociation, BlnSOKA, ");
                        sql.Append("UserID, StatusID, CreatedFrom, CreatedOn, EditFrom, EditOn, RequestFrom, MinWageAttestation, Soundex) ");
                        sql.Append("VALUES (@SystemID, @CompanyID, @NameVisible, @NameAdditional, '', @AddressID, 1, 1, @TradeAssociation, 1, @UserID, @StatusID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), ");
                        sql.AppendLine("@LoginName, @MinWageAttestation, dbo.SoundexGer(@NameVisible)); ");
                        sql.Append("INSERT INTO [System_CompanyTariffs] ([SystemID], [TariffScopeID], CompanyID, [ValidFrom], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) ");
                        sql.Append("VALUES (@SystemID, @TariffScopeID, @CompanyID, @ValidFrom, @UserName, SYSDATETIME(), @UserName, SYSDATETIME())");

                        SqlCommand cmd = new SqlCommand(sql.ToString(), conn);

                        cmd.Parameters.Add("@SystemID", SqlDbType.Int);
                        cmd.Parameters.Add("@CompanyID", SqlDbType.Int);
                        cmd.Parameters.Add("@Address1", SqlDbType.NVarChar, 100);
                        cmd.Parameters.Add("@Address2", SqlDbType.NVarChar, 100);
                        cmd.Parameters.Add("@Zip", SqlDbType.NVarChar, 20);
                        cmd.Parameters.Add("@City", SqlDbType.NVarChar, 100);
                        cmd.Parameters.Add("@State", SqlDbType.NVarChar, 100);
                        cmd.Parameters.Add("@CountryID", SqlDbType.NVarChar, 10);
                        cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 50);
                        cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 200);
                        cmd.Parameters.Add("@WWW", SqlDbType.NVarChar, 200);
                        cmd.Parameters.Add("@UserName", SqlDbType.NVarChar, 50);
                        SqlParameter par = new SqlParameter("@AddressID", SqlDbType.Int);
                        par.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(par);
                        cmd.Parameters.Add("@NameVisible", SqlDbType.NVarChar, 50);
                        cmd.Parameters.Add("@NameAdditional", SqlDbType.NVarChar, 200);
                        cmd.Parameters.Add("@TradeAssociation", SqlDbType.NVarChar, 200);
                        cmd.Parameters.Add("@MinWageAttestation", SqlDbType.Bit);
                        cmd.Parameters.Add("@UserID", SqlDbType.Int);
                        cmd.Parameters.Add("@StatusID", SqlDbType.Int);
                        cmd.Parameters.Add("@TariffScopeID", SqlDbType.Int);
                        cmd.Parameters.Add("@ValidFrom", SqlDbType.DateTime);
                        cmd.Parameters.Add("@LoginName", SqlDbType.NVarChar, 50);
                        par = new SqlParameter("@ReturnValue", SqlDbType.Int);
                        par.Direction = ParameterDirection.Output;
                        cmd.Parameters.Add(par);

                        cmd.Parameters["@SystemID"].Value = 1;
                        cmd.Parameters["@CompanyID"].Value = companyID;
                        cmd.Parameters["@Address1"].Value = Address1.Text;
                        cmd.Parameters["@Address2"].Value = Address2.Text;
                        cmd.Parameters["@Zip"].Value = Zip.Text;
                        cmd.Parameters["@City"].Value = City.Text;
                        cmd.Parameters["@State"].Value = State.Text;
                        cmd.Parameters["@CountryID"].Value = CountryID.SelectedValue;
                        cmd.Parameters["@Phone"].Value = string.Empty;
                        cmd.Parameters["@Email"].Value = string.Empty;
                        cmd.Parameters["@WWW"].Value = WWW.Text;
                        cmd.Parameters["@UserName"].Value = LoginName.Text;
                        cmd.Parameters["@NameVisible"].Value = NameVisible.Text;
                        cmd.Parameters["@NameAdditional"].Value = NameAdditional.Text;
                        cmd.Parameters["@TradeAssociation"].Value = TradeAssociation.Text;
                        cmd.Parameters["@MinWageAttestation"].Value = MinWageAttestation.Checked;
                        if (TariffScopeID.SelectedValue != null && !TariffScopeID.SelectedValue.Equals(string.Empty))
                        {
                            cmd.Parameters["@TariffScopeID"].Value = Convert.ToInt32(TariffScopeID.SelectedValue);
                        }
                        else
                        {
                            cmd.Parameters["@TariffScopeID"].Value = 0;
                        }
                        cmd.Parameters["@ValidFrom"].Value = ValidFrom.SelectedDate;
                        cmd.Parameters["@UserID"].Value = userID;
                        cmd.Parameters["@StatusID"].Value = Status.CreatedNotConfirmed;
                        cmd.Parameters["@LoginName"].Value = LoginName.Text;

                        Session["LoginName"] = LoginName.Text;
                        Session["UserID"] = userID;

                        if (conn.State != ConnectionState.Open)
                        {
                            conn.Open();
                        }
                        try
                        {
                            cmd.ExecuteNonQuery();

                            Helpers.DialogLogger(type, Actions.Create, companyID.ToString(), Resources.Resource.lblActionCreate);
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
                            conn.Close();
                        }

                        // Benutzer speichern
                        sql.Clear();
                        sql.Append("INSERT INTO Master_Users (SystemID, BpID, UserID, Salutation, FirstName, LastName, CompanyID, LoginName, Password, RoleID, LanguageID, ");
                        sql.Append("SkinName, Phone, Email, IsVisible, StatusID, CreatedFrom, CreatedOn, EditFrom, EditOn, Soundex) ");
                        sql.Append("VALUES (@SystemID, 0, @UserID, @Salutation, @FirstName, @LastName, @CompanyID, @LoginName, @Password, 0, @LanguageID, @SkinName, ");
                        sql.AppendLine("@Phone, @Email, 1, @StatusID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), dbo.SoundexGer(@LastName)) ");

                        cmd = new SqlCommand(sql.ToString(), conn);

                        cmd.Parameters.Add("@SystemID", SqlDbType.Int);
                        cmd.Parameters.Add("@UserID", SqlDbType.Int);
                        cmd.Parameters.Add("@Salutation", SqlDbType.NVarChar, 50);
                        cmd.Parameters.Add("@FirstName", SqlDbType.NVarChar, 50);
                        cmd.Parameters.Add("@LastName", SqlDbType.NVarChar, 50);
                        cmd.Parameters.Add("@CompanyID", SqlDbType.Int);
                        cmd.Parameters.Add("@LoginName", SqlDbType.NVarChar, 50);
                        cmd.Parameters.Add("@Password", SqlDbType.NVarChar, 200);
                        // cmd.Parameters.Add("@RoleID", SqlDbType.Int);
                        cmd.Parameters.Add("@LanguageID", SqlDbType.NVarChar, 10);
                        cmd.Parameters.Add("@SkinName", SqlDbType.NVarChar, 50);
                        cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 50);
                        cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 200);
                        // cmd.Parameters.Add("@IsVisible", SqlDbType.Bit);
                        cmd.Parameters.Add("@StatusID", SqlDbType.Int);
                        cmd.Parameters.Add("@UserName", SqlDbType.NVarChar, 50);

                        cmd.Parameters["@SystemID"].Value = 1;
                        cmd.Parameters["@UserID"].Value = userID;
                        cmd.Parameters["@Salutation"].Value = Salutation.Text;
                        cmd.Parameters["@FirstName"].Value = FirstName.Text;
                        cmd.Parameters["@LastName"].Value = LastName.Text;
                        cmd.Parameters["@CompanyID"].Value = companyID;
                        cmd.Parameters["@LoginName"].Value = LoginName.Text;
                        string hashedPassword = Helpers.HashPassword(Password.Text);
                        cmd.Parameters["@Password"].Value = hashedPassword;
                        // cmd.Parameters["@RoleID"].Value = Convert.ToInt32((insertItem["RoleID"].Controls[0] as RadComboBox).SelectedItem.Value);
                        string languageID = "";
                        if (LanguageID.SelectedItem != null)
                        {
                            languageID = LanguageID.SelectedValue;
                        }
                        cmd.Parameters["@LanguageID"].Value = languageID;
                        cmd.Parameters["@SkinName"].Value = "Office2010Silver";
                        cmd.Parameters["@Phone"].Value = Phone.Text;
                        cmd.Parameters["@Email"].Value = Email1.Text;
                        cmd.Parameters["@StatusID"].Value = Status.CreatedNotConfirmed;
                        // cmd.Parameters["@IsVisible"].Value = (insertItem["IsVisible"].Controls[0] as CheckBox).Checked;
                        cmd.Parameters["@UserName"].Value = LoginName.Text;

                        if (conn.State != ConnectionState.Open)
                        {
                            conn.Open();
                        }
                        try
                        {
                            cmd.ExecuteNonQuery();
                            if (userID != 0)
                            {
                                Helpers.DialogLogger(type, Actions.Create, userID.ToString(), Resources.Resource.lblActionCreate);

                                // Email an Benutzer
                                values.Clear();
                                values.Add(new Tuple<string, string>("CompanyID", companyID.ToString()));
                                values.Add(new Tuple<string, string>("CompanyName", NameVisible.Text));
                                values.Add(new Tuple<string, string>("Description", NameAdditional.Text));
                                values.Add(new Tuple<string, string>("Address1", Address1.Text));
                                values.Add(new Tuple<string, string>("Address2", Address2.Text));
                                values.Add(new Tuple<string, string>("Zip", Zip.Text));
                                values.Add(new Tuple<string, string>("City", City.Text));
                                values.Add(new Tuple<string, string>("State", State.Text));
                                values.Add(new Tuple<string, string>("CountryName", CountryID.SelectedItem.Text));
                                values.Add(new Tuple<string, string>("WWW", WWW.Text));
                                values.Add(new Tuple<string, string>("TradeAssociation", TradeAssociation.Text));
                                values.Add(new Tuple<string, string>("UserID", userID.ToString()));
                                values.Add(new Tuple<string, string>("Salutation", Salutation.Text));
                                values.Add(new Tuple<string, string>("FirstName", FirstName.Text));
                                values.Add(new Tuple<string, string>("LastName", LastName.Text));
                                values.Add(new Tuple<string, string>("LanguageName", languageID));
                                values.Add(new Tuple<string, string>("Phone", Phone.Text));
                                values.Add(new Tuple<string, string>("EmailUser", Email1.Text));
                                values.Add(new Tuple<string, string>("LoginName", LoginName.Text));

                                string url = Uri.EscapeUriString(ConfigurationManager.AppSettings["ViewsUrl"].ToString() + "/RegisterCompanyCentralVerify.aspx?CompanyID=" + companyID.ToString() + "&LoginName=" + LoginName.Text);
                                values.Add(new Tuple<string, string>("Url", url));

                                Tuple<string, string>[] valuesArray = values.ToArray();
                                Session["BpID"] = 1;
                                Master_Translations translation = Helpers.GetTranslation("ConfirmationEmail_VerifyEmailAddress", languageID, valuesArray);
                                Session["BpID"] = null;

                                string subject = translation.DescriptionTranslated;
                                string bodyText = translation.HtmlTranslated;

                                Helpers.SendMail(Email1.Text, subject, bodyText, true);

                                RadAjaxManager1.Redirect("~/Views/Login.aspx?Msg=CRS&Email=" + Email1.Text);
                            }
                            else
                            {
                                Notification.Title = Resources.Resource.lblCompanyMasterCentral;
                                Notification.Text = Resources.Resource.msgRegistrationFailed;
                                Notification.ContentIcon = "warning";
                                Notification.Show();
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
                            conn.Close();
                        }
                    }
                }
            }
        }

        protected void Email1_TextChanged(object sender, EventArgs e)
        {
            LoginName.Text = Email1.Text;
            Email2.Focus();
        }

        protected void TariffScopeID_ItemDataBound(object sender, Telerik.Web.UI.RadComboBoxItemEventArgs e)
        {
            if (e.Item.Index % 2 == 0)
            {
                e.Item.BackColor = Color.FromArgb(240, 240, 240);
            }
        }

        protected void GetHelp_Click(object sender, EventArgs e)
        {
            string url = "/InSiteApp" + (sender as RadButton).CommandArgument;
            ShowAsPopUp(url, "/InSiteApp/Resources/Icons/Help_16.png", false, Session["pageTitle"].ToString());
        }

        protected void ViewPrivacyStatement_Click(object sender, EventArgs e)
        {
            ShowAsPopUp("/InSiteApp/Views/HtmlViewer.aspx", "/InSiteApp/Resources/Icons/Help_16.png", false, Resources.Resource.lblPrivacyStatement);
        }
    }
}