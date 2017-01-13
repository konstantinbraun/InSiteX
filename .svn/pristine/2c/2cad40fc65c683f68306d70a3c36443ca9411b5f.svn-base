using InSite.App.Constants;
using InSite.App.Models;
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
    public class dtoAccessEvent
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);

        private void DisplayMessage(string command, string text, string color)
        {
            //Meldung in Statuszeile und per Notification
            //Helpers.UpdateGridStatus(RadGrid1, command, text, color);
            //Helpers.ShowMessage(Master, command, text, color);
        }

        private string messageTitle = null;
        private string gridMessage = null;
        private string messageColor = null;

        private void SetMessage(string command, string message, string color)
        {
            // Message-Variablen belegen
            messageTitle = command;
            gridMessage = message;
            messageColor = color;
        }


        [DataObjectMethodAttribute(DataObjectMethodType.Select, true)]
        public List<clsAccessEvent> GetData(int systemId, int bpId,  string internalId)
        {
            UserServices.IUserService  service = new UserServices.UserServiceClient ();
            return service.GetAccessHistoryForShortTermPasses(systemId, bpId, internalId).Select(x => new clsAccessEvent()
                {
                    BpId = x.BpID,
                    SystemId = x.SystemID,
                    AccessTypeID = x.AccessType,
                    Result = x.AccessResult,
                    InternalId = x.InternalID,
                    IsManualEntry = x.IsManualEntry,
                    OriginalMessage =x.Remark,      
                    IsOnlineAccessEvent = x.IsOnlineAccessEvent, 
                    AccessOn = x.AccessOn, 
                    AccessAreaId = x.AccessAreaID,
                    AccessEventId = x.AccessEventID,
                    EditFrom = x.EditFrom,
                    EditOn = x.EditOn, 
                    CreatedFrom =x.CreatedFrom,
                    CreatedOn = x.CreatedOn   
                }).ToList() ;
        }

        [DataObjectMethodAttribute(DataObjectMethodType.Delete , true)]
        public void Delete(Models.clsAccessEvent model)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("DELETE FROM Data_AccessEvents ");
            sql.AppendLine("WHERE SystemID = @SystemID AND BpID = @BpID AND AccessEventID = @AccessEventID; ");

            SqlConnection con = new SqlConnection(BasePage.ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(model.SystemId );
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(model.BpId );
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessEventID", SqlDbType.Int);
            par.Value = Convert.ToInt32(model.AccessEventId );
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();

          //      Helpers.DialogLogger(type, Actions.Delete, (e.Item as GridDataItem).GetDataKeyValue("AccessEventID").ToString(), Resources.Resource.lblActionDelete);
                SetMessage(Resources.Resource.lblActionDelete, Resources.Resource.msgDeleteOK, "green");
                Helpers.SetAction(Actions.View);
            }
            catch (SqlException ex)
            {
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }
         
        [DataObjectMethodAttribute(DataObjectMethodType.Insert, true)]
        public void Insert(Models.clsAccessEvent model)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("INSERT INTO Data_AccessEvents(SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, ");
            sql.Append("AccessType, AccessResult, MessageShown, DenialReason, Remark, CreatedOn, CreatedFrom, IsManualEntry, EditOn, EditFrom, PassType) ");
            sql.Append("VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @EmployeeID, @InternalID, 0, @AccessOn, @AccessType, 1, 1, 0, @Remark, SYSDATETIME(), @UserName, 1, SYSDATETIME(), @UserName, 2)");


            SqlConnection con = new SqlConnection(BasePage.ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = model.SystemId;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = model.BpId;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = -1;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessAreaID", SqlDbType.Int);
            par.Value = model.AccessAreaId;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessOn", SqlDbType.DateTime);
            par.Value = model.AccessOn ;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessType", SqlDbType.Int);
            par.Value = model.AccessTypeID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@Remark", SqlDbType.NVarChar, 200);
            if (model.OriginalMessage != null)
                par.Value = model.OriginalMessage;
            else
                par.Value = "";

            cmd.Parameters.Add(par);

            par = new SqlParameter("@InternalId", SqlDbType.NVarChar, 200);
            par.Value = model.InternalId;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = model.CreatedFrom ;
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                //                lastID = Convert.ToInt32(cmd.Parameters["@AccessEventID"].Value);
                SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                Helpers.SetAction(Actions.View);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0}", ex.Message);
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                logger.ErrorFormat("Runtime Error: {0}", ex.Message);
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }

        [DataObjectMethodAttribute(DataObjectMethodType.Update, true)]
        public void Update(Models.clsAccessEvent model)
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("UPDATE Data_AccessEvents(SystemID, BfID, BpID, AccessAreaID, EntryID, PoeID, OwnerID, InternalID, IsOnlineAccessEvent, AccessOn, ");
            sql.Append("AccessType, AccessResult, MessageShown, DenialReason, Remark, CreatedOn, CreatedFrom, IsManualEntry, EditOn, EditFrom, PassType) ");
            sql.Append("VALUES (@SystemID, 0, @BpID, @AccessAreaID, 0, 0, @EmployeeID, @InternalID, 0, @AccessOn, @AccessType, 1, 1, 0, @Remark, SYSDATETIME(), @UserName, 1, SYSDATETIME(), @UserName, 2)");


            SqlConnection con = new SqlConnection(BasePage.ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = model.SystemId;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = model.BpId;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@EmployeeID", SqlDbType.Int);
            par.Value = -1;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessAreaID", SqlDbType.Int);
            par.Value = model.AccessAreaId;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessOn", SqlDbType.DateTime);
            par.Value = model.AccessOn;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@AccessType", SqlDbType.Int);
            par.Value = model.AccessTypeID;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@Remark", SqlDbType.NVarChar, 200);
            if (model.OriginalMessage != null)
                par.Value = model.OriginalMessage;
            else
                par.Value = "";

            cmd.Parameters.Add(par);

            par = new SqlParameter("@InternalId", SqlDbType.NVarChar, 200);
            par.Value = model.InternalId;
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
            par.Value = model.CreatedFrom;
            cmd.Parameters.Add(par);

            if (con.State != ConnectionState.Open)
            {
                con.Open();
            }
            try
            {
                cmd.ExecuteNonQuery();
                //                lastID = Convert.ToInt32(cmd.Parameters["@AccessEventID"].Value);
                SetMessage(Resources.Resource.lblActionInsert, Resources.Resource.msgInsertOK, "green");
                Helpers.SetAction(Actions.View);
            }
            catch (SqlException ex)
            {
                logger.ErrorFormat("SQL Error: {0}", ex.Message);
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
            }
            catch (System.Exception ex)
            {
                logger.ErrorFormat("Runtime Error: {0}", ex.Message);
                SetMessage(Resources.Resource.lblActionInsert, String.Format(Resources.Resource.msgInsertFailed, ex.Message), "red");
            }
            finally
            {
                con.Close();
            }

            // Message anzeigen
            if (!string.IsNullOrEmpty(gridMessage))
            {
                DisplayMessage(messageTitle, gridMessage, messageColor);
            }
        }
    }
}