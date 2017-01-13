using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace InSite.App.BLL
{
    [DataObjectAttribute]

    public static class dtoReportToProject
    {
        [DataObjectMethodAttribute(DataObjectMethodType.Select, false)]
        public static List<Master_BuildingProjects> GetAllBpForReport(int ReportId)
        {
            IUserService webService = new UserServices.UserServiceClient();
            List<int> projectsSelectedForReport = GetProjectIds(ReportId);
            return webService.GetAllBpsInfo("").Where(x=>!projectsSelectedForReport.Contains(x.BpID) && x.IsVisible ).OrderBy(x=> x.NameVisible ).ToList();
        }

        [DataObjectMethodAttribute(DataObjectMethodType.Select, false)]
        public static List<Master_BuildingProjects> GetSelectedBpForReport(int ReportId)
        {
            IUserService webService = new UserServices.UserServiceClient();
            List<int> projectsSelectedForReport = GetProjectIds(ReportId);
            return webService.GetAllBpsInfo("").Where(x => projectsSelectedForReport.Contains(x.BpID) && x.IsVisible).OrderBy(x => x.NameVisible).ToList();
        }

        private static List<int> GetProjectIds(int ReportId)
        {
            string queryString = "SELECT BpID FROM System_ReportToProject WHERE ReportId = @ReportId";
            List<int> projectsId = new List<int>();

            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@ReportId", ReportId);
                try
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        projectsId.Add((int)reader[0]);
                    }
                    reader.Close();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }
            return projectsId;
        }
    
    }
}