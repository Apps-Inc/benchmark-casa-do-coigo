using System;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using CasaDoCodigo.Services.Validations;

namespace CasaDoCodigo.Data.DTOs.Book
{
    [Table("books")]
    public sealed class CreateBookDto
    {
        private const int AbstractMaxLen = 500;
        private const float MinPrice = 20;
        private const int MinPageCount = 100;

        [Required(ErrorMessage = "O campo de título é obrigatório")]
        [DefaultValue("To Sleep in a Sea of Stars")]
        public string Title { get; set; }

        [Required(ErrorMessage = "O campo de resumo é obrigatório")]
        [StringLength(AbstractMaxLen,
            ErrorMessage = "O campo de resumo deve ter no máximo 500 caracteres")]
        public string Abstract { get; set; }

        public string Summary { get; set; }

        [Required(ErrorMessage = "O campo de preço é obrigatório")]
        [Range(MinPrice, Double.MaxValue, ErrorMessage = "O preço deve ser no mínimo 20")]
        [DefaultValue(157.72)]
        public double Price { get; set; }

        [Required(ErrorMessage = "O campo de número de páginas é obrigatório")]
        [Range(MinPageCount, int.MaxValue, ErrorMessage = "O número de páginas deve ser no mínimo 100")]
        [DefaultValue(880)]
        public int PageCount { get; set; }

        [Isbn]
        [Required(ErrorMessage = "O campo de ISBN é obrigatório")]
        [DefaultValue("9781529046502")]
        public string Isbn { get; set; }

        [Required(ErrorMessage = "O campo de data de úblicação é obrigatório")]
        [InTheFuture(ErrorMessage = "O campo de data deve estar no futuro")]
        [DefaultValue("2020-09-15")]
        public DateTime PublicationDate { get; set; }

        [Required(ErrorMessage = "O campo de categoria é obrigatório")]
        [DefaultValue(1)]
        public int CategoryId { get; set; }

        [Required(ErrorMessage = "O campo de autor é obrigatório")]
        [DefaultValue(1)]
        public int AuthorId { get; set; }

        public CreateBookDto(
            string title,
            string @abstract,
            string summary,
            double price,
            int pageCount,
            string isbn,
            DateTime publicationDate,
            int categoryId,
            int authorId
        )
        {
            Title = title;
            Abstract = @abstract;
            Summary = summary;
            Price = price;
            PageCount = pageCount;
            Isbn = isbn;
            PublicationDate = publicationDate;
            CategoryId = categoryId;
            AuthorId = authorId;
        }
    }
}
