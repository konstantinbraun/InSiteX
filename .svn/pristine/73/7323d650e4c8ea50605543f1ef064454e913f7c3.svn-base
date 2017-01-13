using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InSite.App
{
    public partial class SessionData : System.Web.UI.Page
    {
        private Dictionary<string, object> someData;

        private SessionData()
        {
            someData = new Dictionary<string, object>();
        }

        public static Dictionary<string, object> SomeData
        {
            get
            {
                SessionData sessionData = (SessionData)HttpContext.Current.Session["sessionData"];
                if (sessionData == null)
                {
                    sessionData = new SessionData();
                    HttpContext.Current.Session["sessionData"] = sessionData;
                }
                return sessionData.someData;
            }
        }
    }
}