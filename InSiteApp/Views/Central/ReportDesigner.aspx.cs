using InSite.App.BLL;
using InSite.App.Models;
using Stimulsoft.Report;
using Stimulsoft.Report.Components;
using Stimulsoft.Report.Dictionary;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace InSite.App.Views.Central
{
    public partial class ReportDesigner :  System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["Tick"] == null)
            {
                this.CheckSessionTimeout();
            }
            else
            {
                Session["Tick"] = null;
            }

            if (Session["IsLoggedIn"] == null || !(Boolean)Session["IsLoggedIn"])
            {
                if (!Page.IsCallback)
                    Response.Redirect("~/Views/Login.aspx?Msg=PleaseLogin");
            }

            string applicationDirectory = HttpContext.Current.Server.MapPath("~");
            string reportFileDirectory = applicationDirectory + "\\Reports" ;

            StiReport masterReport = new StiReport(); 
            clsReport _report= dtoReport.GetById(Convert.ToInt32(Request["id"]));
            StiReport report = new StiReport();

            if (_report.ReportData == null)
            {
                masterReport.Load(string.Format("{0}\\ReportTemplate.mrt", reportFileDirectory));
                report.MasterReport = masterReport.SaveToString();
            }
            else
            {
                report.LoadPackedReportFromString (_report.ReportData); 
            }

            List<StiDatabase> sourceList = new List<StiDatabase>();
            foreach (StiDatabase db in report.Dictionary.Databases)
                sourceList.Add(new StiSqlDatabase(db.Name, ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString));

            report.Dictionary.Databases.Clear();
            foreach (var item in sourceList)
                report.Dictionary.Databases.Add(item);

            foreach (StiDataSource source in report.Dictionary.DataSources)
            {
                foreach (StiDataParameter param in source.Parameters)
                {
                    if (param.Name == "@BpId")
                    {
                        param.Value = Session["BpId"].ToString();
                    }
                }
            }


            foreach (StiVariable source in report.Dictionary.Variables)
            {
                if (source.Name == "Language")
                    source.Value = Helpers.CurrentLanguage();

            }

            Stimulsoft.Report.Web.StiWebDesignerOptions.MainMenu.ShowNew = false;
            Stimulsoft.Report.Web.StiWebDesignerOptions.MainMenu.ShowSaveAs = false;
            Stimulsoft.Report.Web.StiWebDesignerOptions.MainMenu.ShowClose = false;

            StiWebDesigner1.Design(report);
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

        protected void StiWebDesigner1_Exit(object sender, Stimulsoft.Report.Web.StiWebDesigner.StiExitEventArgs e)
        {
            Response.Redirect("~/Views/Central/ReportConfiguration.aspx");
        }

        protected void StiWebDesigner1_SaveReport(object sender, Stimulsoft.Report.Web.StiWebDesigner.StiSaveReportEventArgs e)
        {
            e.ErrorCode = dtoReport.UpdateReportData(Convert.ToInt32(Request["id"]), e.Report.SavePackedReportToString());  
        }

        protected void StiWebDesigner1_PreInit(object sender, Stimulsoft.Report.Web.StiWebDesigner.StiPreInitEventArgs e)
        {
            clsReport _report = dtoReport.GetById(Convert.ToInt32(Request["id"]));

            e.WebDesigner.BrowserTitle = string.Format("{0}: {1}",Resources.Resource.lblReportConfiguration ,_report.Name);
            e.WebDesigner.LocalizationDirectory = string.Format("{0}\\Reports\\Localization\\", HttpContext.Current.Server.MapPath("~"));
            e.WebDesigner.Localization = Session["currentCulture"].ToString();
        }
    }
}