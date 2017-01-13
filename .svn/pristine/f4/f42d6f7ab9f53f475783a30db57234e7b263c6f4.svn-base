using InSite.App.Constants;
using InSite.App.UserServices;
using OfficeOpenXml;
using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
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
    public partial class MinWageReportEmployee : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            string msg = Request.QueryString["MonthFrom"];

            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                this.MonthFrom.MaxDate = DateTime.Now.AddMonths(-1);
                this.MonthUntil.MaxDate = DateTime.Now.AddMonths(-1);
                this.MonthFrom.SelectedDate = DateTime.Now.AddMonths(-1);
                this.MonthUntil.SelectedDate = DateTime.Now.AddMonths(-1);

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

                    msg = Request.QueryString["SelectedCompanyID"];
                    if (msg != null)
                    {
                        Session["SelectedCompanyID"] = msg;
                    }
                }

                RadGrid1.DataSource = GetReportMinWageData();
                RadGrid1.DataBind();
                RefreshCompanyInfo();
            }

            if (msg != null)
            {
                BtnMWReportCompany.Visible = true;
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, false);
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

            bool showCorrectMonths = ShowCorrectMonths.Checked;

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("GetReportMinWageEmployeeData", con);
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

            par = new SqlParameter("@ShowCorrectMonths", SqlDbType.Bit);
            par.Direction = ParameterDirection.Input;
            par.Value = showCorrectMonths;
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

        protected void MonthFrom_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
            RadGrid1.DataBind();
        }

        protected void MonthUntil_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
            RadGrid1.DataBind();
        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            DataTable result = GetReportMinWageData();
            if (result == null || result.Rows.Count == 0)
            {
                Helpers.Notification(this.Page.Master, Resources.Resource.lblMinWageReportEmployee, Resources.Resource.msgNoDataFound);
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

                pck.Workbook.Properties.Title = Resources.Resource.lblMinWageReportEmployee;
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

                ws.Cells[1, 1].Value = Resources.Resource.lblMinWageReportEmployee;
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
                    ws.Cells[6, 2].Value = MonthFrom.SelectedDate;
                    ws.Cells[6, 2].Style.Numberformat.Format = "MMM.YYYY";
                    ws.Cells[6, 2].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells[7, 1].Value = Resources.Resource.lblUntil + ":";
                if (MonthUntil.SelectedDate != null)
                {
                    ws.Cells[7, 2].Value = MonthUntil.SelectedDate;
                    ws.Cells[7, 2].Style.Numberformat.Format = "MMM.YYYY";
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

                int companyID = 0;
                if (!CompanyID.SelectedValue.Equals(string.Empty))
                {
                    companyID = Convert.ToInt32(CompanyID.SelectedValue.Split(',')[0]);
                }

                GetCompanyInfo_Result[] result1 = Helpers.GetCompanyInfo(companyID);
                if (result != null)
                {
                    ws.Cells[3, 4].Value = Resources.Resource.lblCompanyInfo + ":";
                    ws.Cells[3, 4].Style.Font.Bold = true;

                    ws.Cells[4, 4].Value = Resources.Resource.lblCompany + ":";
                    ws.Cells[4, 5].Value = result1[0].NameVisible;

                    ws.Cells[5, 4].Value = Resources.Resource.lblAddress + ":";
                    ws.Cells[5, 5].Value = result1[0].Address1;

                    ws.Cells[6, 4].Value = Resources.Resource.lblAddrZip + ":";
                    ws.Cells[6, 5].Value = result1[0].Zip;

                    ws.Cells[7, 4].Value = Resources.Resource.lblAddrCity + ":";
                    ws.Cells[7, 5].Value = result1[0].City;

                    ws.Cells[8, 4].Value = Resources.Resource.lblClientID + ":";
                    ws.Cells[8, 5].Value = result1[0].ClientCompanyID.ToString();

                    ws.Cells[9, 4].Value = Resources.Resource.lblClient + ":";
                    ws.Cells[9, 5].Value = result1[0].ClientNameVisible;

                    parameters = ws.Cells[3, 4, 9, 5];
                    parameters.AutoFitColumns();
                }

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
                ws.Cells[1, 1].Value = Resources.Resource.lblAddrLastName;
                ws.Cells[1, 2].Value = Resources.Resource.lblAddrFirstName;
                ws.Cells[1, 3].Value = Resources.Resource.lblAddrBirthDate;
                ws.Cells[1, 4].Value = Resources.Resource.lblFunction;
                ws.Cells[1, 5].Value = Resources.Resource.lblMonth;
                ws.Cells[1, 6].Value = Resources.Resource.lblStatus;
                ws.Cells[1, 7].Value = Resources.Resource.lblTariffWageGroup;
                ws.Cells[1, 8].Value = Resources.Resource.lblTariffWage;
                ws.Cells[1, 9].Value = Resources.Resource.lblAmount;
                ws.Cells[1, 10].Value = Resources.Resource.lblReceivedOn;
                ws.Cells[1, 11].Value = Resources.Resource.lblReceivedFrom;
                ws.Cells[1, 12].Value = Resources.Resource.lblRequestOn;
                ws.Cells[1, 13].Value = Resources.Resource.lblRequestFrom;
                ws.Cells[1, 14].Value = Resources.Resource.lblID;

                // Daten
                int rowNum = 1;
                foreach (DataRow row in result.Rows)
                {
                    rowNum++;

                    ws.Cells[rowNum, 1].Value = row["LastName"].ToString();
                    ws.Cells[rowNum, 2].Value = row["FirstName"].ToString();
                    if (row["BirthDate"] != DBNull.Value && row["BirthDate"] != null)
                    {
                        ws.Cells[rowNum, 3].Value = Convert.ToDateTime(row["BirthDate"]).ToString("dd.MM.yyyy");
                        ws.Cells[rowNum, 3].Style.Numberformat.Format = "DD.MM.YYYY";
                    }
                    ws.Cells[rowNum, 4].Value = row["StaffFunction"].ToString();
                    ws.Cells[rowNum, 5].Value = Convert.ToDateTime(row["MWMonth"]).ToString("MM.yyyy");
                    ws.Cells[rowNum, 5].Style.Numberformat.Format = "DD.MM.YYYY";
                    ws.Cells[rowNum, 6].Value = GetMWStatus(Convert.ToInt32(row["StatusCode"].ToString()));
                    ws.Cells[rowNum, 7].Value = row["WageName"].ToString();
                    ws.Cells[rowNum, 8].Value = Convert.ToDecimal(row["Wage"]).ToString("#,##0.00");
                    // ws.Cells[rowNum, 8].Style.Numberformat.Format = "#.##0,00";
                    if (row["Amount"] != DBNull.Value)
                    {
                        ws.Cells[rowNum, 9].Value = Convert.ToDecimal(row["Amount"]).ToString("#,##0.00");
                        // ws.Cells[rowNum, 9].Style.Numberformat.Format = "#.##0,00";
                    }
                    if (row["ReceivedOn"] != DBNull.Value)
                    {
                        ws.Cells[rowNum, 10].Value = Convert.ToDateTime(row["ReceivedOn"]).ToString("dd.MM.yyyy HH:mm");
                    }
                    ws.Cells[rowNum, 11].Value = row["ReceivedFrom"].ToString();
                    if (row["RequestedOn"] != DBNull.Value && row["RequestedOn"] != null)
                    {
                        ws.Cells[rowNum, 12].Value = Convert.ToDateTime(row["RequestedOn"]).ToString("dd.MM.yyyy HH:mm");
                    }
                    ws.Cells[rowNum, 13].Value = row["RequestedFrom"].ToString();
                    ws.Cells[rowNum, 14].Value = row["RequestListID"].ToString();
                }

                int colCount = 14;

                // Autofilter und autofit
                ExcelRange dataCells = ws.Cells[1, 1, rowNum + 1, colCount];
                dataCells.AutoFilter = true;
                dataCells.AutoFitColumns();

                // Kopfzeile fett und fixiert
                ExcelRange headLine = ws.Cells[1, 1, 1, colCount];
                headLine.Style.Font.Bold = true;
                ws.View.FreezePanes(2, 2);

                Helpers.ProtectWorksheet(ref ws);

                // Tarifvertragshistorie
                if (templateID > 0)
                {
                    ws = pck.Workbook.Worksheets[Resources.Resource.lblTariffContractHistory];
                }
                else
                {
                    ws = pck.Workbook.Worksheets.Add(Resources.Resource.lblTariffContractHistory);
                }

                if (ShowTariffHistory.Checked)
                {
                    // Kopfzeile
                    ws.Cells[1, 1].Value = Resources.Resource.lblTariff;
                    ws.Cells[1, 2].Value = Resources.Resource.lblTariffContract;
                    ws.Cells[1, 3].Value = Resources.Resource.lblTariffScope;
                    ws.Cells[1, 4].Value = Resources.Resource.lblValidFrom;
                    ws.Cells[1, 5].Value = Resources.Resource.lblCreatedOn;
                    ws.Cells[1, 6].Value = Resources.Resource.lblTariffWageGroup;

                    // Daten
                    SqlDataSource_CompanyTariffs.SelectParameters["SystemID"].DefaultValue = Session["SystemID"].ToString();
                    SqlDataSource_CompanyTariffs.SelectParameters["BpID"].DefaultValue = Session["BpID"].ToString();
                    SqlDataSource_CompanyTariffs.SelectParameters["CompanyID"].DefaultValue = companyID.ToString();
                    DataSourceSelectArguments args = new DataSourceSelectArguments();
                    DataView view = (DataView)SqlDataSource_CompanyTariffs.Select(args);
                    result = view.ToTable();
                    rowNum = 1;
                    foreach (DataRow row in result.Rows)
                    {
                        rowNum++;

                        ws.Cells[rowNum, 1].Value = row["NameVisibleTariff"].ToString();
                        ws.Cells[rowNum, 2].Value = row["NameVisibleContract"].ToString();
                        ws.Cells[rowNum, 3].Value = row["NameVisible"].ToString();
                        ws.Cells[rowNum, 4].Value = Convert.ToDateTime(row["ValidFrom"]).ToString("dd.MM.yyyy");
                        ws.Cells[rowNum, 4].Style.Numberformat.Format = "DD.MM.YYYY";
                        ws.Cells[rowNum, 5].Value = Convert.ToDateTime(row["CreatedOn"]).ToString("dd.MM.yyyy HH:mm");
                        ws.Cells[rowNum, 5].Style.Numberformat.Format = "DD.MM.YYYY hh:mm";
                        ws.Cells[rowNum, 6].Value = row["WageGroupName"].ToString();
                    }

                    colCount = 6;

                    // Autofilter und autofit
                    dataCells = ws.Cells[1, 1, rowNum + 1, colCount];
                    dataCells.AutoFilter = true;
                    dataCells.AutoFitColumns();

                    // Kopfzeile fett und fixiert
                    headLine = ws.Cells[1, 1, 1, colCount];
                    headLine.Style.Font.Bold = true;
                    ws.View.FreezePanes(2, 2);

                    Helpers.ProtectWorksheet(ref ws);
                }

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

                    workbook.Worksheets[0].WorksheetPageSetup.PaperType = PaperTypes.A4;
                    workbook.Worksheets[0].WorksheetPageSetup.PageOrientation = PageOrientation.Landscape;
                    workbook.Worksheets[0].WorksheetPageSetup.ScaleFactor = new Size(0.8, 0.8);
                    workbook.Worksheets[0].WorksheetPageSetup.CenterHorizontally = true;

                    workbook.Worksheets[1].WorksheetPageSetup.PaperType = PaperTypes.A4;
                    workbook.Worksheets[1].WorksheetPageSetup.PageOrientation = PageOrientation.Landscape;
                    workbook.Worksheets[1].WorksheetPageSetup.ScaleFactor = new Size(0.8, 0.8);
                    workbook.Worksheets[1].WorksheetPageSetup.CenterHorizontally = true;
                    workbook.Worksheets[1].WorksheetPageSetup.Margins = new PageMargins(20.0);

                    workbook.Worksheets[2].WorksheetPageSetup.PaperType = PaperTypes.A4;
                    workbook.Worksheets[2].WorksheetPageSetup.PageOrientation = PageOrientation.Landscape;
                    workbook.Worksheets[2].WorksheetPageSetup.CenterHorizontally = true;

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
                Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(Resources.Resource.lblMinWageReportEmployee + "_" + fileDate + "." + suffix));
                Response.BinaryWrite(fileData);
                Response.End();
            }
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
        }

        protected void ShowCorrectMonths_CheckedChanged(object sender, EventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
            RadGrid1.DataBind();
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridFilteringItem)
            {
                GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                if (filteringItem != null)
                {
                    LiteralControl literal = filteringItem["BirthDate"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["BirthDate"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";

                    literal = filteringItem["MWMonth"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["MWMonth"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";

                    literal = filteringItem["ReceivedOn"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["ReceivedOn"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";

                    literal = filteringItem["RequestedOn"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["RequestedOn"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
                }
            }
        }

        protected void ShowTariffHistory_CheckedChanged(object sender, EventArgs e)
        {
            bool show = (sender as CheckBox).Checked;
            PanelTariffHistory.Visible = show;
            if (show)
            {
                RebindRadGridTariffHistory();
            }
        }

        private void RebindRadGridTariffHistory()
        {
            int companyID = 0;
            if (!CompanyID.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(CompanyID.SelectedValue.Split(',')[0]);
            }

            SqlDataSource_CompanyTariffs.SelectParameters["CompanyID"].DefaultValue = companyID.ToString();
            RadGridTariffHistory.Rebind();
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

        protected void CompanyID_EntryRemoved(object sender, DropDownTreeEntryEventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
            RadGrid1.DataBind();
            if (ShowTariffHistory.Checked)
            {
                RebindRadGridTariffHistory();
            }
            RefreshCompanyInfo();
        }

        protected void CompanyID_EntryAdded(object sender, Telerik.Web.UI.DropDownTreeEntryEventArgs e)
        {
            RadGrid1.DataSource = GetReportMinWageData();
            RadGrid1.DataBind();
            if (ShowTariffHistory.Checked)
            {
                RebindRadGridTariffHistory();
            }
            RefreshCompanyInfo();
        }

        protected void BtnMWReportCompany_Click(object sender, EventArgs e)
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

            string companyID = Session["SelectedCompanyID"].ToString();

            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
            ajax.Redirect("/InSiteApp/Views/Reports/MinWageReport.aspx?MonthFrom=" + monthFrom + "&MonthUntil=" + monthUntil + "&CompanyID=" + companyID);

            Session["SelectedCompanyID"] = null;
        }
    }
}