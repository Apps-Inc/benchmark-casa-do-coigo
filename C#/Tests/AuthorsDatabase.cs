using CasaDoCodigo.Controllers;
using CasaDoCodigo.Data.DTOs.Author;
using CasaDoCodigo.Models;
using Microsoft.AspNetCore.Mvc;
using Xunit;

namespace Tests
{
    public sealed class AuthorsDatabase
    {
        private static readonly CreateAuthorDto[] CreateAuthorsTestData = new[]
        {
            new CreateAuthorDto(
                "Philip Pullman",
                "mail@philip-pullman.com",
                "His Dark Materials and nothing else"
            ),
            new CreateAuthorDto(
                "Terry Pratchett",
                "mail@terrypratchettbooks.com",
                "Mainly Discworld"
            ),
            new CreateAuthorDto(
                "Stephen King",
                "mail@stephenking.com",
                "The Dark Tower and The Shining"
            )
        };

        [Fact]
        public void InsertNewAuthorIntoDatabase()
        {
            var controller = Generate.Controller<AuthorController>();
            Assert.Empty(controller.GetAuthors());

            var insertedActionResult = controller.AddAuthor(CreateAuthorsTestData[0]);
            Assert.IsType<CreatedAtActionResult>(insertedActionResult);

            var insertedResult = (CreatedAtActionResult) insertedActionResult;
            Assert.Single(controller.GetAuthors());
            Assert.IsType<Author>(insertedResult.Value);

            var insertedValue = (Author)insertedResult.Value;
            Assert.Equal(CreateAuthorsTestData[0].Name, insertedValue.Name);
        }

        [Fact]
        public void InsertDuplicateEmailReturnsBadRequest()
        {
            var controller = Generate.Controller<AuthorController>();
            Assert.Empty(controller.GetAuthors());

            // Tentar inserir duas vezes o mesmo autor deve retornar um erro Bad Request.
            Assert.IsType<CreatedAtActionResult>(controller.AddAuthor(CreateAuthorsTestData[0]));
            Assert.IsType<BadRequestObjectResult>(controller.AddAuthor(CreateAuthorsTestData[0]));

            // Mas, ao tentar inserir um válido logo depois, ele deve funcionar.
            controller.AddAuthor(CreateAuthorsTestData[1]);
        }
    }
}
