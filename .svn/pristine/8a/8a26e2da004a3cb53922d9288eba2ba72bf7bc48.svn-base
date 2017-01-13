using InSite.App.Constants;
using InSite.App.Models;
using Stimulsoft.Report;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Stimulsoft.Report.Dictionary;
using System.Configuration;
using InSite.App.BLL;
using InSite.App.UserServices;
using InSite.App.Models.Extensions;
using System.Threading;
using System.Globalization;

namespace InSite.App.Views.Main
{
    public partial class StiReportViewer : System.Web.UI.Page
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private string messageTitle = null;
        private string gridMessage = null;
        private string messageColor = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                UserAssignments user = Helpers.GetCurrentUserAssignment();
                string companyName = "";
                if (!user.Company.Equals(string.Empty))
                {
                    companyName = " (" + user.Company + ")";
                }

                Session["currentCulture"] = user.LanguageID;
                Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(user.LanguageID);
                Thread.CurrentThread.CurrentUICulture = new CultureInfo(user.LanguageID);

                lblReportGroup.Text = Resources.Resource.lblReports;
                Page.Title = Resources.Resource.lblReports;
                lblName.Text = Resources.Resource.lblCostLocationNameVisible;

                Session["TreeViewNodeID"] = Helpers.GetTreeNodeID(type.Name);
                Helpers.DialogLogger(type, Actions.View, "0", Resources.Resource.lblActionView);

                if (ReportsDataSource.Select().OfType<clsReport>().Count() > 0)
                {
                    lblInfo.Text = Resources.Resource.msgSelectReport;
                    RadComboBox1.Enabled = true;
                }
                else
                {
                    lblInfo.Text = Resources.Resource.msgNoneReport;
                    RadComboBox1.Enabled = false;
                }
            }

            StiWebViewer1.Localization = string.Format("{0}\\Reports\\Localization\\{1}.xml", HttpContext.Current.Server.MapPath("~"), Session["currentCulture"]);
            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, true);
        }


        private void SetMessage(string command, string message, string color)
        {
            // Message-Variablen belegen
            messageTitle = command;
            gridMessage = message;
            messageColor = color;
        }
        protected void RadComboBox1_SelectedIndexChanged(object sender, Telerik.Web.UI.RadComboBoxSelectedIndexChangedEventArgs e)
        {
            RadComboBox1.Items[0].Visible = false;
            
            if (Convert.ToInt32(e.Value)>0)
            {
                StiReport report = new StiReport();
                clsReport rep = dtoReport.GetById(Convert.ToInt32(e.Value));

                report.LoadPackedReportFromString(rep.ReportData);
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

                report.ReportName = rep.Name;
                report.ReportDescription = rep.Description;
                report.ReportAuthor = Helpers.GetUser(Convert.ToInt32(Session["UserID"])).LoginName;
                report.ReportAlias = Helpers.GetBpName(Convert.ToInt32(Session["BpId"]));
                try
                {
                    StiWebViewer1.Report = report;
                    StiWebViewer1.Visible = true;
                    lblInfo.Visible = false;
                }
                catch (Exception)
                {

                }

            }
        }

        protected void ReportsDataSource_Selecting(object sender, ObjectDataSourceSelectingEventArgs e)
        {
            UserAssignments user = Helpers.GetCurrentUserAssignment();

            int[] values = (int[])Enum.GetValues(typeof(ReportRoles));
            var dict = new Dictionary<int, string>();

            for (int i = 0; i < values.Length; i++)
            {
                    dict.Add(values[i], ((ReportRoles)values[i]).GetDisplayName());
            }

            e.InputParameters["BpId"] = Session["BpId"];
            e.InputParameters["isAdmin"] = Helpers.IsSysAdmin();

            if (dict.ContainsValue(user.RoleName))
                e.InputParameters["reportRoleId"] = dict.Where(x=>x.Value == user.RoleName).First().Key;
            else
                e.InputParameters["reportRoleId"] = 0;
        }

    }
}