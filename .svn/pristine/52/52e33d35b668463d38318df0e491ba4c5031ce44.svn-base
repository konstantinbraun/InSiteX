using log4net;
using System;
using System.Linq;

namespace InSite.App
{
    public static class Extensions
    {
        static readonly log4net.Core.Level authLevel = new log4net.Core.Level(50000, "DIALOG");

        public static void Dialog(this ILog log, string message)
        {
            log.Logger.Log(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType,
                authLevel, message, null);
        }

        public static void DialogFormat(this ILog log, string message, params object[] args)
        {
            string formattedMessage = string.Format(message, args);
            log.Logger.Log(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType,
                authLevel, formattedMessage, null);
        }
    }
}