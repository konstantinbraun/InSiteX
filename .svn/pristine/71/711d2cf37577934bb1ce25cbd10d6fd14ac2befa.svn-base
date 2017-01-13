using InSite.App.Constants;
using InSite.App.AdminServices;
using InSite.App.UserServices;
using OfficeOpenXml;
using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web.Services.Protocols;
using System.Web.UI.WebControls;
using System.Xml.Linq;
using Telerik.Web.UI;
using Telerik.Windows.Documents.Model;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.Pdf;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.Pdf.Export;
using Telerik.Windows.Documents.Spreadsheet.Model;

namespace InSite.App.Views.Reports
{
    public partial class TariffData : BasePagePopUp
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        string selType = string.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            string msg = Request.QueryString["Sel"];
            if (msg != null)
            {
                selType = msg;
            }

            if (selType.Equals("Tariff"))
            {
                PanelTariff.Visible = true;
                PanelCompany.Visible = false;
                this.TariffID.Focus();
                this.Title = Resources.Resource.lblReportTariffData;
            }
            else if (selType.Equals("Company"))
            {
                PanelTariff.Visible = false;
                PanelCompany.Visible = true;
                this.CompanyID.Focus();
                this.Title = Resources.Resource.lblReportTariffCompany;
            }

            if (!IsPostBack)
            {
                TariffID.Text = string.Empty;
                TariffContractID.Text = string.Empty;
                TariffScopeID.Text = string.Empty;
                this.ExecutionTime.SelectedDate = DateTime.Now;
                this.StartDate.SelectedDate = DateTime.Now.Date;
                this.StartDate.MinDate = DateTime.Now.Date;
                this.EndDate.MinDate = DateTime.Now.Date;

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

                    if (!selected)
                    {
                        TemplateID.Items[0].Selected = true;
                    }
                    TemplateID.DataBind();
                }

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

        public static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            int tariffID = 0;
            if (!TariffID.SelectedValue.Equals(string.Empty))
            {
                tariffID = Convert.ToInt32(TariffID.SelectedValue);
            }

            int tariffContractID = 0;
            if (!TariffContractID.SelectedValue.Equals(string.Empty))
            {
                tariffContractID = Convert.ToInt32(TariffContractID.SelectedValue);
            }

            int tariffScopeID = 0;
            if (!TariffScopeID.SelectedValue.Equals(string.Empty))
            {
                tariffScopeID = Convert.ToInt32(TariffScopeID.SelectedValue);
            }

            int bpID = Convert.ToInt32(Session["BpID"]);

            int companyID = 0;
            if (!CompanyID.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(CompanyID.SelectedValue);
            }

            DateTime dateFrom = new DateTime(2000, 1, 1, 0, 0, 0);
            if (DateTimeFrom.SelectedDate != null)
            {
                dateFrom = (DateTime)DateTimeFrom.SelectedDate;
            }

            DateTime dateUntil = new DateTime(2100, 12, 31, 23, 59, 59);
            if (DateTimeUntil.SelectedDate != null)
            {
                dateUntil = (DateTime)DateTimeUntil.SelectedDate;
            }

            int reportType = 0;
            if (tariffID != 0)
            {
                reportType = 1;
            }

            Webservices webservice = new Webservices();
            GetTariffData_Result[] result = webservice.GetTariffData(tariffID, tariffContractID, tariffScopeID, bpID, companyID, dateFrom, dateUntil, reportType);

