using System;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Threading;
using Telerik.Web.UI;
using InSite.App.UserServices;
using System.Web;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using System.Web.Services.Protocols;
using InSite.App.Constants;

namespace InSite.App
{
    public partial class SiteMaster : MasterPage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected void Page_Load(object sender, EventArgs e)
        {
            // Seitentitel ergänzen
            Session["pageTitle"] = headMaster.Title;
            if (!headMaster.Title.Equals(String.Empty))
            {
                headMaster.Title = Properties.AppDefaults.appName + " - " + headMaster.Title;
            }
            else
            {
                headMaster.Title = Properties.AppDefaults.appName;
            }

            // Seitenüberschrift zusammenbauen
            if (Session["BpName"] != null)
            {
                if (Session["pageTitle"] != null && !Session["pageTitle"].ToString().Equals(Session["BpName"].ToString()))
                {
                    BpName.Text = Session["BpName"].ToString() + " (" + Session["BpID"].ToString() + ")";
                    DoubleDot.Text = ": ";
                }
            }
            else
            {
                DoubleDot.Text = "";
            }
            if (Session["pageTitle"] != null)
            {
                PageTitle.Text = Session["pageTitle"].ToString();
            }

            if (!IsPostBack && Session["BpName"] != null)
            {
                // Statuszeile zusammenbauen
                UserAssignments user = Helpers.GetCurrentUserAssignment();
                leftStatus.Text = Resources.Resource.copyRight;
                string companyName = "";
                if (!user.Company.Equals(string.Empty))
                {
                    companyName = " (" + user.Company + ")";
                }
                middleStatus.Text = user.FirstName + " " + user.LastName + companyName + " : " + user.RoleName;
                // rightStatus.Text = Resources.Resource.lblActionReady;

                // Benutzer Skin laden
                if (user.SkinName != null && !user.SkinName.Equals(string.Empty))
                {
                    RadSkinManager1.Skin = user.SkinName;
                    FormDecorator1.Skin = user.SkinName;
                }

                // Benutzer Sprache laden
                if (!user.LanguageID.ToLower().Equals(Session["currentCulture"].ToString().ToLower()))
                {
                    Session["currentCulture"] = user.LanguageID;
                    Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(user.LanguageID);
                    Thread.CurrentThread.CurrentUICulture = new CultureInfo(user.LanguageID);
                    // RadAjaxManager1.Redirect(Request.Path);
                }

                if (!user.NeedsPwdChange && Session["BpID"] != null && Convert.ToInt32(Session["BpID"]) != 0)
                {
                    // Menüs initialisieren
                    RenderMenu();
                    // InitTreeViewContextMenus();
                    InitTreeView();

                    // RadPaneTree.Collapsed = false;
                    // treeView1.Visible = true;

                    UpdateMailbox();
                    UpdateProcesses();

                    Webservices webservice = new Webservices();
                    int dialogID = Convert.ToInt32(Session["DialogID"]);
                    System_Help help = webservice.GetHelp(dialogID, 0);
                    if (help != null)
                    {
                        GetHelp.Visible = true;
                        GetHelp.CommandArgument = help.HelpUrl;
                    }
                    else
                    {
                        GetHelp.Visible = false;
                    }
                }

                // PageIcon und HilfeIcon ausblenden, wenn keine Auswahl aus Baum
                if (Session["TreeViewNodeID"] == null)
                {
                    this.PageIcon.ImageUrl = "~/Resources/Images/favicon.ico";
                    this.GetHelp.Visible = false;
                }

                Helpers.SetMasterTimer(this, true);
            }
            //this.RadAjaxManager1.ResponseScripts.Add("cardReader.onajaxresponse();");
        }

        protected void Page_Init(object sender, EventArgs e)
        {
            // Persistence Manager initialisieren
            int systemID = Convert.ToInt32(Session["SystemID"]);
            int userID = Convert.ToInt32(Session["UserID"]);
            RadPersistenceManager1.StorageProvider = new ControlStateDBStorageProvider(systemID, userID);
        }

