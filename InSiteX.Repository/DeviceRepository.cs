using System;
using InSiteX.Entity;
using InSiteX.Repository.Common;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using InSiteX.Repository.Interfaces;
using System.Threading.Tasks;

namespace InSiteX.Repository
{
    public class DeviceRepository : GenericRepository<Device>, IDeviceRepository
    {
        public DeviceRepository(DbContext context) : base(context)
        {
        }

        public Device GetById(int Id)
        {
            return FindBy(x => x.Id == Id).FirstOrDefault();
        }

        public async Task<Device> GetByIdAsync(int Id)
        {
            return await Task.FromResult(FindBy(x => x.Id == Id).First());
        }
    }
}
