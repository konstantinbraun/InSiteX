using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using InSiteX.Entity;
using InSiteX.Repository.Common;
using InSiteX.Services.Common;
using InSiteX.Repository;
using InSiteX.Repository.Interfaces;

namespace InSiteX.Services
{
    public class DeviceService : EntityService<Device>, IDeviceService
    {
        IDeviceRepository _deviceRepository;
        public DeviceService(IUnitOfWork unitOfWork, IDeviceRepository deviceRepository) : 
            base(unitOfWork, deviceRepository)
        {
            _deviceRepository = deviceRepository;
        }

        public Device GetById(int id)
        {
            return _deviceRepository.GetById(id);
        }

    }
}
