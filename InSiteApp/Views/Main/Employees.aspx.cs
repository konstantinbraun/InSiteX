using InSite.App.Constants;
using InSite.App.Controls;
using InSite.App.CMServices;
using InSite.App.UserServices;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.Views.Main
{
    public partial class Employees : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "EmployeeID";

        private List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();
        private GetFieldsConfig_Result[] fca = null;

        private bool initEdit = false;
        private int lastID = 0;
        private int action = Actions.View;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

                // Session["LastTab"] = 0;

                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);

                // Sessionvariablen für temporäre Satz IDs
                Session["EmployeeIDInserted"] = 0;
                Session["AddressIDInserted"] = 0;

                Session["AlphaFilter"] = string.Empty;

                ShowScannerPanel(true);

                Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);

                fca = GetFieldsConfig(Helpers.GetDialogID(type.Name));
                ViewState["fca"] = fca;
                rights = GetRights(fca);
                ViewState["rights"] = rights;

                // View allowed?
                if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.View))
                {
                    RadAjaxManager ajax = (RadAjaxManager) this.Page.Master.FindControl("RadAjaxManager1");
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

                // Parameterabfrage für Vorgangsverwaltung
                string msg = Request.QueryString["ID"];
                if (msg != null)
                {
                    lastID = Convert.ToInt32(msg);
                    Session["MyEmployeeID"] = lastID;
                    Session["LastEdited"] = true;
                }

                msg = Request.QueryString["Action"];
                if (msg != null)
                {
                    action = Convert.ToInt32(msg);
                    if (action != Actions.Edit && action != Actions.Release && action != Actions.ReleaseBp)
                    {
                        Session["LastEdited"] = false;
                    }
                }

                msg = Request.QueryString["Tab"];
                if (msg != null)
                {
                    Session["LastTab"] = msg;
                }

                Helpers.SetAction(action);
            }
        }

        //protected override void OnLoad(EventArgs e)
        //{
        //    base.OnLoad(e);

        //    IsRadAsyncValid = null;
        //}

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Literal für Statusmeldungen
                Helpers.AddGridStatus(RadGrid1, Page);

                Helpers.GotoLastEdited(RadGrid1, lastID, idName);
            }

            // Insert allowed?
            if (!HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Create))
            {
                GridCommandItem cmdItem = (GridCommandItem) RadGrid1.MasterTableView.GetItems(GridItemType.CommandItem)[0];
                RadButton insertButton = (RadButton) cmdItem.FindControl("btnInitInsert");
                insertButton.Visible = false;

                RadButton updateThumbnailButton = (RadButton) cmdItem.FindControl("UpdateThumbnail");
                if (updateThumbnailButton != null)
                {
                    updateThumbnailButton.Visible = Helpers.IsMaster();
                }
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
                if (e.AffectedRows > 0)
                {
                    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                    Helpers.SetAction(Actions.View);
                }
                else
                {
                    e.KeepInInsertMode = true;
                }
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

            GridColumn item1 = (sender as RadGrid).MasterTableView.Columns.FindByUniqueName("LastName");
            if (item1 != null)
            {
                string filterValue = item1.CurrentFilterValue;
                if ((Session["AlphaFilter"] != null && !Session["AlphaFilter"].ToString().Equals(string.Empty)) || (filterValue != null && !filterValue.Equals(string.Empty)))
                {
                    item1.HeaderStyle.ForeColor = System.Drawing.Color.DarkRed;
                    item1.HeaderStyle.Font.Bold = true;

                }
                else
                {
                    item1.HeaderStyle.ForeColor = System.Drawing.Color.Black;
                    item1.HeaderStyle.Font.Bold = false;
                }
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }

            // Detailbereich des ersten Elements einblenden
            if (!Page.IsPostBack)
            {
                // RadGrid1.MasterTableView.Items[0].Expanded = true;
                // RadGrid1.MasterTableView.Items[0].ChildItem.FindControl("InnerContainer").Visible = true;
            }

            // Aufruf durch Vorgangsverwaltung
            if (lastID != 0 && ((action == Actions.Release && HasRight(rights, Actions.Release))
                || (action == Actions.ReleaseBp && HasRight(rights, Actions.ReleaseBp))
                || (action == Actions.Edit && HasRight(rights, Actions.Edit))))
            {
                Helpers.GotoLastEdited(RadGrid1, lastID, idName, true);
            }
        }

        public bool Hide(Control c)
        {
            c.Visible = false;
            return true;
        }

        public void RadGrid1_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, this.Header.Title);

            GridDataItem item = e.Item as GridDataItem;

            // Only one active edit form 
            RadGrid grid = (sender as RadGrid);
            if (e.CommandName == RadGrid.InitInsertCommandName)
            {
                grid.MasterTableView.ClearEditItems();
            }
            if (e.CommandName == RadGrid.EditCommandName)
            {
                e.Item.OwnerTableView.IsItemInserted = false;
            }

            if (e.CommandName == "Sort" || e.CommandName == "Page" || e.CommandName == "Filter")
            {
                RadToolTipManager1.TargetControls.Clear();
                RadToolTipManager2.TargetControls.Clear();
            }

            // Deteilbereich ein- und ausblenden
            if (e.CommandName == RadGrid.ExpandCollapseCommandName && e.Item is GridDataItem)
            {
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);

                ((GridDataItem) e.Item).ChildItem.FindControl("PanelDetails").Visible = !e.Item.Expanded;

                Helpers.SetAction(Actions.View);
            }

            if (e.CommandName == "RowClick")
            {
                // RowClick abhandeln
                item = RadGrid1.MasterTableView.Items[e.CommandArgument as string];
                Helpers.DialogLogger(type, Actions.View, item.GetDataKeyValue(idName).ToString(), Resources.Resource.lblActionView);

                ((GridDataItem) item).ChildItem.FindControl("PanelDetails").Visible = !item.Expanded;

                item.Expanded = !item.Expanded;

                Helpers.SetAction(Actions.View);
            }

            if (e.CommandName == "WebCamClosed")
            {
                if (Session["ImageData"] != null)
                {
                    RadBinaryImage image;

                    if ((e.Item.Parent.Parent as GridTableView).IsItemInserted)
                    {
                        image = item.FindControl("PhotoData") as RadBinaryImage;
                    }
                    else
                    {
                        image = item.EditFormItem.FindControl("PhotoData") as RadBinaryImage;
                    }
                    if (image != null)
                    {
                        image.DataValue = Convert.FromBase64String(Session["ImageData"].ToString());
                    }
                    // RadGrid1.Rebind();
                    //UpdatePanel panel = item.EditFormItem.FindControl("PanelPhoto") as UpdatePanel;
                    //if (panel != null)
                    //{
                    //    panel.Update();
                    //}
                }
            }

            if (e.CommandName == "ReleaseB")
            {
                if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                {
                    Session["MyEmployeeID"] = item.GetDataKeyValue(idName);
                    Helpers.StopMasterTimer(this.Page.Master);
                    Helpers.SetAction(Actions.ReleaseBp);
                    item.Edit = true;
                    (sender as RadGrid).Rebind();
                    ShowScannerPanel(false);
                }
            }

            if (e.CommandName == "ReleaseC")
            {
                if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release))
                {
                    Session["MyEmployeeID"] = item.GetDataKeyValue(idName);
                    Helpers.StopMasterTimer(this.Page.Master);
                    Helpers.SetAction(Actions.Release);
                    item.Edit = true;
                    (sender as RadGrid).Rebind();
                    ShowScannerPanel(false);
                }
            }

            if (e.CommandName == "ReleaseItB")
            {
                Helpers.SetAction(Actions.ReleaseBp);
                Label label = item.EditFormItem.FindControl("ReleaseBOn") as Label;
                label.Text = DateTime.Now.ToString();
                label = item.EditFormItem.FindControl("ReleaseBFrom") as Label;
                label.Text = Session["LoginName"].ToString();

                label = item.EditFormItem.FindControl("LockedFrom") as Label;
                label.Text = "";
                label = item.EditFormItem.FindControl("LockedOn") as Label;
                label.Text = "";

                Session["ReleaseMessage"] = true;
            }

            if (e.CommandName == "ReleaseItC")
            {
                Helpers.SetAction(Actions.Release);
                Label label = item.EditFormItem.FindControl("ReleaseCOn") as Label;
                label.Text = DateTime.Now.ToString();
                label = item.EditFormItem.FindControl("ReleaseCFrom") as Label;
                label.Text = Session["LoginName"].ToString();

                label = item.EditFormItem.FindControl("LockedFrom") as Label;
                label.Text = "";
                label = item.EditFormItem.FindControl("LockedOn") as Label;
                label.Text = "";
            }

            if (e.CommandName == "Lock" && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Edit))
            {
                Session["MyEmployeeID"] = item.GetDataKeyValue(idName);
                Helpers.StopMasterTimer(this.Page.Master);
                Helpers.SetAction(Actions.Lock);
                item.Edit = true;
                (sender as RadGrid).Rebind();
                ShowScannerPanel(false);
            }

            if (e.CommandName == "LockIt")
            {
                Helpers.SetAction(Actions.Lock);
                Label label = item.EditFormItem.FindControl("LockedFrom") as Label;
                label.Text = Session["LoginName"].ToString();
                label = item.EditFormItem.FindControl("LockedOn") as Label;
                label.Text = DateTime.Now.ToString();
            }

            if (e.CommandName == "Cancel")
            {
                lastID = -1;
                Helpers.SetAction(Actions.View);
                ShowScannerPanel(true);
                Helpers.StartMasterTimer(this.Page.Master);
                if (Session["RawUrl"] != null)
                {
                    string url = Uri.EscapeUriString(Session["RawUrl"].ToString());
                    Session["RawUrl"] = null;
                    RadAjaxManager ajax = (RadAjaxManager) this.Page.Master.FindControl("RadAjaxManager1");
                    ajax.Redirect(url);
                }
            }

            if (e.CommandName == "Edit")
            {
                Helpers.StopMasterTimer(this.Page.Master);
                Session["ImageData"] = null;
                int employeeID = Convert.ToInt32((item.FindControl("EmployeeID") as Label).Text);
                Session["MyEmployeeID"] = employeeID;

                Helpers.SetAction(Actions.Edit);
                ShowScannerPanel(false);
            }

            if (e.CommandName == "InitInsert")
            {
                Helpers.StopMasterTimer(this.Page.Master);
                Session["ImageData"] = null;

                int nextEmployeeID = Helpers.GetNextID("EmployeeID");
                Session["NextEmployeeID"] = nextEmployeeID;
                Session["MyEmployeeID"] = nextEmployeeID;

                // Default Zutrittsbereich und Zeitgruppe zuordnen
                int defaultAccessAreaID = Helpers.GetDefaultAccessAreaID(Convert.ToInt32(Session["BpID"]));
                int defaultTimeSlotGroupID = Helpers.GetDefaultTimeSlotGroupID(Convert.ToInt32(Session["BpID"]));
                Helpers.SetDefaultAccessAreaForUser(nextEmployeeID, defaultAccessAreaID, defaultTimeSlotGroupID);

                int nextAddressID = Helpers.GetNextID("AddressID");
                Session["NextAddressID"] = nextAddressID;

                Helpers.SetAction(Actions.Create);
                ShowScannerPanel(false);

                GetEmployees_Result newEmployee = new GetEmployees_Result();
                newEmployee.EmployeeID = nextEmployeeID;
                newEmployee.AddressID = nextAddressID;
                e.Item.OwnerTableView.InsertItem(newEmployee);
            }

            if (e.CommandName == "PassAction")
            {
                Helpers.EmployeeChanged(Convert.ToInt32(Session["MyEmployeeID"]));

                (sender as RadGrid).MasterTableView.Rebind();
            }

            if (e.CommandName == "WebCam")
            {
                RadWindow window1 = new RadWindow();
                string employeeID = (e.Item.FindControl("EmployeeID") as Label).Text;
                string dateSuffix = DateTime.Now.ToString("yyyymmdd");
                window1.NavigateUrl = "/InSiteApp/Main/WebCamTest.aspx";
                window1.ID = "RadWindow1";
                window1.VisibleOnPageLoad = true;
                window1.ReloadOnShow = true;
                RadWindowManager mgr = Master.FindControl("RadWindowManager1") as RadWindowManager;
                mgr.Windows.Add(window1);
                this.Controls.Add(window1);
            }

            if (e.CommandName == "PerformInsert")
            {
                Session["NoExit"] = e.CommandArgument.Equals("NoExit");
                ShowScannerPanel(true);
            }

            if (e.CommandName == "Update")
            {
                Session["NoExit"] = e.CommandArgument.Equals("NoExit");
                ShowScannerPanel(true);
            }

            if (e.CommandName == "FindEmployee")
            {
                Master_Passes pass = Helpers.GetPassData(e.CommandArgument.ToString());
                if (pass.EmployeeID > 0)
                {
                    Helpers.GotoLastEdited(RadGrid1, pass.EmployeeID, idName);
                }
                else
                {
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblSearchEmployee, Resources.Resource.msgSearchEmployeeNotFound);
                }
            }

            if (e.CommandName == "HideScanner")
            {
                if (Convert.ToBoolean(e.CommandArgument))
                {
                    ShowScannerPanel(false);
                }
                else
                {
                    ShowScannerPanel(true);
                }
            }

            if (e.CommandName == "ReprintPass")
            {
                Pass pass = Helpers.GetPass(Convert.ToInt32(e.CommandArgument), true);
                if (pass.PassID != 0)
                {
                    // Report anzeigen
                    Response.Clear();
                    Response.AppendHeader("Content-Length", pass.FileData.Length.ToString());
                    Response.ContentType = pass.FileType;
                    Response.AddHeader("content-disposition", "attachment;  filename=" + pass.FileName);
                    Response.BinaryWrite(pass.FileData);
                    Response.End();
                }
            }

            if (e.Item != null)
            {
                RadTabStrip ts = e.Item.FindControl("RadTabStrip1") as RadTabStrip;
                if (ts != null)
                {
                    Session["LastTab"] = ts.SelectedTab.Index;
                }
            }

            if (e.CommandName.Equals("AlphaFilter"))
            {
                Session["AlphaFilter"] = e.CommandArgument;
                RadGrid1.Rebind();
            }

            if (e.CommandName == RadGrid.ExportToExcelCommandName || e.CommandName == RadGrid.ExportToCsvCommandName || e.CommandName == RadGrid.ExportToPdfCommandName)
            {
                RadGrid1.ShowGroupPanel = false;
                RadGrid1.Rebind();
            }

            if (e.CommandName.Equals("UpdateThumbnails"))
            {
                Webservices webservice = new Webservices();
                webservice.UpdateThumbnails();
                RadGrid1.Rebind();
            }
        }

        private void ShowScannerPanel(bool show)
        {
            Control sb = Master.FindControl("RadScriptBlockReader");
            System.Diagnostics.Debug.Assert(sb != null);
            sb.Visible = show;
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.IsInEditMode)
            {
                GetEmployees_Result employee = e.Item.DataItem as GetEmployees_Result;
                GridEditableItem item = (GridEditableItem) e.Item;
                RadComboBox cbTrade = item.FindControl("TradeID") as RadComboBox;
                RadDropDownTree cbCompany = item.FindControl("CompanyID") as RadDropDownTree;
                if (cbCompany != null)
                {
                    string companyID = cbCompany.SelectedValue;
                    if (companyID == null || companyID.Equals(String.Empty))
                    {
                        companyID = "0";
                    }
                    cbTrade.DataSource = LoadTrades(companyID);
                    cbTrade.DataBind();
                }

                if (!(e.Item is IGridInsertItem))
                {
                    cbTrade.SelectedValue = employee.TradeID.ToString();
                }

                HiddenField addressID = item.FindControl("AddressID") as HiddenField;
                Label employeeID = item.FindControl("EmployeeID") as Label;

                if (e.Item is GridEditFormInsertItem)
                {
                    employeeID.Text = Session["NextEmployeeID"].ToString();
                    addressID.Value = Session["NextAddressID"].ToString();

                    RadBinaryImage image = item.FindControl("PhotoData") as RadBinaryImage;
                    if (image != null && Session["ImageData"] != null)
                    {
                        image.DataValue = Convert.FromBase64String(Session["ImageData"].ToString());
                        Label fileSize = item.FindControl("PhotoFileSize") as Label;
                        fileSize.Text = image.DataValue.Length.ToString("#,##0") + " Bytes";
                    }
                }

                if (e.Item is GridEditableItem && !(e.Item is GridEditFormInsertItem))
                {
                    RadBinaryImage image = item.FindControl("PhotoData") as RadBinaryImage;
                    if (image != null)
                    {
                        Webservices webservice = new Webservices();
                        byte[] result = webservice.GetEmployeePhotoData(employee.EmployeeID);
                        image.DataValue = result;
                        Label fileSize = item.FindControl("PhotoFileSize") as Label;
                        if (result != null)
                        {
                            fileSize.Text = result.Length.ToString("#,##0") + " Bytes";
                        }
                    }
                }
            }

            if (e.Item is GridNestedViewItem && e.Item.DataItem != null)
            {
                GridNestedViewItem nestedViewItem = (GridNestedViewItem) e.Item;
                GetEmployees_Result employee = e.Item.DataItem as GetEmployees_Result;

                Label lbl = nestedViewItem.FindControl("AccessDenialReason") as Label;
                if (lbl != null)
                {
                    bool accessAllowed = employee.AccessAllowed;
                    if (accessAllowed)
                    {
                        lbl.Text = Resources.Resource.lblAccessAllowed;
                    }
                    else
                    {
                        if (employee.AccessDenialReason.Equals(string.Empty))
                        {
                            lbl.Text = Resources.Resource.lblNoPassAssigned;
                        }
                        else
                        {
                            lbl.Text = employee.AccessDenialReason.Replace(Environment.NewLine, "<br/>");
                        }
                    }
                }

                RadButton btn = (nestedViewItem.FindControl("AccessRightInfo") as RadButton);
                if (btn != null)
                {
                    string cmd = "function(sender, args) {openEmployeeAccessRight(" + employee.EmployeeID + "); return false;}";
                    btn.OnClientClicked = cmd;
                    if (employee.AccessDenialTimeStamp != null)
                    {
                        btn.Text = string.Concat(Resources.Resource.lblAccessRightsInfo, " ", Resources.Resource.lblFrom.ToLower(), " ", employee.AccessDenialTimeStamp.ToString());
                    }
                }
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem))
            {
                int employeeID = Convert.ToInt32(((GetEmployees_Result) e.Item.DataItem).EmployeeID);
                Label lb = ((GridEditFormItem) e.Item).FindControl("AppliedRule") as Label;
                lb.Text = Helpers.GetAppliedRuleString(employeeID);

                RadButton btn = (((GridEditFormItem) e.Item).FindControl("AccessRightInfo") as RadButton);
                if (((GetEmployees_Result) e.Item.DataItem).AccessDenialTimeStamp != null)
                {
                    btn.Text = string.Concat(Resources.Resource.lblAccessRightsInfo, " ", Resources.Resource.lblFrom.ToLower(), " ", ((GetEmployees_Result) e.Item.DataItem).AccessDenialTimeStamp.ToString());
                }
            }

            if (e.Item is GridNestedViewItem)
            {
                int employeeID = Convert.ToInt32(((GetEmployees_Result) e.Item.DataItem).EmployeeID);
                Label lb = ((GridNestedViewItem) e.Item).FindControl("AppliedRule") as Label;
                if (lb != null)
                {
                    lb.Text = Helpers.GetAppliedRuleString(employeeID);
                }
            }

            // Feldsteuerung
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                RadTabStrip tabStrip = (RadTabStrip) e.Item.FindControl("RadTabStrip1");
                if (e.Item is GridEditFormInsertItem)
                {
                    //tabStrip.Tabs[1].Visible = false;
                    //tabStrip.Tabs[2].Visible = false;
                    //tabStrip.Tabs[3].Visible = false;
                    //tabStrip.Tabs[4].Visible = false;
                    //tabStrip.Tabs[5].Visible = false;
                    // Insert
                    FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Create, e, false);
                }
                else
                {
                    if (Helpers.GetAction() == Actions.Release)
                    {
                        // Release
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Release, e, false);
                    }
                    else if (Helpers.GetAction() == Actions.ReleaseBp)
                    {
                        // ReleaseBp
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.ReleaseBp, e, false);
                    }
                    else if (Helpers.GetAction() == Actions.Lock)
                    {
                        // Lock
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Lock, e, false);
                    }
                    else
                    {
                        // Edit
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Edit, e, false);
                    }

                    if (e.Item.IsInEditMode)
                    {
                        tabStrip.Tabs[Convert.ToInt32(Session["LastTab"])].Selected = true;
                        tabStrip.Tabs[Convert.ToInt32(Session["LastTab"])].PageView.Selected = true;
                    }
                }
            }
            else
            {
                // View
                FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.View, e, false);
            }

            GridDataItem item1 = e.Item as GridDataItem;
            if (item1 != null)
            {
                ImageButton button = e.Item.FindControl("ReleaseButton") as ImageButton;
                button.Visible = true;
                button.Enabled = false;

                int statusID = Convert.ToInt32(((GetEmployees_Result) e.Item.DataItem).StatusID);
                button.ToolTip = Status.GetStatusString(statusID);

                if (statusID == Status.Locked)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/Red-X.png";
                    button.CommandName = "ReleaseB";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.ReleasedForCCWaitForBp)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/requestBP.png";
                    button.CommandName = "ReleaseB";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                    {
                        button.Enabled = true;
                    }
                }
                else if (statusID == Status.Released)
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/release.png";
                    button.CommandName = "Lock";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Lock))
                    {
                        button.Enabled = true;
                    }
                }
                else
                {
                    button.ImageUrl = "/InSiteApp/Resources/Icons/request.png";
                    button.CommandName = "ReleaseC";
                    if (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release))
                    {
                        button.Enabled = true;
                    }
                }
                button.CommandArgument = item1.GetDataKeyValue("EmployeeID").ToString();
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditFormItem editFormItem = (GridEditFormItem) e.Item;
                RadButton button = (editFormItem.FindControl("ReleaseItB") as RadButton);
                if (Helpers.GetAction() == Actions.ReleaseBp && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.ReleaseBp))
                {
                    button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }

                button = (editFormItem.FindControl("ReleaseItC") as RadButton);
                if (Helpers.GetAction() == Actions.Release && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Release))
                {
                    button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }

                button = (editFormItem.FindControl("LockIt") as RadButton);
                if (Helpers.GetAction() == Actions.Lock && HasRight(ViewState["rights"] as List<Tuple<int, bool>>, Actions.Lock))
                {
                    button.Visible = true;
                }
                else
                {
                    button.Visible = false;
                }

                if (Helpers.GetAction() == Actions.Lock || Helpers.GetAction() == Actions.Release || Helpers.GetAction() == Actions.ReleaseBp)
                {
                    RadTabStrip ts = editFormItem.FindControl("RadTabStrip1") as RadTabStrip;
                    ts.Tabs[0].Selected = false;
                    ts.Tabs[2].Selected = true;
                    ts.Tabs[2].PageView.Selected = true;
                }
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            {
                GridEditableItem item = (GridEditableItem) e.Item;
                GetEmployees_Result employee = e.Item.DataItem as GetEmployees_Result;
                int passStatus = 0;
                if (employee != null)
                {
                    passStatus = Helpers.GetEmployeePassStatus(employee.EmployeeID);
                }
                RadButton btn = (item.FindControl("TakePicture") as RadButton);
                string cmd;
                if (employee != null)
                {
                    cmd = "function(sender, args) {openWebCamWindow(" + employee.AddressID + ");}";
                    btn.OnClientClicked = cmd;
                    btn.Enabled = true;
                }
                else
                {
                    btn.Enabled = false;
                }

                // Firmenauswahl inaktiv, wenn Ausweis gedruckt
                RadDropDownTree cbCompany = item.FindControl("CompanyID") as RadDropDownTree;
                if (cbCompany != null)
                {
                    if (passStatus == PassStatus.Printed || passStatus == PassStatus.Activated || passStatus == PassStatus.Deactivated || passStatus == PassStatus.Locked)
                    {
                        cbCompany.Enabled = false;
                    }
                    else
                    {
                        cbCompany.Enabled = true;
                    }
                }

                // Drucken Button steuern
                btn = (item.FindControl("PassPrint") as RadButton);
                AccessControl access = new AccessControl();

                bool complete = false;
                if (e.Item is GridEditFormInsertItem)
                {
                    complete = access.AllRelevantDocumentsSubmitted(Convert.ToInt32(Session["NextEmployeeID"]));
                }
                else
                {
                    complete = access.AllRelevantDocumentsSubmitted(employee.EmployeeID);
                }

                if (employee != null && employee.StatusID == Status.Released && passStatus != PassStatus.Printed && passStatus != PassStatus.Activated && complete)
                {
                    cmd = "function(sender, args) {openRadWindow(" + employee.EmployeeID + ", '" + employee.LastName + "', '" + employee.FirstName + "', " + Actions.Print + "); return false;}";
                    btn.OnClientClicked = cmd;
                    btn.Enabled = true;
                }
                else if (employee != null && employee.StatusID == Status.Released && passStatus == PassStatus.Printed && passStatus != PassStatus.Deactivated && passStatus != PassStatus.Locked)
                {
                    // Druckwiederholung 
                    Pass pass = Helpers.GetPass(employee.EmployeeID, false);
                    if (!pass.FileName.Equals(string.Empty))
                    {
                        btn.Enabled = true;
                        btn.OnClientClicked = "gridCommand";
                        btn.Text = pass.FileName;
                        btn.CommandArgument = employee.EmployeeID.ToString();
                        btn.CommandName = "ReprintPass";
                        btn.AutoPostBack = true;
                    }
                    else
                    {
                        btn.Enabled = false;
                    }
                }
                else
                {
                    btn.Enabled = false;
                }

                btn = (item.FindControl("PassActivate") as RadButton);
                if (employee != null && passStatus != PassStatus.None && passStatus != PassStatus.Activated && passStatus != PassStatus.Locked)
                {
                    cmd = "function(sender, args) {openRadWindow(" + employee.EmployeeID + ", '" + employee.LastName + "', '" + employee.FirstName + "', " + Actions.Activate + "); return false;}";
                    btn.OnClientClicked = cmd;
                    btn.Enabled = true;
                }
                else
                {
                    btn.Enabled = false;
                }

                btn = (item.FindControl("PassDeactivate") as RadButton);
                if (employee != null && passStatus != PassStatus.None && passStatus != PassStatus.Printed && passStatus != PassStatus.Deactivated && passStatus != PassStatus.Locked)
                {
                    cmd = "function(sender, args) {openRadWindow(" + employee.EmployeeID + ", '" + employee.LastName + "', '" + employee.FirstName + "', " + Actions.Deactivate + "); return false;}";
                    btn.OnClientClicked = cmd;
                    btn.Enabled = true;
                }
                else
                {
                    btn.Enabled = false;
                }

                btn = (item.FindControl("PassLock") as RadButton);
                if (employee != null && passStatus != PassStatus.None && passStatus != PassStatus.Deactivated && passStatus != PassStatus.Locked)
                {
                    cmd = "function(sender, args) {openRadWindow(" + employee.EmployeeID + ", '" + employee.LastName + "', '" + employee.FirstName + "', " + Actions.Lock + "); return false;}";
                    btn.OnClientClicked = cmd;
                    btn.Enabled = true;
                }
                else
                {
                    btn.Enabled = false;
                }

                btn = (item.FindControl("AccessRightInfo") as RadButton);
                if (employee != null && passStatus != PassStatus.None && (passStatus == PassStatus.Activated || passStatus == PassStatus.Deactivated))
                {
                    cmd = "function(sender, args) {openEmployeeAccessRight(" + employee.EmployeeID + "); return false;}";
                    btn.OnClientClicked = cmd;
                    btn.Enabled = true;
                }
                else
                {
                    btn.Enabled = false;
                }
            }

            if (e.Item is GridDataItem)
            {
                GetEmployees_Result employee = e.Item.DataItem as GetEmployees_Result;
                bool deleteColumnVisible = (Convert.ToInt32(Session["UserType"]) == 100) || employee.StatusID == Status.WaitRelease || employee.StatusID == Status.WaitReleaseCC || employee.StatusID == Status.ReleasedForCCWaitForBp;
                (item1["deleteColumn"].Controls[0] as ImageButton).Visible = deleteColumnVisible;

                if (lastID != 0 && Convert.ToInt32(item1.GetDataKeyValue(idName)) == lastID)
                {
                    item1.Selected = true;
                }
            }

            if (e.Item.ItemType == GridItemType.Item || e.Item.ItemType == GridItemType.AlternatingItem)
            {
                Control target = e.Item.FindControl("PhotoData");
                if (!Object.Equals(target, null))
                {
                    if (!Object.Equals(this.RadToolTipManager1, null))
                    {
                        //Add the button (target) id to the tooltip manager
                        this.RadToolTipManager1.TargetControls.Add(target.ClientID, ((GetEmployees_Result) e.Item.DataItem).EmployeeID.ToString(), true);
                    }
                    if ((target as RadBinaryImage).DataValue == null || (target as RadBinaryImage).DataValue.Length == 0)
                    {
                        (target as RadBinaryImage).Visible = false;
                    }
                }
            }
            //if (e.Item is GridEditFormItem && e.Item.IsInEditMode)
            //{
            //    GridEditFormItem editFormItem = (GridEditFormItem)e.Item;
            //    RadGrid rg = editFormItem.FindControl("RadGridDocumentRules") as RadGrid;
            //    if (rg != null)
            //    {
            //        Webservices webservice = new Webservices();
            //        GetEmployeeRelevantDocuments_Result[] result = webservice.GetEmployeeRelevantDocuments(Convert.ToInt32(Session["MyEmployeeID"]));
            //        rg.DataSource = result;
            //        rg.DataBind();
            //    }
            //}
            // Aufruf durch Vorgangsverwaltung
            //if (e.Item is GridDataItem && lastID != 0 && e.Item.DataItem != null && (action == Actions.Release || action == Actions.ReleaseBp))
            //{
            //    GetEmployees_Result employee = e.Item.DataItem as GetEmployees_Result;
            //    if (employee.EmployeeID == lastID)
            //    {
            //        int statusID = employee.StatusID;
            //        if (statusID != Status.CreatedNotConfirmed && (HasRight(ViewState["rights"] as List<Tuple<int, bool>>, action)))
            //        {
            //            Helpers.SetAction(action);
            //            e.Item.Edit = true;
            //        }
            //    }
            //}
        }

        protected void CompanyID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadComboBox cb = (sender as RadComboBox).Parent.FindControl("TradeID") as RadComboBox;
            if (cb != null)
            {
                cb.Text = "";
                cb.Items.Clear();
                cb.DataSource = LoadTrades(e.Value);
                cb.DataBind();
            }
        }

        protected DataTable LoadTrades(string companyID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT ct.TradeGroupID, ct.TradeID, t.TradeNumber, t.NameVisible, t.DescriptionShort, m_tg.NameVisible + ' : ' + t.NameVisible AS TradeName ");
            sql.Append("FROM Master_CompanyTrades AS ct ");
            sql.Append("INNER JOIN Master_Trades AS t ");
            sql.Append("ON ct.SystemID = t.SystemID AND ct.BpID = t.BpID AND ct.TradeGroupID = t.TradeGroupID AND ct.TradeID = t.TradeID ");
            sql.Append("INNER JOIN Master_TradeGroups AS m_tg ");
            sql.Append("ON t.SystemID = m_tg.SystemID AND t.BpID = m_tg.BpID AND t.TradeGroupID = m_tg.TradeGroupID ");
            sql.Append("WHERE ct.SystemID = @SystemID ");
            sql.Append("AND ct.BpID = @BpID ");
            sql.Append("AND ct.CompanyID = @CompanyID ");
            sql.Append("ORDER BY m_tg.NameVisible, t.NameVisible ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = Convert.ToInt32(companyID);
            cmd.Parameters.Add(par);

            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
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

            return dt;
        }

        protected void TradeID_ItemsRequested(object sender, RadComboBoxItemsRequestedEventArgs e)
        {
            RadComboBox cbTrade = (sender as RadComboBox);
            RadDropDownTree cbCompany = cbTrade.Parent.FindControl("CompanyID") as RadDropDownTree;
            if (cbCompany != null)
            {
                string companyID = cbCompany.SelectedValue;
                if (companyID == null || companyID.Equals(String.Empty))
                {
                    companyID = "0";
                }
                cbTrade.DataSource = LoadTrades(companyID);
                cbTrade.DataBind();
            }
        }

        protected void AvailableQualifications_Transferred(object sender, RadListBoxTransferredEventArgs e)
        {
            if (e.Items.Count > 0)
            {
                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand("MoveEmployeeQualification", con);
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

                par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                par.Value = Convert.ToInt32((e.SourceListBox.Parent.FindControl("EmployeeID") as Label).Text);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StaffRoleID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@User", SqlDbType.NVarChar, 50);
                par.Direction = ParameterDirection.Input;
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                foreach (RadListBoxItem item in e.Items)
                {
                    cmd.Parameters["@StaffRoleID"].Value = item.Value;

                    try
                    {
                        logger.InfoFormat("Try to execute {0}", cmd.CommandText);
                        cmd.ExecuteNonQuery();
                    }
                    catch (SqlException ex)
                    {
                        logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                        throw ex;
                    }
                    catch (System.Exception ex)
                    {
                        logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                        throw ex;
                    }
                }
                con.Close();
            }
        }

        protected void RadGrid1_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            Webservices webservice = new Webservices();
            GetEmployees_Result[] result = webservice.GetEmployees(true);
            if (Session["AlphaFilter"] != null && !Session["AlphaFilter"].ToString().Equals(string.Empty))
            {
                result = result.Where(r => r.FirstChar.Equals(Session["AlphaFilter"].ToString())).ToArray();
            }
            if (Session["LastEdited"] != null && Convert.ToBoolean(Session["LastEdited"]))
            {
                result = result.Where(r => r.EmployeeID == lastID).ToArray();
            }
            RadGrid1.DataSource = result;
        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;

                RadDropDownTree cb = (item.FindControl("CompanyID") as RadDropDownTree);
                if (cb.SelectedValue == null || cb.SelectedValue.Equals("0") || cb.SelectedValue.Equals(string.Empty))
                {
                    e.Canceled = true;
                    cb.Focus();
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblActionInsert, Resources.Resource.msgPleaseSelect);
                }
                else
                {
                    StringBuilder sql = new StringBuilder();
                    sql.Append("INSERT INTO Master_Addresses (SystemID, BpId, AddressID, Salutation, FirstName, LastName, Address1, Address2, Zip, City, State, CountryID, LanguageID, ");
                    if (Session["ImageData"] != null)
                    {
                        sql.Append("PhotoFileName, PhotoData, ThumbnailData, ");
                    }
                    sql.Append("NationalityID, Phone, Email, BirthDate, CreatedFrom, CreatedOn, EditFrom, EditOn, Soundex) ");
                    sql.Append("VALUES (@SystemID, @BpId, @AddressID, @Salutation, @FirstName, @LastName, @Address1, @Address2, @Zip, @City, @State, @CountryID, @LanguageID, ");
                    if (Session["ImageData"] != null)
                    {
                        sql.Append("@PhotoFileName, @PhotoData, @ThumbnailData, ");
                    }
                    sql.AppendLine("@NationalityID, @Phone, @Email, @BirthDate, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), dbo.SoundexGer(@LastName)); ");
                    //sql.AppendLine("SELECT @AddressID = SCOPE_IDENTITY(); ");
                    sql.Append("INSERT INTO Master_Employees (SystemID, BpID, EmployeeID, AddressID, CompanyID, TradeID, StaffFunction, EmploymentStatusID, MaxHrsPerMonth, ");
                    sql.Append("AttributeID, Description, ExternalPassID, StatusID, CreatedFrom, CreatedOn, EditFrom, EditOn, UserString1, UserString2, UserString3, UserString4, ");
                    sql.Append("UserBit1, UserBit2, UserBit3, UserBit4, AccessRightValidUntil) ");
                    sql.Append("VALUES (@SystemID, @BpID, @EmployeeID, @AddressID, @CompanyID, @TradeID, @StaffFunction, @EmploymentStatusID, @MaxHrsPerMonth, ");
                    sql.Append("@AttributeID, @Description, @ExternalPassID, @StatusID, @UserName, SYSDATETIME(), @UserName, SYSDATETIME(), @UserString1, @UserString2, @UserString3, ");
                    sql.AppendLine("@UserString4, @UserBit1, @UserBit2, @UserBit3, @UserBit4, @AccessRightValidUntil); ");
                    sql.Append("INSERT INTO Master_EmployeeRelevantDocuments (SystemID, BpID, EmployeeID, RelevantFor, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                    sql.Append("SELECT r.SystemID, @BpID, @EmployeeID, r.RelevantFor, @UserName, SYSDATETIME(), @UserName, SYSDATETIME() ");
                    sql.Append("FROM System_RelevantFor r ");
                    sql.Append("WHERE r.SystemID = @SystemID ");
                    sql.Append("AND NOT EXISTS (SELECT 1 FROM Master_EmployeeRelevantDocuments erd ");
                    sql.Append("WHERE erd.SystemID = @SystemID AND erd.BpID = @BpID AND erd.EmployeeID = @EmployeeID AND erd.RelevantFor = r.RelevantFor) ");

                    SqlConnection con = new SqlConnection(ConnectionString);
                    SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                    SqlParameter par = new SqlParameter();

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BpID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["BpID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                    par.Value = Convert.ToInt32((item.FindControl("EmployeeID") as Label).Text);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Salutation", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("Salutation") as RadComboBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@FirstName", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("FirstName") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@LastName", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("LastName") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Address1", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("Address1") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Address2", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("Address2") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Zip", SqlDbType.NVarChar, 20);
                    par.Value = (item.FindControl("Zip") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@City", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("City") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@State", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("State") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@CountryID", SqlDbType.NVarChar, 10);
                    par.Value = (item.FindControl("CountryID") as RadComboBox).SelectedValue;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Phone", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("Phone") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Email", SqlDbType.NVarChar, 200);
                    par.Value = (item.FindControl("Email") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AccessRightValidUntil", SqlDbType.DateTime);
                    if ((item.FindControl("AccessRightValidUntil") as RadDatePicker).SelectedDate != null)
                    {
                        par.Value = (item.FindControl("AccessRightValidUntil") as RadDatePicker).SelectedDate;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BirthDate", SqlDbType.DateTime);
                    if ((item.FindControl("BirthDate") as RadDatePicker).SelectedDate != null)
                    {
                        par.Value = (item.FindControl("BirthDate") as RadDatePicker).SelectedDate;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(par);

                    if (Session["ImageData"] != null)
                    {
                        byte[] bytes = Convert.FromBase64String(Session["ImageData"].ToString());

                        par = new SqlParameter("@PhotoFileName", SqlDbType.NVarChar, 200);
                        par.Value = Helpers.CleanFilename(Session["ImageFileName"].ToString());
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@PhotoData", SqlDbType.Image);
                        System.Drawing.Image img = Helpers.ByteArrayToImage(bytes);
                        img = Helpers.ScaleImage(img, 350, 450);
                        System.Drawing.Imaging.ImageFormat fmt = Helpers.ParseImageFormat(Path.GetExtension(Helpers.CleanFilename(Session["ImageFileName"].ToString())));
                        byte[] fileData = Helpers.ImageToByteArray(img, fmt);
                        par.Value = fileData;
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@ThumbnailData", SqlDbType.Image);
                        par.Value = Helpers.CreateThumbnail(bytes, 45);
                        cmd.Parameters.Add(par);
                    }

                    par = new SqlParameter("@NationalityID", SqlDbType.NVarChar, 10);
                    par.Value = (item.FindControl("NationalityID") as RadComboBox).SelectedValue;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@LanguageID", SqlDbType.NVarChar, 10);
                    par.Value = (item.FindControl("LanguageID") as RadComboBox).SelectedValue;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                    par.Value = Session["LoginName"].ToString();
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AddressID", SqlDbType.Int);
                    par.Value = Convert.ToInt32((item.FindControl("AddressID") as HiddenField).Value);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@CompanyID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(cb.SelectedValue.Split(',')[0]);
                    cmd.Parameters.Add(par);

                    int tradeID = 0;
                    if (!(item.FindControl("TradeID") as RadComboBox).SelectedValue.Equals(String.Empty))
                    {
                        tradeID = Convert.ToInt32((item.FindControl("TradeID") as RadComboBox).SelectedValue);
                    }
                    par = new SqlParameter("@TradeID", SqlDbType.Int);
                    par.Value = tradeID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@StaffFunction", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("StaffFunction") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    int employmentStatusID = 0;
                    if (!(item.FindControl("EmploymentStatusID") as RadComboBox).SelectedValue.Equals(String.Empty))
                    {
                        employmentStatusID = Convert.ToInt32((item.FindControl("EmploymentStatusID") as RadComboBox).SelectedValue);
                    }
                    par = new SqlParameter("@EmploymentStatusID", SqlDbType.Int);
                    par.Value = employmentStatusID;
                    cmd.Parameters.Add(par);

                    int maxHrsPerMonth = 0;
                    if (!(item.FindControl("MaxHrsPerMonth") as RadTextBox).Text.Equals(String.Empty))
                    {
                        maxHrsPerMonth = Convert.ToInt32((item.FindControl("MaxHrsPerMonth") as RadTextBox).Text);
                    }
                    par = new SqlParameter("@MaxHrsPerMonth", SqlDbType.Int);
                    par.Value = maxHrsPerMonth;
                    cmd.Parameters.Add(par);

                    int attributeID = 0;
                    if (!(item.FindControl("AttributeID") as RadComboBox).SelectedValue.Equals(String.Empty))
                    {
                        attributeID = Convert.ToInt32((item.FindControl("AttributeID") as RadComboBox).SelectedValue);
                    }
                    par = new SqlParameter("@AttributeID", SqlDbType.Int);
                    par.Value = attributeID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Description", SqlDbType.NVarChar, 2000);
                    par.Value = (item.FindControl("Description") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ExternalPassID", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("ExternalPassID") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString1", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString1") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString2", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString2") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString3", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString3") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString4", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString4") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit1", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit1") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit2", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit2") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit3", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit3") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit4", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit4") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@StatusID", SqlDbType.Int);
                    par.Value = Status.WaitReleaseCC;
                    cmd.Parameters.Add(par);

                    con.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();
                        lastID = Convert.ToInt32(cmd.Parameters["@EmployeeID"].Value);

                        // Eintrag in Vorgangsverwaltung
                        string dialogName = GetResource(Helpers.GetDialogResID(type.Name));
                        string companyName = cb.SelectedText;
                        string refName = (item.FindControl("FirstName") as RadTextBox).Text + " " + (item.FindControl("LastName") as RadTextBox).Text;
                        string actionHint = "Gehört der Mitarbeiter zur Firma? Daten komplett und stimmig?";

                        // Duplikatsuche
                        string employeeDuplicates = string.Empty;
                        GetEmployeeDuplicates_Result[] employees = Helpers.GetEmployeeDuplicates(lastID);
                        if (employees != null && employees.Count() > 0)
                        {
                            StringBuilder duplicatesHint = new StringBuilder();
                            duplicatesHint.Append("<br />Mögliche Duplikate (Relevanz, Nachname, Vorname, Email, Geburtsdatum, PLZ):<br />");
                            duplicatesHint.Append("Possible duplicates (Relevance, Last name, First name, Email, Birth date, Zip):<br /><br />");
                            foreach (GetEmployeeDuplicates_Result employee in employees)
                            {
                                duplicatesHint.AppendFormat("{0}, {1}, {2}, {3}, {4}, {5}<br />", employee.Match.ToString(), employee.LastName, employee.FirstName, employee.Email, employee.BirthDate, employee.Zip);
                            }
                            employeeDuplicates = duplicatesHint.ToString();
                        }

                        if (!employeeDuplicates.Equals(string.Empty))
                        {
                            actionHint += employeeDuplicates;
                        }

                        // Recht Freigabe
                        GetCompanyInfo_Result[] companyInfo = Helpers.GetCompanyInfo(Convert.ToInt32(cb.SelectedValue.Split(',')[0]));
                        int companyCentralID = 0;
                        if (companyInfo != null)
                        {
                            companyCentralID = companyInfo[0].CompanyCentralID;
                        }

                        List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                        Helpers.CreateProcessEvent(type.Name, dialogName, companyName, Actions.Release, lastID, refName, actionHint, companyCentralID, string.Empty, values.ToArray());

                        Helpers.DialogLogger(type, Actions.Create, lastID.ToString(), Resources.Resource.lblActionCreate);
                        SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                        Helpers.SetAction(Actions.View);
                        RadGrid1.MasterTableView.IsItemInserted = false;

                        if (Convert.ToBoolean(Session["NoExit"]))
                        {
                            Helpers.SetAction(Actions.Edit);
                            Helpers.GotoLastEdited(RadGrid1, lastID, idName, true);
                            Session["NoExit"] = false;
                        }
                        else
                        {
                            // RadGrid1.MasterTableView.Rebind();
                        }
                    }
                    catch (SqlException ex)
                    {
                        SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
                    }
                    catch (System.Exception ex)
                    {
                        logger.Error("Exception: " + ex.Message);
                        if (ex.InnerException != null)
                        {
                            logger.Error("Inner Exception: " + ex.InnerException.Message);
                        }
                        logger.Debug("Exception Details: \n" + ex);
                        SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
                    }
                    finally
                    {
                        con.Close();
                    }

                    // Message anzeigen
                    if (!string.IsNullOrEmpty(gridMessage))
                    {
                        DisplayMessage(messageTitle, gridMessage, messageColor);
                    }

                    Helpers.EmployeeChanged(lastID);

                    Session["ImageData"] = null;
                }
            }
            else
            {
                e.Canceled = true;
            }
            Helpers.StartMasterTimer(this.Page.Master);
        }

        protected void RadGrid1_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                GridEditableItem item = e.Item as GridEditableItem;

                // bool accessRelevantChanges = false;
                bool accessRelevantChanges = true;

                RadDropDownTree cb = (item.FindControl("CompanyID") as RadDropDownTree);
                if (cb.SelectedValue == null || cb.SelectedValue.Equals("0") || cb.SelectedValue.Equals(string.Empty))
                {
                    e.Canceled = true;
                    cb.Focus();
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblActionInsert, Resources.Resource.msgPleaseSelect);
                }
                else
                {
                    Hashtable employee = new Hashtable();
                    e.Item.OwnerTableView.ExtractValuesFromItem(employee, item);

                    StringBuilder sql = new StringBuilder();

                    sql.Append("INSERT INTO History_Employees SELECT * FROM Master_Employees ");
                    sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @EmployeeID; ");
                    sql.Append("INSERT INTO History_Addresses SELECT * FROM Master_Addresses ");
                    sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND AddressID = @AddressID; ");
                    sql.Append("UPDATE [Master_Employees] SET [CompanyID] = @CompanyID, [TradeID] = @TradeID, [StaffFunction] = @StaffFunction, ");
                    sql.Append("[EmploymentStatusID] = @EmploymentStatusID, [MaxHrsPerMonth] = @MaxHrsPerMonth, [AttributeID] = @AttributeID, ExternalPassID = @ExternalPassID, ");
                    sql.Append("UserString1 = @UserString1, UserString2 = @UserString2, UserString3 = @UserString3, UserString4 = @UserString4, UserBit1 = @UserBit1, UserBit2 = @UserBit2, ");
                    sql.Append("UserBit3 = @UserBit3, UserBit4 = @UserBit4, StatusID = @StatusID, ");
                    sql.Append("[Description] = @Description, [EditFrom] = @UserName, [EditOn] = SYSDATETIME(), [ReleaseCFrom] = @ReleaseCFrom, [ReleaseCOn] = @ReleaseCOn, ");
                    sql.Append("[ReleaseBFrom] = @ReleaseBFrom, [ReleaseBOn] = @ReleaseBOn, [LockedFrom] = @LockedFrom, [LockedOn] = @LockedOn, AccessRightValidUntil = @AccessRightValidUntil ");
                    sql.AppendLine("WHERE [SystemID] = @SystemID AND [BpID] = @BpID AND [EmployeeID] = @EmployeeID; ");
                    sql.Append("UPDATE Master_Addresses SET Salutation = @Salutation, FirstName = @FirstName, LastName = @LastName, Address1 = @Address1, ");
                    sql.Append("Address2 = @Address2, Zip = @Zip, City = @City, [State] = @State, CountryID = @CountryID, LanguageID = @LanguageID, NationalityID = @NationalityID, Phone = @Phone, ");
                    sql.Append("Email = @Email, BirthDate = @BirthDate, ");
                    if (Session["ImageData"] != null)
                    {
                        sql.Append("PhotoFileName = @PhotoFileName, PhotoData = @PhotoData, ThumbnailData = @ThumbnailData, ");
                    }
                    sql.Append("[EditFrom] = @UserName, [EditOn] = SYSDATETIME(), Soundex = dbo.SoundexGer(@LastName) ");
                    sql.Append("WHERE SystemID = @SystemID ");
                    sql.Append("AND [BpID] = @BpID ");
                    sql.AppendLine("AND AddressID = @AddressID; ");
                    sql.Append("INSERT INTO Master_EmployeeRelevantDocuments (SystemID, BpID, EmployeeID, RelevantFor, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
                    sql.Append("SELECT r.SystemID, @BpID, @EmployeeID, r.RelevantFor, @UserName, SYSDATETIME(), @UserName, SYSDATETIME() ");
                    sql.Append("FROM System_RelevantFor r ");
                    sql.Append("WHERE r.SystemID = @SystemID ");
                    sql.Append("AND NOT EXISTS (SELECT 1 FROM Master_EmployeeRelevantDocuments erd ");
                    sql.Append("WHERE erd.SystemID = @SystemID AND erd.BpID = @BpID AND erd.EmployeeID = @EmployeeID AND erd.RelevantFor = r.RelevantFor) ");

                    SqlConnection con = new SqlConnection(ConnectionString);
                    SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                    SqlParameter par = new SqlParameter();

                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["SystemID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BpID", SqlDbType.Int);
                    par.Value = Convert.ToInt32(Session["BpID"]);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                    par.Value = (item.FindControl("EmployeeID") as Label).Text;
                    lastID = Convert.ToInt32((item.FindControl("EmployeeID") as Label).Text);
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Salutation", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("Salutation") as RadComboBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@FirstName", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("FirstName") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@LastName", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("LastName") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Address1", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("Address1") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Address2", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("Address2") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Zip", SqlDbType.NVarChar, 20);
                    par.Value = (item.FindControl("Zip") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@City", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("City") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@State", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("State") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@CountryID", SqlDbType.NVarChar, 10);
                    if (!item.SavedOldValues["CountryID"].ToString().Equals((item.FindControl("CountryID") as RadComboBox).SelectedValue))
                    {
                        accessRelevantChanges = true;
                    }
                    par.Value = (item.FindControl("CountryID") as RadComboBox).SelectedValue;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Phone", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("Phone") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Email", SqlDbType.NVarChar, 200);
                    par.Value = (item.FindControl("Email") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@BirthDate", SqlDbType.DateTime);
                    if ((item.FindControl("BirthDate") as RadDatePicker).SelectedDate != null)
                    {
                        par.Value = (item.FindControl("BirthDate") as RadDatePicker).SelectedDate;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(par);

                    if (Session["ImageData"] != null)
                    {
                        byte[] bytes = Convert.FromBase64String(Session["ImageData"].ToString());

                        par = new SqlParameter("@PhotoFileName", SqlDbType.NVarChar, 200);
                        par.Value = Helpers.CleanFilename(Session["ImageFileName"].ToString());
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@PhotoData", SqlDbType.Image);
                        System.Drawing.Image img = Helpers.ByteArrayToImage(bytes);
                        img = Helpers.ScaleImage(img, 350, 450);
                        System.Drawing.Imaging.ImageFormat fmt = Helpers.ParseImageFormat(Path.GetExtension(Helpers.CleanFilename(Session["ImageFileName"].ToString())));
                        byte[] fileData = Helpers.ImageToByteArray(img, fmt);
                        par.Value = fileData;
                        cmd.Parameters.Add(par);

                        par = new SqlParameter("@ThumbnailData", SqlDbType.Image);
                        par.Value = Helpers.CreateThumbnail(bytes, 45);
                        cmd.Parameters.Add(par);
                    }

                    par = new SqlParameter("@NationalityID", SqlDbType.NVarChar, 10);
                    par.Value = (item.FindControl("NationalityID") as RadComboBox).SelectedValue;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@LanguageID", SqlDbType.NVarChar, 10);
                    par.Value = (item.FindControl("LanguageID") as RadComboBox).SelectedValue;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                    par.Value = Session["LoginName"].ToString();
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AddressID", SqlDbType.Int);
                    par.Value = (item.FindControl("AddressID") as HiddenField).Value;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@CompanyID", SqlDbType.Int);
                    if (item.SavedOldValues["CompanyID"] != null && !item.SavedOldValues["CompanyID"].ToString().Equals(cb.SelectedValue.Split(',')[0]))
                    {
                        accessRelevantChanges = true;
                    }
                    par.Value = Convert.ToInt32(cb.SelectedValue.Split(',')[0]);
                    cmd.Parameters.Add(par);

                    int tradeID = 0;
                    if (!(item.FindControl("TradeID") as RadComboBox).SelectedValue.Equals(String.Empty))
                    {
                        if (item.SavedOldValues["TradeID"] != null && !item.SavedOldValues["TradeID"].ToString().Equals((item.FindControl("TradeID") as RadComboBox).SelectedValue))
                        {
                            accessRelevantChanges = true;
                        }
                        tradeID = Convert.ToInt32((item.FindControl("TradeID") as RadComboBox).SelectedValue);
                    }
                    par = new SqlParameter("@TradeID", SqlDbType.Int);
                    par.Value = tradeID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@StaffFunction", SqlDbType.NVarChar, 100);
                    par.Value = (item.FindControl("StaffFunction") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    int employmentStatusID = 0;
                    if (!(item.FindControl("EmploymentStatusID") as RadComboBox).SelectedValue.Equals(String.Empty))
                    {
                        if (item.SavedOldValues["EmploymentStatusID"] != null && !item.SavedOldValues["EmploymentStatusID"].ToString().Equals((item.FindControl("EmploymentStatusID") as RadComboBox).SelectedValue))
                        {
                            accessRelevantChanges = true;
                        }
                        employmentStatusID = Convert.ToInt32((item.FindControl("EmploymentStatusID") as RadComboBox).SelectedValue);
                    }
                    par = new SqlParameter("@EmploymentStatusID", SqlDbType.Int);
                    par.Value = employmentStatusID;
                    cmd.Parameters.Add(par);

                    int maxHrsPerMonth = 0;
                    if (!(item.FindControl("MaxHrsPerMonth") as RadTextBox).Text.Equals(String.Empty))
                    {
                        maxHrsPerMonth = Convert.ToInt32((item.FindControl("MaxHrsPerMonth") as RadTextBox).Text);
                    }
                    par = new SqlParameter("@MaxHrsPerMonth", SqlDbType.Int);
                    par.Value = maxHrsPerMonth;
                    cmd.Parameters.Add(par);

                    int attributeID = 0;
                    if (!(item.FindControl("AttributeID") as RadComboBox).SelectedValue.Equals(String.Empty))
                    {
                        attributeID = Convert.ToInt32((item.FindControl("AttributeID") as RadComboBox).SelectedValue);
                    }
                    par = new SqlParameter("@AttributeID", SqlDbType.Int);
                    par.Value = attributeID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@StatusID", SqlDbType.Int);
                    int prevStatusID = Convert.ToInt32((item.FindControl("StatusID") as HiddenField).Value);
                    int statusID = 0;
                    string releaseCOn = (item.FindControl("ReleaseCOn") as Label).Text;
                    string releaseBOn = (item.FindControl("ReleaseBOn") as Label).Text;
                    string lockedOn = (item.FindControl("LockedOn") as Label).Text;
                    if (lockedOn != null && !lockedOn.Equals(string.Empty))
                    {
                        // Status: Locked
                        statusID = Status.Locked;
                    }
                    else if (releaseCOn != null && !releaseCOn.Equals(string.Empty) && (releaseBOn == null || releaseBOn.Equals(string.Empty)))
                    {
                        // Status: Released for central company master, waiting to release for building project
                        statusID = Status.ReleasedForCCWaitForBp;
                    }
                    else if (releaseCOn != null && !releaseCOn.Equals(string.Empty) && releaseBOn != null && !releaseBOn.Equals(string.Empty) && (lockedOn == null || lockedOn.Equals(string.Empty)))
                    {
                        // Status: Released for central company master and building project
                        statusID = Status.Released;
                    }
                    else
                    {
                        // Status: Waiting to release for central company master and building project
                        statusID = Status.WaitReleaseCC;
                    }
                    if (item.SavedOldValues["StatusID"] != null && !item.SavedOldValues["StatusID"].ToString().Equals(statusID.ToString()))
                    {
                        accessRelevantChanges = true;
                    }
                    par.Value = statusID;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@Description", SqlDbType.NVarChar, 2000);
                    par.Value = (item.FindControl("Description") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ExternalPassID", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("ExternalPassID") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString1", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString1") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString2", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString2") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString3", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString3") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserString4", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("UserString4") as RadTextBox).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit1", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit1") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit2", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit2") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit3", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit3") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@UserBit4", SqlDbType.Bit);
                    par.Value = (item.FindControl("UserBit4") as CheckBox).Checked;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@AccessRightValidUntil", SqlDbType.DateTime);
                    if ((item.FindControl("AccessRightValidUntil") as RadDatePicker).SelectedDate != null)
                    {
                        par.Value = (item.FindControl("AccessRightValidUntil") as RadDatePicker).SelectedDate;
                    }
                    else
                    {
                        par.Value = DBNull.Value;
                    }
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ReleaseCFrom", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("ReleaseCFrom") as Label).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ReleaseCOn", SqlDbType.DateTime);
                    string parString = (item.FindControl("ReleaseCOn") as Label).Text;
                    if (parString.Equals(String.Empty))
                    {
                        par.Value = DBNull.Value;
                    }
                    else
                    {
                        par.Value = parString;
                    }
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ReleaseBFrom", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("ReleaseBFrom") as Label).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@ReleaseBOn", SqlDbType.DateTime);
                    parString = (item.FindControl("ReleaseBOn") as Label).Text;
                    if (parString.Equals(String.Empty))
                    {
                        par.Value = DBNull.Value;
                    }
                    else
                    {
                        par.Value = parString;
                    }
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@LockedFrom", SqlDbType.NVarChar, 50);
                    par.Value = (item.FindControl("LockedFrom") as Label).Text;
                    cmd.Parameters.Add(par);

                    par = new SqlParameter("@LockedOn", SqlDbType.DateTime);
                    parString = (item.FindControl("LockedOn") as Label).Text;
                    if (parString.Equals(String.Empty))
                    {
                        par.Value = DBNull.Value;
                    }
                    else
                    {
                        par.Value = parString;
                    }
                    cmd.Parameters.Add(par);

                    con.Open();
                    try
                    {
                        cmd.ExecuteNonQuery();

                        Helpers.DialogLogger(type, Actions.Edit, (item.FindControl("EmployeeID") as Label).Text, Resources.Resource.lblActionEdit);
                        SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");

                        // Behältermanagement aktualisieren
                        Webservices webservice = new Webservices();
                        GetEmployees_Result employee1 = webservice.GetEmployees(0, Convert.ToInt32((item.FindControl("EmployeeID") as Label).Text), "", 0, 0)[0];
                        if (employee1 != null && employee1.ExternalID != null && !employee1.ExternalID.Equals(string.Empty))
                        {
                            ContainerManagementClient client = new ContainerManagementClient();
                            try
                            {
                                client.EmployeeData(employee1.SystemID, employee1.BpID, employee1.EmployeeID, Actions.Update);
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

                        string dialogName = GetResource(Helpers.GetDialogResID(type.Name));
                        string companyName = cb.SelectedText;
                        string refName = (item.FindControl("FirstName") as RadTextBox).Text + " " + (item.FindControl("LastName") as RadTextBox).Text;
                        List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                        values.Add(new Tuple<string, string>("CompanyID", cb.SelectedValue.Split(',')[0]));
                        values.Add(new Tuple<string, string>("CompanyName", companyName));
                        values.Add(new Tuple<string, string>("BpName", Session["BpName"].ToString()));
                        values.Add(new Tuple<string, string>("Salutation", (item.FindControl("Salutation") as RadComboBox).Text));
                        values.Add(new Tuple<string, string>("FirstName", (item.FindControl("FirstName") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("LastName", (item.FindControl("LastName") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("Address1", (item.FindControl("Address1") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("Address2", (item.FindControl("Address2") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("Zip", (item.FindControl("Zip") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("City", (item.FindControl("City") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("State", (item.FindControl("State") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("CountryName", (item.FindControl("CountryID") as RadComboBox).SelectedValue));
                        values.Add(new Tuple<string, string>("Phone", (item.FindControl("Phone") as RadTextBox).Text));
                        values.Add(new Tuple<string, string>("Email", (item.FindControl("Email") as RadTextBox).Text));
                        if ((item.FindControl("BirthDate") as RadDatePicker).SelectedDate != null)
                        {
                            values.Add(new Tuple<string, string>("BirthDate", (item.FindControl("BirthDate") as RadDatePicker).SelectedDate.ToString()));
                        }
                        values.Add(new Tuple<string, string>("Nationality", (item.FindControl("NationalityID") as RadComboBox).SelectedValue));
                        string languageID = "en";
                        if ((item.FindControl("LanguageID") as RadComboBox).SelectedItem != null)
                        {
                            languageID = (item.FindControl("LanguageID") as RadComboBox).SelectedItem.Text;
                        }
                        values.Add(new Tuple<string, string>("LanguageName", languageID));
                        Tuple<string, string>[] valuesArray = values.ToArray();

                        if (statusID == Status.ReleasedForCCWaitForBp && prevStatusID == Status.WaitReleaseCC)
                        {
                            // Vorgang für Weiterverarbeitung
                            Master_Translations translation = Helpers.GetTranslation("PMHints_RegisterEmployee", Helpers.CurrentLanguage(), valuesArray);
                            string actionHint = translation.HtmlTranslated;
                            Helpers.CreateProcessEvent(type.Name, dialogName, companyName, Actions.ReleaseBp, lastID, refName, actionHint, "PMHints_RegisterEmployee", valuesArray);

                            // Aktuellen Vorgang auf erledigt setzen
                            Data_ProcessEvents eventData = new Data_ProcessEvents();
                            eventData.DialogID = Helpers.GetDialogID(type.Name);
                            eventData.ActionID = Actions.Release;
                            eventData.RefID = lastID;
                            eventData.StatusID = Status.Done;
                            Helpers.ProcessEventDone(eventData);
                        }

                        if (prevStatusID == Status.Released && statusID == Status.Locked)
                        {
                            // Vorgang für Weiterverarbeitung
                            //dialogName = GetResource(Helpers.GetDialogResID(type.Name));
                            //companyName = cb.SelectedText;
                            //refName = (item.FindControl("FirstName") as RadTextBox).Text + " " + (item.FindControl("LastName") as RadTextBox).Text;
                            //string actionHint = "Mitarbeiter wurde für BV gesperrt. Sperrgrund beseitigen!";
                            //Helpers.CreateProcessEvent(type.Name, dialogName, companyName, Actions.ReleaseBp, lastID, refName, actionHint, "PMHints_LockedEmployee", valuesArray);
                        }

                        if (statusID == Status.Released)
                        {
                            // Aktuellen Vorgang auf erledigt setzen
                            Data_ProcessEvents eventData = new Data_ProcessEvents();
                            eventData.DialogID = Helpers.GetDialogID(type.Name);
                            eventData.ActionID = Actions.ReleaseBp;
                            eventData.RefID = lastID;
                            eventData.StatusID = Status.Done;
                            Helpers.ProcessEventDone(eventData);
                        }

                        if (Convert.ToBoolean(Session["NoExit"]))
                        {
                            e.Canceled = true;
                            Session["NoExit"] = false;
                        }
                        else
                        {
                            Helpers.SetAction(Actions.View);
                            Session["EmployeeIDInserted"] = "0";
                            Session["AddressIDInserted"] = "0";
                            Session["EmployeeInitEdit"] = false;
                        }
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

                    // Message anzeigen
                    if (!string.IsNullOrEmpty(gridMessage))
                    {
                        DisplayMessage(messageTitle, gridMessage, messageColor);
                    }

                    if (Session["ReleaseMessage"] != null && Convert.ToBoolean(Session["ReleaseMessage"]))
                    {
                        List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                        values.Add(new Tuple<string, string>("CompanyID", cb.SelectedValue.Split(',')[0]));
                        values.Add(new Tuple<string, string>("CompanyName", cb.SelectedText));
                        values.Add(new Tuple<string, string>("BpName", Session["BpName"].ToString()));
                        values.Add(new Tuple<string, string>("Salutation", employee["Salutation"].ToString()));
                        values.Add(new Tuple<string, string>("FirstName", employee["FirstName"].ToString()));
                        values.Add(new Tuple<string, string>("LastName", employee["LastName"].ToString()));
                        values.Add(new Tuple<string, string>("Address1", employee["Address1"].ToString()));
                        values.Add(new Tuple<string, string>("Address2", employee["Address2"].ToString()));
                        values.Add(new Tuple<string, string>("Zip", employee["Zip"].ToString()));
                        values.Add(new Tuple<string, string>("City", employee["City"].ToString()));
                        values.Add(new Tuple<string, string>("State", employee["State"].ToString()));
                        values.Add(new Tuple<string, string>("CountryName", employee["CountryID"].ToString()));
                        values.Add(new Tuple<string, string>("Phone", employee["Phone"].ToString()));
                        values.Add(new Tuple<string, string>("Email", employee["Email"].ToString()));
                        values.Add(new Tuple<string, string>("BirthDate", Convert.ToDateTime(employee["BirthDate"]).ToString("{0:G}")));
                        values.Add(new Tuple<string, string>("Nationality", employee["NationalityID"].ToString()));
                        values.Add(new Tuple<string, string>("LanguageName", employee["LanguageID"].ToString()));
                        Tuple<string, string>[] valuesArray = values.ToArray();

                        Master_Translations translation = null;

                        if (!employee["Email"].ToString().Equals(string.Empty))
                        {
                            // Email an Mitarbeiter, wenn Freigabe erfolgt
                            translation = Helpers.GetTranslation("ConfirmationEmail_ReleaseEmployee", employee["LanguageID"].ToString(), valuesArray);
                            string subject = translation.DescriptionTranslated;
                            string body = translation.HtmlTranslated;
                            Helpers.SendMail(employee["Email"].ToString(), subject, body);
                        }

                        // Email an Firmenadministrator
                        GetCompanyAdminUserWithBP_Result[] result = Helpers.GetCompanyAdminUserWithBP(Convert.ToInt32(cb.SelectedValue.Split(',')[0]));
                        if (result.Count() > 0)
                        {
                            translation = Helpers.GetTranslation("ConfirmationEmail_ReleaseEmployeeAdmin", result[0].LanguageID, valuesArray);
                            string subject = translation.DescriptionTranslated;
                            string body = translation.HtmlTranslated;
                            string email = result[0].Email;
                            if (!email.Equals(string.Empty))
                            {
                                Helpers.SendMail(email, subject, body);
                            }
                        }

                        Session["ReleaseMessage"] = null;
                    }

                    if (accessRelevantChanges)
                    {
                        Helpers.EmployeeChanged(Convert.ToInt32((item.FindControl("EmployeeID") as Label).Text));
                    }

                    Session["ImageData"] = null;
                }
            }
            else
            {
                e.Canceled = true;
            }

            if (Session["RawUrl"] != null)
            {
                string url = Uri.EscapeUriString(Session["RawUrl"].ToString());
                Session["RawUrl"] = null;
                RadAjaxManager ajax = (RadAjaxManager) this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect(url);
            }
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

        protected void RadGrid1_ItemCreated(object sender, GridItemEventArgs e)
        {
            // Feldsteuerung
            if (e.Item is GridEditableItem && e.Item.IsInEditMode)
            {
                if (e.Item is GridEditFormInsertItem || e.Item is GridDataInsertItem)
                {
                    // Insert
                    FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Create, e, true);
                }
                else
                {
                    if (Helpers.GetAction() == Actions.Release)
                    {
                        // Release
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Release, e, true);
                    }
                    else if (Helpers.GetAction() == Actions.ReleaseBp)
                    {
                        // ReleaseBp
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.ReleaseBp, e, true);
                    }
                    else if (Helpers.GetAction() == Actions.Lock)
                    {
                        // Lock
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Lock, e, true);
                    }
                    else
                    {
                        // Edit
                        FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.Edit, e, true);
                    }
                }
            }
            else
            {
                // View
                FieldsConfig(ViewState["fca"] as GetFieldsConfig_Result[], Actions.View, e, true);
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem) && e.Item.DataItem != null)
            {
                GridEditableItem item = (GridEditableItem) e.Item;
                RadComboBox cb = item.FindControl("CompanyID") as RadComboBox;

                if (cb != null)
                {
                    cb.Items.Clear();
                    string accessAreaID = ((GetEmployees_Result) e.Item.DataItem).CompanyID.ToString();
                    string accessAreaName = ((GetEmployees_Result) e.Item.DataItem).NameVisible.ToString();
                    RadComboBoxItem cbItem = new RadComboBoxItem(accessAreaName, accessAreaID);
                    cbItem.Selected = true;
                    cb.Items.Add(cbItem);
                    cbItem.DataBind();
                }
            }

            if (e.Item is GridEditFormItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem) && e.Item.DataItem != null)
            {
                GridEditFormItem editFormItem = (GridEditFormItem) e.Item;

                Label lbl = editFormItem.FindControl("AccessDenialReason") as Label;
                if (lbl != null)
                {
                    GetEmployees_Result employee = e.Item.DataItem as GetEmployees_Result;

                    bool accessAllowed = ((GetEmployees_Result) e.Item.DataItem).AccessAllowed;
                    if (accessAllowed)
                    {
                        lbl.Text = Resources.Resource.lblAccessAllowed;
                    }
                    else
                    {
                        if (employee.AccessDenialReason.Equals(string.Empty))
                        {
                            lbl.Text = Resources.Resource.lblNoPassAssigned;
                        }
                        else
                        {
                            lbl.Text = employee.AccessDenialReason.Replace(Environment.NewLine, "<br/>");
                        }
                    }
                }
            }

            if (e.Item is GridFilteringItem)
            {
                // Formatierung für Datumsfilter
                //GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                //if (filteringItem != null)
                //{
                //    LiteralControl literal = filteringItem["EditOn"].Controls[0] as LiteralControl;
                //    literal.Text = Resources.Resource.lblFrom + " ";

                //    literal = filteringItem["EditOn"].Controls[3] as LiteralControl;
                //    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
                //}
            }

            if (e.Item is GridCommandItem)
            {
                GridCommandItem commandItem = (e.Item as GridCommandItem);
                PlaceHolder placeHolder = commandItem.FindControl("AlphaFilter") as PlaceHolder;
                if (placeHolder != null)
                {
                    RadButton rb;

                    for (int i = 65; i <= 65 + 25; i++)
                    {
                        rb = new RadButton();

                        rb.Text = string.Empty + (char) i;
                        rb.CommandName = "AlphaFilter";
                        rb.CommandArgument = string.Empty + (char) i;
                        rb.Width = new Unit(25, UnitType.Pixel);
                        rb.BorderStyle = BorderStyle.None;
                        if (Session["AlphaFilter"] != null && Session["AlphaFilter"].ToString().Equals(string.Empty + (char) i))
                        {
                            rb.ForeColor = Color.Orange;
                            rb.Font.Bold = true;
                        }
                        else
                        {
                            rb.ForeColor = Color.Black;
                            rb.Font.Bold = false;
                        }
                        rb.ButtonType = RadButtonType.SkinnedButton;
                        rb.GroupName = "AlphaFilterGroup";
                        rb.CssClass = "AlphaButton";
                        rb.ToolTip = Resources.Resource.ttFilterByFirstLetter + " " + (char) i;

                        placeHolder.Controls.Add(rb);
                    }

                    rb = new RadButton();
                    rb.Text = Resources.Resource.lblAll;
                    rb.CommandName = "AlphaFilter";
                    rb.CommandArgument = string.Empty;
                    rb.BorderStyle = BorderStyle.None;
                    if (Session["AlphaFilter"] != null && Session["AlphaFilter"].ToString().Equals(string.Empty))
                    {
                        rb.ForeColor = Color.Orange;
                        rb.Font.Bold = true;
                    }
                    else
                    {
                        rb.ForeColor = Color.Black;
                        rb.Font.Bold = false;
                    }
                    rb.ButtonType = RadButtonType.SkinnedButton;
                    rb.GroupName = "AlphaFilterGroup";
                    rb.ToolTip = Resources.Resource.ttFilterNoFirstLetter;

                    placeHolder.Controls.Add(rb);
                }
            }

            if (e.Item is GridNestedViewItem)
            {
                e.Item.FindControl("PanelDetails").Visible = ((GridNestedViewItem) e.Item).ParentItem.Expanded;
            }
        }

        protected void RadGridDocumentRules_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.IsInEditMode)
            {
                int employeeID = Convert.ToInt32(((DataRowView) e.Item.DataItem)["EmployeeID"]);
                int relevantFor = Convert.ToInt32(((DataRowView) e.Item.DataItem)["RelevantFor"]);
                int relevantDocumentID = Convert.ToInt32(((DataRowView) e.Item.DataItem)["RelevantDocumentID"]);

                GridEditableItem item = (GridEditableItem) e.Item;
                RadComboBox cb = item.FindControl("RelevantDocumentID") as RadComboBox;
                if (cb != null)
                {
                    GetEmployeeRelevantDocumentsToAdd_Result[] result = Helpers.GetEmployeeRelevantDocumentsToAdd(employeeID, relevantFor);
                    cb.DataSource = result;
                    cb.DataBind();
                    foreach (RadComboBoxItem cbItem in cb.Items)
                    {
                        if (cbItem.Value.Equals(relevantDocumentID.ToString()))
                        {
                            cbItem.Selected = true;
                            break;
                        }
                    }
                }

                if (!(e.Item is GridEditFormInsertItem))
                {
                    RadBinaryImage bi = item.FindControl("SampleData") as RadBinaryImage;
                    if (bi != null)
                    {
                        bi.DataValue = Helpers.GetRelevantDocumentImage(relevantDocumentID, 200, 200);
                        //Add the button (target) id to the tooltip manager
                        this.RadToolTipManager2.TargetControls.Add(bi.ClientID, relevantDocumentID.ToString(), true);
                    }
                }
            }
        }

        protected DataTable GetRelevantDocument(int employeeID, int relevantFor)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT m_rd.NameVisible, m_rd.RelevantDocumentID ");
            sql.Append("FROM System_Addresses AS s_a ");
            sql.Append("INNER JOIN Master_Companies AS m_comp ");
            sql.Append("INNER JOIN Master_Employees AS m_e ");
            sql.Append("ON m_comp.SystemID = m_e.SystemID ");
            sql.Append("AND m_comp.BpID = m_e.BpID ");
            sql.Append("AND m_comp.CompanyID = m_e.CompanyID ");
            sql.Append("ON s_a.SystemID = m_comp.SystemID ");
            sql.Append("AND s_a.AddressID = m_comp.AddressID ");
            sql.Append("INNER JOIN Master_Addresses AS m_a ");
            sql.Append("ON m_e.SystemID = m_a.SystemID ");
            sql.Append("AND m_e.BpID = m_a.BpID ");
            sql.Append("AND m_e.AddressID = m_a.AddressID ");
            sql.Append("INNER JOIN Master_Countries AS m_coun ");
            sql.Append("ON m_a.SystemID = m_coun.SystemID ");
            sql.Append("AND m_a.BpID = m_coun.BpID ");
            sql.Append("AND m_a.NationalityID = m_coun.CountryID ");
            sql.Append("INNER JOIN Master_RelevantDocuments AS m_rd ");
            sql.Append("INNER JOIN Master_DocumentRules AS m_dr ");
            sql.Append("ON m_rd.SystemID = m_dr.SystemID ");
            sql.Append("AND m_rd.BpID = m_dr.BpID ");
            sql.Append("AND m_rd.RelevantDocumentID = m_dr.RelevantDocumentID ");
            sql.Append("ON m_coun.SystemID = m_dr.SystemID ");
            sql.Append("AND m_coun.BpID = m_dr.BpID ");
            sql.Append("AND m_coun.CountryGroupID = m_dr.CountryGroupIDEmployee ");
            sql.Append("AND m_e.EmploymentStatusID = m_dr.EmploymentStatusID ");
            sql.Append("INNER JOIN Master_Countries AS m_coun_1 ");
            sql.Append("ON s_a.SystemID = m_coun_1.SystemID ");
            sql.Append("AND s_a.CountryID = m_coun_1.CountryID ");
            sql.Append("AND m_comp.BpID = m_coun_1.BpID ");
            sql.Append("AND m_dr.SystemID = m_coun_1.SystemID ");
            sql.Append("AND m_dr.BpID = m_coun_1.BpID ");
            sql.Append("AND m_dr.CountryGroupIDEmployer = m_coun_1.CountryGroupID ");
            sql.Append("WHERE m_e.SystemID = @SystemID AND m_e.BpID = @BpID AND m_e.EmployeeID = @EmployeeID AND m_dr.RelevantFor = @RelevantFor ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = employeeID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@RelevantFor", SqlDbType.TinyInt);
            par.Value = relevantFor;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
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

            return dt;
        }

        protected void RadGridDocumentRules_ItemUpdated(object sender, GridUpdatedEventArgs e)
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
                if (e.AffectedRows > 0)
                {
                    Helpers.EmployeeChanged(Convert.ToInt32(Session["MyEmployeeID"]));
                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                    (sender as RadGrid).Rebind();
                    Helpers.SetAction(Actions.View);
                }
                else
                {
                    e.KeepInEditMode = true;
                }
            }
        }

        protected void AvailableAreas_Transferred(object sender, RadListBoxTransferredEventArgs e)
        {
            if (e.Items.Count > 0)
            {
                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand("MoveEmployeeAccessArea", con);
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

                par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                par.Value = Convert.ToInt32((e.SourceListBox.Parent.FindControl("EmployeeID") as Label).Text);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AccessAreaID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@User", SqlDbType.NVarChar, 50);
                par.Direction = ParameterDirection.Input;
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                foreach (RadListBoxItem item in e.Items)
                {
                    cmd.Parameters["@AccessAreaID"].Value = item.Value;

                    con.Open();
                    try
                    {
                        logger.InfoFormat("Try to execute {0}", cmd.CommandText);
                        cmd.ExecuteNonQuery();
                    }
                    catch (SqlException ex)
                    {
                        logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                        throw ex;
                    }
                    catch (System.Exception ex)
                    {
                        logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                        throw ex;
                    }
                    finally
                    {
                        con.Close();
                    }
                }
            }
        }

        public string GetAccessState(int accessState)
        {
            string ret;
            switch (accessState)
            {
                case 0:
                    {
                        ret = Resources.Resource.lblAccessStateAbsent;
                        break;
                    }
                case 1:
                    {
                        ret = Resources.Resource.lblAccessStatePresent;
                        break;
                    }
                case 2:
                    {
                        ret = Resources.Resource.lblAccessStateUndefined;
                        break;
                    }
                case 3:
                    {
                        ret = Resources.Resource.lblAccessStateNoAccess;
                        break;
                    }
                default:
                    {
                        ret = Resources.Resource.lblAccessStateUndefined;
                        break;
                    }
            }
            return ret;
        }

        public string GetAccessType(int accessType)
        {
            string ret = "";
            switch (accessType)
            {
                case 0:
                    {
                        ret = Resources.Resource.lblAccessTypeLeaving;
                        break;
                    }
                case 1:
                    {
                        ret = Resources.Resource.lblAccessTypeComing;
                        break;
                    }
                default:
                    {
                        ret = Resources.Resource.lblAccessTypeUnknown;
                        break;
                    }
            }
            return ret;
        }

        protected void UpdateImage_Click(object sender, EventArgs e)
        {
            RadGrid1.Rebind();
        }

        protected void RadTabStrip1_TabClick(object sender, RadTabStripEventArgs e)
        {
            Session["LastTab"] = e.Tab.Index;
        }

        protected void ValidatorAssignedQualifications_ServerValidate(object source, ServerValidateEventArgs args)
        {
            RadListBox lb = (RadListBox) (((GridEditFormItem) ((CustomValidator) source).NamingContainer)).FindControl("AssignedQualifications");
            if (lb != null)
            {
                if (lb.Items.Count == 0)
                {
                    args.IsValid = false;
                }
            }
        }

        protected void ValidatorAssignedAreas_ServerValidate(object source, ServerValidateEventArgs args)
        {
            RadListBox lb = (RadListBox) (((GridEditFormItem) ((CustomValidator) source).NamingContainer)).FindControl("AssignedAreas");
            if (lb != null)
            {
                if (lb.Items.Count == 0)
                {
                    args.IsValid = false;
                }
            }
        }

        protected void ValidatorRadGridMinWage2_ServerValidate(object source, ServerValidateEventArgs args)
        {
            RadGrid rg = (RadGrid) (((GridEditFormItem) ((CustomValidator) source).NamingContainer)).FindControl("RadGridMinWage2");
            if (rg != null)
            {
                if (!rg.MasterTableView.IsItemInserted && rg.MasterTableView.Items.Count == 0)
                {
                    // Wenn Beschäftigungsverhältnis nicht mindestlohnpflichtig, dann ist Lohngruppenzuordnung keine Pflicht
                    RadComboBox cb = (RadComboBox)(((GridEditFormItem)((CustomValidator)source).NamingContainer)).FindControl("EmploymentStatusID");
                    if (cb != null && cb.SelectedValue != "")
                    {
                        int employmentStatusID = Convert.ToInt32(cb.SelectedValue);
                        if (!Helpers.EmploymentStatusMWObligate(employmentStatusID))
                        {
                            args.IsValid = true;
                        }
                        else
                        {
                            args.IsValid = false;
                        }
                    }
                    else
                    {
                        args.IsValid = false;
                    }
                }
            }
        }

        protected void RadGridMinWage2_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGridMinWage2_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblEmplMinWage2);

            if (e.CommandName.Equals("Delete"))
            {
                e.Canceled = true;
            }

            if (e.CommandName.Equals("Cancel") || e.CommandName == "Update" || e.CommandName == "PerformInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
                if (!e.CommandName.Equals("Cancel"))
                {
                    // RadGrid1.Rebind();
                }
            }

            if (e.CommandName == "Edit" || e.CommandName == "Update")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveTariffs") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = false;
                RadTabStrip ts = (sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip;
                if (ts != null)
                {
                    Session["LastTab"] = ts.SelectedTab.Index;
                    ts.Enabled = false;
                }
            }
        }

        protected void RadGridDocumentRules_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblDocumentRules);

            if (e.CommandName.Equals("Delete"))
            {
                e.Canceled = true;
            }

            if (e.CommandName.Equals("Cancel") || e.CommandName == "Update" || e.CommandName == "PerformInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveDocumentRules") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateDocumentRules") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelDocumentRules") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
                e.Item.Edit = false;
                if (!e.CommandName.Equals("Cancel"))
                {
                    // RadGrid1.Rebind();
                }
            }

            if (e.CommandName == "Edit" || e.CommandName == "InitInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveDocumentRules") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateDocumentRules") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelDocumentRules") as RadButton).Enabled = false;
                RadTabStrip ts = (sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip;
                if (ts != null)
                {
                    Session["LastTab"] = ts.SelectedTab.Index;
                    ts.Enabled = false;
                }
            }
        }

        protected void RadGridDocumentRules_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void AssignedAreas_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblAssignedAreas);

            if (e.CommandName.Equals("Delete"))
            {
                // Zutrittsrelevantes Ereignis 
                // e.Canceled = true;
            }

            if (e.CommandName.Equals("Cancel") || e.CommandName == "PerformInsert" || e.CommandName == "Update")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveAssignedAreas") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAssignedAreas") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelAssignedAreas") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
                if (!e.CommandName.Equals("Cancel"))
                {
                    // RadGrid1.Rebind();
                }
            }

            if (e.CommandName == "Edit" || e.CommandName == "InitInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveAssignedAreas") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAssignedAreas") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelAssignedAreas") as RadButton).Enabled = false;
                RadTabStrip ts = (sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip;
                if (ts != null)
                {
                    Session["LastTab"] = ts.SelectedTab.Index;
                    ts.Enabled = false;
                }
            }
        }

        protected void AssignedAreas_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                (sender as RadGrid).MasterTableView.Rebind();
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        protected void AssignedAreas_ItemInserted(object sender, GridInsertedEventArgs e)
        {
            // Insert-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, e.Exception.Message), "red");
            }
            else
            {
                if (e.AffectedRows > 0)
                {
                    Helpers.EmployeeChanged(Convert.ToInt32(Session["MyEmployeeID"]));
                    SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                }
                else
                {
                    e.KeepInInsertMode = true;
                }
            }
        }

        protected void AssignedAreas_ItemUpdated(object sender, GridUpdatedEventArgs e)
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
                if (e.AffectedRows > 0)
                {
                    (sender as RadGrid).MasterTableView.Rebind();
                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                    Helpers.EmployeeChanged(Convert.ToInt32(Session["MyEmployeeID"]));
                }
                else
                {
                    e.KeepInEditMode = true;
                }
            }
        }

        protected void AssignedAreas_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditFormItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem) && e.Item.DataItem != null)
            {
                GridEditableItem item = (GridEditableItem) e.Item;
                RadComboBox cb = item.FindControl("AccessAreaID") as RadComboBox;

                if (cb != null)
                {
                    cb.Items.Clear();
                    string accessAreaID = ((DataRowView) e.Item.DataItem)["AccessAreaID"].ToString();
                    string accessAreaName = ((DataRowView) e.Item.DataItem)["AccessAreaName"].ToString();
                    RadComboBoxItem cbItem = new RadComboBoxItem(accessAreaName, accessAreaID);
                    cbItem.Selected = true;
                    cb.Items.Add(cbItem);
                    cbItem.DataBind();
                }
            }
        }

        protected void RadToolTipManager1_AjaxUpdate(object sender, ToolTipUpdateEventArgs e)
        {
            this.UpdateToolTip(e.Value, e.UpdatePanel);
        }

        private void UpdateToolTip(string elementID, UpdatePanel panel)
        {
            Control ctrl = Page.LoadControl("/InSiteApp/Controls/ImagePopUp.ascx");
            ctrl.ID = "ImagePopUp1";
            panel.ContentTemplateContainer.Controls.Add(ctrl);
            ImagePopUp details = (ImagePopUp) ctrl;
            details.EmployeeID = elementID;
        }

        protected void RadGridDocumentRules_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            if (Page.IsValid)
            {
                GridEditFormItem item = e.Item as GridEditFormItem;

                StringBuilder sql = new StringBuilder();
                sql.Append("UPDATE Master_EmployeeRelevantDocuments SET RelevantDocumentID = @RelevantDocumentID, DocumentReceived = @DocumentReceived, ExpirationDate = @ExpirationDate, ");
                sql.Append("IDNumber = @IDNumber, EditFrom = @UserName, EditOn = SYSDATETIME() ");
                sql.Append("WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @EmployeeID AND RelevantFor = @RelevantFor ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["BpID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("EmployeeID") as HiddenField).Value);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@RelevantFor", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("RelevantFor") as HiddenField).Value);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@RelevantDocumentID", SqlDbType.Int);
                par.Value = Convert.ToInt32((item.FindControl("RelevantDocumentID") as RadComboBox).SelectedValue);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@DocumentReceived", SqlDbType.Bit);
                par.Value = (item.FindControl("DocumentReceived") as CheckBox).Checked;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ExpirationDate", SqlDbType.DateTime);
                if ((item.FindControl("ExpirationDate") as RadDatePicker).SelectedDate != null)
                {
                    par.Value = (item.FindControl("ExpirationDate") as RadDatePicker).SelectedDate;
                }
                else
                {
                    par.Value = DBNull.Value;
                }
                cmd.Parameters.Add(par);

                par = new SqlParameter("@IDNumber", SqlDbType.NVarChar, 50);
                par.Value = (item.FindControl("IDNumber") as RadTextBox).Text;
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

                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                    Helpers.EmployeeChanged(Convert.ToInt32(Session["MyEmployeeID"]));
                    (sender as RadGrid).Rebind();
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
        }

        protected void RelevantDocumentID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            GetRelevantDocuments_Result[] arr = Helpers.GetRelevantDocuments(Convert.ToInt32(e.Value));
            if (arr.Count() > 0 )
            {
                GetRelevantDocuments_Result result = arr[0];

                CheckBox cb = (sender as RadComboBox).Parent.FindControl("IsAccessRelevant") as CheckBox;
                if (cb != null)
                {
                    cb.Checked = result.IsAccessRelevant;
                }

                RadBinaryImage bi = (sender as RadComboBox).Parent.FindControl("SampleData") as RadBinaryImage;
                if (bi != null && result.SampleData != null)
                {
                    System.Drawing.Image image = Helpers.ByteArrayToImage(result.SampleData);
                    image = Helpers.ScaleImage(image, 200, 200);
                    string extension = Path.GetExtension(result.SampleFileName);
                    bi.DataValue = Helpers.ImageToByteArray(image, Helpers.ParseImageFormat(extension));
                }

                HyperLink hl = (sender as RadComboBox).Parent.FindControl("SampleDataLink") as HyperLink;
                if (hl != null)
                {
                    hl.NavigateUrl = bi.ImageUrl;
                }

                Label lbl = (sender as RadComboBox).Parent.FindControl("LabelExpirationDate") as Label;
                if (lbl != null)
                {
                    lbl.Font.Bold = result.RecExpirationDate;
                }

                RadDatePicker dp = (sender as RadComboBox).Parent.FindControl("ExpirationDate") as RadDatePicker;
                if (dp != null)
                {
                    if (result.ToolTipExpiration != null && !(result.ToolTipExpiration.Equals(string.Empty)))
                    {
                        dp.ToolTip = result.ToolTipExpiration;
                    }
                    else
                    {
                        dp.ToolTip = Resources.Resource.lblExpirationDate + " " + Resources.Resource.lblRequired;
                    }
                }

                RequiredFieldValidator fv = (sender as RadComboBox).Parent.FindControl("ValidatorExpirationDate") as RequiredFieldValidator;
                if (fv != null)
                {
                    fv.Enabled = result.RecExpirationDate;
                }

                lbl = (sender as RadComboBox).Parent.FindControl("LabelIDNumber") as Label;
                if (lbl != null)
                {
                    lbl.Font.Bold = result.RecIDNumber;
                }

                RadTextBox tb = (sender as RadComboBox).Parent.FindControl("ValidatorIDNumber") as RadTextBox;
                if (tb != null)
                {
                    if (result.ToolTipDocumentID != null && !(result.ToolTipDocumentID.Equals(string.Empty)))
                    {
                        tb.ToolTip = result.ToolTipDocumentID;
                    }
                    else
                    {
                        tb.ToolTip = Resources.Resource.lblDocumentID + " " + Resources.Resource.lblRequired;
                    }
                }

                fv = (sender as RadComboBox).Parent.FindControl("ValidatorIDNumber") as RequiredFieldValidator;
                if (fv != null)
                {
                    fv.Enabled = result.RecIDNumber;
                }
            }
        }

        protected void RadGridDocumentRules_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            Webservices webservice = new Webservices();
            GetEmployeeRelevantDocuments_Result[] result = webservice.GetEmployeeRelevantDocuments(Convert.ToInt32(Session["MyEmployeeID"]));
            (sender as RadGrid).DataSource = result;
        }

        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO History_Employees SELECT * FROM Master_Employees ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @EmployeeID; ");
            sql.Append("INSERT INTO History_Addresses SELECT * FROM Master_Addresses ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND AddressID = @AddressID; ");
            sql.Append("DELETE FROM Master_Addresses ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND AddressID = @AddressID; ");
            sql.Append("DELETE FROM Data_ProcessEvents ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND DialogID = 25 AND RefID = @EmployeeID; ");
            sql.Append("DELETE FROM Master_Employees ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @EmployeeID; ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item as GridDataItem).GetDataKeyValue("EmployeeID"));
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AddressID", SqlDbType.Int);
            par.Value = Convert.ToInt32(((e.Item as GridDataItem).FindControl("AddressID") as Label).Text);
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue("EmployeeID").ToString(), Resources.Resource.lblActionDelete);
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

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        protected void EmploymentStatusID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Label lb = (sender as RadComboBox).Parent.FindControl("EmployeeID") as Label;
            int employeeID = Convert.ToInt32(lb.Text);
            lb = (sender as RadComboBox).Parent.FindControl("AppliedRule") as Label;
            lb.Text = Helpers.GetAppliedRuleString(employeeID);
        }

        protected void NationalityID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            Label lb = (sender as RadComboBox).Parent.FindControl("EmployeeID") as Label;
            int employeeID = Convert.ToInt32(lb.Text);
            lb = (sender as RadComboBox).Parent.FindControl("AppliedRule") as Label;
            lb.Text = Helpers.GetAppliedRuleString(employeeID);
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
        }

        protected void CompanyID_EntryAdded(object sender, DropDownTreeEntryEventArgs e)
        {
            RadComboBox cb = (sender as RadDropDownTree).Parent.FindControl("TradeID") as RadComboBox;
            if (cb != null)
            {
                cb.Text = "";
                cb.Items.Clear();
                cb.DataSource = LoadTrades(e.Entry.Value);
                cb.DataBind();
            }
        }

        protected void RadGridMinWage4_ItemCreated(object sender, GridItemEventArgs e)
        {
            Helpers.ChangeDefaultEditButtons(e);
        }

        protected void RadGridMinWage4_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblEmplMinWage4);

            if (e.CommandName.Equals("Cancel") || e.CommandName == "Update")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
                if (!e.CommandName.Equals("Cancel"))
                {
                    // RadGrid1.Rebind();
                }
            }

            if (e.CommandName == "Edit")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveTariffs") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateTariffs") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelTariffs") as RadButton).Enabled = false;
                RadTabStrip ts = (sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip;
                if (ts != null)
                {
                    Session["LastTab"] = ts.SelectedTab.Index;
                    ts.Enabled = false;
                }
            }
        }

        protected void RadGridMinWage4_ItemUpdated(object sender, GridUpdatedEventArgs e)
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
                if (e.AffectedRows > 0)
                {
                    // Prüfung wegen Überziehung der Vorlagefrist für Mindestlohnbescheinigungen
                    Helpers.EmployeeChanged(Convert.ToInt32(Session["MyEmployeeID"]));

                    (sender as RadGrid).MasterTableView.Rebind();
                    SetMessage(Resources.Resource.lblActionUpdate, Resources.Resource.msgUpdateOK, "green");
                }
                else
                {
                    e.KeepInEditMode = true;
                }
            }
        }

        protected void Amount_TextChanged(object sender, EventArgs e)
        {
            GridEditFormItem item = (sender as RadTextBox).NamingContainer as GridEditFormItem;
            if (item != null)
            {
                HiddenField wageC = item.FindControl("Wage_C") as HiddenField;
                HiddenField wageE = item.FindControl("Wage_E") as HiddenField;
                RadComboBox statusCode = item.FindControl("StatusCode") as RadComboBox;
                if (wageC != null && wageE != null && statusCode != null)
                {
                    decimal amountValue = Convert.ToDecimal((sender as RadTextBox).Text);
                    decimal wageCValue = Convert.ToDecimal(wageC.Value);
                    decimal wageEValue = Convert.ToDecimal(wageE.Value);

                    if (amountValue >= wageCValue && amountValue >= wageEValue)
                    {
                        statusCode.SelectedValue = "2";
                    }
                    else if (amountValue >= wageCValue && amountValue >= wageEValue)
                    {
                        statusCode.SelectedValue = "4";
                    }
                    else if (amountValue < wageCValue)
                    {
                        statusCode.SelectedValue = "5";
                    }
                }
            }
        }

        protected void ValidFrom_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            DateTime validFrom = (DateTime) e.NewDate;
            int companyID = 0;

            RadDropDownTree hf;
            GridTableView gtv = (sender as RadDatePicker).NamingContainer.NamingContainer.NamingContainer as GridTableView;
            if (gtv.IsItemInserted)
            {
                hf = (sender as RadDatePicker).NamingContainer.NamingContainer.NamingContainer.NamingContainer.NamingContainer.FindControl("CompanyID") as RadDropDownTree;
            }
            else
            {
                hf = (sender as RadDatePicker).NamingContainer.NamingContainer.NamingContainer.NamingContainer.FindControl("CompanyID") as RadDropDownTree;
            }

            if (hf != null && hf.SelectedValue != null && !hf.SelectedValue.Equals(string.Empty))
            {
                companyID = Convert.ToInt32(hf.SelectedValue);
            }

            RadComboBox tariffWageGroupID = (sender as RadDatePicker).Parent.Parent.Parent.FindControl("TariffWageGroupID") as RadComboBox;
            if (tariffWageGroupID != null)
            {

                tariffWageGroupID.Items.Clear();
                tariffWageGroupID.DataSource = GetTariffWageGroupData(companyID, validFrom);
                tariffWageGroupID.DataBind();
            }
        }

        private DataTable GetTariffWageGroupData(int companyID, DateTime validFrom)
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("GetEmployeeWageGroups", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = companyID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@ValidFrom", SqlDbType.DateTime);
            par.Value = validFrom;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            catch (System.Exception ex)
            {
                logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            finally
            {
                con.Close();
            }
            return dt;
        }

        protected void RadGrid1_PageIndexChanged(object sender, GridPageChangedEventArgs e)
        {
            this.RadToolTipManager1.TargetControls.Clear();
        }

        protected void RadGrid1_PageSizeChanged(object sender, GridPageSizeChangedEventArgs e)
        {
            this.RadToolTipManager1.TargetControls.Clear();
        }

        protected void AccessOn_SelectedDateChanged(object sender, Telerik.Web.UI.Calendar.SelectedDateChangedEventArgs e)
        {
            GridEditableItem item = (sender as RadDateTimePicker).NamingContainer as GridEditableItem;
            GridEditableItem itemEmployee = null;
            if (item != null)
            {
                if (item is GridEditFormInsertItem)
                {
                    itemEmployee = item.NamingContainer.NamingContainer.NamingContainer.NamingContainer as GridEditableItem;
                }
                else
                {
                    itemEmployee = item.NamingContainer.NamingContainer.NamingContainer as GridEditableItem;
                }
                int employeeID = Convert.ToInt32((itemEmployee.FindControl("EmployeeID") as Label).Text);
                RadButton rb = item.FindControl("Access") as RadButton;
                bool coming = true;
                if (rb != null)
                {
                    coming = rb.Checked;
                }
                DateTime accessTime = DateTime.Now;
                if (e.NewDate != null)
                {
                    accessTime = (DateTime) e.NewDate;
                }
                RadComboBox rc = item.FindControl("AccessAreaID") as RadComboBox;
                if (rc != null)
                {
                    string accessAreaID = rc.SelectedValue;
                    rc.Items.Clear();
                    rc.DataSource = GetValidAccessAreas(employeeID, accessTime, coming);
                    rc.DataBind();
                    if (!(item is GridEditFormInsertItem))
                    {
                        rc.SelectedValue = accessAreaID;
                    }
                }
            }
        }

        protected void Access_ToggleStateChanged(object sender, ButtonToggleStateChangedEventArgs e)
        {
            GridEditFormItem item = (sender as RadButton).NamingContainer as GridEditFormItem;
            if (item != null)
            {
                GridEditFormItem itemEmployee = item.NamingContainer.NamingContainer.NamingContainer.NamingContainer as GridEditFormItem;
                int employeeID = Convert.ToInt32((itemEmployee.FindControl("EmployeeID") as Label).Text);
                RadButton rb = sender as RadButton;
                bool coming = true;
                if (rb != null)
                {
                    coming = rb.Checked;
                }
                RadDateTimePicker rdtp = item.FindControl("AccessOn") as RadDateTimePicker;
                DateTime accessTime = DateTime.Now;
                if (rdtp != null)
                {
                    accessTime = (DateTime) rdtp.SelectedDate;
                }
                RadComboBox rc = item.FindControl("AccessAreaID") as RadComboBox;
                if (rc != null)
                {
                    rc.Items.Clear();
                    rc.DataSource = GetValidAccessAreas(employeeID, accessTime, coming);
                    rc.DataBind();
                }
            }
        }

        protected void Exit_ToggleStateChanged(object sender, ButtonToggleStateChangedEventArgs e)
        {
            GridEditFormItem item = (sender as RadButton).NamingContainer as GridEditFormItem;
            if (item != null)
            {
                GridEditFormItem itemEmployee = item.NamingContainer.NamingContainer.NamingContainer.NamingContainer as GridEditFormItem;
                int employeeID = Convert.ToInt32((itemEmployee.FindControl("EmployeeID") as Label).Text);
                RadButton rb = sender as RadButton;
                bool coming = true;
                if (rb != null)
                {
                    coming = !rb.Checked;
                }
                RadDateTimePicker rdtp = item.FindControl("AccessOn") as RadDateTimePicker;
                DateTime accessTime = DateTime.Now;
                if (rdtp != null)
                {
                    accessTime = (DateTime) rdtp.SelectedDate;
                }
                RadComboBox rc = item.FindControl("AccessAreaID") as RadComboBox;
                if (rc != null)
                {
                    rc.Items.Clear();
                    rc.DataSource = GetValidAccessAreas(employeeID, accessTime, coming);
                    rc.DataBind();
                }
            }
        }

        private DataTable GetValidAccessAreas(int employeeID, DateTime accessTime, bool coming)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT DISTINCT m_aa.SystemID, m_aa.BpID, m_aa.AccessAreaID, m_aa.NameVisible, m_aa.DescriptionShort, m_aa.AccessTimeRelevant, m_aa.CheckInCompelling, ");
            sql.Append("m_aa.UniqueAccess, m_aa.CheckOutCompelling, m_aa.CompleteAccessTimes, m_aa.PresentTimeHours, m_aa.PresentTimeMinutes, m_aa.CreatedFrom, m_aa.CreatedOn, ");
            sql.Append("m_aa.EditFrom, m_aa.EditOn ");
            sql.Append("FROM Master_AccessAreas AS m_aa ");
            sql.Append("INNER JOIN Master_EmployeeAccessAreas AS m_eaa ");
            sql.Append("ON m_aa.SystemID = m_eaa.SystemID AND m_aa.BpID = m_eaa.BpID AND m_aa.AccessAreaID = m_eaa.AccessAreaID ");
            sql.Append("INNER JOIN Master_TimeSlots AS m_ts ");
            sql.Append("ON m_eaa.SystemID = m_ts.SystemID AND m_eaa.BpID = m_ts.BpID AND m_eaa.TimeSlotGroupID = m_ts.TimeSlotGroupID ");
            sql.Append("WHERE m_aa.SystemID = @SystemID ");
            sql.Append("AND m_aa.BpID = @BpID ");
            sql.Append("AND m_eaa.EmployeeID = @EmployeeID ");
            if (coming)
            {
                sql.Append("AND DATETIMEFROMPARTS(YEAR(m_ts.ValidFrom), MONTH(m_ts.ValidFrom), DAY(m_ts.ValidFrom), ");
                sql.Append("DATEPART(hh, m_ts.TimeFrom), DATEPART(n, m_ts.TimeFrom), DATEPART(s, m_ts.TimeFrom), 0) <= @AccessTime ");
                sql.Append("AND DATETIMEFROMPARTS(YEAR(m_ts.ValidUntil), MONTH(m_ts.ValidUntil), DAY(m_ts.ValidUntil), ");
                sql.Append("DATEPART(hh, m_ts.TimeUntil), DATEPART(n, m_ts.TimeUntil), DATEPART(s, m_ts.TimeUntil), 0) >= @AccessTime ");
            }

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = employeeID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessTime", SqlDbType.DateTime);
            par.Value = accessTime;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            catch (System.Exception ex)
            {
                logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            finally
            {
                con.Close();
            }

            return dt;
        }

        protected void RadGridEmplAccess2_ItemDataBound(object sender, GridItemEventArgs e)
        {
            GridDataItem item = e.Item as GridDataItem;

            if (e.Item is GridEditableItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem))
            {
                DataRowView dataRow = e.Item.DataItem as DataRowView;
                if (dataRow != null)
                {
                    DateTime timestamp = Convert.ToDateTime(dataRow["Timestamp"]);
                    bool coming = (Convert.ToInt32(dataRow["AccessTypeID"]) == 1 ? true : false);
                    int accessAreaID = Convert.ToInt32(dataRow["AccessAreaID"]);
                    int employeeID = Convert.ToInt32(dataRow["EmployeeID"]);

                    GridEditableItem editItem = e.Item as GridEditableItem;
                    if (editItem != null)
                    {
                        RadDateTimePicker dtp = editItem.FindControl("AccessOn") as RadDateTimePicker;
                        if (dtp != null)
                        {
                            dtp.SelectedDate = timestamp;
                        }

                        RadButton btn = editItem.FindControl("Access") as RadButton;
                        if (btn != null)
                        {
                            btn.Checked = coming;
                        }
                        btn = editItem.FindControl("Exit") as RadButton;
                        if (btn != null)
                        {
                            btn.Checked = !coming;
                        }

                        RadComboBox cb = editItem.FindControl("AccessAreaID") as RadComboBox;
                        if (cb != null)
                        {
                            cb.Items.Clear();
                            cb.DataSource = GetValidAccessAreas(employeeID, timestamp, coming);
                            cb.DataBind();
                            cb.SelectedValue = accessAreaID.ToString();
                        }

                        RadTextBox tb = editItem.FindControl("Remark") as RadTextBox;
                        if (tb != null)
                        {
                            tb.Text = dataRow["Remark"].ToString();
                        }
                    }
                }
            }

            if (e.Item is GridDataItem)
            {
                DateTime lastCompressedDate = DateTime.MinValue;
                if (Session["LastCompress"] != null)
                {
                    lastCompressedDate = Convert.ToDateTime(Convert.ToDateTime(Session["LastCompress"]).Date).AddSeconds(-1);
                }

                DateTime accessOn = Convert.ToDateTime((item.DataItem as DataRowView)["Timestamp"]);

                bool isManualEntry = Convert.ToBoolean((item.DataItem as DataRowView)["IsManualEntry"]);
                if (isManualEntry && accessOn > lastCompressedDate)
                {
                    (item["EditCommandColumn5"].Controls[0] as ImageButton).Enabled = true;
                    (item["EditCommandColumn5"].Controls[0] as ImageButton).Visible = true;

                    (item["deleteColumn4"].Controls[0] as ImageButton).Enabled = true;
                    (item["deleteColumn4"].Controls[0] as ImageButton).Visible = true;
                }
                else
                {
                    (item["EditCommandColumn5"].Controls[0] as ImageButton).Enabled = false;
                    (item["EditCommandColumn5"].Controls[0] as ImageButton).Visible = false;

                    (item["deleteColumn4"].Controls[0] as ImageButton).Enabled = false;
                    (item["deleteColumn4"].Controls[0] as ImageButton).Visible = false;
                }
            }
        }

        protected void RadGridEmplAccess2_InsertCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;

            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO Data_AccessEvents(SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, ");
            sql.Append("AccessType, AccessResult, MessageShown, DenialReason, Remark, CreatedOn, CreatedFrom, IsManualEntry, EditOn, EditFrom, PassType, CountIt) ");
            sql.Append("SELECT SystemID, 0, BpID, @AccessAreaID, 0, 0, EmployeeID, InternalID, 0, @AccessOn, @AccessType, 1, 1, 0, @Remark, SYSDATETIME(), ");
            sql.Append("@UserName, 1, SYSDATETIME(), @UserName, 1, 1 ");
            sql.Append("FROM Master_Passes ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND EmployeeID = @EmployeeID ");
            sql.Append("AND ActivatedOn IS NOT NULL ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = Convert.ToInt32((item.NamingContainer.NamingContainer.NamingContainer.NamingContainer.FindControl("EmployeeID") as Label).Text);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessAreaID", SqlDbType.Int);
            if (!(item.FindControl("AccessAreaID") as RadComboBox).SelectedValue.Equals(string.Empty))
            {
                par.Value = Convert.ToInt32((item.FindControl("AccessAreaID") as RadComboBox).SelectedValue);
            }
            else
            {
                par.Value = 0;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessOn", SqlDbType.DateTime);
            if ((item.FindControl("AccessOn") as RadDateTimePicker).SelectedDate != null)
            {
                par.Value = (DateTime) (item.FindControl("AccessOn") as RadDateTimePicker).SelectedDate;
            }
            else
            {
                par.Value = DateTime.Now;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessType", SqlDbType.Int);
            par.Value = ((item.FindControl("Access") as RadButton).Checked) ? 1 : 0;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@Remark", SqlDbType.NVarChar, 200);
            par.Value = (item.FindControl("Remark") as RadTextBox).Text;
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
                int res= cmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            catch (System.Exception ex)
            {
                logger.ErrorFormat("Runtime Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadGridEmplAccess2_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormItem item = e.Item as GridEditFormItem;

            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE Data_AccessEvents SET AccessAreaID = @AccessAreaID, IsOnlineAccessEvent = 0, AccessOn = @AccessOn, AccessType = @AccessType, ");
            sql.Append("AccessResult = 1, IsManualEntry = 1, Remark = @Remark, EditOn = SYSDATETIME(), EditFrom = @UserName ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND AccessEventID = @AccessEventID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessEventID", SqlDbType.Int);
            par.Value = Convert.ToInt32(item.GetDataKeyValue("AccessEventID"));
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessAreaID", SqlDbType.Int);
            if (!(item.FindControl("AccessAreaID") as RadComboBox).SelectedValue.Equals(string.Empty))
            {
                par.Value = Convert.ToInt32((item.FindControl("AccessAreaID") as RadComboBox).SelectedValue);
            }
            else
            {
                par.Value = 0;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessOn", SqlDbType.DateTime);
            if ((item.FindControl("AccessOn") as RadDateTimePicker).SelectedDate != null)
            {
                par.Value = (DateTime) (item.FindControl("AccessOn") as RadDateTimePicker).SelectedDate;
            }
            else
            {
                par.Value = DateTime.Now;
            }
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessType", SqlDbType.Int);
            par.Value = ((item.FindControl("Access") as RadButton).Checked) ? 1 : 0;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@Remark", SqlDbType.NVarChar, 200);
            par.Value = (item.FindControl("Remark") as RadTextBox).Text;
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
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            catch (System.Exception ex)
            {
                logger.ErrorFormat("Runtime Error: {0} - SessionID: {1}", ex.Message, this.Session.SessionID);
                throw ex;
            }
            finally
            {
                con.Close();
            }
        }

        protected void RadGridEmplAccess2_ItemCommand(object sender, GridCommandEventArgs e)
        {
            Helpers.ChangeEditFormCaption(e, Resources.Resource.lblEmplAccess2);

            GridDataItem item = e.Item as GridDataItem;

            // Only one active edit form 
            RadGrid grid = (sender as RadGrid);
            if (e.CommandName == RadGrid.InitInsertCommandName)
            {
                grid.MasterTableView.ClearEditItems();
            }
            if (e.CommandName == RadGrid.EditCommandName)
            {
                e.Item.OwnerTableView.IsItemInserted = false;
            }

            if (e.CommandName == "Sort" || e.CommandName == "Page" || e.CommandName == "Filter")
            {
                RadToolTipManager1.TargetControls.Clear();
                RadToolTipManager2.TargetControls.Clear();
            }

            if (e.CommandName == "RowClick")
            {
                // RowClick abhandeln
                item = e.Item.OwnerTableView.Items[e.CommandArgument as string];
                item.Expanded = !item.Expanded;
            }

            if (e.CommandName.Equals("Cancel") || e.CommandName == "Update" || e.CommandName.Equals("PerformInsert"))
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveAssignedAreas") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAssignedAreas") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("btnCancelAssignedAreas") as RadButton).Enabled = true;
                ((sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip).Enabled = true;
                if (!e.CommandName.Equals("Cancel"))
                {
                    // RadGrid1.Rebind();
                }
            }

            if (e.CommandName == "Edit" || e.CommandName == "InitInsert")
            {
                ((sender as RadGrid).Parent.FindControl("btnSaveAssignedAreas") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnUpdateAssignedAreas") as RadButton).Enabled = false;
                ((sender as RadGrid).Parent.FindControl("btnCancelAssignedAreas") as RadButton).Enabled = false;
                RadTabStrip ts = (sender as RadGrid).Parent.FindControl("RadTabStrip1") as RadTabStrip;
                if (ts != null)
                {
                    Session["LastTab"] = ts.SelectedTab.Index;
                    ts.Enabled = false;
                }
            }
        }

        protected void RadToolTipManager2_AjaxUpdate(object sender, ToolTipUpdateEventArgs e)
        {
            this.UpdateToolTip2(e.Value, e.UpdatePanel);
        }

        private void UpdateToolTip2(string elementID, UpdatePanel panel)
        {
            Control ctrl = Page.LoadControl("/InSiteApp/Controls/RelevantDocumentPopUp.ascx");
            ctrl.ID = "RelevantDocumentPopUp1";
            panel.ContentTemplateContainer.Controls.Add(ctrl);
            RelevantDocumentPopUp details = (RelevantDocumentPopUp) ctrl;
            details.RelevantDocumentID = Convert.ToInt32(elementID);
        }

        protected void RadGridEmplAccess2_ItemCreated(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridFilteringItem)
            {
                GridFilteringItem filteringItem = e.Item as GridFilteringItem;
                if (filteringItem != null)
                {
                    LiteralControl literal = filteringItem["Timestamp"].Controls[0] as LiteralControl;
                    literal.Text = Resources.Resource.lblFrom + " ";

                    literal = filteringItem["Timestamp"].Controls[3] as LiteralControl;
                    literal.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
                }
            }
        }

        protected void RadGridEmplAccess2_ItemDeleted(object sender, GridDeletedEventArgs e)
        {
            // Delete-Message
            if (e.Exception != null)
            {
                e.ExceptionHandled = true;
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, e.Exception.Message), "red");
            }
            else
            {
                Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue("AccessEventID").ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
            }
        }

        protected void RadGridEmplAccess2_PreRender(object sender, EventArgs e)
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
        }

        protected void RadGridMinWage2_InsertCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormInsertItem item = e.Item as GridEditFormInsertItem;

            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO Master_EmployeeWageGroupAssignment(SystemID, BpID, EmployeeID, TariffWageGroupID, ValidFrom, CreatedFrom, CreatedOn, EditFrom, EditOn) ");
            sql.Append("VALUES (@SystemID, @BpID, @EmployeeID, @TariffWageGroupID, @ValidFrom, @UserName, SYSDATETIME(), @UserName, SYSDATETIME())");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = Convert.ToInt32((item.NamingContainer.NamingContainer.NamingContainer.NamingContainer.FindControl("EmployeeID") as Label).Text);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@TariffWageGroupID", SqlDbType.Int);
            par.Value = Convert.ToInt32((item.FindControl("TariffWageGroupID") as RadComboBox).SelectedValue);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@ValidFrom", SqlDbType.DateTime);
            par.Value = (item.FindControl("ValidFrom") as RadDatePicker).SelectedDate;
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

                (sender as RadGrid).MasterTableView.ClearEditItems();
                (sender as RadGrid).Rebind();

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

        protected void RadGridMinWage2_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            GridEditFormItem item = e.Item as GridEditFormItem;

            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE Master_EmployeeWageGroupAssignment ");
            sql.Append("SET TariffWageGroupID = @TariffWageGroupID, ValidFrom = @ValidFrom, EditFrom = @UserName, EditOn = SYSDATETIME() ");
            sql.Append("WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @EmployeeID AND TariffWageGroupID = @TariffWageGroupIDPrevious");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = Convert.ToInt32((item.NamingContainer.NamingContainer.NamingContainer.FindControl("EmployeeID") as Label).Text);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@TariffWageGroupID", SqlDbType.Int);
            par.Value = Convert.ToInt32((item.FindControl("TariffWageGroupID") as RadComboBox).SelectedValue);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@TariffWageGroupIDPrevious", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["TariffWageGroupIDPrevious"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@ValidFrom", SqlDbType.DateTime);
            par.Value = (item.FindControl("ValidFrom") as RadDatePicker).SelectedDate;
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
                (sender as RadGrid).MasterTableView.IsItemInserted = false;
                (sender as RadGrid).Rebind();

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

        protected void RadGridMinWage2_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridEditableItem && e.Item.IsInEditMode && !(e.Item is GridEditFormInsertItem))
            {
                Session["TariffWageGroupIDPrevious"] = (e.Item.DataItem as DataRowView)["TariffWageGroupID"];
                GridEditableItem item = e.Item as GridEditableItem;
                if (item != null)
                {
                    RadComboBox cb = item.FindControl("TariffWageGroupID") as RadComboBox;
                    if (cb != null)
                    {
                        HiddenField hf = item.NamingContainer.NamingContainer.NamingContainer.FindControl("CompanyID1") as HiddenField;
                        int companyID = 0;
                        if (hf != null)
                        {
                            companyID = Convert.ToInt32(hf.Value);
                        }

                        DateTime validFrom = DateTime.Now;
                        RadDatePicker rdp = item.FindControl("ValidFrom") as RadDatePicker;
                        if (rdp != null)
                        {
                            validFrom = (DateTime) rdp.SelectedDate;
                        }

                        cb.Items.Clear();
                        cb.DataSource = GetTariffWageGroupData(companyID, validFrom);
                        cb.DataBind();
                        cb.SelectedValue = Session["TariffWageGroupIDPrevious"].ToString();
                    }
                }
            }
        }

        protected void RadGridMinWage2_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGrid radGridMinWage2 = (sender as RadGrid);
            string employeeID = string.Empty;
            if (Session["MyEmployeeID"] != null)
            {
                employeeID = Session["MyEmployeeID"].ToString();
            }

            if (employeeID != null && !employeeID.Equals(string.Empty))
            {

                StringBuilder sql = new StringBuilder();
                sql.Append("SELECT m_ewga.SystemID, m_ewga.BpID, m_ewga.EmployeeID, m_ewga.TariffWageGroupID, s_twg.NameVisible, m_ewga.ValidFrom, m_ewga.CreatedFrom, ");
                sql.Append("m_ewga.CreatedOn, m_ewga.EditFrom, m_ewga.EditOn, System_TariffWages.NameVisible AS WageName, System_TariffWages.Wage ");
                sql.Append("FROM Master_EmployeeWageGroupAssignment AS m_ewga ");
                sql.Append("INNER JOIN System_TariffWageGroups AS s_twg ON m_ewga.SystemID = s_twg.SystemID AND m_ewga.TariffWageGroupID = s_twg.TariffWageGroupID ");
                sql.Append("INNER JOIN System_TariffWages ON s_twg.TariffID = System_TariffWages.TariffID AND s_twg.TariffContractID = System_TariffWages.TariffContractID ");
                sql.Append("AND s_twg.TariffScopeID = System_TariffWages.TariffScopeID AND s_twg.TariffWageGroupID = System_TariffWages.TariffWageGroupID ");
                sql.Append("AND s_twg.SystemID = System_TariffWages.SystemID ");
                sql.Append("WHERE (m_ewga.SystemID = @SystemID) AND (m_ewga.BpID = @BpID) AND (m_ewga.EmployeeID = @EmployeeID) ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlDataAdapter adapter = new SqlDataAdapter();
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                par.Value = Convert.ToInt32(employeeID);
                cmd.Parameters.Add(par);

                adapter.SelectCommand = cmd;

                DataTable dt = new DataTable();

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    adapter.Fill(dt);
                    radGridMinWage2.DataSource = dt;
                }
                catch (SqlException ex)
                {
                    SetMessage(Resources.Resource.lblActionSelect, String.Format(Resources.Resource.msgSelectFailed, ex.Message), "red");
                }
                catch (System.Exception ex)
                {
                    SetMessage(Resources.Resource.lblActionSelect, String.Format(Resources.Resource.msgSelectFailed, ex.Message), "red");
                }
                finally
                {
                    con.Close();
                }
            }
        }

        protected void RadGridMinWage2_DeleteCommand(object sender, GridCommandEventArgs e)
        {
            RadGrid radGridMinWage2 = (sender as RadGrid);

            StringBuilder sql = new StringBuilder();
            sql.Append("DELETE FROM Master_EmployeeWageGroupAssignment ");
            sql.Append("WHERE (SystemID = @SystemID) AND (BpID = @BpID) AND (EmployeeID = @EmployeeID) AND (TariffWageGroupID = @TariffWageGroupID) ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item as GridDataItem).GetDataKeyValue("EmployeeID"));
            cmd.Parameters.Add(par);

            par = new SqlParameter("@TariffWageGroupID", SqlDbType.Int);
            par.Value = Convert.ToInt32((e.Item as GridDataItem).GetDataKeyValue("TariffWageGroupID"));
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

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

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        protected void RadGridMinWage4_UpdateCommand(object sender, GridCommandEventArgs e)
        {
            GridEditableItem item = e.Item as GridEditableItem;

            if (item != null)
            {
                HiddenField wageC = item.FindControl("Wage_C") as HiddenField;
                HiddenField wageE = item.FindControl("Wage_E") as HiddenField;
                int statusCode = 0;
                RadTextBox amount = item.FindControl("Amount") as RadTextBox;

                decimal amountValue = 0;
                decimal wageCValue = 0;
                decimal wageEValue = 0;

                if (wageC != null && wageE != null)
                {
                    amountValue = Convert.ToDecimal(amount.Text);
                    wageCValue = Convert.ToDecimal(wageC.Value);
                    wageEValue = Convert.ToDecimal(wageE.Value);

                    if (amountValue >= wageCValue && amountValue >= wageEValue)
                    {
                        statusCode = 2;
                    }
                    else if (amountValue >= wageCValue && amountValue >= wageEValue)
                    {
                        statusCode = 4;
                    }
                    else if (amountValue < wageCValue)
                    {
                        statusCode = 5;
                    }
                }

                StringBuilder sql = new StringBuilder();
                sql.Append("UPDATE Data_EmployeeMinWage ");
                sql.Append("SET Amount = @Amount, StatusCode = @StatusCode, EditFrom = @UserName, EditOn = SYSDATETIME(), ReceivedFrom = @UserName, ReceivedOn = SYSDATETIME() ");
                sql.Append("WHERE SystemID = @SystemID AND BpID = @BpID AND EmployeeID = @EmployeeID AND MWMonth = @MWMonth ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@EmployeeID", SqlDbType.Int);
                par.Value = Convert.ToInt32(item.GetDataKeyValue("EmployeeID"));
                cmd.Parameters.Add(par);

                par = new SqlParameter("@MWMonth", SqlDbType.Date);
                par.Value = Convert.ToDateTime(item.GetDataKeyValue("MWMonth"));
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Amount", SqlDbType.Decimal);
                par.Value = amountValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusCode", SqlDbType.Int);
                par.Value = statusCode;
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

                (sender as RadGrid).MasterTableView.ClearEditItems();

                // Message anzeigen
                if (!string.IsNullOrEmpty(gridMessage))
                {
                    DisplayMessage(messageTitle, gridMessage, messageColor);
                }
            }
        }
    }
}