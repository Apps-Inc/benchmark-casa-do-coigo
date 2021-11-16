using System.Collections.Generic;
using System.Linq;
using CasaDoCodigo.Data;
using CasaDoCodigo.Data.DTOs.Author;
using CasaDoCodigo.Data.DTOs.Book;
using CasaDoCodigo.Data.DTOs.Category;
using CasaDoCodigo.Models;
using CasaDoCodigo.Services;
using Microsoft.AspNetCore.Mvc;

namespace CasaDoCodigo.Controllers
{
    [ApiController]
    [Route("book")]
    public sealed class BookController : ControllerBase
    {
        private readonly Query<Book, ReadBookDto, CreateBookDto> _query;
        private readonly Query<Author, ReadAuthorDto, CreateAuthorDto> _queryAuthor;
        private readonly Query<Category, ReadCategoryDto, CreateCategoryDto> _queryCategory;

        public BookController(ApplicationContext context)
        {
            _query = new Query<Book, ReadBookDto, CreateBookDto>(context);
            _queryAuthor = new Query<Author, ReadAuthorDto, CreateAuthorDto>(context);
            _queryCategory = new Query<Category, ReadCategoryDto, CreateCategoryDto>(context);
        }

        [HttpGet("/books")]
        public IEnumerable<ReadBookListDto> GetBooks() =>
            _query.SelectAllFull().Select(b => new ReadBookListDto(b));

        [HttpGet("/fullbooks")]
        public IEnumerable<ReadBookDto> GetFullBooks() =>
            _query.SelectAllRead();

        [HttpGet("{id:int}")]
        public IActionResult GetBookById(int id)
        {
            var book = _query.SelectRead(b => id == b.Id);
            if (book == null) return NotFound();

            var author = _queryAuthor.SelectRead(a => book.AuthorId == a.Id);
            if (author == null) return NotFound();

            var category = _queryCategory.SelectRead(c => book.CategoryId == c.Id);
            if (category == null) return NotFound();

            return Ok(new ReadBookDetailsDto(book, category, author));
        }

        [HttpPost]
        public IActionResult AddBook([FromBody] CreateBookDto bookDto)
        {
            ValidateInputData(bookDto);
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var book = _query.Insert(bookDto);

            return CreatedAtAction(
                nameof(GetBookById),
                new {book.Id},
                book
            );
        }

        private void ValidateInputData(CreateBookDto bookDto)
        {
            if (_query.Exists(b => bookDto.Title == b.Title))
                ModelState.AddModelError("title", $"Título já registrado: {bookDto.Title}");

            if (_query.Exists(b => bookDto.Isbn == b.Isbn))
                ModelState.AddModelError("ISBN", $"ISBN já registrado: {bookDto.Isbn}");

            if (!_queryAuthor.Exists(a => bookDto.AuthorId == a.Id))
                ModelState.AddModelError("authorId", $"Id do autor inválido: {bookDto.AuthorId}");

            if (!_queryCategory.Exists(c => bookDto.CategoryId == c.Id))
                ModelState.AddModelError("categoryId", "Id da categoria inválido");
        }
    }
}
