using InSite.App.Constants;
using InSite.App.UserServices;
using log4net;
using System;
using System.Configuration;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Web.Services.Protocols;
using System.Web.SessionState;

namespace InSite.App
{
    public class Global : System.Web.HttpApplication
    {
        private static readonly ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        protected void Application_Start(object sender, EventArgs e)
        {
            // log4net Logging Level "DIALOG" hinzufügen
            log4net.Core.Level authLevel = new log4net.Core.Level(50000, "DIALOG");
            LogManager.GetRepository().LevelMap.Add(authLevel);

            // log4net Eigenschaften initialisieren
            log4net.Config.XmlConfigurator.Configure();
            GlobalContext.Properties["SystemID"] = 0;
            GlobalContext.Properties["BpID"] = 0;
            GlobalContext.Properties["SessionID"] = string.Empty;
            GlobalContext.Properties["IsDialog"] = false;
            GlobalContext.Properties["UserID"] = 0;
            GlobalContext.Properties["ActionID"] = 0;
            GlobalContext.Properties["RefID"] = "0";

            logger.Debug("++++++++++++++++++++++++++++");
            logger.Info("Logger initialized and application started");
            logger.Debug("++++++++++++++++++++++++++++");
        }

        protected void Session_Start(object sender, EventArgs e)
        {
            logger.Debug("++++++++++++++++++++++++++++");
            logger.InfoFormat("Start session {0} ...", Session.SessionID);

            Session["IsLoggedIn"] = false;
            Session["pageTitle"] = Resources.Resource.appName;
            Session["AdvertID"] = 0;
            Session["TreeViewNodeID"] = null;
            Session["ACSLastState"] = "1";
            Session["ATLastState"] = "1";
            Session["MinPwdLength"] = ConfigurationManager.AppSettings["MinPwdLength"];
            Session["LastEdited"] = false;
            string currentCulture = Request.UserLanguages[0];
            SetCurrentCulture(currentCulture);
            Session.Timeout = Convert.ToInt32(Properties.AppDefaults.sessionLengthMinutes);

            GlobalContext.Properties["SessionID"] = Session.SessionID;

            Helpers.SessionLogger(Session.SessionID, SessionState.SessionStart, null, null);

            logger.InfoFormat("... Session {0} started", Session.SessionID);
            logger.Debug("++++++++++++++++++++++++++++");
        }
        
        protected void Application_PostAcquireRequestState(object sender, EventArgs e)
        {
            if (Context.Handler is IRequiresSessionState)
            {
                ThreadContext.Properties["SessionID"] = Session.SessionID;
                ThreadContext.Properties["LoginName"] = Session["LoginName"];
            }
        }

        //protected void Application_BeginRequest(object sender, EventArgs e)
        //{

        //}

        //protected void Application_AuthenticateRequest(object sender, EventArgs e)
        //{

        //}

        protected void Application_Error(object sender, EventArgs e)
        {
            Exception ex = Server.GetLastError();

            logger.Debug("+++++++++ERROR_BEGIN++++++++++");
            logger.Error("Exception: ", ex);
            logger.Debug("+++++++++ERROR_END++++++++++++");
            //Server.ClearError();
        }

        protected void Session_End(object sender, EventArgs e)
        {
            logger.Debug("++++++++++++++++++++++++++++");
            logger.Info("Session ended");
            logger.Debug("++++++++++++++++++++++++++++");
        }

        //protected void Application_End(object sender, EventArgs e)
        //{

        //}

        private void SetCurrentCulture(string currentCulture)
        {
            Session["currentCulture"] = currentCulture;
            Thread.CurrentThread.CurrentCulture = CultureInfo.CreateSpecificCulture(currentCulture);
            Thread.CurrentThread.CurrentUICulture = new CultureInfo(currentCulture);
        }
    }
}