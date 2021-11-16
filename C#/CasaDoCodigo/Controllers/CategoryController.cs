using System.Collections.Generic;
using CasaDoCodigo.Data;
using CasaDoCodigo.Data.DTOs.Category;
using CasaDoCodigo.Models;
using CasaDoCodigo.Services;
using Microsoft.AspNetCore.Mvc;

namespace CasaDoCodigo.Controllers
{
    [ApiController]
    [Route("/category")]
    public sealed class CategoryController : ControllerBase
    {
        private readonly Query<Category, ReadCategoryDto, CreateCategoryDto> _query;

        public CategoryController(ApplicationContext context)
        {
            _query = new Query<Category, ReadCategoryDto, CreateCategoryDto>(context);
        }

        [HttpGet("/categories")]
        public IEnumerable<ReadCategoryDto> GetCategories() =>
            _query.SelectAllRead();

        [HttpGet("{id:int}")]
        public IActionResult GetCategoryById(int id)
        {
            var result = _query.SelectRead(c => id == c.Id);
            return result == null ? NotFound() : Ok(result);
        }

        [HttpPost]
        public IActionResult AddCategory([FromBody] CreateCategoryDto categoryDto)
        {
            ValidateInputData(categoryDto);
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var category = _query.Insert(categoryDto);

            return CreatedAtAction(
                nameof(GetCategoryById),
                new { category.Id },
                category
            );
        }

        private void ValidateInputData(CreateCategoryDto categoryDto)
        {
            if (_query.Exists(c => categoryDto.Name == c.Name))
                ModelState.AddModelError("name", $"Categoria já registrada: {categoryDto.Name}");
        }
    }
}
