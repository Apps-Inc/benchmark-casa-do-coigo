using System;
using CasaDoCodigo.Controllers;
using CasaDoCodigo.Data.DTOs.Author;
using CasaDoCodigo.Data.DTOs.Book;
using CasaDoCodigo.Data.DTOs.Category;
using CasaDoCodigo.Models;
using Microsoft.AspNetCore.Mvc;
using Xunit;

namespace Tests
{
    public sealed class BookDatabase
    {
        private static readonly CreateCategoryDto[] CreateCategoriesTestData = new[]
        {
            new CreateCategoryDto("Fantasia")
        };

        private static readonly CreateAuthorDto[] CreateAuthorsTestData = new[]
        {
            new CreateAuthorDto("Terry Pratchett", "mail@example.com", "")
        };

        private static readonly CreateBookDto[] CreateBooksTestData = new[]
        {
            new CreateBookDto(
                "The Colour Of Magic",
                "A 1983 fantasy comedy novel by Terry Pratchett, and is the first book of the Discworld series",
                "Rincewind did nothing wrong",
                10.93,
                288,
                "9780552124751",
                new DateTime(2021, 02, 01),
                1,
                1
            )
        };

        [Theory]
        [InlineData(0)]
        public void InsertNewBookIntoDatabase(int idx)
        {
            var authorDto = CreateAuthorsTestData[idx];
            var categoryDto = CreateCategoriesTestData[idx];
            var bookDto = CreateBooksTestData[idx];

            // Usar o mesmo nome pro banco faz esse teste quebrar (?)
            var context = Generate.Context("InsertNewBookIntoDatabase");
            var authorController = Generate.Controller<AuthorController>(context);
            var categoryController = Generate.Controller<CategoryController>(context);
            var bookController = Generate.Controller<BookController>(context);

            // Para a inserção do livro, o banco precisa ter a categoria e o
            // autor registrados.

            Assert.Empty(categoryController.GetCategories());
            categoryController.AddCategory(categoryDto);
            Assert.Single(categoryController.GetCategories());
            Assert.IsType<OkObjectResult>(categoryController.GetCategoryById(bookDto.CategoryId));

            Assert.Empty(authorController.GetAuthors());
            authorController.AddAuthor(authorDto);
            Assert.Single(authorController.GetAuthors());
            Assert.IsType<OkObjectResult>(authorController.GetAuthorById(bookDto.AuthorId));

            // Agora sim o teste pode começar.

            Assert.Empty(bookController.GetBooks());

            var insertedActionResult = bookController.AddBook(bookDto);
            Assert.IsType<CreatedAtActionResult>(insertedActionResult);

            var insertedResult = (CreatedAtActionResult) insertedActionResult;
            Assert.Single(bookController.GetBooks());
            Assert.IsType<Book>(insertedResult.Value);

            var insertedValue = (Book) insertedResult.Value;
            Assert.Equal(bookDto.Title, insertedValue.Title);
        }
    }
}
