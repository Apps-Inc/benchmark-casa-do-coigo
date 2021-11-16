using System.ComponentModel.DataAnnotations.Schema;
using CasaDoCodigo.Data.DTOs.Author;

namespace CasaDoCodigo.Models
{
    [Table("authors")]
    public sealed class Author : Entity
    {
        [Column("email")]
        public string Email { get; private set; }

        [Column("name")]
        public string Name { get; private set; }

        [Column("description")]
        public string Description { get; private set; }

        public override string ToString() =>
            $"{Name} <{Email}> {RegisterTime:yyyy-MM-d HH:mm:ss}: {Description}";

        public Author(string name, string email, string description)
        {
            Name = name;
            Email = email;
            Description = description;
        }

        public Author(CreateAuthorDto dto)
            : this(dto.Name, dto.Email, dto.Description)
        {
        }
    }
}
