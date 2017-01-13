using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;

namespace InSite.App.BLL
{
    [DataObjectAttribute]
    public class dtoAccessArea
    {
        [DataObjectMethodAttribute(DataObjectMethodType.Select, true)]
        public Dictionary<int, string>  GetData(int systemId, int bpId)
        {
            UserServices.IUserService webService = new UserServices.UserServiceClient();
            return webService.GetAccessAreas(systemId, bpId, "").ToDictionary(x=>x.AccessAreaID, y=>y.NameVisible);
        }
    }
}