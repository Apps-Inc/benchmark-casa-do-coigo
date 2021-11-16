using System.ComponentModel.DataAnnotations.Schema;
using CasaDoCodigo.Data.DTOs.State;

namespace CasaDoCodigo.Models
{
    [Table("states")]
    public class State : Entity
    {
        [Column("name")]
        public string Name { get; private set; }

        [Column("country")]
        public int CountryId { get; private set; }

        public State(string name, int countryId)
        {
            Name = name;
            CountryId = countryId;
        }

        public State(CreateStateDto stateDto)
            : this(stateDto.Name, stateDto.CountryId)
        {
        }
    }
}
