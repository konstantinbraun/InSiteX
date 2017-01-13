using InSite.App.CMServices;
using System;
using System.Linq;

namespace InSite.App.Views.Costumization
{
    public partial class ContainerManagement : App.BasePage
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        protected void Page_Load(object sender, EventArgs e)
        {
            Helpers.PanelControlStateVisibility(this.Page.Master as SiteMaster, false);
        }

        protected void EmployeeExecute_Click(object sender, EventArgs e)
        {
            int systemID = Convert.ToInt32(Session["SystemID"]);
            int bpID = Convert.ToInt32(Session["BpID"]);

            ContainerManagementClient client = new ContainerManagementClient();
            string response = string.Empty;
            try
            {
                response = client.EmployeeData(systemID, bpID, Convert.ToInt32(EmployeeID.SelectedValue), Convert.ToInt32(EmployeeAction.SelectedValue));
                LastResult.Text = response;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
            }
        }

        protected void CompanyExecute_Click(object sender, EventArgs e)
        {
            int systemID = Convert.ToInt32(Session["SystemID"]);
            int bpID = Convert.ToInt32(Session["BpID"]);

            ContainerManagementClient client = new ContainerManagementClient();
            string response = string.Empty;
            try
            {
                response = client.CompanyData(systemID, bpID, Convert.ToInt32(CompanyID.SelectedValue), Convert.ToInt32(CompanyAction.SelectedValue));
                LastResult.Text = response;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
            }
        }

        protected void TradeExecute_Click(object sender, EventArgs e)
        {
            int systemID = Convert.ToInt32(Session["SystemID"]);
            int bpID = Convert.ToInt32(Session["BpID"]);

            ContainerManagementClient client = new ContainerManagementClient();
            string response = string.Empty;
            try
            {
                response = client.TradeData(systemID, bpID, Convert.ToInt32(TradeID.SelectedValue), Convert.ToInt32(TradeAction.SelectedValue));
                LastResult.Text = response;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
            }
        }

        protected void TestGetAccessRights_Click(object sender, EventArgs e)
        {
            AccessServiceInterface accessService = new AccessServiceInterface();
            accessService.GetAccessRights(); 
        }
    }
}