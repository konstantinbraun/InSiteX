using System;
using System.Linq;

namespace InSite.App.Views.Costumization
{
    public partial class Hasher : App.BasePage
    {
        private static readonly log4net.ILog logger = log4net.LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void BtnOK_Click(object sender, EventArgs e)
        {
            Hash.Text = Helpers.HashPassword(Pwd.Text);
        }
    }
}