using System;
using System.Linq;

namespace InSite.App.Views.Help
{
    public partial class Info : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = Resources.Resource.lblInfo;
            AppName.Text = Resources.Resource.appName;
            CopyRight.Text = Resources.Resource.copyRight;
            AppVersion.Text = Helpers.AppFileVersion() + " (" + Helpers.AppDate().ToShortDateString() + ")";
        }
    }
}