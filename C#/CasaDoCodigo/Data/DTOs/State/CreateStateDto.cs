using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.State
{
    [Table("states")]
    public sealed class CreateStateDto
    {
        [Required(ErrorMessage = "O campo de nome é obrigatório")]
        [DefaultValue("Hokkaido")]
        public string Name { get; set; }

        [Required(ErrorMessage = "O campo de id do país é obrigatório")]
        [DefaultValue(1)]
        public int CountryId { get; set; }

        public CreateStateDto(string name, int countryId)
        {
            Name = name;
            CountryId = countryId;
        }
    }
}
