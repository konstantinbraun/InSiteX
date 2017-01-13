using InSite.App.UserServices;
using System;
using System.Configuration;
using System.Linq;
using Telerik.Web.UI;
using System.Xml.Linq;
using System.Resources;
using System.Globalization;
using System.Reflection;
using Microsoft.Reporting.WebForms;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Net;
using InSite.App.CMServices;
using InSite.App.Constants;

namespace InSite.App.Views.Main
{
    public partial class PassActions : BasePagePopUp
    {
        string msg = "";
        // private InSiteServerOperationsClient opClient = new InSiteServerOperationsClient();

        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                msg = Request.QueryString["EmployeeID"];
                if (msg != null)
                {
                    Session["MyEmployeeID"] = msg;
                    EmployeeID.Text = msg;
                }

                LastName.Text = Request.QueryString["LastName"];

                FirstName.Text = Request.QueryString["FirstName"];

                msg = Request.QueryString["Action"];
                if (msg != null)
                {
                    Session["CurrentPassAction"] = msg;
                }

                if (Convert.ToInt32(Session["CurrentPassAction"]) == Actions.Print)
                {
                    Title = Resources.Resource.lblPassPrint;
                    BtnOK.Text = Resources.Resource.lblActionPrint;

                    LabelIDInternal.Visible = false;
                    IDInternal.Visible = false;
                    ValidatorIDInternal.Enabled = false;

                    LabelReaderState.Visible = false;
                    ReaderStatePanel.Visible = false;

                    LabelReplacementPassCaseID.Font.Bold = true;
                    LabelReason.Font.Bold = true;

                    Webservices webservice = new Webservices();
                    bool isFirstPass = webservice.IsFirstPass(Convert.ToInt32(Session["MyEmployeeID"]));

                    if (isFirstPass)
                    {
                        ReplacementPassCaseID.Enabled = false;
                        LabelReplacementPassCaseID.Font.Bold = false;
                        ValidatorReplacementPassCaseID.Enabled = false;
                        ValidatorReplacementPassCaseID.Visible = false;

                        Reason.Visible = false;
                        LabelReason.Visible = false;
                        ValidatorReason.Enabled = false;
                        ValidatorReason.Visible = false;

                        // Gültigkeit des Zutrittsrechts
                        GetEmployees_Result employee = webservice.GetEmployees(0, Convert.ToInt32(Session["MyEmployeeID"]), "", 0, 0)[0];
                        int accessRightValidDays = Convert.ToInt32(Session["AccessRightValidDays"]);
                        if (employee.AccessRightValidUntil == null)
                        {
                            AccessRightValidUntil.SelectedDate = DateTime.Now.AddDays(accessRightValidDays);
                        }
                        else
                        {
                            AccessRightValidUntil.SelectedDate = employee.AccessRightValidUntil;
                        }
                        AccessRightValidUntil.Visible = true;
                        LabelAccessRightValidUntil.Visible = true;
                        ValidatorAccessRightValidUntil.Enabled = true;
                        ValidatorAccessRightValidUntil.Visible = true;
                    }
                }
                else if (Convert.ToInt32(Session["CurrentPassAction"]) == Actions.Activate)
                {
                    Title = Resources.Resource.lblPassActivate;
                    BtnOK.Text = Resources.Resource.lblActionActivate;

                    LabelReplacementPassCaseID.Visible = false;
                    ReplacementPassCaseID.Visible = false;
                    ValidatorReplacementPassCaseID.Enabled = false;
                    ValidatorReplacementPassCaseID.Visible = false;

                    LabelReason.Visible = false;
                    Reason.Visible = false;
                    ValidatorReason.Enabled = false;
                    ValidatorReason.Visible = false;

                    LabelIDInternal.Font.Bold = true;
                }
                else if (Convert.ToInt32(Session["CurrentPassAction"]) == Actions.Deactivate)
                {
                    Title = Resources.Resource.lblPassDeactivate;
                    BtnOK.Text = Resources.Resource.lblActionDeactivate;

                    LabelReplacementPassCaseID.Visible = false;
                    ReplacementPassCaseID.Visible = false;
                    ValidatorReplacementPassCaseID.Enabled = false;
                    ValidatorReplacementPassCaseID.Visible = false;

                    LabelReason.Visible = false;
                    Reason.Visible = false;
                    ValidatorReason.Enabled = false;
                    ValidatorReason.Visible = false;

                    LabelIDInternal.Font.Bold = true;
                }
                else if (Convert.ToInt32(Session["CurrentPassAction"]) == Actions.Lock)
                {
                    Title = Resources.Resource.lblPassLock;
                    BtnOK.Text = Resources.Resource.lblActionLock;

                    LabelReplacementPassCaseID.Visible = false;
                    ReplacementPassCaseID.Visible = false;
                    ValidatorReplacementPassCaseID.Enabled = false;
                    ValidatorReplacementPassCaseID.Visible = false;

                    LabelIDInternal.Visible = false;
                    IDInternal.Visible = false;
                    ValidatorIDInternal.Enabled = false;
                    ValidatorIDInternal.Visible = false;

                    LabelReaderState.Visible = false;
                    ReaderStatePanel.Visible = false;

                    LabelReason.Font.Bold = true;
                }
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            Response.AppendHeader("Access-Control-Allow-Origin", "*");
            base.OnPreRender(e);
        }

