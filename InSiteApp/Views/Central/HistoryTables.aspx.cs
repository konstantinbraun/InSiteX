using InSite.App.UserServices;
using OfficeOpenXml;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using Telerik.Web.UI;

namespace InSite.App.Views.Central
{
    public partial class HistoryTables : BasePagePopUp
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                this.Title = Resources.Resource.lblHistoryTables;
                System_Tables[] historyTables = Helpers.GetHistoryTables();
                TableNames.DataSource = historyTables;
                TableNames.DataBind();
                UserNames.DataSource = Helpers.GetUsers();
                UserNames.DataBind();

                string tableName = Request.QueryString["TableName"];
                if (tableName != null && !tableName.Equals(string.Empty))
                {
                    foreach(RadComboBoxItem item in TableNames.Items)
                    {
                        if (item.Value.Equals(tableName))
                        {
                            item.Selected = true;
                        }
                    }
                }
            }
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
            System_Tables[] historyTables = Helpers.GetHistoryTables();
            System_Tables selectedTable = historyTables.FirstOrDefault(t => t.TABLE_NAME == TableNames.SelectedValue);

            StringBuilder sql = new StringBuilder();
            string originalTableName;
            if (TableNames.SelectedValue.Contains("History_S_"))
            {
                originalTableName = TableNames.SelectedValue.Replace("History_S_", "System_");
            }
            else
            {
                originalTableName = TableNames.SelectedValue.Replace("History_", "Master_");
            }

            // Der originale Datensatz, wenn dessen Änderungsdatum im Intervall liegt
            sql.AppendFormat("SELECT * FROM {0} ", originalTableName);
            if (DateTimeFrom.SelectedDate != null)
            {
                sql.Append("WHERE EditOn >= @DateTimeFrom ");
            }
            if (DateTimeUntil.SelectedDate != null)
            {
                if (DateTimeFrom.SelectedDate == null)
                {
                    sql.Append("WHERE ");
                }
                else
                {
                    sql.Append("AND ");
                }
                sql.Append("EditOn <= @DateTimeUntil ");
            }
            if (UserNames.SelectedValue != null && !UserNames.SelectedValue.Equals(string.Empty))
            {
                if (DateTimeFrom.SelectedDate == null && DateTimeUntil.SelectedDate == null)
                {
                    sql.Append("WHERE ");
                }
                else
                {
                    sql.Append("AND ");
                }
                sql.Append("EditFrom = @LoginName ");
            }

            sql.AppendLine();
            sql.AppendLine("UNION ALL ");

            // Die historisierten Sätze aus dem Intervall
            sql.AppendFormat("SELECT * FROM {0} ", TableNames.SelectedValue);
            if (DateTimeFrom.SelectedDate != null)
            {
                sql.Append("WHERE EditOn >= @DateTimeFrom ");
            }
            if (DateTimeUntil.SelectedDate != null)
            {
                if (DateTimeFrom.SelectedDate == null)
                {
                    sql.Append("WHERE ");
                }
                else
                {
                    sql.Append("AND ");
                }
                sql.Append("EditOn <= @DateTimeUntil ");
            }
            if (UserNames.SelectedValue != null && !UserNames.SelectedValue.Equals(string.Empty))
            {
                if (DateTimeFrom.SelectedDate == null && DateTimeUntil.SelectedDate == null)
                {
                    sql.Append("WHERE ");
                }
                else
                {
                    sql.Append("AND ");
                }
                sql.Append("EditFrom = @LoginName ");
            }

            // Der letzte historisierte Satz vor dem Intervall
            if (DateTimeFrom.SelectedDate != null)
            {
                sql.AppendLine();
                sql.AppendLine("UNION ALL ");

                sql.AppendFormat("SELECT TOP 1 * FROM {0} ", TableNames.SelectedValue);
                sql.Append("WHERE EditOn < @DateTimeFrom ");
            }

            sql.AppendFormat("ORDER BY {0} ", selectedTable.OrderBy);

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            if (DateTimeFrom.SelectedDate != null)
            {
                par = new SqlParameter("@DateTimeFrom", SqlDbType.DateTime);
                par.Value = DateTimeFrom.SelectedDate;
                cmd.Parameters.Add(par);
            }
            if (DateTimeUntil.SelectedDate != null)
            {
                par = new SqlParameter("@DateTimeUntil", SqlDbType.DateTime);
                par.Value = DateTimeUntil.SelectedDate;
                cmd.Parameters.Add(par);
            }
            if (UserNames.SelectedValue != null && !UserNames.SelectedValue.Equals(string.Empty))
            {
                par = new SqlParameter("@LoginName", SqlDbType.NVarChar, 50);
                par.Value = UserNames.SelectedItem.Text;
                cmd.Parameters.Add(par);
            }

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
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw;
            }
            catch (System.Exception ex)
            {
                logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw;
            }
            finally
            {
                con.Close();
            }

            if (dt.Rows.Count == 0)
            {
                Notification1.Title = Resources.Resource.lblHistoryTables;
                Notification1.Text = Resources.Resource.msgNoDataFound;
                Notification1.ContentIcon = "info";
                Notification1.Show();
            }
            else
            {
                int colCount = dt.Columns.Count;
                ExcelPackage pck = new ExcelPackage();

                // Kopfdaten
                ExcelWorksheet ws = pck.Workbook.Worksheets.Add(Resources.Resource.lblParameters);

                string tableName = GetResource(selectedTable.ResourceID) + " (" + selectedTable.TABLE_NAME.Replace("History_S_", "System_").Replace("History_", "") + ")";
                ws.Cells["A1"].Value = tableName;
                ws.Cells["A1"].Style.Font.Bold = true;
                ws.Cells["A1"].Style.Font.Size = 16;

                ws.Cells["A3"].Value = Resources.Resource.lblLastEditBy + ":";
                if (UserNames.SelectedValue != null && !UserNames.SelectedValue.Equals(string.Empty))
                {
                    ws.Cells["B3"].Value = UserNames.SelectedItem.Text;
                }

                ws.Cells["A4"].Value = Resources.Resource.lblLastEdit + " " + Resources.Resource.lblFrom.ToLower() + ":";
                if (DateTimeFrom.SelectedDate != null)
                {
                    ws.Cells["B4"].Value = DateTimeFrom.SelectedDate;
                    ws.Cells["B4"].Style.Numberformat.Format = "DDD, DD.MM.YYYY hh:mm";
                    ws.Cells["B4"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells["A5"].Value = Resources.Resource.lblLastEdit + " " + Resources.Resource.lblUntil.ToLower() + ":";
                if (DateTimeUntil.SelectedDate != null)
                {
                    ws.Cells["B5"].Value = DateTimeUntil.SelectedDate;
                    ws.Cells["B5"].Style.Numberformat.Format = "DDD, DD.MM.YYYY hh:mm";
                    ws.Cells["B5"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                }

                ws.Cells["A6"].Value = Resources.Resource.lblState + ":";
                ws.Cells["B6"].Value = DateTime.Now.ToString("ddd, dd.MM.yyyy HH:mm");

                ws.Cells["A7"].Value = Resources.Resource.lblUser + ":";
                ws.Cells["B7"].Value = Session["LoginName"].ToString();

                ws.Cells["A1:B7"].AutoFitColumns();

                // Detaildaten
                ws = pck.Workbook.Worksheets.Add(Resources.Resource.lblData);
                ws.Cells["A1"].LoadFromDataTable(dt, true, OfficeOpenXml.Table.TableStyles.Light9);

                // Datumsfelder formatieren
                foreach (DataColumn col in dt.Columns)
                {
                    if (col.DataType == System.Type.GetType("System.DateTime"))
                    {
                        int pos = col.Ordinal + 1;
                        using (ExcelRange range = ws.Cells[2, pos, 2 + dt.Rows.Count, pos])
                        {
                            range.Style.Numberformat.Format = "DD.MM.YYYY hh:mm";
                        }
                    }
                }

                // Änderungen markieren
                string[] primaryKey = selectedTable.OrderBy.Replace(", [EditOn] DESC", "").Replace("[", "").Replace("], ", ",").Replace("]", "").Split(',');
                for (int r = 1; r < dt.Rows.Count; r++)
                {
                    DataRow currentRow = dt.Rows[r - 1];
                    DataRow historizedRow = dt.Rows[r];
                    
                    bool samePrimaryKey = true;
                    for(int k = 0; k < primaryKey.Length; k++)
                    {
                        samePrimaryKey &= currentRow[primaryKey[k]].ToString().Equals(historizedRow[primaryKey[k]].ToString());
                    }

                    if (samePrimaryKey)
                    {
                        for(int c = primaryKey.Length + 1; c < dt.Columns.Count; c++)
                        {
                            if (ws.Cells[r + 2, c].Value != null && ws.Cells[r + 1, c].Value != null && !ws.Cells[r + 2, c].Value.ToString().Equals(ws.Cells[r + 1, c].Value.ToString())) 
                            {
                                ws.Cells[r + 1, c].Style.Font.Color.SetColor(Color.Red);
                            }
                        }
                    }
                }


                ws.Cells[1, 1, 1 + dt.Rows.Count, colCount].AutoFitColumns();

                byte[] fileData = pck.GetAsByteArray();
                Response.Clear();
                Response.AppendHeader("Content-Length", fileData.Length.ToString());
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                string fileDate = DateTime.Now.ToString("yyyyMMddHHmm");
                Response.AddHeader("content-disposition", "attachment;  filename=" + Helpers.CleanFilename(tableName.Replace(" ", "") + fileDate + ".xlsx"));
                Response.BinaryWrite(fileData);
                Response.End();
            }
            // UnloadMe();
        }
    }
}