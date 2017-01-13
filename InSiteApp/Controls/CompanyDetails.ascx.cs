using InSite.App.Constants;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace InSite.App.Controls
{
    public partial class CompanyDetails : System.Web.UI.UserControl
    {
        private static Type type = System.Reflection.MethodBase.GetCurrentMethod().DeclaringType;

        public int CompanyID { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            BindDataSource();
        }

        private void BindDataSource()
        {
            StringBuilder sql = new StringBuilder();

                sql.Append("SELECT c.SystemID, c.BpID, c.CompanyID, c.CompanyCentralID, cc.NameVisible, cc.NameAdditional, c.Description, cc.AddressID, c.IsVisible, ");
                sql.Append("c.IsValid, c.TradeAssociation, c.IsPartner, c.BlnSOKA, c.MinWageAttestation, c.StatusID, c.CreatedFrom, c.CreatedOn, c.EditFrom, c.EditOn, ");
                sql.Append("c.RequestFrom, c.RequestOn, c.ReleaseFrom, c.ReleaseOn, c.LockedFrom, c.LockedOn, a.Address1, c.RegistrationCode, c.CodeValidUntil, ");
                sql.Append("a.Address2, a.Zip, a.City, a.State, a.CountryID, a.Phone, a.Email, a.WWW, c.UserString1, c.UserString2, c.UserString3, c.UserString4, ");
                sql.Append("c.UserBit1, c.UserBit2, c.UserBit3, c.UserBit4, c.ParentID, ");
                sql.Append("cp.NameVisible AS ParentNameVisible, cp.NameAdditional AS ParentNameAdditional, m_c.NameVisible AS CountryName, s_l.FlagName, c.LockSubContractors, ");
                sql.Append("c.MinWageAccessRelevance, c.PassBudget, c.AllowSubcontractorEdit ");
                sql.Append("FROM Master_Companies AS c ");
                sql.Append("INNER JOIN System_Companies AS cc ");
                sql.Append("ON c.SystemID = cc.SystemID AND c.CompanyCentralID = cc.CompanyID ");
                sql.Append("INNER JOIN System_Addresses AS a ");
                sql.Append("ON cc.SystemID = a.SystemID AND cc.AddressID = a.AddressID ");
                sql.Append("LEFT OUTER JOIN Master_Companies AS cp ");
                sql.Append("ON c.SystemID = cp.SystemID AND c.BpID = cp.BpID AND c.ParentID = cp.CompanyID ");
		        sql.Append("LEFT OUTER JOIN Master_Countries AS m_c ");
			    sql.Append("ON a.SystemID = m_c.SystemID ");
				sql.Append("AND a.CountryID = m_c.CountryID ");
                sql.Append("LEFT OUTER JOIN View_Countries AS s_l ");
                sql.Append("ON m_c.CountryID = s_l.CountryID ");
                sql.Append("WHERE (c.SystemID = @SystemID) ");
                sql.Append("AND (c.BpID = @BpID) ");
                sql.Append("AND c.CompanyID = @CompanyID ");
                sql.Append("AND m_c.BpID = @BpID ");

                SqlConnection con = new SqlConnection(ConnectionString);
                SqlCommand cmd = new SqlCommand(sql.ToString(), con);
                SqlDataAdapter adapter = new SqlDataAdapter();
                SqlParameter par = new SqlParameter();

                par = new SqlParameter("@SystemID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["SystemID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@BpID", SqlDbType.Int);
                par.Value = Convert.ToInt32(HttpContext.Current.Session["BpID"]);
                cmd.Parameters.Add(par);

                par = new SqlParameter("@CompanyID", SqlDbType.Int);
                par.Value = CompanyID;
                cmd.Parameters.Add(par);

                adapter.SelectCommand = cmd;

                DataTable dt = new DataTable();

                con.Open();
                try
                {
                    adapter.Fill(dt);
                    CompanyDetailsFormView.DataSource = dt;
                    CompanyDetailsFormView.DataBind();
                }
                catch (SqlException ex)
                {
                    Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
                }
                catch (System.Exception ex)
                {
                    Helpers.DialogLogger(type, Actions.View, "0", String.Format(Resources.Resource.lblActionSelect, ex.Message));
                }
                finally
                {
                    con.Close();
                }
        }

        public String GetResource(String resourceName)
        {
            object res = GetGlobalResourceObject("Resource", resourceName);
            if (res != null)
            {
                return res.ToString();
            }
            else
            {
                return "";
            }
        }

        public static string ConnectionString
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString;
            }
        }
    }
}