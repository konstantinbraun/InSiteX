using InSiteX.Repository;
using InSiteX.Repository.Common;
using InSiteX.Repository.Mocks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Linq;

namespace InSiteX.Services.Tests
{
    [TestClass]
    public class ServicesTests
    {

        [TestMethod]
        public void CheckIfTwoNumbersAreEqual()
        {
            DeviceService service = new DeviceService(new UnitOfWorkMock(), new DeviceRepositoryMock());
            service.Create(new InSiteX.Entity.Device());

            Assert.AreEqual(service.GetAll().Count(), 1);
        }
    }
}
