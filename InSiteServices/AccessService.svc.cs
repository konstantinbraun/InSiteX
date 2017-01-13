using System;
using System.Collections.Generic;
using log4net;
using System.Reflection;
using System.Linq;
using System.Data.Entity.Core.Objects;
using System.Resources;
using System.Globalization;
using InsiteServices.Models;
using System.Configuration;
using System.Data.Entity.Core;
using InsiteServices.Constants;
using System.Data.Entity.Validation;
using System.Text;
using System.Data.Entity.Infrastructure;
using System.Data.SqlClient;

namespace InsiteServices
{
    [Flags]
    public enum Rights : int
    {
        None = 0,
        AllowCarAccess = 1
    }

    [GlobalErrorBehaviorAttribute(typeof(GlobalErrorHandler))]
    public class AccessService : IAccessService
    {
        // Pass types
        public const int PassTypeEmployeePass = 1;
        public const int PassTypeShortTermPass = 2;

        public const bool AccessAllowed = true;
        public const bool AccessNotAllowed = false;

        private static ILog logger;
        private Insite_DevEntities entities;
        readonly ResourceManager rm = new ResourceManager("InSite.Services.App_GlobalResources.AccessMessages", Assembly.GetExecutingAssembly());

        /// <summary>
        /// Standardkonstruktor
        /// </summary>
        public AccessService()
        {
            log4net.Config.XmlConfigurator.Configure();
            // GlobalContext.Properties["SessionID"] = "n.a.";
            logger = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
            // logger.Info("AccessServiceLogger initialized");
            InitializeContext();
        }

        private void InitializeContext()
        {
            entities = new Insite_DevEntities();
            if (ConfigurationManager.AppSettings["CommandTimeout"] != null)
            {
                entities.Database.CommandTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["CommandTimeout"].ToString());
            }
        }

        /// <summary>
        /// Periodically set the online state of all connected terminals
        /// </summary>
        /// <param name="accessSystemID">ID of access control system</param>
        /// <param name="authID">Authentication ID</param>
        /// <param name="bpID">Building project ID</param>
        /// <param name="allTerminalsOnline">When all connected terminals are online and in sync = false, else = true</param>
        public void PutSystemState(int accessSystemID, string authID, int bpID, bool allTerminalsOnline)
        {
            Master_AccessSystems accessSystem = entities.Master_AccessSystems.FirstOrDefault(a => a.AccessSystemID == accessSystemID && a.BpID == bpID);
            if (accessSystem != null)
            {
                accessSystem.LastUpdate = DateTime.Now;
                accessSystem.AllTerminalsOnline = !allTerminalsOnline;
                if (allTerminalsOnline)
                {
                    logger.WarnFormat("### Access control system: {0}, building project: {1} - Some terminals offline! ###", accessSystemID.ToString(), bpID.ToString());
                    accessSystem.LastOfflineState = DateTime.Now;
                }
                EntitySaveChanges(true);
            }
        }

