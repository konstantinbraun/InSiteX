using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace InsiteServices.Constants
{
    public static class PassStatus
    {
        public const int Unknown = 0;
        public const int None = 1;
        public const int Printed = 2;
        public const int Activated = 3;
        public const int Deactivated = 4;
        public const int Locked = 5;
    }
}