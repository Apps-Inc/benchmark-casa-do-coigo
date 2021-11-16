using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace CasaDoCodigo.Services.Validations
{
    /// <summary>
    /// Validados customizado de CPFs, seguindo o algoritmo apresendato em <a href="https://www.geradorcpf.com/algoritmo_do_cpf.htm">nesse link</a>.
    /// </summary>
    public sealed class Cpf : ValidationAttribute
    {
        private const string DefaultNotAStringMessage = "Somente strings podem ser CPFs";
        private const string DefaultSameDigitMessage = "CPFs com um único dígito são inválidos";
        private const string DefaultDigitCountMessage = "CPFs devem possuir 11 dígitos";
        private const string DefaultInvalidMessage = "CPF inválido";

        // Utilize essa mensagem para sobrescrever quaisquer outras caso não
        // queira especificar o erro encontrado.
        //
        // Esconde ValidationAttribute.ErrorMessage.
        public new string ErrorMessage { get; set; } = null;

        public string NotAStringMessage { get; set; } = DefaultNotAStringMessage;
        public string SameDigitMessage { get; set; } = DefaultSameDigitMessage;
        public string DigitCountMessage { get; set; } = DefaultDigitCountMessage;
        public string InvalidMessage { get; set; } = DefaultInvalidMessage;

        protected override ValidationResult IsValid(object value, ValidationContext context)
        {
            // Somente strings podem ser CPFs.
            if (value is not string cpf) return new ValidationResult(ErrorMessage ?? NotAStringMessage);

            // Permitir CPFs em formato livre; para isso, basta filtrar os
            // caracteres que não são dígitos antes de transformar os demais em
            // inteiros.
            var digits = cpf
                .Where(char.IsDigit)
                .Select(digit => int.Parse(digit.ToString()))
                .ToList();

            // Se todos os dígitos forem iguais, o CPF é inválido.
            //
            // Essa verificação é necessária uma vez que esses CPFs passam no
            // restante do algoritmo.
            if (digits.GroupBy(d => d).Count() == 1) return new ValidationResult(ErrorMessage ?? SameDigitMessage);

            // Se não houverem onze caracteres restantes, então esse CPF é
            // inválido.
            if (11 != digits.Count) return new ValidationResult(ErrorMessage ?? DigitCountMessage);

            // Os dois últimos dígitos são verificadores.
            var firstVerifyingDigit = digits[9];
            var secondVerifyingDigit = digits[10];

            // Os dois dígitos verificadores são calculados de forma parecida,
            // porém a sequência para conferir o segundo considera o primeiro.

            var rem1 = Remainder(digits, 9); // Apenas os nove primeiros dígitos.
            if (firstVerifyingDigit != rem1) return new ValidationResult(ErrorMessage ?? InvalidMessage);

            var rem2 = Remainder(digits, 10); // Os nove dígitos e o primeiro dígito verificador.
            if (secondVerifyingDigit != rem2) return new ValidationResult(ErrorMessage ?? InvalidMessage);

            // Se nada estiver errado, então o CPF é válido.
            return ValidationResult.Success;
        }

        private static int Remainder(IEnumerable<int> digits, int count)
        {
            // Multiplicar cada dígito (até antes do primeiro dígito
            // verificador) por (11), 10, 9, ..., 3, 2.
            //
            // Em seguida, calcular o resto da divisão por onze.
            var rem = digits
                .Zip(Enumerable.Range(2, count).Reverse(), (digit, num) => digit * num)
                .Sum() % 11;

            // Se o resto da divisão for menor do que dois, deve-se retornar
            // zero; caso contrário, subtrai-se esse valor de onze.
            return rem < 2 ? 0 : 11 - rem;
        }
    }
}
