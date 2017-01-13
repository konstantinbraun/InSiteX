using Resources;
using System;
using System.Linq;

namespace InSite.App.Constants
{
    public static class Status
    {
        public const int Deleted = -99;
        public const int Rejected = -20;
        public const int Invalid = -15;
        public const int Locked = -10;
        public const int Deactivated = -5;
        public const int Expired = -2;
        public const int Created = 0;
        public const int CreatedNotConfirmed = 5;
        public const int Printed = 7;
        public const int WaitExecute = 9;
        public const int WaitRelease = 10;
        public const int WaitReleaseCC = 15;
        public const int Overdue = 16;
        public const int Assigned = 17;
        public const int Released = 20;
        public const int Activated = 25;
        public const int ReleasedForCCWaitForBp = 35;
        public const int ReleasedForBp = 45;
        public const int Executing = 49;
        public const int Done = 50;

        public static string GetStatusString(int status)
        {
            string statusString="";

            switch(status)
            {
                case Deleted:
                    statusString = Resource.statDeleted;
                    break;

                case Rejected:
                    statusString = Resource.statRejected;
                    break;

                case Invalid:
                    statusString = Resource.statInvalid;
                    break;

                case Expired:
                    statusString = Resource.statExpired;
                    break;

                case Locked:
                    statusString = Resource.statLocked;
                    break;

                case Deactivated:
                    statusString = Resource.statDeactivated;
                    break;

                case Created:
                    statusString = Resource.statCreated;
                    break;

                case CreatedNotConfirmed:
                    statusString = Resource.statCreatedNotConfirmed;
                    break;

                case Printed:
                    statusString = Resource.statPrinted;
                    break;

                case WaitExecute:
                    statusString = Resource.statWaitExecute;
                    break;

                case WaitRelease:
                    statusString = Resource.statWaitRelease;
                    break;

                case WaitReleaseCC:
                    statusString = Resource.statWaitReleaseForCo;
                    break;

                case Assigned:
                    statusString = Resource.statAssigned;
                    break;

                case Released:
                    statusString = Resource.statReleased;
                    break;

                case Activated:
                    statusString = Resource.statActivated;
                    break;

                case ReleasedForCCWaitForBp:
                    statusString = Resource.statWaitReleaseForBp;
                    break;

                case ReleasedForBp:
                    statusString = Resource.statReleasedFor + " " + Resource.lblBuildingProject;
                    break;

                case Executing:
                    statusString = Resource.statExecuting;
                    break;

                case Done:
                    statusString = Resource.statDone;
                    break;

                default:
                    statusString = Resource.statNone;
                    break;
            }

            return statusString;
        }
    }
}