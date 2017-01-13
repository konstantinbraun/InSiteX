using InSite.App.UserServices;
using log4net;
using System;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web.UI;

namespace InSite.App
{
    public class BasePagePopUp : Page
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
        private const string MDefaultCulture = "en-GB";

        protected override void OnLoad(EventArgs e)
        {
            // Benutzer Sprache laden
            UserAssignments user = Helpers.GetCurrentUserAssignment();
            if (Session != null && user != null)
            {
                Session["currentCulture"] = user.LanguageID;
            }
            base.OnLoad(e);
        }

        protected override void InitializeCulture()
        {
            if (!this.IsPostBack)
            {
                //retrieve culture information from session
                string culture = Convert.ToString(Session["currentCulture"]);

                //check whether a culture is stored in the session
                if (!string.IsNullOrEmpty(culture))
                    Culture = culture;
                else
                    Culture = MDefaultCulture;

                //set culture to current thread
                if (!Thread.CurrentThread.CurrentCulture.Name.ToLower().Equals(culture.ToLower()))
                {
                    Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(culture);
                    logger.DebugFormat("Current culture set to {0}", culture);
                }
                if (!Thread.CurrentThread.CurrentUICulture.Name.ToLower().Equals(culture.ToLower()))
                {
                    Thread.CurrentThread.CurrentUICulture = new CultureInfo(culture);
                    // logger.DebugFormat("Current UI culture set to {0}", culture);
                }
            }

            //call base class
            base.InitializeCulture();
        }
    }
}