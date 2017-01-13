using InSiteX.Entity;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InSiteX.Api.Context
{
    public class InSiteXContext: DbContext
    {
        public InSiteXContext(DbContextOptions<InSiteXContext> options)  : base(options)
        { }
        public virtual DbSet<Device> Devices { get; set; }

    }
}
