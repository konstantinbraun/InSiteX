using System;
using System.Linq;
using System.Web.UI;
using System.IO;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web;

namespace InSite.App.ViewStatePersister
{
    public class CustomPageStatePersister : HiddenFieldPageStatePersister
    {
        private static readonly Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private readonly LosFormatter formatter;

        // Load the Configuration from web.config
        readonly CustomPageStatePersisterConfiguration configuration = new CustomPageStatePersisterConfiguration();

        // Call base constructor
        public CustomPageStatePersister(Page page) : base(page)
        {
            formatter = new LosFormatter();
        }

        /// <summary>
        /// Method that loads the ViewState from various sources and plugs it back on the page.
        /// </summary>
        public override void Load()
        {
            // Load Whatever is there in the __VIEWSTATE hidden variables.
            base.Load();

            // Check if the configuration is set to be switched OFF or none of the Custom persisters are set.
            if (configuration.IsSwitchOff || (!configuration.IsSqlPersisted && !configuration.IsCached && !configuration.IsCompressed))
                return;
            
            // Check if the Page configuration demands that only flaged pages need to be custom persisted 
            // & the current page implements ICustomStatePersistedPage
            if ((configuration.IsOnCustomPageOnly && !(base.Page is ICustomStatePersistedPage)) || (base.Page is IDefaultStatePersistedPage))
                return;

            string currentViewState = base.ViewState.ToString();

            // Lets check if the ViewState is a GUID. 
            // Dont need to check anything except the fact that the String is exactly 36 char.
            if (currentViewState.Length == 36)
            {
                CustomViewState vs = null;

                // If we have SQL Persistable state and we couldnt find it from cache, then go to the database. 
                if (vs == null && configuration.IsSqlPersisted)
                    vs = GetFromSql(currentViewState);
                
                // Deserialize the cache using the Formatter. 
                Deserialize(vs.Data);
            }
        }

        /// <summary>
        /// Saves the current ViewState into the database/cache as per configuration.
        /// </summary>
        public override void Save()
        {
            // Check if the configuration is set to be switched OFF or none of the Custom persisters are set.
            if (configuration.IsSwitchOff || (!configuration.IsSqlPersisted && !configuration.IsCached && !configuration.IsCompressed))
            {
                base.Save();
                return;
            }

            // Check if the Page configuration demands that only flaged pages need to be custom persisted 
            // & the current page implements ICustomStatePersistedPage
            if ((configuration.IsOnCustomPageOnly && !(base.Page is ICustomStatePersistedPage)) || (base.Page is IDefaultStatePersistedPage))
            {
                base.Save();
                return;
            }
            // Create the CustomViewState with data needed to save.
            CustomViewState vs = new CustomViewState
            {
                Id = Guid.NewGuid(),
                Data = Serialize(),
                TimeStamp = DateTime.Now
            };

            // Save to SQL if IsSqlPersisted is True
            if (configuration.IsSqlPersisted)
                SaveToSql(vs);

            // Save to Cache if IsCached is True.
            if (configuration.IsCached)
                SaveToSql(vs);
            //                    SaveToCache(vs, VIEWSTATE_CACHEKEY_PREFIX + vs.Id);
                
            // Replace the actual ViewState going to the page with the GUID.
            base.ViewState = vs.Id;
            base.ControlState = "";
            
            // Call base class method to do its job.
            base.Save();
        }

        private byte[] Serialize()
        {
            using (MemoryStream mem = new MemoryStream())
            {
                Pair pair = new Pair(base.ViewState, base.ControlState);
                formatter.Serialize(mem, pair);

                return mem.ToArray();
            }
        }

        private void Deserialize(byte[] buffer)
        {
            if (buffer != null)
            {
                using (MemoryStream mem = new MemoryStream(buffer))
                {
                    Pair pair = (Pair)formatter.Deserialize(mem);
                    if (pair != null && (pair is Pair))
                    {
                        base.ViewState = pair.First;
                        base.ControlState = pair.Second;
                    }
                }
            }
        }

