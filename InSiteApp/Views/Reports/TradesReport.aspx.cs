using InSite.App.UserServices;
using OfficeOpenXml;
using System;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Windows;
using Telerik.Web.UI;
using Telerik.Windows.Documents.Model;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.OpenXml.Xlsx;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.Pdf;
using Telerik.Windows.Documents.Spreadsheet.FormatProviders.Pdf.Export;
using Telerik.Windows.Documents.Spreadsheet.Model;
using Telerik.Windows.Documents.Spreadsheet.Model.Printing;

namespace InSite.App.Views.Reports
{
    public partial class TradesReport : BasePagePopUp
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;

        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = Resources.Resource.lblReportTrades;
            this.DateTimeFrom.Focus();

            if (!IsPostBack)
            {
                this.DateTimeFrom.SelectedDate = Helpers.FirstDayOfWeek(DateTime.Today.AddDays(-7));
                this.DateTimeFrom.MaxDate = DateTime.Today.AddDays(-1);
                this.DateTimeUntil.SelectedDate = Helpers.LastDayOfWeek(DateTime.Today.AddDays(-7));
                this.DateTimeUntil.MaxDate = DateTime.Today.AddDays(-1);

                // Vorlagen für diese Verarbeitung auswählen
                TemplateID.Items.Clear();
                RadComboBoxItem item = new RadComboBoxItem();
                item.Text = Resources.Resource.selNoTemplate;
                item.Value = "0";
                TemplateID.Items.Add(item);
                bool selected = false;

                GetTemplates_Result[] templates = Helpers.GetTemplates(type.Name, false);
                if (templates != null)
                {
                    foreach (GetTemplates_Result template in templates)
                    {
                        item = new RadComboBoxItem();
                        item.Text = template.NameVisible;
                        item.Value = template.TemplateID.ToString();
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
            DateTime dateFrom = DateTime.Today;
            if (DateTimeFrom.SelectedDate != null)
            {
                dateFrom = (DateTime)DateTimeFrom.SelectedDate;
            }

            DateTime dateUntil = DateTime.Today;
            if (DateTimeUntil.SelectedDate != null)
            {
                dateUntil = (DateTime)DateTimeUntil.SelectedDate;
            }

            Webservices webservice = new Webservices();

            GetTradeReportData_Result[] result = webservice.GetTradeReportData(dateFrom, dateUntil);

            if (result == null || result.Count() == 0)
            {
                Notification1.Title = Resources.Resource.lblReportTrades;
                Notification1.Text = Resources.Resource.msgNoDataFound;
                Notification1.ContentIcon = "info";
                Notification1.Show();
            }
            else
            {
                int colCount = 10;

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

                pck.Workbook.Properties.Title = Resources.Resource.lblReportTrades;
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

                ws.Cells[1, 1].Value = Resources.Resource.lblReportTrades;
                ws.Cells[1, 1].Style.Font.Bold = true;
                ws.Cells[1, 1].Style.Font.Size = 16;

                ws.Cells[2, 1].Value = Resources.Resource.lblSystem;
                ws.Cells[2, 2].Value = Session["SystemID"].ToString();

                ws.Cells[3, 1].Value = Resources.Resource.lblBuildingProject;
                ws.Cells[3, 2].Value = Session["BpName"].ToString();

                ws.Cells[4, 1].Value = Resources.Resource.lblAccess + " " + Resources.Resource.lblFrom.ToLower() + ":";
                if (DateTimeFrom.SelectedDate != null)
                {
                    ws.Cells[4, 2].Value = DateTimeFrom.SelectedDate;
                    ws.Cells[4, 2].Style.Numberformat.Format = "DDD, DD.MM.YYYY hh:mm";
                    ws.Cells[4, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[5, 1].Value = Resources.Resource.lblAccess + " " + Resources.Resource.lblUntil.ToLower() + ":";
                if (DateTimeUntil.SelectedDate != null)
                {
                    ws.Cells[5, 2].Value = DateTimeUntil.SelectedDate;
                    ws.Cells[5, 2].Style.Numberformat.Format = "DDD, DD.MM.YYYY hh:mm";
                    ws.Cells[5, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[6, 1].Value = Resources.Resource.lblTemplate + ":";
                ws.Cells[6, 2].Value = TemplateID.SelectedItem.Text;

                ws.Cells[7, 1].Value = Resources.Resource.lblRemarks + ":";
                ws.Cells[7, 2].Value = Remarks.Text;
                ws.Cells[7, 2].Style.WrapText = true;

                ws.Cells[8, 1].Value = Resources.Resource.lblState + ":";
                ws.Cells[8, 2].Value = DateTime.Now.ToString("ddd, dd.MM.yyyy HH:mm");

                ws.Cells[9, 1].Value = Resources.Resource.lblUser + ":";
                ws.Cells[9, 2].Value = Session["LoginName"].ToString();

                ExcelRange parameters = ws.Cells[1, 1, 9, 2];
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
                ws.Cells[1, 1].Value = Resources.Resource.lblCompany;
                ws.Cells[1, 1].Value = Resources.Resource.lblCompany;
                ws.Cells[1, 2].Value = Resources.Resource.lblID + " " + Resources.Resource.lblTradeGroup;
                ws.Cells[1, 3].Value = Resources.Resource.lblTradeGroup;
                ws.Cells[1, 4].Value = Resources.Resource.lblID + " " + Resources.Resource.lblTrade;
                ws.Cells[1, 5].Value = Resources.Resource.lblTrade;
                ws.Cells[1, 6].Value = Resources.Resource.lblDate;
                ws.Cells[1, 7].Value = Resources.Resource.lblHours;
                ws.Cells[1, 8].Value = "# " + Resources.Resource.lblEmployees;
                ws.Cells[1, 9].Value = Resources.Resource.lblIndex;
                ws.Cells[1, 10].Value = Resources.Resource.lblIndentLevel;

                // Daten
                int rowNum = 1;
                foreach (GetTradeReportData_Result row in result)
                {
                    rowNum++;

                    ws.Cells[rowNum, 1].Value = row.NameVisible;
                    ws.Cells[rowNum, 2].Value = row.TradeGroupID;
                    ws.Cells[rowNum, 3].Value = row.TradeGroupName;
                    ws.Cells[rowNum, 4].Value = row.TradeNumber;
                    ws.Cells[rowNum, 5].Value = row.TradeName;

                    ws.Cells[rowNum, 6].Value = row.PresenceDay;
                    ws.Cells[rowNum, 6].Style.Numberformat.Format = "DD.MM.YYYY";
                    ws.Cells[rowNum, 6].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;

                    ws.Cells[rowNum, 7].Value = (decimal)row.PresenceSeconds / (decimal)3600;
                    ws.Cells[rowNum, 7].Style.Numberformat.Format = "#.##0,00";

                    ws.Cells[rowNum, 8].Value = row.CountAs;
                    ws.Cells[rowNum, 9].Value = row.TreeLevel;
                    ws.Cells[rowNum, 10].Value = row.IndentLevel;
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
                    workbook.Worksheets[1].WorksheetPageSetup.ScaleFactor = new Size(0.8, 0.8);
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
                Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblReportTrades + "_" + fileDate + "." + suffix));
                Response.BinaryWrite(fileData);
                Response.End();
            }
        }

        protected void DateTimeFrom_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            if (this.DateTimeUntil.SelectedDate != null)
            {
                this.DateTimeUntil.SelectedDate = Helpers.LastDayOfWeek((DateTime)this.DateTimeFrom.SelectedDate);
            }
        }
    }
}