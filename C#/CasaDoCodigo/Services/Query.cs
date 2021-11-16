using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using CasaDoCodigo.Data;
using Microsoft.EntityFrameworkCore;

namespace CasaDoCodigo.Services
{
    public sealed class Query<TFullData, TReadDto, TCreateDto>
        where TFullData : class
        where TReadDto : class
        where TCreateDto : class
    {
        private readonly ApplicationContext _context;

        public Query(ApplicationContext context)
        {
            _context = context;
        }

        public TReadDto SelectRead(Expression<Func<TFullData, bool>> expr)
        {
            var result = SelectAllFull().FirstOrDefault(expr);

            return (result == null)
                ? null
                : InstantiateReadDto(result);
        }

        public DbSet<TFullData> SelectAllFull() =>
            _context.Set<TFullData>();

        public IEnumerable<TReadDto> SelectAllRead()
        {
            var set = SelectAllFull();
            var list = new List<TReadDto>(set.Count());
            foreach (var item in set) list.Add(InstantiateReadDto(item));

            return list;
        }

        public bool Exists(Expression<Func<TFullData, bool>> expr) =>
            SelectAllFull().Any(expr);

        #region Deveria ser apagado

        public bool Exists(int id) =>
            SelectAllFull().Any(f => id == GetField<int>("Id", f));

        private static TField GetField<TField>(string fieldName, TFullData f)
        {
            var fieldInfo = f.GetType().GetField(fieldName);
            if (fieldInfo == null) return default;

            return fieldInfo.GetValue(f) is not TField fieldValue
                ? default
                : fieldValue;
        }

        #endregion

        public TFullData Insert(TCreateDto val)
        {
            var fullData = InstantiateFullData(val);
            SelectAllFull().Add(fullData);
            _context.SaveChanges();

            return fullData;
        }

        // Basicamente o mesmo que
        //
        //     return new TReturn(val);
        //
        // exceto que isso requer o constraint new(), e ele não aceita parâmetros.
        private static TReadDto InstantiateReadDto(TFullData val) =>
            (TReadDto) Activator.CreateInstance(typeof(TReadDto), val);

        private static TFullData InstantiateFullData(TCreateDto val) =>
            (TFullData) Activator.CreateInstance(typeof(TFullData), val);
    }
}
