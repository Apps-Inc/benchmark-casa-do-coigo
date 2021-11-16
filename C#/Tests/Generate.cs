using System;
using CasaDoCodigo.Data;
using Microsoft.EntityFrameworkCore;

namespace Tests
{
    public static class Generate
    {
        public static ApplicationContext Context(string dbName = "IntegrationTests")
        {
            var ops = new DbContextOptionsBuilder<ApplicationContext>()
                .UseInMemoryDatabase(dbName)
                .Options;

            var context = new ApplicationContext(ops);
            context.Database.EnsureDeleted();

            return context;
        }

        public static T Controller<T>(ApplicationContext context = null) =>
            (T) Activator.CreateInstance(typeof(T), context ?? Context());
    }
}
