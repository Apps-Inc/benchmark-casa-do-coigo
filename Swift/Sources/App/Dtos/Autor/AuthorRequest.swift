import Vapor

struct AuthorRequest : Content{
    let nome: String
    let email: String
    let descricao: String
    
    func castToAutor() -> Author {
        return Author(nome: nome, email: email, descricao: descricao)
    }
}

extension AuthorRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("nome", as: String.self, is: !.empty && .count(...50))
        validations.add("email", as: String.self, is: !.empty && .email)
        validations.add("descricao", as: String.self, is: !.empty && .count(...400))
    }
}
