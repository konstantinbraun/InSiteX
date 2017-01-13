using InSiteX.Api.Controllers;
using InSiteX.Entity;
using InSiteX.Repository.Mocks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace InSiteX.Controller.Tests
{
    [TestClass]
    public class TestDeviceController
    {
        private List<Device> _devices;
 
        [TestInitialize]
        public void Init()
        {
            _devices = new List<Device>();

            for (int i = 0; i < 10; i++)
                _devices.Add(new Device() { Id = i, Name = string.Format("Device #{0}", i), Description = string.Format("Device #{0} description", i), DeviceType = DeviceType.Aditus });

        }

        [TestMethod]
        public async Task GetAllDevicesAsync_ShouldReturnAllDevices()
        {
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));

            var result = await controller.Get() as List<Device>;
            Assert.AreEqual(_devices.Count, result.Count);
        }

        [TestMethod]
        public async Task GetDevice_ShouldReturnCorrectDevice()
        {
            int i = 3;
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            OkObjectResult result = (OkObjectResult)await controller.Get(i);

            Assert.AreEqual(_devices[i].Name, ((Device)result.Value).Name);
        }

        [TestMethod]
        public async Task GetDevice_ShouldNotFindDevice()
        {
            int i = 32;
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            var result = await controller.Get(i);

            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod]
        public async Task AddDevice_ShouldReturnNewDevice()
        {
            int deviceCount = _devices.Count;
            deviceCount += 1;
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            CreatedAtRouteResult result = (CreatedAtRouteResult)await controller.Create(new Device { Name = "New device", Description ="New device", DeviceType =  DeviceType.Aditus });
            Device device = (Device)result.Value;

            Assert.IsNotNull(device);
            Assert.IsNotNull(device.Id);
            Assert.AreEqual(deviceCount,_devices.Count);
            Assert.AreEqual(device.Name , "New device");
        }

        [TestMethod]
        public async Task AddNullDevice_ShouldReturnBadRequest()
        {
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            var result = (await controller.Create(null));

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod]
        public async Task DeleteDevice_ShouldReturnNoContent()
        {
            int deviceCount = _devices.Count;
            deviceCount -= 1;

            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            var result = await controller.Delete(1);

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            Assert.AreEqual(deviceCount, _devices.Count);
        }

        [TestMethod]
        public async Task DeleteInvalidDevice_ShouldReturnNotFound()
        {
            int deviceCount = _devices.Count;

            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            var result = await controller.Delete(-1);

            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
            Assert.AreEqual(deviceCount, _devices.Count);
        }

        [TestMethod]
        public async Task ChangeDevice_ShouldReturnNotNoContent()
        {
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            var result = await controller.Update(5, new Device() { Id = 5, Name = "Device 5 changed", Description = "Changed", DeviceType = DeviceType.Aditus });

            Device device = _devices.Where(x => x.Id == 5).First();

            Assert.IsInstanceOfType(result, typeof(NoContentResult));
            Assert.AreEqual(device.Name, "Device 5 changed");
        }

        [TestMethod]
        public async Task ChangeDeviceWithWrongId_ShouldReturnBadRequest()
        {
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            var result = await controller.Update(4, new Device() { Id = 5, Name = "Device 5 changed", Description = "Changed", DeviceType = DeviceType.Aditus });

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

        [TestMethod]
        public async Task ChangeDeviceWithWrongNotExistingId_ShouldReturnNotFound()
        {
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            var result = await controller.Update(-1, new Device() { Id = -1, Name = "Device -1 changed", Description = "Changed", DeviceType = DeviceType.Aditus });

            Assert.IsInstanceOfType(result, typeof(NotFoundResult));
        }

        [TestMethod]
        public async Task ChangeNullableDevice_ShouldReturnBadRequest()
        {
            var controller = new DevicesController(new DeviceRepositoryMock(_devices));
            var result = await controller.Update(5, null);

            Assert.IsInstanceOfType(result, typeof(BadRequestResult));
        }

    }
}
