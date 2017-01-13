using InSite.App.Constants;
using InSite.App.UserServices;
using InSite.App.ReportServices;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services.Protocols;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class Templates : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "TemplateID";

        const int MaxTotalMBytes = 2; // 2 MB
        const int MaxTotalBytes = MaxTotalMBytes * 1024 * 1024;
        Int64 totalBytes;

        public bool? IsRadAsyncValid
        {
            get
            {
                if (Session["IsRadAsyncValid"] == null)
                {
                    Session["IsRadAsyncValid"] = true;
                }

                return Convert.ToBoolean(Session["IsRadAsyncValid"].ToString());
            }
            set
            {
                Session["IsRadAsyncValid"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            IsRadAsyncValid = null;
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Literal für Statusmeldungen
            Helpers.AddGridStatus(RadGrid1, Page);
        }

        protected void RadGrid1_ItemInserted(object sender, GridInsertedEventArgs e)
        {
            // Insert-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, e.Exception.Message), "red");
            }
            else
            {
                SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
            }
        }

        protected void RadGrid1_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
            // Update-Message
            if (e.Exception != null)
            {
                e.KeepInEditMode = true;
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, e.Exception.Message), "red");
            }
            else
            {
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
            }
        }

        protected void RadGrid1_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        private void DisplayMessage(string command, string text, string color)
        {
            // Meldung in Statuszeile und per Notification
            Helpers.UpdateGridStatus(RadGrid1, command, text, color);
            Helpers.ShowMessage(Master, command, text, color);
        }

        private string messageTitle = null;
        private string gridMessage = null;
        private string messageColor = null;

        private void SetMessage(string command, string message, string color)
        {
            // Message-Variablen belegen
            messageTitle = command;
            gridMessage = message;
            messageColor = color;
        }

        protected void RadGrid1_PreRender(object sender, EventArgs e)
        {
            // Gefilterte Spalten hervorheben
            foreach (GridColumn item in (sender as RadGrid).MasterTableView.Columns)
            {
                string filterValue = item.CurrentFilterValue;
                if (filterValue != null && !filterValue.Equals(string.Empty))
                {
                    item.HeaderStyle.ForeColor = System.Drawing.Color.DarkRed;
                    item.HeaderStyle.Font.Bold = true;
                }
                else
                {
                    item.HeaderStyle.ForeColor = System.Drawing.Color.Black;
                    item.HeaderStyle.Font.Bold = false;
                }
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        // RowClick abhandeln
        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            if (e.CommandName == "RowClick")
            {
                GridDataItem item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                item.Expanded = !item.Expanded;
            }

            if (e.CommandName == "EditTemplate")
            {
                // Download der Reportvorlage Excel
                GridDataItem item = e.Item as GridDataItem;
                int templateID = Convert.ToInt32(item.GetDataKeyValue("TemplateID"));
                Master_Templates template = Helpers.GetTemplate(templateID);

                Response.Clear();
                Response.AppendHeader("Content-Length", template.FileData.Length.ToString());
                Response.ContentType = template.FileType;
                Response.AddHeader("content-disposition", "attachment;  filename=" + template.FileName);
                Response.BinaryWrite(template.FileData);
                Response.End();
            }

            if (e.CommandName == "EditTemplateRDL")
            {
                // Download der Reportvorlage SQL Reporting Server
                GridDataItem item = e.Item as GridDataItem;
                int templateID = Convert.ToInt32(item.GetDataKeyValue("TemplateID"));
                Master_Templates template = Helpers.GetTemplate(templateID);

                ReportingService2010SoapClient rs = new ReportingService2010SoapClient();
                rs.ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
                string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
                string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
                string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
                NetworkCredential clientCredentials = new NetworkCredential(userName, userPwd, userDomain);
                rs.ClientCredentials.Windows.ClientCredential = clientCredentials;

                string reportPath = string.Concat("/Insite/S", Session["SystemID"].ToString(), "/B", Session["BpID"].ToString(), "/", template.FileName);
                TrustedUserHeader header = new TrustedUserHeader();
                byte[] reportData = null;

                try
                {
                    // Quelldefinition lesen
                    rs.GetItemDefinition(header, reportPath, out reportData);
                }
                catch (SoapException ex)
                {
                    logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                }
                catch (Exception ex)
                {
                    logger.ErrorFormat("Webservice error: {0}", ex.Message);
                }

                if (reportData != null)
                {
                    Response.Clear();
                    Response.AppendHeader("Content-Length", reportData.Length.ToString());
                    Response.ContentType = "application/rdl";
                    Response.AddHeader("content-disposition", "attachment;  filename=" + template.FileName + ".rdl");
                    Response.BinaryWrite(reportData);
                    Response.End();
                }
            }

            if (e.CommandName == RadGrid.ExportToExcelCommandName || e.CommandName == RadGrid.ExportToCsvCommandName || e.CommandName == RadGrid.ExportToPdfCommandName)
            {
                RadGrid1.ShowGroupPanel = false;
                RadGrid1.Rebind();
            }
        }

        public void OnAjaxUpdate(object sender, Telerik.Web.UI.ToolTipUpdateEventArgs e)
        {
            this.UpdateToolTip(e.Value, e.UpdatePanel);
        }

        private void UpdateToolTip(string elementID, UpdatePanel panel)
        {
            //Control ctrl = Page.LoadControl("~/Controls/RelevantDocumentsToolTip.ascx");
            //RelevantDocumentsToolTip details = (RelevantDocumentsToolTip)ctrl;
            //details.DetailID = elementID;
            //panel.ContentTemplateContainer.Controls.Add(ctrl);
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);

            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                RadAsyncUpload upload = ((GridEditableItem)e.Item).FindControl("AsyncUploadXLS") as RadAsyncUpload;
                Control cell = upload.Parent;

                CustomValidator validator = new CustomValidator();
                validator.ErrorMessage = Resources.Resource.msgSelectFile;
                validator.ClientValidationFunction = "validateRadUpload";
                validator.Display = ValidatorDisplay.Dynamic;
                cell.Controls.Add(validator);

                RadGrid1.Controls.Add(new LiteralControl("<script type='text/javascript'>window['upload'] = '" + upload.ClientID + "';</script>"));

                upload = ((GridEditableItem)e.Item).FindControl("AsyncUploadRDL") as RadAsyncUpload;
                cell = upload.Parent;

                cell.Controls.Add(validator);

                RadGrid1.Controls.Add(new LiteralControl("<script type='text/javascript'>window['upload'] = '" + upload.ClientID + "';</script>"));
            }
        }

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }
        }

        protected void AsyncUpload1_FileUploaded(object sender, FileUploadedEventArgs e)
        {
            if ((totalBytes < MaxTotalBytes) && (e.File.ContentLength < MaxTotalBytes))
            {
                e.IsValid = true;
                totalBytes += e.File.ContentLength;
                IsRadAsyncValid = true;
            }
            else
            {
                e.IsValid = false;
                IsRadAsyncValid = false;
            }
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT m_t.*, ISNULL(s_d.ResourceID, '') AS DialogName, '/InSiteApp/Resources/' + ISNULL(s_i.ImagePath, '') + '/' + ISNULL(s_i.ImageName, '') AS ImageUrl ");
            sql.Append("FROM Master_Templates AS m_t ");
            sql.Append("LEFT OUTER JOIN Master_TreeNodes AS s_d ");
            sql.Append("ON m_t.SystemID = s_d.SystemID ");
            sql.Append("AND m_t.DialogID = s_d.DialogID ");
            sql.Append("LEFT OUTER JOIN System_Images AS s_i ");
            sql.Append("ON s_d.SystemID = s_i.SystemID ");
            sql.Append("AND s_d.ImageID = s_i.ImageID ");
            sql.Append("WHERE m_t.SystemID = @SystemID ");
            sql.Append("AND m_t.BpID = @BpID ");
            sql.Append("ORDER BY m_t.NameVisible ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
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
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        row["DialogName"] = GetResource(row["DialogName"].ToString());
                    }
                }
                RadGrid1.DataSource = dt;
            }
            catch (SqlException ex)
            {
                Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
                SetMessage(Resources.Resource.lblActionSelect, String.Format(Resources.Resource.msgSelectFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
                SetMessage(Resources.Resource.lblActionSelect, String.Format(Resources.Resource.msgSelectFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            if (!IsRadAsyncValid.Value)
            {
                e.Canceled = true;
                Alert(String.Format(Resources.Resource.msgMaxFileLength, MaxTotalMBytes));
                return;
            }

            GridEditFormInsertItem insertItem = e.Item as GridEditFormInsertItem;


            int dialogID = Convert.ToInt32((insertItem["DialogID"].FindControl("DialogID") as RadDropDownTree).SelectedValue);
            Webservices webservice = new Webservices();
            System_Dialogs dialog = webservice.GetDialog(dialogID);

            RadAsyncUpload radAsyncUpload;
            if (dialog.UseReportingServer)
            {
                radAsyncUpload = insertItem["FileName"].FindControl("AsyncUploadRDL") as RadAsyncUpload;
            }
            else
            {
                radAsyncUpload = insertItem["FileName"].FindControl("AsyncUploadXLS") as RadAsyncUpload;
            }

            byte[] fileData = default(byte[]);
            UploadedFile file = null;

            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                file = radAsyncUpload.UploadedFiles[0];
                fileData = new byte[file.InputStream.Length];
                file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
            }

            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO Master_Templates(SystemID, BpID, NameVisible, DescriptionShort, FileName, ");
            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                sql.Append("FileData, FileType, ");
            }
            sql.Append("DialogID, IsDefault, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
            sql.Append("OUTPUT INSERTED.TemplateID ");
            sql.AppendLine("VALUES (@SystemID, @BpID, @NameVisible, @DescriptionShort, @FileName, ");
            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                sql.Append("@FileData, @FileType, ");
            }
            sql.Append("@DialogID, @IsDefault, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()); ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@NameVisible", SqlDbType.NVarChar, 50);
            par.Value = (insertItem["NameVisible"].FindControl("NameVisible") as RadTextBox).Text;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@DescriptionShort", SqlDbType.NVarChar, 200);
            par.Value = (insertItem["DescriptionShort"].FindControl("DescriptionShort") as RadTextBox).Text;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@FileName", SqlDbType.NVarChar, 200);
            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                if (dialog.UseReportingServer)
                {
                    par.Value = Helpers.CleanFilename(file.GetNameWithoutExtension());
                }
                else
                {
                    par.Value = Helpers.CleanFilename(file.GetName());
                }
            }
            else
            {
                Panel panel = insertItem.FindControl("PanelServerReport") as Panel;
                if (panel != null && panel.Visible)
                {
                    RadComboBox cb = insertItem.FindControl("FileName") as RadComboBox;
                    if (cb != null && !cb.SelectedValue.Equals(string.Empty))
                    {
                        par.Value = cb.SelectedValue;
                    }
                    else
                    {
                        par.Value = string.Empty;
                    }
                }
                else
                {
                    par.Value = string.Empty;
                }
            }
            cmd.Parameters.Add(par);

            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                par = new SqlParameter("@FileData", SqlDbType.Image);
                par.Value = fileData;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@FileType", SqlDbType.NVarChar, 200);
                par.Value = file.ContentType;
                cmd.Parameters.Add(par);

                if (file.GetExtension().ToLower().Equals(".rdl"))
                {
                    ReportingService2010SoapClient rs = new ReportingService2010SoapClient();
                    rs.ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
                    string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
                    string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
                    string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
                    NetworkCredential clientCredentials = new NetworkCredential(userName, userPwd, userDomain);
                    rs.ClientCredentials.Windows.ClientCredential = clientCredentials;

                    string reportPath = string.Concat("/Insite/S", Session["SystemID"].ToString(), "/B", Session["BpID"].ToString());
                    CatalogItem info = new CatalogItem();
                    Property[] properties = null;
                    TrustedUserHeader header = new TrustedUserHeader();
                    Warning[] warnings;

                    try
                    {
                        rs.CreateCatalogItem(header, "Report", file.GetNameWithoutExtension(), reportPath, true, fileData, properties, out info, out warnings);
                    }
                    catch (SoapException ex)
                    {
                        logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                    }
                    catch (Exception ex)
                    {
                        logger.ErrorFormat("Webservice error: {0}", ex.Message);
                    }
                }
            }

            par = new SqlParameter("@DialogID", SqlDbType.Int);
            par.Value = (insertItem["DialogID"].FindControl("DialogID") as RadDropDownTree).SelectedValue;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@IsDefault", SqlDbType.Bit);
            par.Value = (insertItem["IsDefault"].FindControl("IsDefault") as CheckBox).Checked;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = Session["LoginName"].ToString();
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                int templateID = (int)cmd.ExecuteScalar();

                Helpers.DialogLogger(type, Actions.Create, templateID.ToString(), Resources.Resource.lblActionCreate);
                SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
            }
            catch (SqlException ex)
            {
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadGrid1_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            if (!IsRadAsyncValid.Value)
            {
                e.Canceled = true;
                Alert(String.Format(Resources.Resource.msgMaxFileLength, MaxTotalMBytes));
                return;
            }

            GridEditableItem editItem = e.Item as GridEditableItem;

            int dialogID = Convert.ToInt32((editItem["DialogID"].FindControl("DialogID") as RadDropDownTree).SelectedValue);
            Webservices webservice = new Webservices();
            System_Dialogs dialog = webservice.GetDialog(dialogID);

            int templateID = Convert.ToInt32(editItem.OwnerTableView.DataKeyValues[editItem.ItemIndex]["TemplateID"].ToString());
            RadAsyncUpload radAsyncUpload;
            if (dialog.UseReportingServer)
            {
                radAsyncUpload = editItem["FileName"].FindControl("AsyncUploadRDL") as RadAsyncUpload;
            }
            else
            {
                radAsyncUpload = editItem["FileName"].FindControl("AsyncUploadXLS") as RadAsyncUpload;
            }

            byte[] fileData = default(byte[]);
            UploadedFile file = null;

            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                file = radAsyncUpload.UploadedFiles[0];
                fileData = new byte[file.InputStream.Length];
                file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
            }

            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE Master_Templates SET NameVisible = @NameVisible, DescriptionShort = @DescriptionShort, FileName = @FileName, ");
            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                sql.Append("FileData = @FileData, FileType = @FileType, ");
            }
            sql.Append("DialogID = @DialogID, IsDefault = @IsDefault, EditFrom = @UserName, EditOn = SYSDATETIME() ");
            sql.Append("WHERE SystemID = @SystemID AND BpID = @BpID AND TemplateID = @TemplateID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@TemplateID", SqlDbType.Int);
            par.Value = templateID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@NameVisible", SqlDbType.NVarChar, 50);
            par.Value = (editItem["NameVisible"].FindControl("NameVisible") as RadTextBox).Text;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@DescriptionShort", SqlDbType.NVarChar, 200);
            par.Value = (editItem["DescriptionShort"].FindControl("DescriptionShort") as RadTextBox).Text;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@FileName", SqlDbType.NVarChar, 200);
            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                if (dialog.UseReportingServer)
                {
                    par.Value = Helpers.CleanFilename(file.GetNameWithoutExtension());
                }
                else
                {
                    par.Value = Helpers.CleanFilename(file.GetName());
                }
            }
            else
            {
                Panel panel = editItem.FindControl("PanelServerReport") as Panel;
                if (panel != null && panel.Visible)
                {
                    RadComboBox cb = editItem.FindControl("FileName") as RadComboBox;
                    if (cb != null && !cb.SelectedValue.Equals(string.Empty))
                    {
                        par.Value = cb.SelectedValue;
                    }
                    else
                    {
                        par.Value = string.Empty;
                    }
                }
                else
                {
                    par.Value = string.Empty;
                }
            }
            cmd.Parameters.Add(par);

            if (radAsyncUpload.UploadedFiles.Count > 0)
            {
                // Vorlage auf Reportserver speichern
                par = new SqlParameter("@FileData", SqlDbType.Image);
                par.Value = fileData;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@FileType", SqlDbType.NVarChar, 200);
                par.Value = file.ContentType;
                cmd.Parameters.Add(par);

                if (file.GetExtension().ToLower().Equals(".rdl"))
                {
                    ReportingService2010SoapClient rs = new ReportingService2010SoapClient();
                    rs.ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
                    string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
                    string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
                    string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
                    NetworkCredential clientCredentials = new NetworkCredential(userName, userPwd, userDomain);
                    rs.ClientCredentials.Windows.ClientCredential = clientCredentials;

                    string reportPath = string.Concat("/Insite/S", Session["SystemID"].ToString(), "/B", Session["BpID"].ToString());
                    CatalogItem info = new CatalogItem();
                    Property[] properties = null;
                    TrustedUserHeader header = new TrustedUserHeader();
                    Warning[] warnings;

                    try
                    {
                        rs.CreateCatalogItem(header, "Report", file.GetNameWithoutExtension(), reportPath, true, fileData, properties, out info, out warnings);
                    }
                    catch (SoapException ex)
                    {
                        logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                    }
                    catch (Exception ex)
                    {
                        logger.ErrorFormat("Webservice error: {0}", ex.Message);
                    }
                }
            }

            par = new SqlParameter("@DialogID", SqlDbType.Int);
            par.Value = dialogID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@IsDefault", SqlDbType.Bit);
            par.Value = (editItem["IsDefault"].FindControl("IsDefault") as CheckBox).Checked;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = Session["LoginName"].ToString();
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Edit, templateID.ToString(), Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
            }
            catch (SqlException ex)
            {
                SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            int templateID = (int)((GridDataItem)e.Item).GetDataKeyValue("TemplateID");

            StringBuilder sql = new StringBuilder();
            sql.Append("DELETE FROM Master_Templates ");
            sql.Append("WHERE SystemID = @SystemID AND BpID = @BpID AND TemplateID = @TemplateID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@TemplateID", SqlDbType.Int);
            par.Value = templateID;
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Delete, templateID.ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
            catch (SqlException ex)
            {
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }
        }

        protected void DialogID_DataBound(object sender, EventArgs e)
        {
            RadDropDownTree rddt = sender as RadDropDownTree;
            rddt.ExpandAllDropDownNodes();
        }

        protected void DialogID_EntryAdded(object sender, DropDownTreeEntryEventArgs e)
        {
            int dialogID = Convert.ToInt32(e.Entry.Value);
            Webservices webservice = new Webservices();
            System_Dialogs dialog = webservice.GetDialog(dialogID);
            Panel panelOffice;
            Panel panelServer;

            if (dialog != null)
            {
                if (dialog.UseReportingServer)
                {
                    RadComboBox cb;

                    if ((sender as RadDropDownTree).NamingContainer is GridEditFormInsertItem)
                    {
                        panelOffice = ((sender as RadDropDownTree).NamingContainer as GridEditFormInsertItem).FindControl("PanelOfficeReport") as Panel;
                        panelServer = ((sender as RadDropDownTree).NamingContainer as GridEditFormInsertItem).FindControl("PanelServerReport") as Panel;
                        cb = ((sender as RadDropDownTree).NamingContainer as GridEditFormInsertItem).FindControl("FileName") as RadComboBox;
                    }
                    else
                    {
                        panelOffice = ((sender as RadDropDownTree).NamingContainer as GridEditFormItem).FindControl("PanelOfficeReport") as Panel;
                        panelServer = ((sender as RadDropDownTree).NamingContainer as GridEditFormItem).FindControl("PanelServerReport") as Panel;
                        cb = ((sender as RadDropDownTree).NamingContainer as GridEditFormItem).FindControl("FileName") as RadComboBox;
                    }
                    panelOffice.Visible = false;

                    ReportingService2010SoapClient rs = new ReportingService2010SoapClient();
                    rs.ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
                    string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
                    string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
                    string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
                    NetworkCredential clientCredentials = new NetworkCredential(userName, userPwd, userDomain);
                    rs.ClientCredentials.Windows.ClientCredential = clientCredentials;

                    rs.Open();

                    string rootPath = string.Concat("/Insite/S", Session["SystemID"].ToString(), "/B", Session["BpID"].ToString());
                    TrustedUserHeader header = new TrustedUserHeader();

                    CatalogItem[] items = null;

                    // Items im Quellordner auflisten
                    try
                    {
                        rs.ListChildren(header, rootPath, true, out items);
                    }
                    catch (SoapException ex)
                    {
                        logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                    }
                    catch (Exception ex)
                    {
                        logger.ErrorFormat("Webservice error: {0}", ex.Message);
                    }

                    if (items != null)
                    {
                        // Items durchlaufen
                        foreach (CatalogItem item in items)
                        {
                            if (item.TypeName.Equals("Report"))
                            {
                                RadComboBoxItem cbItem = new RadComboBoxItem();
                                cbItem.Text = item.Name;
                                cbItem.Value = item.Name;
                                cb.Items.Add(cbItem);
                            }
                        }
                        cb.DataBind();
                    }
                    panelServer.Visible = true;

                    cb.Focus();
                }
                else
                {
                    if ((sender as RadDropDownTree).NamingContainer is GridEditFormInsertItem)
                    {
                        panelOffice = ((sender as RadDropDownTree).NamingContainer as GridEditFormInsertItem).FindControl("PanelOfficeReport") as Panel;
                        panelServer = ((sender as RadDropDownTree).NamingContainer as GridEditFormInsertItem).FindControl("PanelServerReport") as Panel;
                    }
                    else
                    {
                        panelOffice = ((sender as RadDropDownTree).NamingContainer as GridEditFormItem).FindControl("PanelOfficeReport") as Panel;
                        panelServer = ((sender as RadDropDownTree).NamingContainer as GridEditFormItem).FindControl("PanelServerReport") as Panel;
                    }
                    panelOffice.Visible = true;
                    panelServer.Visible = false;
                }
            }
            else
            {
                if ((sender as RadDropDownTree).NamingContainer is GridEditFormInsertItem)
                {
                    panelOffice = ((sender as RadDropDownTree).NamingContainer as GridEditFormInsertItem).FindControl("PanelOfficeReport") as Panel;
                    panelServer = ((sender as RadDropDownTree).NamingContainer as GridEditFormInsertItem).FindControl("PanelServerReport") as Panel;
                }
                else
                {
                    panelOffice = ((sender as RadDropDownTree).NamingContainer as GridEditFormItem).FindControl("PanelOfficeReport") as Panel;
                    panelServer = ((sender as RadDropDownTree).NamingContainer as GridEditFormItem).FindControl("PanelServerReport") as Panel;
                }
                panelOffice.Visible = false;
                panelServer.Visible = false;
            }
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem))
            {
                GridEditFormItem editItem = e.Item as GridEditFormItem;
                int dialogID = Convert.ToInt32(((DataRowView)e.Item.DataItem)["DialogID"]);
                if (dialogID != 0)
                {
                    Webservices webservice = new Webservices();
                    System_Dialogs dialog = webservice.GetDialog(dialogID);

                    Panel panelOffice = editItem.FindControl("PanelOfficeReport") as Panel;
                    Panel panelServer = editItem.FindControl("PanelServerReport") as Panel;

                    if (dialog.UseReportingServer)
                    {
                        RadComboBox cb = editItem.FindControl("FileName") as RadComboBox;

                        panelOffice.Visible = false;

                        ReportingService2010SoapClient rs = new ReportingService2010SoapClient();
                        rs.ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
                        string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
                        string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
                        string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
                        NetworkCredential clientCredentials = new NetworkCredential(userName, userPwd, userDomain);
                        rs.ClientCredentials.Windows.ClientCredential = clientCredentials;

                        string rootPath = string.Concat("/Insite/S", Session["SystemID"].ToString(), "/B", Session["BpID"].ToString());
                        TrustedUserHeader header = new TrustedUserHeader();

                        CatalogItem[] items = null;

                        // Items im Quellordner auflisten
                        try
                        {
                            rs.ListChildren(header, rootPath, true, out items);
                        }
                        catch (SoapException ex)
                        {
                            logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                        }
                        catch (Exception ex)
                        {
                            logger.ErrorFormat("Webservice error: {0}", ex.Message);
                        }

                        string fileName = ((DataRowView)e.Item.DataItem)["FileName"].ToString();

                        // Items durchlaufen
                        foreach (CatalogItem item in items)
                        {
                            if (item.TypeName.Equals("Report"))
                            {
                                RadComboBoxItem cbItem = new RadComboBoxItem();
                                cbItem.Text = item.Name;
                                cbItem.Value = item.Name;
                                if (item.Name.Equals(fileName))
                                {
                                    cbItem.Selected = true;
                                }
                                cb.Items.Add(cbItem);
                            }
                        }
                        cb.DataBind();

                        panelServer.Visible = true;

                        cb.Focus();
                    }
                    else
                    {
                        panelOffice.Visible = true;
                        panelServer.Visible = false;
                    }
                }
            }
        }
    }
}