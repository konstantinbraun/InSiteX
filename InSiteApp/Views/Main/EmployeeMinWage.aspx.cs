using InSite.App.Constants;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Main
{
    public partial class EmployeeMinWage : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private int action = Actions.View;

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);
            }

            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);

            if (Session["PassRole"] != null)
            {
                fca = GetFieldsConfig(Helpers.GetDialogID(type.Name), Convert.ToInt32(Session["PassRole"]));
            }
            else
            {
                fca = GetFieldsConfig(Helpers.GetDialogID(type.Name));
            }
            ViewState["fca"] = fca;
            rights = GetRights(fca);
            ViewState["rights"] = rights;

            // View allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.View))
            {
                RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect("/InSiteApp/Views/Dashboard.aspx?Msg=NoViewRight");
            }

            // Insert allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Create))
            {
                RadGrid1.MasterTableView.CommandItemSettings.ShowAddNewRecordButton = false;
            }

            // Edit allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
            {
                RadGrid1.MasterTableView.GetColumn("EditCommandColumn").Visible = false;
            }

            string msg = Request.QueryString["ID"];
            if (msg != null)
            {
                CompanyID.SelectedValue = msg;
                SqlDataSource_EmployeeMinWage.SelectParameters["CompanyID"].DefaultValue = msg;
                RadGrid1.DataBind();
            }
        }

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Literal für Statusmeldungen
            Helpers.AddGridStatus(RadGrid1, Page);
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
                GridEditableItem item = e.Item;
                int employeeID = Convert.ToInt32(item.GetDataKeyValue("EmployeeID"));

                // Prüfung wegen Überziehung der Vorlagefrist für Mindestlohnbescheinigungen
                Helpers.EmployeeChanged(employeeID);

                DateTime mWMonth = Convert.ToDateTime(item.GetDataKeyValue("MWMonth"));
                string key = string.Concat(employeeID.ToString(), "|", mWMonth.ToString("yyyyMM"));

                Helpers.DialogLogger(type, Actions.Edit, key, Resources.Resource.lblActionUpdate);
                SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                action = Actions.View;
                //if (RadGrid1.CurrentPageIndex < RadGrid1.PageCount - 1)
                //{
                //    RadGrid1.CurrentPageIndex++;
                //    RadGrid1.DataBind();
                //}
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

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem)
            {
                GridEditableItem editItem = e.Item as GridEditableItem;
                RadTextBox tb = editItem.FindControl("Amount") as RadTextBox;
                if (tb != null)
                {
                    tb.Focus();
                }

                RadButton btn = (editItem.FindControl("EditEmployee") as RadButton);
                Label employeeID = editItem.FindControl("EmployeeID") as Label;
                string cmd;
                if (btn != null)
                {
                    if (employeeID != null)
                    {
                        cmd = "function(sender, args) {EditEmployee(" + btn.ID + ", " + employeeID.Text + "); return false;}";
                        btn.OnClientClicked = cmd;
                        btn.Enabled = true;
                    }
                    else
                    {
                        btn.Enabled = false;
                    }
                }
            }

            if (e.Item is GridDataItem && e.Item.ItemIndex == 0 && !e.Item.IsInEditMode)
            {
                //GridDataItem dataItem = e.Item as GridDataItem;
                //dataItem.Selected = true;
                //dataItem.Edit = true;
            }
        }

        protected void CompanyID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            SqlDataSource_EmployeeMinWage.SelectParameters["CompanyID"].DefaultValue = CompanyID.SelectedValue;
            RadGrid1.DataBind();
            if (RadGrid1.MasterTableView.Items.Count > 0)
            {
                //RadGrid1.MasterTableView.Items[0].Selected = true;
                //RadGrid1.MasterTableView.Items[0].Edit = true;
                //RadGrid1.DataBind();
            }
        }

        protected void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;

            if (e.CommandName == "EditEmployee")
            {
                string[] url = Request.RawUrl.Split(new char[] { '?' });
                Session["RawUrl"] = url[0] + "?ID=" + CompanyID.SelectedValue;
                RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect("/InSiteApp/Views/Main/Employees.aspx?ID=" + e.CommandArgument + "&Action=" + Actions.Edit.ToString() + "&Tab=3");
            }
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
                }
            }
        }

        protected void UpdateStatus_Click(object sender, EventArgs e)
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("UpdateEmployeeMwStatus", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
            }
            catch (System.Exception ex)
            {
                logger.Error("Exception: ", ex);
            }
            finally
            {
                con.Close();
            }

            RadGrid1.Rebind();
        }
    }
}