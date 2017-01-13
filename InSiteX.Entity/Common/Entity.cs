using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InSiteX.Entity.Common
{
    public abstract class Entity<T> : BaseEntity, IEntity<T>
    {
        [Required]
        public virtual T Id { get; set; }
    }
}
