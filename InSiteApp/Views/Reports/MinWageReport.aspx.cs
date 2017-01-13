using InSite.App.Constants;
using InSite.App.UserServices;
using OfficeOpenXml;
using System;
using System.Data;
using System.Data.SqlClient;
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
    public partial class MinWageReport : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                this.MonthFrom.MaxDate = DateTime.Now.AddMonths(-1);
                this.MonthUntil.MaxDate = DateTime.Now.AddMonths(-1);
                this.MonthFrom.SelectedDate = DateTime.Now.AddMonths(-1);
                this.MonthUntil.SelectedDate = DateTime.Now.AddMonths(-1);

                string msg = Request.QueryString["MonthFrom"];
                if (msg != null)
                {
                    MonthFrom.SelectedDate = Convert.ToDateTime(msg);

                    msg = Request.QueryString["MonthUntil"];
                    if (msg != null)
                    {
                        MonthUntil.SelectedDate = Convert.ToDateTime(msg);
                    }

                    msg = Request.QueryString["CompanyID"];
                    if (msg != null)
                    {
                        CompanyID.DataBind();
                        CompanyID.SelectedValue = msg;
                    }
                }

                RadTreeList1.DataBind();
                RadTreeList1.ExpandAllItems();
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, false);
        }

        protected void MonthFrom_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            RadTreeList1.DataSource = GetReportMinWageData();
            RadTreeList1.DataBind();
            RadTreeList1.ExpandAllItems();
        }

        protected void MonthUntil_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            RadTreeList1.DataSource = GetReportMinWageData();
            RadTreeList1.DataBind();
            RadTreeList1.ExpandAllItems();
        }

        protected void RadTreeList1_NeedDataSource(object sender, Telerik.Web.UI.TreeListNeedDataSourceEventArgs e)
        {
            RadTreeList1.DataSource = GetReportMinWageData();
        }

        private DataTable GetReportMinWageData()
        {
            DateTime monthFrom = DateTime.Now.AddMonths(-1);
            if (MonthFrom.SelectedDate != null)
            {
                monthFrom = Helpers.BeginOfMonth(Convert.ToDateTime(MonthFrom.SelectedDate));
            }

            DateTime monthUntil = DateTime.Now.AddMonths(-1);
            if (MonthUntil.SelectedDate != null)
            {
                monthUntil = Helpers.EndOfMonth(Convert.ToDateTime(MonthUntil.SelectedDate));
            }

            int companyID = 0;
            if (!CompanyID.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(CompanyID.SelectedValue.Split(',')[0]);
            }

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("GetReportMinWageData", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter par;

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@MonthFrom", SqlDbType.Date);
            par.Direction = ParameterDirection.Input;
            par.Value = monthFrom;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@MonthUntil", SqlDbType.Date);
            par.Direction = ParameterDirection.Input;
            par.Value = monthUntil;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = companyID;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
            }
            catch (System.Exception ex)
            {
                Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
            }
            finally
            {
                con.Close();
            }

            return dt;
        }

        protected void CompanyID_EntryAdded(object sender, Telerik.Web.UI.DropDownTreeEntryEventArgs e)
        {
            RadTreeList1.DataSource = GetReportMinWageData();
            RadTreeList1.DataBind();
            RadTreeList1.ExpandAllItems();
        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            DataTable result = GetReportMinWageData();
            if (result == null || result.Rows.Count == 0)
            {
                Helpers.Notification(this.Page.Master, Resources.Resource.lblMinWageReportCompany, Resources.Resource.msgNoDataFound);
            }
            else
            {
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

                pck.Workbook.Properties.Title = Resources.Resource.lblMinWageReportCompany;
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

                ws.Cells[1, 1].Value = Resources.Resource.lblMinWageReportCompany;
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
                else
                {
                    ws.Cells[5, 2].Value = Resources.Resource.selAllBpCompanies;
                }

                ws.Cells[6, 1].Value = Resources.Resource.lblFrom + ":";
                if (MonthFrom.SelectedDate != null)
                {
                    ws.Cells[6, 2].Value = ((DateTime)MonthFrom.SelectedDate).ToString("MMMM yyyy");
                    ws.Cells[6, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[7, 1].Value = Resources.Resource.lblUntil + ":";
                if (MonthUntil.SelectedDate != null)
                {
                    ws.Cells[7, 2].Value = ((DateTime)MonthUntil.SelectedDate).ToString("MMMM yyyy");
                    ws.Cells[7, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[8, 1].Value = Resources.Resource.lblTemplate + ":";
                ws.Cells[8, 2].Value = TemplateID.SelectedItem.Text;

                ws.Cells[9, 1].Value = Resources.Resource.lblRemarks + ":";
                ws.Cells[9, 2].Value = Remarks.Text;
                ws.Cells[9, 2].Style.WrapText = true;

                ws.Cells[10, 1].Value = Resources.Resource.lblState + ":";
                ws.Cells[10, 2].Value = DateTime.Now.ToString("ddd, dd.MM.yyyy HH:mm");

                ws.Cells[11, 1].Value = Resources.Resource.lblUser + ":";
                ws.Cells[11, 2].Value = Session["LoginName"].ToString();

                ExcelRange parameters = ws.Cells[1, 1, 11, 2];
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
                foreach (DataRow row in result.Rows)
                {
                    if (Convert.ToInt32(row["IndentLevel"]) > maxIndent)
                    {
                        maxIndent = Convert.ToInt32(row["IndentLevel"]);
                    }
                }
                int colCount = 10;
                colCount += maxIndent;

                // Kopfzeile
                ws.Cells[1, 1].Value = Resources.Resource.lblMainContractor;
                for (int i = 2; i <= 1 + maxIndent; i++)
                {
                    ws.Cells[1, i].Value = Resources.Resource.lblSubContractor + " (" + Resources.Resource.lblLevel + " " + (i - 1).ToString() + ")";
                }
                ws.Cells[1, 3 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationMCRequired;
                ws.Cells[1, 4 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationSCRequired;
                ws.Cells[1, 5 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationMCOpen;
                ws.Cells[1, 6 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationSCOpen;
                ws.Cells[1, 7 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationMCExisting;
                ws.Cells[1, 8 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationSCExisting;
                ws.Cells[1, 9 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationMCFaulty;
                ws.Cells[1, 10 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationSCFaulty;
                ws.Cells[1, 11 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationMCToLow;
                ws.Cells[1, 12 + maxIndent - 2].Value = Resources.Resource.lblMWAttestationSCToLow;

                // Daten
                int rowNum = 1;
                foreach (DataRow row in result.Rows)
                {
                    rowNum++;

                    // Firmenname
                    ws.Cells[rowNum, (int)row["IndentLevel"]].Value = row["NameVisible"].ToString();

                    // Weitere Daten
                    ws.Cells[rowNum, 3 + maxIndent - 2].Value = row["MWAttestationMCRequired"].ToString();
                    ws.Cells[rowNum, 3 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 4 + maxIndent - 2].Value = row["MWAttestationSCRequired"].ToString();
                    ws.Cells[rowNum, 4 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 5 + maxIndent - 2].Value = row["MWAttestationMCOpen"].ToString();
                    ws.Cells[rowNum, 5 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 6 + maxIndent - 2].Value = row["MWAttestationSCOpen"].ToString();
                    ws.Cells[rowNum, 6 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 7 + maxIndent - 2].Value = row["MWAttestationMCExisting"].ToString();
                    ws.Cells[rowNum, 7 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 8 + maxIndent - 2].Value = row["MWAttestationSCExisting"].ToString();
                    ws.Cells[rowNum, 8 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 9 + maxIndent - 2].Value = row["MWAttestationMCFaulty"].ToString();
                    ws.Cells[rowNum, 9 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 10 + maxIndent - 2].Value = row["MWAttestationSCFaulty"].ToString();
                    ws.Cells[rowNum, 10 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 11 + maxIndent - 2].Value = row["MWAttestationMCToLow"].ToString();
                    ws.Cells[rowNum, 11 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                    ws.Cells[rowNum, 12 + maxIndent - 2].Value = row["MWAttestationSCToLow"].ToString();
                    ws.Cells[rowNum, 12 + maxIndent - 2].Style.Numberformat.Format = "#.##0,00";
                }

                // Autofilter und autofit
                ExcelRange dataCells = ws.Cells[1, 1, rowNum + 1, colCount];
                dataCells.AutoFilter = true;
                dataCells.AutoFitColumns();

                // Kopfzeile fett und fixiert
                ExcelRange headLine = ws.Cells[1, 1, 1, colCount];
                headLine.Style.Font.Bold = true;
                ws.View.FreezePanes(2, 2);

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
                    workbook.Worksheets[1].WorksheetPageSetup.ScaleFactor = new Size(0.7, 0.7);
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
                Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblMinWageReportCompany + "_" + fileDate + "." + suffix));
                Response.BinaryWrite(fileData);
                Response.End();
            }
        }

        protected void RadTreeList1_ItemCommand(object sender, TreeListCommandEventArgs e)
        {
            if (e.CommandName.Equals("MinWageEmployee"))
            {
                string monthFrom = DateTime.Now.AddMonths(-1).ToString("dd.MM.yyyy");
                if (MonthFrom.SelectedDate != null)
                {
                    monthFrom = Convert.ToDateTime(MonthFrom.SelectedDate).ToString("dd.MM.yyyy");
                }

                string monthUntil = DateTime.Now.AddMonths(-1).ToString("dd.MM.yyyy");
                if (MonthUntil.SelectedDate != null)
                {
                    monthUntil = Convert.ToDateTime(MonthUntil.SelectedDate).ToString("dd.MM.yyyy");
                }

                string companyID = e.CommandArgument.ToString();

                string selectedCompanyID = "";
                if (!CompanyID.SelectedValue.Equals(string.Empty))
                {
                    selectedCompanyID = CompanyID.SelectedValue.Split(',')[0];
                }

                RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect("/InSiteApp/Views/Reports/MinWageReportEmployee.aspx?MonthFrom=" + monthFrom + "&MonthUntil=" + monthUntil + "&CompanyID=" + companyID + "&SelectedCompanyID=" + selectedCompanyID);
            }
        }
    }
}