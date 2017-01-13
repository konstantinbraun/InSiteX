using InSite.Scheduler.AdminServices;
using log4net;
using System;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.ServiceModel;
using System.ServiceProcess;
using System.Timers;
using System.Web.Services.Protocols;

namespace InSite.Scheduler
{
    public partial class InSiteSchedule : ServiceBase
    {
        private static readonly ILog logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private Timer timer = null;
        private string schedulerID = ConfigurationManager.AppSettings["SchedulerID"].ToString();

        public InSiteSchedule()
        {
            InitializeComponent();
            
            // Initialize logger
            log4net.Config.XmlConfigurator.Configure();

            // Initialize EventLog
            if (!EventLog.SourceExists("InSiteSchedule"))
            {
                EventLog.CreateEventSource("InSiteSchedule", "Application");
            }
            eventLog1.Source = "InSiteSchedule";
            eventLog1.Log = "Application";
        }

        protected override void OnStart(string[] args)
        {
            eventLog1.WriteEntry("Service starting");

            logger.Debug("++++++++++++++++++++++++++++");
            logger.Info("Service starting");
            logger.Debug("++++++++++++++++++++++++++++");
        
            // Initialize timer
            timer = new Timer();
            int interval = Convert.ToInt32(ConfigurationManager.AppSettings["MasterTimerInterval"]);
            timer.Interval = interval * 1000;
            timer.Elapsed += new ElapsedEventHandler(this.OnTimer);
            timer.Start();
            logger.InfoFormat("Timer started with interval of {0} seconds", interval.ToString());
        }

        protected override void OnStop()
        {
            eventLog1.WriteEntry("Service stopping");

            logger.Debug("++++++++++++++++++++++++++++");
            logger.Info("Service stopping");
            logger.Debug("++++++++++++++++++++++++++++");

            timer.Stop();
            timer.Dispose();
        }

        protected override void OnContinue()
        {
            eventLog1.WriteEntry("Service continues");

            logger.Debug("++++++++++++++++++++++++++++");
            logger.Info("Service continues");
            logger.Debug("++++++++++++++++++++++++++++");

            timer.Start();
        }

        protected override void OnPause()
        {
            eventLog1.WriteEntry("Service pausing");

            logger.Debug("++++++++++++++++++++++++++++");
            logger.Info("Service pausing");
            logger.Debug("++++++++++++++++++++++++++++");

            timer.Stop();
        }

        protected override void OnShutdown()
        {
            eventLog1.WriteEntry("System shutdown");

            logger.Debug("++++++++++++++++++++++++++++");
            logger.Info("System shutdown");
            logger.Debug("++++++++++++++++++++++++++++");

            timer.Stop();
            timer.Dispose();
        }

        public void OnTimer(object sender, ElapsedEventArgs args)
        {
            logger.InfoFormat("Loop time: {0}", args.SignalTime);

            timer.Stop();

            CallAdditionAccessTimes();

            CallCompressPresenceData();

            CallUpdateAccessRights();

            BackupDatabase();

            ExecuteDueJobs();

            CallTerminateUnusedSessions();

            timer.Start();
        }

        private void ExecuteDueJobs()
        {
            logger.Info("Enter ExecuteDueJobs");

            AdminServiceClient client = InitializeWebservice();

            try
            {
                client.ExecuteDueJobs(0);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                client.Abort();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("Webservice error: " + ex.Message, EventLogEntryType.Error);

                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                if (ex.InnerException != null)
                {
                    logger.ErrorFormat("Inner Exception: {0}", ex.InnerException.Message);
                }
                logger.DebugFormat("Exception Details: \n{0}", ex);
                client.Abort();
            }
            finally
            {
                client.Close();
            }
        }

