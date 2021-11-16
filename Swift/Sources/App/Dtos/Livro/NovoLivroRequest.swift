import Vapor

struct NovoLivroRequest: Content {
    var titulo: String
    var resumo: String
    var sumario: String
    var preco: Double
    var numPaginas: Int
    var ISBN: String
    var dataPublicacao: Date

    var categoria: UUID
    var autor: UUID
}

extension NovoLivroRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("titulo", as: String.self, is: !.empty)
        validations.add("resumo", as: String.self, is: !.empty && .count(...500))
        validations.add("sumario", as: String.self, is: !.empty)
        validations.add("preco", as: Double.self, is: .range(20...))
        validations.add("numPaginas", as: Int.self, is: .range(100...))
        validations.add("ISBN", as: String.self, is: !.empty)
        validations.add("dataPublicacao", as: Date.self, is: .isFuture)
    }
}

extension Validator where T == Date {
    public static var isFuture: Validator<T> {
        .init { data in
            ValidatorResults.Date(isFuture: data > Date())
        }
    }
}

extension ValidatorResults {
    public struct Date {
        public let isFuture: Bool
    }
}

extension ValidatorResults.Date: ValidatorResult {
    public var isFailure: Bool {
        !self.isFuture
    }

    public var successDescription: String? {
        "is in the future"
    }

    public var failureDescription: String? {
        "is not in the future"
    }
}