
import Fluent
import Foundation
final class Estado: Model {
        
    static let schema = "Estado"
    
    @ID(key: .id)
    var id:UUID?
    
    @Field(key: "nome")
    var nome: String

    @Field(key: "pais")
    var pais: UUID

    init() {  }

    init(nome: String, pais: UUID) {
        self.id = UUID()
        self.nome = nome
        self.pais = pais
    }
    
}

