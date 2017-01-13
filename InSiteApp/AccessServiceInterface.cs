using InSite.App.AccessServices;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace InSite.App
{
    public class AccessServiceInterface : IDisposable
    {
        readonly AccessServiceClient client;

        public AccessServiceInterface()
        {
            client = new AccessServiceClient();
            try
            {
                client.Open();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        ~AccessServiceInterface()
        {
            Dispose(false);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (disposing)
            {
                client.Close();
            }
        }

        /// <summary>
        /// Beispiel einer Methode für die Abfrage der Zutrittsrechte
        /// </summary>
        public void GetAccessRights()
        {
            // Webservice Methode aufrufen und Ergebnis in lokales AccessRight Array speichern
            // Die Definition für AccessRight und AccessArea kommt über den Webservice
            AccessRight[] accessRights = null;
            try
            {
                accessRights = client.GetAccessRights(1, "myAuthID", true);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            // Array durchlaufen
            if (accessRights != null && accessRights.Count() > 0)
            {
                foreach (AccessRight accessRight in accessRights)
                {
                    // Beispiel Zugriff auf das AccessRight Objekt
                    string message = accessRight.Message;
                    // weitere Eigenschaften ...

                    // Abfrage der Zutrittsbereiche
                    AccessArea[] accessAreas = accessRight.AccessAreas;

                    // Array durchlaufen
                    if (accessAreas != null && accessAreas.Count() > 0)
                    {
                        foreach (AccessArea accessArea in accessAreas)
                        {
                            // Beispiel Zugriff auf das AccessArea Objekt
                            string validDays = accessArea.ValidDays;
                            // weitere Eigenschaften ...
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Beispiel einer Methode für die Übergabe der Kontrollergebnisse
        /// </summary>
        /// <param name="myAccessEvents">Kontrollergebnisse von Zutrittssytem</param>
        public void PutAccessEvent(DataTable myAccessEvents)
        {
            if (myAccessEvents.Rows.Count > 0)
            {
                // DataTable in AccessEvent Objekte umsetzen
                List<AccessEvent> accessEvents = new List<AccessEvent>();
                foreach (DataRow row in myAccessEvents.Rows)
                {
                    AccessEvent accessEvent = new AccessEvent();

                    accessEvent.AccessAreaID = Convert.ToInt32(row["myAccessAreaID"]);
                    accessEvent.EntryID = row["myEntryID"].ToString();
                    // weitere Felder ...

                    accessEvents.Add(accessEvent);
                }

                try
                {
                    // Webservice aufrufen und AccessEvent Objekte als Array übergeben
                    client.PutAccessEvent(1, "myAuthID", accessEvents.ToArray());
                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
        }
    }
}