        public void InitTreeView()
        {
            // Treeview initialisieren
            RadTreeView2.Nodes.Clear();
            RadTreeView2.DataSourceID = "SqlDataSource_TreeNodes";
            try
            {
                RadTreeView2.DataBind();
            }
            catch (Exception ex)
            {
                logger.ErrorFormat("Error in tree structure: {0}", ex.Message.ToString());
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);

                Notification.Title = Resources.Resource.lblActionView;
                Notification.Text = Resources.Resource.msgTreeDamage;
                Notification.AutoCloseDelay = 0;
                Notification.ShowSound = "warning";
                Notification.ContentIcon = "warning";
                Notification.Show();
            }
        }

        /// <summary>
        /// Datenbindung für Navigationsbaum
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void RadTreeView2_NodeDataBound(object sender, Telerik.Web.UI.RadTreeNodeEventArgs e)
        {
            DataRowView drv = e.Node.DataItem as DataRowView;

            string imageUrl = string.Empty;

            // Icon
            Image nodeImage = e.Node.FindControl("NodeImage") as Image;
            // Beschriftung
            Label nodeText = e.Node.FindControl("NodeText") as Label;
            // Untertitel
            Label nodeSubtext = e.Node.FindControl("NodeSubtext") as Label;
            // Anzeige neuer Elemente
            Panel bubbleContainer = e.Node.FindControl("BubbleContainer") as Panel;
            // Text für Anzeige neuer Elemente
            Label bubbleText = e.Node.FindControl("BubbleText") as Label;
            HyperLink navigateUrl = e.Node.FindControl("NavigateUrl") as HyperLink;

            e.Node.Font.Size = 9;

            // Icon
            if (Convert.ToInt32(drv["ImageID"]) != 0)
            {
                string imageHome = ConfigurationManager.AppSettings["ImageFilesHome"];
                string imagePath = drv["ImagePath"].ToString();
                string imageName = drv["ImageName"].ToString();
                imageUrl = string.Concat(imageHome, imagePath, "/", imageName);
                nodeImage.ImageUrl = imageUrl;
            }

            string resourceID = drv["ResourceID"].ToString();
            if (!resourceID.Equals(string.Empty))
            {
                nodeText.Text = (String)GetGlobalResourceObject("Resource", resourceID);

                // Untertitel für Bauvorhaben
                if (resourceID.Equals("lblBuildingProject") && Session["BpName"] != null)
                {
                    nodeText.Text = Session["BpName"].ToString();
                    nodeText.Font.Bold = true;

                    if (Session["BpDescription"] != null)
                    {
                        string bpDescription = Session["BpDescription"].ToString();
                        if (bpDescription != null && !bpDescription.Equals(string.Empty))
                        {
                            nodeSubtext.Text = bpDescription;
                            nodeSubtext.Visible = true;
                        }
                    }
                }

                // Anzeige neuer Elemente für Briefkasten
                else if (resourceID.Equals("lblMailBox"))
                {
                    int unread = Convert.ToInt32(Session["MailCount"]);
                    if (unread > 0)
                    {
                        // nodeText.Text = unread.ToString() + " " + Resources.Resource.lblNewMessages;
                        // nodeText.ForeColor = System.Drawing.Color.Red;
                        nodeImage.ImageUrl = "~/Resources/Icons/mail-unread-new.png";

                        bubbleContainer.Visible = true;
                        bubbleText.Text = unread.ToString();
                        bubbleText.ToolTip = unread.ToString() + " " + Resources.Resource.lblNewMessages;
                    }
                }

                // Anzeige neuer Elemente für Vorgangsverwaltung
                else if (resourceID.Equals("lblProcessManagement"))
                {
                    int unread = Convert.ToInt32(Session["ProcessCount"]);
                    if (unread > 0)
                    {
                        // nodeText.Text = unread.ToString() + " " + Resources.Resource.lblOpenProcesses;
                        // nodeText.ForeColor = System.Drawing.Color.Blue;

                        bubbleContainer.Visible = true;
                        bubbleText.Text = unread.ToString();
                        bubbleText.ToolTip = unread.ToString() + " " + Resources.Resource.lblOpenProcesses;
                    }
                }

                // Anzeige neuer Elemente für zentrale Vorgangsverwaltung
                else if (resourceID.Equals("lblProcessManagementCentral"))
                {
                    int unread = Convert.ToInt32(Session["ProcessCountCentral"]);
                    if (unread > 0)
                    {
                        // nodeText.Text = unread.ToString() + " " + Resources.Resource.lblOpenProcessesCentral;
                        // nodeText.ForeColor = System.Drawing.Color.Blue;

                        bubbleContainer.Visible = true;
                        bubbleText.Text = unread.ToString();
                        bubbleText.ToolTip = unread.ToString() + " " + Resources.Resource.lblOpenProcessesCentral;
                    }
                }

                nodeText.ToolTip = (String)GetGlobalResourceObject("Resource", resourceID);
                nodeText.Attributes.Add("ResourceID", resourceID);
            }

            if (e.Node.Level == 0)
            {
                nodeText.Font.Bold = true;
            }

            // Url für NodeClick
            string nodeUrl = drv["NodeUrl"].ToString();
            if (!nodeUrl.Equals(string.Empty))
            {
                e.Node.NavigateUrl = nodeUrl;
                navigateUrl.NavigateUrl = nodeUrl;
                e.Node.PostBack = false;
            }
            else
            {
                e.Node.PostBack = true;
            }

            // Contextmenü für Knoten
            string contextMenu = drv["ContextMenuID"].ToString();
            if (contextMenu.Equals(string.Empty))
            {
                e.Node.EnableContextMenu = false;
            }
            else
            {
                e.Node.EnableContextMenu = true;
                e.Node.ContextMenuID = contextMenu;
            }

            e.Node.ExpandMode = TreeNodeExpandMode.ServerSide;

            if (Convert.ToInt32(drv["ChildCount"]) == 0)
            {
                // Knoten ohne Unterknoten
                e.Node.ContentCssClass = "hide";
            }
            else
            {
                // Knoten mit Unterknoten
                nodeText.Font.Bold = true;
                nodeText.ForeColor = System.Drawing.Color.DarkBlue;
            }

            // Aktuell ausgewählten Knoten hervorheben
            if (Session["TreeViewNodeID"] != null)
            {
                if (e.Node.Value.Equals(Session["TreeViewNodeID"].ToString()))
                {
                    RadTreeNode node = e.Node;
                    node.Selected = true;
                    node.Expanded = true;
                    node.ExpandParentNodes();
                    node.Focus();

                    this.PageIcon.ImageUrl = imageUrl;
                    this.PageIcon.Visible = true;
                }
            }
        }

        /// <summary>
        /// Menüzeile zusammenbauen
        /// </summary>
        private void RenderMenu()
        {
            RadMenu1.Items.Clear();
            RadMenuItem item1;
            RadMenuItem item01;

            // Home
            item1 = new RadMenuItem(Resources.Resource.lblHome);
            item1.Value = "Home";
            item1.NavigateUrl = "~/Views/Dashboard.aspx";
            RadMenu1.Items.Add(item1);

            // Benutzer
            item1 = new RadMenuItem(Resources.Resource.lblUser);
            item1.Value = "User";
            item1.PostBack = false;

            item01 = new RadMenuItem(Resources.Resource.lblChangeLanguage);
            item01.Value = "User_Languages";
            item1.Items.Add(item01);

            item01 = new RadMenuItem(Resources.Resource.lblChangePwd);
            item01.Value = "User_ChangePwd";
            item01.NavigateUrl = "~/Views/Costumization/Password.aspx";
            item1.Items.Add(item01);

            if (Convert.ToByte(Session["UserType"]) >= 50)
            {
                item01 = new RadMenuItem(Resources.Resource.lblChangeLayout);
                item01.Value = "View_Layout";
                item1.Items.Add(item01);
            }

            item01 = new RadMenuItem();
            item01.IsSeparator = true;
            item1.Items.Add(item01);

            item01 = new RadMenuItem(Resources.Resource.lblBpSelect);
            item01.Value = "User_BpSelect";
            item01.NavigateUrl = "~/Views/Login.aspx?Action=BpSelect";
            item1.Items.Add(item01);

            item01 = new RadMenuItem();
            item01.IsSeparator = true;
            item1.Items.Add(item01);

            item01 = new RadMenuItem(Resources.Resource.lblLogout);
            item01.Value = "User_Logout";
            // item01.NavigateUrl = "~/Views/Login.aspx";
            item1.Items.Add(item01);

            RadMenu1.Items.Add(item1);

            //// Ansicht
            //item1 = new RadMenuItem(Resources.Resource.lblView);
            //item1.Value = "View";
            //item1.PostBack = false;

            //item01 = new RadMenuItem(Resources.Resource.lblActionRefresh);
            //item01.Value = "View_Refresh";
            //item1.NavigateUrl = "#";
            //item1.Items.Add(item01);

            //RadMenu1.Items.Add(item1);

            // Administrator
            if (Helpers.IsSysAdmin())
            {
                item1 = new RadMenuItem(Resources.Resource.lblAdministration);
                item1.Value = "Admin";
                item1.PostBack = false;

                item01 = new RadMenuItem(Resources.Resource.lblLogViewer);
                item01.Value = "Admin_LogViewer";
                item01.NavigateUrl = "~/Views/Costumization/LogViewer.aspx";
                item1.Items.Add(item01);

                item01 = new RadMenuItem(Resources.Resource.lblHistoryTables);
                item01.Value = "Admin_HistoryTables";
                item1.Items.Add(item01);

                item01 = new RadMenuItem(Resources.Resource.lblEmplAccess2);
                item01.Value = "Admin_AccessHistory";
                item01.NavigateUrl = "~/Views/Main/AccessHistory.aspx";
                item1.Items.Add(item01);

                if (Helpers.IsMaster())
                {
                    item01 = new RadMenuItem("Hasher");
                    item01.Value = "Admin_Hasher";
                    item01.NavigateUrl = "~/Views/Costumization/Hasher.aspx";
                    item1.Items.Add(item01);

                    item01 = new RadMenuItem(Resources.Resource.lblContainerManagement);
                    item01.Value = "Admin_ContainerManagement";
                    item01.NavigateUrl = "~/Views/Costumization/ContainerManagement.aspx";
                    item1.Items.Add(item01);

                    item01 = new RadMenuItem(Resources.Resource.lblTerminal);
                    item01.Value = "Admin_Terminal";
                    item1.Items.Add(item01);
                    
                    //item01 = new RadMenuItem("GetAccessRights");
                    //item01.Value = "Admin_GetAccessRights";
                    //item1.Items.Add(item01);
                    //item01 = new RadMenuItem("WebCam");
                    //item01.Value = "Admin_WebCam";
                    //item01.NavigateUrl = "~/Views/Main/WebCamTest.aspx";
                    //item1.Items.Add(item01);
                }

                RadMenu1.Items.Add(item1);
            }

            // Hilfe
            item1 = new RadMenuItem(Resources.Resource.lblHelp);
            item1.Value = "Help";
            item1.PostBack = false;

            item01 = new RadMenuItem(Resources.Resource.lblDocumentation);
            item01.Value = "Help_Documentation";
            item1.Items.Add(item01);

            item01 = new RadMenuItem(Resources.Resource.lblSupport);
            item01.Value = "Help_Support";
            item1.Items.Add(item01);

            item01 = new RadMenuItem(Resources.Resource.lblInfo);
            item01.Value = "Help_Info";
            item1.Items.Add(item01);

            RadMenu1.Items.Add(item1);

            //Webservices webservice = new Webservices();
            //int dialogID = Convert.ToInt32(Session["DialogID"]);
            //System_Help help = webservice.GetHelp(dialogID, 0);
            //if (help != null)
            //{
            //    item1 = new RadMenuItem();
            //    item1.ImageUrl = "/InSiteApp/Resources/Icons/Help_22.png";
            //    item1.ToolTip = Resources.Resource.lblDialogHelp;
            //    item1.Value = "DialogHelp";
            //    RadMenu1.Items.Add(item1);
            //}
        }

        /// <summary>
        /// Beliebige Seite als PopUp anzeigen
        /// </summary>
        /// <param name="navigateUrl"></param>
        /// <param name="iconUrl"></param>
        /// <param name="modal"></param>
        /// <param name="title"></param>
        public void ShowAsPopUp(string navigateUrl, string iconUrl, bool modal, string title)
        {
            if (iconUrl.Equals(string.Empty))
            {
                iconUrl = "/InSiteApp/Resources/Icons/TitleIcon.png";
            }
            else
            {
                iconUrl = iconUrl.Replace("~", "/InSiteApp");
            }

            StringBuilder script = new StringBuilder();
            script.AppendLine("function f(){");
            script.AppendLine("var radWindow = $find(\"" + RadWindowPopUp.ClientID + "\");");
            script.AppendLine("radWindow.setUrl(\"" + navigateUrl + "\");");
            script.AppendLine("radWindow.set_iconUrl(\"" + iconUrl + "\");");
            script.AppendLine("radWindow.set_title(\"" + title + "\");");
            if (modal)
            {
                script.AppendLine("radWindow.set_modal(true);");
            }
            else
            {
                script.AppendLine("radWindow.set_left(0);");
                script.AppendLine("radWindow.set_modal(false);");
            }
            script.AppendLine("radWindow.show();");
            script.AppendLine("Sys.Application.remove_load(f);");
            script.AppendLine("}");
            script.AppendLine("Sys.Application.add_load(f);");

            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "key", script.ToString(), true);
        }

        private void ShowAsPopUp(string navigateUrl, string iconUrl, bool modal)
        {
            ShowAsPopUp(navigateUrl, iconUrl, modal, string.Empty);
        }

        private void ShowAsPopUp(string navigateUrl)
        {
            ShowAsPopUp(navigateUrl, "", true);
        }

        /// <summary>
        /// Contextmenü für Navigationsbaum zusammenbauen
        /// </summary>
        private void InitTreeViewContextMenus()
        {
            RadTreeViewContextMenu menu = new RadTreeViewContextMenu();
            RadMenuItem item;

            menu.ID = "MainContextMenu";
            menu.CollapseAnimation.Type = AnimationType.InOutBounce;
            menu.CollapseAnimation.Duration = 300;

            item = new RadMenuItem(Resources.Resource.lblActionNew);
            item.ImageUrl = "Resources/Icons/edit-add.png";
            menu.Items.Add(item);

            item = new RadMenuItem(Resources.Resource.lblActionDelete);
            item.ImageUrl = "Resources/Icons/edit-delete-6.png";
            menu.Items.Add(item);

            item = new RadMenuItem(Resources.Resource.lblActionEdit);
            item.ImageUrl = "Resources/Icons/edit-3.png";
            menu.Items.Add(item);

            item = new RadMenuItem("");
            item.IsSeparator = true;
            menu.Items.Add(item);

            item = new RadMenuItem(Resources.Resource.lblActionCopy);
            item.ImageUrl = "Resources/Icons/edit-copy-3.png";
            menu.Items.Add(item);

            item = new RadMenuItem(Resources.Resource.lblActionCut);
            item.ImageUrl = "Resources/Icons/edit-cut-3.png";
            menu.Items.Add(item);

            item = new RadMenuItem(Resources.Resource.lblActionPaste);
            item.ImageUrl = "Resources/Icons/edit-paste-2.png";
            menu.Items.Add(item);

            RadTreeView2.ContextMenus.Add(menu);
        

            // Kontextmenü Bauvorhaben
            menu = new RadTreeViewContextMenu();
            menu.ID = "BpContextMenu";
            menu.CollapseAnimation.Type = AnimationType.InOutBounce;
            menu.CollapseAnimation.Duration = 300;

            item = new RadMenuItem(Resources.Resource.lblBpSelect);
            item.ImageUrl = "Resources/Icons/applications-development-5.png";
            item.NavigateUrl = "~/Views/Login.aspx?Action=BpSelect";
            menu.Items.Add(item);

            RadTreeView2.ContextMenus.Add(menu);
        }

        protected void RadSkinManager1_SkinChanged(object sender, SkinChangedEventArgs e)
        {
            Helpers.ChangeSkin(e.Skin.ToString());
            // RadAjaxManager1.Redirect("Layout.aspx");
        }

        protected void RadTreeView2_DataBound(object sender, EventArgs e)
        {
            // Treeview expandierte Knoten wiederherstellen
            if (Session["expandedNodes"] != null)
            {
                string[] expandedNodeValues = Session["expandedNodes"].ToString().Split('*');
                foreach (string nodeValue in expandedNodeValues)
                {
                    RadTreeNode expandedNode = RadTreeView2.FindNodeByValue(HttpUtility.UrlDecode(nodeValue));
                    if (expandedNode != null)
                        expandedNode.Expanded = true;
                }
            }
        }

        protected void RadSkinManager1_PreRender(object sender, EventArgs e)
        {
            // RadComboBox skinChooser = RadSkinManager1.FindControl("SkinChooser") as RadComboBox;
            /*            int i = 0;
            while (i < skinChooser.Items.Count)
            {
            if (skinChooser.Items[i].Text == "Black")
            {
            skinChooser.Items.Remove(skinChooser.Items[i]);
            }
            if (skinChooser.Items[i].Text == "BlackMetroTouch")
            {
            skinChooser.Items.Remove(skinChooser.Items[i]);
            }
            if (skinChooser.Items[i].Text == "MetroTouch")
            {
            skinChooser.Items.Remove(skinChooser.Items[i]);
            }
            if (skinChooser.Items[i].Text == "Office2010Black")
            {
            skinChooser.Items.Remove(skinChooser.Items[i]);
            }
            if (skinChooser.Items[i].Text == "Office2010Silver")
            {
            skinChooser.Items.Remove(skinChooser.Items[i]);
            }
            if (skinChooser.Items[i].Text == "Forest")
            {
            skinChooser.Items.Remove(skinChooser.Items[i]);
            }
            if (skinChooser.Items[i].Text == "Glow")
            {
            skinChooser.Items.Remove(skinChooser.Items[i]);
            }
            if (skinChooser.Items[i].Text == "Hay")
            {
            skinChooser.Items.Remove(skinChooser.Items[i]);
            }
            i++;
            //more conditions here  
            }
        */ }

        protected void RadMenu1_ItemClick(object sender, RadMenuEventArgs e)
        {
            if (e.Item.Value.Equals("User_Logout"))
            {
                logger.DebugFormat("User {0} wants to logout", Session["LoginName"].ToString());
                RadWindowManager1.RadConfirm(Resources.Resource.qstLogout, "confirmCallBackFn", 300, 150, null, Resources.Resource.lblLogout);
                Session["ConfirmAction"] = "Logout";
            }
            else if (e.Item.Value.Equals("View_Refresh"))
            {
                InitTreeView();
                RenderMenu();
            }
            else if (e.Item.Value.Equals("User_Languages"))
            {
                Session["previousCulture"] = Session["currentCulture"];
                RadAjaxManager1.Redirect("~/Views/Costumization/Languages.aspx");
            }
            else if (e.Item.Value.Equals("View_Layout"))
            {
                Session["PreviousSkin"] = RadSkinManager1.Skin;
                RadAjaxManager1.Redirect("~/Views/Costumization/Layout.aspx");
            }
            else if (e.Item.Value.Equals("Admin_WebCam"))
            {
                ShowAsPopUp("/InSiteApp/Main/WebCamTest.aspx");
            }
            else if (e.Item.Value.Equals("Help_Support"))
            {
                ShowAsPopUp("/InSiteApp/Views/Help/Support.aspx");
            }
            else if (e.Item.Value.Equals("Help_Info"))
            {
                ShowAsPopUp("/InSiteApp/Views/Help/Info.aspx");
            }
            else if (e.Item.Value.Equals("Admin_HistoryTables"))
            {
                ShowAsPopUp("/InSiteApp/Views/Central/HistoryTables.aspx");
            }
            else if (e.Item.Value.Equals("Admin_GetAccessRights"))
            {
                AccessServiceInterface access = new AccessServiceInterface();
                access.GetAccessRights();
            }
            else if (e.Item.Value.Equals("DialogHelp"))
            {
                string url = string.Empty;

                Webservices webservice = new Webservices();
                int dialogID = Convert.ToInt32(Session["DialogID"]);
                System_Help help = webservice.GetHelp(dialogID, 0);
                if (help != null)
                {
                    url = "/InSiteApp" + help.HelpUrl;
                    // url = "/InSiteApp/Views/HtmlViewer.aspx";
                    ShowAsPopUp(url, "/InSiteApp/Resources/Icons/Help_16.png", false, Session["pageTitle"].ToString());
                }
            }
            else if (e.Item.Value.Equals("Admin_Terminal"))
            {
                ShowAsPopUp("/InSiteApp/Views/Main/Speedy.aspx");
            }
        }

        protected void RadTreeView2_NodeClick(object sender, RadTreeNodeEventArgs e)
        {
            // Session["TreeViewNodeID"] = e.Node.Value;
            string nodeText = (e.Node.FindControl("NodeText") as Label).Text;
            if (e.Node.ContentCssClass != "hide" && e.Node.Level != 0 && !nodeText.Equals(Session["BpName"].ToString()))
            {
                e.Node.Expanded = !e.Node.Expanded;
                SaveExpandedNodes(sender as RadTreeView);
            }

            logger.InfoFormat("Node '{0}' clicked", nodeText);

            if (!nodeText.Equals(string.Empty))
            {
                if (nodeText.Equals(GetResource("lblReportPassBilling")))
                {
                    ShowAsPopUp("/InSiteApp/Views/Reports/PassBilling.aspx", "/InSiteApp/Resources/Icons/PassBilling_16.png", true);
                    SetTreeNode();
                }
                else if (nodeText.Equals(GetResource("lblReportTariffData")))
                {
                    ShowAsPopUp("/InSiteApp/Views/Reports/TariffData.aspx?Sel=Tariff", "/InSiteApp/Resources/Icons/Contract_16.png", true);
                    SetTreeNode();
                }
                else if (nodeText.Equals(GetResource("lblReportTariffCompany")))
                {
                    ShowAsPopUp("/InSiteApp/Views/Reports/TariffData.aspx?Sel=Company", "/InSiteApp/Resources/Icons/Contract_16.png", true);
                    SetTreeNode();
                }
                else if (nodeText.Equals(GetResource("lblPresenceReport")))
                {
                    ShowAsPopUp("/InSiteApp/Views/Reports/PresenceReport.aspx", "/InSiteApp/Resources/Icons/accessories-date_16.png", true);
                    SetTreeNode();
                }
                else if (nodeText.Equals(GetResource("lblReportPresenceCount")))
                {
                    ShowAsPopUp("/InSiteApp/Views/Reports/PresenceCount.aspx", "/InSiteApp/Resources/Icons/PresenceCount_16.png", true);
                    SetTreeNode();
                }
                else if (nodeText.Equals(GetResource("lblReportTrades")))
                {
                    ShowAsPopUp("/InSiteApp/Views/Reports/TradesReport.aspx", "/InSiteApp/Resources/Icons/emblem-development_16.png", true);
                    SetTreeNode();
                }
                else if (nodeText.Equals(GetResource("lblSystemOverview")))
                {
                    ShowAsPopUp("/InSiteApp/Views/Reports/SystemOverview.aspx", "/InSiteApp/Resources/Icons/stats_16.png", true);
                    SetTreeNode();
                }
                else
                {
                    if (!e.Node.NavigateUrl.Equals(string.Empty))
                    {
                        RadAjaxManager1.Redirect("~/" + e.Node.NavigateUrl);
                        SetTreeNode();
                    }
                }
            }
        }

        /// <summary>
        /// Ausgewählten Knoten merken
        /// </summary>
        public void SetTreeNode()
        {
            int treeNodeID = 0;
            if (Session["TreeViewNodeID"] != null)
            {
                treeNodeID = Convert.ToInt32(Session["TreeViewNodeID"]);
            }
            SetTreeNode(treeNodeID);
        }

        /// <summary>
        /// Gemerkten Knoten wieder auswählen
        /// </summary>
        /// <param name="treeNodeID"></param>
        public void SetTreeNode(int treeNodeID)
        {
            RadTreeNode node = RadTreeView2.FindNodeByValue(treeNodeID.ToString());
            if (node != null)
            {
                node.Selected = true;
            }

            Helpers.SessionLogger(HttpContext.Current.Session.SessionID, SessionState.SessionUsed, null, null);
        }

        protected void RadButtonMailBox_Click(object sender, EventArgs e)
        {
            RadAjaxManager1.Redirect("~/Views/MailBox/MailBox.aspx");
        }

        protected void RadTreeView2_NodeCollapse(object sender, RadTreeNodeEventArgs e)
        {
            SaveExpandedNodes(sender as RadTreeView);
        }

        protected void RadTreeView2_NodeExpand(object sender, RadTreeNodeEventArgs e)
        {
            SaveExpandedNodes(sender as RadTreeView);
        }

        /// <summary>
        /// Expansionsstatus des Naviagtionsbaums beim Benutzer speichern
        /// </summary>
        /// <param name="rtv"></param>
        private void SaveExpandedNodes(RadTreeView rtv)
        {
            IList<RadTreeNode> nodeList = rtv.GetAllNodes();
            string expandedNodes = string.Empty;
            foreach (RadTreeNode node in nodeList)
            {
                if (node.Expanded == true)
                {
                    expandedNodes += node.Value + "*";
                }
            }
            Session["expandedNodes"] = expandedNodes;
            // Helpers.SetValueToCookie("expandedNodes", expandedNodes);
            Helpers.UpdateUser("TreeStatus", expandedNodes);
        }

        protected void RadTreeView2_NodeCreated(object sender, RadTreeNodeEventArgs e)
        {
            if (Session["TreeViewNodeID"] != null)
            {
                if (e.Node.Value.Equals(Session["TreeViewNodeID"].ToString()))
                {
                    e.Node.Selected = true;
                }
                else
                {
                    e.Node.Selected = false;
                }
            }
        }

        protected void ControlStateSave_Click(object sender, EventArgs e)
        {
            // Formulareinstellungen speichern
            RadPersistenceManager1.StorageProviderKey = Session["StorageProviderKey"].ToString();
            RadPersistenceManager1.SaveState();
            Helpers.PanelControlStateVisibility(this, true);
        }

        protected void ControlStateLoad_Click(object sender, EventArgs e)
        {
            // Formulareinstellungen laden
            RadPersistenceManager1.StorageProviderKey = Session["StorageProviderKey"].ToString();
            RadPersistenceManager1.LoadState();
            ClientControlRebind();
        }

        protected void ControlStateReset_Click(object sender, EventArgs e)
        {
            // Formulareinstellungen zurücksetzen
            Helpers.DeleteStateFromStorage(Session["StorageProviderKey"].ToString());
            ClientControlRebind();
            Helpers.PanelControlStateVisibility(this, true);
        }

        /// <summary>
        /// Datenbindung für persistierte Steuerelemente erneuern
        /// </summary>
        private void ClientControlRebind()
        {
            RadPersistenceManagerProxy proxy = this.BodyContent.FindControl("RadPersistenceManagerProxy1") as RadPersistenceManagerProxy;
            foreach (PersistenceSetting setting in proxy.PersistenceSettings)
            {
                if (setting.SettingType == PersistenceSettingType.ControlID)
                {
                    Object ctl = this.BodyContent.FindControl(setting.ControlID);
                    if (ctl != null)
                    {
                        if (ctl.GetType() == typeof(RadGrid))
                        {
                            (ctl as RadGrid).Rebind();
                        }
                        else if (ctl.GetType() == typeof(RadTreeList))
                        {
                            (ctl as RadTreeList).Rebind();
                        }
                    }
                }
            }
        }

        public static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void RadGridHistory_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            RadGridHistory.DataSource = GetHistoryData();
        }

        /// <summary>
        /// Datenänderungshistorie
        /// </summary>
        /// <returns></returns>
        private DataTable GetHistoryData()
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT d_l.LoggingID, d_l.SystemID, d_l.BpID, d_l.Date AS LoggingDate, d_l.Thread, d_l.[Level], d_l.Logger, d_l.Message, d_l.Exception, d_l.SessionID, d_l.DialogID, ");
            sql.Append("d_l.UserID, d_l.ActionID, d_l.RefID, s_a.NameVisible AS ActionName, s_a.ResourceID AS ActionResourceID, m_u.FirstName + ' ' + m_u.LastName AS UserName, ");
            sql.Append("m_u.Company, m_u.LoginName, m_u.RoleID ");
            sql.Append("FROM Data_Logging AS d_l ");
            sql.Append("INNER JOIN Master_TreeNodes AS m_tn ON d_l.SystemID = m_tn.SystemID AND d_l.DialogID = m_tn.DialogID ");
            sql.Append("LEFT OUTER JOIN Master_Users AS m_u ");
            sql.Append("ON d_l.SystemID = m_u.SystemID AND d_l.UserID = m_u.UserID ");
            sql.Append("LEFT OUTER JOIN System_Actions AS s_a ");
            sql.Append("ON d_l.SystemID = s_a.SystemID AND d_l.ActionID = s_a.ActionID ");
            sql.Append("WHERE d_l.SystemID = @SystemID ");
            sql.Append("AND d_l.BpID = @BpID ");
            sql.Append("AND d_l.ActionID <> @ActionID ");
            sql.Append("AND m_tn.NodeID = @NodeID ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@NodeID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["TreeViewNodeID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@ActionID", SqlDbType.Int);
            par.Value = Actions.View;
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

        public String GetResource(String resourceName)
        {
            return (String)GetGlobalResourceObject("Resource", resourceName);
        }

        protected void HistoryOfChanges_Click(object sender, EventArgs e)
        {
            RadPaneHistory.Collapsed = !RadPaneHistory.Collapsed;
            if (!RadPaneHistory.Collapsed)
            {
                RadGridHistory.DataSource = GetHistoryData();
                RadGridHistory.DataBind();
            }
        }

        protected void RadGridHistory_ItemCreated(object sender, GridItemEventArgs e)
        {
            GridFilteringItem filteringItem = e.Item as GridFilteringItem;
            if (filteringItem != null)
            {
                LiteralControl literalFrom = filteringItem["LoggingDate"].Controls[0] as LiteralControl;
                literalFrom.Text = Resources.Resource.lblFrom + " ";
                LiteralControl literalTo = filteringItem["LoggingDate"].Controls[3] as LiteralControl;
                literalTo.Text = "<br /> " + Resources.Resource.lblTo + "&nbsp;  ";
            }
        }

        protected void RadGridHistory_GroupsChanging(object sender, GridGroupsChangingEventArgs e)
        {
            if (e.Action == GridGroupsChangingAction.Group)
            {
                e.Expression.SelectFields[0].FieldAlias = e.Expression.SelectFields[0].HeaderText;
            }
        }

        /// <summary>
        /// Anzeige neuer Elemente für Briefkasten aktualisieren
        /// </summary>
        public void UpdateMailbox()
        {
            int previous = 0;
            if (Session["MailCount"] != null)
            {
                previous = Convert.ToInt32(Session["MailCount"]);
            }
            int unread = Helpers.GetUnreadMailCount();
            bool hasChanged = (previous != unread);

            if (hasChanged)
            {
                string messageText = unread.ToString() + " " + Resources.Resource.lblNewMessages;

                if (unread > previous)
                {
                    Mailbox.Text = messageText;
                    Mailbox.Value = unread.ToString();
                    Mailbox.Show();
                    // PanelMailbox.Update();
                }
                else
                {
                    Mailbox.Value = "0";
                }
                Session["MailCount"] = unread;

                InitTreeView();
            }
            else
            {
                Mailbox.Value = "0";
            }
        }

        /// <summary>
        /// Anzeige neuer Elemente für Vorgangsverwaltung aktualisieren
        /// </summary>
        public void UpdateProcesses()
        {
            int previous = 0;
            int previousCentral = 0;
            if (Session["ProcessCount"] != null)
            {
                previous = Convert.ToInt32(Session["ProcessCount"]);
            }
            if (Session["ProcessCountCentral"] != null)
            {
                previousCentral = Convert.ToInt32(Session["ProcessCountCentral"]);
            }

            int unread = Helpers.GetOpenProcessCount();
            int unreadCentral = Helpers.GetOpenProcessCount(0);

            bool hasChanged = (previous != unread);
            bool hasChangedCentral = (previousCentral != unreadCentral);

            if (hasChanged || hasChangedCentral)
            {
                string messageText = string.Empty;
                if (hasChanged)
                {
                    messageText += unread.ToString() + " " + Resources.Resource.lblOpenProcesses;
                    if (hasChangedCentral)
                    {
                        messageText += "<br/>";
                    }
                }
                if (hasChangedCentral)
                {
                    messageText += unreadCentral.ToString() + " " + Resources.Resource.lblOpenProcessesCentral;
                }

                if (unread > previous || unreadCentral > previousCentral)
                {
                    Processes.Text = messageText;
                    Processes.Value = (unread + unreadCentral).ToString();
                    Processes.Show();
                    // PanelProcesses.Update();
                }
                else
                {
                    Processes.Value = "0";
                }

                Session["ProcessCount"] = unread;
                Session["ProcessCountCentral"] = unreadCentral;

                InitTreeView();
            }
            else
            {
                Processes.Value = "0";
            }
        }

        protected void Mailbox_CallbackUpdate(object sender, RadNotificationEventArgs e)
        {
            UpdateMailbox();
        }

        protected void Processes_CallbackUpdate(object sender, RadNotificationEventArgs e)
        {
            UpdateProcesses();
        }

        /// <summary>
        /// Zeitsteuerung für Update der Anzeige
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void TimerMaster_Tick(object sender, EventArgs e)
        {
            Session["Tick"] = "1";
            UpdateMailbox();
            UpdateProcesses();

            DateTime lastUpdate = new DateTime(2000, 1, 1);
            Webservices webservice = new Webservices();
            Master_AccessSystems accessSystem = webservice.GetLastUpdateAccessControl();
            if (accessSystem != null)
            {
                if (accessSystem.LastUpdate != null)
                {
                    lastUpdate = (DateTime)accessSystem.LastUpdate;
                }
            }
            TimeSpan timeSpan = DateTime.Now - lastUpdate;

            if (timeSpan.TotalSeconds > Convert.ToDouble(ConfigurationManager.AppSettings["ACSOfflineTrigger"]))
            {
                if (Session["ACSLastState"].ToString().Equals("1"))
                {
                    Session["ACSLastState"] = "0";
                    Notification.Title = Resources.Resource.lblAccessControlSystem;
                    Notification.Text = Resources.Resource.msgAccessControlSystemOffline;
                    Notification.AutoCloseDelay = 0;
                    Notification.ShowSound = "warning";
                    Notification.ContentIcon = "warning";
                    Notification.Show();
                    PanelNotification.Update();
                }
            }
            else
            {
                if (Session["ACSLastState"].ToString().Equals("0"))
                {
                    Session["ACSLastState"] = "1";
                    Notification.Title = Resources.Resource.lblAccessControlSystem;
                    Notification.Text = Resources.Resource.msgAccessControlSystemOnline;
                    Notification.AutoCloseDelay = 3000;
                    Notification.ShowSound = "none";
                    Notification.ContentIcon = "info";
                    Notification.Show();
                    PanelNotification.Update();
                }
                else
                {
                    if (accessSystem.AllTerminalsOnline && Session["ATLastState"].ToString().Equals("0"))
                    {
                        Session["ATLastState"] = "1";
                        Notification.Title = Resources.Resource.lblAccessControlSystem;
                        Notification.Text = Resources.Resource.msgAccessTerminalsOnline;
                        Notification.AutoCloseDelay = 3000;
                        Notification.ShowSound = "none";
                        Notification.ContentIcon = "info";
                        Notification.Show();
                        PanelNotification.Update();
                    }
                    else if (!accessSystem.AllTerminalsOnline && Session["ATLastState"].ToString().Equals("1"))
                    {
                        Session["ATLastState"] = "0";
                        Notification.Title = Resources.Resource.lblAccessControlSystem;
                        Notification.Text = Resources.Resource.msgAccessTerminalsOffline;
                        Notification.AutoCloseDelay = 0;
                        Notification.ShowSound = "warning";
                        Notification.ContentIcon = "warning";
                        Notification.Show();
                        PanelNotification.Update();
                    }
                }
            }
        }

        protected void GetHelp_Click(object sender, EventArgs e)
        {
            string url = "/InSiteApp" + (sender as RadButton).CommandArgument;
            ShowAsPopUp(url, "/InSiteApp/Resources/Icons/Help_16.png", false, Session["pageTitle"].ToString());
        }
    }
}