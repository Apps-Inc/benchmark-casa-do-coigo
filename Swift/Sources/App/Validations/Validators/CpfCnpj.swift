import Vapor

extension Validator where T == String {
    public static var cpfCnpj: Validator<T> {
        .init {
            ValidatorResults.CpfCnpj(isCpfCnpj: isCpf($0) || isCnpj($0))
        }
    }
}

fileprivate func isCpf(_ str: String) -> Bool {
    let digits = str.filter(\.isNumber).map {
        Int($0.asciiValue! - Character("0").asciiValue!)
    }

    return digits.count == 11 &&
        digits.allSatisfy({ $0 >= 0 && $0 <= 9 }) &&
        digits[9] == calcVerifierDigit(cpf: digits, 10) &&
        digits[10] == calcVerifierDigit(cpf: digits, 11)
}

fileprivate func isCnpj(_ str: String) -> Bool {
    let digits = str.filter(\.isNumber).map {
        Int($0.asciiValue! - Character("0").asciiValue!)
    }

    return digits.count == 14 &&
        digits.allSatisfy({ $0 >= 0 && $0 <= 9 }) &&
        digits[12] == calcVerifierDigit(cnpj: digits, isSecondVerifier: false) &&
        digits[13] == calcVerifierDigit(cnpj: digits, isSecondVerifier: true)
}

fileprivate func calcVerifierDigit(cpf cpfDigits: [Int], _ rangeEnd: Int) -> Int {
    let verifierDigit = zip((2 ... rangeEnd).reversed(), cpfDigits)
        .map { $0 * $1 }
        .reduce(0, +) % 11

    return verifierDigit < 2
        ? 0
        : 11 - verifierDigit
}

fileprivate func calcVerifierDigit(cnpj cpfDigits: [Int], isSecondVerifier: Bool) -> Int {
    let multipliers = (isSecondVerifier ? [6] : []) + [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
    let verifierDigit = zip(multipliers, cpfDigits)
        .map { $0 * $1 }
        .reduce(0, +) % 11

    return verifierDigit < 2
        ? 0
        : 11 - verifierDigit
}

extension ValidatorResults {
    public struct CpfCnpj {
        public let isCpfCnpj: Bool
    }
}

extension ValidatorResults.CpfCnpj: ValidatorResult {

    public var isFailure: Bool {
        !self.isCpfCnpj
    }

    public var successDescription: String? {
        "is a valid CPF or CNPJ"
    }

    public var failureDescription: String? {
        "isn't a valid CPF or CNPJ"
    }
}
