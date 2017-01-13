using System.Web;
using Telerik.Web.UI.PersistenceFramework;

namespace InSite.App
{
    public class SessionStorageProvider : IStateStorageProvider
    {
        private readonly System.Web.SessionState.HttpSessionState session = HttpContext.Current.Session;
        static string storageKey;

        public static string StorageProviderKey
        {
            set
            {
                storageKey = value;
            }
        }

        public void SaveStateToStorage(string key, string serializedState)
        {
            session[storageKey] = serializedState;
        }

        public string LoadStateFromStorage(string key)
        {
            return session[storageKey].ToString();
        }
    }
}