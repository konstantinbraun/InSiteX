using InSite.App.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace InSite.App.CustomControls
{
    public partial class wcBpContact : System.Web.UI.UserControl
    {
        protected void BpContactDataSource_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            clsBpContact model = (clsBpContact)e.InputParameters[0];
            model.BpId = Convert.ToInt32(Request.QueryString["id"]);
        }

    }
}