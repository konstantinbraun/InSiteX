using InSite.App.Constants;
using InSite.App.UserServices;
using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App
{
    public class BasePage : Page
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private const string MDefaultCulture = "en-GB";

        protected override void OnLoad(EventArgs e)
        {
            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");

            if (Session["Tick"] == null)
            {
                this.CheckSessionTimeout();
            } 
            else
            {
                Session["Tick"] = null;
            }

            if (!Request.Path.Contains("Password.aspx") && Request.UrlReferrer != null && !Request.UrlReferrer.ToString().Contains("Password.aspx"))
            {
                if (Session["IsLoggedIn"] == null || !(Boolean)Session["IsLoggedIn"])
                {
                    if (!Page.IsCallback) 
                        ajax.Redirect("~/Views/Login.aspx?Msg=PleaseLogin");
                }
                else if (Session["BpID"] == null || Convert.ToInt32(Session["BpID"]) == 0)
                {
                    if (!Request.Path.Contains("BuildingProjectsSelect.aspx") && !Request.UrlReferrer.ToString().Contains("BuildingProjectsSelect.aspx"))
                    {
                        if (!Page.IsCallback)
                            ajax.Redirect("~/Views/BuildingProjectsSelect.aspx?Msg=PleaseSelect");
                    }
                    if (!this.IsPostBack)
                    {
                        string[] url = Request.UrlReferrer.ToString().Split(new char[] { '?' });
                        if (!url[0].ToString().Contains("Layout.aspx"))
                        {
                            Session["Referrer"] = url[0];
                        }
                        base.OnLoad(e);
                    }
                }
                else if (!this.IsPostBack)
                {
                    string[] url = Request.UrlReferrer.ToString().Split(new char[] { '?' });
                    if (!url[0].ToString().Contains("Layout.aspx"))
                    {
                        Session["Referrer"] = url[0];
                    }
                    base.OnLoad(e);
                }
            }
            else
            {
                if (Session["IsLoggedIn"] == null || !(Boolean)Session["IsLoggedIn"])
                {
                    Session["RawUrl"] = Request.RawUrl;
                    if (!Page.IsCallback)
                        ajax.Redirect("~/Views/Login.aspx?Msg=PleaseLogin");
                }
                if (!this.IsPostBack)
                {
                    if (Request.UrlReferrer != null)
                    {
                        string[] url = Request.UrlReferrer.ToString().Split(new char[] { '?' });
                        if (!url[0].ToString().Contains("Layout.aspx"))
                        {
                            Session["Referrer"] = url[0];
                        }
                    }
                    base.OnLoad(e);
                }
            }
        }

        public int SessionLengthMinutes
        {
            get
            {
                return Session.Timeout;
            }
        }

        public string SessionExpireDestinationUrl
        {
            get
            {
                return "/InSiteApp/Views/Login.aspx?Msg=Timeout";
            }
        }

        protected override void OnPreRender(EventArgs e)
        {
            Response.AppendHeader("Access-Control-Allow-Origin", "*"); 
            
            if (!IsPostBack)
            {
                // this.Page.Header.Controls.Add(new LiteralControl(String.Format("<meta http-equiv='refresh' content='{0};url={1}'>", SessionLengthMinutes * 60, SessionExpireDestinationUrl)));
            }
            base.OnPreRender(e);
        }

        private void CheckSessionTimeout()
        {
            //time to remind, 3 minutes before session ends
            int intMilliSecondsTimeReminder = (SessionLengthMinutes * 60000) - (3 * 60000);
            //time to redirect, 5 milliseconds before session ends
            int intMilliSecondsTimeOut = (SessionLengthMinutes * 60000) - 5;

            string strScript = @"var myTimeReminder, myTimeOut; clearTimeout(myTimeReminder); clearTimeout(myTimeOut); " +
                               "var sessionTimeReminder = " + intMilliSecondsTimeReminder.ToString() + "; " +
                               "var sessionTimeout = " + intMilliSecondsTimeOut.ToString() + ";" +
                               "function doReminder(){ radalert('" + Resources.Resource.msgSessionTimeout + "', 350, 150, '" + Resources.Resource.lblSessionWillBeClosed + "'); }" +
                               "function doRedirect(){ window.location.href='" + SessionExpireDestinationUrl + "'; }" +
                               @"myTimeReminder=setTimeout('doReminder()', sessionTimeReminder); myTimeOut=setTimeout('doRedirect()', sessionTimeout); ";

            ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "CheckSessionOut", strScript, true);
        }

        protected override void InitializeCulture()
        {
            if (!this.IsPostBack)
            {
                //retrieve culture information from session
                string culture = Convert.ToString(Session["currentCulture"]);

                //check whether a culture is stored in the session
                if (!string.IsNullOrEmpty(culture))
                    Culture = culture;
                else
                    Culture = MDefaultCulture;

                //set culture to current thread
                if (!Thread.CurrentThread.CurrentCulture.Name.ToLower().Equals(culture.ToLower()))
                {
                    Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(culture);
                    logger.DebugFormat("Current culture set to {0}", culture);
                }
                if (!Thread.CurrentThread.CurrentUICulture.Name.ToLower().Equals(culture.ToLower()))
                {
                    Thread.CurrentThread.CurrentUICulture = new CultureInfo(culture);
                    // logger.DebugFormat("Current UI culture set to {0}", culture);
                }
            }

            //call base class
            base.InitializeCulture();
        }

        [WebMethod]
        public static void CompleteTask(bool? userResponse)
        {
            //null will be received if the user closes the dialog via the [X] button
            if (userResponse == true)
            {
                if (HttpContext.Current.Session["ConfirmAction"].ToString() == "Logout")
                {
                    string loginName = string.Empty;
                    if (HttpContext.Current.Session["LoginName"] != null)
                    {
                        loginName = HttpContext.Current.Session["LoginName"].ToString();
                    }
                    logger.DebugFormat("User {0} confirms logout", loginName);
                    Helpers.Logout();
                    // Thread.Sleep(1000);
                    // HttpContext.Current.Server.TransferRequest("Login.aspx?Msg=Timeout", true);
                    // HttpContext.Current.Response.Redirect("Login.aspx?Msg=Timeout", true);
                }
            }
            else
            {
                //Cancel or the [x] button were pressed
                // throw new Exception((HttpContext.Current.Handler as Page).Session["ConfirmAction"].ToString());
            }
        }

        public void Alert(string alertMessage)
        {
            RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
            logger.Warn(alertMessage);
            ajax.Alert(alertMessage);
        }

        protected virtual Control FindControlRecursive(string id)
        {
            return FindControlRecursive(id, this);
        }

        protected virtual Control FindControlRecursive(string id, Control parent)
        {
            // If parent is the control we're looking for, return it
            if (string.Compare(parent.ID, id, true) == 0)
                return parent;
            // Search through children
            foreach (Control child in parent.Controls)
            {
                Control match = FindControlRecursive(id, child);
                if (match != null)
                    return match;
            }
            // If we reach here then no control with id was found
            return null;
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

        public String Tail(string stringToTail, int length)
        {
            string ret = stringToTail;
            if (stringToTail.Length > length)
            {
                string tail = " ...";
                ret = string.Concat(stringToTail.Substring(0, length), tail);
            }
            return ret;
        }

        public static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        public GetFieldsConfig_Result[] GetFieldsActionConfig(int dialogID, int actionID)
        {
            // Get field configuration for specific dialog and specific action 
            Webservices webservice = new Webservices();
            GetFieldsConfig_Result[] fc = webservice.GetFieldsConfig(dialogID, actionID);
            return fc;
        }

        public GetFieldsConfig_Result[] GetFieldsConfig(int dialogID)
        {
            // Get field configuration for specific dialog 
            Webservices webservice = new Webservices();
            GetFieldsConfig_Result[] fc = webservice.GetFieldsConfig(dialogID, 0);
            return fc;
        }

        public GetFieldsConfig_Result[] GetFieldsConfig(int dialogID, int roleID)
        {
            // Get field configuration for specific dialog and role
            Webservices webservice = new Webservices();
            GetFieldsConfig_Result[] fc = webservice.GetFieldsConfig(dialogID, 0, roleID);
            return fc;
        }

        public List<Tuple<int, bool>> GetRights(GetFieldsConfig_Result[] fc)
        {
            // Get rights for current dialog
            List<Tuple<int, bool>> rights = new List<Tuple<int, bool>>();

            if (fc.GetLength(0) > 0)
            {
                GetFieldsConfig_Result fca = null;

                fca = fc.FirstOrDefault(right => right.ActionID == Actions.View);
                rights.Add(new Tuple<int, bool>(Actions.View, fca.ActionIsActive && fca.DialogIsActive));

                fca = fc.FirstOrDefault(right => right.ActionID == Actions.Create);
                rights.Add(new Tuple<int, bool>(Actions.Create, fca.ActionIsActive && fca.DialogIsActive));

                fca = fc.FirstOrDefault(right => right.ActionID == Actions.Delete);
                rights.Add(new Tuple<int, bool>(Actions.Delete, fca.ActionIsActive && fca.DialogIsActive));

                fca = fc.FirstOrDefault(right => right.ActionID == Actions.Edit);
                rights.Add(new Tuple<int, bool>(Actions.Edit, fca.ActionIsActive && fca.DialogIsActive));

                fca = fc.FirstOrDefault(right => right.ActionID == Actions.Lock);
                rights.Add(new Tuple<int, bool>(Actions.Lock, fca.ActionIsActive && fca.DialogIsActive));

                fca = fc.FirstOrDefault(right => right.ActionID == Actions.Release);
                rights.Add(new Tuple<int, bool>(Actions.Release, fca.ActionIsActive && fca.DialogIsActive));

                fca = fc.FirstOrDefault(right => right.ActionID == Actions.ReleaseBp);
                rights.Add(new Tuple<int, bool>(Actions.ReleaseBp, fca.ActionIsActive && fca.DialogIsActive));

                fca = fc.FirstOrDefault(right => right.ActionID == Actions.Move);
                rights.Add(new Tuple<int, bool>(Actions.Move, fca.ActionIsActive && fca.DialogIsActive));
            }

            return rights;
        }

        public bool HasRight(List<Tuple<int, bool>> rights, int actionID)
        {
            bool ret = false;
            if (rights != null)
            {
                // Get right for specific action and current dialog
                Tuple<int, bool> right = rights.FirstOrDefault(r => r.Item1 == actionID);
                if (right != null)
                {
                    ret = right.Item2;
                }
            }
            return ret;
        }

        public void FieldsConfig(GetFieldsConfig_Result[] fc, int actionID, object e, bool withValidation)
        {
            if (fc != null)
            {
                // Get fields config data for current dialog and action
                GetFieldsConfig_Result[] fca = fc.Where(right => right.ActionID == actionID).ToArray();

                // Iterate through fields collection
                foreach (GetFieldsConfig_Result result in fca)
                {
                    // Find field
                    object control = null;
                    if (e != null)
                    {
                        if (e.GetType() == typeof(TreeListItemDataBoundEventArgs))
                        {
                            control = (e as TreeListItemDataBoundEventArgs).Item.FindControl(result.InternalName);
                        }
                        else if (e.GetType() == typeof(GridItemEventArgs))
                        {
                            control = (e as GridItemEventArgs).Item.FindControl(result.InternalName);
                        }
                        else if (e.GetType() == typeof(TreeListItemCreatedEventArgs))
                        {
                            control = (e as TreeListItemCreatedEventArgs).Item.FindControl(result.InternalName);
                        }

                        if (control != null)
                        {
                            // Field is TextBox
                            if (control.GetType() == typeof(RadTextBox))
                            {
                                RadTextBox ctl = (control as RadTextBox);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;
                                        if (actionID == Actions.Create)
                                        {
                                            // Set default value
                                            ctl.Text = result.DefaultValue;
                                        }

                                        if (withValidation)
                                        {
                                            SetRequiredFieldValidator(result, ctl);
                                        }
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }
                            // Field is CheckBox
                            else if (control.GetType() == typeof(CheckBox))
                            {
                                CheckBox ctl = (control as CheckBox);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;
                                        if (actionID == Actions.Create)
                                        {
                                            // Set default value
                                            ctl.Checked = (result.DefaultValue == "0") ? false : true;
                                        }
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }

                            // Field is DropDownTree
                            if (control.GetType() == typeof(RadDropDownTree))
                            {
                                RadDropDownTree ctl = (control as RadDropDownTree);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;
                                        if (actionID == Actions.Create)
                                        {
                                            // Set default value
                                            ctl.SelectedText = result.DefaultValue;
                                        }

                                        if (withValidation)
                                        {
                                            foreach (DropDownTreeEntry item in ctl.Entries)
                                            {
                                                // Check for default item with value 0
                                                if (item.Value == "0")
                                                {
                                                    // SetRequiredFieldValidator(result, ctl, "0");
                                                    SetCompareValidator(result, ctl);
                                                    break;
                                                }
                                            }
                                            SetRequiredFieldValidator(result, ctl);
                                        }
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }

                            // Field is ComboBox
                            if (control.GetType() == typeof(RadComboBox))
                            {
                                RadComboBox ctl = (control as RadComboBox);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;
                                        if (actionID == Actions.Create)
                                        {
                                            // Set default value
                                            ctl.Text = result.DefaultValue;
                                        }

                                        if (withValidation)
                                        {
                                            foreach (RadComboBoxItem item in ctl.Items)
                                            {
                                                // Check for default item with value 0
                                                if (item.Value == "0")
                                                {
                                                    // SetRequiredFieldValidator(result, ctl, "0");
                                                    SetCompareValidator(result, ctl);
                                                    break;
                                                }
                                            }
                                            SetRequiredFieldValidator(result, ctl);
                                        }
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }

                            if (control.GetType() == typeof(RadButton))
                            {
                                // Field is RadButton
                                RadButton ctl = (control as RadButton);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }

                            if (control.GetType() == typeof(Panel))
                            {
                                // Field is Panel
                                Panel ctl = (control as Panel);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }

                            if (control.GetType() == typeof(RadListBox))
                            {
                                // Field is ListBox
                                RadListBox ctl = (control as RadListBox);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;
                                        if (actionID == Actions.Create)
                                        {
                                            // Set default value
                                            ctl.SelectedValue = result.DefaultValue;
                                        }

                                        if (withValidation)
                                        {
                                            InitCustomValidator(result, e);
                                        }
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }

                            if (control.GetType() == typeof(RadGrid))
                            {
                                // Field is Grid
                                RadGrid ctl = (control as RadGrid);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;

                                        if (withValidation)
                                        {
                                            InitCustomValidator(result, e);
                                        }
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }

                            if (control.GetType() == typeof(RadDatePicker))
                            {
                                // Field is RadDatePicker
                                RadDatePicker ctl = (control as RadDatePicker);
                                if (result.IsVisible)
                                {
                                    // Field is visible
                                    if (!result.DescriptionTranslated.Equals(String.Empty))
                                    {
                                        // ToolTip
                                        ctl.ToolTip = result.DescriptionTranslated;
                                    }
                                    if (actionID == Actions.Create || actionID == Actions.Edit || actionID == Actions.Release || actionID == Actions.ReleaseBp || actionID == Actions.Lock)
                                    {
                                        // Is editable
                                        ctl.Enabled = result.IsEditable;
                                        if (actionID == Actions.Create)
                                        {
                                            // Set default value
                                            ctl.DbSelectedDate = result.DefaultValue;
                                        }

                                        if (withValidation)
                                        {
                                            SetRequiredFieldValidator(result, ctl);
                                        }
                                    }
                                }
                                else
                                {
                                    // Field is not visible
                                    ctl.Enabled = false;
                                    ctl.Visible = false;
                                }
                            }
                        }

                        // Set user defined label text
                        Label label = null;
                        if (e.GetType() == typeof(TreeListItemDataBoundEventArgs))
                        {
                            label = (e as TreeListItemDataBoundEventArgs).Item.FindControl(String.Concat("Label", result.InternalName)) as Label;
                        }
                        else if (e.GetType() == typeof(GridItemEventArgs))
                        {
                            label = (e as GridItemEventArgs).Item.FindControl(String.Concat("Label", result.InternalName)) as Label;
                        }
                        else if (e.GetType() == typeof(TreeListItemCreatedEventArgs))
                        {
                            label = (e as TreeListItemCreatedEventArgs).Item.FindControl(String.Concat("Label", result.InternalName)) as Label;
                        }
                        if (label != null)
                        {
                            label.Visible = result.IsVisible;
                            if (result.IsVisible && result.IsMandatory)
                            {
                                label.Font.Bold = true;
                            }
                            if (result.IsVisible && !result.NameTranslated.Equals(String.Empty))
                            {
                                label.Text = String.Concat(result.NameTranslated, ":");
                            }
                        }
                    }
                }
            }
        }

        private void SetRequiredFieldValidator(GetFieldsConfig_Result result, Control ctl)
        {
            SetRequiredFieldValidator(result, ctl, "-99");
        }

        private void SetRequiredFieldValidator(GetFieldsConfig_Result result, Control ctl, string initialValue)
        {
            if (result.IsMandatory)
            {
                // If field is mandatory, set RequiredFieldValidator
                RequiredFieldValidator rFV = new RequiredFieldValidator();
                Random rd = new Random();
                
                rFV.ID = String.Concat("RequiredFieldValidator", result.InternalName, rd.Next(100, 1000).ToString());
                rFV.ControlToValidate = ctl.ID;
                if (!initialValue.Equals("-99"))
                {
                    rFV.InitialValue = initialValue;
                }
                string msg;
                if (result.NameTranslated.Equals(String.Empty))
                {
                    msg = String.Concat((String)GetGlobalResourceObject("Resource", result.ResourceID), " ", Resources.Resource.lblRequired);
                }
                else
                {
                    msg = String.Concat(result.NameTranslated, " ", Resources.Resource.lblRequired);
                }

                rFV.ErrorMessage = msg;
                rFV.Text = " *";
                rFV.ForeColor = Color.Red;
                rFV.Display = ValidatorDisplay.Dynamic;
                rFV.EnableClientScript = false;
                rFV.Enabled = true;
                rFV.Visible = true;
                rFV.SetFocusOnError = true;
                //int index = ctl.Parent.Controls.IndexOf(ctl);
                //ctl.Parent.Controls.AddAt(index + 1, rFV);
                ctl.Parent.Controls.Add(rFV);
            }
        }

        private void SetCompareValidator(GetFieldsConfig_Result result, Control ctl)
        {
            if (result.IsMandatory)
            {
                // If field is mandatory, set CompareValidator
                CompareValidator rFV = new CompareValidator();
                Random rd = new Random();

                rFV.ID = String.Concat("CompareValidator", result.InternalName, rd.Next(10, 99).ToString());
                rFV.ControlToValidate = ctl.ID;
                rFV.ValueToCompare = Resources.Resource.selNoSelection;
                rFV.Operator = ValidationCompareOperator.NotEqual;
                string msg;
                if (result.NameTranslated.Equals(String.Empty))
                {
                    msg = String.Concat((String)GetGlobalResourceObject("Resource", result.ResourceID), ": ", Resources.Resource.lblSelectionRequired);
                }
                else
                {
                    msg = String.Concat(result.NameTranslated, ": ", Resources.Resource.lblSelectionRequired);
                }

                rFV.ErrorMessage = msg;
                rFV.Text = " *";
                rFV.ForeColor = Color.Red;
                rFV.Display = ValidatorDisplay.Dynamic;
                rFV.EnableClientScript = false;
                rFV.Enabled = true;
                rFV.Visible = true;
                rFV.SetFocusOnError = true;
                // int index = ctl.Parent.Controls.IndexOf(ctl);
                // ctl.Parent.Controls.AddAt(index + 1, rFV);
                ctl.Parent.Controls.Add(rFV);
            }
        }

        private void InitCustomValidator(GetFieldsConfig_Result result, object e)
        {
            if (result.IsMandatory)
            {
                CustomValidator cV = new CustomValidator();
                if (e != null)
                {
                    if (e.GetType() == typeof(TreeListItemDataBoundEventArgs))
                    {
                        cV = (e as TreeListItemDataBoundEventArgs).Item.FindControl(String.Concat("Validator", result.InternalName)) as CustomValidator;
                    }
                    else if (e.GetType() == typeof(GridItemEventArgs))
                    {
                        cV = (e as GridItemEventArgs).Item.FindControl(String.Concat("Validator", result.InternalName)) as CustomValidator;
                    }
                    else if (e.GetType() == typeof(TreeListItemCreatedEventArgs))
                    {
                        cV = (e as TreeListItemCreatedEventArgs).Item.FindControl(String.Concat("Validator", result.InternalName)) as CustomValidator;
                    }
                    if (cV != null)
                    {
                        string msg;
                        if (result.NameTranslated.Equals(String.Empty))
                        {
                            msg = String.Concat((String)GetGlobalResourceObject("Resource", result.ResourceID), " ", Resources.Resource.lblRequired);
                        }
                        else
                        {
                            msg = String.Concat(result.NameTranslated, " ", Resources.Resource.lblRequired);
                        }

                        cV.ErrorMessage = msg;
                        cV.Text = " *";
                        cV.ForeColor = Color.Red;
                        cV.Display = ValidatorDisplay.Dynamic;
                        cV.EnableClientScript = true;
                        cV.Enabled = true;
                        cV.Visible = true;
                    }
                }
            }
        }

        public GridTableView GetTableView(GridTableView currTableView, string controlId)
        {
            if (currTableView.ClientID == controlId)
            {
                return currTableView;
            }
            else
            {
                GridTableView tv = null;
                foreach (GridDataItem item in currTableView.Items)
                {
                    if (item.HasChildItems)
                    {
                        foreach (GridTableView nestedView in item.ChildItem.NestedTableViews)
                        {
                            object temp = GetTableView(nestedView, controlId);
                            if (temp != null)
                            {
                                tv = temp as GridTableView;
                                break;
                            }
                        }
                        if (tv != null)
                        {
                            break;
                        }
                    }
                }
                return tv;
            }
        }

        public string GetMWStatus(int statusCode)
        {
            switch(statusCode)
            {
                case 0:
                    {
                        return "";
                    }
                case 1:
                    {
                        // Open
                        return Resources.Resource.selStatusCode1;
                    }
                case 2:
                    {
                        // OK
                        return Resources.Resource.selStatusCode2;
                    }
                case 3:
                    {
                        // Faulty
                        return Resources.Resource.selStatusCode3;
                    }
                case 4:
                    {
                        // To low
                        return Resources.Resource.selStatusCode4;
                    }
                case 5:
                    {
                        // Wrong
                        return Resources.Resource.selStatusCode5;
                    }
                default:
                    {
                        return "";
                    }
            }
        }

        public DateTime? GetFilterDate(string inputDate, int pos)
        {
            DateTime? outputDate = null;
            if (!inputDate.Equals(string.Empty))
            {
                string[] dateArray = inputDate.Split(' ');
                if (dateArray.Length > pos)
                {
                    int seconds;
                    int minutes;
                    int hours;
                    int day;
                    int month;
                    int year;

                    if (dateArray.Length == 4)
                    {
                        if (pos == 1)
                        {
                            pos++;
                        }
                        seconds = int.Parse(dateArray[pos + 1].Substring(6, 2));
                        minutes = int.Parse(dateArray[pos + 1].Substring(3, 2));
                        hours = int.Parse(dateArray[pos + 1].Substring(0, 2));
                        day = int.Parse(dateArray[pos].Substring(3, 2));
                        month = int.Parse(dateArray[pos].Substring(0, 2));
                        year = int.Parse(dateArray[pos].Substring(6, 4));
                        outputDate = new DateTime(year, month, day, hours, minutes, seconds);
                    }
                    else
                    {
                        day = int.Parse(dateArray[pos].Substring(3, 2));
                        month = int.Parse(dateArray[pos].Substring(0, 2));
                        year = int.Parse(dateArray[pos].Substring(6, 4));
                        outputDate = new DateTime(year, month, day);
                    }
                }
            }
            return outputDate;
        }
    }
}