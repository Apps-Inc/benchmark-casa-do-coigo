import Vapor

struct CompraRequest : Content{
    var email: String
    var nome: String
    var sobrenome: String
    var documento: String
    var endereco: String
    var complemento: String
    var cidade: String
    var estado: UUID?
    var pais: UUID
    var telefone: String
    var cep: String

    
    func castToCompra() -> Compra {
        return Compra(
            email: email,
            nome: nome,
            sobrenome: sobrenome,
            documento: documento,
            endereco: endereco,
            complemento: complemento,
            cidade: cidade,
            estado: estado,
            pais: pais,
            telefone: telefone,
            cep: cep
        )
    }
}

extension CompraRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("nome", as: String.self, is: !.empty && .count(...50))
        validations.add("sobrenome", as: String.self, is: !.empty && .count(...50))
        validations.add("documento", as: String.self, is: .cpfCnpj)
        validations.add("endereco",as: String.self, is: !.empty && .count(...50))
        validations.add("complemento",as: String.self, is: !.empty && .count(...50))
        validations.add("cidade",as: String.self, is: !.empty && .count(...50))
        validations.add("telefone",as: String.self, is: !.empty && .telefone)
        validations.add("cep",as: String.self, is: !.empty && .cep)
    }
}
