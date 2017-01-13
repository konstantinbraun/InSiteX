using log4net;
using System;
using System.Linq;

namespace InsiteServices
{
    public class InSiteException : Exception
    {
        private static readonly log4net.ILog logger = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

        public InSiteException() : base()
        {
            logger.Error("InSiteException occured!");
        }

        public InSiteException(string message) : base(message)
        {
            logger.ErrorFormat("InSiteException: {0}", message);
        }

        public InSiteException(string message, Exception innerException) : base(message, innerException)
        {
            logger.ErrorFormat("InSiteException: {0}", message);
            if (innerException != null)
            {
                logger.ErrorFormat("Inner exception: {0}", innerException);
            }
        }
    }
}