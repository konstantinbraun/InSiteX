using InSiteX.Entity.Common;
using InSiteX.Repository.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace InSiteX.Services.Common
{
    public abstract class EntityService<T> : IEntityService<T>
        where T : BaseEntity
    {
        IGenericRepository<T> _repository;

        public EntityService(IGenericRepository<T> repository)
        {
            _unitOfWork = unitOfWork;
            _repository = repository;
        }
        public virtual T Create(T entity)
        {
            if (entity == null) throw new ArgumentNullException("entity");
            T newEntiry =_repository.Add(entity);
            _unitOfWork.Commit();
            return newEntiry;
        }

        public async Task<T> CreateAsync(T entity)
        {
            if (entity == null) throw new ArgumentNullException("entity");
            T newEntiry = await _repository.AddAsync(entity);
            await _unitOfWork.CommitAsync();
            return newEntiry;
        }

        public virtual void Delete(T entity)
        {
            if (entity== null) throw new ArgumentNullException("entity");
            _repository.Delete(entity);
            _unitOfWork.Commit(); 
        }

        public virtual IEnumerable<T> GetAll()
        {
            return _repository.GetAll();
        }

        public virtual void Update(T entity)
        {
            if (entity == null) throw new ArgumentNullException("entity");
            _repository.Edit(entity);
            _unitOfWork.Commit();
        }

    }
}
