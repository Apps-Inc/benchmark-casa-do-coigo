import Vapor

struct NovaCategoriaRequest: Content {
    var nome: String
}

extension NovaCategoriaRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("nome", as: String.self, is: !.empty)
    }
}