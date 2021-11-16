using System;
using System.ComponentModel.DataAnnotations.Schema;
using CasaDoCodigo.Data.DTOs.Author;
using CasaDoCodigo.Data.DTOs.Category;

namespace CasaDoCodigo.Data.DTOs.Book
{
    [Table("books")]
    public sealed class ReadBookDetailsDto
    {
        public string Title { get; private set; }
        public string Abstract { get; private set; }
        public string Summary { get; private set; }
        public double Price { get; private set; }
        public int PageCount { get; private set; }
        public string Isbn { get; private set; }
        public string CoverUrl { get; private set; } = "https://www.stroustrup.com/4thEnglish.JPG";
        public DateTime PublicationDate { get; private set; }
        public ReadCategoryDto Category { get; private set; }
        public ReadAuthorDto Author { get; private set; }
        public DateTime AccessTime { get; private set; } = DateTime.Now;

        public ReadBookDetailsDto(ReadBookDto book, ReadCategoryDto category, ReadAuthorDto author)
        {
            Title = book.Title;
            Abstract = book.Abstract;
            Summary = book.Summary;
            Price = book.Price;
            PageCount = book.PageCount;
            Isbn = book.Isbn;
            PublicationDate = book.PublicationDate;
            Category = category;
            Author = author;
        }
    }
}
