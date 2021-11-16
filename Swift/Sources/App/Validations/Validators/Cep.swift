import Vapor

extension Validator where T == String {
    public static var cep: Validator<T> {
        .init {
            ValidatorResults.Cep(isValidCep: $0.range(of: "^\\d{5}-?\\d{3}$", options: .regularExpression) != nil)
        }
    }
}

extension ValidatorResults {
    public struct Cep {
        public let isValidCep: Bool
    }
}

extension ValidatorResults.Cep: ValidatorResult {

    public var isFailure: Bool {
        !self.isValidCep
    }

    public var successDescription: String? {
        "is a valid CEP"
    }

    public var failureDescription: String? {
        "isn't a valid CEP"
    }
}
