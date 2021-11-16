using System.Collections.Generic;
using CasaDoCodigo.Data;
using CasaDoCodigo.Data.DTOs.Author;
using CasaDoCodigo.Models;
using CasaDoCodigo.Services;
using Microsoft.AspNetCore.Mvc;

namespace CasaDoCodigo.Controllers
{
    [ApiController]
    [Route("/author")]
    public sealed class AuthorController : ControllerBase
    {
        private readonly Query<Author, ReadAuthorDto, CreateAuthorDto> _query;

        public AuthorController(ApplicationContext context)
        {
            _query = new Query<Author, ReadAuthorDto, CreateAuthorDto>(context);
        }

        [HttpGet("/authors")]
        public IEnumerable<ReadAuthorDto> GetAuthors() =>
            _query.SelectAllRead();

        [HttpGet("{id:int}")]
        public IActionResult GetAuthorById(int id)
        {
            var result = _query.SelectRead(a => id == a.Id);
            return result == null ? NotFound() : Ok(result);
        }

        [HttpPost]
        public IActionResult AddAuthor([FromBody] CreateAuthorDto authorDto)
        {
            ValidateInputData(authorDto);
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var author = _query.Insert(authorDto);

            return CreatedAtAction(
                nameof(GetAuthorById),
                new {author.Id},
                author
            );
        }

        private void ValidateInputData(CreateAuthorDto authorDto)
        {
            if (_query.Exists(a => authorDto.Name == a.Name))
                ModelState.AddModelError("name", $"Autor já registrado: {authorDto.Name}");
        }
    }
}
