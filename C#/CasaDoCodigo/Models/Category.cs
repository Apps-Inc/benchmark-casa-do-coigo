using System.ComponentModel.DataAnnotations.Schema;
using CasaDoCodigo.Data.DTOs.Category;

namespace CasaDoCodigo.Models
{
    [Table("categories")]
    public sealed class Category : Entity
    {
        [Column("name")]
        public string Name { get; private set; }

        public Category(string name)
        {
            Name = name;
        }

        public Category(CreateCategoryDto categoryDto)
            : this(categoryDto.Name)
        {
        }
    }
}
