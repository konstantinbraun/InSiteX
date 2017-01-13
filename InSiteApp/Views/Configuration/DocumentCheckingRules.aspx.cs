using InSite.App.Constants;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Resources;
using System.Text;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Configuration
{
    public partial class DocumentCheckingRules : App.BasePage
    {
        int countryGroupIDEmployer = 0;
        int countryGroupIDEmployee = 0;
        int employmentStatusID = 0;

        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

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
                String id = (e.Item as GridEditFormItem).GetDataKeyValue("CountryGroupIDEmployer").ToString() + "|";
                id += (e.Item as GridEditFormItem).GetDataKeyValue("CountryGroupIDEmployee").ToString() + "|";
                id += (e.Item as GridEditFormItem).GetDataKeyValue("EmploymentStatusID").ToString();
                Helpers.DialogLogger(type, Actions.Edit, id.ToString(), Resources.Resource.lblActionUpdate);
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
                String id = (e.Item as GridDataItem).GetDataKeyValue("CountryGroupIDEmployer").ToString() + "|";
                id += (e.Item as GridDataItem).GetDataKeyValue("CountryGroupIDEmployee").ToString() + "|";
                id += (e.Item as GridDataItem).GetDataKeyValue("EmploymentStatusID").ToString();
                Helpers.DialogLogger(type, Actions.Delete, id, Resources.Resource.lblActionDelete);
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

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            if (e.CommandName == "RowClick")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args[0].Equals("Expand"))
                {
                    int index = args[2].LastIndexOf('_');
                    int tableIndex = int.Parse(args[2].Substring(index + 1));
                    GridDataItem item = GetTableView(this.RadGrid1.MasterTableView, args[1]).Items[tableIndex];
                    item.Expanded = !item.Expanded;
                }
            }

            if (e.CommandName == RadGrid.InitInsertCommandName)
            {
                if (e.Item.OwnerTableView.Name.Equals("DocumentCheckingRules"))
                {
                    GridDataItem parentItem = e.Item.OwnerTableView.ParentItem;
                    if (parentItem != null)
                    {
                        countryGroupIDEmployer = Convert.ToInt32(parentItem.OwnerTableView.DataKeyValues[parentItem.ItemIndex]["CountryGroupIDEmployer"]);
                        countryGroupIDEmployee = Convert.ToInt32(parentItem.OwnerTableView.DataKeyValues[parentItem.ItemIndex]["CountryGroupIDEmployee"]);
                        employmentStatusID = Convert.ToInt32(parentItem.OwnerTableView.DataKeyValues[parentItem.ItemIndex]["EmploymentStatusID"]);
                    }
                }
            }
        }

        protected void RadGrid1_DetailTableDataBind(object sender, GridDetailTableDataBindEventArgs e)
        {
            // Überschriften für Detailtabellen zusammenbauen
            if (e.DetailTableView.ParentItem.DataItem != null)
            {
                string parent = "";
                if (e.DetailTableView.Name != "DocumentCheckingRules")
                {
                    parent = (e.DetailTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                }
                switch (e.DetailTableView.Name)
                {
                    case "EmployeeCountryGroup":
                        {
                            e.DetailTableView.Caption = String.Concat(Resources.Resource.lblEmployerCountryGroup, " ", parent, ": ", Resources.Resource.lblEmployeeCountryGroup);
                            break;
                        }
                    case "DocumentCheckingRules":
                        {
                            if (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem != null)
                            {
                                string parent1 = (e.DetailTableView.ParentItem.OwnerTableView.ParentItem.DataItem as DataRowView)["NameVisible"].ToString();
                                e.DetailTableView.Caption = String.Concat(Resources.Resource.lblEmployerCountryGroup, " ", parent1, "/", Resources.Resource.lblEmployeeCountryGroup, " ", parent, ": ", Resources.Resource.lblEmploymentStatus);
                            }
                            break;
                        }
                }
            }
        }

        public void RadGrid1_ItemDataBound(object sender, Telerik.Web.UI.GridItemEventArgs e)
        {
            if (e.Item is GridEditFormInsertItem)
            {
                GridEditableItem editItem = (GridEditableItem)e.Item;
                HiddenField tb = (HiddenField)editItem.FindControl("CountryGroupIDEmployer");
                tb.Value = countryGroupIDEmployer.ToString();
                tb = (HiddenField)editItem.FindControl("CountryGroupIDEmployee");
                tb.Value = countryGroupIDEmployee.ToString();
                SqlDataSource_EmploymentStatus.SelectParameters["CountryGroupIDEmployer"].DefaultValue = countryGroupIDEmployer.ToString();
                SqlDataSource_EmploymentStatus.SelectParameters["CountryGroupIDEmployee"].DefaultValue = countryGroupIDEmployee.ToString();
                RadComboBox rc = (RadComboBox)editItem.FindControl("EmploymentStatusID");
                rc.Items.Clear();
                rc.DataBind();
            }
        }

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        public String GetCheckingRule(int checkingRuleID)
        {
            ResourceManager rm = Resources.Resource.ResourceManager;
            string ruleString = "";

            if (checkingRuleID == 0)
            {
                ruleString = Resources.Resource.selRDRuleNone;
            }
            else
            {
                ruleString = rm.GetString("selRDRule" + checkingRuleID.ToString());
            }

            return ruleString;
        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;

            if (!(item.FindControl("EmploymentStatusID") as RadComboBox).SelectedValue.Equals(String.Empty))
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO Master_DocumentCheckingRules( ");
                sql.Append("SystemID, BpID, CountryGroupIDEmployer, CountryGroupIDEmployee, EmploymentStatusID, CheckingRuleID, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                sql.Append("VALUES (@SystemID, @BpID, @CountryGroupIDEmployer, @CountryGroupIDEmployee, @EmploymentStatusID, @CheckingRuleID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME()) ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["BpID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CountryGroupIDEmployer", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("CountryGroupIDEmployer") as HiddenField).Value);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CountryGroupIDEmployee", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("CountryGroupIDEmployee") as HiddenField).Value);
                cmd.Parameters.Add(par);

                int employmentStatusID = 0;
                if (!(item.FindControl("EmploymentStatusID") as RadComboBox).SelectedValue.Equals(String.Empty))
                {
                    employmentStatusID = Convert.ToInt32((item.FindControl("EmploymentStatusID") as RadComboBox).SelectedValue);
                }
                par = new SqlParameter("@EmploymentStatusID", SqlDbType.Int);
                par.Value = employmentStatusID;
                cmd.Parameters.Add(par);

                int checkingRuleID = 0;
                if (!(item.FindControl("CheckingRuleID") as RadDropDownList).SelectedValue.Equals(String.Empty))
                {
                    checkingRuleID = Convert.ToInt32((item.FindControl("CheckingRuleID") as RadDropDownList).SelectedValue);
                }
                par = new SqlParameter("@CheckingRuleID", SqlDbType.Int);
                par.Value = checkingRuleID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                con.Open();
                try
                {
                    cmd.ExecuteNonQuery();

                    Helpers.DialogLogger(type, Actions.Create, "0", Resources.Resource.lblActionCreate);
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

                Helpers.DocumentCheckingRuleChanged(Convert.ToInt32((item.FindControl("CountryGroupIDEmployer") as HiddenField).Value), Convert.ToInt32((item.FindControl("CountryGroupIDEmployee") as HiddenField).Value), employmentStatusID);
            }
        }

        protected void SqlDataSource_DocumentCheckingRules_Deleting(object sender, SqlDataSourceCommandEventArgs e)
        {
            string countryGroupIDEmployer = e.Command.Parameters["@original_CountryGroupIDEmployer"].Value.ToString();
            string countryGroupIDEmployee = e.Command.Parameters["@original_CountryGroupIDEmployee"].Value.ToString();
            string employmentStatusID = e.Command.Parameters["@original_EmploymentStatusID"].Value.ToString();
            string ret = string.Concat(countryGroupIDEmployer, " | ", countryGroupIDEmployee, " | ", employmentStatusID);
            Helpers.DialogLogger(type, Actions.Delete, ret, Resources.Resource.lblActionDelete);
            Helpers.DocumentCheckingRuleChanged(Convert.ToInt32(countryGroupIDEmployer), Convert.ToInt32(countryGroupIDEmployee), Convert.ToInt32(employmentStatusID));
        }

        protected void SqlDataSource_DocumentCheckingRules_Updating(object sender, SqlDataSourceCommandEventArgs e)
        {
            string countryGroupIDEmployer = e.Command.Parameters["@original_CountryGroupIDEmployer"].Value.ToString();
            string countryGroupIDEmployee = e.Command.Parameters["@original_CountryGroupIDEmployee"].Value.ToString();
            string employmentStatusID = e.Command.Parameters["@original_EmploymentStatusID"].Value.ToString();
            string ret = string.Concat(countryGroupIDEmployer, " | ", countryGroupIDEmployee, " | ", employmentStatusID);
            Helpers.DialogLogger(type, Actions.Edit, ret, Resources.Resource.lblActionUpdate);
            Helpers.DocumentCheckingRuleChanged(Convert.ToInt32(countryGroupIDEmployer), Convert.ToInt32(countryGroupIDEmployee), Convert.ToInt32(employmentStatusID));
        }

        protected void RadGrid1_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }
        }
    }
}