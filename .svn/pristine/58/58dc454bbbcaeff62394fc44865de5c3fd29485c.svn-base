using InSite.App.Constants;
using InSite.App.Controls;
using InSite.App.CMServices;
using InSite.App.ReportServices;
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Text;
using System.Web.Services.Protocols;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Central
{
    public partial class BuildingProjects : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "BpID";

        ICollection CreateDataSource()
        {
            DataTable dt = new DataTable();
            DataRow dr;

            dt.Columns.Add(new DataColumn("BpTypeID", typeof(Int32)));
            dt.Columns.Add(new DataColumn("BpTypeName", typeof(string)));

            dr = dt.NewRow();
            dr[0] = 1;
            dr[1] = Resources.Resource.lblBuildingProject;
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = 2;
            dr[1] = Resources.Resource.lblTemplate;
            dt.Rows.Add(dr);

            dr = dt.NewRow();
            dr[0] = 3;
            dr[1] = "Test";
            dt.Rows.Add(dr);

            DataView dv = new DataView(dt);
            return dv;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT TypeID, BpID, NameVisible ");
            sql.Append("FROM Master_BuildingProjects ");
            sql.AppendFormat("WHERE (SystemID = {0}) ", Session["SystemID"]);
            sql.AppendFormat("UNION SELECT 0 TypeID, 0 BpID, '{0}' NameVisible ", Resources.Resource.lblNoTemplate);
            sql.Append("ORDER BY TypeID, NameVisible ");
            SqlDataSource_BasedOn.SelectCommand = sql.ToString();

            if (Session["BpID"] == null || Convert.ToInt32(Session["BpID"]) == 0)
            {
                RadGrid1.ClientSettings.ClientEvents.OnRowClick = null;
                RadGrid1.ClientSettings.EnablePostBackOnRowClick = true;
            }
            else
            {
                RadGrid1.ClientSettings.ClientEvents.OnRowClick = "OnRowClick";
                RadGrid1.ClientSettings.EnablePostBackOnRowClick = false;
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
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
            string targetBp = e.Command.Parameters["@BpID"].Value.ToString();
            string sourceBp = e.Command.Parameters["@BasedOn"].Value.ToString();

            // Reports auf Reportserver kopieren
            CopyBpReports(sourceBp, targetBp);

            Helpers.DialogLogger(type, Actions.Create, targetBp, Resources.Resource.lblActionCreate);
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
                GridEditFormItem item = e.Item as GridEditFormItem;
                Helpers.DialogLogger(type, Actions.Edit, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");

                // Initialisierung der Behältermanagement Daten
                if (Convert.ToBoolean(Session["CMInit"]))
                {
                    TextBox tb = item.FindControl("ContainerManagementName") as TextBox;
                    if (tb != null && !tb.Text.Equals(string.Empty))
                    {
                        int systemID = Convert.ToInt32(Session["SystemID"]);
                        int bpID = Convert.ToInt32(item.GetDataKeyValue(idName));

                        ContainerManagementClient client = new ContainerManagementClient();
                        try
                        {
                            client.EmployeeData(systemID, bpID, 0, Actions.Insert);
                            client.CompanyData(systemID, bpID, 0, Actions.Insert);
                            client.TradeData(systemID, bpID, 0, Actions.Insert);
                        }
                        catch (WebException ex)
                        {
                            logger.Error("Exception: " + ex.Message);
                            if (ex.InnerException != null)
                            {
                                logger.Error("Inner Exception: " + ex.InnerException.Message);
                            }
                            logger.Debug("Exception Details: \n" + ex);
                        }
                    }
                }
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

        protected void OnAjaxUpdate(object sender, ToolTipUpdateEventArgs args)
        {
            // this.UpdateToolTip(args.Value, args.UpdatePanel);
        }

        private void UpdateToolTip(string elementID, UpdatePanel panel)
        {
            Control ctrl = Page.LoadControl("~/Controls/BuildingProjectsToolTip.ascx");
            panel.ContentTemplateContainer.Controls.Add(ctrl);
            BuildingProjectsToolTip details = (BuildingProjectsToolTip)ctrl;
            details.BpID = elementID;
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (!(e.Item is GridEditFormInsertItem) && e.Item.IsInEditMode)
            {
                GridEditableItem editItem = (GridEditableItem)e.Item;
                string bpID = (editItem.FindControl("BpID") as Label).Text;

                RadComboBox cb = editItem.FindControl("DefaultRoleID") as RadComboBox;
                if (cb != null && !bpID.Equals(string.Empty))
                {
                    cb.DataSource = Helpers.GetRoles(Convert.ToInt32(bpID));
                    cb.DataBind();
                    string defaultRoleID = ((DataRowView)e.Item.DataItem)["DefaultRoleID"].ToString();
                    foreach (RadComboBoxItem cbItem in cb.Items)
                    {
                        if (cbItem.Value.Equals(defaultRoleID))
                        {
                            cbItem.Selected = true;
                        }
                    }
                }

                cb = editItem.FindControl("DefaultAccessAreaID") as RadComboBox;
                if (cb != null && !bpID.Equals(string.Empty))
                {
                    cb.DataSource = Helpers.GetAccessAreas(Convert.ToInt32(bpID));
                    cb.DataBind();
                    string defaultAccessAreaID = ((DataRowView)e.Item.DataItem)["DefaultAccessAreaID"].ToString();
                    foreach (RadComboBoxItem cbItem in cb.Items)
                    {
                        if (cbItem.Value.Equals(defaultAccessAreaID))
                        {
                            cbItem.Selected = true;
                        }
                    }
                }

                cb = editItem.FindControl("DefaultTimeSlotGroupID") as RadComboBox;
                if (cb != null && !bpID.Equals(string.Empty))
                {
                    cb.DataSource = Helpers.GetTimeSlotGroups(Convert.ToInt32(bpID));
                    cb.DataBind();
                    string defaultTimeSlotGroupID = ((DataRowView)e.Item.DataItem)["DefaultTimeSlotGroupID"].ToString();
                    foreach (RadComboBoxItem cbItem in cb.Items)
                    {
                        if (cbItem.Value.Equals(defaultTimeSlotGroupID))
                        {
                            cbItem.Selected = true;
                        }
                    }
                }

                cb = editItem.FindControl("DefaultSTAccessAreaID") as RadComboBox;
                if (cb != null && !bpID.Equals(string.Empty))
                {
                    cb.DataSource = Helpers.GetAccessAreas(Convert.ToInt32(bpID));
                    cb.DataBind();
                    string defaultAccessAreaID = ((DataRowView)e.Item.DataItem)["DefaultSTAccessAreaID"].ToString();
                    foreach (RadComboBoxItem cbItem in cb.Items)
                    {
                        if (cbItem.Value.Equals(defaultAccessAreaID))
                        {
                            cbItem.Selected = true;
                        }
                    }
                }

                cb = editItem.FindControl("DefaultSTTimeSlotGroupID") as RadComboBox;
                if (cb != null && !bpID.Equals(string.Empty))
                {
                    cb.DataSource = Helpers.GetTimeSlotGroups(Convert.ToInt32(bpID));
                    cb.DataBind();
                    string defaultTimeSlotGroupID = ((DataRowView)e.Item.DataItem)["DefaultSTTimeSlotGroupID"].ToString();
                    foreach (RadComboBoxItem cbItem in cb.Items)
                    {
                        if (cbItem.Value.Equals(defaultTimeSlotGroupID))
                        {
                            cbItem.Selected = true;
                        }
                    }
                }

                RadDropDownList drList = editItem["BasedOn"].Controls[1] as RadDropDownList;
                drList.Enabled = false;

                TextBox tb = editItem.FindControl("ContainerManagementName") as TextBox;
                if (tb != null)
                {
                    Session["CMName"] = tb.Text;
                }
            }

            if (e.Item is GridDataItem)
            {
                // this.RadToolTipManager1.TargetControls.Add(e.Item.ClientID, (e.Item as GridDataItem).GetDataKeyValue(idName).ToString(), true);
            }

            if ((e.Item is GridEditFormItem) && e.Item.IsInEditMode)
            {
                GridEditableItem editItem = (GridEditableItem)e.Item;

                RadComboBox cb = editItem.FindControl("CountryID") as RadComboBox;
                if (cb != null)
                {
                    cb.Items.Clear();
                    cb.DataSource = Helpers.GetRegions(Helpers.GetCultures(CultureTypes.AllCultures));
                    cb.DataBind();
                }
                foreach (RadComboBoxItem cbItem in cb.Items)
                {
                    if (cbItem.Value == (editItem.FindControl("CountryID1") as HiddenField).Value)
                    {
                        cbItem.Selected = true;
                    }
                }

                RadButton rb = editItem.FindControl("InitContainerManagement") as RadButton;
                if (rb != null)
                {
                    RadTextBox tb = editItem.FindControl("ContainerManagementName") as RadTextBox;
                    if (tb != null && tb.Text != null && !tb.Text.Equals(string.Empty))
                    {
                        rb.Enabled = true;
                    }
                    else
                    {
                        rb.Enabled = false;
                    }
                }
            }

            if (e.Item is GridDataItem)
            {
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100);
                GridDataItem item1 = e.Item as GridDataItem;
                if (item1 != null)
                {
                    (item1["deleteColumn"].Controls[0] as ImageButton).Visible = deleteColumnVisible;
                }
            }
        }

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }

            if (e.Action == GridGroupsChangingAction.Group)
            {
                RadGrid1.MasterTableView.GetColumnSafe(e.Expression.GroupByFields[0].FieldName).Visible = false;
            }
            else if (e.Action == GridGroupsChangingAction.Ungroup)
            {
                RadGrid1.MasterTableView.GetColumnSafe(e.Expression.GroupByFields[0].FieldName).Visible = true;
            }

            if (e.Action == GridGroupsChangingAction.Group)
            {
                if (e.Expression.SelectFields[0].FieldName == "DescriptionShort")
                {
                    e.Expression.SelectFields[0].FieldAlias = Resources.Resource.lblDescriptionShort;
                }
                else if (e.Expression.SelectFields[0].FieldName == "NameVisible")
                {
                    e.Expression.SelectFields[0].FieldAlias = Resources.Resource.lblNameVisible;
                }
                else if (e.Expression.SelectFields[0].FieldName == "TypeID")
                {
                    e.Expression.SelectFields[0].FieldAlias = Resources.Resource.lblType;
                }
            }
        }
 
        public string GetBpTypeName(int bpTypeID)
        {
            if (bpTypeID == 1)
            {
                return Resources.Resource.lblBuildingProject;
            }
            else if (bpTypeID == 2)
            {
                return Resources.Resource.lblTemplate;
            }
            else
                return string.Empty;
        }

        // RowClick abhandeln
        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            GridDataItem item = e.Item as GridDataItem;

            if (e.CommandName == "RowClick")
            {
                GridDataItem clickItem = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, clickItem.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);
                clickItem.Expanded = !clickItem.Expanded;
            }

            if (e.CommandName == "Edit")
            {
            }

            if (e.CommandName == "PerformInsert")
            {
                string countryID = (e.Item.FindControl("CountryID") as RadComboBox).SelectedValue;
                SqlDataSource_BuidingProjects.InsertParameters["CountryID"].DefaultValue = countryID;
            }

            if (e.CommandName == "Update")
            {
                string countryID = (e.Item.FindControl("CountryID") as RadComboBox).SelectedValue;
                SqlDataSource_BuidingProjects.UpdateParameters["CountryID"].DefaultValue = countryID;

                string defaultRoleID = (e.Item.FindControl("DefaultRoleID") as RadComboBox).SelectedValue;
                SqlDataSource_BuidingProjects.UpdateParameters["DefaultRoleID"].DefaultValue = defaultRoleID;

                string defaultAccessAreaID = (e.Item.FindControl("DefaultAccessAreaID") as RadComboBox).SelectedValue;
                SqlDataSource_BuidingProjects.UpdateParameters["DefaultAccessAreaID"].DefaultValue = defaultAccessAreaID;

                string defaultTimeSlotGroupID = (e.Item.FindControl("DefaultTimeSlotGroupID") as RadComboBox).SelectedValue;
                SqlDataSource_BuidingProjects.UpdateParameters["DefaultTimeSlotGroupID"].DefaultValue = defaultTimeSlotGroupID;

                defaultAccessAreaID = (e.Item.FindControl("DefaultSTAccessAreaID") as RadComboBox).SelectedValue;
                SqlDataSource_BuidingProjects.UpdateParameters["DefaultSTAccessAreaID"].DefaultValue = defaultAccessAreaID;

                defaultTimeSlotGroupID = (e.Item.FindControl("DefaultSTTimeSlotGroupID") as RadComboBox).SelectedValue;
                SqlDataSource_BuidingProjects.UpdateParameters["DefaultSTTimeSlotGroupID"].DefaultValue = defaultTimeSlotGroupID;

                TextBox tb = e.Item.FindControl("ContainerManagementName") as TextBox;
                if (tb != null && !tb.Text.Equals(string.Empty) && Session["CMName"].ToString().Equals(string.Empty))
                {
                    Session["CMInit"] = true;
                }
                else
                {
                    Session["CMInit"] = false;
                }
                Session["CMName"] = null;
            }

            if (e.CommandName == RadGrid.ExportToExcelCommandName || e.CommandName == RadGrid.ExportToCsvCommandName || e.CommandName == RadGrid.ExportToPdfCommandName)
            {
                RadGrid1.ShowGroupPanel = false;
                RadGrid1.Rebind();
            }

            if (e.CommandName == "InitContainerManagement")
            {
                ContainerManagementClient client = new ContainerManagementClient();
                int systemID = Convert.ToInt32(Session["SystemID"]);
                int bpID = Convert.ToInt32(Session["BpID"]);
                try
                {
                    string result = string.Empty;
                    result = client.CompanyData(systemID, bpID, 0, Actions.Update);
                    result += "\r\n";
                    result += client.TradeData(systemID, bpID, 0, Actions.Update);
                    result += "\r\n";
                    result += client.EmployeeData(systemID, bpID, 0, Actions.Update);
                    SetMessage(Resources.Resource.lblInitContainerManagement, Resources.Resource.msgInitContainerManagement, "green");
                }
                catch (WebException ex)
                {
                    logger.Error("WebException: " + ex.Message);
                    if (ex.InnerException != null)
                    {
                        logger.Error("Inner WebException: " + ex.InnerException.Message);
                    }
                    logger.Debug("WebException Details: \n" + ex);
                    SetMessage(Resources.Resource.lblInitContainerManagement, "WebException: " + ex.Message, "red");
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: " + ex.Message);
                    if (ex.InnerException != null)
                    {
                        logger.Error("Inner Exception: " + ex.InnerException.Message);
                    }
                    logger.Debug("Exception Details: \n" + ex);
                    SetMessage(Resources.Resource.lblInitContainerManagement, "Exception: " + ex.Message, "red");
                }
            }

            if(e.CommandName == "TariffScopeChanged")
            {
                using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
                {
                    int systemID = Convert.ToInt32(Session["SystemID"]);
                    int bpID = Convert.ToInt32(Session["BpID"]);

                    SqlCommand command = new SqlCommand("SwitchTariffScopeEastToWest", connection);
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@SystemID", systemID);
                    command.Parameters.AddWithValue("@BpID", bpID);

                    try
                    {
                        connection.Open();
                        command.ExecuteNonQuery();
                        connection.Close();
                    }
                    catch (Exception ex)
                    {
                        logger.Error("Exception: " + ex.Message);
                        if (ex.InnerException != null)
                        {
                            logger.Error("Inner Exception: " + ex.InnerException.Message);
                        }
                        logger.Debug("Exception Details: \n" + ex);
                        SetMessage(Resources.Resource.lblTariffScope , "Exception: " + ex.Message, "red");
                    }
                }
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void CopyBpReports(string sourceBp, string targetBp)
        {
            System.Diagnostics.Debug.Assert(!String.IsNullOrEmpty(sourceBp));
            System.Diagnostics.Debug.Assert(!String.IsNullOrEmpty(targetBp));

            ReportingService2010SoapClient rs = new ReportingService2010SoapClient();
            rs.ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
            string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
            string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
            string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
            NetworkCredential clientCredentials = new NetworkCredential(userName, userPwd, userDomain);
            rs.ClientCredentials.Windows.ClientCredential = clientCredentials;

            string rootPath = string.Concat("/Insite/S", Session["SystemID"].ToString());
            CatalogItem info = new CatalogItem();
            TrustedUserHeader header = new TrustedUserHeader();
            Property[] properties = new Property[1];
            Property property = new Property();
            property.Name = "Description";
            property.Value = "Vorlagen für Bauvorhaben " + targetBp.ToString();
            properties[0] = property;

            // Zielordner anlegen
            try
            {
                rs.CreateFolder(header, "B" + targetBp, rootPath, properties, out info);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }

            string sourcePath = string.Concat(rootPath, "/B", sourceBp);
            string targetPath = string.Concat(rootPath, "/B", targetBp);
            string reportName = "";
            string reportPath = "";
            string reportType = "";
            byte[] reportData = null;
            Warning[] warnings;
            CatalogItem[] items = null;

            // Items im Quellordner auflisten
            try
            {
                rs.ListChildren(header, sourcePath, true, out items);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Webservice error: {0}", ex.Message);
            }

            if (items.Count() > 0)
            {
                // Items durchlaufen
                foreach (CatalogItem item in items)
                {
                    reportName = item.Name;
                    reportPath = item.Path;
                    reportType = item.TypeName;

                    // Reports vom Quell- in den Zielordner kopieren
                    if (reportType.Equals("Report"))
                    {
                        try
                        {
                            // Quelldefinition lesen
                            rs.GetItemDefinition(header, reportPath, out reportData);

                            // Beschreibung übernehmen
                            Property retrieveProp = new Property();
                            retrieveProp.Name = "Description";
                            Property[] props = new Property[1];
                            props[0] = retrieveProp;
                            ItemNamespaceHeader header1 = new ItemNamespaceHeader();
                            rs.GetProperties(header1, header, reportPath, props, out properties);

                            // Neuen Report im Zielverzeichnis anlegen
                            rs.CreateCatalogItem(header, "Report", reportName, targetPath, true, reportData, properties, out info, out warnings);
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
            }
        }

        protected void DeleteBpReports(string bpToDelete)
        {
            ReportingService2010SoapClient rs = new ReportingService2010SoapClient();
            rs.ClientCredentials.Windows.AllowedImpersonationLevel = System.Security.Principal.TokenImpersonationLevel.Impersonation;
            string userName = ConfigurationManager.AppSettings["ReportServerUser"].ToString();
            string userPwd = ConfigurationManager.AppSettings["ReportServerPwd"].ToString();
            string userDomain = ConfigurationManager.AppSettings["ReportServerDomain"].ToString();
            NetworkCredential clientCredentials = new NetworkCredential(userName, userPwd, userDomain);
            rs.ClientCredentials.Windows.ClientCredential = clientCredentials;

            string rootPath = string.Concat("/Insite/S", Session["SystemID"].ToString());
            TrustedUserHeader header = new TrustedUserHeader();

            // Ordner löschen
            try
            {
                rs.DeleteItem(header, rootPath + "/B" + bpToDelete);
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

        protected void CountryID_ItemDataBound(object sender, RadComboBoxItemEventArgs e)
        {
            string flagHome = ConfigurationManager.AppSettings["FlagFilesHome"];
            string flagName = (e.Item.DataItem as DataRowView)["FlagName"].ToString();
            if (!flagName.Equals(string.Empty))
            {
                Image img = (Image)e.Item.FindControl("ItemImage");
                img.ImageUrl = string.Concat(flagHome, flagName);
                Label lbl = (Label)e.Item.FindControl("ItemText");
                lbl.Text = (e.Item.DataItem as DataRowView)["CountryName"].ToString();
            }
        }

        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("DeleteBuildingProject", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter par;

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            int bpToDelete = Convert.ToInt32((e.Item as GridDataItem).GetDataKeyValue("BpID"));
            par.Value = bpToDelete;
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }

            try
            {
                logger.InfoFormat("Try to execute {0}", cmd.CommandText);
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Delete, bpToDelete.ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
                Helpers.SetAction(Actions.View);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }

            DeleteBpReports(bpToDelete.ToString());

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }
    }
}