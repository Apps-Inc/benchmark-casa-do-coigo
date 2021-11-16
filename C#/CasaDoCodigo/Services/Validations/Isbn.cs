using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace CasaDoCodigo.Services.Validations
{
    public sealed class Isbn : ValidationAttribute
    {
        private const string DefaultNotAStringMessage = "Somente strings podem ser ISBNs";
        private const string DefaultDigitCountMessage = "ISBNs devem possuir 10 ou 13 dígitos";
        private const string DefaultInvalidIsbn10Message = "ISBN-10 inválido";
        private const string DefaultInvalidIsbn13Message = "ISBN-13 inválido";

        // Utilize essa mensagem para sobrescrever quaisquer outras caso não
        // queira especificar o erro encontrado.
        //
        // Esconde ValidationAttribute.ErrorMessage.
        public new string ErrorMessage { get; set; } = null;

        public string NotAStringMessage { get; set; } = DefaultNotAStringMessage;
        public string DigitCountMessage { get; set; } = DefaultDigitCountMessage;
        public string InvalidIsbn10Message { get; set; } = DefaultInvalidIsbn10Message;
        public string InvalidIsbn13Message { get; set; } = DefaultInvalidIsbn13Message;

        protected override ValidationResult IsValid(object value, ValidationContext context)
        {
            if (value is not string isbn) return new ValidationResult(ErrorMessage ?? NotAStringMessage);

            var digits = isbn
                .Where(char.IsDigit)
                .Select(digit => int.Parse(digit.ToString()))
                .ToList();

            return digits.Count switch
            {
                10 => IsValidIsbn10(digits),
                13 => IsValidIsbn13(digits),
                _ => new ValidationResult(DigitCountMessage)
            };
        }

        /*
         * Validação de um ISBN-10, considerando apenas os dígitos. Como
         * exemplo, considere o código ISBN-10 0321563840 (The C++ Programming
         * Language).
         *
         * Primeiramente, enumera-se, da direita para a esquerda, cada um dos
         * dígitos:
         *
         *       0  3  2  1  5  6  3  8  4  0
         *       |  |  |  |  |  |  |  |  |  |
         *      10  9  8  7  6  5  4  3  2  1
         *
         * Multiplica-se, então, cada dígito pelo valor enumerado, e soma-se
         * todos os resultados:
         *
         *     (0 * 10) + (3 * 9) + ... + (4 * 2) + (0 * 1) = 154
         *
         * Por fim, calcula-se o resto da divisão dessa soma por 11. Apenas se
         * for zero o código ISBN-10 é válido:
         *
         *     154 % 11 == 0 ✔
         */
        private ValidationResult IsValidIsbn10(IEnumerable<int> digits) =>
            0 == digits
                .Zip(Enumerable.Range(1, 10).Reverse(), (digit, pos) => digit * pos)
                .Sum() % 11
                ? ValidationResult.Success
                : new ValidationResult(ErrorMessage ?? InvalidIsbn10Message);

        /*
         * Para ISBN-13, o processo é um pouco diferente. Como exemplo,
         * considere o código ISBN-13 9780321563842, do mesmo livro usado no
         * exemplo para o ISBN-10.
         *
         * Enumera-se os dígitos da mesma forma:
         *
         *      9  7  8  0  3  2  1  5  6  3  8  4  2
         *      |  |  |  |  |  |  |  |  |  |  |  |  |
         *     13 12 11 10  9  8  7  6  5  4  3  2  1
         *
         * Porém, nas posições pares, multiplica-se o dígito por 3, e as
         * demais por 1:
         *
         *     (9 * 1) + (7 * 3) + ... + (8 * 3) + (4 * 2) + (2 * 1) = 100
         *
         * Então, calcula-se o resto da divisão dessa soma por 10; como
         * anteriormente, apenas se esse valor for zero o código ISBN-13 é
         * válido:
         *
         *     100 % 10 == 0 ✔
         */
        private ValidationResult IsValidIsbn13(IEnumerable<int> digits) =>
            0 == digits
                .Zip(Enumerable.Range(1, 13), (digit, pos) => digit * (pos % 2 == 0 ? 3 : 1))
                .Sum() % 10
                ? ValidationResult.Success
                : new ValidationResult(ErrorMessage ?? InvalidIsbn13Message);
    }
}
