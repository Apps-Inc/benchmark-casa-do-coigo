using CasaDoCodigo.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace CasaDoCodigo.Data
{
    public sealed class ApplicationContext : DbContext
    {
        public DbSet<Author> Authors { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Book> Books { get; set; }
        public DbSet<Country> Countries { get; set; }
        public DbSet<State> States { get; set; }

        private static readonly ILoggerFactory Logger = LoggerFactory.Create(
            p => p.AddConsole()
        );

        public ApplicationContext(DbContextOptions<ApplicationContext> ops)
            : base(ops)
        {
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .UseLoggerFactory(Logger)
            #if DEBUG
                .EnableSensitiveDataLogging()
            #endif
                ;
        }
    }
}
