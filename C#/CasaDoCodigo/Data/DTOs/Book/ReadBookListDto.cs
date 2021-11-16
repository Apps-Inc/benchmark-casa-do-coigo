using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.Book
{
    [Table("books")]
    public class ReadBookListDto
    {
        public int Id { get; private set; }
        public string Title { get; private set; }

        public ReadBookListDto(Models.Book book)
        {
            Id = book.Id;
            Title = book.Title;
        }
    }
}
