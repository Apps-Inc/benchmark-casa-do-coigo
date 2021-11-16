using System;
using CasaDoCodigo.Services.Validations;
using Xunit;

namespace Tests
{
    public sealed class Validations
    {
        [Theory]
        [InlineData(0)]
        [InlineData(-10)]
        [InlineData(10)]
        public void InTheFutureShouldReturnFalseWhenDateIsInThePast(int numDays)
        {
            var now = DateTime.Now;
            var inTheFuture = new InTheFuture(now);
            var testDate = now.AddDays(numDays);

            if (numDays <= 0)
                Assert.False(inTheFuture.IsValid(testDate));
            else
                Assert.True(inTheFuture.IsValid(testDate));
        }

        [Theory]
        [InlineData("529.982.247-25", true)]
        [InlineData("457.017.395-03", true)]
        [InlineData("111.111.111-11", false)]
        [InlineData("222.222.222-22", false)]
        public void CpfShouldReturnTrueOnValidInput(string cpfStr, bool isValid)
        {
            var cpf = new Cpf();
            Assert.Equal(isValid, cpf.IsValid(cpfStr));
        }

        [Theory]
        // ISBN-10
        [InlineData("0.321.563.840", true)]
        [InlineData("0321563840", true)]
        [InlineData("1529046505", true)]
        // ISBN-13
        [InlineData("978-055.212.475-1", true)]
        [InlineData("9780552124751", true)]
        [InlineData("978-0440238133", true)]
        [InlineData("978-0321958327", true)]
        public void IsbnShouldReturnTrueOnValidInput(string isbnStr, bool isValid)
        {
            var isbn = new Isbn();
            Assert.Equal(isValid, isbn.IsValid(isbnStr));
        }
    }
}
