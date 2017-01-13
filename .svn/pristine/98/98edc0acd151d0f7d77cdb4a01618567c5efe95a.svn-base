using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Linq;
using Telerik.Web.UI;

namespace InSite.App.Views
{
    public partial class Dashboard : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            UserAssignments user = new UserAssignments();
            try
            {
                user = Helpers.GetCurrentUserAssignment();
            }
            catch (KeyNotFoundException ex)
            {
                Helpers.Logout();
                RadAjaxManager ajax = (RadAjaxManager)this.Page.Master.FindControl("RadAjaxManager1");
                ajax.Redirect("/InSiteApp/Views/Login.aspx?Msg=PleaseLogin");
            }
            Username.Text = user.FirstName + " " + user.LastName;
            if (user.Company.Equals(string.Empty))
            {
                Company.Text = Resources.Resource.lblNoCompanyAssigned;
            }
            else
            {
                Company.Text = user.Company;
            }
            Role.Text = user.RoleName;
            // Layout.Text = user.SkinName;
            // Version.Text = Helpers.AppFileVersion() + " (" + Helpers.AppDate().ToShortDateString() + ")";
            
            Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);

            String msg = Request.QueryString["Msg"];
            if (msg != null)
            {
                if (msg.Equals("Welcome"))
                {
                    RadAjaxPanel treePanel = (RadAjaxPanel)this.Master.FindControl("treeView1");
                    if (treePanel != null)
                    {
                        // treePanel.Visible = true;
                    }
                    
                    ShowWelcome();
                }
                else if (msg.Equals("NoViewRight"))
                {
                    Helpers.Notification(this.Page.Master, Resources.Resource.lblActionView, Resources.Resource.msgNoViewRight);
                }
            }

            int bpID;
            if (Request.QueryString["BpID"] != null && !Request.QueryString["BpID"].Equals(String.Empty))
            {
                bpID = Convert.ToInt32(Request.QueryString["BpID"]);
            }
            else
            {
                bpID = Convert.ToInt32(Session["BpID"]);
            }

            Webservices webservice = new Webservices();
            Master_BuildingProjects buildingProject = webservice.GetBpInfo(bpID);

            if (Request.QueryString["BpID"] != null && !Request.QueryString["BpID"].Equals(String.Empty))
            {
                Session["BpID"] = buildingProject.BpID;
                log4net.GlobalContext.Properties["BpID"] = buildingProject.BpID;
                Session["BpName"] = buildingProject.NameVisible;
                ShowWelcome();
            }
            BpName.Text = buildingProject.NameVisible;
            BpDescription.Text = buildingProject.DescriptionShort;
            BpOwner.Text = buildingProject.BuilderName;

            webservice.Dispose();

            if (Session["BpName"] != null)
            {
                BuildingProject.Text = Session["BpName"].ToString();
            }

            RefreshNewEmailCount();
            RefreshOpenProcessCount();
            RefreshPresentPersonsCount();
            RefreshMissingFirstAiders();
            RefreshAvailableFirstAiders();
            RefreshAppInfo();
            RefreshExpiringTariffs();

            // Rechte für Anzeige von Nachrichten und Vorgängen
            PanelMailbox.Visible = Helpers.HasRightForDialog("MailBox");
            PanelProcessEvents.Visible = Helpers.HasRightForDialog("ProcessEvents");
            PanelProcessEventsCentral.Visible = Helpers.HasRightForDialog("ProcessEventsCentral");
        }

        private void ShowWelcome()
        {
            // Helpers.Notification(this.Page.Master, Resources.Resource.lblLogin, Resources.Resource.msgWelcome + "<br/><br/>" + Resources.Resource.lblBuildingProject + ": " + Session["BpName"].ToString());
        }

        private void RefreshOpenProcessCount()
        {
            int unread = Helpers.GetOpenProcessCount();
            if (unread > 0)
            {
                LabelProcessEvents.Text = unread.ToString() + " " + Resources.Resource.lblOpenProcesses;
                LabelProcessEvents.ForeColor = Color.Blue;
                LabelProcessEvents.Font.Bold = true;
            }
            else
            {
                LabelProcessEvents.Text = Resources.Resource.lblNoOpenProcess;
                LabelProcessEvents.ForeColor = Color.Black;
                LabelProcessEvents.Font.Bold = false;
            }

            unread = Helpers.GetOpenProcessCount(0);
            if (unread > 0)
            {
                LabelProcessEventsCentral.Text = unread.ToString() + " " + Resources.Resource.lblOpenProcesses;
                LabelProcessEventsCentral.ForeColor = Color.Blue;
                LabelProcessEventsCentral.Font.Bold = true;
            }
            else
            {
                LabelProcessEventsCentral.Text = Resources.Resource.lblNoOpenProcess;
                LabelProcessEventsCentral.ForeColor = Color.Black;
                LabelProcessEventsCentral.Font.Bold = false;
            }
        }

        private void RefreshNewEmailCount()
        {
            int unread = Helpers.GetUnreadMailCount();
            if (unread > 0)
            {
                IconMailbox.ImageUrl = "~/Resources/Icons/mail-unread-new_128.png";
                LabelMailbox.Text = unread.ToString() + " " + Resources.Resource.lblNewMessages;
                LabelMailbox.ForeColor = Color.Red;
                LabelMailbox.Font.Bold = true;
            }
            else
            {
                IconMailbox.ImageUrl = "~/Resources/Icons/mail-mark-read-2.png";
                LabelMailbox.Text = Resources.Resource.lblNoNewMessage;
                LabelMailbox.ForeColor = Color.Black;
                LabelMailbox.Font.Bold = false;
            }
        }

        private void RefreshPresentPersonsCount()
        {
            GetPresentPersonsCount_Result persons = Helpers.GetPresentPersonsCount();
            
            LabelEmployeesPresent.Text = persons.EmployeesCount.ToString();
            
            if (persons.EmployeesFaultyCount > 0)
            {
                LabelEmployeesFaulty.Text = persons.EmployeesFaultyCount.ToString();
                LabelEmployeesFaulty.Visible = true;
                LabelEmployeesFaultyHeader.Visible = true;
            }
            else
            {
                LabelEmployeesFaulty.Text = string.Empty;
                LabelEmployeesFaulty.Visible = false;
                LabelEmployeesFaultyHeader.Visible = false;
            }
            
            LabelVisitorsPresent.Text = persons.VisitorCount.ToString();
            
            if (persons.VisitorFaultyCount > 0)
            {
                LabelVisitorsFaulty.Text = persons.VisitorFaultyCount.ToString();
                LabelVisitorsFaulty.Visible = true;
                LabelVisitorsFaultyHeader.Visible = true;
            }
            else
            {
                LabelVisitorsFaulty.Text = string.Empty;
                LabelVisitorsFaulty.Visible = false;
                LabelVisitorsFaultyHeader.Visible = false;
            }

            if (persons.LastAccess != null)
            {
                LabelLastAccess.Text = ((DateTime)persons.LastAccess).ToString("G");
                ImageLastEvent.ImageUrl = "/InSiteApp/Resources/Icons/enter-16.png";
                ImageLastEvent.ToolTip = Resources.Resource.lblAccess;
                if (persons.LastExit != null && DateTime.Compare((DateTime)persons.LastExit, (DateTime)persons.LastAccess) > 0)
                {
                    LabelLastAccess.Text = ((DateTime)persons.LastExit).ToString("G");
                    ImageLastEvent.ImageUrl = "/InSiteApp/Resources/Icons/exit-16.png";
                    ImageLastEvent.ToolTip = Resources.Resource.lblLeaving;
                }
            }

            Webservices webservice = new Webservices();
            Master_AccessSystems accessSystem = webservice.GetLastUpdateAccessControl();
            if (accessSystem != null)
            {
                DateTime lastCorrection = webservice.GetLastCorrectionDate();
                LastCorrection.Text = lastCorrection.ToString("G");

                DateTime lastUpdate = new DateTime(2000, 1, 1);
                if (accessSystem.LastUpdate != null)
                {
                    lastUpdate = (DateTime)accessSystem.LastUpdate;
                    LabelLastUpdate.Text = lastUpdate.ToString("G");
                }
                else
                {
                    LabelLastUpdate.Text = Resources.Resource.lblNever;
                }

                TimeSpan timeSpan = DateTime.Now - lastUpdate;

                if (timeSpan.TotalSeconds > Convert.ToDouble(ConfigurationManager.AppSettings["ACSOfflineTrigger"]))
                {
                    Signal.ImageUrl = "/InSiteApp/Resources/Icons/Offline_24.png";
                    Signal.ToolTip = Resources.Resource.msgAccessControlSystemOffline;
                    Terminals.ImageUrl = "/InSiteApp/Resources/Icons/TerminalsOffline_24.png";
                    Terminals.ToolTip = Resources.Resource.msgAccessTerminalsOffline;
                }
                else
                {
                    Signal.ImageUrl = "/InSiteApp/Resources/Icons/Online_24.png";
                    Signal.ToolTip = Resources.Resource.msgAccessControlSystemOnline;
                    if (accessSystem.AllTerminalsOnline)
                    {
                        Terminals.ImageUrl = "/InSiteApp/Resources/Icons/TerminalsOnline_24.png";
                        Terminals.ToolTip = Resources.Resource.msgAccessTerminalsOnline;
                    }
                    else
                    {
                        Terminals.ImageUrl = "/InSiteApp/Resources/Icons/TerminalsOffline_24.png";
                        Terminals.ToolTip = Resources.Resource.msgAccessTerminalsOffline;
                    }
                }
            }

            GetPresentPersonsPerAccessArea_Result[] result = webservice.GetPresentPersonsPerAccessArea();
            PresentPersonsPerAccessArea.DataSource = result;
            PresentPersonsPerAccessArea.DataBind();
        }

        private void RefreshMissingFirstAiders()
        {
            Webservices webservice = new Webservices();
            GetMissingFirstAiders_Result[] result = webservice.GetMissingFirstAiders();

            if (result != null)
            {
                bool hasMfa = false;
                int fapCount = 0;
                int farCount = 0;

                List<GetMissingFirstAiders_Result> mfas = new List<GetMissingFirstAiders_Result>();

                foreach (GetMissingFirstAiders_Result mfa in result)
                {
                    if (mfa.MinAiders > mfa.FirstAidersPresent)
                    {
                        hasMfa = true;
                        mfas.Add(mfa);
                    }
                    fapCount += (int)mfa.FirstAidersPresent;
                    farCount += (int)mfa.MinAiders;
                }

                if (hasMfa)
                {
                    if (fapCount < farCount)
                    {
                        ImageMissingFirstAiders.ImageUrl = "/InSiteApp/Resources/Images/signal_3_red_24.png";
                        ImageMissingFirstAiders.ToolTip = Resources.Resource.msgFARed;
                    }
                    else
                    {
                        ImageMissingFirstAiders.ImageUrl = "/InSiteApp/Resources/Images/signal_3_yellow_24.png";
                        ImageMissingFirstAiders.ToolTip = Resources.Resource.msgFAYellow;
                    }
                }
                else
                {
                    ImageMissingFirstAiders.ImageUrl = "/InSiteApp/Resources/Images/signal_3_green_24.png";
                    ImageMissingFirstAiders.ToolTip = Resources.Resource.msgFAGreen;
                }
                if (hasMfa)
                {
                    FirstAidersMissed.DataSource = mfas.ToArray();
                }
                else
                {
                    FirstAidersMissed.DataSource = null;
                }
                FirstAidersMissed.DataBind();
            }
        }

        private void RefreshAvailableFirstAiders()
        {
            Webservices webservice = new Webservices();
            lstAvailableFirstAiders.DataSource = webservice.GetAvailableFirstAiders();
            lstAvailableFirstAiders.DataBind();
        }

        private void RefreshAppInfo()
        {
            if (Helpers.IsSysAdmin())
            {
                PanelAppInfo.Visible = true;

                AppVersion.Text = Helpers.AppFileVersion() + " (" + Helpers.AppDate().ToShortDateString() + ")";
                Webservices webservice = new Webservices();
                DateTime lastBackup = webservice.GetLastBackupDate();
                LastBackup.Text = lastBackup.ToString("G");
                DateTime lastCompress = webservice.GetLastCompressDate();
                Session["LastCompress"] = lastCompress;
                LastCompress.Text = lastCompress.ToString("G");
            }
            else
            {
                PanelAppInfo.Visible = false;
            }
        }

        private void RefreshExpiringTariffs()
        {
            Webservices webservice = new Webservices();
            GetExpiringTariffs_Result[] result = webservice.GetExpiringTariffs();
            ExpiringTariffs.DataSource = result;
            ExpiringTariffs.DataBind();
        }

        protected void BtnRefresh_Click(object sender, EventArgs e)
        {
            RefreshNewEmailCount();
            RefreshOpenProcessCount();
            RefreshPresentPersonsCount();
            RefreshMissingFirstAiders();
            RefreshAvailableFirstAiders(); 
            RefreshAppInfo();
            RefreshExpiringTariffs();
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            Session["Tick"] = "1";
            RefreshNewEmailCount();
            RefreshOpenProcessCount();
            RefreshPresentPersonsCount();
            RefreshMissingFirstAiders();
            RefreshAvailableFirstAiders();
        }
    }
}