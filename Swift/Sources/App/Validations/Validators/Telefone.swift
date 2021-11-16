import Vapor

extension Validator where T == String {
    public static var telefone: Validator<T> {
        .init {
            ValidatorResults.Telefone(isValidTelefone: $0.range(of: #"^\(?\d{2}[)-]?\s?\d{4,5}[-\s]?\d{4}$"#, options: .regularExpression) != nil)
        }
    }
}

extension ValidatorResults {
    public struct Telefone {
        public let isValidTelefone: Bool
    }
}

extension ValidatorResults.Telefone: ValidatorResult {

    public var isFailure: Bool {
        !self.isValidTelefone
    }

    public var successDescription: String? {
        "is a valid telephone"
    }

    public var failureDescription: String? {
        "isn't a valid telephone"
    }
}
