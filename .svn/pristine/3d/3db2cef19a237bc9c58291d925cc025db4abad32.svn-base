using InSite.App.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace InSite.App.CustomControls
{
    public partial class wcShortTermPassAccess : System.Web.UI.UserControl
    {
        public string InternalId
        {
            get
            {
                return Session["InternalId"].ToString();
            }
            set
            {
                Session["InternalId"] = value;
            }
        }

        protected void AccessEventsDataSource_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            clsAccessEvent model = (clsAccessEvent)e.InputParameters[0];
            model.BpId = Convert.ToInt32 (Session["BpId"]) ;
            model.SystemId = Convert.ToInt32(Session["SystemId"]);
            model.InternalId = Session["InternalId"].ToString() ;
            model.CreatedFrom = Session["LoginName"].ToString();
        }
   
    }
}