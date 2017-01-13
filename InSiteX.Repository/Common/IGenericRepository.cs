using InSiteX.Entity.Common;
using System;
using System.Collections.Generic;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace InSiteX.Repository.Common
{
    public interface IGenericRepository<T> where T: BaseEntity
    {
        Task<IEnumerable<T>> GetAllAsync();
        IEnumerable<T> FindBy(Expression<Func<T, bool>> predicate);
        Task<T> AddAsync(T entity);
        Task<T> DeleteAsync(T entity);
        Task EditAsync(T extity);
  
    }
}
