using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
using InSiteX.Entity;
using InSiteX.Repository.Interfaces;

namespace InSiteX.Repository.Mocks
{
    public class DeviceRepositoryMock : IDeviceRepository
    {
        List<Device> devices = new List<Device>();

        public DeviceRepositoryMock(List<Device> _devices)
        {
            devices = _devices;
        }

        public async Task<Device> AddAsync(Device entity)
        {
            devices.Add(entity);
            return await Task.FromResult(entity);
        }

        public async Task<Device> DeleteAsync(Device entity)
        {
            devices.Remove(entity);
            return await Task.FromResult(entity);
        }

        public async Task EditAsync(Device entity)
        {
            await Task.Delay(12);

            Device device = devices.Where(x => x.Id == entity.Id).FirstOrDefault();
            if (device != null)
                device.Name = entity.Name;
            else
                throw new NotSupportedException();
        }

        public IEnumerable<Device> FindBy(Expression<Func<Device, bool>> predicate)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<Device>> GetAllAsync()
        {
            return await Task.FromResult(devices.AsEnumerable<Device>());
        }

        public Device GetById(int id)
        {
            return devices.Where(x => x.Id == id).FirstOrDefault();
        }

    }
}
