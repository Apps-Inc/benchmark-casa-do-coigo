using System;

namespace CasaDoCodigo.Data.DTOs.Category
{
    public sealed class ReadCategoryDto
    {
        public string Name { get; private set; }
        public DateTime RegisterTime { get; private set; }
        public DateTime AccessTime { get; private set; } = DateTime.Now;

        public ReadCategoryDto(Models.Category category)
        {
            Name = category.Name;
            RegisterTime = category.RegisterTime;
        }
    }
}
