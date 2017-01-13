using InSite.App.UserServices;
using System;
using System.Configuration;
using System.Linq;
using Telerik.Web.UI;
using System.Xml.Linq;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using Microsoft.Reporting.WebForms;
using InSite.App.Constants;

namespace InSite.App.Views.Main
{
    public partial class ShortTermPassActions : BasePagePopUp
    {
        string msg = "";
        int myEmployeeID = 0;
        // private InSiteServerOperationsClient opClient = new InSiteServerOperationsClient();

        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                msg = Request.QueryString["Action"];
                if (msg != null)
                {
                    Session["currentAction"] = Convert.ToInt32(msg);
                }

                if (Convert.ToInt32(Session["currentAction"]) == Actions.Print)
                {
                    this.Title = Resources.Resource.lblPrintShortTermPasses;
                    this.PanelAssign.Visible = false;
                    this.PanelPrint.Visible = true;
                    this.BtnOK.ValidationGroup = "Print";
                    this.PanelGrid.Visible = true;
                    this.BtnOK.Enabled = true;
                    this.BtnOK.OnClientClicked = "suspendAJAX";
                    this.ShortTermPassTypeID.Focus();
                }
                else if (Convert.ToInt32(Session["currentAction"]) == Actions.Assign)
                {
                    this.Title = Resources.Resource.lblAssignNewPasses;
                    this.PanelAssign.Visible = true;
                    this.PanelPrint.Visible = false;
                    this.BtnOK.ValidationGroup = "Assign";
                    this.BtnOK.Enabled = false;
                    this.BtnOK.OnClientClicked = "";
                    this.IDInternal.Focus();
                }

                this.BtnOK.Text = Actions.GetActionString(Convert.ToInt32(Session["currentAction"]));
                this.BtnOK.CausesValidation = true;

                msg = Request.QueryString["InternalID"];
                if (msg != null)
                {
                    IDInternal.Text = msg;
                    CheckPass();
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
            Session["currentAction"] = null;
            string script = "<script language='javascript' type='text/javascript'>Sys.Application.add_load(cancelAndClose);</script>";
            RadScriptManager.RegisterStartupScript(this, this.GetType(), "cancelAndClose", script, false);
            this.PanelAssign.Visible = false;
            this.PanelPrint.Visible = false;
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            SessionData.SomeData.Remove("ShortTermPassData");
            UnloadMe();
        }

