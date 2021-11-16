using CasaDoCodigo.Controllers;
using CasaDoCodigo.Data.DTOs.Category;
using CasaDoCodigo.Models;
using Microsoft.AspNetCore.Mvc;
using Xunit;

namespace Tests
{
    public sealed class CategoriesDatabase
    {
        [Theory]
        [InlineData("Ficção")]
        [InlineData("Romance")]
        [InlineData("Programação")]
        public void InsertNewCategoryIntoDatabase(string name)
        {
            var newCategory = new CreateCategoryDto(name);
            var controller = Generate.Controller<CategoryController>();
            Assert.Empty(controller.GetCategories());

            var insertedActionResult = controller.AddCategory(newCategory);
            Assert.IsType<CreatedAtActionResult>(insertedActionResult);

            var insertedResult = (CreatedAtActionResult) insertedActionResult;
            Assert.Single(controller.GetCategories());
            Assert.IsType<Category>(insertedResult.Value);

            var insertedValue = (Category)insertedResult.Value;
            Assert.Equal(newCategory.Name, insertedValue.Name);
        }

        [Theory]
        [InlineData("Programação")]
        [InlineData("Romance")]
        public void InsertDuplicateCategoryReturnsBadRequest(string name)
        {
            var controller = Generate.Controller<CategoryController>();
            Assert.Empty(controller.GetCategories());

            // Tentar inserir a mesma categoria duas vezes deve retornar Bad Request.
            var newCategory = new CreateCategoryDto(name);
            Assert.IsType<CreatedAtActionResult>(controller.AddCategory(newCategory));
            Assert.IsType<BadRequestObjectResult>(controller.AddCategory(newCategory));

            // Mas inserir outra com um nome levemente distinto logo depois deve funcionar normalmente.
            controller.AddCategory(new CreateCategoryDto(name + "1"));
        }
    }
}
