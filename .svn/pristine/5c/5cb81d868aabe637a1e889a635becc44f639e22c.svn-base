using InSite.App.UserServices;
using InSite.App.AdminServices;
using OfficeOpenXml;
using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web.UI.WebControls;
using System.Windows;
using System.Xml.Linq;
using Telerik.Web.UI;
using Telerik.Windows.Documents.Model;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.Pdf;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.Pdf.Export;
using Telerik.Windows.Documents.Spreadsheet.Model;
using Telerik.Windows.Documents.Spreadsheet.Model.Printing;
using System.Web.Services.Protocols;
using InSite.App.Constants;

namespace InSite.App.Views.Reports
{
    public partial class PresenceReport : BasePagePopUp
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.Title = Resources.Resource.lblPresenceReport;
                this.DateTimeFrom.MaxDate = DateTime.Now.AddDays(-1);
                this.DateTimeUntil.MaxDate = DateTime.Now.AddDays(-1);
                this.CompanyID.Focus();
                this.ExecutionTime.SelectedDate = DateTime.Now;
                this.StartDate.SelectedDate = DateTime.Now.Date;
                this.StartDate.MinDate = DateTime.Now.Date;
                this.EndDate.MinDate = DateTime.Now.Date;

                // Zutrittsbereiche nur bei Anwesenheitsvariante 3 auswählbar
                int presenceLevel = Convert.ToInt32(Session["PresenceLevel"]);
                if (presenceLevel == 3)
                {
                    LabelAccessAreaID.ForeColor = System.Drawing.Color.Black;
                    AccessAreaID.Enabled = true;
                }
                else
                {
                    LabelAccessAreaID.ForeColor = System.Drawing.Color.Gray;
                    AccessAreaID.Enabled = false;
                }

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

