using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace InSite.App.BLL
{
    [DataObjectAttribute]
    public class dtoBpContact
    {
        [DataObjectMethodAttribute(DataObjectMethodType.Select, true)]
        public List<Models.clsBpContact> GetData(int BpId)
        {
            List<Models.clsBpContact> list = new List<Models.clsBpContact>();
            string queryString = "SELECT BpC.*, Bp.NameVisible AS BuildingProject FROM Master_Bp_Contact AS BpC INNER JOIN Master_BuildingProjects AS Bp ON BpC.BpId = Bp.BpID WHERE (BpC.BpId = @BpId)";
            SqlParameter[] parameters = new SqlParameter[] {new SqlParameter("@BpId", BpId)};

            return PrepareData(queryString, parameters);
        }

        [DataObjectMethodAttribute(DataObjectMethodType.Select, false)]
        public Dictionary<string, List<Models.clsBpContact>> GetData()
        {
            string queryString = "SELECT BpC.*, Bp.NameVisible AS BuildingProject FROM Master_Bp_Contact AS BpC INNER JOIN Master_BuildingProjects AS Bp ON BpC.BpId = Bp.BpID ORDER BY Bp.NameVisible, BpC.LastName ";
            SqlParameter[] parameters = new SqlParameter[] { };

            Dictionary<string, List<Models.clsBpContact>> dict = new Dictionary<string, List<Models.clsBpContact>>();
            foreach(Models.clsBpContact item in PrepareData(queryString, parameters))
            {
                if (dict.ContainsKey(item.BuildingProject))
                    dict[item.BuildingProject].Add(item);
                else
                {
                    dict.Add(item.BuildingProject, new List<Models.clsBpContact>() { item });
                }
            }
            return dict;
        }

        private List<Models.clsBpContact> PrepareData(string queryString, SqlParameter[] parameters)
        {
            List<Models.clsBpContact> list = new List<Models.clsBpContact>();
            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddRange(parameters);
                try
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        Models.clsBpContact model = new Models.clsBpContact();
                        model.Id = (int)reader[0];
                        model.BpId = (int)reader[1];
                        model.FirstName = (string)reader[2];
                        model.LastName = (string)reader[3];
                        if (reader[4].GetType() != typeof(System.DBNull))
                            model.Phone = (string)reader[4];
                        if (reader[5].GetType() != typeof(System.DBNull))
                            model.Email = (string)reader[5];
                        model.IsZplContact = (bool)reader[6];
                        if (reader[7].GetType() != typeof(System.DBNull))
                            model.Comments = (string)reader[7];
                        model.BuildingProject = (string)reader[8];
                        list.Add(model);
                    }
                    reader.Close();
                }
                catch (Exception ex)
                {
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }
            return list;

        }

        [DataObjectMethodAttribute(DataObjectMethodType.Insert, true)]
        public void Insert(Models.clsBpContact model)
        {
            string queryString = "INSERT INTO [Master_Bp_Contact] ([BpId], [FirstName], [LastName], [Phone], [Email], [IsZplContact], [Comments]) VALUES (@BpId, @FirstName, @LastName, @Phone, @Email, @IsZplContact, @Comments)";
            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@FirstName", model.FirstName);
                command.Parameters.AddWithValue("@LastName", model.LastName);
                if (model.Phone != null)
                    command.Parameters.AddWithValue("@Phone", model.Phone);
                else
                    command.Parameters.AddWithValue("@Phone", System.DBNull.Value);

                if (model.Email != null)
                    command.Parameters.AddWithValue("@Email", model.Email);
                else
                    command.Parameters.AddWithValue("@Email", System.DBNull.Value);

                if (model.Comments != null)
                    command.Parameters.AddWithValue("@Comments", model.Comments);
                else
                    command.Parameters.AddWithValue("@Comments", System.DBNull.Value);

                command.Parameters.AddWithValue("@IsZplContact", model.IsZplContact);
                command.Parameters.AddWithValue("@BpId", model.BpId );

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

        [DataObjectMethodAttribute(DataObjectMethodType.Delete, true)]
        public void Delete(Models.clsBpContact model)
        {
            string queryString = "DELETE FROM [Master_Bp_Contact] WHERE ([BpContactId] = @BpContactId)";
            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@BpContactId", model.Id);

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

        [DataObjectMethodAttribute(DataObjectMethodType.Update , true)]
        public void Update(Models.clsBpContact model)
        {
            string queryString = "UPDATE [Master_Bp_Contact] SET [FirstName] = @FirstName, [LastName] = @LastName, [Phone] = @Phone, [Email] = @Email, [IsZplContact] = @IsZplContact, [Comments] = @Comments WHERE [BpContactId] = @BpContactId";
            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@FirstName", model.FirstName);
                command.Parameters.AddWithValue("@LastName", model.LastName);

                if (model.Phone != null)
                    command.Parameters.AddWithValue("@Phone", model.Phone);
                else
                    command.Parameters.AddWithValue("@Phone", System.DBNull.Value );

                if (model.Email  != null)
                    command.Parameters.AddWithValue("@Email", model.Email);
                else
                    command.Parameters.AddWithValue("@Email", System.DBNull.Value);

                if (model.Comments  != null)
                    command.Parameters.AddWithValue("@Comments", model.Comments);
                else
                    command.Parameters.AddWithValue("@Comments", System.DBNull.Value);

                command.Parameters.AddWithValue("@BpContactId", model.Id);
                command.Parameters.AddWithValue("@IsZplContact", model.IsZplContact);

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
    }
}