using InSite.App.Models.Interfaces;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace InSite.App.Models
{
    public class BuildingProjectSwitcher : BaseSwitcher
    {
        public override string GetCaption()
        {
            return Resources.Resource.lblBpSelect;
        }

        public override Dictionary<int, string> GetDataSource(int masterId, bool showSelected)
        {
            IUserService webService = new UserServices.UserServiceClient();
            List<int> projectsSelectedForReport = GetSelectedId(masterId);
            return webService.GetAllBpsInfo("")
                    .Where(x => projectsSelectedForReport.Contains(x.BpID) == showSelected && x.IsVisible).OrderBy(x => x.NameVisible)
                    .ToDictionary(x => x.BpID, x => x.NameVisible );
        }

        public override string GetKeyFieldName()
        {
            return "BpId";
        }
        public override string GetKeyTableName()
        {
            return "System_ReportToProject";
        }
        public override bool TransferItem(int masterId, int itemId, bool select)
        {
            string queryString;
            int itemCount = 0;

            if (select)
                queryString = "INSERT INTO System_ReportToProject(ReportId, BpID, SystemID) VALUES (@ReportId, @BpId, 1)";
            else
                queryString = "DELETE FROM System_ReportToProject WHERE ReportId = @ReportId AND BpID = @BpId AND SystemId = 1";


            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@ReportId", masterId);
                command.Parameters.AddWithValue("@BpId", itemId);
                try
                {
                    connection.Open();
                    itemCount = command.ExecuteNonQuery();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }

            if (itemCount > 0)
                return true;
            return false;
        }

    }
}