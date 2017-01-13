using System;
using System.Linq;

namespace InSite.App.Views.Help
{
    public partial class Support : BasePagePopUp
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = Resources.Resource.lblSupport;
        }
    }
}