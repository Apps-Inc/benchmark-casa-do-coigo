using System.Collections.Generic;
using CasaDoCodigo.Data;
using CasaDoCodigo.Data.DTOs.Country;
using CasaDoCodigo.Models;
using CasaDoCodigo.Services;
using Microsoft.AspNetCore.Mvc;

namespace CasaDoCodigo.Controllers
{
    [ApiController]
    [Route("/country")]
    public class CountryController : ControllerBase
    {
        private readonly Query<Country, ReadCountryDto, CreateCountryDto> _query;

        public CountryController(ApplicationContext context)
        {
            _query = new Query<Country, ReadCountryDto, CreateCountryDto>(context);
        }

        [HttpGet("/countries")]
        public IEnumerable<ReadCountryDto> GetCountries() =>
            _query.SelectAllRead();

        [HttpGet("{id:int}")]
        public IActionResult GetCountryById(int id)
        {
            var result = _query.SelectRead(c => id == c.Id);
            return result == null ? NotFound() : Ok(result);
        }

        [HttpPost]
        public IActionResult AddCountry([FromBody] CreateCountryDto countryDto)
        {
            ValidateInputData(countryDto);
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var country = _query.Insert(countryDto);

            return CreatedAtAction(
                nameof(GetCountryById),
                new {country.Id},
                country
            );
        }

        private void ValidateInputData(CreateCountryDto countryDto)
        {
            if (_query.Exists(c => countryDto.Name == c.Name))
                ModelState.AddModelError("name", $"País já registrado: {countryDto.Name}");
        }
    }
}