        protected void BtnOK_Click(object sender, EventArgs e)
        { 
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

            // bool nameIsVisible = EmployeesShowName.Checked;
            bool nameIsVisible = true;

            int companyLevel = Convert.ToInt32(SelectNodes.SelectedValue);

            int presenceLevel = Convert.ToInt32(Session["PresenceLevel"]);

            Webservices webservice = new Webservices();

            GetPresenceData_Result[] result = webservice.GetPresenceData(companyID, dateFrom, dateUntil, nameIsVisible, companyLevel, presenceLevel);

            if (result == null || result.Count() == 0)
            {
                Notification1.Title = Resources.Resource.lblPresenceReport;
                Notification1.Text = Resources.Resource.msgNoDataFound;
                Notification1.ContentIcon = "info";
                Notification1.ShowSound = "";
                Notification1.AutoCloseDelay = 5000;
                Notification1.Show();
            }
            else
            {
                int colCount = 14;

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

                pck.Workbook.Properties.Title = Resources.Resource.lblPresenceReport;
                pck.Workbook.Properties.Author = Session["LoginName"].ToString();
                if (Session["CompanyID"] != null && Convert.ToInt32(Session["CompanyID"]) > 0)
                {
                    pck.Workbook.Properties.Company = Helpers.GetCompanyName(Convert.ToInt32(Session["CompanyID"]));
                }
                pck.Workbook.Properties.Manager = Resources.Resource.appName;

                pck.Workbook.Protection.LockRevision = false;
                pck.Workbook.Protection.LockStructure = false;

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

                ws.Cells[1, 1].Value = Resources.Resource.lblPresenceReport;
                ws.Cells[1, 1].Style.Font.Bold = true;
                ws.Cells[1, 1].Style.Font.Size = 16;

                ws.Cells[3, 1].Value = Resources.Resource.lblSystem + ":";
                ws.Cells[3, 2].Value = Session["SystemID"].ToString();

                ws.Cells[4, 1].Value = Resources.Resource.lblBuildingProject + ":";
                ws.Cells[4, 2].Value = Session["BpName"].ToString();

                ws.Cells[5, 1].Value = Resources.Resource.lblCompany + ":";
                if (CompanyID.SelectedValue != null && !CompanyID.SelectedValue.Equals(string.Empty))
                {
                    ws.Cells[5, 2].Value = CompanyID.SelectedText;
                }

                ws.Cells[6, 1].Value = Resources.Resource.lblAccess + " " + Resources.Resource.lblFrom.ToLower() + ":";
                if (DateTimeFrom.SelectedDate != null)
                {
                    ws.Cells[6, 2].Value = DateTimeFrom.SelectedDate;
                    ws.Cells[6, 2].Style.Numberformat.Format = "DDD, DD.MM.YYYY hh:mm";
                    ws.Cells[6, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[7, 1].Value = Resources.Resource.lblAccess + " " + Resources.Resource.lblUntil.ToLower() + ":";
                if (DateTimeUntil.SelectedDate != null)
                {
                    ws.Cells[7, 2].Value = DateTimeUntil.SelectedDate;
                    ws.Cells[7, 2].Style.Numberformat.Format = "DDD, DD.MM.YYYY hh:mm";
                    ws.Cells[7, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[8, 1].Value = Resources.Resource.lblConsideredLevels + ":";
                ws.Cells[8, 2].Value = SelectNodes.SelectedItem.Text;

                ws.Cells[9, 1].Value = Resources.Resource.lblTemplate + ":";
                ws.Cells[9, 2].Value = TemplateID.SelectedItem.Text;

                ws.Cells[10, 1].Value = Resources.Resource.lblRemarks + ":";
                ws.Cells[10, 2].Value = Remarks.Text;
                ws.Cells[10, 2].Style.WrapText = true;

                ws.Cells[11, 1].Value = Resources.Resource.lblState + ":";
                ws.Cells[11, 2].Value = DateTime.Now.ToString("ddd, dd.MM.yyyy HH:mm");

                ws.Cells[12, 1].Value = Resources.Resource.lblUser + ":";
                ws.Cells[12, 2].Value = Session["LoginName"].ToString();

                ExcelRange parameters = ws.Cells[1, 1, 12, 2];
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

                // Tiefe der Baumstruktur feststellen
                int maxIndent = 1;
                foreach (GetPresenceData_Result row in result)
                {
                    if (row.IndentLevel > maxIndent)
                    {
                        maxIndent = (int)row.IndentLevel;
                    }
                }
                colCount += maxIndent;

                // Kopfzeile
                ws.Cells[1, 1].Value = Resources.Resource.lblRowType;
                ws.Cells[1, 2].Value = Resources.Resource.lblMainContractor;
                for (int i = 3; i <= 1 + maxIndent; i++)
                {
                    ws.Cells[1, i].Value = Resources.Resource.lblSubContractor + " (" + Resources.Resource.lblLevel + " " + (i - 2).ToString() + ")";
                }
                ws.Cells[1, 4 + maxIndent - 2].Value = Resources.Resource.lblEmployeeID;
                ws.Cells[1, 5 + maxIndent - 2].Value = Resources.Resource.lblLastName;
                ws.Cells[1, 6 + maxIndent - 2].Value = Resources.Resource.lblFirstName;
                ws.Cells[1, 7 + maxIndent - 2].Value = Resources.Resource.lblDate;
                ws.Cells[1, 8 + maxIndent - 2].Value = Resources.Resource.lblEntrance;
                ws.Cells[1, 9 + maxIndent - 2].Value = Resources.Resource.lblLeaving;
                ws.Cells[1, 10 + maxIndent - 2].Value = Resources.Resource.lblHours;
                ws.Cells[1, 11 + maxIndent - 2].Value = Resources.Resource.lblSum + " " + Resources.Resource.lblHours + " " + Resources.Resource.lblEmployee;
                ws.Cells[1, 11 + maxIndent - 2].Style.WrapText = true;
                ws.Cells[1, 12 + maxIndent - 2].Value = Resources.Resource.lblSum + " " + Resources.Resource.lblDays + " " + Resources.Resource.lblEmployee;
                ws.Cells[1, 12 + maxIndent - 2].Style.WrapText = true;
                ws.Cells[1, 13 + maxIndent - 2].Value = Resources.Resource.lblSum + " " + Resources.Resource.lblHours + " " + Resources.Resource.lblMainContractor;
                ws.Cells[1, 13 + maxIndent - 2].Style.WrapText = true;
                ws.Cells[1, 14 + maxIndent - 2].Value = Resources.Resource.lblSum + " " + Resources.Resource.lblDays + " " + Resources.Resource.lblMainContractor;
                ws.Cells[1, 14 + maxIndent - 2].Style.WrapText = true;
                ws.Cells[1, 15 + maxIndent - 2].Value = Resources.Resource.lblSum + " " + Resources.Resource.lblHours + " " + Resources.Resource.lblMainContractor + " + " + Resources.Resource.lblSubContractors;
                ws.Cells[1, 15 + maxIndent - 2].Style.WrapText = true;
                ws.Cells[1, 16 + maxIndent - 2].Value = Resources.Resource.lblSum + " " + Resources.Resource.lblDays + " " + Resources.Resource.lblMainContractor + " + " + Resources.Resource.lblSubContractors;
                ws.Cells[1, 16 + maxIndent - 2].Style.WrapText = true;

                // Daten
                int rowNum = 1;
                foreach (GetPresenceData_Result row in result)
                {
                    rowNum++;

                    // Zeilentyp
                    if (row.CompressLevel == -1)
                    {
                        ws.Cells[rowNum, 1].Value = Resources.Resource.rowTypeCompanyHoursWithSubcontractors;
                    }
                    else if (row.CompressLevel == 1)
                    {
                        ws.Cells[rowNum, 1].Value = Resources.Resource.rowTypeCompanyHours;
                        ws.Row(rowNum).OutlineLevel = 1;
                    }
                    else if (row.CompressLevel == 2)
                    {
                        ws.Cells[rowNum, 1].Value = Resources.Resource.rowTypeEmployeeDays;
                        ws.Row(rowNum).OutlineLevel = 2;
                    }
                    else if (row.CompressLevel == 3)
                    {
                        ws.Cells[rowNum, 1].Value = Resources.Resource.rowTypeEmployeePresenceTimes;
                        ws.Row(rowNum).OutlineLevel = 3;
                    }

                    // Firmenname
                    ws.Cells[rowNum, (int)row.IndentLevel + 1].Value = row.NameVisible;

                    // Weitere Daten
                    if (row.CompressLevel == 3 || row.CompressLevel == 2)
                    {
                        ws.Cells[rowNum, 4 + maxIndent - 2].Value = row.EmployeeID;
                        ws.Cells[rowNum, 5 + maxIndent - 2].Value = row.LastName;
                        ws.Cells[rowNum, 6 + maxIndent - 2].Value = row.FirstName;
                    }

                    // Datum
                    ws.Cells[rowNum, 7 + maxIndent - 2].Value = row.PresenceDay;
                    ws.Cells[rowNum, 7 + maxIndent - 2].Style.Numberformat.Format = "DD.MM.YYYY";
                    ws.Cells[rowNum, 7 + maxIndent - 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;

                    if (row.CompressLevel == 3)
                    {
                        // Kommen
                        ws.Cells[rowNum, 8 + maxIndent - 2].Value = row.AccessAt;
                        ws.Cells[rowNum, 8 + maxIndent - 2].Style.Numberformat.Format = "DD.MM.YYYY hh:mm";
                        ws.Cells[rowNum, 8 + maxIndent - 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                        if (row.AccessTimeManual)
                        {
                            ws.Cells[rowNum, 8 + maxIndent - 2].Style.Font.Color.SetColor(System.Drawing.Color.DarkRed);
                        }

                        // Gehen
                        ws.Cells[rowNum, 9 + maxIndent - 2].Value = row.ExitAt;
                        ws.Cells[rowNum, 9 + maxIndent - 2].Style.Numberformat.Format = "DD.MM.YYYY hh:mm";
                        ws.Cells[rowNum, 9 + maxIndent - 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                        if (row.ExitTimeManual)
                        {
                            ws.Cells[rowNum, 9 + maxIndent - 2].Style.Font.Color.SetColor(System.Drawing.Color.DarkRed);
                        }
                    }

                    if (row.CompressLevel == 3)
                    {
                        // Stunden Mitarbeiter
                        ws.Cells[rowNum, 10 + maxIndent - 2].Value = (decimal)row.PresenceSeconds / (decimal)3600;
                        ws.Cells[rowNum, 10 + maxIndent - 2].Style.Numberformat.Format = "#,##0.00";
                    }

                    if (row.CompressLevel == 2)
                    {
                        // Summe Stunden Mitarbeiter
                        ws.Cells[rowNum, 11 + maxIndent - 2].Value = (decimal)row.PresenceSeconds / (decimal)3600;
                        ws.Cells[rowNum, 11 + maxIndent - 2].Style.Numberformat.Format = "#,##0.00";
                        // Anwesenheitstage Mitarbeiter
                        ws.Cells[rowNum, 12 + maxIndent - 2].Value = row.CountAs;
                    }

                    if (row.CompressLevel == 1)
                    {
                        // Stunden Firma
                        ws.Cells[rowNum, 13 + maxIndent - 2].Value = (decimal)row.PresenceSeconds / (decimal)3600;
                        ws.Cells[rowNum, 13 + maxIndent - 2].Style.Numberformat.Format = "#,##0.00";

                        // Anwesenheitstage Firma
                        ws.Cells[rowNum, 14 + maxIndent - 2].Value = row.CountAs;
                    }

                    if (row.CompressLevel == -1)
                    {
                        // Stunden Firma und Nachunternehmer
                        ws.Cells[rowNum, 15 + maxIndent - 2].Value = (decimal)row.PresenceSeconds / (decimal)3600;
                        ws.Cells[rowNum, 15 + maxIndent - 2].Style.Numberformat.Format = "#,##0.00";

                        // Anwesenheitstage Firma und Nachunternehmer
                        ws.Cells[rowNum, 16 + maxIndent - 2].Value = row.CountAs;
                    }
                }

                // Autofilter und autofit
                ExcelRange dataCells = ws.Cells[1, 1, rowNum + 1, colCount];
                dataCells.AutoFilter = true;
                dataCells.AutoFitColumns();

                // Kopfzeile fett und fixiert
                ExcelRange headLine = ws.Cells[1, 1, 1, colCount];
                headLine.Style.Font.Bold = true;
                ws.View.FreezePanes(2, 2);

                // Gruppierungen
                ws.Column(2 + maxIndent).OutlineLevel = 1;
                ws.Column(3 + maxIndent).OutlineLevel = 1;
                ws.Column(4 + maxIndent).OutlineLevel = 1;
                ws.Column(5 + maxIndent).OutlineLevel = 1;
                ws.Column(6 + maxIndent).OutlineLevel = 1;
                ws.Column(7 + maxIndent).OutlineLevel = 1;
                ws.Column(8 + maxIndent).OutlineLevel = 1;
                ws.Column(8 + maxIndent).Width = 20;
                ws.Column(9 + maxIndent).OutlineLevel = 1;
                ws.Column(9 + maxIndent).Width = 20;
                ws.Column(10 + maxIndent).OutlineLevel = 1;
                ws.Column(10 + maxIndent).Width = 20;

                ws.Column(11 + maxIndent).Width = 20;

                ws.Column(12 + maxIndent).OutlineLevel = 1;
                ws.Column(12 + maxIndent).Width = 20;

                ws.Column(13 + maxIndent).Width = 20;

                ws.Column(14 + maxIndent).OutlineLevel = 1;
                ws.Column(14 + maxIndent).Width = 20;
                
                // ws.Tables[0].TableStyle = OfficeOpenXml.Table.TableStyles.Light9;

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
                    workbook.Worksheets[1].WorksheetPageSetup.ScaleFactor = new Size(0.5, 0.5);
                    workbook.Worksheets[1].WorksheetPageSetup.CenterHorizontally = true;
                    workbook.Worksheets[1].WorksheetPageSetup.Margins = new PageMargins(20.0);

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
                Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblPresenceReport + "_" + fileDate + "." + suffix));
                Response.BinaryWrite(fileData);
                Response.End();
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
                LabelAccess.ForeColor = System.Drawing.Color.Black;
                LabelAccess1.ForeColor = System.Drawing.Color.Black;
                LabelAccess2.ForeColor = System.Drawing.Color.Black;
                DateTimeFrom.Enabled = true;
                DateTimeUntil.Enabled = true;
            }
            else
            {
                LabelAccess.ForeColor = System.Drawing.Color.Gray;
                LabelAccess1.ForeColor = System.Drawing.Color.Gray;
                LabelAccess2.ForeColor = System.Drawing.Color.Gray;
                DateTimeFrom.Enabled = false;
                DateTimeUntil.Enabled = false;
                DateTimeFrom.SelectedDate = null;
                DateTimeUntil.SelectedDate = null;
            }
        }

        private string CreateReportParameter(
            string reportName,
            string reportType,
            int companyID,
            int companyLevel,
            int accessAreaID,
            int evaluationPeriod,
            DateTime dateFrom,
            DateTime dateUntil,
            int presenceLevel,
            string comment,
            string companyName,
            string accessAreaName,
            string companyLevelName,
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
            xeReportParameters.Add(new XElement("Parameter", companyID.ToString(), new XAttribute("Name", "CompanyID")));
            xeReportParameters.Add(new XElement("Parameter", companyLevel.ToString(), new XAttribute("Name", "CompanyLevel")));
            xeReportParameters.Add(new XElement("Parameter", accessAreaID.ToString(), new XAttribute("Name", "AccessAreaID")));
            xeReportParameters.Add(new XElement("Parameter", evaluationPeriod.ToString(), new XAttribute("Name", "EvaluationPeriod")));
            xeReportParameters.Add(new XElement("Parameter", dateFrom, new XAttribute("Name", "DateFrom")));
            xeReportParameters.Add(new XElement("Parameter", dateUntil, new XAttribute("Name", "DateUntil")));
            xeReportParameters.Add(new XElement("Parameter", presenceLevel, new XAttribute("Name", "PresenceLevel")));
            xeReportParameters.Add(new XElement("Parameter", comment, new XAttribute("Name", "Comment")));
            xeReportParameters.Add(new XElement("Parameter", companyName, new XAttribute("Name", "CompanyName")));
            xeReportParameters.Add(new XElement("Parameter", accessAreaName, new XAttribute("Name", "AccessAreaName")));
            xeReportParameters.Add(new XElement("Parameter", companyLevelName, new XAttribute("Name", "CompanyLevelName")));
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

            int companyID = 0;
            if (!CompanyID.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(CompanyID.SelectedValue);
            }

            int companyLevel = Convert.ToInt32(SelectNodes.SelectedValue);

            int accessAreaID = 0;
            if (!AccessAreaID.SelectedValue.Equals(string.Empty))
            {
                accessAreaID = Convert.ToInt32(AccessAreaID.SelectedValue);
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
                dateUntil = (DateTime)DateTimeUntil.SelectedDate + new TimeSpan(23, 59, 59);
            }

            int presenceLevel = Convert.ToInt32(Session["PresenceLevel"]);

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
                    companyID,
                    companyLevel,
                    accessAreaID,
                    evaluationPeriod,
                    dateFrom,
                    dateUntil,
                    presenceLevel,
                    Remarks.Text,
                    companyName,
                    AccessAreaID.SelectedItem.Text,
                    SelectNodes.SelectedItem.Text,
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
                        Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblPresenceReport + "_" + fileDate + "." + report.FileExtension));
                        Response.BinaryWrite(report.FileData);
                        Response.End();
                    }
                    else if (report != null)
                    {
                        Notification1.Title = Resources.Resource.lblPresenceReport;
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

                            Notification1.Title = Resources.Resource.lblPresenceReport;
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
    }
}