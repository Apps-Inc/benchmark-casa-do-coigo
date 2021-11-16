using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.State
{
    [Table("states")]
    public sealed class ReadStateDto
    {
        public string Name { get; set; }

        public ReadStateDto(Models.State state)
        {
            Name = state.Name;
        }
    }
}
