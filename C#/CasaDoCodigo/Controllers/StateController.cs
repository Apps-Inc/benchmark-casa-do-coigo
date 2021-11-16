using System.Collections.Generic;
using CasaDoCodigo.Data;
using CasaDoCodigo.Data.DTOs.Country;
using CasaDoCodigo.Data.DTOs.State;
using CasaDoCodigo.Models;
using CasaDoCodigo.Services;
using Microsoft.AspNetCore.Mvc;

namespace CasaDoCodigo.Controllers
{
    [ApiController]
    [Route("/state")]
    public class StateController : ControllerBase
    {
        private readonly Query<State, ReadStateDto, CreateStateDto> _query;
        private readonly Query<Country, ReadCountryDto, CreateCountryDto> _queryCountries;

        public StateController(ApplicationContext context)
        {
            _query = new Query<State, ReadStateDto, CreateStateDto>(context);
            _queryCountries = new Query<Country, ReadCountryDto, CreateCountryDto>(context);
        }

        [HttpGet("/states")]
        public IEnumerable<ReadStateDto> GetStates() =>
            _query.SelectAllRead();

        [HttpGet("{id:int}")]
        public IActionResult GetStateById(int id)
        {
            var result = _query.SelectRead(s => id == s.Id);
            return result == null ? NotFound() : Ok(result);
        }

        [HttpPost]
        public IActionResult AddState([FromBody] CreateStateDto stateDto)
        {
            ValidateInputData(stateDto);
            if (!ModelState.IsValid) return BadRequest(ModelState);

            var state = _query.Insert(stateDto);

            return CreatedAtAction(
                nameof(GetStateById),
                new {state.Id},
                state
            );
        }

        private void ValidateInputData(CreateStateDto stateDto)
        {
            if (_query.Exists(s =>
                stateDto.Name == s.Name &&
                stateDto.CountryId == s.CountryId))
                ModelState.AddModelError("name", $"Estado já registrado: {stateDto.Name}");

            if (!_queryCountries.Exists(stateDto.CountryId))
                ModelState.AddModelError("country", $"País não encontrado: {stateDto.CountryId}");
        }
    }
}