        private static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        private void PassAction()
        {
            Webservices webservice = new Webservices();

            if (Convert.ToInt32(Session["currentAction"]) == Actions.Print)
            {
                int printID = webservice.PrintShortTermPasses(Convert.ToInt32(ShortTermPassTypeID.SelectedValue), Convert.ToInt32(PassCount.Text));

                RadGrid1.Rebind();

                // Report erstellen
                ReportViewer reportViewer = new ReportViewer();
                reportViewer.ProcessingMode = ProcessingMode.Remote;

                ServerReport serverReport = reportViewer.ServerReport;

                string reportName = webservice.GetShortTermPassTemplate(Convert.ToInt32(ShortTermPassTypeID.SelectedValue));
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
                reportPar.Name = "PrintID";
                reportPar.Values.Add(printID.ToString());
                serverReport.SetParameters(new ReportParameter[] { reportPar });

                byte[] reportData = serverReport.Render("PDF");

                if (reportData != null)
                {
                    // Report speichern
                    StringBuilder sql = new StringBuilder();
                    sql.Append("UPDATE Data_ShortTermPassesPrint ");
                    sql.Append("SET [FileName] = @FileName, ");
                    sql.Append("FileType = @FileType, ");
                    sql.Append("FileData = @FileData ");
                    sql.Append("WHERE SystemID = @SystemID ");
                    sql.Append("AND BpID = @BpID ");
                    sql.Append("AND PrintID = @PrintID ");

                    SqlConnection con = new SqlConnection(ConnectionString);
                    SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                    SqlParameter par = new SqlParameter();

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BpID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["BpID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@PrintID", SqlDbType.Int);
                    par.Value = printID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@FileName", SqlDbType.NVarChar, 200);
                    string fileName = Helpers.CleanFilename(String.Concat("ShortTermPasses_", Session["LoginName"].ToString(), "_", DateTime.Now.ToString("yyyyMMddHHmm"), ".pdf"));
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

                    // Report anzeigen
                    Response.Clear();
                    Response.AppendHeader("Content-Length", reportData.Length.ToString());
                    Response.ContentType = "application/pdf";
                    Response.AddHeader("content-disposition", "attachment;  filename=" + fileName);
                    Response.BinaryWrite(reportData);
                    Response.End();
                }
            }
            else if (Convert.ToInt32(Session["currentAction"]) == Actions.Assign)
            {
                if (RadGrid1.SelectedItems.Count > 0)
                {
                    int passAssigned = 0;
                    passAssigned = webservice.UpdateShortTermPass(Convert.ToInt32(Session["selectedPassID"]), IDInternal.Text);

                    if (passAssigned == 0)
                    {
                        Notification1.Title = Resources.Resource.lblActionAssign;
                        Notification1.Text = String.Format(Resources.Resource.msgPassAssigned, Session["selectedPassID"].ToString(), IDInternal.Text);
                        Notification1.ContentIcon = "info";
                        Notification1.Show();

                        RadGrid1.Rebind();
                        Helpers.ShortTermPassChanged(Convert.ToInt32(Session["selectedPassID"]));
                        BtnOK.Enabled = false;
                        IDInternal.Text = string.Empty;
                        IDInternal.Focus();
                    }
                    else
                    {
                        IDInternal.Focus();
                        Notification1.Title = Resources.Resource.lblActionAssign;
                        Notification1.Text = String.Format(Resources.Resource.msgInternalIDAlreadyAssigned, passAssigned.ToString());
                        Notification1.ContentIcon = "warning";
                        Notification1.Show();
                    }
                }
                else
                {
                    Notification1.Title = Resources.Resource.lblActionAssign;
                    Notification1.Text = Resources.Resource.msgPleaseSelect;
                    Notification1.ContentIcon = "warning";
                    Notification1.Show();
                }
            }
            else if (Convert.ToInt32(Session["currentAction"]) == Actions.Activate)
            {
                //webservice.ActivatePass(myEmployeeID, IDInternal.Text);
            }
            else if (Convert.ToInt32(Session["currentAction"]) == Actions.Deactivate)
            {
                //webservice.DeactivatePass(myEmployeeID, IDInternal.Text, Reason.Text);
            }
            else if (Convert.ToInt32(Session["currentAction"]) == Actions.Lock)
            {
                //webservice.LockPass(myEmployeeID, IDInternal.Text, Reason.Text);
            }
            // UnloadMe();
        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                PassAction();
            }
        }

        //protected void CreateJob()
        //{
        //    InSiteJob myJob = new InSiteJob();
        //    myJob.SystemID = Convert.ToInt32(Session["SystemID"]);
        //    myJob.UserID = Convert.ToInt32(Session["UserID"]);
        //    myJob.JobParameter = CreateParameter("ShortTermPass", "pdf");
        //    myJob.JobName = "PrintShortTermPass";
        //    myJob.JobPriority = InSiteJobPriority.IMMEDIATE;
        //    opClient.CreateJob(myJob);
        //}
                    
