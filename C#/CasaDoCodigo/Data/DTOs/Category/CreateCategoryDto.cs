using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.Category
{
    [Table("categories")]
    public sealed class CreateCategoryDto
    {
        [Required(ErrorMessage = "Toda categoria precisa de um nome")]
        [DefaultValue("Fantasia")]
        public string Name { get; set; }

        public CreateCategoryDto(string name)
        {
            Name = name;
        }
    }
}