            if (result == null || result.Count() == 0)
            {
                Notification1.Title = Resources.Resource.lblReportTariffData;
                Notification1.Text = Resources.Resource.msgNoDataFound;
                Notification1.ContentIcon = "info";
                Notification1.Show();
            }
            else
            {
                int colCount = 7;

                int templateID = 0;
                if (!TemplateID.SelectedValue.Equals(string.Empty))
                {
                    templateID = Convert.ToInt32(TemplateID.SelectedValue);
                }
                ExcelPackage pck;
                if (templateID > 0)
                {
                    Master_Templates template = Helpers.GetTemplate(templateID);
                    Stream streamTemplate = new MemoryStream(template.FileData);
                    Stream streamOutput = new MemoryStream();
                    pck = new ExcelPackage(streamOutput, streamTemplate);
                }
                else
                {
                    pck = new ExcelPackage();
                }

                pck.Workbook.Properties.Title = Resources.Resource.lblReportTariffData;
                pck.Workbook.Properties.Author = Session["LoginName"].ToString();
                if (Session["CompanyID"] != null && Convert.ToInt32(Session["CompanyID"]) > 0)
                {
                    pck.Workbook.Properties.Company = Helpers.GetCompanyName(Convert.ToInt32(Session["CompanyID"]));
                }
                pck.Workbook.Properties.Manager = Resources.Resource.appName;

                // Kopfdaten
                ExcelWorksheet ws;
                if (templateID > 0)
                {
                    ws = pck.Workbook.Worksheets[Resources.Resource.lblParameters];
                }
                else
                {
                    ws = pck.Workbook.Worksheets.Add(Resources.Resource.lblParameters);
                }

                // Überschrift
                if (selType.Equals("Tariff"))
                {
                    ws.Cells[1, 1].Value = Resources.Resource.lblReportTariffData;
                }
                else if (selType.Equals("Company"))
                {
                    ws.Cells[1, 1].Value = Resources.Resource.lblReportTariffCompany;
                }
                ws.Cells[1, 1].Style.Font.Bold = true;
                ws.Cells[1, 1].Style.Font.Size = 16;

                ws.Cells[3, 1].Value = Resources.Resource.lblSystem + ":";
                ws.Cells[3, 2].Value = Session["SystemID"].ToString();

                ws.Cells[4, 1].Value = Resources.Resource.lblBuildingProject + ":";
                ws.Cells[4, 2].Value = Session["BpName"].ToString();

                ws.Cells[5, 1].Value = Resources.Resource.lblTariff + ":";
                if (TariffID.SelectedValue != null && !TariffID.SelectedValue.Equals(string.Empty))
                {
                    ws.Cells[5, 2].Value = TariffID.SelectedItem.Text;
                }

                ws.Cells[6, 1].Value = Resources.Resource.lblTariffContract + ":";
                if (TariffContractID.SelectedValue != null && !TariffContractID.SelectedValue.Equals(string.Empty))
                {
                    ws.Cells[6, 2].Value = TariffContractID.SelectedItem.Text;
                }

                ws.Cells[7, 1].Value = Resources.Resource.lblTariffScope + ":";
                if (TariffScopeID.SelectedValue != null && !TariffScopeID.SelectedValue.Equals(string.Empty))
                {
                    ws.Cells[7, 2].Value = TariffScopeID.SelectedItem.Text;
                }

                ws.Cells[8, 1].Value = Resources.Resource.lblBuildingProject + ":";
                ws.Cells[8, 2].Value = Session["BpID"];

                ws.Cells[9, 1].Value = Resources.Resource.lblCompany + ":";
                if (CompanyID.SelectedValue != null && !CompanyID.SelectedValue.Equals(string.Empty))
                {
                    ws.Cells[9, 2].Value = CompanyID.SelectedText;
                }

                ws.Cells[10, 1].Value = Resources.Resource.lblValidFrom + ":";
                if (DateTimeFrom.SelectedDate != null)
                {
                    ws.Cells[10, 2].Value = DateTimeFrom.SelectedDate.ToString();
                    ws.Cells[10, 2].Style.Numberformat.Format = "DDD, DD.MM.YYYY hh:mm";
                    ws.Cells[10, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[11, 1].Value = Resources.Resource.lblValidTo + ":";
                if (DateTimeUntil.SelectedDate != null)
                {
                    ws.Cells[11, 2].Value = DateTimeUntil.SelectedDate.ToString();
                    ws.Cells[11, 2].Style.Numberformat.Format = "DDD, DD.MM.YYYY hh:mm";
                    ws.Cells[11, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[12, 1].Value = Resources.Resource.lblTemplate + ":";
                ws.Cells[12, 2].Value = TemplateID.SelectedItem.Text;

                ws.Cells[13, 1].Value = Resources.Resource.lblRemarks + ":";
                ws.Cells[13, 2].Value = Remarks.Text;
                ws.Cells[13, 2].Style.WrapText = true;

                ws.Cells[14, 1].Value = Resources.Resource.lblState + ":";
                ws.Cells[14, 2].Value = DateTime.Now.ToString("ddd, dd.MM.yyyy HH:mm");

                ws.Cells[15, 1].Value = Resources.Resource.lblUser + ":";
                ws.Cells[15, 2].Value = Session["LoginName"].ToString();

                ExcelRange parameters = ws.Cells[1, 1, 15, 2];
                parameters.AutoFitColumns();

                Helpers.ProtectWorksheet(ref ws);

                // Detaildaten
                if (templateID > 0)
                {
                    ws = pck.Workbook.Worksheets[Resources.Resource.lblData];
                }
                else
                {
                    ws = pck.Workbook.Worksheets.Add(Resources.Resource.lblData);
                }

                // Kopfzeile
                ws.Cells[1, 1].Value = Resources.Resource.lblTariff;
                ws.Cells[1, 2].Value = Resources.Resource.lblTariffContract;
                ws.Cells[1, 3].Value = Resources.Resource.lblTariffScope;
                ws.Cells[1, 4].Value = Resources.Resource.lblTariffWageGroup;
                ws.Cells[1, 5].Value = Resources.Resource.lblTariffWage;
                ws.Cells[1, 6].Value = Resources.Resource.lblValidFrom;
                ws.Cells[1, 7].Value = Resources.Resource.lblAmount;

                int rowNum = 1;
                foreach (GetTariffData_Result tariff in result)
                {
                    rowNum++;

                    ws.Cells[rowNum, 1].Value = tariff.TariffName;
                    ws.Cells[rowNum, 2].Value = tariff.TariffContractName;
                    ws.Cells[rowNum, 3].Value = tariff.TariffScopeName;
                    ws.Cells[rowNum, 4].Value = tariff.TariffWageGroupName;
                    ws.Cells[rowNum, 5].Value = tariff.TariffWageName;
                    ws.Cells[rowNum, 6].Value = tariff.TariffWageValidFrom;
                    ws.Cells[rowNum, 6].Style.Numberformat.Format = "DD.MM.YYYY";
                    ws.Cells[rowNum, 7].Value = tariff.TariffWage.ToString();
                    ws.Cells[rowNum, 7].Style.Numberformat.Format = "#.##0,00";
                }

                // Autofilter und autofit
                ExcelRange dataCells = ws.Cells[1, 1, rowNum + 1, colCount];
                dataCells.AutoFilter = true;
                dataCells.AutoFitColumns();

                // Kopfzeile fett und fixiert
                ExcelRange headLine = ws.Cells[1, 1, 1, colCount];
                headLine.Style.Font.Bold = true;
                ws.View.FreezePanes(2, 1);

                Helpers.ProtectWorksheet(ref ws);

                // Alles aktualisieren wg. nachfolgender Blätter
                pck.Workbook.Calculate();

                string fileDate = DateTime.Now.ToString("yyyyMMddHHmm");
                string command = (sender as RadButton).CommandArgument;
                byte[] fileData = null;
                string suffix;
                string content;

                if (command.Equals("Pdf"))
                {
                    MemoryStream output = new MemoryStream();
                    XlsxFormatProvider formatProvider = new XlsxFormatProvider();
                    Workbook workbook = formatProvider.Import(pck.GetAsByteArray());

                    workbook.Worksheets[1].WorksheetPageSetup.PaperType = PaperTypes.A4;
                    workbook.Worksheets[1].WorksheetPageSetup.PageOrientation = PageOrientation.Landscape;
                    // workbook.Worksheets[1].WorksheetPageSetup.ScaleFactor = new Size(0.5, 0.5);
                    workbook.Worksheets[1].WorksheetPageSetup.CenterHorizontally = true;

                    PdfFormatProvider pdfFormatProvider = new PdfFormatProvider();
                    pdfFormatProvider.ExportSettings = new PdfExportSettings(ExportWhat.EntireWorkbook, true);
                    pdfFormatProvider.Export(workbook, output);

                    fileData = output.ToArray();
                    suffix = "pdf";
                    content = "application/pdf";
                }
                else
                {
                    fileData = pck.GetAsByteArray();
                    suffix = "xlsx";
                    content = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                }

                Response.Clear();
                Response.AppendHeader("Content-Length", fileData.Length.ToString());
                Response.ContentType = content;
                if (selType.Equals("Tariff"))
                {
                    Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblReportTariffData + "_" + fileDate + "." + suffix));
                }
                else if (selType.Equals("Company"))
                {
                    Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblReportTariffCompany + "_" + fileDate + "." + suffix));
                }
                Response.BinaryWrite(fileData);
                Response.End();
            }
        }

        protected void TariffID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            TariffContractID.Text = string.Empty;
            TariffContractID.Items.Clear();
            TariffContractID.DataBind();
            TariffScopeID.Text = string.Empty;
            TariffScopeID.Items.Clear();
            TariffScopeID.DataBind();
        }

        protected void TariffContractID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            TariffScopeID.Text = string.Empty;
            TariffScopeID.Items.Clear();
            TariffScopeID.DataBind();
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

        private string CreateReportParameter(
            string reportName,
            string reportType,
            int reportVariant,
            int tariffID, 
            int tariffContractID,
            int tariffScopeID, 
            int companyID,
            int evaluationPeriod,
            DateTime dateFrom,
            DateTime dateUntil,
            string comment,
            string tariffName,
            string tariffContractName,
            string tariffScopeName,
            string companyName,
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
            xeReportParameters.Add(new XElement("Parameter", Session["BpID"].ToString(), new XAttribute("Name", "BpID")));
            xeReportParameters.Add(new XElement("Parameter", reportVariant.ToString(), new XAttribute("Name", "ReportVariant")));
            xeReportParameters.Add(new XElement("Parameter", tariffID.ToString(), new XAttribute("Name", "TariffID")));
            xeReportParameters.Add(new XElement("Parameter", tariffContractID.ToString(), new XAttribute("Name", "TariffContractID")));
            xeReportParameters.Add(new XElement("Parameter", tariffScopeID.ToString(), new XAttribute("Name", "TariffScopeID")));
            xeReportParameters.Add(new XElement("Parameter", companyID.ToString(), new XAttribute("Name", "CompanyID")));
            xeReportParameters.Add(new XElement("Parameter", evaluationPeriod.ToString(), new XAttribute("Name", "EvaluationPeriod")));
            xeReportParameters.Add(new XElement("Parameter", dateFrom, new XAttribute("Name", "DateFrom")));
            xeReportParameters.Add(new XElement("Parameter", dateUntil, new XAttribute("Name", "DateUntil")));
            xeReportParameters.Add(new XElement("Parameter", comment, new XAttribute("Name", "Comment")));
            xeReportParameters.Add(new XElement("Parameter", tariffName, new XAttribute("Name", "TariffName")));
            xeReportParameters.Add(new XElement("Parameter", tariffContractName, new XAttribute("Name", "TariffContractName")));
            xeReportParameters.Add(new XElement("Parameter", tariffScopeName, new XAttribute("Name", "TariffScopeName")));
            xeReportParameters.Add(new XElement("Parameter", companyName, new XAttribute("Name", "CompanyName")));
            xeReportParameters.Add(new XElement("Parameter", evaluationPeriodName, new XAttribute("Name", "EvaluationPeriodName")));
            xeReportParameters.Add(new XElement("Parameter", Session["BpName"].ToString(), new XAttribute("Name", "BpName")));
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
            job.BpID = Convert.ToInt32(Session["BpID"]);
            job.NameVisible = Resources.Resource.lblReportTariffData;
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

            int tariffID = 0;
            if (!TariffID.SelectedValue.Equals(string.Empty))
            {
                tariffID = Convert.ToInt32(TariffID.SelectedValue);
            }

            int tariffContractID = 0;
            if (!TariffContractID.SelectedValue.Equals(string.Empty))
            {
                tariffContractID = Convert.ToInt32(TariffContractID.SelectedValue);
            }

            int tariffScopeID = 0;
            if (!TariffScopeID.SelectedValue.Equals(string.Empty))
            {
                tariffScopeID = Convert.ToInt32(TariffScopeID.SelectedValue);
            }

            int bpID = Convert.ToInt32(Session["BpID"]);

            int companyID = 0;
            if (!CompanyID.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(CompanyID.SelectedValue);
            }

            int evaluationPeriod = 0;
            if (!EvaluationPeriod.SelectedValue.Equals(string.Empty))
            {
                evaluationPeriod = Convert.ToInt32(EvaluationPeriod.SelectedValue);
            }

            DateTime dateFrom = new DateTime(2000, 1, 1, 0, 0, 0);
            if (DateTimeFrom.SelectedDate != null)
            {
                dateFrom = (DateTime)DateTimeFrom.SelectedDate;
            }

            DateTime dateUntil = new DateTime(2100, 12, 31, 23, 59, 59);
            if (DateTimeUntil.SelectedDate != null)
            {
                dateUntil = (DateTime)DateTimeUntil.SelectedDate;
            }

            int reportVariant = 0;
            if (PanelTariff.Visible)
            {
                reportVariant = 1;
            }

            string tariffName = Resources.Resource.lblAll;
            if (TariffID.SelectedItem != null &&  !TariffID.SelectedItem.Text.Equals(string.Empty))
            {
                tariffName = TariffID.SelectedItem.Text;
            }

            string tariffContractName = Resources.Resource.lblAll;
            if (TariffContractID.SelectedItem != null && !TariffContractID.SelectedItem.Text.Equals(string.Empty))
            {
                tariffContractName = TariffContractID.SelectedItem.Text;
            }

            string tariffScopeName = Resources.Resource.lblAll;
            if (TariffScopeID.SelectedItem != null && !TariffScopeID.SelectedItem.Text.Equals(string.Empty))
            {
                tariffScopeName = TariffScopeID.SelectedItem.Text;
            }

            string companyName = Resources.Resource.lblAll;
            if (!CompanyID.SelectedText.Equals(string.Empty))
            {
                companyName = CompanyID.SelectedText;
            }

            if (!TemplateID.SelectedValue.Equals(string.Empty))
            {
                string reportParameter = CreateReportParameter(
                    TemplateID.SelectedValue,
                    ExportFormat.SelectedValue,
                    reportVariant,
                    tariffID, 
                    tariffContractID, 
                    tariffScopeID, 
                    companyID,
                    evaluationPeriod,
                    dateFrom,
                    dateUntil,
                    Remarks.Text,
                    tariffName,
                    tariffContractName,
                    tariffScopeName,
                    companyName,
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
                        Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblReportTariffData + "_" + fileDate + "." + report.FileExtension));
                        Response.BinaryWrite(report.FileData);
                        Response.End();
                    }
                    else if (report != null)
                    {
                        Notification1.Title = Resources.Resource.lblReportTariffData;
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

                            Notification1.Title = Resources.Resource.lblReportTariffData;
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

        protected void EvaluationPeriod_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            if (e.Value.Equals("1"))
            {
                LabelValid.ForeColor = System.Drawing.Color.Black;
                LabelValid1.ForeColor = System.Drawing.Color.Black;
                LabelValid2.ForeColor = System.Drawing.Color.Black;
                DateTimeFrom.Enabled = true;
                DateTimeUntil.Enabled = true;
            }
            else
            {
                LabelValid.ForeColor = System.Drawing.Color.Gray;
                LabelValid1.ForeColor = System.Drawing.Color.Gray;
                LabelValid2.ForeColor = System.Drawing.Color.Gray;
                DateTimeFrom.Enabled = false;
                DateTimeUntil.Enabled = false;
                DateTimeFrom.SelectedDate = null;
                DateTimeUntil.SelectedDate = null;
            }
        }
    }
}