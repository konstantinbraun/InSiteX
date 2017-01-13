﻿using InSite.App.UserServices;
using InSite.App.AdminServices;
using System;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using Telerik.Web.UI;
using System.Web.Services.Protocols;
using InSite.App.Constants;

namespace InSite.App.Views.Reports
{
    public partial class SystemOverview : BasePagePopUp
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.Title = Resources.Resource.lblSystemOverview;
                this.ExecutionTime.SelectedDate = DateTime.Now;
                this.StartDate.SelectedDate = DateTime.Now.Date;
                this.StartDate.MinDate = DateTime.Now.Date;
                this.EndDate.MinDate = DateTime.Now.Date;

                Receiver.Entries.Insert(0, new AutoCompleteBoxEntry(Session["LoginName"].ToString(), Session["UserID"].ToString()));
            }
        }

        protected void UnloadMe()
        {
            Session["currentAction"] = null;
            string script = "<script language='javascript' type='text/javascript'>Sys.Application.add_load(cancelAndClose);</script>";
            RadScriptManager.RegisterStartupScript(this, this.GetType(), "cancelAndClose", script, false);
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            UnloadMe();
        }

        public String GetResource(String resourceName)
        {
            object res = GetGlobalResourceObject("Resource", resourceName);
            if (res != null)
            {
                return res.ToString();
            }
            else
            {
                return "";
            }
        }

        public static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void DayMo_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 0, (sender as CheckBox).Checked);
        }

        protected void DayTu_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 1, (sender as CheckBox).Checked);
        }

        protected void DayWe_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 2, (sender as CheckBox).Checked);
        }

        protected void DayTh_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 3, (sender as CheckBox).Checked);
        }

        protected void DayFr_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 4, (sender as CheckBox).Checked);
        }

        protected void DaySa_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 5, (sender as CheckBox).Checked);
        }

        protected void DaySu_CheckedChanged(object sender, EventArgs e)
        {
            RadTextBox tb = (sender as CheckBox).Parent.FindControl("ValidDays") as RadTextBox;
            tb.Text = GetValidDays(tb.Text, 6, (sender as CheckBox).Checked);
        }

        private string GetValidDays(string validDays, int dayPos, bool dayValid)
        {
            string dayValue;
            if (dayValid)
            {
                dayValue = "1";
            }
            else
            {
                dayValue = "0";
            }
            validDays = validDays.Remove(dayPos, 1).Insert(dayPos, dayValue);
            return validDays;
        }

        protected bool GetValidForDay(string validDays, int dayPos)
        {
            string dayValue = validDays.Substring(dayPos, 1);
            return (dayValue == "1");
        }

        protected void ExecutionInterval_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            switch (e.Value)
            {
                case "0":
                    PanelWeekly.Visible = false;
                    PanelMonthly.Visible = false;
                    break;
                case "1":
                    PanelWeekly.Visible = false;
                    PanelMonthly.Visible = false;
                    break;
                case "2":
                    PanelWeekly.Visible = true;
                    PanelMonthly.Visible = false;
                    break;
                case "3":
                    PanelWeekly.Visible = false;
                    PanelMonthly.Visible = true;
                    break;
                default:
                    PanelWeekly.Visible = false;
                    PanelMonthly.Visible = false;
                    break;
            }
        }

        protected void EvaluationPeriod_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (e.Value.Equals("1"))
            {
                StatisticsDate.Enabled = true;
            }
            else
            {
                StatisticsDate.Enabled = false;
            }
        }

        private string CreateReportParameter(
            string reportName,
            string reportType,
            int bpID,
            int evaluationPeriod,
            DateTime statisticsDate,
            string comment,
            string evaluationPeriodName,
            string templateName)
        {
            XElement xeReport = new XElement("Report");
            xeReport.Add(new XElement("ReportName", reportName));
            string reportPath = String.Concat("/InSite/S", Session["SystemID"].ToString(), "/B", Session["BpID"].ToString());
            xeReport.Add(new XElement("ReportPath", reportPath));
            xeReport.Add(new XElement("ExportFormat", reportType));
            xeReport.Add(new XElement("Language", "de"));

            XElement xeReportParameters = new XElement("ReportParameters");
            xeReportParameters.Add(new XElement("Parameter", Session["SystemID"].ToString(), new XAttribute("Name", "SystemID")));
            xeReportParameters.Add(new XElement("Parameter", BpID.SelectedValue, new XAttribute("Name", "BpID")));
            xeReportParameters.Add(new XElement("Parameter", evaluationPeriod.ToString(), new XAttribute("Name", "EvaluationPeriod")));
            xeReportParameters.Add(new XElement("Parameter", statisticsDate, new XAttribute("Name", "StatisticsDate")));
            xeReportParameters.Add(new XElement("Parameter", comment, new XAttribute("Name", "Comment")));
            xeReportParameters.Add(new XElement("Parameter", evaluationPeriodName, new XAttribute("Name", "EvaluationPeriodName")));
            xeReportParameters.Add(new XElement("Parameter", templateName, new XAttribute("Name", "TemplateName")));
            xeReportParameters.Add(new XElement("Parameter", Session["LoginName"].ToString(), new XAttribute("Name", "UserName")));

            xeReport.Add(xeReportParameters);

            string xmlString = xeReport.ToString();
            return xmlString;
        }

        private System_Jobs CreateJob(
            int frequency,
            string validDays,
            int dayOfMonth,
            DateTime? dateBegin,
            DateTime? dateEnd,
            TimeSpan startTime,
            string jobParameter,
            string receiver,
            string remarks)
        {
            System_Jobs job = new System_Jobs();
            job.SystemID = Convert.ToInt32(Session["SystemID"]);
            job.BpID = Convert.ToInt32(BpID.SelectedValue);
            job.NameVisible = Resources.Resource.lblPresenceReport;
            if (remarks.Length > 200)
            {
                job.Description = remarks.Substring(0, 196) + " ...";
            }
            else
            {
                job.Description = remarks;
            }
            job.JobType = JobType.Report;
            job.UserID = Convert.ToInt32(Session["UserID"]);
            job.Frequency = frequency;
            job.RepeatEvery = 1;
            if (frequency == JobFrequency.Weekly)
            {
                job.ValidDays = validDays;
            }
            else
            {
                job.ValidDays = string.Empty;
            }
            if (frequency == JobFrequency.Monthly)
            {
                job.DayOfMonth = dayOfMonth;
            }
            else
            {
                job.DayOfMonth = 0;
            }
            job.DateBegin = dateBegin;
            job.DateEnd = dateEnd;
            job.StartTime = startTime;
            job.StatusID = Status.Created;
            job.JobParameter = jobParameter;
            job.JobLanguage = Helpers.CurrentLanguage();
            job.Receiver = receiver;
            job.CreatedFrom = Session["LoginName"].ToString();
            job.CreatedOn = DateTime.Now;
            job.EditFrom = Session["LoginName"].ToString();
            job.EditOn = DateTime.Now;

            int jobID = 0;
            AdminServiceClient adminService = new AdminServiceClient();
            try
            {
                jobID = adminService.InsertJob(job);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }
            if (jobID == 0)
            {
                return null;
            }
            else
            {
                job.JobID = jobID;
                return job;
            }
        }

        protected void OK_Click(object sender, EventArgs e)
        {
            OK.Enabled = false;

            int bpID = 0;
            if (!BpID.SelectedValue.Equals(string.Empty))
            {
                bpID = Convert.ToInt32(BpID.SelectedValue);
            }

            int evaluationPeriod = 0;
            if (!EvaluationPeriod.SelectedValue.Equals(string.Empty))
            {
                evaluationPeriod = Convert.ToInt32(EvaluationPeriod.SelectedValue);
            }

            DateTime statisticsDate = new DateTime(2000, 1, 1, 0, 0, 0);
            if (StatisticsDate.SelectedDate != null)
            {
                statisticsDate = (DateTime)StatisticsDate.SelectedDate;
            }

            if (!TemplateID.SelectedValue.Equals(string.Empty))
            {
                string reportParameter = CreateReportParameter(
                    TemplateID.SelectedValue,
                    ExportFormat.SelectedValue,
                    bpID,
                    evaluationPeriod,
                    statisticsDate,
                    Remarks.Text,
                    EvaluationPeriod.SelectedItem.Text,
                    TemplateID.SelectedItem.Text);

                DateTime nextStart = (DateTime)StartDate.SelectedDate + (TimeSpan)ExecutionTime.SelectedTime;
                long diff = (long)(nextStart - DateTime.Now).TotalMinutes;

                if (ExecutionInterval.SelectedValue.Equals("0") && diff < 5)
                {
                    // Report sofort ausführen
                    Document report = Helpers.RenderReport(reportParameter);

                    // Report herunterladen
                    if (report != null && report.FileData != null && report.DocumentID == 0)
                    {
                        Response.Clear();
                        Response.AppendHeader("Content-Length", report.FileData.Length.ToString());
                        Response.ContentType = report.FileType;
                        string fileDate = DateTime.Now.ToString("yyyyMMddHHmm");
                        Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblSystemOverview + "_" + fileDate + "." + report.FileExtension));
                        Response.BinaryWrite(report.FileData);
                        Response.End();
                    }
                    else if (report != null)
                    {
                        Notification1.Title = Resources.Resource.lblSystemOverview;
                        Notification1.Text = string.Concat(Resources.Resource.lblError, ": ", report.Comment);
                        Notification1.ContentIcon = "warning";
                        Notification1.ShowSound = "warning";
                        Notification1.AutoCloseDelay = 0;
                        Notification1.Show();
                    }
                    else
                    { 
                    }
                }
                else
                {
                    // Reportausführung als Job anlegen
                    int frequency = Convert.ToInt32(ExecutionInterval.SelectedValue);

                    string validDays = string.Empty;
                    if (frequency == JobFrequency.Weekly)
                    {
                        validDays = ValidDays.Text;
                    }

                    int dayOfMonth = 0;
                    if (frequency == JobFrequency.Monthly)
                    {
                        dayOfMonth = Convert.ToInt32(DayOfMonth.SelectedValue);
                    }

                    string receiver = string.Empty;
                    if (Receiver.Entries.Count > 0)
                    {
                        // Empfänger für Job Ergebnis übernehmen
                        if (Receiver.Entries[0].Value.Equals(string.Empty) && Helpers.IsValidEmail(Receiver.Entries[0].Text))
                        {
                            receiver += Receiver.Entries[0].Text;
                        }
                        else
                        {
                            receiver += Receiver.Entries[0].Value;
                        }

                        for (int i = 1; i < Receiver.Entries.Count; i++)
                        {
                            AutoCompleteBoxEntry entry = Receiver.Entries[i];
                            if (entry.Value.Equals(string.Empty) && Helpers.IsValidEmail(entry.Text))
                            {
                                receiver += string.Concat(";", entry.Text);
                            }
                            else
                            {
                                receiver += string.Concat(";", entry.Value);
                            }
                        }
                    }

                    // Job anlegen
                    System_Jobs job = CreateJob(
                        frequency,
                        validDays,
                        dayOfMonth,
                        StartDate.SelectedDate,
                        EndDate.SelectedDate,
                        (TimeSpan)ExecutionTime.SelectedTime,
                        reportParameter,
                        receiver,
                        Remarks.Text);
                    
                    if (job != null)
                    {
                        // Erste Jobausführung initialisieren
                        int statusID = 0;
                        AdminServiceClient adminService = new AdminServiceClient();
                        try
                        {
                            statusID = adminService.RefreshJob(job);
                        }
                        catch (SoapException ex)
                        {
                            logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                        }
                        catch (Exception ex)
                        {
                            logger.ErrorFormat("Webservice error: {0}", ex.Message);
                        }

                        // Benutzer benachrichtigen
                        if (statusID == Status.WaitExecute)
                        {
                            try
                            {
                                job = adminService.GetJob(Convert.ToInt32(Session["SystemID"]), job.JobID);
                            }
                            catch (SoapException ex)
                            {
                                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                            }
                            catch (Exception ex)
                            {
                                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                            }

                            Notification1.Title = Resources.Resource.lblSystemOverview;
                            Notification1.Text = string.Format(Resources.Resource.msgJobCreated, job.JobID, ((DateTime)job.NextStart).ToString("G"));
                            Notification1.ContentIcon = "info";
                            Notification1.ShowSound = "";
                            Notification1.AutoCloseDelay = 5000;
                            Notification1.Show();
                        }
                    }
                }
            }

            OK.Enabled = true;
        }

        protected void BpID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            // Vorlagen für diese Verarbeitung auswählen
            TemplateID.SelectedIndex = -1;
            TemplateID.Items.Clear();
            TemplateID.Text = "";
            bool selected = false;

            GetTemplates_Result[] templates = Helpers.GetTemplates(type.Name, false, Convert.ToInt32(BpID.SelectedValue));
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

                if (!selected)
                {
                    TemplateID.Items[0].Selected = true;
                }
            }

            TemplateID.DataBind();
        }
    }
}