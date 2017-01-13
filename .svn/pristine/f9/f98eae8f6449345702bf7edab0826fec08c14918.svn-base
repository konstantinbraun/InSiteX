using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using InSite.App.UserServices;

namespace InSite.App.BLL
{
    [DataObjectAttribute]
    public class dtoBuildingProject
    {
        [DataObjectMethodAttribute(DataObjectMethodType.Select, true)]
        public List<Master_BuildingProjects> GetData()
        {
            IUserService webService = new UserServices.UserServiceClient();
            return webService.GetAllBpsInfo(" ").ToList();
        }

        [DataObjectMethodAttribute(DataObjectMethodType.Select, false)]
        public Master_BuildingProjects GetById(int bpId)
        {
            IUserService webService = new UserServices.UserServiceClient();
            return webService.GetBpInfo(bpId, " ");
        }

    }
}