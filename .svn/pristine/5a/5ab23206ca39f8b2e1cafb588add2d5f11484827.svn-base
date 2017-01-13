using log4net;
using System;
using System.Configuration;
using System.Linq;
using System.Reflection;
using Microsoft.SqlServer.Management.Common;
using Microsoft.SqlServer.Management.Smo;
using System.Data.SqlClient;
using System.Data.Entity;
using System.Net.Mail;
using System.IO;
using InsiteServices.Constants;
using System.Data.Entity.Core;
using System.Data.Entity.Validation;
using System.Text;
using System.Data.Entity.Infrastructure;
using InsiteServices;

namespace InsiteServices
{
    [GlobalErrorBehaviorAttribute(typeof(GlobalErrorHandler))]
    public class AdminService : IAdminService
    {
        private static ILog logger;
        private Insite_DevEntities entities;
        private SqlConnection sqlConnection;
        private ServerConnection connection;

        /// <summary>
        /// Standardkonstruktor
        /// </summary>
        public AdminService()
        {
            // log4net.Config.XmlConfigurator.Configure();
            // GlobalContext.Properties["SessionID"] = "n.a.";
            logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            // logger.Info("AdminServiceLogger initialized");
            InitializeContext();
        }

        private void InitializeContext()
        {
            entities = new Insite_DevEntities();
            if (ConfigurationManager.AppSettings["CommandTimeout"] != null)
            {
                entities.Database.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["CommandTimeout"].ToString());
            }

            sqlConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["Insite_Dev_ConnectionString"].ConnectionString);
            connection = new ServerConnection(sqlConnection);
        }

        /// <summary>
        /// CompressPresenceData
        /// </summary>
        /// <param name="schedulerID"></param>
        public void CompressPresenceData(string schedulerID)
        {
            logger.InfoFormat("Enter CompressPresenceData with param schedulerID: {0}", schedulerID);

            if (ConfigurationManager.AppSettings["SchedulerID"].ToString().Equals(schedulerID))
            {
                IQueryable<Master_BuildingProjects> buildingProjects = entities.Master_BuildingProjects;
                if (buildingProjects.Count() > 0)
                {
                    TimeSpan timeCompress = Convert.ToDateTime(ConfigurationManager.AppSettings["CompressPresenceDataOn"]).TimeOfDay;

                    foreach (Master_BuildingProjects buildingProject in buildingProjects.ToList())
                    {
                        if (!IsCompressRunning(buildingProject.SystemID, buildingProject.BpID))
                        {
                            DateTime lastCompress = GetLastCompress(buildingProject.SystemID, buildingProject.BpID);
                            DateTime presenceDay = lastCompress.Date;
                            // logger.InfoFormat("Try to compress presence data for presence day {0} and building project {1}", presenceDay, buildingProject.BpID);

                            if (lastCompress != DateTime.MinValue)
                            {   
                                if (AllTerminalsOnline(buildingProject.SystemID, buildingProject.BpID))
                                {
                                    DateTime nextCompress = DateTime.Now.Date + timeCompress;
                                    if (nextCompress < lastCompress)
                                    {
                                        nextCompress = nextCompress.AddDays(1);
                                    }

                                    if (nextCompress < DateTime.Now)
                                    {
                                        while (presenceDay <= DateTime.Now.AddDays(-1).Date)
                                        {
                                            logger.InfoFormat("buildingProject: {0}; presenceDay: {1}; lastCompress: {2}; nextCompress: {3}", buildingProject.BpID, presenceDay, lastCompress, nextCompress);
                                            try
                                            {
                                                logger.InfoFormat("Start compress presence data for presence day {0} and building project {1}", presenceDay, buildingProject.BpID);
                                                SetCompressState(buildingProject.SystemID, buildingProject.BpID, true);

                                                // Rücksetzen der Korrekturen für den zurückliegenden Tag
                                                entities.ResetDateRange(buildingProject.SystemID, buildingProject.BpID, presenceDay, presenceDay, 0, 0);

                                                // Ausführen der Korrekturen für den zurückliegenden Tag
                                                AccessService access = new AccessService();
                                                int ret = access.AccessDataConsistency(buildingProject.SystemID, buildingProject.BpID);

                                                // Verdichtung der Zutrittsdaten für den zurückliegenden Tag
                                                entities.CompressPresenceData(buildingProject.SystemID, buildingProject.BpID, presenceDay, buildingProject.PresentType);
                                                SetLastCompress(buildingProject.SystemID, buildingProject.BpID);
                                                SetCompressState(buildingProject.SystemID, buildingProject.BpID, false);

                                                // Mitarbeiter ermitteln, die die Vorlagefrist für Mindestlohnbescheinigungen überzogen haben
                                                access.MWLackTriggerOverdue(buildingProject.SystemID, buildingProject.BpID);

                                                // Statistik aktualisieren
                                                UpdateStatistics(buildingProject.SystemID, buildingProject.BpID, presenceDay);
                                            }
                                            catch (EntityException ex)
                                            {
                                                logger.Error("EntityException: ", ex);
                                                throw;
                                            }
                                            catch (Exception ex)
                                            {
                                                logger.Error("Exception: ", ex);
                                                throw;
                                            }
                                            presenceDay = presenceDay.AddDays(1).Date;
                                            nextCompress = nextCompress.AddDays(1);
                                        }
                                    }
                                }
                                else
                                {
                                    logger.InfoFormat("Some Terminals offline from building project {0}. No further execution of CompressPresenceData.", buildingProject.BpID);
                                }
                            }
                        }
                    }
                }
            }
        }

        private void UpdateStatistics(int systemID, int bpID, DateTime statisticsDate)
        {
            Data_Statistics stat = entities.Data_Statistics.FirstOrDefault(s => s.SystemID == systemID && s.BpID == bpID && s.StatisticsDate == statisticsDate);
            if (stat == null)
            {
                try
                {
                    entities.UpdateStatistics(systemID, bpID, statisticsDate);
                }
                catch (EntityException ex)
                {
                    logger.Error("EntityException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    throw;
                }
            }
        }

        private bool AllTerminalsOnline(int systemID, int bpID)
        {
            bool ret = false;
            double minOnline = 15.0;
            if (ConfigurationManager.AppSettings["ASMinOnline"] != null)
            {
                minOnline = Convert.ToDouble(ConfigurationManager.AppSettings["ASMinOnline"]);
            }

            IQueryable<Master_AccessSystems> result = entities.Master_AccessSystems.Where(r => r.SystemID == systemID && r.BpID == bpID);
            if (result.Count() > 0)
            {
                TimeSpan duration;
                Master_AccessSystems accessSystem = result.ToList()[0];
                if (accessSystem.LastOfflineState == null)
                {
                    duration = TimeSpan.FromMinutes(minOnline);
                }
                else
                {
                    duration = DateTime.Now - Convert.ToDateTime(accessSystem.LastOfflineState);
                }
                if (duration.TotalMinutes >= minOnline)
                {
                    ret = accessSystem.AllTerminalsOnline;
                }
            }
            return ret;
        }

        private DateTime GetLastCompress(int systemID, int bpID)
        {
            Master_AccessSystems accessSystem = entities.Master_AccessSystems.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID);
            if (accessSystem != null)
            {
                return accessSystem.LastCompress;
            }
            else
            {
                return DateTime.MinValue;
            }
        }

        private void SetLastCompress(int systemID, int bpID)
        {
            // logger.Info("Enter SetLastCompress");

            Master_AccessSystems accessSystem = entities.Master_AccessSystems.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID);
            if (accessSystem != null)
            {
                accessSystem.LastCompress = DateTime.Now;
                if (!EntitySaveChanges(true))
                {
                    logger.Debug("Error on SetLastCompress");
                }
            }
        }

        private void SetLastAddition(int systemID, int bpID)
        {
            // logger.Info("Enter SetLastAddition");

            Master_AccessSystems accessSystem = entities.Master_AccessSystems.FirstOrDefault(a => a.SystemID == systemID && a.BpID == bpID);
            if (accessSystem != null)
            {
                accessSystem.LastAddition = DateTime.Now;
                if (!EntitySaveChanges(true))
                {
                    logger.Debug("Error on SetLastAdition");
                }
            }
        }

        private void SetCompressState(int systemID, int bpID, bool isRunning)
        {
            // logger.Info("Enter SetCompressState");

            IQueryable<Master_AccessSystems> result = entities.Master_AccessSystems.Where(a => a.SystemID == systemID && a.BpID == bpID);
            if (result.Count() > 0)
            {
                Master_AccessSystems[] accessSystems = result.ToArray();
                foreach (Master_AccessSystems accessSystem in accessSystems)
                {
                    DateTime? startTime = null;
                    if (isRunning)
                    {
                        startTime = DateTime.Now;
                    }
                    accessSystem.CompressStartTime = startTime;
                }
                if (!EntitySaveChanges(true))
                {
                    logger.Debug("Error on SetCompressState");
                }
            }
        }

        private bool IsCompressRunning(int systemID, int bpID)
        {
            IQueryable<Master_AccessSystems> accessSystems = entities.Master_AccessSystems.Where(a => a.SystemID == systemID && a.BpID == bpID && a.CompressStartTime != null);
            if (accessSystems.Count() > 0)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// DatabaseBackup
        /// </summary>
        /// <param name="schedulerID"></param>
        public void DatabaseBackup(string schedulerID)
        {
            if (ConfigurationManager.AppSettings["DoBackup"] != null && Convert.ToBoolean(ConfigurationManager.AppSettings["DoBackup"]))
            {
                logger.InfoFormat("Enter DatabaseBackup with param schedulerID: {0}", schedulerID);
                if (ConfigurationManager.AppSettings["SchedulerID"].ToString().Equals(schedulerID))
                {
                    // Connect to the local, default instance of SQL Server. 
                    Server srv = new Server(connection);
                    string dbName = ConfigurationManager.AppSettings["DBName"].ToString();

                    // Define a Backup object variable. 
                    Backup bk = new Backup();

                    // Specify the type of backup, the description, the name, and the database to be backed up. 
                    bk.Action = BackupActionType.Database;
                    bk.BackupSetDescription = "Full backup of InSite 3 database";
                    bk.BackupSetName = "InSite 3 Backup";
                    bk.Database = dbName;

                    // Declare a BackupDeviceItem by supplying the backup device file name in the constructor, and the type of device is a file. 
                    BackupDeviceItem bdi = default(BackupDeviceItem);
                    string fileName = dbName + "_backup_" + DateTime.Now.Date.ToString("yyyyMMdd") + ".bak";
                    bdi = new BackupDeviceItem(fileName, DeviceType.File);

                    // Add the device to the Backup object. 
                    bk.Devices.Add(bdi);
                    // Set the Incremental property to False to specify that this is a full database backup. 
                    bk.Incremental = false;

                    // Set the expiration date. 
                    // bk.ExpirationDate = DateTime.Now.AddDays(14);

                    // Specify that the log must be truncated after the backup is complete. 
                    bk.LogTruncation = BackupTruncateLogType.Truncate;

                    try
                    {
                        // Run SqlBackup to perform the full database backup on the instance of SQL Server. 
                        logger.InfoFormat("Start backup from {0} to {1}", dbName, fileName);
                        bk.SqlBackup(srv);
                        logger.InfoFormat("Finished backup from {0} to {1}", dbName, fileName);
                    }
                    catch (Exception ex)
                    {
                        logger.Error("Exception: ", ex);
                        throw;
                    }

                    // Update LastBackup date
                    System_Systems system = entities.System_Systems.FirstOrDefault(s => s.IsMainSystem);
                    if (system != null)
                    {
                        system.LastBackup = DateTime.Now;
                        if (!EntitySaveChanges(true))
                        {
                            logger.Debug("Error on DatabaseBackup");
                        }
                    }
                }
            }
        }

        /// <summary>
        /// GetLastBackupDate
        /// </summary>
        /// <param name="schedulerID"></param>
        /// <returns></returns>
        public DateTime GetLastBackupDate(string schedulerID)
        {
            logger.InfoFormat("Enter GetLastBackupDate with param schedulerID: {0}", schedulerID);

            DateTime lastBackup = DateTime.MinValue;

            if (ConfigurationManager.AppSettings["SchedulerID"].ToString().Equals(schedulerID))
            {
                System_Systems system = entities.System_Systems.FirstOrDefault(s => s.IsMainSystem);
                if (system != null)
                {
                    if (system.LastBackup != null)
                    {
                        lastBackup = (DateTime)system.LastBackup;
                    }
                }
            }

            return lastBackup;
        }

        /// <summary>
        /// GetJob
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="jobID"></param>
        /// <returns></returns>
        public System_Jobs GetJob(int systemID, int jobID)
        {
            logger.InfoFormat("Enter GetJob with param systemID: {0}; jobID: {1}", systemID, jobID);

            System_Jobs result = entities.System_Jobs.FirstOrDefault(j => j.SystemID == systemID && j.JobID == jobID);
            return result;
        }

        /// <summary>
        /// UpdateJob
        /// </summary>
        /// <param name="job"></param>
        public bool UpdateJob(System_Jobs job)
        {
            logger.InfoFormat("Enter UpdateJob with param systemID: {0}; jobID: {1}", job.SystemID, job.JobID);

            bool ret = false;
            entities.System_Jobs.Attach(job);
            entities.Entry(job).State = EntityState.Modified;
            if (!EntitySaveChanges(true))
            {
                logger.Debug("Error on SetLastCompress");
            }
            else
            {
                ret = true;
            }
            return ret;
        }

        /// <summary>
        /// InsertJob
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>
        public int InsertJob(System_Jobs job)
        {
            logger.Info("Enter InsertJob");

            entities.System_Jobs.Add(job);
            int ret = 0;
            if (!EntitySaveChanges(true))
            {
                logger.Debug("Error on InsertJob");
            }
            else
            {
                ret = job.JobID;
            }
            return ret;
        }

        /// <summary>
        /// DeleteJob
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="jobID"></param>
        /// <returns></returns>
        public bool DeleteJob(int systemID, int jobID)
        {
            logger.InfoFormat("Enter DeleteJob with param systemID: {0}; jobID: {1}", systemID, jobID);

            System_Jobs job = entities.System_Jobs.FirstOrDefault(j => j.SystemID == systemID && j.JobID == jobID);
            if (job != null)
            {
                entities.System_Jobs.Remove(job);
                if (!EntitySaveChanges(true))
                {
                    logger.Debug("Error on SetLastCompress");
                }
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// GetDueJobs
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="dueTimestamp"></param>
        /// <returns></returns>
        public System_Jobs[] GetDueJobs(int systemID, DateTime? dueTimestamp)
        {
            logger.InfoFormat("Enter GetDueJobs with param systemID: {0}; dueTimestamp: {1}", systemID, dueTimestamp);

            if (dueTimestamp == null)
            {
                dueTimestamp = DateTime.Now;
            }

            IQueryable<System_Jobs> result = entities.System_Jobs.Where(j => j.SystemID == systemID && (j.StatusID == Status.Created || j.StatusID == Status.WaitExecute) &&
                                                                             j.NextStart <= dueTimestamp);
            if (result.Count() > 0)
            {
                return result.ToArray();
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// RefreshJob
        /// Update Job with new NextStart date or set it to Status.Deactivated
        /// </summary>
        /// <param name="job"></param>
        /// <returns></returns>
        public int RefreshJob(System_Jobs jobParam)
        {
            logger.InfoFormat("Enter RefreshJob with param systemID: {0}; jobID: {1}", jobParam.SystemID, jobParam.JobID);

            System_Jobs job = GetJob(jobParam.SystemID, jobParam.JobID);

            if (job.StatusID == Status.Done || job.StatusID == Status.Created || job.StatusID == Status.WaitExecute)
            {
                entities.System_Jobs.Attach(job);
                entities.Entry(job).State = EntityState.Modified;
                if (job.Frequency == 0 && job.StatusID == Status.Done)
                {
                    // Single execution, deactivate job
                    job.NextStart = null;
                    job.StatusID = Status.Deactivated;
                }
                else
                {
                    // Initialize DateBegin and DateEnd if null
                    DateTime dateBegin = new DateTime(2000, 1, 1, 0, 0, 0);
                    if (job.DateBegin != null)
                    {
                        dateBegin = (DateTime)job.DateBegin;
                    }
                    else
                    {
                        job.DateBegin = dateBegin;
                    }

                    DateTime dateEnd = new DateTime(2100, 12, 31, 23, 59, 59);
                    if (job.DateEnd != null)
                    {
                        dateEnd = (DateTime)job.DateEnd;
                    }
                    else
                    {
                        job.DateEnd = dateEnd;
                    }

                    // Get date for first start
                    DateTime startDate = DateTime.Now.Date;
                    if (dateBegin > startDate)
                    {
                        startDate = dateBegin;
                    }

                    // Execution period not ended
                    if (dateEnd >= startDate)
                    {
                        // Single execution
                        if (job.Frequency == 0)
                        {
                            job.NextStart = (DateTime)job.DateBegin + (TimeSpan)job.StartTime;
                            if (job.NextStart < DateTime.Now)
                            {
                                job.NextStart = DateTime.Now;
                            }
                        }
                        // Daily execution
                        else if (job.Frequency == 1)
                        {
                            if (job.NextStart == null)
                            {
                                job.NextStart = (DateTime)job.DateBegin + (TimeSpan)job.StartTime;
                            }

                            while (job.NextStart < DateTime.Now)
                            {
                                // Add repeat interval to last start date
                                job.NextStart = ((DateTime)job.NextStart).AddDays(job.RepeatEvery);
                            }
                        }
                        // Weekly execution
                        else if (job.Frequency == 2)
                        {
                            if (job.NextStart == null)
                            {
                                job.NextStart = (DateTime)job.DateBegin + (TimeSpan)job.StartTime;
                            }

                            while (job.NextStart < DateTime.Now)
                            {
                                DateTime nextDate = ((DateTime)job.NextStart).Date + (TimeSpan)job.StartTime;
                                job.NextStart = NextValidDate(nextDate, job.ValidDays);
                            }
                        }
                        // Monthly execution
                        else if (job.Frequency == 3)
                        {
                            if (job.NextStart == null)
                            {
                                job.NextStart = new DateTime(((DateTime)job.DateBegin).Year, ((DateTime)job.DateBegin).Month, job.DayOfMonth) + (TimeSpan)job.StartTime;
                            }

                            while (job.NextStart < DateTime.Now)
                            {
                                // Add repeat interval to last start date
                                job.NextStart = new DateTime(((DateTime)job.NextStart).Year, ((DateTime)job.NextStart).Month, job.DayOfMonth) + (TimeSpan)job.StartTime;
                                job.NextStart = ((DateTime)job.NextStart).AddMonths(job.RepeatEvery);
                            }
                        }

                        logger.DebugFormat("job.NextStart: {0}", ((DateTime)job.NextStart).ToString("G"));
                        job.StatusID = Status.WaitExecute;

                        if (((DateTime)job.NextStart).Date > dateEnd)
                        {
                            // No new execution, deactivate job
                            job.NextStart = null;
                            job.StatusID = Status.Deactivated;
                        }
                    }
                    else if (dateEnd < startDate)
                    {
                        // Execution period ended, deactivate job
                        job.NextStart = null;
                        job.StatusID = Status.Deactivated;
                    }
                }

                job.EditFrom = "System";
                job.EditOn = DateTime.Now;

                UpdateJob(job);
            }

            return job.StatusID;
        }

        protected bool IsValidDay(string validDays, int dayPos)
        {
            string dayValue = validDays.Substring(dayPos, 1);
            return (dayValue == "1");
        }

        protected DateTime NextValidDate(DateTime dateFrom, string validDays)
        {
            bool isValid = false;
            DateTime nextDate = dateFrom;

            while (!isValid)
            {
                nextDate = nextDate.AddDays(1);

                int weekday = (int)nextDate.DayOfWeek - 1;
                // Shift caused by U.S. week start = sunday
                if (weekday == -1)
                {
                    weekday = 6;
                }

                isValid = IsValidDay(validDays, weekday);
            }

            return nextDate;
        }

        protected DateTime StartOfWeek(DateTime dt, DayOfWeek startOfWeek)
        {
            int diff = dt.DayOfWeek - startOfWeek;
            if (diff < 0)
            {
                diff += 7;
            }

            return dt.AddDays(-1 * diff).Date;
        }

        /// <summary>
        /// ExecuteDueJobs
        /// </summary>
        /// <param name="systemID"></param>
        public void ExecuteDueJobs(int systemID)
        {
            logger.InfoFormat("Enter ExecuteDueJobs with param systemID: {0}", systemID);

            IQueryable<System_Systems> systems = entities.System_Systems.Where(s => s.SystemID == (systemID == 0 ? s.SystemID : systemID) && s.IsActive == true);

            foreach (System_Systems system in systems.ToList())
            {
                System_Jobs[] jobs = GetDueJobs(system.SystemID, DateTime.Now);

                if (jobs != null)
                {
                    for (int i = 0; i < jobs.Count(); i++)
                    {
                        System_Jobs job = jobs[i];

                        // Execute job
                        logger.InfoFormat("Execute job with param systemID: {0}; jobID: {1}", job.SystemID, job.JobID);
                        if (job.JobType == JobType.Report)
                        {
                            // Set job status to executing
                            job.Started = DateTime.Now;
                            job.StatusID = Status.Executing;
                            UpdateJob(job);

                            // Do job
                            int ret = DoReportingJob(ref job);

                            // Set job status to done
                            job.Terminated = DateTime.Now;
                            job.StatusID = Status.Done;
                            UpdateJob(job);
                        }

                        // Refresh job for next interval or deactivation (single loop)
                        RefreshJob(job);
                    }
                }
            }
        }

        private int DoReportingJob(ref System_Jobs job)
        {
            logger.InfoFormat("Enter DoReportingJob with param jobID: {0}", job.JobID);

            // Report rendern
            byte[] result = null;
            string extension = string.Empty;
            string mimeType = string.Empty;
            string comment = string.Empty;
            string message = string.Empty;

            int ret = Reporting.RenderReport(job.JobParameter, out result, out extension, out mimeType, out comment, out message);

            if (ret == 0)
            {
                string fileName = job.NameVisible + "_" + DateTime.Now.ToString("yyyyMMddHHmm") + "." + extension;
                string body = string.Format(Resources.Resource.msgJobExecutedWithReport, job.JobID, fileName);
                if (!comment.Equals(string.Empty))
                {
                    body += string.Concat("<br/><br/>", Resources.Resource.lblRemark, ": ", "<br/>", comment);
                }

                // Report versenden
                string[] receivers = job.Receiver.Split(';');
                for (int i = 0; i < receivers.Length; i++)
                {
                    int userID = 0;
                    string receiver = receivers[i];
                    if (Helpers.IsValidEmail(receiver))
                    {
                        MailMessage mail = Helpers.CreateMail(ConfigurationManager.AppSettings["SMTPFrom"].ToString(), receiver, job.NameVisible, body, true);
                        Stream stream = new MemoryStream(result);
                        Attachment attachment = new Attachment(stream, fileName, mimeType);
                        mail.Attachments.Add(attachment);

                        Helpers.SendMail(mail);
                    }
                    else if (Int32.TryParse(receiver, out userID))
                    {
                        UserService service = new UserService();
                        try
                        {
                            int messageID = service.SendMessage(job.SystemID, job.JobID, Convert.ToInt32(receiver), job.NameVisible, body, "");
                            int attachmentID = service.SetAttachmentToMessage(job.SystemID, job.JobID, messageID, result, fileName, mimeType, "");
                        }
                        catch (Exception ex)
                        {
                            logger.Error("Exception: ", ex);
                            throw;
                        }
                    }
                }
            }
            else
            {
                job.TerminationMessage = message;
            }

            return ret;
        }

        public void TerminateUnusedSessions()
        {
            IQueryable<System_SessionLog> result = entities.System_SessionLog.Where(l => l.SessionState == SessionState.SessionStart && l.LastUsed == null);
            System_SessionLog[] arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                foreach (System_SessionLog log in arrayResult)
                {
                    if (log.FirstUsed.AddHours(1) < DateTime.Now)
                    {
                        logger.InfoFormat("Terminating session {0}", log.SessionID);
                        log.SessionState = SessionState.SessionEnd;
                        if (!EntitySaveChanges(true))
                        {
                            logger.Debug("Error on TerminateUnusedSessions 1");
                        }
                    }
                }
            }

            result = entities.System_SessionLog.Where(l => l.SessionState == SessionState.SessionUsed);
            arrayResult = result.ToArray();
            if (arrayResult.Count() > 0)
            {
                foreach (System_SessionLog log in arrayResult)
                {
                    if (((DateTime)log.LastUsed).AddHours(1) < DateTime.Now)
                    {
                        logger.InfoFormat("Terminating session {0}", log.SessionID);
                        log.SessionState = SessionState.SessionEnd;
                        if (!EntitySaveChanges(true))
                        {
                            logger.Debug("Error on TerminateUnusedSessions 2");
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Update der Zutrittsrechte aller Mitarbeiter
        /// </summary>
        /// <param name="schedulerID"></param>
        public void UpdateAccessRights(string schedulerID)
        {
            logger.InfoFormat("Enter UpdateAccessRights with param schedulerID: {0}", schedulerID);

            if (ConfigurationManager.AppSettings["SchedulerID"].ToString().Equals(schedulerID))
            {
                // Alle Bauvorhaben mit aktivierter Zutrittskontrolle
                IQueryable<Master_AccessSystems> buildingProjects = entities.Master_AccessSystems;
                if (buildingProjects.Count() > 0)
                {
                    // Updatezeitpunkt aus der Konfiguration lesen
                    TimeSpan timeUpdate = Convert.ToDateTime(ConfigurationManager.AppSettings["UpdateAccessRightsOn"]).TimeOfDay;
                    AccessService access = new AccessService();
                    foreach (Master_AccessSystems bp in buildingProjects.ToList())
                    {
                        // Letzten Updatezeitpunkt ermitteln
                        DateTime? lastUpdate = bp.LastUpdateAccessRights;
                        if (lastUpdate == null)
                        {
                            lastUpdate = DateTime.Now.AddDays(-1);
                        }

                        DateTime nextUpdate = DateTime.Now.Date + timeUpdate;
                        if (nextUpdate < lastUpdate)
                        {
                            nextUpdate = nextUpdate.AddDays(1);
                        }

                        if (nextUpdate < DateTime.Now)
                        {
                            logger.InfoFormat(" Update access rights for buildingProject: {0}; lastUpdate: {1}; nextUpdate: {2}", bp.BpID, lastUpdate, nextUpdate);

                            // Alle Mitarbeiter mit Ausweis
                            IQueryable<Master_Employees> result = entities.Master_Employees.Where(e => e.SystemID == bp.SystemID && e.BpID == bp.BpID && e.PassCount > 0);
                            Master_Employees[] employees = result.ToArray();
                            if (employees != null && employees.Count() > 0)
                            {
                                foreach (Master_Employees ep in employees)
                                {
                                    access.EmployeeChanged(ep.SystemID, ep.BpID, ep.EmployeeID);
                                }
                                // Neuen Updatezeitpunkt wegschreiben
                                bp.LastUpdateAccessRights = DateTime.Now;
                                if (!EntitySaveChanges(true))
                                {
                                    logger.Debug("Error on UpdateAccessRights");
                                }
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Automatische Ergänzung der Zutrittsdaten
        /// </summary>
        /// <param name="schedulerID"></param>
        public void AdditionAccessTimes(string schedulerID)
        {
            logger.InfoFormat("Enter AdditionAccessTimes with param schedulerID: {0}", schedulerID);

            if (ConfigurationManager.AppSettings["SchedulerID"].ToString().Equals(schedulerID))
            {
                // Alle Bauvorhaben mit aktivierter Zutrittskontrolle
                IQueryable<Master_AccessSystems> buildingProjects = entities.Master_AccessSystems;
                if (buildingProjects.Count() > 0)
                {
                    // Updatezeitpunkt aus der Konfiguration lesen
                    int additionEvery = Convert.ToInt32(ConfigurationManager.AppSettings["AdditionEveryMin"]);
                    AccessService access = new AccessService();
                    foreach (Master_AccessSystems bp in buildingProjects.ToList())
                    {
                        if (!IsCompressRunning(bp.SystemID, bp.BpID))
                        {
                            if (AllTerminalsOnline(bp.SystemID, bp.BpID))
                            {
                                // Letzten Updatezeitpunkt ermitteln
                                DateTime? lastUpdate = bp.LastAddition;
                                if (lastUpdate == null)
                                {
                                    lastUpdate = DateTime.Now.AddMinutes(additionEvery * (-1));
                                }

                                DateTime nextUpdate = Convert.ToDateTime(bp.LastAddition).AddMinutes(additionEvery);
                                if (nextUpdate < lastUpdate)
                                {
                                    nextUpdate = nextUpdate.AddMinutes(additionEvery);
                                }

                                if (nextUpdate < DateTime.Now)
                                {
                                    logger.InfoFormat("Access time additions for buildingProject: {0}; lastUpdate: {1}; nextUpdate: {2}", bp.BpID, lastUpdate, nextUpdate);

                                    SetCompressState(bp.SystemID, bp.BpID, true);
                                    // Fehler in den Zutrittsdaten von Additus korrigieren
                                    access.AccessDataErrors(bp.SystemID, bp.BpID);
                                    // Datenkonsistenz und maximale Anwesenheitszeiten
                                    access.AccessDataConsistency(bp.SystemID, bp.BpID);
                                    SetLastAddition(bp.SystemID, bp.BpID);
                                    SetCompressState(bp.SystemID, bp.BpID, false);

                                }
                            }
                            else
                            {
                                logger.InfoFormat("Some Terminals offline from building project {0}. AdditionAccessTimes not executed.", bp.BpID);
                            }
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Änderungen an der Datenquelle speichern und ggf. Fehlerbehandlung
        /// </summary>
        /// <param name="throwError"></param>
        /// <returns></returns>
        private bool EntitySaveChanges(bool throwError)
        {
            bool changesSaved = false;
            try
            {
                entities.SaveChanges();
                changesSaved = true;
            }
            catch (DbEntityValidationException ex)
            {
                logger.Error("DbEntityValidationException: " + ex.Message);
                StringBuilder sb = new StringBuilder();

                foreach (var failure in ex.EntityValidationErrors)
                {
                    sb.AppendFormat("{0} failed validation\n", failure.Entry.Entity.GetType());
                    foreach (var error in failure.ValidationErrors)
                    {
                        sb.AppendFormat("- {0} : {1}", error.PropertyName, error.ErrorMessage);
                        sb.AppendLine();
                    }
                }
                logger.Debug("Entity Validation Failed - errors follow:\n" + sb.ToString() + "\n", ex);

                if (ex.InnerException != null)
                {
                    logger.Error("Inner DbEntityValidationException: " + ex.InnerException.Message);
                }
                logger.Debug("DbEntityValidationException Details: \n" + ex);
            }
            catch (DbUpdateException ex)
            {
                SqlException innerException = ex.InnerException.InnerException as SqlException;
                if (innerException != null && (innerException.Number == 2627 || innerException.Number == 2601))
                {
                    logger.Debug("DbUpdateException: ", ex);
                    return changesSaved;
                }
                else
                {
                    logger.Error("DbUpdateException: ", ex);
                    if (throwError)
                    {
                        throw;
                    }
                }
            }
            catch (EntityException ex)
            {
                logger.Error("EntityException: ", ex);
                if (throwError)
                {
                    throw;
                }
            }
            catch (Exception ex)
            {
                logger.Error("Exception: ", ex);
                if (throwError)
                {
                    throw;
                }
            }
            return changesSaved;
        }
    }
}