        protected void UnloadMe()
        {
            string script = "<script language='javascript' type='text/javascript'>Sys.Application.add_load(cancelAndClose);</script>";
            RadScriptManager.RegisterStartupScript(this, this.GetType(), "cancelAndClose", script, false);
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            UnloadMe();
        }

        private static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            Webservices webservice = new Webservices();
            GetEmployees_Result employee = webservice.GetEmployees(0, Convert.ToInt32(Session["MyEmployeeID"]), "", 0, 0)[0];
            int currentPassAction = Convert.ToInt32(Session["CurrentPassAction"]);

            if (currentPassAction == Actions.Print)
            {
                int replacementPassCaseID = 0;
                if (!(ReplacementPassCaseID.SelectedValue.Equals(string.Empty)))
                {
                    replacementPassCaseID = Convert.ToInt32(ReplacementPassCaseID.SelectedValue);

                    if (Helpers.IsPassCaseFirstIssue(replacementPassCaseID))
                    {
                        int systemID = Convert.ToInt32(Session["SystemID"]);
                        int bpID = Convert.ToInt32(Session["BpID"]);

                        ContainerManagementClient client = new ContainerManagementClient();
                        try
                        {
                            client.EmployeeData(systemID, bpID, employee.EmployeeID, Actions.Insert);
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
                    }
                }

                ResourceManager rm = new ResourceManager("InSite.App.App_GlobalResources.AccessMessages", Assembly.GetExecutingAssembly());
                CultureInfo ci = CultureInfo.CreateSpecificCulture(employee.LanguageID);
                if (rm.GetString("admPassNotActive", ci).Equals(string.Empty))
                {
                    ci = CultureInfo.CreateSpecificCulture(Session["LanguageID"].ToString());
                }
                string deactivationMessage = rm.GetString("admPassNotActive", ci) + Environment.NewLine;

                PrintPass_Result result = webservice.PrintPass(employee.EmployeeID, replacementPassCaseID, Reason.Text, deactivationMessage);

                if (result != null)
                {
                    Barcoder barcoder = new Barcoder();
                    byte[] barcodeData = barcoder.Encode1D(result.ExternalID, 600, 100, "CODE_39");

                    // Barcode und Gültigeit des Zutrittsrechts speichern
                    StringBuilder sql = new StringBuilder();
                    sql.Append("UPDATE Master_Passes ");
                    sql.Append("SET BarcodeData = @BarcodeData ");
                    sql.Append("WHERE SystemID = @SystemID ");
                    sql.Append("AND BpID = @BpID ");
                    sql.AppendLine("AND EmployeeID = @EmployeeID; ");
                    sql.Append("UPDATE Master_Employees ");
                    sql.Append("SET AccessRightValidUntil = @AccessRightValidUntil ");
                    sql.Append("WHERE SystemID = @SystemID ");
                    sql.Append("AND BpID = @BpID ");
                    sql.AppendLine("AND EmployeeID = @EmployeeID; ");

                    SqlConnection con = new SqlConnection(ConnectionString);
                    SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                    SqlParameter par = new SqlParameter();

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BpID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["BpID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                    par.Value = result.EmployeeID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BarcodeData", SqlDbType.Image);
                    par.Value = barcodeData;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AccessRightValidUntil", SqlDbType.DateTime);
                    if (AccessRightValidUntil.SelectedDate != null)
                    {
                        par.Value = AccessRightValidUntil.SelectedDate;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
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

                    // Report erstellen
                    ReportViewer reportViewer = new ReportViewer();
                    reportViewer.ProcessingMode = ProcessingMode.Remote;

                    ServerReport serverReport = reportViewer.ServerReport;

                    // TODO Da gehört eine Fehlerbehandlung drum, falls der Bericht nicht gefunden wird
                    string reportName = webservice.GetEmployeePassTemplate(result.EmployeeID, Helpers.GetDialogID("Employees"));
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
                    reportPar.Name = "EmployeeID";
                    reportPar.Values.Add(result.EmployeeID.ToString());
                    serverReport.SetParameters(new ReportParameter[] { reportPar });

                    reportPar = new ReportParameter();
                    reportPar.Name = "PassCaseID";
                    reportPar.Values.Add(result.PassCaseID.ToString());
                    serverReport.SetParameters(new ReportParameter[] { reportPar });

                    byte[] reportData = serverReport.Render("PDF");

                    if (reportData != null)
                    {
                        // Report speichern
                        sql.Clear();
                        sql.Append("UPDATE Master_Passes ");
                        sql.Append("SET [FileName] = @FileName, ");
                        sql.Append("FileType = @FileType, ");
                        sql.Append("FileData = @FileData, ");
                        sql.Append("BarcodeData = @BarcodeData ");
                        sql.Append("WHERE SystemID = @SystemID ");
                        sql.Append("AND BpID = @BpID ");
                        sql.Append("AND EmployeeID = @EmployeeID ");

                        con = new SqlConnection(ConnectionString);
                        cmd = new SqlCommand(sql.ToString(), con);
                        par = new SqlParameter();

                        par = new SqlParameter("@SystemID", SqlDbType.Int);
                        par.Value = Convert.ToInt32(Session["SystemID"]);
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@BpID", SqlDbType.Int);
                        par.Value = Convert.ToInt32(Session["BpID"]);
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                        par.Value = result.EmployeeID;
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@FileName", SqlDbType.NVarChar, 200);
                        string fileName = Helpers.CleanFilename(String.Concat("Pass_", result.LastName, "_", result.FirstName, "_", result.ExternalID, "_", DateTime.Now.ToString("yyyyMMddHHmm"), ".pdf"));
                        par.Value = fileName;
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@FileType", SqlDbType.NVarChar, 50);
                        par.Value = "application/pdf";
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@FileData", SqlDbType.Image);
                        par.Value = reportData;
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@BarcodeData", SqlDbType.Image);
                        par.Value = barcodeData;
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

                        BtnOK.Enabled = false;

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
                GetPassInfo_Result[] info = Helpers.GetPassInfo(IDInternal.Text);
                if (info != null && info.Count() > 0)
                {
                    if ((bool)info[0].IsDuplicate || (currentPassAction == Actions.Activate && info[0].PassType == 1 && employee.EmployeeID != info[0].OwnerID))
                    {
                        // Nichts machen. Ausweis ist Duplikat
                        Notification1.Title = Resources.Resource.lblShortTermPasses;
                        Notification1.Text = Resources.Resource.msgPassDuplicate;
                        Notification1.ContentIcon = "warning";
                        Notification1.Show();
                    }
                    else
                    {
                        if (info[0].PassType == 2)
                        {
                            // Nichts machen. Ausweis ist Kurzzeitausweis
                            Notification1.Title = Resources.Resource.lblShortTermPasses;
                            Notification1.Text = Resources.Resource.msgShortTermPass;
                            Notification1.ContentIcon = "warning";
                            Notification1.Show();
                        }
                        else
                        {
                            if (currentPassAction == Actions.Activate)
                            {
                                webservice.ActivatePass(employee.EmployeeID, IDInternal.Text);
                            }
                            else if (currentPassAction == Actions.Deactivate)
                            {
                                webservice.DeactivatePass(employee.EmployeeID, IDInternal.Text, Reason.Text);
                            }
                            else if (currentPassAction == Actions.Lock)
                            {
                                webservice.LockPass(employee.EmployeeID, IDInternal.Text, Reason.Text);
                            }
                            BtnOK.Enabled = false;
                            UnloadMe();
                        }
                    }
                }
                else 
                {
                    if (currentPassAction == Actions.Activate)
                    {
                        webservice.ActivatePass(employee.EmployeeID, IDInternal.Text);
                    }
                    else if (currentPassAction == Actions.Deactivate)
                    {
                        webservice.DeactivatePass(employee.EmployeeID, IDInternal.Text, Reason.Text);
                    }
                    else if (currentPassAction == Actions.Lock)
                    {
                        webservice.LockPass(employee.EmployeeID, IDInternal.Text, Reason.Text);
                    }
                    BtnOK.Enabled = false;
                    UnloadMe();
                }
            }
        }

        //protected void CreateJob(PrintPass_Result result)
        //{
        //    InSiteJob myJob = new InSiteJob();
        //    myJob.SystemID = result.SystemID;
        //    myJob.UserID = Convert.ToInt32(Session["UserID"]);
        //    myJob.JobParameter = CreateParameter("EmployeePass", "pdf", result);
        //    myJob.JobName = "PrintEmployeePass";
        //    myJob.JobPriority = InSiteJobPriority.IMMEDIATE;
        //    opClient.CreateJob(myJob);
        //}
                    
        private string CreateParameter(string reportName, string reportType, PrintPass_Result result)
        {
            XElement myRoot = new XElement("InSiteJobParameter");
            XElement myReports = new XElement("Reports");
            myRoot.Add(myReports);
            string fileName = String.Concat("Pass_", result.EmployeeID.ToString(), "_", result.ExternalID, "_", DateTime.Now.ToString("yyyyMMddHHmm"));
            XElement myParams = new XElement("ReportParameter",
                new XElement("Parameter", result.SystemID.ToString(),
                    new XAttribute("Name", "SystemID")),
                new XElement("Parameter", result.BpID.ToString(),
                    new XAttribute("Name", "BpID")),
                new XElement("Parameter", result.EmployeeID.ToString(),
                    new XAttribute("Name", "EmployeeID")));
            XElement myReport = new XElement("Report",
                new XElement("ReportName", reportName),
                new XElement("ReportPath", String.Concat("B", Session["BpID"].ToString())),
                new XElement("SystemID", string.Format("{0:d02}", result.SystemID)),
                new XElement("DocumentType", reportType),
                new XElement("FileName", fileName),
                new XElement("MailBody", Resources.Resource.msgMailBody),
                new XElement("MailSubject", String.Concat(Resources.Resource.msgMailSubject, ": ", fileName, ".", reportType)),
                new XElement("Language", "de"),
                myParams);
            myReports.Add(myReport);
            string xmlStr = myRoot.ToString();
            logger.Debug(xmlStr);
            return xmlStr;
        }

        protected void ReplacementPassCaseID_ItemDataBound(object sender, RadComboBoxItemEventArgs e)
        {
            Webservices webservice = new Webservices();
            bool isFirstPass = webservice.IsFirstPass(Convert.ToInt32(Session["MyEmployeeID"]));

            if (isFirstPass && e.Item.Index == 0)
            {
                e.Item.Selected = true;
            }
        }
    }
}