        /// <summary>
        /// Periodically put the online status of all terminals
        /// </summary>
        /// <param name="accessSystemID">ID of access control system</param>
        /// <param name="authID">Authentication ID</param>
        /// <param name="status">Array of TerminalStatus objects</param>
        public void PutTerminalStatus(int accessSystemID, string authID, TerminalStatus[] status)
        {
            if (ConfigurationManager.AppSettings["PutTerminalStatus"] != null && ConfigurationManager.AppSettings["PutTerminalStatus"].ToString().Equals("true"))
            {
                logger.InfoFormat("Enter PutTerminalStatus with params accessSystemID: {0}; authID: {1}", accessSystemID, authID);

                if (status != null && status.Count() > 0)
                {
                    bool saveChanges = false;
                    try
                    {
                        foreach (TerminalStatus stat in status)
                        {
                            // Update or add terminal master item
                            bool addNew = false;
                            bool newTimestamp = false;

                            Master_Terminal terminal = entities.Master_Terminal.FirstOrDefault(
                                t => t.SystemID == stat.SystemID &&
                                t.BfID == stat.BfID &&
                                t.BpID == stat.BpID &&
                                t.AccessAreaID == stat.AccessAreaID &&
                                t.TerminalID == stat.TerminalID);

                            if (terminal == null)
                            {
                                logger.DebugFormat("Add new Master_Terminal record: {0}", stat.Designation);
                                addNew = true;
                                saveChanges |= true;
                                terminal = new Master_Terminal();
                                terminal.SystemID = stat.SystemID;
                                terminal.BfID = stat.BfID;
                                terminal.BpID = stat.BpID;
                                terminal.AccessAreaID = stat.AccessAreaID;
                                terminal.TerminalID = stat.TerminalID;
                                terminal.TerminalType = stat.TerminalType;
                            }

                            if (DateTime.Compare(terminal.StatusTimestamp, stat.StatusTimestamp) != 0 || addNew)
                            {
                                // Save each status event
                                Data_TerminalStatus ts = new Data_TerminalStatus();

                                ts.SystemID = stat.SystemID;
                                ts.BfID = stat.BfID;
                                ts.BpID = stat.BpID;
                                ts.AccessAreaID = stat.AccessAreaID;
                                ts.TerminalID = stat.TerminalID;
                                ts.IsOnline = stat.IsOnline;
                                ts.StatusTimestamp = (DateTime)stat.StatusTimestamp;

                                entities.Data_TerminalStatus.Add(ts);

                                newTimestamp = true;
                                saveChanges |= true;
                            }

                            if (addNew || newTimestamp)
                            {
                                if (stat.Designation != null)
                                {
                                    if (stat.Designation.Length > 50)
                                    {
                                        terminal.NameVisible = stat.Designation.Substring(0, 50);
                                    }
                                    else
                                    {
                                        terminal.NameVisible = stat.Designation;
                                    }
                                }

                                if (stat.FirmwareVersion != null)
                                {
                                    if (stat.FirmwareVersion.Length > 50)
                                    {
                                        terminal.FirmwareVersion = stat.FirmwareVersion.Substring(0, 50);
                                    }
                                    else
                                    {
                                        terminal.FirmwareVersion = stat.FirmwareVersion;
                                    }
                                }

                                if (stat.SoftwareVersion != null)
                                {
                                    if (stat.SoftwareVersion.Length > 50)
                                    {
                                        terminal.SoftwareVersion = stat.SoftwareVersion.Substring(0, 50);
                                    }
                                    else
                                    {
                                        terminal.SoftwareVersion = stat.SoftwareVersion;
                                    }
                                }

                                terminal.IsActivated = stat.IsActivated;

                                terminal.StatusTimestampLast = terminal.StatusTimestamp;
                                terminal.StatusTimestamp = Convert.ToDateTime(stat.StatusTimestamp);

                                bool addNew1 = false;

                                DateTime yesterday = DateTime.Now.AddDays(-1).Date;

                                Data_StatisticsTerminals statTerminal = entities.Data_StatisticsTerminals.FirstOrDefault(
                                        s => s.SystemID == stat.SystemID && 
                                        s.BfID == stat.BfID && 
                                        s.BpID == stat.BpID && 
                                        s.StatisticsDate == yesterday &&
                                        s.AccessAreaID == stat.AccessAreaID &&
                                        s.TerminalID == stat.TerminalID);

                                if (statTerminal == null)
                                {
                                    statTerminal = new Data_StatisticsTerminals();
                                    statTerminal.SystemID = stat.SystemID;
                                    statTerminal.BfID = stat.BfID;
                                    statTerminal.BpID = stat.BpID;
                                    statTerminal.StatisticsDate = yesterday;
                                    statTerminal.AccessAreaID = stat.AccessAreaID;
                                    statTerminal.TerminalID = stat.TerminalID;
                                    addNew1 = true;
                                }

                                if (terminal.IsOnline)
                                {
                                    terminal.OnlineTimeLast = terminal.OnlineTime;
                                    if (stat.StatusTimestamp.Day != terminal.StatusTimestamp.Day)
                                    {
                                        // Zähler am Tagesbeginn zurücksetzen
                                        terminal.OnlineTime = (int)terminal.StatusTimestamp.TimeOfDay.TotalSeconds;

                                        // Statistik aktualisieren
                                        statTerminal.OnlineTime = terminal.OnlineTimeLast;
                                        saveChanges = true;
                                    }
                                    else
                                    {
                                        terminal.OnlineTime += (int)(terminal.StatusTimestamp - terminal.StatusTimestampLast).TotalSeconds;
                                    }
                                }

                                if (terminal.IsOnline != stat.IsOnline)
                                {
                                    terminal.OnOffChangesLast = terminal.OnOffChanges;
                                    if (stat.StatusTimestamp.Day != terminal.StatusTimestamp.Day)
                                    {
                                        // Zähler am Tagesbeginn zurücksetzen
                                        terminal.OnOffChanges = 1;

                                        // Statistik aktualisieren
                                        statTerminal.OnOffChanges = terminal.OnOffChangesLast;
                                        saveChanges = true;
                                    }
                                    else
                                    {
                                        terminal.OnOffChanges++;
                                    }
                                }

                                if (addNew1)
                                {
                                    entities.Data_StatisticsTerminals.Add(statTerminal);
                                }

                                terminal.IsOnline = stat.IsOnline;
                                terminal.EditFrom = "Aditus";
                                terminal.EditOn = DateTime.Now;

                                if (addNew)
                                {
                                    entities.Master_Terminal.Add(terminal);
                                }
                            }
                        }
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

                    if (saveChanges)
                    {
                        if (ConfigurationManager.AppSettings["SerializePutTerminalStatus"] != null && ConfigurationManager.AppSettings["SerializePutTerminalStatus"].ToString().Equals("true"))
                        {
                            // Save serialized object to xml file
                            string serialized = Helpers.Serialize(status);
                            Helpers.WriteXmlFile(serialized, "PutTerminalStatus", 654);
                        }

                        EntitySaveChanges(true);
                    }
                }
                else
                {
                    logger.Debug("No terminal status data appended with request");
                }
            }
        }

        /// <summary>
        /// Returns the access rights defined by InSite
        /// </summary>
        /// <param name="accessSystemID">ID of access control system</param>
        /// <param name="authID">Authentication ID</param>
        /// <param name="initial">Return all rights or new since last request</param>
        /// <returns>Array of AccessRight</returns>
        public AccessRight[] GetAccessRights(int accessSystemID, string authID, bool initial)
        {
            logger.InfoFormat("Enter GetAccessRights with params accessSystemID: {0}; authID: {1}; initial: {2}", accessSystemID, authID, initial);

            List<AccessRight> accessRights = new List<AccessRight>();

            // Get access system to building project assignment
            Master_AccessSystems[] accessSystems = entities.Master_AccessSystems.Where(a => a.AccessSystemID == accessSystemID).ToArray();
            if (accessSystems.Count() > 0)
            {
                foreach (Master_AccessSystems accessSystem in accessSystems)
                {
                    // If last update timestamp is null
                    DateTime changesSince;
                    if (accessSystem.LastGetAccessRights == null || initial)
                    {
                        changesSince = Convert.ToDateTime("01.01.2013 00:00:00");
                    }
                    else
                    {
                        changesSince = (DateTime) accessSystem.LastGetAccessRights;
                    }
                    // logger.InfoFormat("Get all changes since {0}", changesSince);

                    accessSystem.LastGetAccessRights = DateTime.Now;
                    EntitySaveChanges(true);

                    try
                    {
                        // Get all access right events since last update
                        ObjectResult<GetAccessRightEventsExtended_Result> accessRightResult = entities.GetAccessRightEventsExtended(accessSystem.SystemID, accessSystem.BpID, changesSince);
                        GetAccessRightEventsExtended_Result[] accessRightEvents = accessRightResult.ToArray();

                        int count = accessRightEvents.Count();
                        if (count > 0)
                        {
                            if (!initial)
                            {
                                logger.InfoFormat("{0} new access right events to export for building project {1}", count.ToString(), accessSystem.BpID);
                            }

                            foreach (GetAccessRightEventsExtended_Result accessRightEvent in accessRightEvents)
                            {
                                AccessRight accessRight = new AccessRight();

                                accessRight.AccessRightID = accessRightEvent.AccessRightEventID;
                                accessRight.CreatedOn = accessRightEvent.CreatedOn;
                                accessRight.EditOn = accessRightEvent.EditOn;
                                accessRight.EmployeeFirstName = accessRightEvent.FirstName;
                                accessRight.EmployeeLastName = accessRightEvent.LastName;
                                accessRight.CompanyName = accessRightEvent.CompanyName;
                                accessRight.TradeName = accessRightEvent.TradeName;
                                if (accessRightEvent.ExternalID != null)
                                {
                                    accessRight.ExternalID = accessRightEvent.ExternalID.ToString();
                                }
                                else
                                {
                                    accessRight.ExternalID = string.Empty;
                                }

                                accessRight.InternalID = accessRightEvent.InternalID;
                                accessRight.LanguageID = accessRightEvent.LanguageID;

                                if (accessRightEvent.ValidUntil != null)
                                {
                                    if ((DateTime)accessRightEvent.ValidUntil <= DateTime.Now || (!accessRightEvent.AccessAllowed))
                                    {
                                        // Access right no longer valid 
                                        accessRight.LockFlag = true;
                                        if (accessRightEvent.AccessDenialReason != null && !accessRightEvent.AccessDenialReason.Equals(string.Empty))
                                        {
                                            accessRight.LockReason = accessRightEvent.AccessDenialReason + Environment.NewLine;
                                        }
                                        CultureInfo ci = null;
                                        if (accessRightEvent.LanguageID != null && !accessRightEvent.LanguageID.Equals(string.Empty) && accessRightEvent.LanguageID.Length == 5)
                                        {
                                            // logger.DebugFormat("Try to get culture info for culture {0}", accessRightEvent.LanguageID);
                                            ci = CultureInfo.CreateSpecificCulture(accessRightEvent.LanguageID);
                                        }
                                        if (ci == null || rm.GetString("admAccessRightValidUntilExpired", ci).Equals(string.Empty))
                                        {
                                            // logger.Debug("Get culture info for default culture en-GB");
                                            ci = CultureInfo.CreateSpecificCulture("en-GB");
                                        }
                                        accessRight.LockReason += rm.GetString("admAccessRightValidUntilExpired", ci);
                                    }
                                    accessRight.ValidUntil = (DateTime) accessRightEvent.ValidUntil;
                                }
                                else
                                {
                                    accessRight.LockFlag = !accessRightEvent.AccessAllowed;
                                    accessRight.LockReason = accessRightEvent.AccessDenialReason;
                                }
                                accessRight.Message = accessRightEvent.Message;
                                accessRight.ShowMessageFrom = (DateTime) accessRightEvent.MessageFrom;
                                accessRight.ShowMessageUntil = (DateTime) accessRightEvent.MessageUntil;
                                accessRight.SystemID = accessRightEvent.SystemID;
                                if (accessRightEvent.PassType == 1)
                                {
                                    GetPhoto_Result photo = Helpers.GetPhoto(accessSystem.SystemID, accessSystem.BpID, accessRightEvent.OwnerID);
                                    if (photo != null && photo.PhotoData != null)
                                    {
                                        //System.Drawing.Image img = Helpers.ByteArrayToImage(photo.PhotoData);
                                        //img = Helpers.ScaleImage(img, 350, 450);
                                        //System.Drawing.Imaging.ImageFormat fmt = Helpers.ParseImageFormat(Path.GetExtension(photo.PhotoFileName));
                                        //byte[] fileData = Helpers.ImageToByteArray(img, fmt);
                                        //accessRight.PhotoData = fileData;

                                        accessRight.PhotoData = photo.PhotoData;
                                    }
                                }

                                List<AccessArea> accessAreas = new List<AccessArea>();

                                // Get all access area events for this access right event
                                ObjectResult<GetAccessAreaEvents_Result> accessAreaResult = entities.GetAccessAreaEvents(accessSystem.SystemID, accessSystem.BpID, accessRightEvent.AccessRightEventID);
                                GetAccessAreaEvents_Result[] accessAreaEvents = accessAreaResult.ToArray();
                                count = accessAreaEvents.Count();
                                if (count > 0)
                                {
                                    // logger.InfoFormat("{0} new access area events to export for AccessRightEvent {1}", count.ToString(), accessRightEvent.AccessRightEventID);
                                    foreach (GetAccessAreaEvents_Result accessAreaEvent in accessAreaEvents)
                                    {
                                        AccessArea accessArea = new AccessArea();

                                        accessArea.AccessAreaID = accessAreaEvent.AccessAreaID;
                                        accessArea.AccessAreaName = accessAreaEvent.AccessAreaName;
                                        accessArea.AccessRightID = accessAreaEvent.AccessRightEventID;
                                        accessArea.BfID = 0;
                                        accessArea.BpID = accessAreaEvent.BpID;
                                        if (accessAreaEvent.TimeFrom != null)
                                        {
                                            accessArea.TimeFrom = (TimeSpan) accessAreaEvent.TimeFrom;
                                        }
                                        accessArea.TimeSlotID = accessAreaEvent.TimeSlotID;
                                        if (accessAreaEvent.TimeUntil != null)
                                        {
                                            accessArea.TimeUntil = (TimeSpan) accessAreaEvent.TimeUntil;
                                        }
                                        accessArea.ValidDays = accessAreaEvent.ValidDays;
                                        accessArea.ValidFrom = accessAreaEvent.ValidFrom;

                                        if (accessRightEvent.ValidUntil != null && (DateTime) accessRightEvent.ValidUntil < accessAreaEvent.ValidUntil)
                                        {
                                            accessArea.ValidUntil = (DateTime) accessRightEvent.ValidUntil;
                                        }
                                        else
                                        {
                                            accessArea.ValidUntil = accessAreaEvent.ValidUntil;
                                        }

                                        accessArea.AdditionalRights = accessAreaEvent.AdditionalRights;

                                        accessAreas.Add(accessArea);
                                    }
                                    accessRight.AccessAreas = accessAreas.ToArray();
                                }

                                accessRights.Add(accessRight);
                            }

                            if (!initial)
                            {
                                logger.InfoFormat("{0} new access right events exported", accessRightEvents.Count().ToString());
                            }
                        }
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

            if (!initial)
            {
                if (accessRights.Count() > 0)
                {
                    logger.InfoFormat("Overall {0} new access right events exported", accessRights.Count().ToString());
                }
            }
            else
            {
                logger.InfoFormat("All {0} access right events exported", accessRights.Count().ToString());
            }

            if (ConfigurationManager.AppSettings["SerializeGetAccessRights"] != null && ConfigurationManager.AppSettings["SerializeGetAccessRights"].ToString().Equals("true"))
            {
                // Save serialized object to xml file
                string serialized = Helpers.Serialize(accessRights);
                Helpers.WriteXmlFile(serialized, "GetAccessRights", 500);
            }

            logger.Info("Exit GetAccessRights");
            return accessRights.ToArray();
        }

        /// <summary>
        /// Push access event to InSite
        /// </summary>
        /// <param name="accessSystemID">ID of access control system</param>
        /// <param name="authID">Authentication ID</param>
        /// <param name="accessEvents">Array of AccessEvent</param>
        /// <returns>= 0: OK; != 0: Error</returns>
        public int PutAccessEvent(int accessSystemID, string authID, AccessEvent[] accessEvents)
        {
            logger.InfoFormat("Enter PutAccessEvent with params accessSystemID: {0}; authID: {1}; new access events to import: {2}", accessSystemID, authID, accessEvents.Count().ToString());

            if (ConfigurationManager.AppSettings["SerializePutAccessEvent"] != null && ConfigurationManager.AppSettings["SerializePutAccessEvent"].ToString().Equals("true"))
            {
                // Save serialized object to xml file
                string serialized = Helpers.Serialize(accessEvents);
                Helpers.WriteXmlFile(serialized, "PutAccessEvent", 500);
            }

            int result = 0;

            foreach (AccessEvent accessEvent in accessEvents)
            {
                // logger.DebugFormat("AccessEvent:\r\n{0}", accessEvent.ToString());
                Data_AccessEvents dataAccessEvent = new Data_AccessEvents();

                try
                {
                    // Convert fields from AccessEvent object to DataAccessEvent entity
                    dataAccessEvent.AccessAreaID = accessEvent.AccessAreaID;
                    dataAccessEvent.AccessResult = accessEvent.AccessResult;
                    dataAccessEvent.AccessType = accessEvent.AccessType;
                    dataAccessEvent.BfID = accessEvent.BfID;
                    dataAccessEvent.BpID = accessEvent.BpID;
                    dataAccessEvent.CreatedOn = DateTime.Now;
                    dataAccessEvent.DenialReason = accessEvent.DenialReason;
                    dataAccessEvent.IsOnlineAccessEvent = accessEvent.IsOnlineAccessEvent;
                    dataAccessEvent.MessageShown = accessEvent.MessageShown;
                    dataAccessEvent.CreatedFrom = "Aditus";
                    dataAccessEvent.EditOn = DateTime.Now;
                    dataAccessEvent.EditFrom = "System";
                    dataAccessEvent.IsManualEntry = false;
                    dataAccessEvent.AddedBySystem = accessEvent.IsSystemEvent;
                    dataAccessEvent.SystemID = accessEvent.SystemID;
                    dataAccessEvent.AccessEventLinkedID = null;

                    // Conversion is needed on following fields
                    if (accessEvent.AccessOn != null)
                    {
                        try
                        {
                            // Try DateTime conversion to test date
                            dataAccessEvent.AccessOn = Convert.ToDateTime(accessEvent.AccessOn);
                        }
                        catch
                        {
                            logger.DebugFormat("DateTime conversion failed on AccessOn: {0}", accessEvent.AccessOn);
                            dataAccessEvent.AccessOn = DateTime.Now;
                            result = -10;
                        }
                    }
                    else
                    {
                        dataAccessEvent.AccessOn = DateTime.Now;
                    }

                    if (!accessEvent.EntryID.Equals(string.Empty))
                    {
                        try
                        {
                            // Convert EntryID from string to int
                            dataAccessEvent.EntryID = Convert.ToInt32(accessEvent.EntryID);
                        }
                        catch
                        {
                            logger.DebugFormat("Int32 conversion failed on EntryID: {0}", accessEvent.EntryID);
                            dataAccessEvent.EntryID = 0;
                            result = -20;
                        }
                    }
                    else
                    {
                        dataAccessEvent.EntryID = 0;
                    }

                    if (!accessEvent.PoeID.Equals(string.Empty))
                    {
                        try
                        {
                            // Convert PoeID from string to int
                            dataAccessEvent.PoeID = Convert.ToInt32(accessEvent.PoeID);
                        }
                        catch
                        {
                            logger.DebugFormat("Int32 conversion failed on PoeID: {0}", accessEvent.PoeID);
                            dataAccessEvent.PoeID = 0;
                            result = -30;
                        }
                    }
                    else
                    {
                        dataAccessEvent.PoeID = 0;
                    }
                    // InternalID max length = 50
                    if (accessEvent.InternalID != null && !accessEvent.InternalID.Equals(string.Empty))
                    {
                        if (accessEvent.InternalID.Length > 50)
                        {
                            logger.DebugFormat("InternalID length exceeds 50 characters: {0}", accessEvent.InternalID);
                            dataAccessEvent.InternalID = accessEvent.InternalID.Substring(0, 50);
                        }
                        else
                        {
                            dataAccessEvent.InternalID = accessEvent.InternalID;
                        }
                    }

                    // Do remark on system events or AccessEventID != null
                    if (accessEvent.AccessEventID != null || (accessEvent.IsSystemEvent && !accessEvent.IsOnlineAccessEvent))
                    {
                        dataAccessEvent.Remark = "Added by Aditus";
                    }
                    else
                    {
                        dataAccessEvent.Remark = string.Empty;
                    }

                    // If result is valid, then it counts
                    if (accessEvent.AccessResult == 1)
                    {
                        dataAccessEvent.CountIt = true;
                    }
                    else
                    {
                        dataAccessEvent.CountIt = false;
                    }
                }
                catch (EntityException ex)
                {
                    logger.Error("EntityException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    result = -40;
                    throw;
                }

                // Get assigned pass
                try
                {
                    Master_Passes pass = entities.Master_Passes.FirstOrDefault(
                        p => p.SystemID == accessEvent.SystemID &&
                        p.BpID == accessEvent.BpID &&
                        p.InternalID == accessEvent.InternalID &&
                        p.ActivatedOn != null);

                    if (pass != null)
                    {
                        dataAccessEvent.OwnerID = pass.EmployeeID;
                        dataAccessEvent.PassType = 1;

                        // Create min wage record for employee
                        int rowCount = entities.CreateEmployeeMinWage(accessEvent.SystemID, accessEvent.BpID, pass.EmployeeID);
                        if (rowCount > 0)
                        {
                            logger.InfoFormat("{0} new min wage records created for employee {1}", rowCount.ToString(), pass.EmployeeID.ToString());
                        }
                    }
                    else
                    {
                        Data_ShortTermPasses shortTermPass = entities.Data_ShortTermPasses.FirstOrDefault(
                            p => p.SystemID == accessEvent.SystemID &&
                            p.BpID == accessEvent.BpID &&
                            p.InternalID == accessEvent.InternalID &&
                            p.ActivatedOn != null &&
                            p.DeactivatedOn == null &&
                            p.LockedOn == null);

                        if (shortTermPass != null && shortTermPass.ShortTermVisitorID != null)
                        {
                            dataAccessEvent.OwnerID = (int) shortTermPass.ShortTermVisitorID;
                            dataAccessEvent.PassType = 2;
                        }
                        else
                        {
                            dataAccessEvent.OwnerID = 0;
                            dataAccessEvent.PassType = 0;
                        }
                    }
                }
                catch (EntityException ex)
                {
                    logger.Error("EntityException: ", ex);
                    throw;
                }
                catch (Exception ex)
                {
                    logger.Error("Exception: ", ex);
                    result = -50;
                    throw;
                }

                // Save new record to db
                entities.Data_AccessEvents.Add(dataAccessEvent);

                EntitySaveChanges(true);
            }

            logger.InfoFormat("{0} access events imported", accessEvents.Count().ToString());
            return result;
        }

        /// <summary>
        /// GetAccessEvents
        /// Get all manual access events from InSite 3 
        /// </summary>
        /// <param name="accessSystemID"></param>
        /// <param name="authID"></param>
        /// <param name="initial"></param>
        /// <returns>AccessEvent[]</returns>
        public AccessEvent[] GetAccessEvents(int accessSystemID, string authID, int lastID)
        {
            logger.InfoFormat("Enter GetAccessEvents with params accessSystemID: {0}; authID: {1}; lastID: {2}", accessSystemID, authID, lastID);

            List<AccessEvent> accessEvents = new List<AccessEvent>();

            // Get access system to building project assignment
            Master_AccessSystems[] accessSystems = entities.Master_AccessSystems.Where(a => a.AccessSystemID == accessSystemID).ToArray();
            if (accessSystems.Count() > 0)
            {
                foreach (Master_AccessSystems accessSystem in accessSystems)
                {
                    accessSystem.LastGetAccessEvents = DateTime.Now;

                    EntitySaveChanges(true);

                    // Get all access events since last update
                    ObjectResult<GetAccessEvents_Result> getAccessEventsResult = entities.GetAccessEvents(accessSystem.SystemID, accessSystem.BpID, lastID);
                    GetAccessEvents_Result[] getAccessEvents = getAccessEventsResult.ToArray();

                    int count = getAccessEvents.Count();
                    if (count > 0)
                    {
                        if (lastID != 0)
                        {
                            logger.InfoFormat("{0} new access events to export for building project {1}", count.ToString(), accessSystem.BpID);
                        }

                        foreach (GetAccessEvents_Result accessEventResult in getAccessEvents)
                        {
                            AccessEvent accessEvent = new AccessEvent();

                            accessEvent.SystemID = accessEventResult.SystemID;
                            accessEvent.BfID = accessEventResult.BfID;
                            accessEvent.BpID = accessEventResult.BpID;
                            accessEvent.AccessAreaID = accessEventResult.AccessAreaID;
                            accessEvent.EntryID = accessEventResult.EntryID.ToString();
                            accessEvent.PoeID = accessEventResult.PoeID.ToString();
                            accessEvent.InternalID = accessEventResult.InternalID;
                            accessEvent.IsOnlineAccessEvent = false;
                            accessEvent.AccessOn = (DateTime) accessEventResult.AccessOn;
                            accessEvent.AccessType = accessEventResult.AccessType;
                            accessEvent.AccessResult = accessEventResult.AccessResult;
                            accessEvent.MessageShown = false;
                            accessEvent.DenialReason = accessEventResult.DenialReason;
                            accessEvent.AccessEventID = accessEventResult.AccessEventID;
                            accessEvent.IsSystemEvent = accessEventResult.AddedBySystem;

                            accessEvents.Add(accessEvent);
                        }

                        if (lastID != 0)
                        {
                            logger.InfoFormat("{0} new access events exported", count.ToString());
                        }
                    }
                }
            }

            if (lastID != 0)
            {
                if (accessEvents.Count() > 0)
                {
                    logger.InfoFormat("Overall {0} new access events exported", accessEvents.Count().ToString());
                }
            }
            else
            {
                logger.InfoFormat("All {0} access events exported", accessEvents.Count().ToString());
            }

            if (ConfigurationManager.AppSettings["SerializeGetAccessEvent"] != null && ConfigurationManager.AppSettings["SerializeGetAccessEvent"].ToString().Equals("true"))
            {
                // Save serialized object to xml file
                string serialized = Helpers.Serialize(accessEvents);
                Helpers.WriteXmlFile(serialized, "GetAccessEvent", 500);
            }

            logger.Info("Exit GetAccessEvents");
            return accessEvents.ToArray();
        }

        /// <summary>
        /// GetNew_Data_AccessRightEvents
        /// Initialisiert ein neues GetNew_Data_AccessRightEvents Objekt
        /// </summary>
        /// <returns>Data_AccessRightEvents</returns>
        private Data_AccessRightEvents GetNew_Data_AccessRightEvents(int systemID, int bpID)
        {
            Data_AccessRightEvents rightEvent = new Data_AccessRightEvents();

            rightEvent.SystemID = systemID;
            rightEvent.BpID = bpID;
            rightEvent.CreatedFrom = "System";
            rightEvent.CreatedOn = DateTime.Now;
            rightEvent.EditFrom = "System";
            rightEvent.EditOn = DateTime.Now;
            rightEvent.IsDelivered = false;
            rightEvent.DeliveryMessage = "";
            rightEvent.IsNewest = true;

            return rightEvent;
        }

        /// <summary>
        /// Rechteänderung bei einem Mitarbeiter verarbeiten
        /// </summary>
        /// <param name="systemID">ID des Systems</param>
        /// <param name="bpID">ID des Bauvorhabens</param>
        /// <param name="employeeID">ID des Mitarbeiters</param>
        public void EmployeeChanged(int systemID, int bpID, int employeeID)
        {
            logger.InfoFormat("Enter EmployeeChanged with param employeeID: {0}", employeeID);
            UserService userService = new UserService();
            Data_AccessRightEvents rightEvent = GetNew_Data_AccessRightEvents(systemID, bpID);
            if (!userService.IsFirstPass(systemID, bpID, employeeID, ""))
            {
                GetEmployees_Result employee = null;
                // Mitarbeiter laden
                GetEmployees_Result[] employees = userService.GetEmployees(systemID, bpID, 0, 0, employeeID, "", 0, 0, 0, "");
                if (employees.Count() > 0)
                {
                    employee = employees[0];
                }

                if (employee != null && employee.PassID != null && employee.InternalID != null && !employee.PassID.Equals(string.Empty) && !employee.InternalID.Equals(string.Empty))
                {
                    logger.InfoFormat("Update employee with employeeID: {0}", employeeID);
                    CultureInfo ci = CultureInfo.CreateSpecificCulture(employee.LanguageID);
                    if (rm.GetString("admPassNotActive", ci).Equals(string.Empty))
                    {
                        ci = CultureInfo.CreateSpecificCulture("en");
                    }

                    rightEvent.PassID = (int) employee.PassID;
                    rightEvent.PassType = PassTypeEmployeePass;
                    rightEvent.ExternalID = employee.ExternalPassID;
                    rightEvent.OwnerID = employeeID;
                    rightEvent.IsActive = Convert.ToBoolean(employee.PassActive) && !Convert.ToBoolean(employee.PassLocked);
                    rightEvent.ValidUntil = employee.ValidUntil;
                    rightEvent.AccessAllowed = AccessAllowed;

                    if (!Convert.ToBoolean(employee.PassActive))
                    {
                        // Ausweis nicht aktiv
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admPassNotActive", ci) + Environment.NewLine;
                    }

                    if (Convert.ToBoolean(employee.PassLocked))
                    {
                        // Ausweis dauerhaft gesperrt
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admPassLocked", ci) + Environment.NewLine;
                    }

                    if (employee.ReleaseBOn == null || employee.ReleaseCOn == null)
                    {
                        // Mitarbeiter ist noch nicht aktiviert
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admEmployeeNotYetActivated", ci) + Environment.NewLine;
                    }

                    if (employee.LockedOn != null)
                    {
                        // Mitarbeiter ist gesperrt
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admEmployeeLocked", ci) + Environment.NewLine;
                    }

                    if (!Convert.ToBoolean(employee.CompanyActive))
                    {
                        // Firma gesperrt
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admCompanyLocked", ci) + Environment.NewLine;
                    }

                    GetLockedMainContractor_Result[] lockedMainContractors = userService.GetLockedMainContractor(systemID, bpID, employee.CompanyID, "");
                    int lockedCount = lockedMainContractors.Count();
                    if (lockedCount > 0)
                    {
                        // Hauptunternehmer gesperrt
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admMainContractorLocked", ci), lockedMainContractors[lockedCount - 1].NameVisible) + Environment.NewLine;
                    }

                    if (employee.AccessRightValidUntil != null && employee.AccessRightValidUntil < DateTime.Now)
                    {
                        // Gültigkeit des Zutrittsrechts abgelaufen
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admAccessRightValidUntilExpired", ci) + Environment.NewLine;
                    }

                    // Zutrittsrelevante Dokumente
                    int ruleID = userService.GetAppliedRule(systemID, bpID, employeeID, "");
                    if (ruleID == -1)
                    {
                        // Keine Dokumentenprüfregel zugeordnet
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admNoDocumentCheckingRule", ci) + Environment.NewLine;
                    }
                    else if (ruleID == 0)
                    {
                        // Keine Dokumente notwendig
                    }
                    else
                    {
                        // Relevante Dokumente des Mitarbeiters überprüfen
                        HasValidDocumentRelevantFor_Result[] results = userService.HasValidDocumentRelevantFor(systemID, bpID, employeeID, "");
                        if (results.Count() > 0)
                        {
                            HasValidDocumentRelevantFor_Result[] arrayResult = null;

                            bool docLabourRightExists = false;
                            bool docLabourRightValid = false;
                            DateTime? docLabourRightExpiration = null;

                            bool docResidenceRightExists = false;
                            bool docResidenceRightValid = false;
                            DateTime? docResidenceRightExpiration = null;

                            bool docLegitimationExists = false;
                            bool docLegitimationValid = false;
                            DateTime? docLegitimationExpiration = null;

                            bool docInsuranceExists = false;
                            bool docInsuranceValid = false;
                            DateTime? docInsuranceExpiration = null;

                            bool docInsuranceAdditionalExists = false;
                            bool docInsuranceAdditionalValid = false;
                            DateTime? docInsuranceAdditionalExpiration = null;

                            DateTime? validUntil = null;

                            if (employee.AccessRightValidUntil != null)
                            {
                                validUntil = employee.AccessRightValidUntil;
                            }

                            // Arbeitsrecht
                            HasValidDocumentRelevantFor_Result resultLabourRight = new HasValidDocumentRelevantFor_Result();
                            arrayResult = results.Where(rf => rf.RelevantFor == 1).ToArray();
                            if (arrayResult.Count() > 0)
                            {
                                resultLabourRight = arrayResult[0];
                                docLabourRightExists = resultLabourRight.DocumentReceived;

                                DateTime? expirationDate = resultLabourRight.ExpirationDate;
                                if (expirationDate != null)
                                {
                                    expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                                }

                                docLabourRightValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                                if (expirationDate != null && resultLabourRight.IsAccessRelevant)
                                {
                                    if ((validUntil != null && validUntil > expirationDate && resultLabourRight.IsAccessRelevant) ||
                                        (validUntil == null && resultLabourRight.IsAccessRelevant))
                                    {
                                        docLabourRightExpiration = (DateTime) expirationDate;
                                    }
                                    else
                                    {
                                        docLabourRightExpiration = validUntil;
                                    }
                                }
                            }

                            // Aufenthaltsrecht
                            HasValidDocumentRelevantFor_Result resultResidenceRight = new HasValidDocumentRelevantFor_Result();
                            arrayResult = results.Where(rf => rf.RelevantFor == 2).ToArray();
                            if (arrayResult.Count() > 0)
                            {
                                resultResidenceRight = arrayResult[0];
                                docResidenceRightExists = resultResidenceRight.DocumentReceived;

                                DateTime? expirationDate = resultResidenceRight.ExpirationDate;
                                if (expirationDate != null)
                                {
                                    expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                                }

                                docResidenceRightValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                                if (expirationDate != null && resultResidenceRight.IsAccessRelevant)
                                {
                                    if ((validUntil != null && validUntil > expirationDate && resultResidenceRight.IsAccessRelevant) ||
                                        (validUntil == null && resultResidenceRight.IsAccessRelevant))
                                    {
                                        docResidenceRightExpiration = (DateTime) expirationDate;
                                    }
                                    else
                                    {
                                        docResidenceRightExpiration = validUntil;
                                    }
                                }
                            }

                            // Legitimation
                            HasValidDocumentRelevantFor_Result resultLegitimation = new HasValidDocumentRelevantFor_Result();
                            arrayResult = results.Where(rf => rf.RelevantFor == 3).ToArray();
                            if (arrayResult.Count() > 0)
                            {
                                resultLegitimation = arrayResult[0];
                                docLegitimationExists = resultLegitimation.DocumentReceived;

                                DateTime? expirationDate = resultLegitimation.ExpirationDate;
                                if (expirationDate != null)
                                {
                                    expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                                }

                                docLegitimationValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                                if (expirationDate != null && resultLegitimation.IsAccessRelevant)
                                {
                                    if ((validUntil != null && validUntil > expirationDate && resultLegitimation.IsAccessRelevant) ||
                                        (validUntil == null && resultLegitimation.IsAccessRelevant))
                                    {
                                        docLegitimationExpiration = (DateTime) expirationDate;
                                    }
                                    else
                                    {
                                        docLegitimationExpiration = validUntil;
                                    }
                                }
                            }

                            // Versicherung
                            HasValidDocumentRelevantFor_Result resultInsurance = new HasValidDocumentRelevantFor_Result();
                            arrayResult = results.Where(rf => rf.RelevantFor == 4).ToArray();
                            if (arrayResult.Count() > 0)
                            {
                                resultInsurance = arrayResult[0];
                                docInsuranceExists = resultInsurance.DocumentReceived;

                                DateTime? expirationDate = resultInsurance.ExpirationDate;
                                if (expirationDate != null)
                                {
                                    expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                                }

                                docInsuranceValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                                if (expirationDate != null && resultInsurance.IsAccessRelevant)
                                {
                                    if ((validUntil != null && validUntil > expirationDate && resultInsurance.IsAccessRelevant) ||
                                        (validUntil == null && resultInsurance.IsAccessRelevant))
                                    {
                                        docInsuranceExpiration = (DateTime) expirationDate;
                                    }
                                    else
                                    {
                                        docInsuranceExpiration = validUntil;
                                    }
                                }
                            }

                            // Zusätzliche Versicherung
                            HasValidDocumentRelevantFor_Result resultInsuranceAdditional = new HasValidDocumentRelevantFor_Result();
                            arrayResult = results.Where(rf => rf.RelevantFor == 5).ToArray();
                            if (arrayResult.Count() > 0)
                            {
                                resultInsuranceAdditional = arrayResult[0];
                                docInsuranceAdditionalExists = resultInsuranceAdditional.DocumentReceived;

                                DateTime? expirationDate = resultInsuranceAdditional.ExpirationDate;
                                if (expirationDate != null)
                                {
                                    expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                                }

                                docInsuranceAdditionalValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                                if (expirationDate != null && resultInsuranceAdditional.IsAccessRelevant)
                                {
                                    if ((validUntil != null && validUntil > expirationDate && resultInsuranceAdditional.IsAccessRelevant) ||
                                        (validUntil == null && resultInsuranceAdditional.IsAccessRelevant))
                                    {
                                        docInsuranceAdditionalExpiration = (DateTime) expirationDate;
                                    }
                                    else
                                    {
                                        docInsuranceAdditionalExpiration = validUntil;
                                    }
                                }
                            }

                            if (ruleID == 1)
                            // Legitimation *und* Versicherung	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Versicherung
                                if (docInsuranceExists)
                                {
                                    if (!docInsuranceValid)
                                    {
                                        // Dokument für Versicherung ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Versicherung liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docInsuranceExpiration != null && validUntil != null && docInsuranceExpiration < validUntil)
                                {
                                    validUntil = docInsuranceExpiration;
                                }
                            }
                            else if (ruleID == 2)
                            // Legitimation *und* Aufenthaltsrecht *und* Arbeitsrecht *und* Versicherung	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Aufenthaltsrecht
                                if (docResidenceRightExists)
                                {
                                    if (!docResidenceRightValid)
                                    {
                                        // Dokument für Aufenthaltsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Aufenthaltsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docResidenceRightExpiration != null && validUntil != null && docResidenceRightExpiration < validUntil)
                                {
                                    validUntil = docResidenceRightExpiration;
                                }

                                // Arbeitsrecht
                                if (docLabourRightExists)
                                {
                                    if (!docLabourRightValid)
                                    {
                                        // Dokument für Arbeitsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Arbeitsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLabourRightExpiration != null && validUntil != null && docLabourRightExpiration < validUntil)
                                {
                                    validUntil = docLabourRightExpiration;
                                }

                                // Versicherung
                                if (docInsuranceExists)
                                {
                                    if (!docInsuranceValid)
                                    {
                                        // Dokument für Versicherung ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Versicherung liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docInsuranceExpiration != null && validUntil != null && docInsuranceExpiration < validUntil)
                                {
                                    validUntil = docInsuranceExpiration;
                                }
                            }
                            else if (ruleID == 3)
                            // Legitimation *und* Arbeitsrecht *und* Versicherung	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Arbeitsrecht
                                if (docLabourRightExists)
                                {
                                    if (!docLabourRightValid)
                                    {
                                        // Dokument für Arbeitsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Arbeitsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLabourRightExpiration != null && validUntil != null && docLabourRightExpiration < validUntil)
                                {
                                    validUntil = docLabourRightExpiration;
                                }

                                // Versicherung
                                if (docInsuranceExists)
                                {
                                    if (!docInsuranceValid)
                                    {
                                        // Dokument für Versicherung ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Versicherung liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docInsuranceExpiration != null && validUntil != null && docInsuranceExpiration < validUntil)
                                {
                                    validUntil = docInsuranceExpiration;
                                }
                            }
                            else if (ruleID == 4)
                            // Legitimation *und* Aufenthaltsrecht *und* Arbeitsrecht *und* Versicherung *und* Versicherung zusätzlich	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Aufenthaltsrecht
                                if (docResidenceRightExists)
                                {
                                    if (!docResidenceRightValid)
                                    {
                                        // Dokument für Aufenthaltsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Aufenthaltsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docResidenceRightExpiration != null && validUntil != null && docResidenceRightExpiration < validUntil)
                                {
                                    validUntil = docResidenceRightExpiration;
                                }

                                // Arbeitsrecht
                                if (docLabourRightExists)
                                {
                                    if (!docLabourRightValid)
                                    {
                                        // Dokument für Arbeitsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Arbeitsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLabourRightExpiration != null && validUntil != null && docLabourRightExpiration < validUntil)
                                {
                                    validUntil = docLabourRightExpiration;
                                }

                                // Versicherung
                                if (docInsuranceExists)
                                {
                                    if (!docInsuranceValid)
                                    {
                                        // Dokument für Versicherung ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Versicherung liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docInsuranceExpiration != null && validUntil != null && docInsuranceExpiration < validUntil)
                                {
                                    validUntil = docInsuranceExpiration;
                                }

                                // Versicherung zusätzlich
                                if (docInsuranceAdditionalExists)
                                {
                                    if (!docInsuranceAdditionalValid)
                                    {
                                        // Dokument für Versicherung ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultInsuranceAdditional.NameVisible, rm.GetString(resultInsuranceAdditional.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Versicherung liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultInsuranceAdditional.NameVisible, rm.GetString(resultInsuranceAdditional.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docInsuranceAdditionalExpiration != null && validUntil != null && docInsuranceAdditionalExpiration < validUntil)
                                {
                                    validUntil = docInsuranceAdditionalExpiration;
                                }
                            }

                            if (ruleID == 5)
                            // Legitimation *und* Arbeitsrecht	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Arbeitsrecht
                                if (docLabourRightExists)
                                {
                                    if (!docLabourRightValid)
                                    {
                                        // Dokument für Arbeitsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Arbeitsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLabourRightExpiration != null && validUntil != null && docLabourRightExpiration < validUntil)
                                {
                                    validUntil = docLabourRightExpiration;
                                }
                            }

                            if (ruleID == 6)
                            // Legitimation *und* Aufenthaltsrecht	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Aufenthaltsrecht
                                if (docResidenceRightExists)
                                {
                                    if (!docResidenceRightValid)
                                    {
                                        // Dokument für Aufenthaltsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Aufenthaltsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docResidenceRightExpiration != null && validUntil != null && docResidenceRightExpiration < validUntil)
                                {
                                    validUntil = docResidenceRightExpiration;
                                }
                            }
                            else if (ruleID == 7)
                            // Legitimation *und* Aufenthaltsrecht *und* Arbeitsrecht	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Aufenthaltsrecht
                                if (docResidenceRightExists)
                                {
                                    if (!docResidenceRightValid)
                                    {
                                        // Dokument für Aufenthaltsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Aufenthaltsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docResidenceRightExpiration != null && validUntil != null && docResidenceRightExpiration < validUntil)
                                {
                                    validUntil = docResidenceRightExpiration;
                                }

                                // Arbeitsrecht
                                if (docLabourRightExists)
                                {
                                    if (!docLabourRightValid)
                                    {
                                        // Dokument für Arbeitsrecht ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Arbeitsrecht liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLabourRightExpiration != null && validUntil != null && docLabourRightExpiration < validUntil)
                                {
                                    validUntil = docLabourRightExpiration;
                                }
                            }
                            else if (ruleID == 8)
                            // Legitimation	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }
                            }
                            else if (ruleID == 9)
                            // Legitimation *und* Versicherung *und* Versicherung zusätzlich	
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Versicherung
                                if (docInsuranceExists)
                                {
                                    if (!docInsuranceValid)
                                    {
                                        // Dokument für Versicherung ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Versicherung liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docInsuranceExpiration != null && validUntil != null && docInsuranceExpiration < validUntil)
                                {
                                    validUntil = docInsuranceExpiration;
                                }

                                // Versicherung zusätzlich
                                if (docInsuranceAdditionalExists)
                                {
                                    if (!docInsuranceAdditionalValid)
                                    {
                                        // Dokument für Versicherung ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultInsuranceAdditional.NameVisible, rm.GetString(resultInsuranceAdditional.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Versicherung liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultInsuranceAdditional.NameVisible, rm.GetString(resultInsuranceAdditional.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docInsuranceAdditionalExpiration != null && validUntil != null && docInsuranceAdditionalExpiration < validUntil)
                                {
                                    validUntil = docInsuranceAdditionalExpiration;
                                }
                            }
                            else if (ruleID == 10)
                            // Legitimation *und* (Aufenthaltsrecht *oder* Arbeitsrecht) *und* Versicherung
                            {
                                // Legitimation
                                if (docLegitimationExists)
                                {
                                    if (!docLegitimationValid)
                                    {
                                        // Dokument für Legitimation ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Legitimation liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLegitimation.NameVisible, rm.GetString(resultLegitimation.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docLegitimationExpiration != null && validUntil != null && docLegitimationExpiration < validUntil)
                                {
                                    validUntil = docLegitimationExpiration;
                                }

                                // Aufenthaltsrecht oder Arbeitrecht 
                                if (docResidenceRightExists || docLabourRightExists)
                                {
                                    if (!docResidenceRightValid && !docLabourRightValid)
                                    {
                                        // Dokumente für Aufenthaltsrecht und Arbeitsrecht sind abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokumente für Aufenthaltsrecht und Arbeitsrecht liegen nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultResidenceRight.NameVisible, rm.GetString(resultResidenceRight.ResourceID, ci)) + Environment.NewLine;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultLabourRight.NameVisible, rm.GetString(resultLabourRight.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docResidenceRightExpiration != null && validUntil != null && docResidenceRightExpiration < validUntil)
                                {
                                    validUntil = docResidenceRightExpiration;
                                }
                                if (docLabourRightExpiration != null && validUntil != null && docLabourRightExpiration < validUntil)
                                {
                                    validUntil = docLabourRightExpiration;
                                }

                                // Versicherung
                                if (docInsuranceExists)
                                {
                                    if (!docInsuranceValid)
                                    {
                                        // Dokument für Versicherung ist abgelaufen
                                        rightEvent.AccessAllowed &= AccessNotAllowed;
                                        rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotValid", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                    }
                                }
                                else
                                {
                                    // Dokument für Versicherung liegt nicht vor
                                    rightEvent.AccessAllowed &= AccessNotAllowed;
                                    rightEvent.AccessDenialReason += string.Format(rm.GetString("admDocumentNotPresent", ci), resultInsurance.NameVisible, rm.GetString(resultInsurance.ResourceID, ci)) + Environment.NewLine;
                                }
                                if (docInsuranceExpiration != null && validUntil != null && docInsuranceExpiration < validUntil)
                                {
                                    validUntil = docInsuranceExpiration;
                                }
                            }

                            // Niedrigstes zutrittsrelevantes Ablaufdatum der Dokumente
                            if (validUntil != null)
                            {
                                rightEvent.ValidUntil = (DateTime) validUntil;
                            }
                        }
                    }

                    List<Data_AccessAreaEvents> areaEvents = new List<Data_AccessAreaEvents>();
                        // Zutrittsbereiche für Mitarbeiter laden
                        GetEmployeeAccessAreas_Result[] accessAreas = null;
                        accessAreas = userService.GetEmployeeAccessAreas(systemID, bpID, employeeID, "");
                        bool allAccessAreasInvalid = true;

                        if (accessAreas.Count() > 0)
                        {
                            foreach (GetEmployeeAccessAreas_Result accessArea in accessAreas)
                            {
                                Data_AccessAreaEvents areaEvent = new Data_AccessAreaEvents();

                                areaEvent.SystemID = systemID;
                                areaEvent.BpID = bpID;
                                areaEvent.AccessAreaID = accessArea.AccessAreaID;
                                areaEvent.TimeSlotID = accessArea.TimeSlotID;
                                areaEvent.ValidFrom = accessArea.ValidFrom;
                                areaEvent.ValidUntil = accessArea.ValidUntil;
                                areaEvent.ValidDays = accessArea.ValidDays;
                                areaEvent.TimeFrom = accessArea.TimeFrom;
                                areaEvent.TimeUntil = accessArea.TimeUntil;

                                areaEvents.Add(areaEvent);

                                if (accessArea.ValidUntil >= DateTime.Now)
                                {
                                    allAccessAreasInvalid &= false;
                                }

                                areaEvent.AdditionalRights = accessArea.AdditionalRights;
                            }

                            if (allAccessAreasInvalid)
                            {
                                // Alle zugeordneten Zutrittsbereiche ungültig
                                rightEvent.AccessAllowed &= AccessNotAllowed;
                                rightEvent.AccessDenialReason += rm.GetString("admAccessAreasInvalid", ci) + Environment.NewLine;
                            }
                        }
                        else
                        {
                            // Keine Zutrittsbereiche zugeordnet
                            rightEvent.AccessAllowed &= AccessNotAllowed;
                            rightEvent.AccessDenialReason += rm.GetString("admNoAccessAreas", ci) + Environment.NewLine;
                        }

                    ObjectResult<GetMWLackTriggerOverdueEmployee_Result> result = entities.GetMWLackTriggerOverdueEmployee(systemID, bpID, employeeID);
                    if (result.Count() > 0)
                    {
                        // Vorlagefrist für Mindestlohnbescheinigung überzogen
                        logger.DebugFormat("Minimum wage lack trigger overdue for employee {0}: {1}", employeeID, employee.FirstName + ' ' + employee.LastName);
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admMWLackOverdue", ci) + Environment.NewLine;
                    }

                    rightEvent.Message = "";
                    rightEvent.MessageFrom = Convert.ToDateTime("01.01.1900 00:00:00");
                    rightEvent.MessageUntil = Convert.ToDateTime("01.01.1900 00:00:00");

                    string deactivationMessage = rm.GetString("admPassNotActive", ci) + Environment.NewLine;
                    userService.CreateAccessRightEvent(rightEvent, areaEvents.ToArray(), deactivationMessage, "");
                }
            }
        }

        /// <summary>
        /// Mitarbeiter ermitteln, die die Vorlagefrist für Mindestlohnbescheinigungen überzogen haben
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        public void MWLackTriggerOverdue(int systemID, int bpID)
        {
            ObjectResult<GetMWLackTriggerOverdue_Result> result = entities.GetMWLackTriggerOverdue(systemID, bpID);
            GetMWLackTriggerOverdue_Result[] resultArray = result.ToArray();
            if (resultArray.Count() > 0)
            {
                foreach (GetMWLackTriggerOverdue_Result employee in resultArray)
                {
                    EmployeeChanged(systemID, bpID, employee.EmployeeID);
                }
            }
        }

        /// <summary>
        /// Rechteänderung bei einer Firma verarbeiten
        /// </summary>
        /// <param name="companyID"></param>
        /// <param name="withSubcontractors"></param>
        public void CompanyChanged(int systemID, int bpID, int companyID, bool withSubcontractors)
        {
            UserService userService = new UserService();
            GetEmployees_Result[] employees = null;

            if (withSubcontractors)
            {
                // Alle Subunternehmer laden
                GetSubContractors_Result[] subContractors = userService.GetSubContractors(systemID, bpID, companyID, "");
                foreach (GetSubContractors_Result subContractor in subContractors)
                {
                    // Alle Mitarbeiter eines Subunternehmers laden
                    employees = userService.GetEmployees(systemID, bpID, 0, (int) subContractor.CompanyID, 0, "", 0, 0, 0, "");
                    foreach (GetEmployees_Result employee in employees)
                    {
                        EmployeeChanged(systemID, bpID, employee.EmployeeID);
                    }
                }
            }

            // Alle Mitarbeiter der Firma laden
            employees = userService.GetEmployees(systemID, bpID, 0, companyID, 0, "", 0, 0, 0, "");
            foreach (GetEmployees_Result employee in employees)
            {
                EmployeeChanged(systemID, bpID, employee.EmployeeID);
            }
        }

        /// <summary>
        /// Rechteänderung bei einem relevanten Dokument verarbeiten
        /// </summary>
        /// <param name="relevantDocumentID"></param>
        public void RelevantDocumentChanged(int systemID, int bpID, int relevantDocumentID)
        {
            UserService userService = new UserService();
            GetEmployeesWithRelevantDocument_Result[] results = userService.GetEmployeesWithRelevantDocument(systemID, bpID, relevantDocumentID, "");
            foreach (GetEmployeesWithRelevantDocument_Result result in results)
            {
                EmployeeChanged(systemID, bpID, result.EmployeeID);
            }
        }

        /// <summary>
        /// Rechteänderung bei der Zuordnung eines Landes verarbeiten
        /// </summary>
        /// <param name="countryID"></param>
        public void CountryChanged(int systemID, int bpID, string countryID)
        {
            UserService userService = new UserService();
            int?[] results = userService.GetEmployeesWithCountry(systemID, bpID, countryID, "");
            foreach (int employeeID in results)
            {
                EmployeeChanged(systemID, bpID, employeeID);
            }
        }

        public void DocumentRuleChanged(int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID, int relevantDocumentID)
        {
        }

        /// <summary>
        /// Rechteänderung bei einer Dokumentenprüfregel verarbeiten
        /// </summary>
        /// <param name="countryGroupIDEmployer"></param>
        /// <param name="countryGroupIDEmployee"></param>
        /// <param name="employmentStatusID"></param>
        public void DocumentCheckingRuleChanged(int systemID, int bpID, int countryGroupIDEmployer, int countryGroupIDEmployee, int employmentStatusID)
        {
            UserService userService = new UserService();
            int?[] results = userService.GetEmployeesWithEmploymentStatus(systemID, bpID, countryGroupIDEmployer, countryGroupIDEmployee, employmentStatusID, "");
            foreach (int employeeID in results)
            {
                EmployeeChanged(systemID, bpID, employeeID);
            }
        }

        /// <summary>
        /// Rechteänderung bei einem Zeitfenster verarbeiten
        /// </summary>
        /// <param name="timeSlotID"></param>
        public void TimeSlotChanged(int systemID, int bpID, int timeSlotID)
        {
            UserService userService = new UserService();
            GetEmployeesWithTimeSlot_Result[] results = userService.GetEmployeesWithTimeSlot(systemID, bpID, timeSlotID, "");
            foreach (GetEmployeesWithTimeSlot_Result result in results)
            {
                EmployeeChanged(systemID, bpID, result.EmployeeID);
            }
        }

        /// <summary>
        /// Rechteänderung bei einem Kurzzeitausweis verarbeiten
        /// </summary>
        /// <param name="shortTermPassID"></param>
        public void ShortTermPassChanged(int systemID, int bpID, int shortTermPassID)
        {
            UserService userService = new UserService();
            GetShortTermPasses_Result[] results = userService.GetShortTermPasses(systemID, bpID, shortTermPassID, "");
            if (results.Count() > 0)
            {
                GetShortTermPasses_Result shortTermPass = results[0];

                CultureInfo ci = CultureInfo.CreateSpecificCulture("en");

                Data_AccessRightEvents rightEvent = GetNew_Data_AccessRightEvents(systemID, bpID);
                rightEvent.PassID = shortTermPass.ShortTermPassID;
                rightEvent.PassType = PassTypeShortTermPass;
                rightEvent.ExternalID = shortTermPass.ExternalID;
                rightEvent.OwnerID = shortTermPass.ShortTermVisitorID;
                if (shortTermPass.PassActivatedOn != null && shortTermPass.PassDeactivatedOn == null && shortTermPass.PassLockedOn == null)
                {
                    rightEvent.IsActive = true;
                }
                else
                {
                    rightEvent.IsActive = false;
                }

                if (shortTermPass.PassDeactivatedOn != null && shortTermPass.PassLockedOn == null)
                {
                    // Pass deaktiviert
                    rightEvent.AccessDenialReason += rm.GetString("admPassNotActive", ci) + Environment.NewLine;
                }

                if (shortTermPass.PassLockedOn != null)
                {
                    // Pass gesperrt
                    rightEvent.AccessDenialReason += rm.GetString("admPassLocked", ci) + Environment.NewLine;
                }

                rightEvent.ValidUntil = shortTermPass.AccessAllowedUntil;
                rightEvent.AccessAllowed = rightEvent.IsActive;

                List<Data_AccessAreaEvents> areaEvents = new List<Data_AccessAreaEvents>();
                    // Zutrittsbereiche für Besucher laden
                    GetVisitorAccessAreas_Result[] accessAreas = null;
                    accessAreas = userService.GetVisitorAccessAreas(systemID, bpID, shortTermPass.ShortTermVisitorID, "");

                    if (accessAreas.Count() > 0)
                    {
                        foreach (GetVisitorAccessAreas_Result accessArea in accessAreas)
                        {
                            Data_AccessAreaEvents areaEvent = new Data_AccessAreaEvents();

                            areaEvent.SystemID = systemID;
                            areaEvent.BpID = bpID;
                            areaEvent.AccessAreaID = accessArea.AccessAreaID;
                            areaEvent.TimeSlotID = accessArea.TimeSlotID;
                            areaEvent.AdditionalRights = accessArea.AdditionalRights;
                            areaEvent.ValidFrom = accessArea.ValidFrom;
                            areaEvent.ValidUntil = Convert.ToDateTime(accessArea.ValidUntil);
                            areaEvent.ValidDays = accessArea.ValidDays;
                            areaEvent.TimeFrom = accessArea.TimeFrom;
                            areaEvent.TimeUntil = accessArea.TimeUntil;

                            areaEvents.Add(areaEvent);
                        }
                    }
                    else
                    {
                        // Keine Zutrittsbereiche zugeordnet
                        rightEvent.AccessAllowed &= AccessNotAllowed;
                        rightEvent.AccessDenialReason += rm.GetString("admNoAccessAreas", ci) + Environment.NewLine;
                    }

                rightEvent.Message = "";
                rightEvent.MessageFrom = Convert.ToDateTime("01.01.1900 00:00:00");
                rightEvent.MessageUntil = Convert.ToDateTime("01.01.1900 00:00:00");
                rightEvent.CreatedFrom = "System";
                rightEvent.CreatedOn = DateTime.Now;
                rightEvent.EditFrom = "System";
                rightEvent.EditOn = DateTime.Now;
                rightEvent.IsDelivered = false;
                rightEvent.DeliveryMessage = "";
                rightEvent.IsNewest = true;

                string deactivationMessage = rm.GetString("admPassNotActive", ci) + Environment.NewLine;
                userService.CreateAccessRightEvent(rightEvent, areaEvents.ToArray(), deactivationMessage, "");
            }
        }

        /// <summary>
        /// Prüfung, ob alle relevanten Dokumente für einen Mitarbeiter vorliegen
        /// </summary>
        /// <param name="employeeID"></param>
        /// <returns></returns>
        public bool AllRelevantDocumentsSubmitted(int systemID, int bpID, int employeeID)
        {
            bool complete = AccessAllowed;

            UserService userService = new UserService();
            Master_BuildingProjects bp = userService.GetBpInfo(bpID, "");

            int ruleID = userService.GetAppliedRule(systemID, bpID, employeeID, "");

            if (ruleID != 0 && bp.PrintPassOnCompleteDocs)
            {
                HasValidDocumentRelevantFor_Result[] results = userService.HasValidDocumentRelevantFor(systemID, bpID, employeeID, "");
                if (results.Count() > 0)
                {
                    HasValidDocumentRelevantFor_Result[] arrayResult = null;
                    bool docLabourRightExists = false;
                    bool docLabourRightValid = false;
                    bool docResidenceRightExists = false;
                    bool docResidenceRightValid = false;
                    bool docLegitimationExists = false;
                    bool docLegitimationValid = false;
                    bool docInsuranceExists = false;
                    bool docInsuranceValid = false;
                    bool docInsuranceAdditionalExists = false;
                    bool docInsuranceAdditionalValid = false;

                    HasValidDocumentRelevantFor_Result resultLabourRight = new HasValidDocumentRelevantFor_Result();
                    arrayResult = results.Where(rf => rf.RelevantFor == 1).ToArray();
                    if (arrayResult.Count() > 0)
                    {
                        resultLabourRight = arrayResult[0];
                        docLabourRightExists = resultLabourRight.DocumentReceived;

                        DateTime? expirationDate = resultLabourRight.ExpirationDate;
                        if (expirationDate != null)
                        {
                            expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                        }

                        docLabourRightValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                    }

                    HasValidDocumentRelevantFor_Result resultResidenceRight = new HasValidDocumentRelevantFor_Result();
                    arrayResult = results.Where(rf => rf.RelevantFor == 2).ToArray();
                    if (arrayResult.Count() > 0)
                    {
                        resultResidenceRight = arrayResult[0];
                        docResidenceRightExists = resultResidenceRight.DocumentReceived;

                        DateTime? expirationDate = resultResidenceRight.ExpirationDate;
                        if (expirationDate != null)
                        {
                            expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                        }

                        docResidenceRightValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                    }

                    HasValidDocumentRelevantFor_Result resultLegitimation = new HasValidDocumentRelevantFor_Result();
                    arrayResult = results.Where(rf => rf.RelevantFor == 3).ToArray();
                    if (arrayResult.Count() > 0)
                    {
                        resultLegitimation = arrayResult[0];
                        docLegitimationExists = resultLegitimation.DocumentReceived;

                        DateTime? expirationDate = resultLegitimation.ExpirationDate;
                        if (expirationDate != null)
                        {
                            expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                        }

                        docLegitimationValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                    }

                    HasValidDocumentRelevantFor_Result resultInsurance = new HasValidDocumentRelevantFor_Result();
                    arrayResult = results.Where(rf => rf.RelevantFor == 4).ToArray();
                    if (arrayResult.Count() > 0)
                    {
                        resultInsurance = arrayResult[0];
                        docInsuranceExists = resultInsurance.DocumentReceived;

                        DateTime? expirationDate = resultInsurance.ExpirationDate;
                        if (expirationDate != null)
                        {
                            expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                        }

                        docInsuranceValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                    }

                    HasValidDocumentRelevantFor_Result resultInsuranceAdditional = new HasValidDocumentRelevantFor_Result();
                    arrayResult = results.Where(rf => rf.RelevantFor == 5).ToArray();
                    if (arrayResult.Count() > 0)
                    {
                        resultInsuranceAdditional = arrayResult[0];
                        docInsuranceAdditionalExists = resultInsuranceAdditional.DocumentReceived;

                        DateTime? expirationDate = resultInsuranceAdditional.ExpirationDate;
                        if (expirationDate != null)
                        {
                            expirationDate = ((DateTime) expirationDate).AddHours(23).AddMinutes(59).AddSeconds(59);
                        }

                        docInsuranceAdditionalValid = (expirationDate != null && expirationDate >= DateTime.Now) || expirationDate == null;
                    }

                    bool combinedBool = AccessNotAllowed;

                    if (ruleID == 1)
                    {
                        // Legitimation *und* Versicherung	
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docInsuranceExists)
                        {
                            if (!docInsuranceValid)
                            {
                                // Dokument für Versicherung ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Versicherung liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }
                    else if (ruleID == 2)
                    {
                        // Legitimation *und* Aufenthaltsrecht *und* Arbeitsrecht *und* Versicherung	
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docResidenceRightExists)
                        {
                            if (!docResidenceRightValid)
                            {
                                // Dokument für Aufenthaltsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Aufenthaltsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docLabourRightExists)
                        {
                            if (!docLabourRightValid)
                            {
                                // Dokument für Arbeitsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Arbeitsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docInsuranceExists)
                        {
                            if (!docInsuranceValid)
                            {
                                // Dokument für Versicherung ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Versicherung liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }
                    else if (ruleID == 3)
                    {
                        // Legitimation *und* Arbeitsrecht *und* Versicherung	
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docLabourRightExists)
                        {
                            if (!docLabourRightValid)
                            {
                                // Dokument für Arbeitsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Arbeitsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docInsuranceExists)
                        {
                            if (!docInsuranceValid)
                            {
                                // Dokument für Versicherung ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Versicherung liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }
                    else if (ruleID == 4)
                    // Legitimation *und* Aufenthaltsrecht *und* Arbeitsrecht *und* Versicherung *und* Versicherung zusätzlich	
                    {
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docResidenceRightExists)
                        {
                            if (!docResidenceRightValid)
                            {
                                // Dokument für Aufenthaltsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Aufenthaltsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docLabourRightExists)
                        {
                            if (!docLabourRightValid)
                            {
                                // Dokument für Arbeitsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Arbeitsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docInsuranceExists)
                        {
                            if (!docInsuranceValid)
                            {
                                // Dokument für Versicherung ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Versicherung liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docInsuranceAdditionalExists)
                        {
                            if (!docInsuranceAdditionalValid)
                            {
                                // Dokument für Versicherung zusätzlich ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Versicherung zusätzlich liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }

                    if (ruleID == 5)
                    // Legitimation *und* Arbeitsrecht	
                    {
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docLabourRightExists)
                        {
                            if (!docLabourRightValid)
                            {
                                // Dokument für Arbeitsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Arbeitsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }

                    if (ruleID == 6)
                    // Legitimation *und* Aufenthaltsrecht	
                    {
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docResidenceRightExists)
                        {
                            if (!docResidenceRightValid)
                            {
                                // Dokument für Aufenthaltsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Aufenthaltsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }
                    else if (ruleID == 7)
                    // Legitimation *und* Aufenthaltsrecht *und* Arbeitsrecht	
                    {
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docResidenceRightExists)
                        {
                            if (!docResidenceRightValid)
                            {
                                // Dokument für Aufenthaltsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Aufenthaltsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docLabourRightExists)
                        {
                            if (!docLabourRightValid)
                            {
                                // Dokument für Arbeitsrecht ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Arbeitsrecht liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }
                    else if (ruleID == 8)
                    // Legitimation	
                    {
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }
                    else if (ruleID == 9)
                    // Legitimation *und* Versicherung *und* Versicherung zusätzlich	
                    {
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docInsuranceExists)
                        {
                            if (!docInsuranceValid)
                            {
                                // Dokument für Versicherung ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Versicherung liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        if (docInsuranceAdditionalExists)
                        {
                            if (!docInsuranceAdditionalValid)
                            {
                                // Dokument für Versicherung zusätzlich ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Versicherung zusätzlich liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }
                    else if (ruleID == 10)
                    // Legitimation *und* (Aufenthaltsrecht *oder* Arbeitsrecht) *und* Versicherung	
                    {
                        if (docLegitimationExists)
                        {
                            if (!docLegitimationValid)
                            {
                                // Dokument für Legitimation ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Legitimation liegt nicht vor
                            complete &= AccessNotAllowed;
                        }

                        // Alternativ Aufenthaltsrecht
                        if (docResidenceRightExists && docResidenceRightValid)
                        {
                            combinedBool |= AccessAllowed;
                        }
                        else
                        {
                            combinedBool |= AccessNotAllowed;
                        }

                        // Alternativ Arbeitsrecht
                        if (docLabourRightExists && docLabourRightValid)
                        {
                            combinedBool |= AccessAllowed;
                        }
                        else
                        {
                            combinedBool |= AccessNotAllowed;
                        }

                        // Alternativen auswerten
                        if (!combinedBool)
                        {
                            complete &= AccessNotAllowed;
                        }

                        if (docInsuranceExists)
                        {
                            if (!docInsuranceValid)
                            {
                                // Dokument für Versicherung ist abgelaufen
                                complete &= AccessNotAllowed;
                            }
                        }
                        else
                        {
                            // Dokument für Versicherung liegt nicht vor
                            complete &= AccessNotAllowed;
                        }
                    }
                }
            }

            return complete;
        }

        /// <summary>
        /// AccessDataConsistency
        /// </summary>
        /// <param name="systemID"></param>
        /// <param name="bpID"></param>
        /// <returns></returns>
        public int AccessDataConsistency(int systemID, int bpID)
        {
            logger.InfoFormat("Enter AccessDataConsistency with systemID: {0}; bpID: {1}", systemID, bpID);
            int ret = 0;
            bool presentOvernight = false;

            // Zutrittskontrollsystem
            Master_AccessSystems accessSystem = entities.Master_AccessSystems.FirstOrDefault(s => s.SystemID == systemID && s.BpID == bpID);
            if (accessSystem != null)
            {
                // Alle Buchungen, 
                // die noch nicht verbunden sind 
                // und vom Zutrittskontrollsystem kommen 
                // und deren Zutrittsergebnis positiv ist
                // und deren Zutrittsbereich die Korrektur von Zutrittsergeignissen vorsieht
                IQueryable<Data_AccessEvents> accessEventsResult =
                    entities.Data_AccessEvents.Where(
                        a => a.SystemID == systemID &&
                             a.BpID == bpID &&
                             a.AccessEventLinkedID == null &&
                             a.AccessResult == 1 &&
                             entities.Master_AccessAreas.Any(
                                 aa => aa.SystemID == a.SystemID &&
                                       aa.BpID == a.BpID &&
                                       aa.AccessAreaID == a.AccessAreaID &&
                                       aa.CheckInCompelling &&
                                       aa.CheckOutCompelling &&
                                       aa.CompleteAccessTimes &&
                                       (aa.PresentTimeHours != "0" || aa.PresentTimeMinutes != "0"))).OrderBy(
                        a => a.InternalID.ToUpper()).ThenBy(
                        a => a.AccessAreaID).ThenBy(
                        a => a.AccessOn).ThenByDescending(
                        a => a.AccessType);

                Data_AccessEvents[] accessEvents = accessEventsResult.ToArray();
                if (accessEvents.Count() > 0)
                {
                    logger.DebugFormat("{0} accessEvents events found", accessEvents.Count().ToString());
                    Data_AccessEvents firstEvent = null;
                    Data_AccessEvents secondEvent = null;
                    int count = accessEvents.Count();
                    bool hasSecondEvent = false;
                    bool exitEventBeforeMidnight = false;
                    bool keepFirstEvent = false;

                    for (int i = 0; i < count; i++)
                    {
                        // Ersten Satz lesen
                        if (!keepFirstEvent)
                        {
                            firstEvent = accessEvents[i];
                        }
                        else
                        {
                            keepFirstEvent = false;
                        }

                        double maxPresenceMinutes = 18.0 * 60.0;
                        Master_AccessAreas accessArea = entities.Master_AccessAreas.FirstOrDefault(aa => aa.SystemID == firstEvent.SystemID && aa.BpID == firstEvent.BpID && aa.AccessAreaID == firstEvent.AccessAreaID);
                        if (accessArea != null)
                        {
                            maxPresenceMinutes = (Convert.ToDouble(accessArea.PresentTimeHours) * 60.0 + Convert.ToDouble(accessArea.PresentTimeMinutes));
                        }

                        if (i < count - 1)
                        {
                            // Zweiten Satz lesen
                            secondEvent = accessEvents[i + 1];
                            hasSecondEvent = true;

                            //// Link des zweiten Satzes auf sich selbst, wenn Kommt-Buchung
                            //if (secondEvent.AccessType == AccessTypes.TypeEnter)
                            //{
                            //    secondEvent.AccessEventLinkedID = secondEvent.AccessEventID;
                            //}
                        }
                        else
                        {
                            // Kein zweiter Satz vorhanden
                            if (firstEvent.AccessType == AccessTypes.TypeEnter)
                            {
                                // Erster Satz ist Kommt-Buchung und kein weiterer Satz vorhanden => Geht-Buchung erzeugen, wenn maximale Anwesenheitszeit überschritten
                                hasSecondEvent = false;

                                // Wenn erster Satz Kommt-Buchung von Tagesabgrenzung, dann vorherige Kommt-Buchung holen
                                // Maximale Anwesenheitszeit muss Kommt-Buchung aus Tagesabgrenzung ignorieren
                                Data_AccessEvents previousEnterEvent = firstEvent;
                                if (firstEvent.IsManualEntry && firstEvent.AddedBySystem && ((DateTime)firstEvent.AccessOn) == (DateTime)((DateTime)firstEvent.AccessOn).Date)
                                {
                                    previousEnterEvent = GetPreviousEvent(GetPreviousEvent(firstEvent));
                                    if (previousEnterEvent != null)
                                    {
                                        presentOvernight = true;
                                    }
                                }


                                if (previousEnterEvent.AccessOn < DateTime.Now.AddMinutes(maxPresenceMinutes * (-1.0)))
                                {

                                    DateTime accessTime = ((DateTime)previousEnterEvent.AccessOn).AddMinutes(maxPresenceMinutes);

                                    // Geht-Buchung 1 Sekunde früher als nächste Kommt-Buchung setzen
                                    Data_AccessEvents followingEvent = GetFollowingEvent(previousEnterEvent);
                                    if (followingEvent != null && followingEvent.AccessType == AccessTypes.TypeEnter && accessTime > followingEvent.AccessOn)
                                    {
                                        accessTime = ((DateTime) followingEvent.AccessOn).AddSeconds(-1);
                                    }

                                    // Geht-Buchung erzeugen und anfügen
                                    secondEvent = CopyAccessEvent(previousEnterEvent, accessTime, AccessTypes.TypeExit, true, true, true, presentOvernight);
                                    presentOvernight = false;

                                    if (!EventExists(secondEvent) && ((followingEvent != null && followingEvent.AccessType == AccessTypes.TypeEnter) || followingEvent == null))
                                    {
                                        logger.DebugFormat("Create exit event - InternalID: {0}; AccessOn: {1}; for enter event - AccessEventID: {2}; BpID: {3}", secondEvent.InternalID, secondEvent.AccessOn, firstEvent.AccessEventID, secondEvent.BpID);
                                        entities.Data_AccessEvents.Add(secondEvent);
                                        if (!EntitySaveChanges(false))
                                        {
                                            logger.Debug("Error on entities.Data_AccessEvents.Add(secondEvent)");
                                        }

                                        // Bei Mitarbeiterausweisen Anwesenheitssatz erzeugen
                                        if (previousEnterEvent.PassType == 1)
                                        {
                                            CreatePresenceEvent(firstEvent, secondEvent);
                                        }

                                        firstEvent.AccessEventLinkedID = firstEvent.AccessEventID; //TODO Warum zeigt der Erste auf sich selbst?
                                        secondEvent.AccessEventLinkedID = firstEvent.AccessEventID;
                                        if (!EntitySaveChanges(false))
                                        {
                                            logger.Debug("Error on secondEvent.AccessEventLinkedID = firstEvent.AccessEventID");
                                        }
                                    }

                                    // Wenn Tageswechsel dazwischen, dann Tagesabgrenzung erzeugen
                                    if (accessTime > ((DateTime) firstEvent.AccessOn).Date.AddHours(23).AddMinutes(59).AddSeconds(59) && AccessStateOnMidnight(firstEvent) == AccessTypes.TypeEnter)
                                    {
                                        CreateDayDemarcation(firstEvent, 1);
                                        exitEventBeforeMidnight = false;
                                    }
                                    else
                                    {
                                        exitEventBeforeMidnight = true;
                                    }
                                }
                                else
                                {
                                    presentOvernight = false;
                                }
                            }
                            else
                            {
                                // Erster Satz ist Geht-Buchung => Kommt-Buchung erzeugen und Sätze tauschen
                                DateTime accessTime = ((DateTime) firstEvent.AccessOn).AddMinutes(maxPresenceMinutes * (-1.0));

                                // Nicht über die Tagesgrenze zurück, da Verdichtung schon gelaufen
                                if (accessTime < ((DateTime) firstEvent.AccessOn).Date)
                                {
                                    accessTime = ((DateTime) firstEvent.AccessOn).Date;
                                }

                                // Kommt-Buchung 1 Sekunde später als vorherige Geht-Buchung zurück setzen
                                Data_AccessEvents previousEvent = GetPreviousEvent(firstEvent);
                                if (previousEvent != null && previousEvent.AccessType == AccessTypes.TypeExit && accessTime < previousEvent.AccessOn)
                                {
                                    accessTime = ((DateTime) previousEvent.AccessOn).AddSeconds(1);
                                }

                                // Kommt-Buchung erzeugen und anfügen
                                Data_AccessEvents accessEvent = CopyAccessEvent(firstEvent, accessTime, AccessTypes.TypeEnter, true, true, false, false);

                                // Prüfung auf vorhergehende Kommt-Buchung vor dem Anfügen
                                previousEvent = GetPreviousEvent(firstEvent);
                                if (!EventExists(accessEvent) && ((previousEvent != null && previousEvent.AccessType == AccessTypes.TypeExit) || previousEvent == null))
                                {
                                    logger.DebugFormat("(1) Create enter event - InternalID: {0}; AccessOn: {1}; for exit event - AccessEventID: {2}; BpID: {3}", accessEvent.InternalID, accessEvent.AccessOn, firstEvent.AccessEventID, accessEvent.BpID);
                                    entities.Data_AccessEvents.Add(accessEvent);
                                    if (!EntitySaveChanges(false))
                                    {
                                        logger.Debug("Error on entities.Data_AccessEvents.Add(accessEvent)");
                                    }

                                    // Sätze tauschen
                                    secondEvent = firstEvent;
                                    firstEvent = accessEvent;

                                    hasSecondEvent = true;
                                }
                            }
                        }

                        if (hasSecondEvent)
                        {
                            // Erster Satz ist Kommt-Buchung und zweiter Satz ist Geht-Buchung und Sätze gehören zusammen
                            if (firstEvent.InternalID.ToUpper() == secondEvent.InternalID.ToUpper() &&
                                firstEvent.AccessAreaID == secondEvent.AccessAreaID &&
                                firstEvent.AccessType == AccessTypes.TypeEnter &&
                                secondEvent.AccessType == AccessTypes.TypeExit)
                            {
                                // Bei Mitarbeiterausweisen Anwesenheitssatz erzeugen
                                if (firstEvent.PassType == 1)
                                {
                                    CreatePresenceEvent(firstEvent, secondEvent);
                                }

                                // Sätze verbinden => ID der Kommt-Buchung als LinkID eintragen
                                firstEvent.AccessEventLinkedID = firstEvent.AccessEventID;
                                secondEvent.AccessEventLinkedID = firstEvent.AccessEventID;
                                if (!EntitySaveChanges(false))
                                {
                                    logger.Debug("Error on secondEvent.AccessEventLinkedID = firstEvent.AccessEventID");
                                }

                                // Einen Satz weiter
                                i++;
                            }
                            else
                            {
                                // Erster Satz ist Kommt-Buchung, aber Sätze gehören nicht zusammen
                                if (firstEvent.AccessType == AccessTypes.TypeEnter)
                                {
                                    // Wenn erster Satz Kommt-Buchung von Tagesabgrenzung, dann vorherige Kommt-Buchung holen
                                    // Maximale Anwesenheitszeit muss Kommt-Buchung aus Tagesabgrenzung ignorieren
                                    Data_AccessEvents previousEnterEvent = firstEvent;
                                    if (firstEvent.IsManualEntry && firstEvent.AddedBySystem && ((DateTime)firstEvent.AccessOn) == (DateTime)((DateTime)firstEvent.AccessOn).Date)
                                    {
                                        previousEnterEvent = GetPreviousEvent(GetPreviousEvent(firstEvent));
                                        if (previousEnterEvent != null)
                                        {
                                            presentOvernight = true;
                                        }
                                    }

                                    if (previousEnterEvent.AccessOn < DateTime.Now.AddMinutes(maxPresenceMinutes * (-1.0)))
                                    {

                                        DateTime accessTime = ((DateTime)previousEnterEvent.AccessOn).AddMinutes(maxPresenceMinutes);

                                        // Geht-Buchung 1 Sekunde früher als nächste Kommt-Buchung setzen
                                        Data_AccessEvents followingEvent = GetFollowingEvent(previousEnterEvent);
                                        if (followingEvent != null && followingEvent.AccessType == AccessTypes.TypeEnter && accessTime > followingEvent.AccessOn)
                                        {
                                            accessTime = ((DateTime)followingEvent.AccessOn).AddSeconds(-1);
                                        }

                                        // Geht-Buchung erzeugen und anfügen
                                        secondEvent = CopyAccessEvent(previousEnterEvent, accessTime, AccessTypes.TypeExit, true, true, true, presentOvernight);
                                        presentOvernight = false;

                                        if (!EventExists(secondEvent) && ((followingEvent != null && followingEvent.AccessType == AccessTypes.TypeEnter) || followingEvent == null))
                                        {
                                            logger.DebugFormat("Create exit event - InternalID: {0}; AccessOn: {1}; for enter event - AccessEventID: {2}; BpID: {3}", secondEvent.InternalID, secondEvent.AccessOn, firstEvent.AccessEventID, secondEvent.BpID);
                                            entities.Data_AccessEvents.Add(secondEvent);
                                            if (!EntitySaveChanges(false))
                                            {
                                                logger.Debug("Error on entities.Data_AccessEvents.Add(secondEvent)");
                                            }

                                            // Bei Mitarbeiterausweisen Anwesenheitssatz erzeugen
                                            if (firstEvent.PassType == 1)
                                            {
                                                CreatePresenceEvent(firstEvent, secondEvent);
                                            }

                                            firstEvent.AccessEventLinkedID = firstEvent.AccessEventID;
                                            secondEvent.AccessEventLinkedID = firstEvent.AccessEventID;
                                            if (!EntitySaveChanges(false))
                                            {
                                                logger.Debug("Error on secondEvent.AccessEventLinkedID = firstEvent.AccessEventID");
                                            }
                                        }

                                        // Wenn Tageswechsel dazwischen, dann Tagesabgrenzung erzeugen
                                        if (accessTime > ((DateTime) firstEvent.AccessOn).Date.AddHours(23).AddMinutes(59).AddSeconds(59) && AccessStateOnMidnight(firstEvent) == AccessTypes.TypeEnter)
                                        {
                                            CreateDayDemarcation(firstEvent, 1);
                                            exitEventBeforeMidnight = false;
                                        }
                                        else
                                        {
                                            exitEventBeforeMidnight = true;
                                        }
                                    }
                                    else
                                    {
                                        presentOvernight = false;

                                        // Maximale Anwesenheitszeit nicht überschritten => Satz ignorieren
                                        // Wenn vor Tageswechsel, dann Tagesabgrenzung erzeugen
                                        if ((DateTime) firstEvent.AccessOn < DateTime.Now.Date.AddSeconds(-1) && AccessStateOnMidnight(firstEvent) == AccessTypes.TypeEnter)
                                        {
                                            CreateDayDemarcation(firstEvent, 1);
                                        }
                                    }
                                }
                                // Erster Satz ist Geht-Buchung und Sätze gehören nicht zusammen => Kommt-Buchung erzeugen
                                else
                                {
                                    DateTime accessTime = ((DateTime) firstEvent.AccessOn).AddMinutes(maxPresenceMinutes * (-1.0));

                                    // Nicht über die Tagesgrenze zurück, da Verdichtung schon gelaufen
                                    if (accessTime < ((DateTime) firstEvent.AccessOn).Date)
                                    {
                                        accessTime = ((DateTime) firstEvent.AccessOn).Date;
                                    }

                                    // Kommt-Buchung 1 Sekunde später als vorherige Geht-Buchung setzen
                                    Data_AccessEvents previousEvent = GetPreviousEvent(firstEvent);
                                    if (previousEvent != null && previousEvent.AccessType == AccessTypes.TypeExit && accessTime < previousEvent.AccessOn)
                                    {
                                        accessTime = ((DateTime) previousEvent.AccessOn).AddSeconds(1);
                                    }

                                    // Kommt-Buchung erzeugen und anfügen
                                    Data_AccessEvents accessEvent = CopyAccessEvent(firstEvent, accessTime, AccessTypes.TypeEnter, true, true, false, false);

                                    // Prüfung auf vorhergehende Kommt-Buchung vor dem Anfügen
                                    previousEvent = GetPreviousEvent(firstEvent);
                                    if (!EventExists(accessEvent) && ((previousEvent != null && previousEvent.AccessType == AccessTypes.TypeExit) || previousEvent == null))
                                    {
                                        logger.DebugFormat("(2) Create enter event - InternalID: {0}; AccessOn: {1}; for exit event - AccessEventID: {2}; BpID: {3}", accessEvent.InternalID, accessEvent.AccessOn, firstEvent.AccessEventID, accessEvent.BpID);
                                        entities.Data_AccessEvents.Add(accessEvent);
                                        if (!EntitySaveChanges(false))
                                        {
                                            logger.Debug("Error on entities.Data_AccessEvents.Add(accessEvent)");
                                        }

                                        // Buchungen drehen und verbinden
                                        secondEvent = firstEvent;
                                        firstEvent = accessEvent;

                                        // Bei Mitarbeiterausweisen Anwesenheitssatz erzeugen
                                        if (firstEvent.PassType == 1)
                                        {
                                            CreatePresenceEvent(firstEvent, secondEvent);
                                        }

                                        firstEvent.AccessEventLinkedID = firstEvent.AccessEventID;
                                        secondEvent.AccessEventLinkedID = firstEvent.AccessEventID;
                                        if (!EntitySaveChanges(false))
                                        {
                                            logger.Debug("Error on secondEvent.AccessEventLinkedID = firstEvent.AccessEventID");
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            // Kein zweiter Satz vorhanden => Nichts machen
                            // Wenn vor Tageswechsel und Kommt-Buchung, dann Tagesabgrenzung erzeugen
                            if ((DateTime) firstEvent.AccessOn < DateTime.Now.Date.AddSeconds(-1) && firstEvent.AccessType == AccessTypes.TypeEnter && !exitEventBeforeMidnight)
                            {
                                CreateDayDemarcation(firstEvent, 1);
                            }
                        }

                        hasSecondEvent = false;
                        exitEventBeforeMidnight = false;
                    }

                    accessSystem.LastAddition = DateTime.Now;
                    if (!EntitySaveChanges(false))
                    {
                        logger.Debug("Error on accessSystem.LastAddition = DateTime.Now");
                    }
                }
            }

            return ret;
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

        /// <summary>
        /// Anwesenheitssatz erzeugen
        /// </summary>
        /// <param name="enterEvent"></param>
        /// <param name="exitEvent"></param>
        /// <returns></returns>
        private bool CreatePresenceEvent(Data_AccessEvents enterEvent, Data_AccessEvents exitEvent)
        {
            bool ret = false;

            // Bei Mitarbeiterausweisen Anwesenheitssatz erzeugen
            if (enterEvent.PassType == 1)
            {
                Master_Employees employee = entities.Master_Employees.FirstOrDefault(e => e.SystemID == enterEvent.SystemID && e.BpID == enterEvent.BpID && e.EmployeeID == enterEvent.OwnerID);
                if (employee != null)
                {
                    Data_PresenceAccessEvents presenceEvent = new Data_PresenceAccessEvents();

                    presenceEvent.SystemID = enterEvent.SystemID;
                    presenceEvent.BpID = enterEvent.BpID;
                    presenceEvent.CompanyID = employee.CompanyID;
                    presenceEvent.TradeID = employee.TradeID;
                    presenceEvent.PresenceDay = ((DateTime) enterEvent.AccessOn).Date;
                    presenceEvent.EmployeeID = enterEvent.OwnerID;
                    presenceEvent.AccessAt = (DateTime) enterEvent.AccessOn;
                    presenceEvent.ExitAt = exitEvent.AccessOn;
                    TimeSpan presenceDuration = (DateTime) presenceEvent.ExitAt - presenceEvent.AccessAt;
                    presenceEvent.PresenceSeconds = Convert.ToInt64(presenceDuration.TotalSeconds);
                    presenceEvent.AccessAreaID = enterEvent.AccessAreaID;
                    presenceEvent.TimeSlotID = 0;
                    presenceEvent.AccessTimeManual = enterEvent.IsManualEntry || enterEvent.AddedBySystem;
                    presenceEvent.ExitTimeManual = exitEvent.IsManualEntry || exitEvent.AddedBySystem;
                    if (enterEvent.CountIt && exitEvent.CountIt)
                    {
                        presenceEvent.CountAs = 1;
                    }
                    else
                    {
                        presenceEvent.CountAs = 0;
                    }

                    // logger.DebugFormat("Try to insert into Data_PresenceAccessEvents - SystemID: {0}; BpID: {1}; CompanyID: {2}; TradeID: {3}; PresenceDay: {4}; EmployeeID: {5}; AccessAt: {6}",
                    //    presenceEvent.SystemID, presenceEvent.BpID, presenceEvent.CompanyID, presenceEvent.TradeID, presenceEvent.PresenceDay, presenceEvent.EmployeeID, presenceEvent.AccessAt);

                    // Ggf. bestehenden Satz löschen
                    Data_PresenceAccessEvents existingPresenceEvent =
                        entities.Data_PresenceAccessEvents.FirstOrDefault(
                            p => p.SystemID == enterEvent.SystemID &&
                                 p.BpID == enterEvent.BpID &&
                                 p.CompanyID == employee.CompanyID &&
                                 p.TradeID == employee.TradeID &&
                                 p.PresenceDay == ((DateTime) enterEvent.AccessOn).Date &&
                                 p.EmployeeID == employee.EmployeeID &&
                                 p.AccessAt == (DateTime) enterEvent.AccessOn);

                    if (existingPresenceEvent != null)
                    {
                        // logger.DebugFormat("Existing presence event found - EmployeeID: {0}; AccessAreaID: {1}; AccessAt: {2}; ExitAt: {3}; BpID: {4}", existingPresenceEvent.EmployeeID, existingPresenceEvent.AccessAreaID, existingPresenceEvent.AccessAt, existingPresenceEvent.ExitAt, existingPresenceEvent.BpID);
                        entities.Data_PresenceAccessEvents.Remove(existingPresenceEvent);
                        ret = EntitySaveChanges(false);
                        // logger.DebugFormat("Existing presence event successfully deleted: {0}", ret);
                    }

                    entities.Data_PresenceAccessEvents.Add(presenceEvent);

                    ret = EntitySaveChanges(false);
                }
            }

            return ret;
        }

        /// <summary>
        /// Kopie des Zutrittsereignisses erzeugen
        /// </summary>
        /// <param name="copyFrom"></param>
        /// <param name="accessTime"></param>
        /// <param name="accessType"></param>
        /// <param name="countIt"></param>
        /// <returns></returns>
        private Data_AccessEvents CopyAccessEvent(Data_AccessEvents copyFrom, DateTime accessTime, int accessType, bool countIt, bool isCorrection, bool maxPresentTimeExceeded, bool presentOvernight)
        {
            Data_AccessEvents accessEvent = new Data_AccessEvents();

            accessEvent.SystemID = copyFrom.SystemID;
            accessEvent.BfID = copyFrom.BfID;
            accessEvent.BpID = copyFrom.BpID;
            accessEvent.AccessAreaID = copyFrom.AccessAreaID;
            accessEvent.EntryID = copyFrom.EntryID;
            accessEvent.PoeID = copyFrom.PoeID;
            accessEvent.OwnerID = copyFrom.OwnerID;
            accessEvent.InternalID = copyFrom.InternalID;
            accessEvent.IsOnlineAccessEvent = false;
            accessEvent.AccessOn = accessTime;
            accessEvent.AccessType = accessType;
            accessEvent.AccessResult = 1;
            accessEvent.MessageShown = false;
            accessEvent.DenialReason = 0;
            accessEvent.IsManualEntry = true;
            accessEvent.AddedBySystem = true;
            accessEvent.CountIt = countIt;
            if (accessType == AccessTypes.TypeEnter)
            {
                accessEvent.Remark = "Added due to missing enter event";
            }
            else
            {
                accessEvent.Remark = "Added due to missing exit event";
            }
            accessEvent.PassType = copyFrom.PassType;
            accessEvent.CreatedOn = DateTime.Now;
            accessEvent.CreatedFrom = "CopyAccessEvent";
            accessEvent.EditOn = DateTime.Now;
            accessEvent.EditFrom = "CopyAccessEvent";
            if (isCorrection)
            {
                accessEvent.CorrectedOn = DateTime.Now;
            }
            accessEvent.MaxPresentTimeExc = maxPresentTimeExceeded;
            accessEvent.PresentOvernight = presentOvernight;

            return accessEvent;
        }

        /// <summary>
        /// Tagesabgrenzung erzeugen
        /// </summary>
        /// <param name="copyFrom"></param>
        /// <param name="addDays"></param>
        /// <returns></returns>
        private bool CreateDayDemarcation(Data_AccessEvents copyFrom, int addDays)
        {
            bool ret = false;
            DateTime demarcationTime = ((DateTime) copyFrom.AccessOn).Date.AddDays(addDays);
            Data_AccessEvents entryEvent = CopyAccessEvent(copyFrom, demarcationTime, AccessTypes.TypeEnter, false, false, false, false);
            if (!EventExists(entryEvent))
            {
                entryEvent.Remark = "Added by System";
                entryEvent.AccessEventLinkedID = null;
                entities.Data_AccessEvents.Add(entryEvent);
                ret = EntitySaveChanges(false);
                logger.DebugFormat("Created day demarcation enter event - AccessEventID: {0}; BpID: {1}", entryEvent.AccessEventID, entryEvent.BpID);
            }
            else
            {
                logger.DebugFormat("Day demarcation enter event already exists - AccessEventID: {0}; demarcationTime: {1}; BpID: {2}", copyFrom.AccessEventID, demarcationTime.ToString("G"), copyFrom.BpID);
            }

            Data_AccessEvents exitEvent = CopyAccessEvent(copyFrom, demarcationTime.AddSeconds(-1), AccessTypes.TypeExit, true, false, false, false);
            if (!EventExists(exitEvent))
            {
                exitEvent.Remark = "Added by System";
                exitEvent.AccessEventLinkedID = copyFrom.AccessEventID;
                entities.Data_AccessEvents.Add(exitEvent);
                ret &= EntitySaveChanges(false);
                logger.DebugFormat("Created day demarcation exit event - AccessEventID: {0}; BpID: {1}", exitEvent.AccessEventID, entryEvent.BpID);
            }
            else
            {
                logger.DebugFormat("Day demarcation exit event already exists - AccessEventID: {0}; demarcationTime: {1}; BpID: {2}", copyFrom.AccessEventID, demarcationTime.AddSeconds(-1).ToString("G"), copyFrom.BpID);
            }

            return ret;
        }

        /// <summary>
        /// Prüfung, ob Zutrittsereignis bereits existiert
        /// </summary>
        /// <param name="compareEvent"></param>
        /// <returns></returns>
        private bool EventExists(Data_AccessEvents compareEvent)
        {
            Data_AccessEvents accessEvent =
                entities.Data_AccessEvents.Where(
                    a => a.SystemID == compareEvent.SystemID &&
                         a.BpID == compareEvent.BpID &&
                         a.AccessAreaID == compareEvent.AccessAreaID &&
                         a.AccessResult == 1 &&
                         a.AccessType == compareEvent.AccessType &&
                         a.InternalID.ToUpper() == compareEvent.InternalID.ToUpper() &&
                         a.PassType == compareEvent.PassType &&
                         a.AccessOn == compareEvent.AccessOn).OrderBy(a => a.AccessOn).FirstOrDefault();
            return (accessEvent != null);
        }

        /// <summary>
        /// Direkt folgendes Zutrittsereignis suchen
        /// </summary>
        /// <param name="compareEvent"></param>
        /// <returns></returns>
        private Data_AccessEvents GetFollowingEvent(Data_AccessEvents compareEvent)
        {
            Data_AccessEvents accessEvent =
                entities.Data_AccessEvents.Where(
                    a => a.SystemID == compareEvent.SystemID &&
                         a.BpID == compareEvent.BpID &&
                         a.AccessAreaID == compareEvent.AccessAreaID &&
                         a.AccessResult == 1 &&
                         a.InternalID.ToUpper() == compareEvent.InternalID.ToUpper() &&
                         a.PassType == compareEvent.PassType &&
                         a.AccessOn > compareEvent.AccessOn).OrderBy(a => a.AccessOn).FirstOrDefault();

            return accessEvent;
        }

        /// <summary>
        /// Direkt zurückliegendes Zutrittsereignis suchen
        /// </summary>
        /// <param name="compareEvent"></param>
        /// <returns></returns>
        private Data_AccessEvents GetPreviousEvent(Data_AccessEvents compareEvent)
        {
            Data_AccessEvents accessEvent =
                entities.Data_AccessEvents.Where(
                    a => a.SystemID == compareEvent.SystemID &&
                         a.BpID == compareEvent.BpID &&
                         a.AccessAreaID == compareEvent.AccessAreaID &&
                         a.AccessResult == 1 &&
                         a.InternalID.ToUpper() == compareEvent.InternalID.ToUpper() &&
                         a.PassType == compareEvent.PassType &&
                         a.AccessOn < compareEvent.AccessOn).OrderByDescending(a => a.AccessOn).FirstOrDefault();

            return accessEvent;
        }

        /// <summary>
        /// Zutrittszustand des Ausweises um Mitternacht (Anwesend / Abwesend)
        /// </summary>
        /// <param name="compareEvent"></param>
        /// <returns></returns>
        private int AccessStateOnMidnight(Data_AccessEvents compareEvent)
        {
            int accessState = compareEvent.AccessType;
            DateTime endOfDay = ((DateTime) compareEvent.AccessOn).Date.AddHours(23).AddMinutes(59).AddSeconds(59);
            Data_AccessEvents accessEvent =
                entities.Data_AccessEvents.Where(
                    a => a.SystemID == compareEvent.SystemID &&
                         a.BpID == compareEvent.BpID &&
                         a.AccessAreaID == compareEvent.AccessAreaID &&
                         a.AccessResult == 1 &&
                         a.InternalID.ToUpper() == compareEvent.InternalID.ToUpper() &&
                         a.PassType == compareEvent.PassType &&
                         a.AccessOn > compareEvent.AccessOn &&
                         a.AccessOn <= endOfDay).OrderByDescending(a => a.AccessOn).FirstOrDefault();

            if (accessEvent != null)
            {
                accessState = accessEvent.AccessType;
            }

            return accessState;
        }

        public int AccessDataErrors(int systemID, int bpID)
        {
            logger.InfoFormat("Enter AccessDataErrors with systemID: {0}; bpID: {1}", systemID, bpID);
            int ret = 0;

            // Zutrittskontrollsystem
            Master_AccessSystems accessSystem = entities.Master_AccessSystems.FirstOrDefault(s => s.SystemID == systemID && s.BpID == bpID);
            if (accessSystem != null)
            {
                DateTime lookBackTo = DateTime.Now.AddDays(-3).Date;
                logger.DebugFormat("Lookback to: {0}", lookBackTo.ToString());

                // Alle Buchungen, 
                // die zwei Tage zurück liegen 
                // und vom Zutrittskontrollsystem kommen 
                // und deren Zutrittsergebnis positiv ist
                IQueryable<Data_AccessEvents> accessEventsResult =
                    entities.Data_AccessEvents.Where(
                        a => a.SystemID == systemID &&
                             a.BpID == bpID &&
                             //a.AccessEventLinkedID == null &&
                             a.IsManualEntry == false &&
                             a.AddedBySystem == false &&
                             a.AccessResult == 1 &&
                             a.AccessOn >= lookBackTo).OrderBy(
                        a => a.InternalID.ToUpper()).ThenBy(
                        a => a.AccessAreaID).ThenBy(
                        a => a.AccessOn).ThenByDescending(
                        a => a.AccessType).ThenBy(
                        a => a.AccessEventID);

                Data_AccessEvents[] accessEvents = accessEventsResult.ToArray();
                if (accessEvents.Count() > 0)
                {
                    logger.DebugFormat("{0} accessEvents events found", accessEvents.Count().ToString());
                    Data_AccessEvents firstEvent = null;
                    Data_AccessEvents secondEvent = null;
                    int count = accessEvents.Count();
                    bool hasSecondEvent = false;
                    bool keepFirstEvent = false;

                    for (int i = 0; i < count; i++)
                    {
                        // Ersten Satz lesen
                        if (!keepFirstEvent)
                        {
                            firstEvent = accessEvents[i];
                            // logger.DebugFormat("First event: {0}", firstEvent.AccessEventID);
                        }
                        keepFirstEvent = false;

                        if (i < count - 1)
                        {
                            // Zweiten Satz lesen
                            secondEvent = accessEvents[i + 1];
                            // logger.DebugFormat("Second event: {0}", secondEvent.AccessEventID);
                            hasSecondEvent = true;
                        }

                        if (hasSecondEvent)
                        {
                            // Erster Satz ist Kommt-Buchung und zweiter Satz ist Geht-Buchung und Sätze gehören zusammen
                            if (firstEvent.InternalID.ToUpper() == secondEvent.InternalID.ToUpper() &&
                                firstEvent.AccessAreaID == secondEvent.AccessAreaID &&
                                firstEvent.AccessType == AccessTypes.TypeEnter &&
                                secondEvent.AccessType == AccessTypes.TypeExit)
                            {
                                // Einen Satz weiter
                                // i++;
                            }
                            // Behandlung des Duplikatfehlers bei Aditus (hundertfach identische Buchungen)
                            // Zweiter Satz ist Duplikat von erstem Satz => Zweiten Satz ungültig machen 
                            else if (firstEvent.InternalID.ToUpper() == secondEvent.InternalID.ToUpper() &&
                                     firstEvent.AccessAreaID == secondEvent.AccessAreaID &&
                                     firstEvent.AccessType == secondEvent.AccessType &&
                                     firstEvent.AccessOn == secondEvent.AccessOn &&
                                     (secondEvent.AccessEventLinkedID == 0 || secondEvent.AccessEventLinkedID == null))
                            {
                                //entities.Data_AccessEvents.Remove(secondEvent);
                                logger.DebugFormat("Invalidating second event due to identical duplicate of AccessEventID: {2} - AccessEventID: {0}; BpID: {1}", secondEvent.AccessEventID, secondEvent.BpID, firstEvent.AccessEventID);
                                secondEvent.Remark = string.Format("Invalidating second event due to identical duplicate of AccessEventID: {2} - AccessEventID: {0}; BpID: {1}", secondEvent.AccessEventID, secondEvent.BpID, firstEvent.AccessEventID);
                                secondEvent.EditOn = DateTime.Now;
                                secondEvent.EditFrom = "AccessDataErrors";
                                secondEvent.AccessResult = 0;
                                secondEvent.CountIt = false;
                                secondEvent.AccessEventLinkedID = null;
                                secondEvent.CorrectedOn = DateTime.Now;
                                if (!EntitySaveChanges(false))
                                {
                                    logger.Debug("Error on invalidating secondEvent");
                                }
                                keepFirstEvent = true;
                                hasSecondEvent = false;
                            }
                            // Behandlung von zwei aufeinanderfolgenden Buchungen mit gleicher Richtung, wobei eine Buchung offline ist => Offline-Buchung ungültig machen
                            else if (firstEvent.InternalID.ToUpper() == secondEvent.InternalID.ToUpper() &&
                                     firstEvent.AccessAreaID == secondEvent.AccessAreaID &&
                                     firstEvent.AccessType == secondEvent.AccessType &&
                                     firstEvent.AccessOn < secondEvent.AccessOn)
                            {
                                Data_AccessEvents followingEvent = GetFollowingEvent(firstEvent);
                                if (firstEvent.IsOnlineAccessEvent && secondEvent.AccessEventID == followingEvent.AccessEventID &&
                                     (secondEvent.AccessEventLinkedID == 0 || secondEvent.AccessEventLinkedID == null))
                                {
                                    logger.DebugFormat("Invalidating second event due to duplicate of AccessEventID: {2} - AccessEventID: {0}; BpID: {1}", secondEvent.AccessEventID, secondEvent.BpID, firstEvent.AccessEventID);
                                    secondEvent.Remark = string.Format("Invalidating second event due to direction duplicate of AccessEventID: {2} - AccessEventID: {0}; BpID: {1}", secondEvent.AccessEventID, secondEvent.BpID, firstEvent.AccessEventID);
                                    secondEvent.EditOn = DateTime.Now;
                                    secondEvent.EditFrom = "AccessDataErrors";
                                    secondEvent.AccessResult = 0;
                                    secondEvent.CountIt = false;
                                    secondEvent.AccessEventLinkedID = null;
                                    secondEvent.CorrectedOn = DateTime.Now;
                                    if (!EntitySaveChanges(false))
                                    {
                                        logger.Debug("Error on invalidating secondEvent");
                                    }

                                    keepFirstEvent = true;
                                }
                                else if (secondEvent.IsOnlineAccessEvent && secondEvent.AccessEventID == followingEvent.AccessEventID &&
                                     (firstEvent.AccessEventLinkedID == 0 || firstEvent.AccessEventLinkedID == null))
                                {
                                    logger.DebugFormat("Invalidating first event due to duplicate of AccessEventID: {2} - AccessEventID: {0}; BpID: {1}", firstEvent.AccessEventID, firstEvent.BpID, secondEvent.AccessEventID);
                                    firstEvent.Remark = string.Format("Invalidating first event due to direction duplicate of AccessEventID: {2} - AccessEventID: {0}; BpID: {1}", firstEvent.AccessEventID, firstEvent.BpID, secondEvent.AccessEventID);
                                    firstEvent.EditOn = DateTime.Now;
                                    firstEvent.EditFrom = "AccessDataErrors";
                                    firstEvent.AccessResult = 0;
                                    firstEvent.CountIt = false;
                                    firstEvent.AccessEventLinkedID = null;
                                    firstEvent.CorrectedOn = DateTime.Now;
                                    if (!EntitySaveChanges(false))
                                    {
                                        logger.Debug("Error on invalidating firstEvent");
                                    }
                                }

                                if (!firstEvent.IsOnlineAccessEvent && secondEvent.IsOnlineAccessEvent)
                                {
                                    firstEvent = accessEvents[i + 1];
                                }

                                hasSecondEvent = false;
                            }
                        }
                        else
                        {
                            // Kein zweiter Satz vorhanden => Nichts machen
                        }

                        hasSecondEvent = false;
                    }
                }
            }

            return ret;
        }
    }
}