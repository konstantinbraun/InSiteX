using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiteServices.Constants
{
    public static class SessionState
    {
        public const int SessionStart = 0;
        public const int SessionAuthenticated = 10;
        public const int SessionUsed = 20;
        public const int SessionEnd = 100;
    }
}