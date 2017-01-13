using System;
using System.Linq;
using System.Security.Permissions;
using System.Web;
using System.Web.UI;

namespace InSite.App.ViewStatePersister
{

    [AspNetHostingPermission(SecurityAction.Demand, Level = AspNetHostingPermissionLevel.Minimal)]
    public class SessionPageStatePersister : PageStatePersister
    {
    
        public SessionPageStatePersister(Page page) : base(page)
        {
        }

        //
        // Load ViewState and ControlState.
        //
        public override void Load()
        {
            string key = Page.Request.Url + "_VIEWSTATE";

            if (Page.Session[key] != null)
            {
                CompressedStateFormatter formatter = new CompressedStateFormatter(base.StateFormatter);
                string viewState = Page.Session[key] as string;
                Pair statePair = (Pair)formatter.Deserialize(viewState);

                ViewState = statePair.First;
                ControlState = statePair.Second;
            }
        }

        //
        // Persist any ViewState and ControlState.
        //
        public override void Save()
        {
            if (ViewState != null || ControlState != null)
            {
                if (Page.Session != null)
                {
                    CompressedStateFormatter formatter = new CompressedStateFormatter(base.StateFormatter);
                    Pair statePair = new Pair(ViewState, ControlState);

                    string serializedState = formatter.Serialize(statePair);

                    string key = Page.Request.Url + "_VIEWSTATE";

                    Page.Session[key] = serializedState;
                }
                else
                {
                    throw new InvalidOperationException("Session needed for StreamPageStatePersister.");
                }
            }
        }
    }
}