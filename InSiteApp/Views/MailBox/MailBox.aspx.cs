using System;
using System.Linq;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using InSite.App.UserServices;
using System.Net.Mail;
using System.Web.UI;
using InSite.App.Constants;

namespace InSite.App.Views.MailBox
{
    public partial class MailBox : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "ID";

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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
                Session["MailMode"] = "View";
            }
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

        protected void SqlDataSource_Inserted(object sender, SqlDataSourceStatusEventArgs e)
        {
            String ret = e.Command.Parameters["@ReturnValue"].Value.ToString();
            Helpers.DialogLogger(type, Actions.Create, ret, Resources.Resource.lblActionCreate);
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

        // RowClick abhandeln
        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            GridDataItem item = e.Item as GridDataItem;

            // Deteilbereich ein- und ausblenden
            if (e.CommandName == RadGrid.ExpandCollapseCommandName && e.Item is GridDataItem)
            {
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);
            }

            if (e.CommandName == "RowClick")
            {
                item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                int id = Convert.ToInt32(item.GetDataKeyValue(idName));
                Session["MailID"] = id;
                Helpers.DialogLogger(type, Actions.View, id.ToString(), Resources.Resource.lblActionView);
                item.ChildItem.FindControl("PanelDetails").Visible = !item.Expanded;
                item.Expanded = !item.Expanded;
                if (item.Expanded)
                {
                    Webservices webservice = new Webservices();
                    webservice.SetMailRead(id, true);
                }

                Session["ItemIndex"] = item.ItemIndex;
            }

            if (e.CommandName == "ToggleRead")
            {
                int myId = Convert.ToInt32(item.GetDataKeyValue("ID"));
                string mailRead = (e.Item.FindControl("MailRead") as HiddenField).Value;
                Webservices webservice = new Webservices();
                webservice.SetMailRead(myId, (mailRead.Equals(string.Empty)));
                RadGrid1.Rebind();
            }

            if (e.CommandName.Equals("Reply") || e.CommandName.Equals("Forward"))
            {
                Session["MailMode"] = e.CommandName;
                Session["MailItem"] = item;
                RadGrid1.MasterTableView.IsItemInserted = true;
                RadGrid1.Rebind();
            }

            if (e.CommandName.Equals("Cancel"))
            {
                Session["MailMode"] = "View";
            }

            if (e.CommandName.Equals("MarkReadSelected"))
            {
                Webservices webservice = new Webservices();
                foreach (GridDataItem dataItem in RadGrid1.MasterTableView.Items)
                {
                    Label id = dataItem.FindControl("ID") as Label;
                    if (id != null)
                    {
                        CheckBox cb = dataItem.FindControl("CheckBox1") as CheckBox;
                        if (cb != null && cb.Checked)
                        {
                            int myID = Convert.ToInt32(id.Text);
                            webservice.SetMailRead(myID, true);
                        }
                    }
                }
                RadGrid1.Rebind();
            }

            if (e.CommandName.Equals("MarkUnreadSelected"))
            {
                Webservices webservice = new Webservices();
                foreach (GridDataItem dataItem in RadGrid1.MasterTableView.Items)
                {
                    Label id = dataItem.FindControl("ID") as Label;
                    if (id != null)
                    {
                        CheckBox cb = dataItem.FindControl("CheckBox1") as CheckBox;
                        if (cb != null && cb.Checked)
                        {
                            int myID = Convert.ToInt32(id.Text);
                            webservice.SetMailRead(myID, false);
                        }
                    }
                }
                RadGrid1.Rebind();
            }

            if (e.CommandName.Equals("DeleteSelected"))
            {
                foreach (GridDataItem dataItem in RadGrid1.MasterTableView.Items)
                {
                    Label id = dataItem.FindControl("ID") as Label;
                    if (id != null)
                    {
                        CheckBox cb = dataItem.FindControl("CheckBox1") as CheckBox;
                        if (cb != null && cb.Checked)
                        {
                            int myID = Convert.ToInt32(id.Text);
                            DeleteMailItem(myID);
                        }
                    }
                }
                RadGrid1.Rebind();
            }
        
            if (e.CommandName.Equals("Delete"))
            {
                e.Canceled = true;
                int myID = Convert.ToInt32(item.GetDataKeyValue("ID"));
                DeleteMailItem(myID);
                RadGrid1.Rebind();
            }
        }

        private string GetValueFromItem(GridDataItem item, string column)
        {
            string retValue = null;
            TableCell itemCell = item[column];
            if (itemCell.Controls[1] is System.Web.UI.WebControls.Label)
            {
                System.Web.UI.WebControls.Label itemLabel = (System.Web.UI.WebControls.Label)itemCell.Controls[1];
                retValue = itemLabel.Text;
            }
            return retValue;
        }

        protected void Attachments_ItemCommand(object sender, GridCommandEventArgs e)
        {
            if (e.CommandName == "DocDownloadCmd")
            {
                int docID = Convert.ToInt32(e.CommandArgument);
                Webservices webservice = new Webservices();
                Document myDoc = webservice.GetDocument(docID);

                if (myDoc != null)
                {
                    Response.Clear();
                    Response.AppendHeader("Content-Length", myDoc.FileData.Length.ToString());
                    Response.ContentType = myDoc.FileType;
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + myDoc.FileName);
                    Response.BinaryWrite(myDoc.FileData);
                    Response.End();
                }
            }
        }

        protected void AsyncUploadAttachments_FileUploaded(object sender, FileUploadedEventArgs e)
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

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                if (!IsRadAsyncValid.Value)
                {
                    e.Canceled = true;
                    Alert(String.Format(Resources.Resource.msgMaxFileLength, MaxTotalMBytes));
                    return;
                }

                GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;

                StringBuilder sqlMail = new StringBuilder();
                StringBuilder sqlDocument = new StringBuilder();
                StringBuilder sqlAttachment = new StringBuilder();

                sqlMail.Append("INSERT INTO System_Mailbox ");
                sqlMail.Append("(SystemID, Subject, JobID, UserID, Body, MailCreated, SenderID) ");
                sqlMail.AppendLine("VALUES (@SystemID, @Subject, @JobID, @UserID, @Body, SYSDATETIME(), @SenderID); ");
                sqlMail.AppendLine("SELECT @MailID = SCOPE_IDENTITY(); ");

                sqlDocument.Append("INSERT INTO System_Documents ");
                sqlDocument.Append("(SystemID, JobID, UserID, Document, DocumentRef, DocCreated, DocumentName, DocumentType) ");
                sqlDocument.AppendLine("VALUES (@SystemID, @JobID, @UserID, @Document, @DocumentRef, SYSDATETIME(), @DocumentName, @DocumentType); ");
                sqlDocument.AppendLine("SELECT @DocumentID = SCOPE_IDENTITY(); ");

                sqlAttachment.Append("INSERT INTO System_MailAttachment ");
                sqlAttachment.Append("(SystemID, MailID, DocumentID) ");
                sqlAttachment.AppendLine("VALUES (@SystemID, @MailID, @DocumentID); ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmdMail = new SqlCommand(sqlMail.ToString(), con);
                SqlCommand cmdDocument = new SqlCommand(sqlDocument.ToString(), con);
                SqlCommand cmdAttachment = new SqlCommand(sqlAttachment.ToString(), con);

                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmdMail.Parameters.Add(par);
                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmdDocument.Parameters.Add(par);
                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmdAttachment.Parameters.Add(par);

                par = new SqlParameter("@JobID", SqlDbType.Int);
                par.Value = 0;
                cmdMail.Parameters.Add(par);
                par = new SqlParameter("@JobID", SqlDbType.Int);
                par.Value = 0;
                cmdDocument.Parameters.Add(par);

                par = new SqlParameter("@UserID", SqlDbType.Int);
                cmdMail.Parameters.Add(par);
                par = new SqlParameter("@UserID", SqlDbType.Int);
                par.Value = 0;
                cmdDocument.Parameters.Add(par);

                par = new SqlParameter("@Subject", SqlDbType.NVarChar, 255);
                string subject = (item.FindControl("Subject") as RadTextBox).Text;
                par.Value = subject;
                cmdMail.Parameters.Add(par);

                par = new SqlParameter("@Body", SqlDbType.NVarChar);
                string body = (item.FindControl("Body") as RadEditor).Content;
                par.Value = body;
                cmdMail.Parameters.Add(par);

                par = new SqlParameter("@SenderID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["UserID"]);
                cmdMail.Parameters.Add(par);

                par = new SqlParameter("@MailID", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmdMail.Parameters.Add(par);
                par = new SqlParameter("@MailID", SqlDbType.Int);
                cmdAttachment.Parameters.Add(par);

                par = new SqlParameter("@Document", SqlDbType.VarBinary);
                cmdDocument.Parameters.Add(par);

                par = new SqlParameter("@DocumentRef", SqlDbType.UniqueIdentifier);
                cmdDocument.Parameters.Add(par);

                par = new SqlParameter("@DocumentName", SqlDbType.NVarChar, 255);
                cmdDocument.Parameters.Add(par);

                par = new SqlParameter("@DocumentType", SqlDbType.NVarChar, 50);
                cmdDocument.Parameters.Add(par);

                par = new SqlParameter("@DocumentID", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmdDocument.Parameters.Add(par);
                par = new SqlParameter("@DocumentID", SqlDbType.Int);
                cmdAttachment.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }

                RadAsyncUpload au = (item.FindControl("AsyncUploadAttachments") as RadAsyncUpload);
                int[] documentIDs = new int[au.UploadedFiles.Count];
                for (int i = 0; i < au.UploadedFiles.Count; i++)
                {
                    UploadedFile file = au.UploadedFiles[i];
                    byte[] fileData = new byte[file.InputStream.Length];
                    file.InputStream.Read(fileData, 0, (int)file.InputStream.Length);
                    try
                    {
                        // Hochgeladene Dateien speichern und IDs merken
                        cmdDocument.Parameters["@Document"].Value = fileData;
                        cmdDocument.Parameters["@DocumentRef"].Value = Guid.NewGuid();
                        cmdDocument.Parameters["@DocumentName"].Value = file.FileName;
                        cmdDocument.Parameters["@DocumentType"].Value = file.ContentType;
                        cmdDocument.ExecuteNonQuery();
                        documentIDs[i] = Convert.ToInt32(cmdDocument.Parameters["@DocumentID"].Value);
                    }
                    catch (SqlException ex)
                    {
                        logger.ErrorFormat("SQL error: {0}", ex.Message);
                        throw;
                    }
                    catch (System.Exception ex)
                    {
                        logger.ErrorFormat("System error: {0}", ex.Message);
                        throw;
                    }
                }

                Master_Users user = Helpers.GetUser(Convert.ToInt32(Session["UserID"]));
                string mailFrom = user.Email;

                RadAutoCompleteBox acb = (item.FindControl("UserID") as RadAutoCompleteBox);
                foreach (AutoCompleteBoxEntry entry in acb.Entries)
                {
                    if (entry.Value.Equals(string.Empty) && Helpers.IsValidEmail(entry.Text) && !mailFrom.Equals(string.Empty))
                    {
                        MailMessage mail = Helpers.CreateMail(mailFrom, entry.Text, subject, body, true);

                        for (int i = 0; i < au.UploadedFiles.Count; i++)
                        {
                            UploadedFile file = au.UploadedFiles[i];
                            Attachment attachment = new Attachment(file.InputStream, file.FileName, file.ContentType);
                            mail.Attachments.Add(attachment);
                        }

                        Helpers.SendMail(mail);
                    }
                    else if (!entry.Value.Equals(string.Empty))
                    {
                        try
                        {
                            // Mail für jeden Empfänger erstellen
                            cmdMail.Parameters["@UserID"].Value = Convert.ToInt32(entry.Value);
                            cmdMail.ExecuteNonQuery();
                            int mailID = Convert.ToInt32(cmdMail.Parameters["@MailID"].Value);

                            for (int i = 0; i < documentIDs.Length; i++)
                            {
                                // Hochgeladene Dateien als Anhänge referenzieren
                                cmdAttachment.Parameters["@DocumentID"].Value = documentIDs[i];
                                cmdAttachment.Parameters["@MailID"].Value = mailID;
                                cmdAttachment.ExecuteNonQuery();
                            }
                        }
                        catch (SqlException ex)
                        {
                            logger.ErrorFormat("SQL error: {0}", ex.Message);
                            throw;
                        }
                        catch (Exception ex)
                        {
                            logger.ErrorFormat("System error: {0}", ex.Message);
                            throw;
                        }
                    }
                }

                Session["MailMode"] = "View";
                con.Close();
            }
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item is GridEditFormInsertItem)
            {
                GridEditableItem editItem = e.Item as GridEditableItem;
                if (Session["MailMode"].ToString().Equals("Reply"))
                {
                    GridDataItem item = Session["MailItem"] as GridDataItem;
                    RadAutoCompleteBox acb = (editItem.FindControl("UserID") as RadAutoCompleteBox);
                    Label lbl = item.FindControl("SenderID") as Label;
                    Label lblSender = item.FindControl("SenderName") as Label;
                    acb.Entries.Add(new AutoCompleteBoxEntry(lblSender.Text, lbl.Text));
                    RadTextBox tb = (editItem.FindControl("Subject") as RadTextBox);
                    lbl = item.FindControl("Subject") as Label;
                    tb.Text = "RE: " + lbl.Text;
                }
                else if (Session["MailMode"].ToString().Equals("Forward"))
                {
                    GridDataItem item = Session["MailItem"] as GridDataItem;
                    RadTextBox tb = (editItem.FindControl("Subject") as RadTextBox);
                    Label lbl = item.FindControl("Subject") as Label;
                    tb.Text = "FW: " + lbl.Text;
                    lbl = item.FindControl("Body") as Label;
                    RadEditor re = editItem.FindControl("Body") as RadEditor;
                    re.Content = lbl.Text;
                }
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridFilteringItem)
            {
                GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                if (filteringItem != null)
                {
                    LiteralControl literal = filteringItem["MailCreated"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["MailCreated"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
                }
            }
        }

        protected void ToggleRowSelection(object sender, EventArgs e)
        {
            ((sender as CheckBox).NamingContainer as GridItem).Selected = (sender as CheckBox).Checked;
            bool checkHeader = true;
            foreach (GridDataItem dataItem in RadGrid1.MasterTableView.Items)
            {
                if (!(dataItem.FindControl("CheckBox1") as CheckBox).Checked)
                {
                    checkHeader = false;
                    break;
                }
            }
            GridHeaderItem headerItem = RadGrid1.MasterTableView.GetItems(GridItemType.Header)[0] as GridHeaderItem;
            (headerItem.FindControl("headerChkbox") as CheckBox).Checked = checkHeader;

            GridDataItem item = RadGrid1.MasterTableView.Items[Convert.ToInt32(Session["ItemIndex"])];
            if (item != null)
            {
                item.Expanded = !item.Expanded;
            }
        }

        protected void ToggleSelectedState(object sender, EventArgs e)
        {
            CheckBox headerCheckBox = (sender as CheckBox);
            foreach (GridDataItem dataItem in RadGrid1.MasterTableView.Items)
            {
                (dataItem.FindControl("CheckBox1") as CheckBox).Checked = headerCheckBox.Checked;
                dataItem.Selected = headerCheckBox.Checked;
            }
        }

        protected void DeleteMailItem(int mailID)
        {
            StringBuilder sql = new StringBuilder();
            sql.AppendLine("DELETE FROM System_MailAttachment WHERE SystemID = @SystemID AND MailID = @MailID; ");
            sql.Append("DELETE FROM System_Mailbox WHERE SystemID = @SystemID AND Id = @MailID");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@MailID", SqlDbType.Int);
            par.Value = mailID;
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                Helpers.DialogLogger(type, Actions.Delete, mailID.ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
                Helpers.SetAction(Actions.View);
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
    }
}