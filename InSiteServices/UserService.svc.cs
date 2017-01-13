using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Collections.Generic;
using System.Net.Mail;
using log4net;
using System.Reflection;
using System.Data.Entity.Core.Objects;
using System.Drawing;
using System.IO;
using InsiteServices.Models;
using InsiteServices.Constants;
using System.Data.Entity.Validation;
using System.Data.Entity.Core;

namespace InsiteServices
{
    [GlobalErrorBehaviorAttribute(typeof(GlobalErrorHandler))]
    public class UserService : IUserService 
    {
        private SqlConnection connection;
        private static ILog logger;
        private Insite_DevEntities entities;

        /// <summary>
        /// Standardkonstruktor
        /// </summary>
        public UserService()
        {
            // log4net.Config.XmlConfigurator.Configure();
            // GlobalContext.Properties["SessionID"] = OperationContext.Current.SessionId;
            logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            // logger.Info("UserServiceLogger initialized");
            InitializeContext();
        }

        private void InitializeContext()
        {
            entities = new Insite_DevEntities();
            if (ConfigurationManager.AppSettings["CommandTimeout"] != null)
            {
                entities.Database.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["CommandTimeout"].ToString());
            }

            connection = new SqlConnection(ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString);
        }

        /// <summary>
        /// Login to Insite
        /// </summary>
        /// <param name="userName">Login name</param>
        /// <param name="passWord">Password</param>
        /// <param name="sessionID">Session ID from Client</param>
        /// <returns>Master_Users data</returns>
        public UserAssignments[] Login(string userName, string passWord, string sessionID)
        {
            string pwd = "";
            pwd = pwd.PadLeft(passWord.Length, '*');
            logger.InfoFormat("Enter Login with params userName: {0}; passWord: {1}; sessionID: {2}", userName, pwd, sessionID);

            // First case: User is assigned to a building project and has a role
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT ");
            sql.Append("u.SystemID, ");
            sql.Append("ubp.BpID, ");
            sql.Append("bp.NameVisible BpName, ");
            sql.Append("bp.DescriptionShort BpDescription, ");
            sql.Append("bp.BuilderName, ");
            sql.Append("u.UserID, ");
            sql.Append("u.FirstName, ");
            sql.Append("u.LastName, ");
            sql.Append("u.CompanyID, ");
            sql.Append("c.NameVisible AS Company, ");
            sql.Append("u.LoginName, ");
            sql.Append("u.Password, ");
            sql.Append("ubp.RoleID, ");
            sql.Append("r.NameVisible RoleName, ");
            sql.Append("r.TypeID, ");
            sql.Append("u.LanguageID, ");
            sql.Append("u.SkinName, ");
            sql.Append("u.Email, ");
            sql.Append("u.SessionID, ");
            sql.Append("u.TreeStatus, ");
            sql.Append("u.IsVisible, ");
            sql.Append("u.IsSysAdmin, ");
            sql.Append("u.NeedsPwdChange, ");
            sql.Append("u.CreatedFrom, ");
            sql.Append("u.CreatedOn, ");
            sql.Append("u.EditFrom, ");
            sql.Append("u.EditOn ");
            sql.Append("FROM Master_Users u ");
            sql.Append("INNER JOIN Master_UserBuildingProjects ubp ");
            sql.Append("ON ubp.SystemID = u.SystemID ");
            sql.Append("AND ubp.UserID = u.UserID ");
            sql.Append("INNER JOIN Master_BuildingProjects bp ");
            sql.Append("ON bp.SystemID = ubp.SystemID ");
            sql.Append("AND bp.BpID = ubp.BpID ");
            sql.Append("INNER JOIN Master_Roles r ");
            sql.Append("ON r.SystemID = ubp.SystemID ");
            sql.Append("AND r.BpID = ubp.BpID ");
            sql.Append("AND r.RoleID = ubp.RoleID ");
            sql.Append("LEFT OUTER JOIN System_Companies c ");
            sql.Append("ON c.SystemID = u.SystemID ");
            sql.Append("AND c.CompanyID = u.CompanyID ");
            sql.Append("WHERE u.LoginName = @LoginName ");
            sql.Append("AND u.ReleaseOn IS NOT NULL ");
            sql.Append("AND u.LockedOn IS NULL ");
            sql.Append("AND bp.IsVisible = 1 ");

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql.ToString();
            command.Connection = connection;

            SqlParameter par = new SqlParameter("@LoginName", SqlDbType.NVarChar, 50);
            par.Direction = ParameterDirection.Input;
            par.Value = userName;
            command.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            DataTable dataTable = new DataTable();

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                adapter.SelectCommand = command;
                adapter.Fill(dataTable);
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            if (dataTable.Rows.Count == 0)
            {
                logger.Info("User not assigned to a building project");

                // Second case: User is assigned to a company, is not assigned to a building project, has no role and want to register company to building project
                sql.Clear();
                sql.Append("SELECT ");
                sql.Append("u.SystemID, ");
                sql.Append("0 BpID, ");
                sql.Append("'' BpName, ");
                sql.Append("'' BpDescription, ");
                sql.Append("'' BuilderName, ");
                sql.Append("u.UserID, ");
                sql.Append("u.FirstName, ");
                sql.Append("u.LastName, ");
                sql.Append("u.CompanyID, ");
                sql.Append("c.NameVisible AS Company, ");
                sql.Append("u.LoginName, ");
                sql.Append("u.Password, ");
                sql.Append("-1 RoleID, ");
                sql.Append("'' RoleName, ");
                sql.Append("0 TypeID, ");
                sql.Append("u.LanguageID, ");
                sql.Append("u.SkinName, ");
                sql.Append("u.Email, ");
                sql.Append("u.SessionID, ");
                sql.Append("u.TreeStatus, ");
                sql.Append("u.IsVisible, ");
                sql.Append("u.IsSysAdmin, ");
                sql.Append("u.NeedsPwdChange, ");
                sql.Append("u.CreatedFrom, ");
                sql.Append("u.CreatedOn, ");
                sql.Append("u.EditFrom, ");
                sql.Append("u.EditOn ");
                sql.Append("FROM Master_Users u ");
                sql.Append("INNER JOIN System_Companies c ");
                sql.Append("ON c.SystemID = u.SystemID ");
                sql.Append("AND c.CompanyID = u.CompanyID ");
                sql.Append("WHERE u.LoginName = @LoginName ");
                sql.Append("AND u.ReleaseOn IS NOT NULL ");
                sql.Append("AND u.LockedOn IS NULL ");
                sql.Append("AND c.ReleaseOn IS NOT NULL ");
                sql.Append("AND c.LockedOn IS NULL ");

                command = new SqlCommand();
                command.CommandType = CommandType.Text;
                command.CommandText = sql.ToString();
                command.Connection = connection;

                par = new SqlParameter("@LoginName", SqlDbType.NVarChar, 50);
                par.Direction = ParameterDirection.Input;
                par.Value = userName;
                command.Parameters.Add(par);

                adapter = new SqlDataAdapter();
                dataTable = new DataTable();

                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }
                try
                {
                    // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                    adapter.SelectCommand = command;
                    adapter.Fill(dataTable);
                }
                catch (SqlException ex)
                {
                    logger.Error("SqlException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
                finally
                {
                    connection.Close();
                }
            }

            List<UserAssignments> users = new List<UserAssignments>();
            if (dataTable.Rows.Count >= 1)
            {
                logger.Info("User found");
                String userPassWord = dataTable.Rows[0]["Password"].ToString();
                if (Helpers.VerifyUnHashedPassword(userPassWord, passWord))
                {
                    logger.Info("Password verified");

                    // Set session id and last login date
                    sql = new StringBuilder();
                    sql.Append("UPDATE Master_Users ");
                    sql.Append("SET SessionID = @SessionID, ");
                    sql.Append("LastLogin = @LastLogin ");
                    sql.Append("WHERE SystemID = @SystemID ");
                    sql.Append("AND UserID = @UserID ");

                    command = new SqlCommand();
                    command.CommandType = CommandType.Text;
                    command.CommandText = sql.ToString();
                    command.Connection = connection;

                    par = new SqlParameter("@SessionID", SqlDbType.NVarChar, 200);
                    par.Value = sessionID;
                    command.Parameters.Add(par);

                    par = new SqlParameter("@LastLogin", SqlDbType.DateTime);
                    par.Value = DateTime.Now;
                    command.Parameters.Add(par);

                    int systemID = Convert.ToInt32(dataTable.Rows[0]["SystemID"]);
                    par = new SqlParameter("@SystemID", SqlDbType.Int);
                    par.Value = systemID;
                    command.Parameters.Add(par);

                    int userID = Convert.ToInt32(dataTable.Rows[0]["UserID"]);
                    par = new SqlParameter("@UserID", SqlDbType.Int);
                    par.Value = userID;
                    command.Parameters.Add(par);

                    SessionLogger(sessionID, SessionState.SessionAuthenticated, systemID, userID);

                    if (connection.State != ConnectionState.Open)
                    {
                        connection.Open();
                    }
                    try
                    {
                        command.ExecuteNonQuery();
                    }
                    catch (SqlException ex)
                    {
                        logger.Error("SqlException: ", ex);
                    }
                    catch (Exception ex)
                    {
                        logger.Error("Exception: ", ex);
                    }
                    finally
                    {
                        connection.Close();
                    }

                    foreach (DataRow row in dataTable.Rows)
                    {
                        try
                        {
                            // logger.Info("Try to translate DataModel");
                            UserAssignments user = new UserAssignments();

                            user.SystemID = (int)row["SystemID"];
                            user.BpID = (int)row["BpID"];
                            user.BpName = row["BpName"].ToString();
                            user.BpDescription = row["BpDescription"].ToString();
                            user.BuilderName = row["BuilderName"].ToString();
                            user.UserID = (int)row["UserID"];
                            user.FirstName = row["FirstName"].ToString();
                            user.LastName = row["LastName"].ToString();
                            user.CompanyID = (int)row["CompanyID"];
                            user.Company = row["Company"].ToString();
                            user.LoginName = row["LoginName"].ToString();
                            user.Password = row["Password"].ToString();
                            user.RoleID = (int)row["RoleID"];
                            user.RoleName = row["RoleName"].ToString();
                            user.TypeID = Convert.ToByte(row["TypeID"]);
                            user.LanguageID = row["LanguageID"].ToString();
                            user.SkinName = row["SkinName"].ToString();
                            user.Email = row["Email"].ToString();
                            user.SessionID = row["SessionID"].ToString();
                            user.TreeStatus = row["TreeStatus"].ToString();
                            user.IsVisible = (bool)row["IsVisible"];
                            user.IsSysAdmin = (bool)row["IsSysAdmin"];
                            user.NeedsPwdChange = (bool)row["NeedsPwdChange"];
                            user.CreatedFrom = row["CreatedFrom"].ToString();
                            user.CreatedOn = (DateTime)row["CreatedOn"];
                            user.EditFrom = row["EditFrom"].ToString();
                            user.EditOn = (DateTime)row["EditOn"];

                            users.Add(user);
                        }
                        catch (System.Exception ex)
                        {
                            logger.Error("Exception: ", ex);
                            throw ex;
                        }
                    }
                }
                else
                {
                    logger.WarnFormat("Password not verified for user {0}", userName);
                }
            }

            return users.ToArray();
        }

        /// <summary>
        /// Update string columns in Master_Users
        /// </summary>
        /// <param name="columnName">Column name</param>
        /// <param name="columnValue">Column value</param>
        /// <param name="userID">User ID</param>
        /// <param name="sessionID">Session ID</param>
        /// <returns>0 = OK, -1 = SQL error, -2 = Error</returns>
        public int UpdateUser(string columnName, string columnValue, int userID, string sessionID)
        {
            logger.InfoFormat("Enter UpdateUser with params columnName: {0}; columnValue: {1}; userID: {2}; sessionID: {3}", columnName, columnValue, userID, sessionID);

            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE Master_Users ");
            sql.AppendFormat("SET {0} = @ColumnValue ", columnName);
            sql.Append("WHERE UserID = @UserID ");
            if (!columnValue.Equals(sessionID))
            {
                sql.Append("AND SessionID LIKE @SessionID ");
            }

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql.ToString();
            command.Connection = connection;

            SqlParameter par = new SqlParameter("@ColumnValue", SqlDbType.NVarChar);
            par.Value = columnValue;
            command.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Value = userID;
            command.Parameters.Add(par);

            par = new SqlParameter("@SessionID", SqlDbType.NVarChar, 200);
            par.Value = sessionID;
            command.Parameters.Add(par);

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                command.ExecuteNonQuery();

                connection.Close();
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                return -1;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                return -2;
            }

            SessionLogger(sessionID, SessionState.SessionUsed, null, null);

            return 0;
        }

