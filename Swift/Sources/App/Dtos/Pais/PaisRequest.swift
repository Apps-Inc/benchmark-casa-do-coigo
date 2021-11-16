import Vapor

struct PaisRequest : Content{
    let nome: String
    
    func castToPais() -> Pais {
        return Pais(nome: nome)
    }
}

extension PaisRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("nome", as: String.self, is: !.empty && .count(...50))
    }
}
