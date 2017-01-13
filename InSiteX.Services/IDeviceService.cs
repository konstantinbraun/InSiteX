using InSiteX.Entity;
using InSiteX.Services.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InSiteX.Services
{
    public interface IDeviceService: IEntityService<Device>
    {
        Device GetById(int id);
    }
}