        /// <summary>
        /// Update password in Master_Users
        /// </summary>
        /// <param name="oldPwd">Old password</param>
        /// <param name="newPwd">New password</param>
        /// <param name="userID">User ID</param>
        /// <param name="sessionID">Session ID</param>
        /// <param name="userName">User who is changing the password</param>
        /// <returns>0 = OK, -1 = SQL error, -2 = Error, 1 = Old password wrong</returns>
        public int UpdatePwd(string oldPwd, string newPwd, int userID, string sessionID, string userName, bool ignore, bool needsPwdChange)
        {
            logger.InfoFormat("Enter UpdatePwd with params oldPwd: {0}; newPwd: {1}; userID: {2}; sessionID: {3}; userName: {4}; ignore: {5}; needsPwdChange: {6}", oldPwd, newPwd, userID, sessionID, userName, ignore, needsPwdChange);

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT * ");
            sql.Append("FROM Master_Users ");
            sql.Append("WHERE UserID = @UserID ");
            sql.Append("AND SessionID = @SessionID ");

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql.ToString();
            command.Connection = connection;

            SqlParameter par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = userID;
            command.Parameters.Add(par);

            par = new SqlParameter("@SessionID", SqlDbType.NVarChar, 200);
            par.Direction = ParameterDirection.Input;
            par.Value = sessionID;
            command.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            DataTable dataTable = new DataTable();

            try
            {
                // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }

                adapter.SelectCommand = command;
                adapter.Fill(dataTable);

                connection.Close();
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            DataRow row = null;
            if (!ignore)
            {
                logger.Info("Old pwd not ignored");
                if (dataTable.Rows.Count > 0)
                {
                    row = dataTable.Rows[0];
                    ignore = Helpers.VerifyUnHashedPassword(row["Password"].ToString(), oldPwd);
                }
                else
                {
                    ignore = false;
                }
                logger.InfoFormat("Old password verified: {0}", ignore);
            }

            if (ignore)
            {
                logger.Info("Update user with new password");
                sql.Clear();
                sql.Append("UPDATE Master_Users ");
                sql.Append("SET Password = @NewPwd, ");
                sql.Append("NeedsPwdChange = @NeedsPwdChange, ");
                sql.Append("EditOn = SYSDATETIME(), ");
                sql.Append("EditFrom = @UserName ");
                sql.Append("WHERE UserID = @UserID ");
                if (!needsPwdChange && dataTable.Rows.Count > 0)
                {
                    sql.Append("AND SessionID = @SessionID ");
                }

                command = new SqlCommand();
                command.CommandType = CommandType.Text;
                command.CommandText = sql.ToString();
                command.Connection = connection;

                par = new SqlParameter("@NewPwd", SqlDbType.NVarChar, 200);
                par.Direction = ParameterDirection.Input;
                par.Value = Helpers.HashPassword(newPwd);
                command.Parameters.Add(par);

                par = new SqlParameter("@NeedsPwdChange", SqlDbType.Bit);
                par.Direction = ParameterDirection.Input;
                par.Value = needsPwdChange;
                command.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Direction = ParameterDirection.Input;
                par.Value = userName;
                command.Parameters.Add(par);

                par = new SqlParameter("@UserID", SqlDbType.Int);
                par.Direction = ParameterDirection.Input;
                par.Value = userID;
                command.Parameters.Add(par);

                par = new SqlParameter("@SessionID", SqlDbType.NVarChar, 200);
                par.Direction = ParameterDirection.Input;
                par.Value = sessionID;
                command.Parameters.Add(par);

                try
                {
                    // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                    if (connection.State != ConnectionState.Open)
                    {
                        connection.Open();
                    }

                    command.ExecuteNonQuery();

                    connection.Close();
                }
                catch (SqlException ex)
                {
                    logger.Error("SqlException: ", ex);
                    return -1;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    return -2;
                }

                return 0;
            }
            else
            {
                return 1;
            }
        }

        /// <summary>
        /// Get building project information
        /// </summary>
        /// <param name="bpID">Building Project ID</param>
        /// <param name="sessionID">Session ID from Client</param>
        /// <returns>Master_BuildingProjects data</returns>
        public Master_BuildingProjects GetBpInfo(int bpID, string sessionID)
        {
            logger.InfoFormat("Enter GetBpInfo with params bpID: {0}; sessionID: {1}", bpID, sessionID);

            return entities.Master_BuildingProjects.FirstOrDefault(b => b.BpID == bpID);
        }

        /// <summary>
        /// Get all building projects information
        /// </summary>
        /// <param name="sessionID">Session ID from Client</param>
        /// <returns>Master_BuildingProjects data</returns>
        public Master_BuildingProjects[] GetAllBpsInfo(string sessionID)
        {
            logger.InfoFormat("Enter GetBpInfo with params sessionID: {0}", sessionID);

            Master_BuildingProjects[] buildingProjects = entities.Master_BuildingProjects.ToArray();

            return buildingProjects;
        }

        /// <summary>
        /// Get fields configuration
        /// </summary>
        /// <param name="systemID">System ID</param>
        /// <param name="bpID">Building Project ID</param>
        /// <param name="roleID">Role ID</param>
        /// <param name="dialogID">Dialog ID</param>
        /// <param name="sessionID">Session ID from client</param>
        /// <returns>GetFieldsConfig_Result data</returns>
        public GetFieldsConfig_Result[] GetFieldsConfig(int systemID, int bpID, int roleID, int dialogID, int actionID, string languageID, string sessionID)
        {
            logger.InfoFormat("Enter GetFieldsConfig with params systemID: {0}; bpID: {1}; roleID: {2}; dialogID: {3}; actionID: {4}; languageID: {5}", systemID, bpID, roleID, dialogID, actionID, languageID);

            ObjectResult<GetFieldsConfig_Result> result = entities.GetFieldsConfig(systemID, bpID, roleID, dialogID, actionID, languageID);
            return result.ToArray();
        }

        /// <summary>
        /// Print pass and get print data
        /// </summary>
        /// <param name="systemID">System ID</param>
        /// <param name="bpID">Building Project ID</param>
        /// <param name="employeeID">Employee ID</param>
        /// <param name="replacementPassCaseID">Replacement Pass Case ID</param>
        /// <param name="reason">Reason for printing</param>
        /// <param name="userName">User Name</param>
        /// <param name="deactivationMessage">Message for deactivated older passes</param>
        /// <param name="sessionID">Session ID from client</param>
        /// <returns>PrintPass_Result data</returns>
        public PrintPass_Result PrintPass(int systemID, int bpID, int employeeID, int replacementPassCaseID, string reason, string userName, string deactivationMessage, string sessionID)
        {
            logger.InfoFormat("Enter PrintPass with params systemID: {0}; bpID: {1}; employeeID: {2}; replacementPassCaseID: {3}; reason: {4}; userName: {5}; deactivationMessage: {6}; sessionID: {7}", systemID, bpID, employeeID, replacementPassCaseID, reason, userName, deactivationMessage, sessionID);

            ObjectResult<PrintPass_Result> result = entities.PrintPass(systemID, bpID, employeeID, replacementPassCaseID, reason, userName, deactivationMessage);
            PrintPass_Result[] pass = result.ToArray();
            PrintPass_Result ret = new PrintPass_Result();
            if (pass.Count() > 0)
            {
                ret = pass[0];
            }
            return ret;
        }

        /// <summary>
        /// Activate pass
        /// </summary>
        /// <param name="systemID">System ID</param>
        /// <param name="bpID">Building Project ID</param>
        /// <param name="employeeID">Employee ID</param>
        /// <param name="internalID">Internal Pass ID</param>
        /// <param name="userName">User Name</param>
        /// <param name="sessionID">Session ID from client</param>
        /// <returns>0</returns>
        public int ActivatePass(int systemID, int bpID, int employeeID, string internalID, string userName, string sessionID)
        {
            logger.InfoFormat("Enter ActivatePass with params systemID: {0}; bpID: {1}; employeeID: {2}; internalID: {3}; userName: {4}; sessionID: {5}", systemID, bpID, employeeID, internalID, userName, sessionID);

            int result = entities.ActivatePass(systemID, bpID, employeeID, internalID, userName);
            return result;
        }

        /// <summary>
        /// DeactivatePass pass
        /// </summary>
        /// <param name="systemID">System ID</param>
        /// <param name="bpID">Building Project ID</param>
        /// <param name="employeeID">Employee ID</param>
        /// <param name="internalID">Internal Pass ID</param>
        /// <param name="reason">Reason for deactivating</param>
        /// <param name="userName">User Name</param>
        /// <param name="sessionID">Session ID from client</param>
        /// <returns>0</returns>
        public int DeactivatePass(int systemID, int bpID, int employeeID, string internalID, string reason, string userName, string sessionID)
        {
            logger.InfoFormat("Enter DeactivatePass with params systemID: {0}; bpID: {1}; employeeID: {2}; internalID: {3}; reason: {4}; userName: {5}; sessionID: {6}", systemID, bpID, employeeID, internalID, reason, userName, sessionID);

            int result = entities.DeactivatePass(systemID, bpID, employeeID, internalID, reason, userName);
            return result;
        }

        /// <summary>
        /// LockPass pass
        /// </summary>
        /// <param name="systemID">System ID</param>
        /// <param name="bpID">Building Project ID</param>
        /// <param name="employeeID">Employee ID</param>
        /// <param name="reason">Reason for locking</param>
        /// <param name="userName">User Name</param>
        /// <param name="sessionID">Session ID from client</param>
        /// <returns>0</returns>
        public int LockPass(int systemID, int bpID, int employeeID, string reason, string userName, string sessionID)
        {
            logger.InfoFormat("Enter LockPass with params systemID: {0}; bpID: {1}; employeeID: {2}; reason: {3}; userName: {4}; sessionID: {5}", systemID, bpID, employeeID, reason, userName, sessionID);

            int result = entities.LockPass(systemID, bpID, employeeID, reason, userName);
            return result;
        }

        /// <summary>
        /// IsFirstPass pass
        /// </summary>
        /// <param name="systemID">System ID</param>
        /// <param name="bpID">Building Project ID</param>
        /// <param name="employeeID">Employee ID</param>
        /// <param name="sessionID">Session ID from client</param>
        /// <returns>true = First pass for this employee; false = replacement pass</returns>
        public bool IsFirstPass(int systemID, int bpID, int employeeID, string sessionID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT * ");
            sql.Append("FROM Master_Passes ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND EmployeeID = @EmployeeID ");

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql.ToString();
            command.Connection = connection;

            SqlParameter par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = systemID;
            command.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = bpID;
            command.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = employeeID;
            command.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            DataTable dataTable = new DataTable();

            try
            {
                // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }

                adapter.SelectCommand = command;
                adapter.Fill(dataTable);

                connection.Close();

                if (dataTable.Rows.Count > 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
        }

        /// <summary>
        /// ValidateRegistrationCode
        /// </summary>
        /// <param name="code">Code to validate</param>
        /// <param name="sessionID">Session ID</param>
        /// <returns>EmployeeRegistrationData for assigned company</returns>
        public EmployeeRegistrationData ValidateRegistrationCode(string code, string sessionID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT c.SystemID, c.BpID, c.CompanyID, c.NameVisible AS CompanyName, c.CodeValidUntil, b.NameVisible AS BpName ");
            sql.Append("FROM Master_Companies c, Master_BuildingProjects b ");
            sql.Append("WHERE c.RegistrationCode = @RegistrationCode ");
            sql.Append("AND b.SystemID = c.SystemID ");
            sql.Append("AND b.BpID = c.BpID ");

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql.ToString();
            command.Connection = connection;

            SqlParameter par = new SqlParameter("@RegistrationCode", SqlDbType.NVarChar, 20);
            par.Direction = ParameterDirection.Input;
            par.Value = code;
            command.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            DataTable dataTable = new DataTable();
            EmployeeRegistrationData data = new EmployeeRegistrationData();

            try
            {
                // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }

                adapter.SelectCommand = command;
                adapter.Fill(dataTable);

                if (dataTable.Rows.Count == 1)
                {
                    DataRow row = dataTable.Rows[0];

                    if (row["CodeValidUntil"] == DBNull.Value)
                    {
                        data.ReturnCode = -5;
                    }
                    else
                    {
                        DateTime codeValidUntil = Convert.ToDateTime(row["CodeValidUntil"]).Date;
                        codeValidUntil = codeValidUntil.AddHours(23).AddMinutes(59).AddSeconds(59);
                        int result = DateTime.Compare(codeValidUntil, DateTime.Now);

                        if (result >= 0)
                        {
                            // Validation ok
                            data.SystemID = Convert.ToInt32(row["SystemID"]);
                            data.BpID = Convert.ToInt32(row["BpID"]);
                            data.BpName = row["BpName"].ToString();
                            data.CompanyID = Convert.ToInt32(row["CompanyID"]);
                            data.CompanyName = row["CompanyName"].ToString();
                            data.ReturnCode = 0;
                        }
                        else
                        {
                            // Valid until date expired
                            data.ReturnCode = -1;
                        }
                    }
                    return data;
                }
                else
                {
                    // Code not found
                    data.ReturnCode = -2;
                    return data;
                }
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                data.ReturnCode = -3;
                data.ReturnMessage = ex.Message;
                return data;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                data.ReturnCode = -4;
                data.ReturnMessage = ex.Message;
                return data;
            }
            finally
            {
                connection.Close();
            }
        }

        /// <summary>
        /// LoginNameIsUnique
        /// </summary>
        /// <param name="code">Login name</param>
        /// <param name="sessionID">Session ID</param>
        /// <returns>true: Login name is unique; false: Login name exists</returns>
        public bool LoginNameIsUnique(string loginName, string sessionID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT * ");
            sql.Append("FROM Master_Users ");
            sql.Append("WHERE LoginName = @LoginName ");

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql.ToString();
            command.Connection = connection;

            SqlParameter par = new SqlParameter("@LoginName", SqlDbType.NVarChar, 50);
            par.Direction = ParameterDirection.Input;
            par.Value = loginName;
            command.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            DataTable dataTable = new DataTable();

            try
            {
                // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }

                adapter.SelectCommand = command;
                adapter.Fill(dataTable);

                if (dataTable.Rows.Count > 0)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }
        }

        /// <summary>
        /// Get all users with specific Role
        /// </summary>
        /// <param name="typeID">Role type ID</param>
        /// <param name="sessionID">Session ID from Client</param>
        /// <returns>Master_Users data</returns>
        public UserAssignments[] GetUsersWithRole(int systemID, int bpID, int typeID, string sessionID)
        {
            logger.InfoFormat("Enter GetUsersWithRole with params systemID: {0}; bpID: {1}; typeID: {2}; sessionID: {3}", systemID, bpID, typeID, sessionID);

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT ");
            sql.Append("u.SystemID, ");
            sql.Append("ubp.BpID, ");
            sql.Append("bp.NameVisible BpName, ");
            sql.Append("bp.DescriptionShort BpDescription, ");
            sql.Append("bp.BuilderName, ");
            sql.Append("u.UserID, ");
            sql.Append("u.FirstName, ");
            sql.Append("u.LastName, ");
            sql.Append("u.CompanyID, ");
            sql.Append("c.NameVisible AS Company, ");
            sql.Append("u.LoginName, ");
            sql.Append("u.Password, ");
            sql.Append("ubp.RoleID, ");
            sql.Append("r.NameVisible RoleName, ");
            sql.Append("r.TypeID, ");
            sql.Append("u.LanguageID, ");
            sql.Append("u.SkinName, ");
            sql.Append("u.Email, ");
            sql.Append("u.UseEmail, ");
            sql.Append("u.SessionID, ");
            sql.Append("u.IsVisible, ");
            sql.Append("u.NeedsPwdChange, ");
            sql.Append("u.CreatedFrom, ");
            sql.Append("u.CreatedOn, ");
            sql.Append("u.EditFrom, ");
            sql.Append("u.EditOn ");
            sql.Append("FROM Master_Users u ");
            sql.Append("INNER JOIN Master_UserBuildingProjects ubp ");
            sql.Append("ON ubp.SystemID = u.SystemID ");
            sql.Append("AND ubp.UserID = u.UserID ");
            sql.Append("INNER JOIN Master_BuildingProjects bp ");
            sql.Append("ON bp.SystemID = ubp.SystemID ");
            sql.Append("AND bp.BpID = ubp.BpID ");
            sql.Append("INNER JOIN Master_Roles r ");
            sql.Append("ON r.SystemID = ubp.SystemID ");
            sql.Append("AND r.BpID = ubp.BpID ");
            sql.Append("AND r.RoleID = ubp.RoleID ");
            sql.Append("LEFT OUTER JOIN System_Companies c ");
            sql.Append("ON c.SystemID = u.SystemID ");
            sql.Append("AND c.CompanyID = u.CompanyID ");
            sql.Append("WHERE u.SystemID = @SystemID ");
            sql.Append("AND ubp.BpID = @BpID ");
            sql.Append("AND r.TypeID = @TypeID ");
            sql.Append("AND r.BpID != 0 ");

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql.ToString();
            command.Connection = connection;

            SqlParameter par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = systemID;
            command.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = bpID;
            command.Parameters.Add(par);

            par = new SqlParameter("@TypeID", SqlDbType.Int);
            par.Direction = ParameterDirection.Input;
            par.Value = typeID;
            command.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            DataTable dataTable = new DataTable();

            try
            {
                // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }

                adapter.SelectCommand = command;
                adapter.Fill(dataTable);

                connection.Close();
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            List<UserAssignments> users = new List<UserAssignments>();
            if (dataTable.Rows.Count >= 1)
            {
                foreach (DataRow row in dataTable.Rows)
                {
                    try
                    {
                        // logger.Info("Try to translate DataModel");
                        UserAssignments user = new UserAssignments();

                        user.SystemID = (int)row["SystemID"];
                        user.BpID = (int)row["BpID"];
                        user.BpName = row["BpName"].ToString();
                        user.BpDescription = row["BpDescription"].ToString();
                        user.BuilderName = row["BuilderName"].ToString();
                        user.UserID = (int)row["UserID"];
                        user.FirstName = row["FirstName"].ToString();
                        user.LastName = row["LastName"].ToString();
                        user.CompanyID = (int)row["CompanyID"];
                        user.Company = row["Company"].ToString();
                        user.LoginName = row["LoginName"].ToString();
                        user.Password = row["Password"].ToString();
                        user.RoleID = (int)row["RoleID"];
                        user.RoleName = row["RoleName"].ToString();
                        user.TypeID = (byte)row["TypeID"];
                        user.LanguageID = row["LanguageID"].ToString();
                        user.SkinName = row["SkinName"].ToString();
                        user.Email = row["Email"].ToString();
                        user.UseEmail = (bool)row["UseEmail"];
                        user.IsVisible = (bool)row["IsVisible"];
                        user.NeedsPwdChange = (bool)row["NeedsPwdChange"];
                        user.CreatedFrom = row["CreatedFrom"].ToString();
                        user.CreatedOn = (DateTime)row["CreatedOn"];
                        user.EditFrom = row["EditFrom"].ToString();
                        user.EditOn = (DateTime)row["EditOn"];

                        users.Add(user);
                    }
                    catch (Exception ex)
                    {
                        logger.Error("Exception: ", ex);
                        throw;
                    }
                }
            }

            return users.ToArray();
        }

        /// <summary>
        /// Returns the rule ID of applied rule for current employee
        /// </summary>
        /// <param name="systemID">System ID</param>
        /// <param name="bpID">Building project ID</param>
        /// <param name="employeeID">Employee ID</param>
        /// <param name="sessionID">Session ID</param>
        /// <returns>Rule ID or -1 if null</returns>
        public int GetAppliedRule(int systemID, int bpID, int employeeID, string sessionID)
        {
            logger.InfoFormat("Enter GetAppliedRule with params systemID: {0}; bpID: {1}; employeeID: {2}; sessionID: {3}", systemID, bpID, employeeID, sessionID);

            ObjectResult<int?> result = entities.GetAppliedRule(systemID, bpID, employeeID);
            int? ret = result.ToArray()[0].Value;
            if (ret == null)
            {
                ret = -1;
            }
            return (int)ret;
        }

        /// <summary>
        /// Get user with specific login name
        /// </summary>
        /// <param name="loginName">Login name</param>
        /// <param name="sessionID">Session ID from Client</param>
        /// <returns>Master_Users data</returns>
        public UserAssignments GetUserWithLoginName(string loginName, string sessionID)
        {
            logger.InfoFormat("Enter GetUserWithLoginName with params loginName: {0}; sessionID: {1}", loginName, sessionID);

            Master_Users userData = entities.Master_Users.FirstOrDefault(u => u.LockedOn == null && u.LoginName == loginName);

            UserAssignments user = new UserAssignments();
            if (userData != null) 
            {
                try
                {
                    // logger.Info("Try to translate DataModel");
                    user.SystemID = userData.SystemID;
                    user.BpID = 0;
                    user.BpName = "";
                    user.BpDescription = "";
                    user.BuilderName = "";
                    user.UserID = userData.UserID;
                    user.FirstName = userData.FirstName;
                    user.LastName = userData.LastName;
                    user.CompanyID = userData.CompanyID;
                    user.Company = userData.Company;
                    user.LoginName = userData.LoginName;
                    user.Password = userData.Password;
                    user.RoleID = 0;
                    user.RoleName = "";
                    user.TypeID = 0;
                    user.LanguageID = userData.LanguageID;
                    user.SkinName = userData.SkinName;
                    user.Email = userData.Email;
                    user.IsVisible = userData.IsVisible;
                    user.NeedsPwdChange = userData.NeedsPwdChange;
                    user.CreatedFrom = userData.CreatedFrom;
                    user.CreatedOn = userData.CreatedOn;
                    user.EditFrom = userData.EditFrom;
                    user.EditOn = userData.EditOn;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
            }

            return user;
        }

        /// <summary>
        /// Get next ID
        /// </summary>
        /// <param name="systemID">ID of system</param>
        /// <param name="idName">Name of ID field</param>
        /// <param name="sessionID">Session ID from Client</param>
        /// <returns>Next ID</returns>
        public int GetNextID(int systemID, string idName, string sessionID)
        {
            logger.InfoFormat("Enter GetNextID with params systemID: {0}; idName: {1}; sessionID: {2}", systemID, idName, sessionID);

            ObjectResult<int?> result = entities.GetNextID(systemID, idName);
            // logger.InfoFormat("Next ID for {0}: {1}", idName, result);
            return result.SingleOrDefault().Value;
        }

        /// <summary>
        /// PrintShortTermPasses
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="shortTermPassTypeID"></param>
        /// <param name="passCount"></param>
        /// <param name="userName"></param>
        /// <param name="sessionID"></param>
        public int PrintShortTermPasses(int systemID, int bpID, int shortTermPassTypeID, int passCount, string userName, string sessionID)
        {
            logger.InfoFormat("Enter PrintShortTermPasses with params systemID: {0}; bpID: {1}; shortTermPassTypeID: {2}; passCount: {3}; userName: {4}; sessionID: {5}", systemID, bpID, shortTermPassTypeID, passCount, userName, sessionID);

            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO Data_ShortTermPassesPrint (SystemID, BpID, PrintedFrom, PrintedOn) ");
            sql.AppendLine("VALUES (@SystemID, @BpID, @UserName, SYSDATETIME()); ");
            sql.AppendLine("SELECT @ReturnValue = SCOPE_IDENTITY(); ");
            sql.Append("SELECT @LastID = MAX(ShortTermPassID) ");
            sql.Append("FROM Data_ShortTermPasses ");

            SqlCommand cmd = new SqlCommand(sql.ToString(), connection);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = bpID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = userName;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@ReturnValue", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@LastID", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            int printID = 0;
            int passID = 0;

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                printID = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value);
                passID = Convert.ToInt32(cmd.Parameters["@LastID"].Value) + 1;
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            if (printID != 0)
            {
                sql.Clear();
                sql.Append("INSERT INTO Data_ShortTermPasses (");
                sql.Append("SystemID, ");
                sql.Append("BpID, ");
                sql.Append("ShortTermPassTypeID, ");
                sql.Append("StatusID, ");
                sql.Append("PrintID, ");
                sql.Append("BarcodeData, ");
                sql.Append("CreatedFrom, ");
                sql.Append("CreatedOn, ");
                sql.Append("EditFrom, ");
                sql.Append("EditOn ");
                sql.Append(") VALUES ( ");
                sql.Append("@SystemID, ");
                sql.Append("@BpID, ");
                sql.Append("@ShortTermPassTypeID, ");
                sql.Append("@StatusID, ");
                sql.Append("@PrintID, ");
                sql.Append("@BarcodeData, ");
                sql.Append("@UserName, ");
                sql.Append("SYSDATETIME(), ");
                sql.Append("@UserName, ");
                sql.Append("SYSDATETIME() ");
                sql.AppendLine("); ");
                sql.AppendLine("SELECT @ReturnValue = SCOPE_IDENTITY(); ");

                cmd = new SqlCommand(sql.ToString(), connection);
                par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = systemID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = bpID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ShortTermPassTypeID", SqlDbType.Int);
                par.Value = shortTermPassTypeID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = Status.Printed;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = userName;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@PrintID", SqlDbType.Int);
                par.Value = printID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BarcodeData", SqlDbType.Image);
                par.Direction = ParameterDirection.Input;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ReturnValue", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(par);

                if (connection.State != ConnectionState.Open)
                {
                    connection.Open();
                }
                try
                {
                    for (int i = 1; i <= passCount; i++)
                    {
                        Barcoder barcoder = new Barcoder();
                        byte[] barcodeData = barcoder.Encode1D(passID.ToString(), 330, 100, "CODE_39");
                        cmd.Parameters["@BarcodeData"].Value = barcodeData;

                        cmd.ExecuteNonQuery();
                        passID = Convert.ToInt32(cmd.Parameters["@ReturnValue"].Value) + 1;
                    }
                }
                catch (SqlException ex)
                {
                    logger.Error("SqlException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
                finally
                {
                    connection.Close();
                }
            }
            return printID;
        }

        /// <summary>
        /// UpdateShortTermPass
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="shortTermPassID"></param>
        /// <param name="internalID"></param>
        /// <param name="userName"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int UpdateShortTermPass(int systemID, int bpID, int shortTermPassID, string internalID, string userName, string sessionID)
        {
            logger.InfoFormat("Enter UpdateShortTermPass with params systemID: {0}; bpID: {1}; shortTermPassID: {2}; internalID: {3}; userName: {4}; sessionID: {5}", systemID, bpID, shortTermPassID, internalID, userName, sessionID);

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT @PassAssigned = ISNULL(ShortTermPassID, 0) ");
            sql.Append("FROM Data_ShortTermPasses ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND InternalID = @InternalID ");

            SqlCommand cmd = new SqlCommand(sql.ToString(), connection);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = bpID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@InternalID", SqlDbType.NVarChar, 50);
            par.Value = internalID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@PassAssigned", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            int passAssigned = 0;
            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                if (cmd.Parameters["@PassAssigned"].Value != DBNull.Value)
                {
                    passAssigned = Convert.ToInt32(cmd.Parameters["@PassAssigned"].Value);
                }
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            if (passAssigned == 0)
            {
                sql.Clear();
                sql.Append("UPDATE Data_ShortTermPasses ");
                sql.Append("SET InternalID = @InternalID, ");
                sql.Append("AssignedFrom = @UserName, ");
                sql.Append("AssignedOn = SYSDATETIME(), ");
                sql.Append("StatusID = @StatusID ");
                sql.Append("WHERE SystemID = @SystemID ");
                sql.Append("AND BpID = @BpID ");
                sql.Append("AND ShortTermPassID = @ShortTermPassID ");
                sql.Append("AND (InternalID = '' OR InternalID IS NULL) ");

                cmd = new SqlCommand(sql.ToString(), connection);
                par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = systemID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = bpID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = Status.Assigned;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ShortTermPassID", SqlDbType.Int);
                par.Value = shortTermPassID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@InternalID", SqlDbType.NVarChar, 50);
                par.Value = internalID;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = userName;
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
                    logger.Error("SqlException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
                finally
                {
                    connection.Close();
                }
            }

            return 0;
        }

        /// <summary>
        /// GetShortTermPass
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="internalID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public ShortTermPass GetShortTermPass(int systemID, int bpID, string internalID, string sessionID)
        {
            logger.InfoFormat("Enter GetShortTermPass with params systemID: {0}; bpID: {1}; internalID: {2}; sessionID: {3}", systemID, bpID, internalID, sessionID);

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT d_stp.*, m_stpt.NameVisible ShortTermPassTypeName, m_stpt.RoleID, m_stpt.TemplateID, m_stpt.ValidDays, m_stpt.ValidHours, m_stpt.ValidMinutes, m_stpt.ValidFrom ");
            sql.Append("FROM Data_ShortTermPasses d_stp, Master_ShortTermPassTypes m_stpt ");
            sql.Append("WHERE d_stp.SystemID = @SystemID ");
            sql.Append("AND d_stp.BpID = @BpID ");
            sql.Append("AND d_stp.InternalID = @InternalID ");
            sql.Append("AND m_stpt.SystemID = d_stp.SystemID ");
            sql.Append("AND m_stpt.BpID = d_stp.BpID ");
            sql.Append("AND m_stpt.ShortTermPassTypeID = d_stp.ShortTermPassTypeID ");

            SqlCommand cmd = new SqlCommand(sql.ToString(), connection);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = bpID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@InternalID", SqlDbType.NVarChar, 50);
            par.Value = internalID;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;
            DataTable dt = new DataTable();

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            ShortTermPass pass = new ShortTermPass();

            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                try
                {
                    // logger.Info("Try to translate DataModel");
                    pass.SystemID = (int)row["SystemID"];
                    pass.BpID = (int)row["BpID"];
                    pass.ShortTermPassID = (int)row["ShortTermPassID"];
                    pass.ShortTermPassTypeID = (int)row["ShortTermPassTypeID"];
                    pass.ShortTermPassTypeName = row["ShortTermPassTypeName"].ToString();
                    pass.StatusID = (int)row["StatusID"];
                    pass.InternalID = row["InternalID"].ToString();
                    if (row["ExternalID"] != DBNull.Value)
                    {
                        pass.ExternalID = row["ExternalID"].ToString();
                    }
                    if (row["ShortTermVisitorID"] != DBNull.Value)
                    {
                        pass.ShortTermVisitorID = (int)row["ShortTermVisitorID"];
                    }
                    pass.TemplateID = (int)row["TemplateID"];
                    pass.ValidFrom = (int)row["ValidFrom"];
                    pass.ValidDays = (int)row["ValidDays"];
                    pass.ValidHours = (int)row["ValidHours"];
                    pass.ValidMinutes = (int)row["ValidMinutes"];
                    pass.RoleID = (int)row["RoleID"];
                    pass.PrintedFrom = row["PrintedFrom"].ToString();
                    if (row["PrintedOn"] != DBNull.Value)
                    {
                        pass.PrintedOn = (DateTime)row["PrintedOn"];
                    }
                    pass.AssignedFrom = row["AssignedFrom"].ToString();
                    if (row["AssignedOn"] != DBNull.Value)
                    {
                        pass.AssignedOn = (DateTime)row["AssignedOn"];
                    }
                    pass.ActivatedFrom = row["ActivatedFrom"].ToString();
                    if (row["ActivatedOn"] != DBNull.Value)
                    {
                        pass.ActivatedOn = (DateTime)row["ActivatedOn"];
                    }
                    pass.DeactivatedFrom = row["DeactivatedFrom"].ToString();
                    if (row["DeactivatedOn"] != DBNull.Value)
                    {
                        pass.DeactivatedOn = (DateTime)row["DeactivatedOn"];
                    }
                    pass.LockedFrom = row["LockedFrom"].ToString();
                    if (row["LockedOn"] != DBNull.Value)
                    {
                        pass.LockedOn = (DateTime)row["LockedOn"];
                    }
                    pass.CreatedFrom = row["CreatedFrom"].ToString();
                    pass.CreatedOn = (DateTime)row["CreatedOn"];
                    pass.EditFrom = row["EditFrom"].ToString();
                    pass.EditOn = (DateTime)row["EditOn"];
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
            }

            return pass;
        }

        /// <summary>
        /// GetTreeNodeID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="dialogName"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetTreeNodeID(int systemID, string dialogName, string sessionID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT @NodeID = NodeID ");
            sql.Append("FROM Master_TreeNodes ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND NodeUrl LIKE @DialogName ");

            SqlCommand cmd = new SqlCommand(sql.ToString(), connection);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@NodeID", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@DialogName", SqlDbType.NVarChar, 200);
            if (dialogName.Contains('?'))
            {
                int pos = dialogName.IndexOf('?');
                string suffix = dialogName.Substring(pos);
                par.Value = "%/" + dialogName.Replace(suffix, string.Empty) + ".aspx" + suffix;
            }
            else
            {
                par.Value = "%/" + dialogName + ".aspx";
            }
            logger.InfoFormat("@DialogName: {0}", par.Value.ToString());
            cmd.Parameters.Add(par);

            int nodeID = 0;
            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                if (cmd.Parameters["@NodeID"].Value != DBNull.Value)
                {
                    nodeID = Convert.ToInt32(cmd.Parameters["@NodeID"].Value);
                }
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            return nodeID;
        }

        /// <summary>
        /// GetDialogResID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="dialogID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public string GetDialogResID(int systemID, int dialogID, string sessionID)
        {
            string dialogResID = string.Empty;

            System_Dialogs dialog = entities.System_Dialogs.FirstOrDefault(d => d.SystemID == systemID && d.DialogID == dialogID);
            if (dialog != null)
            {
                dialogResID = dialog.ResourceID;
            }

            return dialogResID;
        }

        /// <summary>
        /// GetDialogID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="dialogName"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetDialogID(int systemID, string dialogName, string sessionID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT @DialogID = DialogID ");
            sql.Append("FROM System_Dialogs ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND PageName LIKE @DialogName ");

            SqlCommand cmd = new SqlCommand(sql.ToString(), connection);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@DialogID", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@DialogName", SqlDbType.NVarChar, 200);
            par.Value = "%." + dialogName;
            cmd.Parameters.Add(par);

            int dialogID = 0;
            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                if (cmd.Parameters["@DialogID"].Value != DBNull.Value)
                {
                    dialogID = Convert.ToInt32(cmd.Parameters["@DialogID"].Value);
                }
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            return dialogID;
        }

        /// <summary>
        /// RowCount
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="where"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int RowCount(string tableName, Tuple<string, int>[] whereInt, Tuple<string, string>[] whereString, string sessionID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT @RowCount = COUNT(*) ");
            sql.AppendFormat("FROM {0} ", tableName);
            for (int i = 0; i < whereInt.Count(); i++)
            {
                if (i == 0)
                {
                    sql.Append("WHERE ");
                }
                else
                {
                    sql.Append("AND ");
                }
                sql.Append(whereInt[i].Item1.Remove(0, 1) + " = " + whereInt[i].Item1 + " ");
            }
            for (int i = 0; i < whereString.Count(); i++)
            {
                if (i == 0 && whereInt.Count() == 0)
                {
                    sql.Append("WHERE ");
                }
                else
                {
                    sql.Append("AND ");
                }
                sql.Append(whereInt[i].Item1.Remove(0, 1) + " = " + whereInt[i].Item1 + " ");
            }

            // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());

            SqlCommand cmd = new SqlCommand(sql.ToString(), connection);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@RowCount", SqlDbType.Int);
            par.Direction = ParameterDirection.Output;
            cmd.Parameters.Add(par);

            for (int i = 0; i < whereInt.Count(); i++)
            {
                par = new SqlParameter(whereInt[i].Item1, SqlDbType.Int);
                par.Value = Convert.ToInt32(whereInt[i].Item2);
                cmd.Parameters.Add(par);
            }

            for (int i = 0; i < whereString.Count(); i++)
            {
                par = new SqlParameter(whereString[i].Item1, SqlDbType.NVarChar, whereString[i].Item2.Length);
                par.Value = whereString[i].Item2;
                cmd.Parameters.Add(par);
            }

            int rowCount = 0;
            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                if (cmd.Parameters["@RowCount"].Value != DBNull.Value)
                {
                    rowCount = Convert.ToInt32(cmd.Parameters["@RowCount"].Value);
                }
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            return rowCount;
        }

        /// <summary>
        /// GetCompanyStatistics
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetCompanyStatistics_Result GetCompanyStatistics(int systemID, int bpID, int companyID, string sessionID)
        {
            logger.InfoFormat("Enter GetCompanyStatistics with params systemID: {0}; bpID: {1}; companyID: {2}; sessionID: {3}", systemID, bpID, companyID, sessionID);

            ObjectResult<GetCompanyStatistics_Result> result = entities.GetCompanyStatistics(systemID, bpID, companyID);

            return result.ToList()[0];
        }

        /// <summary>
        /// GetEmployees
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyCentralID"></param>
        /// <param name="companyID"></param>
        /// <param name="employeeID"></param>
        /// <param name="externalPassID"></param>
        /// <param name="employmentStatusID"></param>
        /// <param name="tradeID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetEmployees_Result[] GetEmployees(
            int systemID,
            int bpID,
            int companyCentralID,
            int companyID,
            int employeeID,
            string externalPassID,
            int employmentStatusID,
            int tradeID,
            int userID,
            string sessionID)
        {
            logger.InfoFormat("Enter GetEmployees with params systemID: {0}; bpID: {1}; companyCentralID: {2}; companyID: {3}; employeeID: {4}; externalPassID: {5}; employmentStatusID: {6}; sessionID: {7}", systemID, bpID, companyCentralID, companyID, employeeID, externalPassID, employmentStatusID, sessionID);

            GetEmployees_Result[] result = entities.GetEmployees(
                                                            systemID,
                                                            bpID,
                                                            companyCentralID,
                                                            companyID,
                                                            employeeID,
                                                            externalPassID,
                                                            employmentStatusID,
                                                            tradeID,
                                                            userID).ToArray();

            //if (employeeID == 0)
            //{
            //    foreach (GetEmployees_Result employee in result)
            //    {
            //        if (employee.PhotoData != null && employee.PhotoData.Length > 0)
            //        {
            //            Image image = Helpers.ByteArrayToImage(employee.PhotoData);
            //            string extension = Path.GetExtension(employee.PhotoFileName);
            //            employee.PhotoData = Helpers.ImageToByteArray(Helpers.ScaleImage(image, 30, 0), Helpers.ParseImageFormat(extension));
            //        }
            //    }
            //}
            return result;
        }

        /// <summary>
        /// Get photo data from employees address entry
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public byte[] GetEmployeePhotoData(int systemID, int bpID, int employeeID, string sessionID)
        {
            Master_Employees employee = entities.Master_Employees.FirstOrDefault(e => e.SystemID == systemID && e.BpID == bpID && e.EmployeeID == employeeID);
            Master_Addresses address = entities.Master_Addresses.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID && a.AddressID == employee.AddressID);
            return address.PhotoData;
        }

        /// <summary>
        /// GetEmployeeAccessAreas
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetEmployeeAccessAreas_Result[] GetEmployeeAccessAreas(int systemID, int bpID, int employeeID, string sessionID)
        {
            logger.InfoFormat("Enter GetEmployeeAccessAreas with params systemID: {0}; bpID: {1}; employeeID: {2}; sessionID: {3}", systemID, bpID, employeeID, sessionID);

            ObjectResult<GetEmployeeAccessAreas_Result> result = entities.GetEmployeeAccessAreas(systemID, bpID, employeeID);

            return result.ToArray();
        }

        /// <summary>
        /// CreateAccessRightEvent
        /// </summary>
        /// <param name="rightEvent"></param>
        /// <param name="areaEvents"></param>
        /// <param name="sessionID"></param>
        public void CreateAccessRightEvent(Data_AccessRightEvents rightEvent, Data_AccessAreaEvents[] areaEvents, string deactivationMessage, string sessionID)
        {
            logger.InfoFormat("Enter CreateAccessRightEvent for sessionID: {0}", sessionID);

            // Reset older Versions
            logger.Debug("Reset older Versions");
            try
            {
                entities.ResetAccessRights(rightEvent.SystemID, rightEvent.BpID, rightEvent.PassID, rightEvent.OwnerID, deactivationMessage);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            // Add new Version of AccessRightEvent
            logger.Debug("Add new Version of AccessRightEvent");
            try
            {
                entities.Data_AccessRightEvents.Add(rightEvent);
                EntitySaveChanges(true);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            int accessRightEventID = rightEvent.AccessRightEventID;
            logger.InfoFormat("Added AccessRightEvent with ID: {0}", accessRightEventID);

            // Add new Versions of AccessAreaEvents
            if (areaEvents.Count() > 0)
            {
                try
                {
                    foreach (Data_AccessAreaEvents areaEvent in areaEvents)
                    {
                        areaEvent.AccessRightEventID = accessRightEventID;
                        entities.Data_AccessAreaEvents.Add(areaEvent);
                    }
                    EntitySaveChanges(true);
                }
                catch (EntityException ex)
                {
                    logger.Error("EntityException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }

                logger.InfoFormat("Added {0} AccessAreaEvent(s)", areaEvents.Count());
            }
        }

        /// <summary>
        /// HasValidDocumentRelevantFor
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="relevantFor"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public HasValidDocumentRelevantFor_Result[] HasValidDocumentRelevantFor(int systemID, int bpID, int employeeID, string sessionID)
        {
            logger.InfoFormat("Enter HasValidDocumentRelevantFor with params systemID: {0}; bpID: {1}; employeeID: {2}; sessionID: {3}", systemID, bpID, employeeID, sessionID);

            ObjectResult<HasValidDocumentRelevantFor_Result> result = entities.HasValidDocumentRelevantFor(systemID, bpID, employeeID);

            return result.ToArray();
        }

        /// <summary>
        /// GetAccessRightEvents
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="newestOnly"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetAccessRightEvents_Result[] GetAccessRightEvents(int systemID, int bpID, int employeeID, bool newestOnly, string sessionID)
        {
            logger.InfoFormat("Enter GetAccessRightEvents with params systemID: {0}; bpID: {1}; employeeID: {2}; newestOnly: {3}; sessionID: {4}", systemID, bpID, employeeID, newestOnly, sessionID);

            ObjectResult<GetAccessRightEvents_Result> result = entities.GetAccessRightEvents(systemID, bpID, employeeID, newestOnly);

            return result.ToArray();
        }

        /// <summary>
        /// GetAccessAreaEvents
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="accessRightEventID"></param>
        /// <returns></returns>
        public GetAccessAreaEvents_Result[] GetAccessAreaEvents(int systemID, int bpID, int accessRightEventID, string sessionID)
        {
            logger.InfoFormat("Enter GetAccessAreaEvents with params systemID: {0}; bpID: {1}; accessRightEventID: {2}; sessionID: {3}", systemID, bpID, accessRightEventID, sessionID);

            ObjectResult<GetAccessAreaEvents_Result> result = entities.GetAccessAreaEvents(systemID, bpID, accessRightEventID);

            return result.ToArray();
        }

        /// <summary>
        /// GetRelevantDocuments
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="relevantDocumentID"></param>
        /// <param name="languageID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetRelevantDocuments_Result[] GetRelevantDocuments(int systemID, int bpID, int relevantDocumentID, string languageID, string sessionID)
        {
            logger.InfoFormat("Enter GetRelevantDocuments with params systemID: {0}; bpID: {1}; relevantDocumentID: {2}; sessionID: {3}", systemID, bpID, relevantDocumentID, sessionID);

            ObjectResult<GetRelevantDocuments_Result> result = entities.GetRelevantDocuments(systemID, bpID, relevantDocumentID, languageID);

            return result.ToArray();
        }

        /// <summary>
        /// GetEmployeeRelevantDocuments
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="languageID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetEmployeeRelevantDocuments_Result[] GetEmployeeRelevantDocuments(int systemID, int bpID, int employeeID, string languageID, string sessionID)
        {
            logger.InfoFormat("Enter GetRelevantDocuments with params systemID: {0}; bpID: {1}; employeeID: {2}; sessionID: {3}", systemID, bpID, employeeID, sessionID);

            ObjectResult<GetEmployeeRelevantDocuments_Result> result = entities.GetEmployeeRelevantDocuments(systemID, bpID, employeeID, languageID);

            return result.ToArray();
        }

        /// <summary>
        /// GetEmployeesWithTimeSlot
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="timeSlotID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetEmployeesWithTimeSlot_Result[] GetEmployeesWithTimeSlot(int systemID, int bpID, int timeSlotID, string sessionID)
        {
            logger.InfoFormat("Enter GetEmployeesWithTimeSlot with params systemID: {0}; bpID: {1}; timeSlotID: {2}; sessionID: {3}", systemID, bpID, timeSlotID, sessionID);

            ObjectResult<GetEmployeesWithTimeSlot_Result> result = entities.GetEmployeesWithTimeSlot(systemID, bpID, timeSlotID);

            return result.ToArray();
        }

        /// <summary>
        /// GetEmployeesWithRelevantDocument
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="relevantDocumentID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetEmployeesWithRelevantDocument_Result[] GetEmployeesWithRelevantDocument(int systemID, int bpID, int relevantDocumentID, string sessionID)
        {
            logger.InfoFormat("Enter GetEmployeesWithRelevantDocument with params systemID: {0}; bpID: {1}; relevantDocumentID: {2}; sessionID: {3}", systemID, bpID, relevantDocumentID, sessionID);

            ObjectResult<GetEmployeesWithRelevantDocument_Result> result = entities.GetEmployeesWithRelevantDocument(systemID, bpID, relevantDocumentID);

            return result.ToArray();
        }

        /// <summary>
        /// GetEmployeesWithCountry
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="countryID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int?[] GetEmployeesWithCountry(int systemID, int bpID, string countryID, string sessionID)
        {
            logger.InfoFormat("Enter GetEmployeesWithCountry with params systemID: {0}; bpID: {1}; countryID: {2}; sessionID: {3}", systemID, bpID, countryID, sessionID);

            ObjectResult<int?> result = entities.GetEmployeesWithCountry(systemID, bpID, countryID);

            return result.ToArray();
        }

        /// <summary>
        /// GetEmployeesWithEmploymentStatus
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="countryGroupIDEmployer"></param>
        /// <param name="countryGroupIDEmployee"></param>
        /// <param name="employmentStatusID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int?[] GetEmployeesWithEmploymentStatus(int systemID, int bpID, int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID, string sessionID)
        {
            logger.InfoFormat("Enter GetEmployeesWithEmploymentStatus with params systemID: {0}; bpID: {1}; employmentStatusID: {2}; countryGroupIDEmployer: {3}; countryGroupIDEmployee: {4}; sessionID: {5}", systemID, bpID, employmentStatusID, countryGroupIDEmployer, countryGroupIDEmployee, sessionID);

            ObjectResult<int?> result = entities.GetEmployeesWithEmploymentStatus(systemID, bpID, countryGroupIDEmployer, countryGroupIDEmployee, employmentStatusID);

            return result.ToArray();
        }

        /// <summary>
        /// GetShortTermPasses
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="shortTermPassID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetShortTermPasses_Result[] GetShortTermPasses(int systemID, int bpID, int shortTermPassID, string sessionID)
        {
            logger.InfoFormat("Enter GetShortTermPasses with params systemID: {0}; bpID: {1}; shortTermPassID: {2}; sessionID: {3}", systemID, bpID, shortTermPassID, sessionID);

            ObjectResult<GetShortTermPasses_Result> result = entities.GetShortTermPasses(systemID, bpID, shortTermPassID);

            return result.ToArray();
        }

        /// <summary>
        /// GetVisitorAccessAreas
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="shortTermVisitorID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetVisitorAccessAreas_Result[] GetVisitorAccessAreas(int systemID, int bpID, int shortTermVisitorID, string sessionID)
        {
            logger.InfoFormat("Enter GetVisitorAccessAreas with params systemID: {0}; bpID: {1}; shortTermVisitorID: {2}; sessionID: {3}", systemID, bpID, shortTermVisitorID, sessionID);

            ObjectResult<GetVisitorAccessAreas_Result> result = entities.GetVisitorAccessAreas(systemID, bpID, shortTermVisitorID);

            return result.ToArray();
        }

        /// <summary>
        /// GetEmployeeRelevantDocumentsToAdd
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="relevantFor"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetEmployeeRelevantDocumentsToAdd_Result[] GetEmployeeRelevantDocumentsToAdd(int systemID, int bpID, int employeeID, int relevantFor, string sessionID)
        {
            logger.InfoFormat("Enter GetEmployeeRelevantDocumentsToAdd with params systemID: {0}; bpID: {1}; employeeID: {2}; relevantFor: {3}; sessionID: {4}", systemID, bpID, employeeID, relevantFor, sessionID);

            ObjectResult<GetEmployeeRelevantDocumentsToAdd_Result> result = entities.GetEmployeeRelevantDocumentsToAdd(systemID, bpID, employeeID, relevantFor);

            return result.ToArray();
        }

        /// <summary>
        /// GetCompanyAdminUser
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="companyCentralID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetCompanyAdminUser_Result[] GetCompanyAdminUser(int systemID, int companyCentralID, string sessionID)
        {
            logger.InfoFormat("Enter GetCompanyAdminUser with params systemID: {0}; companyCentralID: {1}; sessionID: {2}", systemID, companyCentralID, sessionID);

            ObjectResult<GetCompanyAdminUser_Result> result = entities.GetCompanyAdminUser(systemID, companyCentralID);

            return result.ToArray();
        }

        /// <summary>
        /// GetCompanyAdminUserWithBP
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetCompanyAdminUserWithBP_Result[] GetCompanyAdminUserWithBP(int systemID, int bpID, int companyID, string sessionID)
        {
            logger.InfoFormat("Enter GetCompanyAdminUserWithBP with params systemID: {0}; bpID: {1}; companyID: {2}; sessionID: {3}", systemID, bpID, companyID, sessionID);

            ObjectResult<GetCompanyAdminUserWithBP_Result> result = entities.GetCompanyAdminUserWithBP(systemID, bpID, companyID);

            return result.ToArray();
        }

        /// <summary>
        /// GetLockedMainContractor
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetLockedMainContractor_Result[] GetLockedMainContractor(int systemID, int bpID, int companyID, string sessionID)
        {
            logger.InfoFormat("Enter GetLockedMainContractor with params systemID: {0}; bpID: {1}; companyID: {2}; sessionID: {3}", systemID, bpID, companyID, sessionID);

            ObjectResult<GetLockedMainContractor_Result> result = entities.GetLockedMainContractor(systemID, bpID, companyID);

            return result.ToArray();
        }

        /// <summary>
        /// GetMainContractorStatus
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetMainContractorStatus(int systemID, int bpID, int companyID, string sessionID)
        {
            int statusID = Status.Released;
            Master_Companies company = entities.Master_Companies.FirstOrDefault(c => c.SystemID == systemID && c.BpID == bpID && c.CompanyID == companyID);
            if (company != null)
            {
                int parentID = company.ParentID;
                company = entities.Master_Companies.FirstOrDefault(c => c.SystemID == systemID && c.BpID == bpID && c.CompanyID == parentID);
                if (company != null)
                {
                    statusID = company.StatusID;
                }
            }
            return statusID;
        }

        /// <summary>
        /// GetSubContractors
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetSubContractors_Result[] GetSubContractors(int systemID, int bpID, int companyID, string sessionID)
        {
            logger.InfoFormat("Enter GetSubContractors with params systemID: {0}; bpID: {1}; companyID: {2}; sessionID: {3}", systemID, bpID, companyID, sessionID);

            ObjectResult<GetSubContractors_Result> result = entities.GetSubContractors(systemID, bpID, companyID);

            return result.ToArray();
        }

        /// <summary>
        /// GetEmployeePassStatus
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetEmployeePassStatus(int systemID, int bpID, int employeeID, string sessionID)
        {
            logger.InfoFormat("Enter GetEmployeePassStatus with params systemID: {0}; bpID: {1}; employeeID: {2}; sessionID: {3}", systemID, bpID, employeeID, sessionID);

            ObjectResult<int?> result = entities.GetEmployeePassStatus(systemID, bpID, employeeID);

            return Convert.ToInt32(result.ToArray()[0]);
        }

        private bool CompanyIsSelfOrSubcontractor(GetCompaniesSubcontractors_Result[] subcontractors, int companyCentralID)
        {
            bool ret = false;
            if (subcontractors != null)
            {
                GetCompaniesSubcontractors_Result[] result = subcontractors.Where(s => s.CompanyCentralID == companyCentralID).ToArray();
                if (result.Count() > 0)
                {
                    ret = true;
                }
            }
            return ret;
        }

        /// <summary>
        /// SetProcessEvent
        /// </summary>
        /// <param name="eventData"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int SetProcessEvent(Data_ProcessEvents eventData, string fieldName, Tuple<string, string>[] values, string sessionID)
        {
            logger.InfoFormat("Enter SetProcessEvent with params systemID: {0}; bpID: {1}; dialogID: {2}; actionID: {3}; refID: {4}; sessionID: {5}", eventData.SystemID, eventData.BpID, eventData.DialogID, eventData.ActionID, eventData.RefID, sessionID);
            logger.InfoFormat("eventData: {0}", string.Join(", ", eventData));

            // Get all users with sufficient rights for current dialog and action
            ObjectResult<GetProcessUsers_Result> result = entities.GetProcessUsers(eventData.SystemID, eventData.BpID, eventData.DialogID, eventData.ActionID);
            GetProcessUsers_Result[] processUsers = result.ToArray();
            logger.InfoFormat("processUsers: {0}", string.Join(", ", processUsers.AsEnumerable()));

            int rowCount = 0;

            if (processUsers.Count() > 0)
            {

                logger.InfoFormat("{0} users found", processUsers.Count());
                foreach (GetProcessUsers_Result processUser in processUsers)
                {
                    int companyCentralID = processUser.CompanyID;

                    ObjectResult<GetCompaniesSubcontractors_Result> subcontractorsResult = entities.GetCompaniesSubcontractors(eventData.SystemID, eventData.BpID, companyCentralID);
                    GetCompaniesSubcontractors_Result[] subcontractors = subcontractorsResult.ToArray();

                    bool selfAndSubcontractors = processUser.SelfAndSubcontractors && CompanyIsSelfOrSubcontractor(subcontractors, eventData.CompanyCentralID);
                    selfAndSubcontractors |= !processUser.SelfAndSubcontractors;

                    bool useCompanyAssignment = processUser.UseCompanyAssignment && (processUser.CompanyID == eventData.CompanyCentralID);
                    useCompanyAssignment |= processUser.UseCompanyAssignment && (processUser.CompanyID == 0);
                    useCompanyAssignment |= !processUser.UseCompanyAssignment;

                    if (selfAndSubcontractors || useCompanyAssignment)
                    {
                        // Add process to user
                        var processEvent = new Data_ProcessEvents();

                        processEvent.SystemID = eventData.SystemID;
                        processEvent.BpID = processUser.BpID;
                        processEvent.CompanyCentralID = processUser.CompanyID;
                        processEvent.UserIDInitiator = eventData.UserIDInitiator;
                        processEvent.UserIDExecutive = processUser.UserID;

                        if (fieldName.Equals(string.Empty))
                        {
                            processEvent.NameVisible = eventData.NameVisible;
                            processEvent.DescriptionShort = Helpers.Tail(eventData.DescriptionShort, 2000, " ...");
                        }
                        else
                        {
                            Master_Translations translation = GetTranslation(eventData.SystemID, eventData.BpID, fieldName, processUser.LanguageID, "en", values, sessionID);
                            if (translation != null && translation.NameTranslated != null && !translation.NameTranslated.Equals(string.Empty))
                            {
                                processEvent.NameVisible = translation.NameTranslated;
                                processEvent.DescriptionShort = Helpers.Tail(translation.HtmlTranslated, 2000, " ...");
                            }
                            else
                            {
                                processEvent.NameVisible = eventData.NameVisible;
                                processEvent.DescriptionShort = Helpers.Tail(eventData.DescriptionShort, 2000, " ...");
                            }
                        }

                        processEvent.TypeID = eventData.TypeID;
                        processEvent.DialogID = eventData.DialogID;
                        processEvent.ActionID = eventData.ActionID;
                        processEvent.RefID = eventData.RefID;
                        processEvent.StatusID = eventData.StatusID;
                        processEvent.CreatedFrom = eventData.CreatedFrom;
                        processEvent.CreatedOn = eventData.CreatedOn;
                        processEvent.EditFrom = eventData.EditFrom;
                        processEvent.EditOn = eventData.EditOn;

                        string appServer = ConfigurationManager.AppSettings["AppServer"].ToString();
                        string processUrl = appServer + processUser.PageName.Replace(".", "/") + ".aspx?ID=" + eventData.RefID.ToString() + "&Action=" + eventData.ActionID.ToString();
                        processEvent.ProcessUrl = processUrl;

                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.SystemID", processEvent.SystemID.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.BpID", processEvent.BpID.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.CompanyCentralID", processEvent.CompanyCentralID.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.UserIDInitiator", processEvent.UserIDInitiator.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.UserIDExecutive", processEvent.UserIDExecutive.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.NameVisible", processEvent.NameVisible.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.DescriptionShort", processEvent.DescriptionShort.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.TypeID", processEvent.TypeID.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.DialogID", processEvent.DialogID.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.ActionID", processEvent.ActionID.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.RefID", processEvent.RefID.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.StatusID", processEvent.StatusID.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.CreatedFrom", processEvent.CreatedFrom.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.CreatedOn", processEvent.CreatedOn.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.EditFrom", processEvent.EditFrom.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.EditOn", processEvent.EditOn.ToString());
                        //logger.InfoFormat("Name: {0}; Value: {1}", "processEvent.ProcessUrl", processEvent.ProcessUrl.ToString());

                        try
                        {
                            entities.Data_ProcessEvents.Add(processEvent);
                            logger.DebugFormat("Try to add process event: BpID {0}, CompanyCentralID {1}, UserIDInitiator {2}, UserIDExecutive {3}, NameVisible {4}", processEvent.BpID,
                                processEvent.CompanyCentralID, processEvent.UserIDInitiator, processEvent.UserIDExecutive, processEvent.NameVisible);
                            EntitySaveChanges(true);
                        }
                        catch (EntityException ex)
                        {
                            logger.Error("EntityException: ", ex);
                            throw;
                        }
                        catch (Exception ex)
                        {
                            logger.Error("Exception: ", ex);
                            throw;
                        }

                        int jobID = processEvent.ProcessEventID;

                        // Send mail to user, if selected
                        if (processUser.UseEmail && !processUser.Email.Equals(string.Empty))
                        {
                            logger.DebugFormat("Try to send mail to user: BpID: {0}, CompanyCentralID: {1}, UserIDInitiator: {2}, UserIDExecutive: {3}, NameVisible: {4}, Email: {5}", processEvent.BpID,
                                processEvent.CompanyCentralID, processEvent.UserIDInitiator, processEvent.UserIDExecutive, processEvent.NameVisible, processUser.Email);
                            SendMail(processUser.Email, processEvent.NameVisible, processEvent.DescriptionShort);
                        }

                        // Add message for user
                        System_Mailbox mail = new System_Mailbox();

                        mail.JobId = jobID;
                        mail.Subject = processEvent.NameVisible;
                        mail.Body = processEvent.DescriptionShort;
                        mail.UserID = processUser.UserID;
                        mail.SystemID = eventData.SystemID;
                        mail.MailCreated = eventData.CreatedOn;

                        try
                        {
                            entities.System_Mailbox.Add(mail);
                            EntitySaveChanges(true);
                        }
                        catch (EntityException ex)
                        {
                            logger.Error("EntityException: ", ex);
                            throw;
                        }
                        catch (Exception ex)
                        {
                            logger.Error("Exception: ", ex);
                            throw;
                        }

                        int mailID = mail.Id;

                        // Create dummy document for action url
                        System_Documents document = new System_Documents();
                        logger.InfoFormat("Url: {0}", processUrl);

                        document.SystemID = eventData.SystemID;
                        document.JobId = jobID;
                        document.UserID = processUser.UserID;
                        document.DocCreated = eventData.CreatedOn;
                        document.DocumentName = processUrl;
                        document.DocumentType = "Url";
                        document.DocumentRef = Guid.NewGuid();

                        try
                        {
                            entities.System_Documents.Add(document);
                            EntitySaveChanges(true);
                        }
                        catch (EntityException ex)
                        {
                            logger.Error("EntityException: ", ex);
                            throw;
                        }
                        catch (Exception ex)
                        {
                            logger.Error("Exception: ", ex);
                            throw;
                        }

                        int documentID = document.Id;

                        // Create attachment for dummy document
                        System_MailAttachment attachment = new System_MailAttachment();

                        attachment.SystemID = eventData.SystemID;
                        attachment.MailID = mailID;
                        attachment.DocumentID = documentID;

                        try
                        {
                            entities.System_MailAttachment.Add(attachment);
                            EntitySaveChanges(true);
                        }
                        catch (EntityException ex)
                        {
                            logger.Error("EntityException: ", ex);
                            throw;
                        }
                        catch (Exception ex)
                        {
                            logger.Error("Exception: ", ex);
                            throw;
                        }

                        rowCount++;
                    }
                }
            }

            logger.InfoFormat("{0} from {1} users got new messages", rowCount, processUsers.Count());

            return rowCount;
        }

        /// <summary>
        /// ProcessEventDone
        /// </summary>
        /// <param name="eventData"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int ProcessEventDone(Data_ProcessEvents eventData, string sessionID)
        {
            try
            {
                entities.ProcessEventDone(eventData.SystemID, eventData.DialogID, eventData.ActionID, eventData.RefID, eventData.UserIDExecutive, eventData.DoneFrom, eventData.StatusID);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            return 0;
        }

        /// <summary>
        /// GetBpName
        /// </summary>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public string GetBpName(int systemID, int bpID, string sessionID)
        {
            string bpName = "";

            Master_BuildingProjects buildingProject = entities.Master_BuildingProjects.FirstOrDefault(b => b.SystemID == systemID && b.BpID == bpID);
            if (buildingProject != null)
            {
                bpName = buildingProject.NameVisible;
            }

            return bpName;
        }

        /// <summary>
        /// GetCompanyName
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public string GetCompanyName(int systemID, int companyID, string sessionID)
        {
            string companyName = string.Empty;

            System_Companies company = entities.System_Companies.FirstOrDefault(c => c.SystemID == systemID && c.CompanyID == companyID);
            if (company != null)
            {
                companyName = company.NameVisible;
            }

            return companyName;
        }

        /// <summary>
        /// GetBpCompanyName
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public string GetBpCompanyName(int systemID, int bpID, int companyID, string sessionID)
        {
            string companyName = string.Empty;

            Master_Companies company = entities.Master_Companies.FirstOrDefault(c => c.SystemID == systemID && c.BpID == bpID && c.CompanyID == companyID);
            if (company != null)
            {
                companyName = company.NameVisible;
            }

            return companyName;
        }

        /// <summary>
        /// GetUnreadMailCount
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="userID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetUnreadMailCount(int systemID, int userID, string sessionID)
        {
            return entities.System_Mailbox.Where(m => m.SystemID == systemID && m.UserID == userID && m.MailRead.Value == null).Count();
        }

        /// <summary>
        /// GetOpenProcessCount
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="userID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetOpenProcessCount(int systemID, int bpID, int userID, string sessionID)
        {
            return entities.Data_ProcessEvents.Where(p => p.SystemID == systemID && p.BpID == bpID && p.UserIDExecutive == userID && p.StatusID == Status.WaitExecute).Count();
        }

        /// <summary>
        /// GetRoles
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="typeID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_Roles[] GetRoles(int systemID, int bpID, int typeID, string sessionID)
        {
            return entities.Master_Roles.Where(r => r.SystemID == systemID && r.BpID == bpID && r.TypeID <= typeID).ToArray();
        }

        /// <summary>
        /// GetDefaultRoleID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetDefaultRoleID(int systemID, int bpID, string sessionID)
        {
            Master_BuildingProjects bp = entities.Master_BuildingProjects.FirstOrDefault(b => b.SystemID == systemID && b.BpID == bpID);
            if (bp != null)
            {
                return bp.DefaultRoleID;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// GetAccessAreas
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_AccessAreas[] GetAccessAreas(int systemID, int bpID, string sessionID)
        {
            return entities.Master_AccessAreas.Where(a => a.SystemID == systemID && a.BpID == bpID).ToArray();
        }

        /// <summary>
        /// GetDefaultAccessAreaID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetDefaultAccessAreaID(int systemID, int bpID, string sessionID)
        {
            Master_BuildingProjects bp = entities.Master_BuildingProjects.FirstOrDefault(b => b.SystemID == systemID && b.BpID == bpID);
            if (bp != null)
            {
                return bp.DefaultAccessAreaID;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// GetDefaultSTAccessAreaID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetDefaultSTAccessAreaID(int systemID, int bpID, string sessionID)
        {
            Master_BuildingProjects bp = entities.Master_BuildingProjects.FirstOrDefault(b => b.SystemID == systemID && b.BpID == bpID);
            if (bp != null)
            {
                return bp.DefaultSTAccessAreaID;
            }
            else
            {
                return 0;
            }
        }
        
        /// <summary>
        /// GetTimeSlotGroups
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_TimeSlotGroups[] GetTimeSlotGroups(int systemID, int bpID, string sessionID)
        {
            return entities.Master_TimeSlotGroups.Where(t => t.SystemID == systemID && t.BpID == bpID).ToArray();
        }

        /// <summary>
        /// GetDefaultTimeSlotGroupID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetDefaultTimeSlotGroupID(int systemID, int bpID, string sessionID)
        {
            Master_BuildingProjects bp = entities.Master_BuildingProjects.FirstOrDefault(b => b.SystemID == systemID && b.BpID == bpID);
            if (bp != null)
            {
                return bp.DefaultTimeSlotGroupID;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// GetDefaultSTTimeSlotGroupID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetDefaultSTTimeSlotGroupID(int systemID, int bpID, string sessionID)
        {
            Master_BuildingProjects bp = entities.Master_BuildingProjects.FirstOrDefault(b => b.SystemID == systemID && b.BpID == bpID);
            if (bp != null)
            {
                return bp.DefaultSTTimeSlotGroupID;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// SetDefaultAccessAreaForUser
        /// </summary>
        /// <param name="accessArea"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int SetDefaultAccessAreaForUser(Master_EmployeeAccessAreas accessArea, string sessionID)
        {
            try
            { 
                entities.Master_EmployeeAccessAreas.Add(accessArea);

                EntitySaveChanges(true);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            return 0;
        }

        /// <summary>
        /// SetDefaultAccessAreaForVisitor
        /// </summary>
        /// <param name="accessArea"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int SetDefaultAccessAreaForVisitor(Data_ShortTermAccessAreas accessArea, string sessionID)
        {
            try
            { 
                entities.Data_ShortTermAccessAreas.Add(accessArea);

                EntitySaveChanges(true);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            return 0;
        }

        /// <summary>
        /// GetPassData
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="chipID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_Passes GetPassData(int systemID, int bpID, string chipID, string sessionID)
        {
            Master_Passes pass = entities.Master_Passes.FirstOrDefault(p => p.SystemID == systemID && p.BpID == bpID && p.InternalID == chipID && p.ActivatedOn != null);
            if (pass != null)
            {
                return pass;
            }
            else
            {
                return new Master_Passes();
            }
        }

        /// <summary>
        /// GetVariables
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="fieldID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public System_Variables[] GetVariables(int systemID, int fieldID, string sessionID)
        {
            System_Variables[] result = entities.System_Variables.Where(v => v.SystemID == systemID && v.FieldID == fieldID).ToArray();
            if (result.Count() > 0)
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetFieldID
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="fieldName"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int GetFieldID(int systemID, string fieldName, string sessionID)
        {
            System_Fields result = entities.System_Fields.FirstOrDefault(f => f.SystemID == systemID && f.InternalName == fieldName);
            if (result != null)
            {
                return result.FieldID;
            }
            else
            {
                return 0;
            }
        }

        /// <summary>
        /// GetVariablesByFieldName
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="fieldName"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public System_Variables[] GetVariablesByFieldName(int systemID, string fieldName, string sessionID)
        {
            int fieldID = GetFieldID(systemID, fieldName, sessionID);
            System_Variables[] result = entities.System_Variables.Where(v => v.SystemID == systemID && v.FieldID == fieldID).ToArray();
            if (result.Count() > 0)
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetShortTermVisitors
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetShortTermVisitors_Result[] GetShortTermVisitors(int systemID, int bpID, string sessionID)
        {
            logger.InfoFormat("Enter GetShortTermVisitors with params systemID: {0}; bpID: {1}; sessionID: {2}", systemID, bpID, sessionID);

            ObjectResult<GetShortTermVisitors_Result> result = null;
            try
            {
                result = entities.GetShortTermVisitors(systemID, bpID);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            return result.ToArray();
        }

        /// <summary>
        /// GetTranslation
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="fieldName"></param>
        /// <param name="languageID"></param>
        /// <param name="values"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_Translations GetTranslation(int systemID, int bpID, string fieldName, string languageIDUser, string languageIDClient, Tuple<string, string>[] values, string sessionID)
        {
            logger.InfoFormat("Start GetTranslation with systemID: {0}; bpID: {1}; languageIDUser: {2}; languageIDClient: {3}", systemID, bpID, languageIDUser, languageIDClient);

            //if (languageIDUser.Length == 2)
            //{
            //    languageIDUser += "-" + languageIDUser.ToUpper();
            //}

            //if (languageIDClient.Length == 2)
            //{
            //    languageIDClient += "-" + languageIDClient.ToUpper();
            //}

            // Get field id from field name
            int fieldID = GetFieldID(systemID, fieldName, sessionID);
            logger.InfoFormat("fieldID: {0}", fieldID);

            // Get translation record
            Master_Translations result = null;
            try
            {
                if (bpID == 0)
                {
                    // Use Bp = 1 when no Bp selected
                    result = entities.Master_Translations.FirstOrDefault(t => t.SystemID == systemID && t.BpID == 1 && t.FieldID == fieldID && t.LanguageID == languageIDUser);
                    if (result == null)
                    {
                        // Use client language
                        logger.InfoFormat("No translation found for user language {0}", languageIDUser);
                        result = entities.Master_Translations.FirstOrDefault(t => t.SystemID == systemID && t.BpID == 1 && t.FieldID == fieldID && t.LanguageID == languageIDClient);
                    }
                    if (result == null)
                    {
                        // Use default en
                        logger.InfoFormat("No translation found for client language {0}", languageIDClient);
                        result = entities.Master_Translations.FirstOrDefault(t => t.SystemID == systemID && t.BpID == 1 && t.FieldID == fieldID && t.LanguageID == "en");
                    }
                }
                else
                {
                    result = entities.Master_Translations.FirstOrDefault(t => t.SystemID == systemID && t.BpID == bpID && t.FieldID == fieldID && t.LanguageID == languageIDUser);
                    if (result == null)
                    {
                        // Use client language
                        logger.InfoFormat("No translation found for user language {0}", languageIDUser);
                        result = entities.Master_Translations.FirstOrDefault(t => t.SystemID == systemID && t.BpID == bpID && t.FieldID == fieldID && t.LanguageID == languageIDClient);
                    }
                    if (result == null)
                    {
                        // Use default en
                        logger.InfoFormat("No translation found for client language {0}", languageIDClient);
                        result = entities.Master_Translations.FirstOrDefault(t => t.SystemID == systemID && t.BpID == bpID && t.FieldID == fieldID && t.LanguageID == "en");
                    }
                }
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            if (result != null)
            {
                // Get corresponding variables
                System_Variables[] variables = GetVariables(systemID, fieldID, sessionID);
                if (variables != null)
                {
                    logger.InfoFormat("variables.Count(): {0}", variables.Count());

                    // Get html string with variable patterns
                    string htmlTranslated = result.HtmlTranslated;
                    // logger.InfoFormat("htmlTranslated before: {0}", htmlTranslated);

                    // Iterate through values
                    foreach (Tuple<string, string> value in values)
                    {
                        // Select corresponding variable for value
                        System_Variables variableSelected = variables.FirstOrDefault(v => v.VariableName == value.Item1);
                        if (variableSelected != null)
                        {
                            // Get pattern from variable
                            string pattern = variableSelected.VariablePattern;

                            // Replace pattern with value
                            htmlTranslated = htmlTranslated.Replace(pattern, value.Item2);
                        }
                    }

                    // Return html string with values
                    result.HtmlTranslated = htmlTranslated;
                    // logger.InfoFormat("htmlTranslated after: {0}", htmlTranslated);
                }
                return result;
            }
            else
            {
                logger.Info("No translation found at all");
                return null;
            }
        }

        /// <summary>
        /// GetHistoryTables
        /// </summary>
        /// <returns></returns>
        public System_Tables[] GetHistoryTables(string sessionID)
        {
            System_Tables[] result = entities.System_Tables.Where(t => t.TABLE_NAME.Contains("History") && t.ResourceID.Length > 0).ToArray();
            if (result.Count() > 0)
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetUsers
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_Users[] GetUsers(int systemID, string sessionID)
        {
            Master_Users[] result = entities.Master_Users.Where(u => u.SystemID == systemID).ToArray();
            if (result.Count() > 0)
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetUser
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="userID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_Users GetUser(int systemID, int userID, string sessionID)
        {
            Master_Users result = entities.Master_Users.FirstOrDefault(u => u.SystemID == systemID && u.UserID == userID);
            if (result != null)
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetPresentPersonsCount
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetPresentPersonsCount_Result GetPresentPersonsCount(int systemID, int bpID, string sessionID)
        {
            ObjectResult<GetPresentPersonsCount_Result> result = entities.GetPresentPersonsCount(systemID, bpID);
            GetPresentPersonsCount_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult[0];
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetPassBillings
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="dateFrom"></param>
        /// <param name="dateUntil"></param>
        /// <param name="level"></param>
        /// <param name="remarks"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetPassBillings_Result[] GetPassBillings(int systemID, int bpID, int companyID, int evaluationPeriod, DateTime dateFrom, DateTime dateUntil, int level, string remarks, string sessionID)
        {
            ObjectResult<GetPassBillings_Result> result = entities.GetPassBillings(systemID, bpID, companyID, evaluationPeriod, dateFrom, dateUntil, level, remarks);
            GetPassBillings_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetTariffData
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="tariffID"></param>
        /// <param name="tariffContractID"></param>
        /// <param name="tariffScopeID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="dateFrom"></param>
        /// <param name="dateUntil"></param>
        /// <param name="reportType"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetTariffData_Result[] GetTariffData(
            int systemID,
            int tariffID,
            int tariffContractID,
            int tariffScopeID,
            int bpID,
            int companyID,
            DateTime dateFrom,
            DateTime dateUntil,
            int reportType,
            string sessionID)
        {
            ObjectResult<GetTariffData_Result> result = entities.GetTariffData(
                systemID,
                tariffID,
                tariffContractID,
                tariffScopeID,
                bpID,
                companyID,
                1,
                dateFrom,
                dateUntil,
                reportType);
            GetTariffData_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetPresenceData
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="dateFrom"></param>
        /// <param name="dateUntil"></param>
        /// <param name="nameIsVisible"></param>
        /// <param name="companyLevel"></param>
        /// <returns></returns>
        public GetPresenceData_Result[] GetPresenceData(
            int systemID,
            int bpID,
            int companyID,
            DateTime dateFrom,
            DateTime dateUntil,
            bool nameIsVisible,
            int companyLevel,
            int compressLevel,
            string sessionID)
        {
            ObjectResult<GetPresenceData_Result> result = entities.GetPresenceData(
                systemID,
                bpID,
                companyID,
                companyLevel,
                0,
                1,
                dateFrom,
                dateUntil,
                compressLevel);
            GetPresenceData_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetPresenceDataNow
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="companyLevel"></param>
        /// <param name="accessAreaID"></param>
        /// <param name="presenceDay"></param>
        /// <param name="presentOnly"></param>
        /// <returns></returns>
        public GetPresenceDataNow_Result[] GetPresenceDataNow(
            int systemID,
            int bpID,
            int companyID,
            int companyLevel,
            int accessAreaID,
            DateTime presenceDay,
            bool presentOnly,
            string sessionID)
        {
            ObjectResult<GetPresenceDataNow_Result> result = entities.GetPresenceDataNow(
                systemID,
                bpID,
                companyID,
                companyLevel,
                accessAreaID,
                presenceDay,
                presentOnly);
            GetPresenceDataNow_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetTradeReportData
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="dateFrom"></param>
        /// <param name="dateUntil"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetTradeReportData_Result[] GetTradeReportData(
            int systemID,
            int bpID,
            DateTime dateFrom,
            DateTime dateUntil,
            string sessionID)
        {
            ObjectResult<GetTradeReportData_Result> result = entities.GetTradeReportData(
                systemID,
                bpID,
                dateFrom,
                dateUntil);
            GetTradeReportData_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetTemplates
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="dialogName"></param>
        /// <param name="withFileData"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetTemplates_Result[] GetTemplates(
            int systemID,
            int bpID,
            string dialogName,
            bool withFileData,
            string sessionID)
        {
            ObjectResult<GetTemplates_Result> result = entities.GetTemplates(
                systemID,
                bpID,
                dialogName,
                withFileData);
            GetTemplates_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetTemplate
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="templateID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_Templates GetTemplate(
            int systemID,
            int bpID,
            int templateID,
            string sessionID)
        {
            Master_Templates result = entities.Master_Templates.FirstOrDefault(t => t.SystemID == systemID && t.BpID == bpID && t.TemplateID == templateID);
            if (result != null)
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        private void SendMail(string mailTo, string subject, string body)
        {
            bool useEmail = Convert.ToBoolean(ConfigurationManager.AppSettings["UseEmail"]);
            if (useEmail)
            {
                SmtpClient client = new SmtpClient();
                client.Host = ConfigurationManager.AppSettings["MailServer"].ToString();
                client.Port = Convert.ToInt32(ConfigurationManager.AppSettings["SMTPPort"]);
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.UseDefaultCredentials = false;

                string smtpUser = ConfigurationManager.AppSettings["SMTPUser"].ToString();
                string smtpPwd = ConfigurationManager.AppSettings["SMTPPwd"].ToString();

                if (smtpUser != null && !smtpUser.Equals(string.Empty) && smtpPwd != null && !smtpPwd.Equals(string.Empty))
                {
                    client.Credentials = new System.Net.NetworkCredential(smtpUser, smtpPwd);
                }

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(ConfigurationManager.AppSettings["SMTPFrom"].ToString());
                string[] arrayMailTo = mailTo.Split(';');
                for (int i = 0; i < arrayMailTo.Length; i++)
                {
                    mail.To.Add(new MailAddress(arrayMailTo[i]));
                }
                mail.Subject = subject;
                mail.Body = body;
                mail.IsBodyHtml = true;
                mail.BodyEncoding = UTF8Encoding.UTF8;
                mail.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

                try
                {
                    client.Send(mail);
                    logger.InfoFormat("Email sent to {0}: {1}", mail.To[0].Address, mail.Subject);
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
            }
            else
            {
                logger.Info("Email not configured");
            }
        }

        /// <summary>
        /// SendMessage
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="jobID"></param>
        /// <param name="receiverID"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int SendMessage(int systemID, int jobID, int receiverID, string subject, string body, string sessionID)
        {
            logger.InfoFormat("Enter SendMessage with params systemID: {0}; jobID: {1}; receiverID: {2}", systemID, jobID, receiverID);

            System_Mailbox mail = new System_Mailbox();

            mail.SystemID = systemID;
            mail.JobId = jobID;
            mail.UserID = receiverID;
            mail.Subject = subject;
            mail.Body = body;
            mail.MailCreated = DateTime.Now;

            try
            {
                entities.System_Mailbox.Add(mail);
                EntitySaveChanges(true);
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            int mailID = mail.Id;
            return mailID;
        }

        /// <summary>
        /// SetAttachmentToMessage
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="jobID"></param>
        /// <param name="messageID"></param>
        /// <param name="fileData"></param>
        /// <param name="fileName"></param>
        /// <param name="fileType"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int SetAttachmentToMessage(int systemID, int jobID, int messageID, byte[] fileData, string fileName, string fileType, string sessionID)
        {
            logger.InfoFormat("Enter SetAttachmentToMessage with params systemID: {0}; jobID: {1}; messageID: {2}; fileName: {3}", systemID, jobID, messageID, fileName);

            System_Documents document = new System_Documents();
            System_MailAttachment attachment = new System_MailAttachment();

            int documentID = 0;
            document.SystemID = systemID;
            document.JobId = jobID;
            document.DocCreated = DateTime.Now;
            document.Document = fileData;
            document.DocumentName = fileName;
            document.DocumentType = fileType;
            document.DocumentRef = Guid.NewGuid();

            try
            {
                entities.System_Documents.Add(document);
                EntitySaveChanges(true);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            documentID = document.Id;

            attachment.SystemID = systemID;
            attachment.MailID = messageID;
            attachment.DocumentID = documentID;

            try
            {
                entities.System_MailAttachment.Add(attachment);
                EntitySaveChanges(true);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }

            return attachment.Id;
        }

        /// <summary>
        /// SendMessageToUsersWithRight
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="jobID"></param>
        /// <param name="dialogID"></param>
        /// <param name="actionID"></param>
        /// <param name="subject"></param>
        /// <param name="body"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public int SendMessageToUsersWithRight(int systemID, int bpID, int jobID, int dialogID, int actionID, string subject, string body, string sessionID)
        {
            logger.InfoFormat("Enter SendMessageToUsersWithRight with params systemID: {0}; bpID: {1}; jobID: {2}; dialogID: {3}; actionID: {4}", systemID, bpID, jobID, dialogID, actionID);

            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT DISTINCT m_ubp.SystemID, m_ubp.UserID ");
            sql.Append("FROM Master_Dialogs_Actions AS m_d_a ");
            sql.Append("INNER JOIN Master_Roles_Dialogs AS m_r_d ");
            sql.Append("ON m_d_a.SystemID = m_r_d.SystemID ");
            sql.Append("AND m_d_a.BpID = m_r_d.BpID ");
            sql.Append("AND m_d_a.RoleID = m_r_d.RoleID ");
            sql.Append("AND m_d_a.DialogID = m_r_d.DialogID ");
            sql.Append("INNER JOIN Master_UserBuildingProjects AS m_ubp ");
            sql.Append("ON m_r_d.SystemID = m_ubp.SystemID ");
            sql.Append("AND m_r_d.BpID = m_ubp.BpID ");
            sql.Append("AND m_r_d.RoleID = m_ubp.RoleID ");
            sql.Append("WHERE m_d_a.SystemID = @SystemID ");
            sql.Append("AND m_d_a.DialogID = @DialogID ");
            sql.Append("AND m_d_a.ActionID = @ActionID ");
            sql.Append("AND m_d_a.IsActive = 1 ");
            sql.Append("AND m_r_d.IsActive = 1 ");
            if (bpID != 0)
            {
                sql.Append("AND m_ubp.BpID = @BpID ");
            }

            SqlCommand command = new SqlCommand();
            command.CommandType = CommandType.Text;
            command.CommandText = sql.ToString();
            command.Connection = connection;

            SqlParameter par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = systemID;
            command.Parameters.Add(par);

            if (bpID != 0)
            {
                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = bpID;
                command.Parameters.Add(par);
            }

            par = new SqlParameter("@DialogID", SqlDbType.Int);
            par.Value = dialogID;
            command.Parameters.Add(par);

            par = new SqlParameter("@ActionID", SqlDbType.Int);
            par.Value = actionID;
            command.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = command;
            DataTable dataTable = new DataTable();

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                // logger.InfoFormat("Try to execute SQL: {0}", sql.ToString());
                adapter.Fill(dataTable);
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            if (dataTable.Rows.Count > 0)
            {
                foreach (DataRow row in dataTable.Rows)
                {
                    int userID = Convert.ToInt32(row["UserID"]);
                    SendMessage(systemID, jobID, userID, subject, body, sessionID);
                }
                return dataTable.Rows.Count;
            }
            else
            {
                logger.Info("No Users  found");
                return 0;
            }
        }

        /// <summary>
        /// GetCompanyTariff
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="companyID"></param>
        /// <param name="tariffScopeID"></param>
        /// <returns></returns>
        public GetCompanyTariff_Result GetCompanyTariff(int systemID, int companyID, int tariffScopeID, string sessionID)
        {
            ObjectResult<GetCompanyTariff_Result> result = entities.GetCompanyTariff(
                systemID,
                companyID,
                tariffScopeID);
            GetCompanyTariff_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult[0];
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetReportMinWageData
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="monthFrom"></param>
        /// <param name="monthUntil"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetReportMinWageData_Result[] GetReportMinWageData(
            int systemID,
            int bpID,
            DateTime monthFrom,
            DateTime monthUntil,
            int companyID,
            string sessionID)
        {
            ObjectResult<GetReportMinWageData_Result> result = entities.GetReportMinWageData(
                systemID,
                bpID,
                monthFrom,
                monthUntil,
                companyID);
            GetReportMinWageData_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetCompanyInfo
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetCompanyInfo_Result[] GetCompanyInfo(
            int systemID,
            int bpID,
            int companyID,
            string sessionID)
        {
            ObjectResult<GetCompanyInfo_Result> result = entities.GetCompanyInfo(
                systemID,
                bpID,
                companyID);
            GetCompanyInfo_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetMWAttestationRequests
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="requestID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetMWAttestationRequests_Result[] GetMWAttestationRequests(
            int systemID,
            int bpID,
            int companyID,
            int requestID,
            string sessionID)
        {
            ObjectResult<GetMWAttestationRequests_Result> result = entities.GetMWAttestationRequests(
                systemID,
                bpID,
                companyID,
                requestID);
            GetMWAttestationRequests_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetDialog
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="dialogID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public System_Dialogs GetDialog(int systemID, int dialogID, string sessionID)
        {
            System_Dialogs result = entities.System_Dialogs.FirstOrDefault(d => d.SystemID == systemID && d.DialogID == dialogID);
            if (result != null)
            {
                return result;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetPass
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="withFileData"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Pass GetPass(int systemID, int bpID, int employeeID, bool withFileData, string sessionID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT SystemID, BpID, PassID, InternalID, ExternalID, NameVisible, DescriptionShort, ValidFrom, ValidUntil, EmployeeID, TypeID, [FileName], FileType, ");
            if (withFileData)
            {
                sql.Append("FileData, ");
            }
            else
            {
                sql.Append("NULL AS FileData, ");
            }
            sql.Append("PrintedFrom, PrintedOn, ActivatedFrom, ActivatedOn, DeactivatedFrom, DeactivatedOn, LockedFrom, LockedOn, CreatedFrom, CreatedOn, EditFrom, EditOn ");
            sql.Append("FROM Master_Passes ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND EmployeeID = @EmployeeID ");

            SqlCommand cmd = new SqlCommand(sql.ToString(), connection);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = bpID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = employeeID;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;
            DataTable dt = new DataTable();

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            Pass pass = new Pass();

            if (dt.Rows.Count > 0)
            {
                try
                {
                    DataRow row = dt.Rows[0];

                    pass.SystemID = Convert.ToInt32(row["SystemID"]);
                    pass.BpID = Convert.ToInt32(row["BpID"]);
                    pass.PassID = Convert.ToInt32(row["PassID"]);
                    pass.InternalID = row["InternalID"].ToString();
                    pass.ExternalID = row["ExternalID"].ToString();
                    pass.NameVisible = row["NameVisible"].ToString();
                    pass.DescriptionShort = row["DescriptionShort"].ToString();
                    if (row["ValidFrom"] != DBNull.Value)
                    {
                        pass.ValidFrom = Convert.ToDateTime(row["ValidFrom"]);
                    }
                    if (row["ValidUntil"] != DBNull.Value)
                    {
                        pass.ValidUntil = Convert.ToDateTime(row["ValidUntil"]);
                    }
                    pass.TypeID = Convert.ToInt32(row["TypeID"]);
                    pass.FileName = row["FileName"].ToString();
                    pass.FileType = row["FileType"].ToString();
                    if (row["FileData"] != DBNull.Value)
                    {
                        pass.FileData = (byte[])row["FileData"];
                    }
                    pass.PrintedFrom = row["PrintedFrom"].ToString();
                    if (row["PrintedOn"] != DBNull.Value)
                    {
                        pass.PrintedOn = Convert.ToDateTime(row["PrintedOn"]);
                    }
                    pass.ActivatedFrom = row["ActivatedFrom"].ToString();
                    if (row["ActivatedOn"] != DBNull.Value)
                    {
                        pass.ActivatedOn = Convert.ToDateTime(row["ActivatedOn"]);
                    }
                    pass.DeactivatedFrom = row["DeactivatedFrom"].ToString();
                    if (row["DeactivatedOn"] != DBNull.Value)
                    {
                        pass.DeactivatedOn = Convert.ToDateTime(row["DeactivatedOn"]);
                    }
                    pass.LockedFrom = row["LockedFrom"].ToString();
                    if (row["LockedOn"] != DBNull.Value)
                    {
                        pass.LockedOn = Convert.ToDateTime(row["LockedOn"]);
                    }
                    pass.CreatedFrom = row["CreatedFrom"].ToString();
                    pass.CreatedOn = Convert.ToDateTime(row["CreatedOn"]);
                    pass.EditFrom = row["EditFrom"].ToString();
                    pass.EditOn = Convert.ToDateTime(row["EditOn"]);
                }
                catch (SqlException ex)
                {
                    logger.Error("SqlException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
            }

            return pass;
        }

        /// <summary>
        /// GetShortTermPassPrint
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="printID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public ShortTermPassPrint GetShortTermPassPrint(int systemID, int bpID, int printID, string sessionID)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT SystemID, BpID, PrintID, [FileName], FileType, FileData, PrintedFrom, PrintedOn ");
            sql.Append("FROM Data_ShortTermPassesPrint ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND BpID = @BpID ");
            sql.Append("AND PrintID = @PrintID ");

            SqlCommand cmd = new SqlCommand(sql.ToString(), connection);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = systemID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = bpID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@PrintID", SqlDbType.Int);
            par.Value = printID;
            cmd.Parameters.Add(par);

            SqlDataAdapter adapter = new SqlDataAdapter();
            adapter.SelectCommand = cmd;
            DataTable dt = new DataTable();

            if (connection.State != ConnectionState.Open)
            {
                connection.Open();
            }
            try
            {
                adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                logger.Error("SqlException: ", ex);
                throw;
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                throw;
            }
            finally
            {
                connection.Close();
            }

            ShortTermPassPrint pass = new ShortTermPassPrint();

            if (dt.Rows.Count > 0)
            {
                try
                {
                    DataRow row = dt.Rows[0];

                    pass.SystemID = Convert.ToInt32(row["SystemID"]);
                    pass.BpID = Convert.ToInt32(row["BpID"]);
                    pass.PrintID = Convert.ToInt32(row["PrintID"]);
                    pass.FileName = row["FileName"].ToString();
                    pass.FileType = row["FileType"].ToString();
                    if (row["FileData"] != DBNull.Value)
                    {
                        pass.FileData = (byte[])row["FileData"];
                    }
                    pass.PrintedFrom = row["PrintedFrom"].ToString();
                    if (row["PrintedOn"] != DBNull.Value)
                    {
                        pass.PrintedOn = Convert.ToDateTime(row["PrintedOn"]);
                    }
                }
                catch (SqlException ex)
                {
                    logger.Error("SqlException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
            }

            return pass;
        }

        /// <summary>
        /// GetShortTermPassTemplate
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="shortTermPassTypeID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public string GetShortTermPassTemplate(int systemID, int bpID, int shortTermPassTypeID, string sessionID)
        {
            ObjectResult<string> result = entities.GetShortTermPassTemplate(
                systemID,
                bpID,
                shortTermPassTypeID);
            string[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult[0];
            }
            else
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// GetEmployeePassTemplate
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="dialogID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public string GetEmployeePassTemplate(int systemID, int bpID, int employeeID, int dialogID, string sessionID)
        {
            ObjectResult<string> result = entities.GetEmployeePassTemplate(
                systemID,
                bpID,
                employeeID,
                dialogID);
            string[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult[0];
            }
            else
            {
                return string.Empty;
            }
        }

        /// <summary>
        /// GetPresentPersonsPerAccessArea
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetPresentPersonsPerAccessArea_Result[] GetPresentPersonsPerAccessArea(int systemID, int bpID, string sessionID)
        {
            ObjectResult<GetPresentPersonsPerAccessArea_Result> result = entities.GetPresentPersonsPerAccessArea(
                systemID,
                bpID);
            GetPresentPersonsPerAccessArea_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetMissingFirstAiders
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetMissingFirstAiders_Result[] GetMissingFirstAiders(int systemID, int bpID, string sessionID)
        {
            ObjectResult<GetMissingFirstAiders_Result> result = entities.GetMissingFirstAiders(
                systemID,
                bpID);
            GetMissingFirstAiders_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetLastUpdateAccessControl
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_AccessSystems GetLastUpdateAccessControl(int systemID, int bpID, string sessionID)
        {
            Master_AccessSystems result = entities.Master_AccessSystems.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID);
            return result;
        }

        /// <summary>
        /// GetLastBackupDate
        /// </summary>
        /// <param name="schedulerID"></param>
        /// <returns></returns>
        public DateTime GetLastBackupDate(string sessionID)
        {
            logger.Info("Enter GetLastBackupDate");

            DateTime lastBackup = DateTime.MinValue;

            System_Systems system = entities.System_Systems.FirstOrDefault(s => s.IsMainSystem);
            if (system != null)
            {
                if (system.LastBackup != null)
                {
                    lastBackup = (DateTime)system.LastBackup;
                }
            }

            return lastBackup;
        }

        /// <summary>
        /// GetLastCompressDate
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public DateTime GetLastCompressDate(int systemID, int bpID, string sessionID)
        {
            logger.Info("Enter GetLastCompressDate");

            DateTime lastCompress = DateTime.MinValue;

            Master_AccessSystems accessSystem = entities.Master_AccessSystems.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID);
            if (accessSystem != null)
            {
                lastCompress = accessSystem.LastCompress;
            }

            return lastCompress;
        }

        /// <summary>
        /// GetLastCorrectionDate
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public DateTime GetLastCorrectionDate(int systemID, int bpID, string sessionID)
        {
            logger.Info("Enter GetLastCorrectionDate");

            DateTime lastCorrection = DateTime.MinValue;

            Master_AccessSystems accessSystem = entities.Master_AccessSystems.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID);
            if (accessSystem != null && accessSystem.LastAddition != null)
            {
                lastCorrection = (DateTime)accessSystem.LastAddition;
            }

            return lastCorrection;
        }

        /// <summary>
        /// GetPassInfo
        /// </summary>
        /// <param name="internalID"></param>
        /// <returns></returns>
        public GetPassInfo_Result[] GetPassInfo(string internalID, string sessionID)
        {
            logger.InfoFormat("Enter GetPassInfo with param internalID: {0}", internalID);

            ObjectResult<GetPassInfo_Result> result = entities.GetPassInfo(internalID);
            GetPassInfo_Result[] resultArray = result.ToArray();
            if (resultArray.Count() > 0)
            {
                return resultArray;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetCompanyMWContact
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_CompanyContacts GetCompanyMWContact(int systemID, int bpID, int companyID, string sessionID)
        {
            logger.InfoFormat("Enter GetCompanyMWContact with params systemID: {0}, bpID: {1}, companyID: {2}", systemID, bpID, companyID);

            Master_CompanyContacts result = entities.Master_CompanyContacts.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID && a.CompanyID == companyID);
            return result;
        }

        /// <summary>
        /// GetCompanyAdmin
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Master_Users GetCompanyAdmin(int systemID, int companyID, string sessionID)
        {
            logger.InfoFormat("Enter GetCompanyAdmin with params systemID: {0}, companyID: {1}", systemID, companyID);

            System_Companies company = entities.System_Companies.FirstOrDefault(c => c.SystemID == systemID && c.CompanyID == companyID);
            if (company != null)
            {
                int userID = company.UserID;

                Master_Users result = entities.Master_Users.FirstOrDefault(u => u.SystemID == systemID && u.UserID == userID);
                return result;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// HasRightForDialog
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="dialogID"></param>
        /// <param name="roleID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public bool HasRightForDialog(int systemID, int bpID, int dialogID, int roleID, string sessionID)
        {
            logger.InfoFormat("Enter HasRightForDialog with params systemID: {0}, bpID: {1}, dialogID: {2}, roleID: {3}", systemID, bpID, dialogID, roleID);

            bool hasRight = false;

            Master_Roles_Dialogs result = entities.Master_Roles_Dialogs.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID && a.DialogID == dialogID && a.RoleID == roleID);
            if (result != null)
            {
                if (result.IsActive)
                {
                    hasRight = true;
                }
            }

            return hasRight;
        }

        /// <summary>
        /// GetRelevantDocumentImage
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="relevantDocumentID"></param>
        /// <param name="maxWidth"></param>
        /// <param name="maxHeight"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public byte[] GetRelevantDocumentImage(int systemID, int bpID, int relevantDocumentID, int maxWidth, int maxHeight, string sessionID)
        {
            logger.InfoFormat("Enter GetRelevantDocumentImage with params systemID: {0}, bpID: {1}, relevantDocumentID: {2}, maxWidth: {3}, maxHeight: {4}", systemID, bpID, relevantDocumentID, maxWidth, maxHeight);

            Master_RelevantDocuments result = entities.Master_RelevantDocuments.FirstOrDefault(r => r.SystemID == systemID && r.BpID == bpID && r.RelevantDocumentID == relevantDocumentID);
            if (result != null && result.SampleData != null)
            {
                Image image = Helpers.ByteArrayToImage(result.SampleData);
                image = Helpers.ScaleImage(image, maxWidth, maxHeight);
                string extension = Path.GetExtension(result.SampleFileName);
                return Helpers.ImageToByteArray(image, Helpers.ParseImageFormat(extension));
            }

            return new byte[0];
        }

        /// <summary>
        /// SetMailRead
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="mailID"></param>
        /// <param name="mailRead"></param>
        /// <param name="sessionID"></param>
        public void SetMailRead(int systemID, int mailID, bool mailRead, string sessionID)
        {
            logger.InfoFormat("Enter SetMailRead with params systemID: {0}, mailID: {1}; mailRead: {2}", systemID, mailID, mailRead);

            System_Mailbox mail = entities.System_Mailbox.FirstOrDefault(m => m.SystemID == systemID && m.Id == mailID);
            if (mail != null)
            {
                if (mailRead)
                {
                    mail.MailRead = DateTime.Now;
                }
                else
                {
                    mail.MailRead = null;
                }

                EntitySaveChanges(true);
            }
        }

        /// <summary>
        /// GetDocument
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="documentID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Document GetDocument(int systemID, int documentID, string sessionID)
        {
            logger.InfoFormat("Enter GetDocument with params systemID: {0}, documentID: {1}", systemID, documentID);

            System_Documents systemDocument = entities.System_Documents.FirstOrDefault(d => d.SystemID == systemID && d.Id == documentID);
            if (systemDocument != null)
            {
                Document document = new Document();
                document.SystemID = systemDocument.SystemID;
                document.DocumentID = systemDocument.Id;
                document.FileName = systemDocument.DocumentName;
                document.FileType = systemDocument.DocumentType;
                document.FileData = systemDocument.Document;

                logger.InfoFormat("Document {0} found with length {1}", document.FileName, document.FileData.Length);
                return document;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// RenderReport
        /// Render report with parameters
        /// </summary>
        /// <param name="reportParameter"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public Document RenderReport(string reportParameter, string sessionID)
        {
            logger.Info("Enter RenderReport");
            
            byte[] output;
            string mimeType;
            string extension;
            string comment;
            string message;
            
            int ret = Reporting.RenderReport(reportParameter, out output, out extension, out mimeType, out comment, out message);
            
            Document document = new Document();
            document.DocumentID = ret;
            if (ret == 0)
            {
                document.Comment = comment;
            }
            else
            {
                document.Comment = message;
            }
            document.FileType = mimeType;
            document.FileExtension = extension;
            document.FileData = output;

            return document;
        }

        /// <summary>
        /// GetHelp
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="dialogID"></param>
        /// <param name="fieldID"></param>
        /// <param name="languageID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public System_Help GetHelp(int systemID, int dialogID, int fieldID, string languageID, string sessionID)
        {
            logger.InfoFormat("Enter GetHelp with params systemID: {0}, dialogID: {1}, fieldID: {2}, languageID: {3}", systemID, dialogID, fieldID, languageID);
            System_Help result = entities.System_Help.FirstOrDefault(h => h.SystemID == systemID && h.DialogID == dialogID && h.FieldID == fieldID && h.LanguageID == languageID);
            return result;
        }

        /// <summary>
        /// GetExpiringTariffs
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetExpiringTariffs_Result[] GetExpiringTariffs(int systemID, string sessionID)
        {
            logger.InfoFormat("Enter GetExpiringTariffs with params systemID: {0}", systemID);
            ObjectResult<GetExpiringTariffs_Result> result = entities.GetExpiringTariffs(systemID);
            GetExpiringTariffs_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// SessionLogger
        /// Logs session events
        /// </summary>
        /// <param name="sessionID"></param>
        /// <param name="sessionState"></param>
        /// <param name="systemID"></param>
        /// <param name="userID"></param>
        public void SessionLogger(string sessionID, int sessionState, int? systemID, int? userID)
        {
            System_SessionLog sessionLog;
            IQueryable<System_SessionLog> result = entities.System_SessionLog.Where(l => l.SessionID == sessionID);
            System_SessionLog[] arrayResult = result.ToArray();

            if (sessionState == SessionState.SessionStart)
            {
                // Session started
                logger.InfoFormat("Session {0} started", sessionID);

                if (arrayResult.Count() > 0)
                {
                    // Session exists
                    sessionLog = arrayResult[0];
                }
                else
                {
                    // New session
                    sessionLog = new System_SessionLog();
                    sessionLog.SessionID = sessionID;
                }
                sessionLog.FirstUsed = DateTime.Now;
                sessionLog.SessionState = SessionState.SessionStart;

                // Save changes
                try
                {
                    if (arrayResult.Count() == 0)
                    {
                        entities.System_SessionLog.Add(sessionLog);
                    }
                    EntitySaveChanges(true);
                }
                catch (EntityException ex)
                {
                    logger.Error("EntityException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
            }
            else
            {
                if (arrayResult.Count() > 0)
                {
                    sessionLog = arrayResult[0];
                    if (sessionState == SessionState.SessionAuthenticated)
                    {
                        // Session authenticated
                        logger.InfoFormat("Session {0} authenticated; systemID: {1}; userID: {2}", sessionID, systemID, userID);
                        sessionLog.SystemID = systemID;
                        sessionLog.UserID = userID;
                        sessionLog.LastUsed = DateTime.Now;
                        sessionLog.SessionState = SessionState.SessionAuthenticated;

                        result = entities.System_SessionLog.Where(l => l.SessionID != sessionID && l.UserID == userID && sessionState != SessionState.SessionEnd);
                        arrayResult = result.ToArray();
                        if (arrayResult.Count() > 0)
                        {
                            foreach (System_SessionLog log in arrayResult)
                            {
                                logger.InfoFormat("Terminating session {0}", log.SessionID);
                                log.SessionState = SessionState.SessionEnd;

                                EntitySaveChanges(true);
                            }
                        }
                    }
                    else if (sessionState == SessionState.SessionUsed)
                    {
                        // Session used
                        if (sessionLog.LastUsed == null)
                        {
                            logger.InfoFormat("Session {0} used", sessionID);
                        }
                        sessionLog.LastUsed = DateTime.Now;
                        sessionLog.SessionState = SessionState.SessionUsed;
                    }
                    else if (sessionState == SessionState.SessionEnd)
                    {
                        // Session ended
                        logger.InfoFormat("Session {0} ended", sessionID);
                        sessionLog.LastUsed = DateTime.Now;
                        sessionLog.SessionState = SessionState.SessionEnd;
                    }

                    EntitySaveChanges(true);
                }
            }
        }

        /// <summary>
        /// IsPassCaseFirstIssue
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="replacementPassCaseID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public bool IsPassCaseFirstIssue(int systemID, int bpID, int replacementPassCaseID, string sessionID)
        {
            bool ret = false;
            Master_ReplacementPassCases result = entities.Master_ReplacementPassCases.FirstOrDefault(r => r.SystemID == systemID && r.BpID == bpID && r.ReplacementPassCaseID == replacementPassCaseID);
            if (result != null)
            {
                ret = result.IsInitialIssue;
            }
            return ret;
        }

        /// <summary>
        /// AllTerminalsOnline
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public bool AllTerminalsOnline(int systemID, int bpID, string sessionID)
        {
            bool ret = false;
            Master_AccessSystems result = entities.Master_AccessSystems.FirstOrDefault(r => r.SystemID == systemID && r.BpID == bpID);
            if (result != null)
            {
                ret = result.AllTerminalsOnline;
            }
            return ret;
        }

        /// <summary>
        /// GetEmployeeDuplicates
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employeeID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public GetEmployeeDuplicates_Result[] GetEmployeeDuplicates(int systemID, int bpID, int employeeID, string sessionID)
        {
            logger.InfoFormat("Enter GetEmployeeDuplicates with params systemID: {0}; bpID: {1}; employeeID: {2}", systemID, bpID, employeeID);
            ObjectResult<GetEmployeeDuplicates_Result> result = entities.GetEmployeeDuplicates(systemID, bpID, employeeID);
            GetEmployeeDuplicates_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetCompanyCentralDuplicates
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <returns></returns>
        public GetCompanyCentralDuplicates_Result[] GetCompanyCentralDuplicates(int systemID, int companyID, string sessionID)
        {
            logger.InfoFormat("Enter GetCompanyCentralDuplicates with params systemID: {0}; companyID: {1}", systemID, companyID);
            ObjectResult<GetCompanyCentralDuplicates_Result> result = entities.GetCompanyCentralDuplicates(systemID, companyID);
            GetCompanyCentralDuplicates_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetUserDuplicates
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="companyID"></param>
        /// <returns></returns>
        public GetUserDuplicates_Result[] GetUserDuplicates(int systemID, int userID, string sessionID)
        {
            logger.InfoFormat("Enter GetUserDuplicates with params systemID: {0}; userID: {1}", systemID, userID);
            ObjectResult<GetUserDuplicates_Result> result = entities.GetUserDuplicates(systemID, userID);
            GetUserDuplicates_Result[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                return arrayResult;
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// GetCompanyCentralInfo
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="companyID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public System_Companies GetCompanyCentralInfo(int systemID, int companyID, string sessionID)
        {
            logger.InfoFormat("Enter GetCompanyCentralInfo with params systemID: {0}; companyID: {1}", systemID, companyID);
            System_Companies systemCompany = entities.System_Companies.FirstOrDefault(c => c.SystemID == systemID && c.CompanyID == companyID);
            return systemCompany;
        }

        /// <summary>
        /// Update thumbnails in all address rows having photo data
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="sessionID"></param>
        public void UpdateThumbnails(int systemID, int bpID, string sessionID)
        {
            logger.InfoFormat("Enter UpdateThumbnails with params systemID: {0}; bpID: {1}", systemID, bpID);
            Master_Addresses[] addresses = entities.Master_Addresses.Where(a => a.SystemID == systemID && a.BpID == bpID && a.PhotoData != null).ToArray();
            if (addresses.Count() > 0)
            {
                logger.InfoFormat("{0} addresses with photo data found", addresses.Count().ToString());
                foreach (Master_Addresses address in addresses)
                {
                    if (address.PhotoData.Length > 0)
                    {
                        byte[] imageData = address.PhotoData;
                        int thumbnailSize = 45;
                        byte[] thumbnailData = Helpers.CreateThumbnail(imageData, thumbnailSize);
                        System.Drawing.Image img = Helpers.ByteArrayToImage(imageData);
                        img = Helpers.ScaleImage(img, 350, 450);
                        System.Drawing.Imaging.ImageFormat fmt = Helpers.ParseImageFormat(Path.GetExtension(address.PhotoFileName));
                        imageData = Helpers.ImageToByteArray(img, fmt);

                        address.ThumbnailData = thumbnailData;
                        address.PhotoData = imageData;

                        EntitySaveChanges(true);
                    }
                }

            }
        }

        /// <summary>
        /// Save changes to data source and do error handling, if needed
        /// </summary>
        /// <param name="throwError"></param>
        /// <returns></returns>
        private bool EntitySaveChanges(bool throwError)
        {
            bool changesSaved = false;
            try
            {
                entities.SaveChanges();
                changesSaved = true;
            }
            catch (DbEntityValidationException ex)
            {
                logger.Error("DbEntityValidationException: " + ex.Message);
                StringBuilder sb = new StringBuilder();

                foreach (var failure in ex.EntityValidationErrors)
                {
                    sb.AppendFormat("{0} failed validation\n", failure.Entry.Entity.GetType());
                    foreach (var error in failure.ValidationErrors)
                    {
                        sb.AppendFormat("- {0} : {1}", error.PropertyName, error.ErrorMessage);
                        sb.AppendLine();
                    }
                }
                logger.Debug("Entity Validation Failed - errors follow:\n" + sb.ToString() + "\n", ex);

                if (ex.InnerException != null)
                {
                    logger.Error("Inner DbEntityValidationException: " + ex.InnerException.Message);
                }
                logger.Debug("DbEntityValidationException Details: \n" + ex);
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                if (throwError)
                {
                    throw;
                }
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                if (throwError)
                {
                    throw;
                }
            }
            return changesSaved;
        }

        /// <summary>
        /// EmploymentStatusMWObligate
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <param name="employmentStatusID"></param>
        /// <param name="sessionID"></param>
        /// <returns></returns>
        public bool EmploymentStatusMWObligate(int systemID, int bpID, int employmentStatusID, string sessionID)
        {
            bool mwObligate = false;

            Master_EmploymentStatus es = entities.Master_EmploymentStatus.FirstOrDefault(e => e.SystemID == systemID && e.BpID == bpID && e.EmploymentStatusID == employmentStatusID);
            if (es != null)
            {
                mwObligate = es.MWObligate;
            }

            return mwObligate;
        }

        public List<GetPresentFirstAiders_Result> GetAvailableFirstAiders(int systemID, int bpID)
        {
            logger.InfoFormat("Enter GetPresentFirstAiders with params systemID: {0}; BpID: {1}", systemID, bpID);
            return entities.GetPresentFirstAiders(systemID, bpID).ToList();
        }

        public List<Data_AccessEvents> GetAccessHistoryForShortTermPasses(int systemId, int bpId,  string internalId)
        {
            logger.InfoFormat("Enter GetAccessHistoryForShortTermPasses with params systemID: {0}; BpID: {1}; internalId: {2}", systemId, bpId, internalId);
            return entities.Data_AccessEvents.Where(x => x.BpID == bpId && x.SystemID == systemId && x.InternalID == internalId).ToList(); 
        }
    }
}