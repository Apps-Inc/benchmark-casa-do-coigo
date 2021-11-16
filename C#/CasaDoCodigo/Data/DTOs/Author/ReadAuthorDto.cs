using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.Author
{
    [Table("authors")]
    public sealed class ReadAuthorDto
    {
        public string Name { get; private set; }
        public string Email { get; private set; }
        public string Description { get; private set; }
        public DateTime RegisterTime { get; private set; }
        public DateTime AccessTime { get; private set; } = DateTime.Now;

        public ReadAuthorDto(Models.Author author)
        {
            Name = author.Name;
            Email = author.Email;
            Description = author.Description;
            RegisterTime = author.RegisterTime;
        }
    }
}
