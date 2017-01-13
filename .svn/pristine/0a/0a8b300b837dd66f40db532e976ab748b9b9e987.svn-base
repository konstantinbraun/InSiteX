using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InSiteX.Services.Common
{
    public interface IEntityService<T>: IService
    {
        T Create(T entity);

        Task<T> CreateAsync(T entity);
        void Delete(T entity);
        IEnumerable<T> GetAll();
        void Update(T entity);
    }
}
