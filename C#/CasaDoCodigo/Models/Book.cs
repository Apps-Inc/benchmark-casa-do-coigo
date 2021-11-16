using System;
using System.ComponentModel.DataAnnotations.Schema;
using CasaDoCodigo.Data.DTOs.Book;

namespace CasaDoCodigo.Models
{
    [Table("books")]
    public sealed class Book : Entity
    {
        [Column("title")]
        public string Title { get; private set; }

        [Column("abstract")]
        public string Abstract { get; private set; }

        [Column("summary")]
        public string Summary { get; private set; }

        [Column("price")]
        public double Price { get; private set; }

        [Column("num_pages")]
        public int PageCount { get; private set; }

        [Column("isbn")]
        public string Isbn { get; private set; }

        [Column("publication_date")]
        public DateTime PublicationDate { get; private set; }

        [Column("category")]
        public int CategoryId { get; private set; }

        [Column("author")]
        public int AuthorId { get; private set; }

        public Book(
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

        public Book(CreateBookDto bookDto)
            : this(
                bookDto.Title,
                bookDto.Abstract,
                bookDto.Summary,
                bookDto.Price,
                bookDto.PageCount,
                bookDto.Isbn,
                bookDto.PublicationDate,
                bookDto.CategoryId,
                bookDto.AuthorId
            )
        {
        }
    }
}