        private string CreateParameter(string reportName, string reportType)
        {
            XElement myRoot = new XElement("InSiteJobParameter");
            XElement myReports = new XElement("Reports");
            myRoot.Add(myReports);
            string fileName = String.Concat("ShortTermPass_", Session["LoginName"].ToString(), "_", DateTime.Now.ToString("yyyyMMddHHmm"));
            XElement myParams = new XElement("ReportParameter",
                new XElement("Parameter", Session["SystemID"].ToString(), new XAttribute("Name", "SystemID")),
                new XElement("Parameter", Session["BpID"].ToString(), new XAttribute("Name", "BpID")),
                new XElement("Parameter", Session["LoginName"].ToString(), new XAttribute("Name", "UserName")));
            XElement myReport = new XElement("Report",
                new XElement("ReportName", reportName),
                new XElement("ReportPath", String.Concat("B", Session["BpID"].ToString())),
                new XElement("SystemID", string.Format("{0:d02}", Convert.ToInt32(Session["SystemID"]))),
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

        protected void RadGrid1_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["selectedPassID"] = Convert.ToInt32((RadGrid1.SelectedItems[0] as GridDataItem).GetDataKeyValue("ShortTermPassID"));
            BtnOK.Enabled = true;
        }

        private void CheckPass()
        {
            if (IDInternal.Text.Equals(String.Empty))
            {
                Notification1.Title = Resources.Resource.lblActionPrint;
                Notification1.Text = String.Concat(Resources.Resource.lblChipID, " ", Resources.Resource.lblRequired);
                Notification1.ContentIcon = "info";
                Notification1.Show();
                IDInternal.Focus();
            }
            else
            {
                GetPassInfo_Result[] info = Helpers.GetPassInfo(IDInternal.Text);
                bool nextStep = true;
                if (info != null && info.Count() > 0)
                {
                    if ((bool)info[0].IsDuplicate)
                    {
                        // Nichts machen. Ausweis ist Duplikat
                        Notification1.Title = Resources.Resource.lblShortTermPasses;
                        Notification1.Text = Resources.Resource.msgPassDuplicate;
                        Notification1.ContentIcon = "warning";
                        Notification1.Show();
                        nextStep = false;

                    }
                    else if (Convert.ToInt32(Session["currentAction"]) == Actions.Assign)
                    {
                        if (info[0].PassType == 1)
                        {
                            // Nichts machen. Ausweis ist Mitarbeiterausweis
                            Notification1.Title = Resources.Resource.lblShortTermPasses;
                            Notification1.Text = Resources.Resource.msgEmployeePass;
                            Notification1.ContentIcon = "warning";
                            Notification1.Show();
                            nextStep = false;
                        }
                    }
                }

                if (nextStep)
                {
                    ShortTermPass pass = new ShortTermPass();
                    Webservices webservice = new Webservices();
                    pass = webservice.GetShortTermPass(IDInternal.Text);
                    if (pass != null && pass.ShortTermPassID != 0)
                    {
                        SessionData.SomeData["ShortTermPassData"] = pass;

                        int statusID = pass.StatusID;

                        if (statusID == Status.Printed)
                        {
                            // Fehler
                        }
                        else if (statusID == Status.Assigned)
                        {
                            // Besucher erfassen
                            UnloadMe();
                        }
                        else if (statusID == Status.Activated)
                        {
                            // Deaktivieren
                            UnloadMe();
                        }
                        else if (statusID == Status.Deactivated)
                        {
                            // Aktivieren oder Sperren
                            UnloadMe();
                        }
                        else if (statusID == Status.Locked)
                        {
                            // Nichts machen. Ausweis ist gesperrt
                            Notification1.Title = Resources.Resource.lblShortTermPasses;
                            Notification1.Text = String.Concat(Resources.Resource.lblPassLocked, ": ", pass.LockedFrom, " / ", pass.LockedOn);
                            Notification1.ContentIcon = "warning";
                            Notification1.Show();
                        }
                    }
                    else
                    {
                        SessionData.SomeData["ShortTermPassData"] = null;

                        // Ausweis zuordnen
                        PanelGrid.Visible = true;
                    }
                }
            }
        }

        protected void BtnCheck_Click(object sender, EventArgs e)
        {
            CheckPass();
        }

        protected void ShortTermPassPrint_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "DocDownloadCmd")
            {
                ShortTermPassPrint pass = Helpers.GetShortTermPassPrint(Convert.ToInt32(e.CommandArgument));
                if (pass.PrintID != 0)
                {
                    // Report anzeigen
                    Response.Clear();
                    Response.AppendHeader("Content-Length", pass.FileData.Length.ToString());
                    Response.ContentType = pass.FileType;
                    Response.AddHeader("content-disposition", "attachment;  filename=" + pass.FileName);
                    Response.BinaryWrite(pass.FileData);
                    Response.End();
                }
            }
        }
    }
}