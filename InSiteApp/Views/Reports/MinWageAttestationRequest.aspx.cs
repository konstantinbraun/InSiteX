using InSite.App.Constants;
using InSite.App.UserServices;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI;
using Telerik.Web.UI;

namespace InSite.App.Views.Reports
{
    public partial class MinWageAttestationRequest : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, false);

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

            if (!IsPostBack)
            {
                this.MonthUntil.MaxDate = DateTime.Now.AddMonths(-1);
                this.MonthUntil.SelectedDate = DateTime.Now.AddMonths(-1);
                RadGrid1.DataSource = GetReportMinWageData();
                RadGrid1.DataBind();
                RefreshCompanyInfo();

                // Vorlagen für diese Verarbeitung auswählen
                TemplateID.Items.Clear();
                bool selected = false;

                GetTemplates_Result[] templates = Helpers.GetTemplates(type.Name, false);
                if (templates != null)
                {
                    foreach (GetTemplates_Result template in templates)
                    {
                        RadComboBoxItem item = new RadComboBoxItem();
                        item.Text = template.NameVisible;
                        item.Value = template.FileName;
                        if (template.IsDefault && !selected)
                        {
                            selected = true;
                            item.Selected = selected;
                        }
                        TemplateID.Items.Add(item);
                    }
                }
                if (!selected)
                {
                    TemplateID.Items[0].Selected = true;
                }
                TemplateID.DataBind();
            }
        }

        protected void MonthUntil_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
            RadGrid1.DataBind();
        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            // Report erstellen
            int companyID = 0;
            if (!CompanyID.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(CompanyID.SelectedValue.Split(',')[0]);
            }

            Master_CompanyContacts contact = Helpers.GetCompanyMWContact(companyID);
            if (contact != null)
            {
                DateTime monthUntil = DateTime.Now.AddMonths(-1);
                if (MonthUntil.SelectedDate != null)
                {
                    monthUntil = Helpers.EndOfMonth(Convert.ToDateTime(MonthUntil.SelectedDate));
                }

                int requestID = 0;

                // Reportdaten anlegen
                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO Data_MWAttestationRequest ");
                sql.Append("(SystemID, BpID, CompanyID, MWMonth, CreatedFrom, CreatedOn) ");
                sql.AppendLine("VALUES (@SystemID, @BpID, @CompanyID, @MonthUntil, @UserName, SYSDATETIME()); ");
                sql.AppendLine("SELECT @ReturnValue = SCOPE_IDENTITY(); ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["BpID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                par.Value = companyID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@MonthUntil", SqlDbType.DateTime);
                par.Value = monthUntil;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ReturnValue", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();

                    requestID = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);

                    Helpers.DialogLogger(type, Actions.Create, requestID.ToString(), Resources.Resource.lblActionCreate);
                }
                catch (SqlException ex)
                {
                    logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                    throw;
                }
                catch (System.Exception ex)
                {
                    logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                    if (ex.InnerException != null)
                    {
                        logger.Error("Inner Exception: " + ex.InnerException.Message);
                    }
                    logger.Debug("Exception Details: \n" + ex);
                    throw;
                }
                finally
                {
                    con.Close();
                }

                if (requestID != 0)
                {
                    // Report erstellen
                    ReportViewer reportViewer = new ReportViewer();
                    reportViewer.ProcessingMode = ProcessingMode.Remote;

                    ServerReport serverReport = reportViewer.ServerReport;

                    string reportName = TemplateID.SelectedValue;
                    serverReport.ReportServerUrl = new Uri(ConfigurationManager.AppSettings["ReportServerUrl"].ToString());
                    serverReport.ReportPath = string.Concat("/Insite/S", Session["SystemID"].ToString(), "/B", Session["BpID"].ToString(), "/", reportName);
                    string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
                    string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
                    string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
                    ReportServerCredentials clientCredentials = new ReportServerCredentials(userName, userPwd, userDomain);
                    serverReport.ReportServerCredentials = clientCredentials;

                    ReportParameter reportPar = new ReportParameter();
                    reportPar.Name = "SystemID";
                    reportPar.Values.Add(Session["SystemID"].ToString());
                    serverReport.SetParameters(new ReportParameter[] { reportPar });

                    reportPar = new ReportParameter();
                    reportPar.Name = "BpID";
                    reportPar.Values.Add(Session["BpID"].ToString());
                    serverReport.SetParameters(new ReportParameter[] { reportPar });

                    reportPar = new ReportParameter();
                    reportPar.Name = "MonthUntil";
                    reportPar.Values.Add(monthUntil.ToShortDateString());
                    serverReport.SetParameters(new ReportParameter[] { reportPar });

                    reportPar = new ReportParameter();
                    reportPar.Name = "CompanyID";
                    reportPar.Values.Add(companyID.ToString());
                    serverReport.SetParameters(new ReportParameter[] { reportPar });

                    reportPar = new ReportParameter();
                    reportPar.Name = "RequestID";
                    reportPar.Values.Add(requestID.ToString());
                    serverReport.SetParameters(new ReportParameter[] { reportPar });

                    byte[] reportData = serverReport.Render("PDF");

                    if (reportData != null)
                    {
                        // Report speichern
                        sql.Clear();
                        sql.Append("UPDATE Data_MWAttestationRequest ");
                        sql.Append("SET [FileName] = @FileName, ");
                        sql.Append("FileType = @FileType, ");
                        sql.Append("FileData = @FileData ");
                        sql.Append("WHERE SystemID = @SystemID ");
                        sql.Append("AND BpID = @BpID ");
                        sql.Append("AND RequestID = @RequestID ");

                        cmd = new SqlCommand(sql.ToString(), con);

                        par = new SqlParameter("@SystemID", SqlDbType.Int);
                        par.Value = Convert.ToInt32(Session["SystemID"]);
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@BpID", SqlDbType.Int);
                        par.Value = Convert.ToInt32(Session["BpID"]);
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@RequestID", SqlDbType.Int);
                        par.Value = requestID;
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@FileName", SqlDbType.NVarChar, 200);
                        string fileName = Helpers.CleanFilename(Resources.Resource.lblMWAttestationRequest + "_" + DateTime.Now.ToString("yyyyMMddHHmm") + ".pdf");
                        par.Value = fileName;
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@FileType", SqlDbType.NVarChar, 50);
                        par.Value = "application/pdf";
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@FileData", SqlDbType.Image);
                        par.Value = reportData;
                        cmd.Parameters.Add(par);

                        if (con.State != ConnectionState.Open)
                        {
                            con.Open();
                        }
                        try
                        {
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
                            if (ex.InnerException != null)
                            {
                                logger.Error("Inner Exception: " + ex.InnerException.Message);
                            }
                            logger.Debug("Exception Details: \n" + ex);
                            throw;
                        }
                        finally
                        {
                            con.Close();
                        }

                        if (contact.Email != null && !contact.Email.Equals(string.Empty))
                        {
                            // Mail an Ansprechpartner ML
                            Helpers.SendMail(contact.Email, Resources.Resource.lblMWAttestationRequest, Resources.Resource.msgMWAttestationRequest, false, fileName, "application/pdf", reportData);
                        }

                        // Grid aktualisieren
                        RadGrid1.DataSource = GetReportMinWageData();
                        RadGrid1.Rebind();

                        // Report anzeigen
                        Response.Clear();
                        Response.AppendHeader("Content-Length", reportData.Length.ToString());
                        Response.ContentType = "application/pdf";
                        Response.AddHeader("content-disposition", "attachment;  filename=" + fileName);
                        Response.BinaryWrite(reportData);
                        Response.End();
                    }
                }
            }
            else
            {
                Helpers.Notification(this.Page.Master, Resources.Resource.lblMWAttestationRequest, Resources.Resource.msgMWContactMissing);
            }
        }

        private GetMWAttestationRequests_Result[] GetReportMinWageData()
        {
            int companyID = 0;
            if (!CompanyID.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(CompanyID.SelectedValue.Split(',')[0]);
            }

            Webservices webservice = new Webservices();
            GetMWAttestationRequests_Result[] result = webservice.GetMWAttestationRequests(companyID, 0);

            return result;
        }

        private void RefreshCompanyInfo()
        {
            int companyID = 0;
            if (!CompanyID.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(CompanyID.SelectedValue.Split(',')[0]);
            }

            if (companyID == 0)
            {
                PanelCompanyInfo.Visible = false;
            }
            else
            {
                PanelCompanyInfo.Visible = true;

                GetCompanyInfo_Result[] result = Helpers.GetCompanyInfo(companyID);
                if (result != null)
                {
                    CompanyName.Text = result[0].NameVisible;
                    Address.Text = result[0].Address1;
                    Zip.Text = result[0].Zip;
                    City.Text = result[0].City;
                    ClientID.Text = result[0].ClientCompanyID.ToString();
                    Client.Text = result[0].ClientNameVisible;
                }
            }
        }

        protected void RadGrid1_ItemCreated(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridFilteringItem)
            {
                GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                if (filteringItem != null)
                {
                    LiteralControl literal = filteringItem["MWMonth"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["MWMonth"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";

                    literal = filteringItem["CreatedOn"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["CreatedOn"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
                }
            }
        }

        protected void RadGrid1_NeedDataSource(object sender, Telerik.Web.UI.GridNeedDataSourceEventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName.Equals("GetFile"))
            {
                int requestID = Convert.ToInt32(e.CommandArgument);

                Webservices webservice = new Webservices();
                GetMWAttestationRequests_Result[] result = webservice.GetMWAttestationRequests(0, requestID);
                if (result.Count() > 0 && result[0].FileData != null)
                {
                    Response.Clear();
                    Response.AppendHeader("Content-Length", result[0].FileData.Length.ToString());
                    Response.ContentType = result[0].FileType;
                    Response.AddHeader("content-disposition", "attachment; filename=" + result[0].FileName);
                    Response.BinaryWrite(result[0].FileData);
                    Response.End();
                }
            }
        }

        protected void CompanyID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
            RadGrid1.DataBind();
            RefreshCompanyInfo();
        }
    }
}