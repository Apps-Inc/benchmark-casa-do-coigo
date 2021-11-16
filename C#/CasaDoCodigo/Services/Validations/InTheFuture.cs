using System;
using System.ComponentModel.DataAnnotations;

namespace CasaDoCodigo.Services.Validations
{
    public sealed class InTheFuture : ValidationAttribute
    {
        private readonly DateTime _now;

        public override bool IsValid(object val) =>
            (DateTime) val > _now;

        public InTheFuture() : this(DateTime.Now)
        {
        }

        public InTheFuture(DateTime time)
        {
            _now = time;
        }
    }
}
