using System;
using System.Linq;
using System.Security.Permissions;
using System.Web;
using System.Web.UI;

namespace InSite.App.ViewStatePersister
{
    [AspNetHostingPermission(SecurityAction.Demand, Level = AspNetHostingPermissionLevel.Minimal)]
    public class SessionPageStateAdapter : System.Web.UI.Adapters.PageAdapter
    {

        public override PageStatePersister GetStatePersister()
        {
            return new SessionPageStatePersister(Page);
        }
    }
}