        private void CallCompressPresenceData()
        {
            logger.Info("Enter CallCompressPresenceData");

            AdminServiceClient client = InitializeWebservice();

            try
            {
                client.CompressPresenceData(schedulerID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                client.Abort();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("Webservice error: " + ex.Message, EventLogEntryType.Error);

                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                if (ex.InnerException != null)
                {
                    logger.ErrorFormat("Inner Exception: {0}", ex.InnerException.Message);
                }
                logger.DebugFormat("Exception Details: \n{0}", ex);
                client.Abort();
            }
            finally
            {
                client.Close();
            }
        }

        private void CallAdditionAccessTimes()
        {
            logger.Info("Enter CallAdditionAccessTimes");

            AdminServiceClient client = InitializeWebservice();

            try
            {
                client.AdditionAccessTimes(schedulerID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                client.Abort();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("Webservice error: " + ex.Message, EventLogEntryType.Error);

                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                if (ex.InnerException != null)
                {
                    logger.ErrorFormat("Inner Exception: {0}", ex.InnerException.Message);
                }
                logger.DebugFormat("Exception Details: \n{0}", ex);
                client.Abort();
            }
            finally
            {
                client.Close();
            }
        }

        private void CallTerminateUnusedSessions()
        {
            logger.Info("Enter CallTerminateUnusedSessions");

            AdminServiceClient client = InitializeWebservice();

            try
            {
                client.TerminateUnusedSessions();
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                client.Abort();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("Webservice error: " + ex.Message, EventLogEntryType.Error);

                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                if (ex.InnerException != null)
                {
                    logger.ErrorFormat("Inner Exception: {0}", ex.InnerException.Message);
                }
                logger.DebugFormat("Exception Details: \n{0}", ex);
                client.Abort();
            }
            finally
            {
                client.Close();
            }
        }
        
        private void BackupDatabase()
        {
            logger.Info("Enter BackupDatabase");

            DateTime lastBackup = new DateTime(2000, 1, 1, 0, 0, 0);

            AdminServiceClient client = InitializeWebservice();

            try
            {
                lastBackup = client.GetLastBackupDate(schedulerID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                client.Abort();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("Webservice error: " + ex.Message, EventLogEntryType.Error);

                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                if (ex.InnerException != null)
                {
                    logger.ErrorFormat("Inner Exception: {0}", ex.InnerException.Message);
                }
                logger.DebugFormat("Exception Details: \n{0}", ex);
                client.Abort();
            }
            finally
            {
                client.Close();
            }

            TimeSpan timeBackup = Convert.ToDateTime(ConfigurationManager.AppSettings["BackupTime"]).TimeOfDay;
            DateTime nextBackup = DateTime.Now.Date + timeBackup;
            if (nextBackup < lastBackup)
            {
                nextBackup = nextBackup.AddDays(1);
            }
            if (nextBackup < DateTime.Now)
            {
                logger.InfoFormat("Start backup with params timeBackup: {0}; nextBackup: {1}; lastBackup: {2}", timeBackup, nextBackup, lastBackup);
                client = InitializeWebservice();

                try
                {
                    logger.InfoFormat("Backup database now, last backup: {0}", lastBackup);
                    client.DatabaseBackup(schedulerID);
                }
                catch (SoapException ex)
                {
                    logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                    client.Abort();
                }
                catch (Exception ex)
                {
                    eventLog1.WriteEntry("Webservice error: " + ex.Message, EventLogEntryType.Error);

                    logger.ErrorFormat("Webservice error: {0}", ex.Message);
                    if (ex.InnerException != null)
                    {
                        logger.ErrorFormat("Inner Exception: {0}", ex.InnerException.Message);
                    }
                    logger.DebugFormat("Exception Details: \n{0}", ex);
                    client.Abort();
                }
                finally
                {
                    client.Close();
                }
            }
        }

        private void CallUpdateAccessRights()
        {
            logger.Info("Enter CallUpdateAccessRights");

            AdminServiceClient client = InitializeWebservice();

            try
            {
                client.UpdateAccessRights(schedulerID);
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                client.Abort();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("Webservice error: " + ex.Message, EventLogEntryType.Error);

                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                if (ex.InnerException != null)
                {
                    logger.ErrorFormat("Inner Exception: {0}", ex.InnerException.Message);
                }
                logger.DebugFormat("Exception Details: \n{0}", ex);
                client.Abort();
            }
            finally
            {
                client.Close();
            }
        }

        private AdminServiceClient InitializeWebservice()
        {
            AdminServiceClient client = new AdminServiceClient();

            // logger.Debug("Try to initialize webservice ...");
            try
            {
                client.Open();
                // logger.Debug("Webservice succesfully initialized");
            }
            catch (SoapException ex)
            {
                logger.ErrorFormat("SOAP exeption: {0}", ex.Detail.InnerXml.ToString());
                client.Abort();
            }
            catch (Exception ex)
            {
                eventLog1.WriteEntry("Webservice error: " + ex.Message, EventLogEntryType.Error);

                logger.ErrorFormat("Webservice error: {0}", ex.Message);
                if (ex.InnerException != null)
                {
                    logger.ErrorFormat("Inner Exception: {0}", ex.InnerException.Message);
                }
                logger.DebugFormat("Exception Details: \n{0}", ex);
                client.Abort();
            }

            return client;
        }
    }
}
