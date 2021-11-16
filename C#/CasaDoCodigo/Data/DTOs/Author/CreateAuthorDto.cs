using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.Author
{
    [Table("authors")]
    public sealed class CreateAuthorDto
    {
        private const int EmailStringMaxLen = 50;
        private const int NameStringMaxLen = 50;
        private const int DescriptionStringMaxLen = 400;

        [EmailAddress]
        [Required(ErrorMessage = "O campo de email é obrigatório")]
        [StringLength(EmailStringMaxLen,
            ErrorMessage = "O campo de email não deve conter mais do que 50 caracteres")]
        [DefaultValue("mail@paolini.net")]
        public string Email { get; set; }

        [Required(ErrorMessage = "O campo de nome é obrigatório")]
        [StringLength(NameStringMaxLen,
            ErrorMessage = "O campo de nome não deve conter mais do que 50 caracteres")]
        [DefaultValue("Christopher Paolini")]
        public string Name { get; set; }

        [Required(ErrorMessage = "O campo de descrição é obrigatório")]
        [StringLength(DescriptionStringMaxLen,
            ErrorMessage = "O campo de descrição não deve conter mais do que 400 caracteres")]
        public string Description { get; set; }

        public CreateAuthorDto(string name, string email, string description)
        {
            Email = email;
            Name = name;
            Description = description;
        }
    }
}
