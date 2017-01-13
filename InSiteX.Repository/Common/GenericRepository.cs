using InSiteX.Entity.Common;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;

namespace InSiteX.Repository.Common
{
    public abstract class GenericRepository<T> : IGenericRepository<T>
        where T:Entity<int>
    {
        protected DbContext _context;
        protected readonly DbSet<T> _dbset;

        public GenericRepository(DbContext context)
        {
            _context = context;
            _dbset = context.Set<T>();
        }

        public async Task<IEnumerable<T>> GetAllAsync()
        {
            return await Task.FromResult( _dbset.AsEnumerable<T>());
        }

        public IEnumerable<T> FindBy(Expression<Func<T, bool>> predicate)
        {
            return _dbset.Where(predicate).AsEnumerable<T>();
        }

        public async Task<T> AddAsync(T entity)
        {
            _dbset.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task<T> DeleteAsync(T entity)
        {
            var item = _dbset.Remove(entity).Entity;
            await _context.SaveChangesAsync();
            return item;
        }

        public async Task EditAsync(T entity)
        {
            _context.Entry(entity).State = EntityState.Modified;
            await _context.SaveChangesAsync();
        }

    }
}
