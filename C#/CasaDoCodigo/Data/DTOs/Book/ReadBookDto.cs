using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace CasaDoCodigo.Data.DTOs.Book
{
    [Table("books")]
    public sealed class ReadBookDto
    {
        public string Title { get; private set; }
        public string Abstract { get; private set; }
        public string Summary { get; private set; }
        public double Price { get; private set; }
        public int PageCount { get; private set; }
        public string Isbn { get; private set; }
        public DateTime PublicationDate { get; private set; }
        public int CategoryId { get; private set; }
        public int AuthorId { get; private set; }
        public DateTime AccessTime { get; private set; } = DateTime.Now;

        public ReadBookDto(Models.Book book)
        {
            Title = book.Title;
            Abstract = book.Abstract;
            Summary = book.Summary;
            Price = book.Price;
            PageCount = book.PageCount;
            Isbn = book.Isbn;
            PublicationDate = book.PublicationDate;
            CategoryId = book.CategoryId;
            AuthorId = book.AuthorId;
        }
    }
}
