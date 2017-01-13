using System;
using System.Linq;
using System.Web.UI.Adapters;

namespace InSite.App.ViewStatePersister
{
    public class CustomPageAdapter : PageAdapter
    {
        public override System.Web.UI.PageStatePersister GetStatePersister()
        {
            return new CustomPageStatePersister(Page);
            //return base.GetStatePersister();
        }
    }
}
