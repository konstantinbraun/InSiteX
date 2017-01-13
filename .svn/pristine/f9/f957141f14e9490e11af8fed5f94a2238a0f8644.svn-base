using InSite.App.Constants;
using InSite.App.CMServices;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Text;
using Telerik.Web.UI;

namespace InSite.App.Views.Central
{
    public partial class RegisterToBp : System.Web.UI.Page
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(type);
        private static string idName = "CompanyID";
        protected int myCompanyID;
        private int action = Actions.View;

        protected void Page_Load(object sender, EventArgs e)
        {
            string msg = Request.QueryString["CompanyID"];
            if (msg != null)
            {
                myCompanyID = Convert.ToInt32(msg);
            }
            InitBp();
        }

        private static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }

        protected void InitBp()
        {
            StringBuilder sql = new StringBuilder();
            sql.Append("SELECT SystemID, BpID, NameVisible, DescriptionShort ");
            sql.Append("FROM Master_BuildingProjects AS b ");
            sql.Append("WHERE SystemID = @SystemID ");
            sql.Append("AND IsVisible = 1 ");
            sql.Append("AND TypeID = 1 ");
            sql.Append("AND NOT EXISTS (SELECT 1 FROM Master_Companies WHERE (SystemID = b.SystemID) AND BpID = b.BpID AND (CompanyCentralID = @CompanyID)) ");
            sql.Append("ORDER BY NameVisible ");

            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand(sql.ToString(), con);
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = myCompanyID;
            cmd.Parameters.Add(par);

            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
                BpID.DataSource = dt;
                BpID.DataBind();
            }
            catch (SqlException ex)
            {
                Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                throw;
            }
            catch (System.Exception ex)
            {
                Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                throw;
            }
            finally
            {
                con.Close();
            }
        }

        protected void UnloadMe()
        {
            string script = "<script language='javascript' type='text/javascript'>Sys.Application.add_load(cancelAndClose);</script>";
            RadScriptManager.RegisterStartupScript(this, this.GetType(), "cancelAndClose", script, false);
        }

        protected void BtnCancel_Click(object sender, EventArgs e)
        {
            UnloadMe();
        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                StringBuilder sql = new StringBuilder();
                sql.Append("INSERT INTO [Master_Companies] ([SystemID], BpID, CompanyID, CompanyCentralID, ParentID, [NameVisible], NameAdditional, [Description], [AddressID], [IsVisible], [IsValid], TradeAssociation, ");
                sql.Append("IsPartner, BlnSOKA, MinWageAttestation, UserString1, UserString2, UserString3, UserString4, UserBit1, UserBit2, UserBit3, UserBit4, [CreatedFrom], [CreatedOn], ");
                sql.Append("[EditFrom], [EditOn], LockSubContractors, MinWageAccessRelevance, PassBudget, StatusID, AllowSubcontractorEdit) ");
                sql.Append("SELECT @SystemID, @BpID, @CompanyID, @CompanyCentralID, @ParentID, NameVisible, NameAdditional, Description, AddressID, 1, 1, TradeAssociation, @IsPartner, @BlnSOKA, ");
                sql.Append("@MinWageAttestation, @UserString1, @UserString2, @UserString3, @UserString4, @UserBit1, @UserBit2, @UserBit3, @UserBit4, @UserName, SYSDATETIME(), @UserName, ");
                sql.Append("SYSDATETIME(), @LockSubContractors, @MinWageAccessRelevance, @PassBudget, @StatusID, @AllowSubcontractorEdit ");
                sql.AppendLine("FROM System_Companies WHERE SystemID = @SystemID AND CompanyID = @CompanyCentralID; ");
                sql.Append("INSERT INTO [Master_CompanyTariffs] ([SystemID], BpID, [TariffScopeID], CompanyID, [ValidFrom], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn]) ");
                sql.Append("SELECT [SystemID], @BpID, dbo.BestTariffScope(@SystemID, @BpID, TariffScopeID), @CompanyID, [ValidFrom], [CreatedFrom], [CreatedOn], [EditFrom], [EditOn] ");
                sql.Append("FROM System_CompanyTariffs WHERE SystemID = @SystemID AND CompanyID = @CompanyCentralID ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(BpID.SelectedValue);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserName", SqlDbType.NVarChar, 50);
                par.Value = Session["LoginName"].ToString();
                cmd.Parameters.Add(par);

                int companyIDBp = Helpers.GetNextID("CompanyID");
                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                par.Value = companyIDBp;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyCentralID", SqlDbType.Int);
                par.Value = myCompanyID;
                cmd.Parameters.Add(par);

                int parentValue;
                if (CompanyID.SelectedValue != null)
                {
                    parentValue = Convert.ToInt32(CompanyID.SelectedValue.Split(',')[0]);
                }
                else
                {
                    parentValue = 0;
                }
                par = new SqlParameter("@ParentID", SqlDbType.Int);
                par.Value = parentValue;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@Description", SqlDbType.NVarChar, 2000);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@TradeAssociation", SqlDbType.NVarChar, 200);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BlnSOKA", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@IsPartner", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@MinWageAccessRelevance", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@AllowSubcontractorEdit", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@PassBudget", SqlDbType.Decimal, 12);
                par.Value = 0.0;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@LockSubContractors", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@MinWageAttestation", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString1", SqlDbType.NVarChar, 50);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString2", SqlDbType.NVarChar, 50);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString3", SqlDbType.NVarChar, 50);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserString4", SqlDbType.NVarChar, 50);
                par.Value = string.Empty;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit1", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit2", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit3", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@UserBit4", SqlDbType.Bit);
                par.Value = false;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@StatusID", SqlDbType.Int);
                par.Value = Status.WaitRelease;
                cmd.Parameters.Add(par);

                par = new SqlParameter("@ReturnValue", SqlDbType.Int);
                par.Direction = ParameterDirection.Output;
                cmd.Parameters.Add(par);

                con.Open();
                try
                {
                    cmd.ExecuteNonQuery();

                    // Behältermanagement aktualisieren
                    ContainerManagementClient client = new ContainerManagementClient();
                    int systemID = Convert.ToInt32(Session["SystemID"]);
                    int bpID = Convert.ToInt32(Session["BpID"]);
                    try
                    {
                        client.CompanyData(systemID, bpID, myCompanyID, Actions.Insert);
                    }
                    catch (WebException ex)
                    {
                        logger.Error("Exception: " + ex.Message);
                        if (ex.InnerException != null)
                        {
                            logger.Error("Inner Exception: " + ex.InnerException.Message);
                        }
                        logger.Debug("Exception Details: \n" + ex);
                    }

                    Helpers.DialogLogger(type, Actions.Create, companyIDBp.ToString(), Resources.Resource.lblActionCreate);

                    // Eintrag in Vorgangsverwaltung
                    Data_ProcessEvents eventData = new Data_ProcessEvents();
                    eventData.DialogID = Helpers.GetDialogID("Companies");
                    eventData.ActionID = Actions.ReleaseBp;
                    eventData.RefID = companyIDBp;
                    eventData.NameVisible = "Firmenstamm BV";
                    eventData.DescriptionShort = "Daten komplett und stimmig?";
                    eventData.CompanyCentralID = myCompanyID;
                    List<Tuple<string, string>> values = new List<Tuple<string, string>>();
                    Helpers.SetProcessEvent(eventData, string.Empty, values.ToArray());

                    action = Actions.View;
                }
                catch (SqlException ex)
                {
                    Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                    throw;
                }
                catch (System.Exception ex)
                {
                    Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                    throw;
                }
                finally
                {
                    con.Close();
                }
            }

            UnloadMe();
        }

        protected void BpID_SelectedIndexChanged(object sender, RadComboBoxSelectedIndexChangedEventArgs e)
        {
            InitCompany();
        }

        protected void InitCompany()
        {
            SqlConnection con = new SqlConnection(ConnectionString);
            SqlCommand cmd = new SqlCommand("GetCompaniesSelection", con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter adapter = new SqlDataAdapter();
            SqlParameter par = new SqlParameter();

            par = new SqlParameter("@SystemID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["SystemID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@BpID", SqlDbType.Int);
            par.Value = Convert.ToInt32(BpID.SelectedValue);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@CompanyID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["CompanyID"]);
            cmd.Parameters.Add(par);

            par = new SqlParameter("@UserID", SqlDbType.Int);
            par.Value = Convert.ToInt32(Session["UserID"]);
            cmd.Parameters.Add(par);

            adapter.SelectCommand = cmd;

            DataTable dt = new DataTable();

            con.Open();
            try
            {
                adapter.Fill(dt);
                CompanyID.DataSource = dt;
                CompanyID.DataBind();
            }
            catch (SqlException ex)
            {
                Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                throw;
            }
            catch (System.Exception ex)
            {
                Helpers.DialogLogger(type, Actions.Create, "0", ex.Message);
                throw;
            }
            finally
            {
                con.Close();
            }
        }
    }
}