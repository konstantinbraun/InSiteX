using InSite.App.Models.Interfaces;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace InSite.App.Models
{
    public abstract class BaseSwitcher : ISwitcher
    {
        public abstract Dictionary<int, string> GetDataSource(int masterId, bool showSelected);
        public abstract bool TransferItem(int masterId, int itemId, bool select);
        public abstract string GetKeyFieldName();
        public abstract string GetKeyTableName();
        protected List<int> GetSelectedId(int ReportId)
        {
            string queryString = string.Format( "SELECT {0} FROM {1} WHERE ReportId = @ReportId", GetKeyFieldName(), GetKeyTableName());
            List<int> selectedId = new List<int>();

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
                        selectedId.Add((int)reader[0]);
                    }
                    reader.Close();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }
            return selectedId;
        }
        public abstract string GetCaption();
    }
}