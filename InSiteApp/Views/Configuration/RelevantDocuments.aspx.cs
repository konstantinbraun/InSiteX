using InSite.App.Constants;
using InSite.App.Controls;
using System;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class RelevantDocuments : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "RelevantDocumentID";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Literal für Statusmeldungen
            Helpers.AddGridStatus(RadGrid1, Page);
        }

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

            protected override void OnLoad(EventArgs e)
            {
                base.OnLoad(e);

                IsRadAsyncValid = null;
            }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                RadAsyncUpload upload = ((GridEditableItem)e.Item).FindControl("AsyncUpload1") as RadAsyncUpload;
                Control cell = upload.Parent;

                CustomValidator validator = new CustomValidator();
                validator.ErrorMessage = Resources.Resource.msgSelectFile;
                validator.ClientValidationFunction = "validateRadUpload";
                validator.Display = ValidatorDisplay.Dynamic;
                cell.Controls.Add(validator);
            }
        }

        protected string TrimDescription(string description)
        {
            if (!string.IsNullOrEmpty(description) && description.Length > 200)
            {
                return string.Concat(description.Substring(0, 200), "...");
            }
            return description;
        }


        private static DataTable GetDataTable(string queryString)
        {
            SqlConnection mySqlConnection = new SqlConnection(ConnectionString);
            SqlDataAdapter mySqlDataAdapter = new SqlDataAdapter();
            mySqlDataAdapter.SelectCommand = new SqlCommand(queryString, mySqlConnection);

            DataTable myDataTable = new DataTable();
            mySqlConnection.Open();
            try
            {
                mySqlDataAdapter.Fill(myDataTable);
            }
            finally
            {
                mySqlConnection.Close();
            }

            return myDataTable;
        }

        protected void RadGrid1_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT SystemID, BpID, RelevantDocumentID, RelevantFor, NameVisible, DescriptionShort, IsAccessRelevant, RecExpirationDate, RecIDNumber, ");
            sql.Append("SampleFileName, SampleData, CreatedFrom, CreatedOn, EditFrom, EditOn ");
            sql.Append("FROM Master_RelevantDocuments ");
            sql.AppendFormat("WHERE (SystemID = {0}) AND (BpID = {1}) ", Session["SystemID"].ToString(), Session["BpID"].ToString());
            sql.Append("ORDER BY NameVisible ");

            SqlDataSource_RelevantDocuments.SelectCommand = sql.ToString();
            RadGrid1.DataBind();
            // RadGrid1.DataSource = GetDataTable(sql.ToString());
        }

        protected void RadGrid1_InsertCommand(object source, GridCommandEventArgs e)
        {
            if (!IsRadAsyncValid.Value)
            {
                e.Canceled = true;
                Alert(String.Format(Resources.Resource.msgMaxFileLength, MaxTotalMBytes));
                return;
            }

            GridEditFormInsertItem insertItem = e.Item as GridEditFormInsertItem;
            RadAsyncUpload radAsyncUpload = insertItem.FindControl("AsyncUpload1") as RadAsyncUpload;

            UploadedFile file = null;
            byte[] fileData = default(byte[]);

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO Master_RelevantDocuments ");
                sql.Append("(SystemID, BpID, RelevantFor, NameVisible, DescriptionShort, IsAccessRelevant, RecExpirationDate, RecIDNumber, ");

                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    file = radAsyncUpload.UploadedFiles[0];
                    fileData = new byte[file.InputStream.Length];
                    file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
                    sql.Append("SampleFileName, SampleData, ");
                }

                sql.Append("CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                sql.Append("OUTPUT INSERTED.RelevantDocumentID ");
                sql.Append("VALUES (@SystemID, @BpID, @RelevantFor, @NameVisible, @DescriptionShort, @IsAccessRelevant, @RecExpirationDate, @RecIDNumber, ");

                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    sql.Append("@SampleFileName, @SampleData, ");
                }

                sql.Append("@UserName, SYSDATETIME(), @UserName, SYSDATETIME()) ");

                SqlCommand cmd = new SqlCommand(sql.ToString(), conn);

                cmd.Parameters.Add("@SystemID", SqlDbType.Int);
                cmd.Parameters.Add("@BpID", SqlDbType.Int);
                cmd.Parameters.Add("@RelevantFor", SqlDbType.TinyInt);
                cmd.Parameters.Add("@NameVisible", SqlDbType.NVarChar, 50);
                cmd.Parameters.Add("@DescriptionShort", SqlDbType.NVarChar, 200);
                cmd.Parameters.Add("@IsAccessRelevant", SqlDbType.Bit);
                cmd.Parameters.Add("@RecExpirationDate", SqlDbType.Bit);
                cmd.Parameters.Add("@RecIDNumber", SqlDbType.Bit);

                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    cmd.Parameters.Add("@SampleFileName", SqlDbType.NVarChar, 200);
                    cmd.Parameters.Add("@SampleData", SqlDbType.Image);
                }
                cmd.Parameters.Add("@UserName", SqlDbType.NVarChar, 50);

                cmd.Parameters["@SystemID"].Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters["@BpID"].Value = Convert.ToInt32(Session["BpID"]);
                cmd.Parameters["@RelevantFor"].Value = Convert.ToInt16((insertItem.FindControl("RadDropDownList_RelevantFor") as RadDropDownList).SelectedValue);
                cmd.Parameters["@NameVisible"].Value = (insertItem.FindControl("NameVisible") as RadTextBox).Text;
                cmd.Parameters["@DescriptionShort"].Value = (insertItem.FindControl("DescriptionShort") as RadTextBox).Text;
                cmd.Parameters["@IsAccessRelevant"].Value = (insertItem.FindControl("IsAccessRelevant") as CheckBox).Checked;
                cmd.Parameters["@RecExpirationDate"].Value = (insertItem.FindControl("RecExpirationDate") as CheckBox).Checked;
                cmd.Parameters["@RecIDNumber"].Value = (insertItem.FindControl("RecIDNumber") as CheckBox).Checked;

                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    cmd.Parameters["@SampleFileName"].Value = Helpers.CleanFilename(file.GetName());
                    cmd.Parameters["@SampleData"].Value = fileData;
                }
                cmd.Parameters["@UserName"].Value = Session["LoginName"].ToString();

                int relevantDocumentID = 0;

                try
                {
                    relevantDocumentID = (int)cmd.ExecuteScalar();

                    Helpers.DialogLogger(type, Actions.Create, relevantDocumentID.ToString(), Resources.Resource.lblActionCreate);
                    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                    
                    // RadGrid1.MasterTableView.IsItemInserted = false;
                    // RadGrid1.Rebind();

                    // Hinweistexte anlegen
                    cmd = new SqlCommand();
                    cmd.Connection = conn;

                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "CreateAlternateTranslations";
                    cmd.Parameters.Add("@SystemID", SqlDbType.Int);
                    cmd.Parameters.Add("@BpID", SqlDbType.Int);
                    cmd.Parameters.Add("@DialogID", SqlDbType.Int);
                    cmd.Parameters.Add("@FieldID", SqlDbType.Int);
                    cmd.Parameters.Add("@ForeignID", SqlDbType.Int);
                    cmd.Parameters["@SystemID"].Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters["@BpID"].Value = Convert.ToInt32(Session["BpID"]);

                    cmd.Parameters["@SystemID"].Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters["@BpID"].Value = Convert.ToInt32(Session["BpID"]);
                    cmd.Parameters["@DialogID"].Value = "6";
                    cmd.Parameters["@ForeignID"].Value = relevantDocumentID.ToString();

                    cmd.Parameters["@FieldID"].Value = "13";
                    cmd.ExecuteScalar();

                    cmd.Parameters["@FieldID"].Value = "14";
                    cmd.ExecuteScalar();
                }
                catch (SqlException ex)
                {
                    SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }
                catch (System.Exception ex)
                {
                    SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }
            }
        }

        protected void RadGrid1_UpdateCommand(object source, GridCommandEventArgs e)
        {
            if (!IsRadAsyncValid.Value)
            {
                e.Canceled = true;
                Alert(String.Format(Resources.Resource.msgMaxFileLength, MaxTotalMBytes));
                return;
            }
            GridEditableItem editedItem = e.Item as GridEditableItem;
            RadAsyncUpload radAsyncUpload = editedItem.FindControl("AsyncUpload1") as RadAsyncUpload;

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();
                SqlCommand cmd;
                byte[] fileData = default(byte[]);
                UploadedFile file = null;

                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO History_RelevantDocuments SELECT * FROM Master_RelevantDocuments ");
                sql.AppendLine("WHERE [SystemID] = @SystemID AND [BpID] = @BpID AND (RelevantDocumentID = @RelevantDocumentID); ");
                sql.Append("UPDATE Master_RelevantDocuments ");
                sql.Append("SET RelevantFor = @RelevantFor, NameVisible = @NameVisible, DescriptionShort = @DescriptionShort, IsAccessRelevant = @IsAccessRelevant, ");
                sql.Append("RecExpirationDate = @RecExpirationDate, RecIDNumber = @RecIDNumber, ");

                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    sql.Append("SampleFileName = @SampleFileName, SampleData = @SampleData, ");

                    file = radAsyncUpload.UploadedFiles[0];
                    fileData = new byte[file.InputStream.Length];
                    file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
                }
                sql.Append("EditFrom = @UserName, EditOn = SYSDATETIME() ");
                sql.Append("WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (RelevantDocumentID = @RelevantDocumentID)");

                cmd = new SqlCommand(sql.ToString(), conn);

                cmd.Parameters.Add("@SystemID", SqlDbType.Int);
                cmd.Parameters.Add("@BpID", SqlDbType.Int);
                cmd.Parameters.Add("@RelevantDocumentID", SqlDbType.Int);
                cmd.Parameters.Add("@RelevantFor", SqlDbType.TinyInt);
                cmd.Parameters.Add("@NameVisible", SqlDbType.NVarChar, 50);
                cmd.Parameters.Add("@DescriptionShort", SqlDbType.NVarChar, 200);
                cmd.Parameters.Add("@IsAccessRelevant", SqlDbType.Bit);
                cmd.Parameters.Add("@RecExpirationDate", SqlDbType.Bit);
                cmd.Parameters.Add("@RecIDNumber", SqlDbType.Bit);

                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    cmd.Parameters.Add("@SampleData", SqlDbType.Image);
                    cmd.Parameters.Add("@SampleFileName", SqlDbType.NVarChar, 200);
                }
                cmd.Parameters.Add("@UserName", SqlDbType.NVarChar, 50);

                cmd.Parameters["@SystemID"].Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters["@BpID"].Value = Convert.ToInt32(Session["BpID"]);
                cmd.Parameters["@RelevantDocumentID"].Value = Convert.ToInt32(editedItem.GetDataKeyValue("RelevantDocumentID"));
                cmd.Parameters["@RelevantFor"].Value = Convert.ToInt16((editedItem.FindControl("RadDropDownList_RelevantFor") as RadDropDownList).SelectedValue);
                cmd.Parameters["@NameVisible"].Value = (editedItem.FindControl("NameVisible") as RadTextBox).Text;
                cmd.Parameters["@DescriptionShort"].Value = (editedItem.FindControl("DescriptionShort") as RadTextBox).Text;
                cmd.Parameters["@IsAccessRelevant"].Value = (editedItem.FindControl("IsAccessRelevant") as CheckBox).Checked;
                cmd.Parameters["@RecExpirationDate"].Value = (editedItem.FindControl("RecExpirationDate") as CheckBox).Checked;
                cmd.Parameters["@RecIDNumber"].Value = (editedItem.FindControl("RecIDNumber") as CheckBox).Checked;

                if (radAsyncUpload.UploadedFiles.Count > 0)
                {
                    cmd.Parameters["@SampleData"].Value = fileData;
                    cmd.Parameters["@SampleFileName"].Value = Helpers.CleanFilename(file.GetName());
                }
                cmd.Parameters["@UserName"].Value = Session["LoginName"].ToString();

                try
                {
                    cmd.ExecuteScalar();
                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");

                    Helpers.DialogLogger(type, Actions.Edit, editedItem.GetDataKeyValue("RelevantDocumentID").ToString(), Resources.Resource.lblActionEdit);
                    Helpers.SetAction(Actions.View);
                }
                catch (SqlException ex)
                {
                    SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }
                catch (System.Exception ex)
                {
                    SetMessage(Resources.Resource.lblActionUpdate, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }

                Helpers.RelevantDocumentChanged(Convert.ToInt32(editedItem.GetDataKeyValue("RelevantDocumentID")));
            }
        }

        protected void RadGrid1_DeleteCommand(object source, GridCommandEventArgs e)
        {

            GridDataItem deletedItem = e.Item as GridDataItem;

            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                conn.Open();

                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO History_RelevantDocuments SELECT * FROM Master_RelevantDocuments ");
                sql.AppendLine("WHERE [SystemID] = @SystemID AND [BpID] = @BpID AND (RelevantDocumentID = @RelevantDocumentID); ");
                sql.Append("DELETE FROM  Master_RelevantDocuments ");
                sql.Append("WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (RelevantDocumentID = @RelevantDocumentID) ");
                SqlCommand cmd = new SqlCommand(sql.ToString(), conn);

                cmd.Parameters.Add("@SystemID", SqlDbType.Int);
                cmd.Parameters.Add("@BpID", SqlDbType.Int);
                cmd.Parameters.Add("@RelevantDocumentID", SqlDbType.Int);

                cmd.Parameters["@SystemID"].Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters["@BpID"].Value = Convert.ToInt32(Session["BpID"]);
                cmd.Parameters["@RelevantDocumentID"].Value = Convert.ToInt32(deletedItem.GetDataKeyValue("RelevantDocumentID"));

                try
                {
                    cmd.ExecuteScalar();
                    SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
                }
                catch (SqlException ex)
                {
                    SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }
                catch (System.Exception ex)
                {
                    SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgUpdateFailed, ex.Message), "red");
                }
            }
        }

        public void RadAsyncUpload1_ValidatingFile(object sender, Telerik.Web.UI.Upload.ValidateFileEventArgs e)
        {
            if ((totalBytes < MaxTotalBytes) && (e.UploadedFile.ContentLength < MaxTotalBytes))
            {
                e.IsValid = true;
                totalBytes += e.UploadedFile.ContentLength;
                IsRadAsyncValid = true;
            }
            else
            {
                e.IsValid = false;
                IsRadAsyncValid = false;
            }
        }

        protected void RadGrid1_ItemCommand(object source, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            if (e.CommandName == RadGrid.EditCommandName)
            {
                // ScriptManager.RegisterStartupScript(Page, Page.GetType(), "SetEditMode", "isEditMode = true;", true);
            }
        
            GridDataItem dataItem = e.Item as GridDataItem;
            if (dataItem != null)
            {
                string foreignID = dataItem.GetDataKeyValue("RelevantDocumentID").ToString();
                SqlDataSource_Translations1.SelectParameters["ForeignID"].DefaultValue = foreignID;
                SqlDataSource_Translations2.SelectParameters["ForeignID"].DefaultValue = foreignID;
            }

            if (e.CommandName == "RowClick" && !(e.CommandArgument as string).Equals(string.Empty))
            {
                // RowClick abhandeln
                GridDataItem item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);

                item.Expanded = !item.Expanded;

                Helpers.SetAction(Actions.View);
            }

            if (e.CommandName == RadGrid.InitInsertCommandName)
            {
                // cancel the default operation
                e.Canceled = true;

                //Prepare an IDictionary with the predefined values
                ListDictionary newValues = new ListDictionary();
                newValues["RelevantFor"] = 0;
                newValues["NameVisible"] = "";
                newValues["DescriptionShort"] = "";
                newValues["IsAccessRelevant"] = true;
                newValues["RecExpirationDate"] = true;
                newValues["RecIDNumber"] = true;
                newValues["SampleFileName"] = "";

                //Insert the item and rebind
                e.Item.OwnerTableView.InsertItem(newValues);
            }

            if (e.CommandName == "Sort" || e.CommandName == "Page" || e.CommandName == "Filter")
            {
                RadToolTipManager1.TargetControls.Clear();
            }
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
                Helpers.DialogLogger(type, Actions.Edit, (e.Item as GridEditFormItem).GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionUpdate);
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
                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionDelete);
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

        public void OnAjaxUpdate(object sender, Telerik.Web.UI.ToolTipUpdateEventArgs e)
        {
            this.UpdateToolTip(e.Value, e.UpdatePanel);
        }

        private void UpdateToolTip(string elementID, UpdatePanel panel)
        {
            Control ctrl = Page.LoadControl("~/Controls/RelevantDocumentPopUp.ascx");
            RelevantDocumentPopUp details = (RelevantDocumentPopUp)ctrl;
            details.RelevantDocumentID = Convert.ToInt32(elementID);
            panel.ContentTemplateContainer.Controls.Add(ctrl);
        }

        protected void RadGrid2_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
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

        protected void RadGrid2_PreRender(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        protected void RadGrid3_ItemUpdated(object sender, GridUpdatedEventArgs e)
        {
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

        protected void RadGrid3_PreRender(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        private void GoToNextPageView()
        {
            RadMultiPage multiPage = (RadMultiPage)this.NamingContainer.FindControl("RadMultiPage1");
            RadPageView page2 = multiPage.FindPageViewByID("RadPageView2");
            page2.Selected = true;
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                RadBinaryImage bi = e.Item.FindControl("SampleData") as RadBinaryImage;
                if (bi != null)
                {
                    int relevantDocumentID = Convert.ToInt32(((DataRowView)e.Item.DataItem)["RelevantDocumentID"]);
                    byte[] sampleData = Helpers.GetRelevantDocumentImage(relevantDocumentID, 60, 60);
                    if (sampleData.Length != 0)
                    {
                        bi.DataValue = sampleData;
                        //Add the button (target) id to the tooltip manager              
                    this.RadToolTipManager1.TargetControls.Add(bi.ClientID, relevantDocumentID.ToString(), true);
                    }
                }
            }

            if (e.Item is GridGroupHeaderItem)
            {
                GridGroupHeaderItem item = (GridGroupHeaderItem)e.Item;
                DataRowView groupDataRow = (DataRowView)e.Item.DataItem;
                item.DataCell.Text = Resources.Resource.lblRelevantFor + ": " + GetRelevantFor(Convert.ToInt16(groupDataRow["RelevantFor"]));
            }

            if (e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem))
            {
                GridEditableItem item = (GridEditableItem)e.Item;
                RadBinaryImage bi = item.FindControl("SampleData") as RadBinaryImage;
                if (bi != null)
                {
                    int relevantDocumentID = Convert.ToInt32(((DataRowView)e.Item.DataItem)["RelevantDocumentID"]);
                    byte[] sampleData = Helpers.GetRelevantDocumentImage(relevantDocumentID, 200, 200);
                    if (sampleData.Length != 0)
                    {
                        bi.DataValue = sampleData;
                        //Add the button (target) id to the tooltip manager
                        this.RadToolTipManager1.TargetControls.Add(bi.ClientID, relevantDocumentID.ToString(), true);
                    }
                }
            }

            if (e.Item is GridDataItem)
            {
                GridDataItem item = e.Item as GridDataItem;
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100);
                (item["deleteColumn"].Controls[0] as ImageButton).Visible = deleteColumnVisible;
            }
        }

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }
        }

        protected void RadGrid1_PageIndexChanged(object sender, GridPageChangedEventArgs e)
        {
            this.RadToolTipManager1.TargetControls.Clear();
        }

        protected void RadGrid1_PageSizeChanged(object sender, GridPageSizeChangedEventArgs e)
        {
            this.RadToolTipManager1.TargetControls.Clear();
        }

        public String GetRelevantFor(int relevantFor)
        {
            string ret = "";
            switch (relevantFor)
            {
                case 0:
                    {
                        ret = Resources.Resource.selRDNone;
                        break;
                    }
                case 1:
                    {
                        ret = Resources.Resource.selRDLaborRight;
                        break;
                    }
                case 2:
                    {
                        ret = Resources.Resource.selRDResidenceRight;
                        break;
                    }
                case 3:
                    {
                        ret = Resources.Resource.selRDLegitimation;
                        break;
                    }
                case 4:
                    {
                        ret = Resources.Resource.selRDInsurance;
                        break;
                    }
                case 5:
                    {
                        ret = Resources.Resource.selRDInsuranceAdditional;
                        break;
                    }
                default:
                    {
                        ret = Resources.Resource.selRDNone;
                        break;
                    }
            }
            return ret;
        }

        protected void RadGrid2_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e);
        }

        protected void RadGrid2_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGrid3_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e);
        }

        protected void RadGrid3_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }
    }
}