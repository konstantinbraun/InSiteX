using log4net;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Telerik.Web.UI.PersistenceFramework;

namespace InSite.App
{
    public class ControlStateDBStorageProvider : IStateStorageProvider
    {
        private readonly SqlConnection connection;
        private readonly int systemID;
        private readonly int userID;
        private static readonly log4net.ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        
        public ControlStateDBStorageProvider(int systemID, int userID)
        {
            connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString);
            this.systemID = systemID;
            this.userID = userID;
        }

        public void SaveStateToStorage(string key, string serializedState)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = "SaveControlStateToDB";
            cmd.CommandType = CommandType.StoredProcedure;

            SqlParameter par;

            par = new SqlParameter();
            par.ParameterName = "@SystemID";
            par.SqlDbType = SqlDbType.Int;
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserID";
            par.SqlDbType = SqlDbType.Int;
            par.Value = userID;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserKey";
            par.SqlDbType = SqlDbType.NVarChar;
            par.Size = 200;
            par.Value = key;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserSettings";
            par.SqlDbType = SqlDbType.NVarChar;
            par.Size = -1;
            par.Value = serializedState;
            cmd.Parameters.Add(par);

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0}", ex.Message);
                throw;
            }
            catch (System.Exception ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
                throw;
            }
            finally
            {
                connection.Close();
            }
        }

        public string LoadStateFromStorage(string key)
        {
            ControlStateDBItem ret = GetStateFromStorage(key);
            return ret.UserSettings;
        }

        public ControlStateDBItem GetStateFromStorage(string key)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT * ");
            sql.Append("FROM Data_UserControlStates ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND UserID = @UserID ");
            sql.Append("AND UserKey = @UserKey ");

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = sql.ToString();
            cmd.CommandType = CommandType.Text;

            SqlParameter par;

            par = new SqlParameter();
            par.ParameterName = "@SystemID";
            par.SqlDbType = SqlDbType.Int;
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserID";
            par.SqlDbType = SqlDbType.Int;
            par.Value = userID;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserKey";
            par.SqlDbType = SqlDbType.NVarChar;
            par.Size = 200;
            par.Value = key;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            DataTable dataTable = new DataTable();

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                adapter.SelectCommand = cmd;
                adapter.Fill(dataTable);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0}", ex.Message);
                throw;
            }
            catch (System.Exception ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            ControlStateDBItem ret = new ControlStateDBItem();
            if (dataTable.Rows.Count > 0)
            {
                DataRow row = dataTable.Rows[0];
                ret.SystemID = Convert.ToInt32(row["SystemID"]);
                ret.UserID = Convert.ToInt32(row["UserID"]);
                ret.UserKey = row["UserID"].ToString();
                ret.UserSettings = row["UserSettings"].ToString();
                ret.LastUpdate = Convert.ToDateTime(row["LastUpdate"]);
            }

            return ret;
        }

        public void DeleteStateFromStorage(string key)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("DELETE FROM Data_UserControlStates ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND UserID = @UserID ");
            sql.Append("AND UserKey = @UserKey ");

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = sql.ToString();
            cmd.CommandType = CommandType.Text;

            SqlParameter par;

            par = new SqlParameter();
            par.ParameterName = "@SystemID";
            par.SqlDbType = SqlDbType.Int;
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserID";
            par.SqlDbType = SqlDbType.Int;
            par.Value = userID;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserKey";
            par.SqlDbType = SqlDbType.NVarChar;
            par.Size = 200;
            par.Value = key;
            cmd.Parameters.Add(par);

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0}", ex.Message);
                throw;
            }
            catch (System.Exception ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
                throw;
            }
            finally
            {
                connection.Close();
            }
        }

        public bool HasState(string key)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT @Count = COUNT(UserKey) ");
            sql.Append("FROM Data_UserControlStates ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND UserID = @UserID ");
            sql.Append("AND UserKey = @UserKey ");

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = connection;
            cmd.CommandText = sql.ToString();
            cmd.CommandType = CommandType.Text;

            SqlParameter par;

            par = new SqlParameter();
            par.ParameterName = "@SystemID";
            par.SqlDbType = SqlDbType.Int;
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserID";
            par.SqlDbType = SqlDbType.Int;
            par.Value = userID;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@UserKey";
            par.SqlDbType = SqlDbType.NVarChar;
            par.Size = 200;
            par.Value = key;
            cmd.Parameters.Add(par);

            par = new SqlParameter();
            par.ParameterName = "@Count";
            par.SqlDbType = SqlDbType.Int;
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            bool ret = false;

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

                if(Convert.ToInt32(cmd.Parameters["@Count"].Value) > 0)
                {
                    ret = true;
                }
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0}", ex.Message);
                throw;
            }
            catch (System.Exception ex)
            {
                logger.Error("Exception: " + ex.Message);
                if (ex.InnerException != null)
                {
                    logger.Error("Inner Exception: " + ex.InnerException.Message);
                }
                logger.Debug("Exception Details: \n" + ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            return ret;
        }
    }
}