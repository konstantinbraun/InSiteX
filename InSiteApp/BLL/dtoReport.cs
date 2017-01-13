using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using InSite.App.Models;
using System.Data.SqlClient;
using InSite.App.Models.Extensions;

namespace InSite.App.BLL
{
    [DataObjectAttribute]
    public class dtoReport
    {
        [DataObjectMethod( DataObjectMethodType.Insert, true )]
        public void Insert(clsReport model)
        {
            string queryString = "INSERT INTO System_Reports (Name, Description, ReportVisibility) ";
            queryString += "VALUES (@Name, @Description, @ReportVisibility)";

            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);

                command.Parameters.AddWithValue("@Name", model.Name);
                if (model.Description!=null)
                    command.Parameters.AddWithValue("@Description", model.Description);
                else
                    command.Parameters.AddWithValue("@Description", "");

                command.Parameters.AddWithValue("@ReportVisibility", model.ReportVisibility);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }
        }

        [DataObjectMethod(DataObjectMethodType.Update, true)]
        public void Update(clsReport model)
        {
            string queryString = "UPDATE System_Reports ";
            queryString += "SET Name= @Name, Description = @Description, ReportVisibility = @ReportVisibility ";
            queryString += "WHERE ReportId = @Id";

            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);

                command.Parameters.AddWithValue("@Name", model.Name);
                command.Parameters.AddWithValue("@Description", model.Description);
                command.Parameters.AddWithValue("@ReportVisibility", model.ReportVisibility);
                command.Parameters.AddWithValue("@Id", model.Id);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
                catch (Exception ex)
                {
                   
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }

        }

        public static int UpdateReportData(int ReportId, string reportData)
        {
            string queryString = "UPDATE System_Reports ";
            queryString += "SET ReportData = @Report ";
            queryString += "WHERE ReportId = @Id";
            int code = 0;

            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);

                command.Parameters.AddWithValue("@Report", reportData);
                command.Parameters.AddWithValue("@Id", ReportId);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    code = 1;
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }
            return code;
        }

        [DataObjectMethod(DataObjectMethodType.Delete, true)]
        public void Delete(clsReport model)
        {
            string queryString = "DELETE FROM System_Reports ";
            queryString += "WHERE ReportId = @Id";

            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@Id", model.Id);
                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }

        }

        [DataObjectMethod(DataObjectMethodType.Select, true)]
        public List<clsReport> GetAll()
        {
            List<clsReport> reports = new List<clsReport>();
            string queryString = "SELECT * FROM System_Reports ORDER BY Name";
            return  GetReportFromDb(queryString, null);
        }

        public static clsReport GetById(int id)
        {
            string queryString = "SELECT * FROM System_Reports WHERE ReportId = @Id";

            SqlParameter[] parameters = new SqlParameter[1];
            parameters[0] = new SqlParameter("@Id", id);

            return GetReportFromDb(queryString, parameters).FirstOrDefault();
        }

        [DataObjectMethod(DataObjectMethodType.Select, false )]
        public List<clsReport> GetReportsForProject(int bpId, int reportRoleId, bool isAdmin)
        {
            List<clsReport> reports = new List<clsReport>();

            string queryString = "SELECT Rep.* ";
            queryString += "FROM System_Reports AS Rep INNER JOIN ";
            queryString += "System_ReportToProject AS RtP ON Rep.ReportId = RtP.ReportId INNER JOIN ";
            queryString += "System_ReportToRole AS Rpr ON Rep.ReportId = Rpr.ReportId ";
            queryString += "WHERE RtP.BpID = @BpID AND Rep.ReportVisibility = 2 AND Rpr.ReportRoleId = @ReportRoleId";

            SqlParameter[] parameters = new SqlParameter[2];
            parameters[0] = new SqlParameter("@BpID", bpId);
            parameters[1] = new SqlParameter("@ReportRoleId", reportRoleId);

            reports = GetReportFromDb(queryString, parameters);

            if (isAdmin)
            {
                queryString = "SELECT Rep.* ";
                queryString += "FROM System_Reports AS Rep ";
                queryString += "WHERE Rep.ReportVisibility = 1";

                reports.AddRange(GetReportFromDb(queryString, null));
            }
            return reports.Where(x=>x.ReportData != null).OrderBy(x=>x.Name).ToList();
        }

        private static List<clsReport> GetReportFromDb(string sql, SqlParameter[] parameters)
        {
            List<clsReport> reports = new List<clsReport>();

            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(sql, connection);
                try
                {
                    connection.Open();
                    if (parameters != null)
                        command.Parameters.AddRange(parameters); 
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        clsReport model = new clsReport();
                        model.Id = (int)reader[0];
                        model.Name = (string)reader[1];

                        if (reader[2].GetType() != typeof(System.DBNull))
                            model.Description = (string)reader[2];

                        model.ReportVisibility = (ReportVisibility)reader[3];

                        if (reader[4].GetType() != typeof(System.DBNull))
                            model.ReportData = (string)reader[4];

                        reports.Add(model);
                    }
                    reader.Close();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }
            return reports;
        }

        [DataObjectMethod(DataObjectMethodType.Select, false)]
        public Dictionary<int, string> GetReportVisibilityDataSource()
        {
            var dict= new Dictionary<int, string>();
            int[] values = (int[])Enum.GetValues(typeof(ReportVisibility));

            for (int i = 0; i < values.Length; i++)
                dict.Add(values[i], ((ReportVisibility)values[i]).GetDisplayName());
            return dict;
        }

    }
}