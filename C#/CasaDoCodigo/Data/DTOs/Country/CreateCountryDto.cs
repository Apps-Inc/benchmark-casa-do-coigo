using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.Country
{
    [Table("countries")]
    public sealed class CreateCountryDto
    {
        [Required(ErrorMessage = "O campo de nome é obrigatório")]
        [DefaultValue("Japão")]
        public string Name { get; set; }

        public CreateCountryDto(string name)
        {
            Name = name;
        }
    }
}