        public void SaveToSql(CustomViewState vs)
        {
            if (vs != null && vs.Id != null && vs.Data != null)
            {
                SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString);
                SqlCommand cmd = new SqlCommand("InsertViewState", con);
                cmd.CommandType = CommandType.StoredProcedure;
                SqlParameter par;

                par = new SqlParameter("@VsId", SqlDbType.UniqueIdentifier);
                par.Direction = ParameterDirection.Input;
                par.Value = vs.Id;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@VsData", SqlDbType.VarBinary);
                par.Direction = ParameterDirection.Input;
                par.Value = Helpers.Compress(vs.Data);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@VsTimeStamp", SqlDbType.DateTime);
                par.Direction = ParameterDirection.Input;
                par.Value = vs.TimeStamp;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@VsSession", SqlDbType.NVarChar, 200);
                par.Direction = ParameterDirection.Input;
                par.Value = HttpContext.Current.Session.SessionID;
                cmd.Parameters.Add(par);

                if (con.State != ConnectionState.Open)
                {
                    con.Open();
                }
                try
                {
                    cmd.ExecuteNonQuery();
                }
                catch (SqlException ex)
                {
                    logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, HttpContext.Current.Session.SessionID);
                    throw;
                }
                catch (System.Exception ex)
                {
                    logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, HttpContext.Current.Session.SessionID);
                    throw;
                }
                finally
                {
                    con.Close();
                }
            }
        }

        public CustomViewState GetFromSql(string vsId)
        {
            if (string.IsNullOrEmpty(vsId))
            {
                return null;
            }

            CustomViewState vs = null;
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString);
            SqlCommand cmd = new SqlCommand("GetViewState", con);
            cmd.CommandTimeout = 60;
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter par;

            par = new SqlParameter("@VsId", SqlDbType.NVarChar, 200);
            par.Direction = ParameterDirection.Input;
            par.Value = vsId;
            cmd.Parameters.Add(par);

            SqlDataReader reader;
            vs = new CustomViewState();
            // SqlDataAdapter adapter = new SqlDataAdapter();
            // adapter.SelectCommand = cmd;
            // DataTable dt = new DataTable();

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    vs.Id = (Guid)reader["VsId"];
                    vs.Data = Helpers.Decompress((byte[])reader["VsData"]);
                    vs.TimeStamp = Convert.ToDateTime(reader["VsTimeStamp"]);
                    vs.SessionID = reader["VsSession"].ToString();
                }
                // adapter.Fill(dt);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, HttpContext.Current.Session.SessionID);
                throw;
            }
            catch (System.Exception ex)
            {
                logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, HttpContext.Current.Session.SessionID);
                throw;
            }
            finally
            {
                con.Close();
            }

            return vs;
        }

        public static void SaveToSession(CustomViewState vs, string cacheKey)
        {
            if (vs != null && vs.Id != null && vs.Data != null)
            {
                HttpContext.Current.Session.Add(cacheKey, vs);
            }
        }

        public static CustomViewState GetFromSession(string cacheKey)
        {
            if (string.IsNullOrEmpty(cacheKey))
            {
                return null;
            }

            return (CustomViewState)HttpContext.Current.Session[cacheKey];
        }


        public static void DeleteViewStateData()
        {
            SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString);
            SqlCommand cmd = new SqlCommand("DeleteViewState", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter par;

            par = new SqlParameter("@VsSession", SqlDbType.NVarChar, 200);
            par.Direction = ParameterDirection.Input;
            par.Value = HttpContext.Current.Session.SessionID;
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0} - SessionID: {1}", ex.Message, HttpContext.Current.Session.SessionID);
                throw;
            }
            catch (System.Exception ex)
            {
                logger.FatalFormat("Fatal Error: {0} - SessionID: {1}", ex.Message, HttpContext.Current.Session.SessionID);
                throw;
            }
            finally
            {
                con.Close();
            }
        }
    }
}