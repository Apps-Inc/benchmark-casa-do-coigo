import Vapor

struct EstadoRequest : Content{
    let nome: String
    let pais: UUID
    
    func castToEstado() -> Estado {
        return Estado(nome: nome, pais: pais)
    }
}

extension EstadoRequest: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("nome", as: String.self, is: !.empty && .count(...50))
    }
}
