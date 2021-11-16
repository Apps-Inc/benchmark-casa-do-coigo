using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.Country
{
    [Table("countries")]
    public sealed class ReadCountryDto
    {
        public string Name { get; set; }

        public ReadCountryDto(Models.Country country)
        {
            Name = country.Name;
        }
    }
}
