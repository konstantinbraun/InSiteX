﻿using InSiteX.Entity;
using InSiteX.Repository.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InSiteX.Repository.Interfaces
{
    public interface IDeviceRepository: IGenericRepository<Device>
    {
       Device GetById(int Id);
    }
}
