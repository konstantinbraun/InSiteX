using InSite.App.Models.Extensions;
using InSite.App.Models.Interfaces;
using InSite.App.UserServices;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace InSite.App.Models
{
    public enum ReportRoles
    {
        [Display(Name = "root")]
        Root,
        [Display(Name = "Super Admin")]
        SuperAdmin,
        [Display(Name = "Baustellen Admin")]
        BuildingAdmin,
        [Display(Name = "Objektüberwachung")]
        ObjectSupervisor,
        [Display(Name = "Firmenbeauftragter")]
        Commissioner
    }
    public class RoleSwitcher : BaseSwitcher
    {
        public override string GetCaption()
        {
            return Resources.Resource.lblRoles;  
        }

        public override Dictionary<int, string> GetDataSource(int masterId, bool showSelected)
        {
            //      IUserService webService = new UserServices.UserServiceClient();
            List<int> rolesSelectedForReport = GetSelectedId(masterId);
            //return webService.GetRoles(1, 1, 110, "")
            //        .Where(x => rolesSelectedForReport.Contains(x.BpID) == showSelected).OrderBy(x => x.NameVisible)
            //        .ToDictionary(x => x.RoleID, x => x.NameVisible);

            int[] values = (int[])Enum.GetValues(typeof(ReportRoles));
            var dict = new Dictionary<int, string>();

            for (int i = 0; i < values.Length; i++)
            {
                if (rolesSelectedForReport.Contains(i) == showSelected)
                    dict.Add(values[i], ((ReportRoles)values[i]).GetDisplayName());
            }
            return dict;
        }
        public override string GetKeyFieldName()
        {
            return "ReportRoleId";
        }
        public override string GetKeyTableName()
        {
            return "System_ReportToRole";
        }
        public override bool TransferItem(int masterId, int itemId, bool select)
        {
            string queryString;
            int itemCount = 0;

            if (select)
                queryString = "INSERT INTO System_ReportToRole(ReportId, ReportRoleId) VALUES (@ReportId, @RoleId)";
            else
                queryString = "DELETE FROM System_ReportToRole WHERE ReportId = @ReportId AND ReportRoleId= @RoleId";


            using (SqlConnection connection = new SqlConnection(BasePage.ConnectionString))
            {
                SqlCommand command = new SqlCommand(queryString, connection);
                command.Parameters.AddWithValue("@ReportId", masterId);
                command.Parameters.AddWithValue("@RoleId", itemId);
                try
                {
                    connection.Open();
                    itemCount = command.ExecuteNonQuery();
                    connection.Close();
                }
                catch (Exception ex)
                {
                    //      SetMessage(Resources.Resource.lblActionDelete, String.Format(Resources.Resource.msgDeleteFailed, ex.Message), "red");
                }
            }

            if (itemCount > 0)
                return true;
            return false;
        }

    }
}