using System.ComponentModel.DataAnnotations.Schema;
using CasaDoCodigo.Data.DTOs.Country;

namespace CasaDoCodigo.Models
{
    [Table("countries")]
    public class Country : Entity
    {
        [Column("name")]
        public string Name { get; private set; }

        public Country(string name)
        {
            Name = name;
        }

        public Country(CreateCountryDto countryDto)
            : this(countryDto.Name)
        {
        }
    }
}
