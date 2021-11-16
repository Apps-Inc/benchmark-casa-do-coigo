
import Fluent
import Foundation
final class Pais: Model {
        
    static let schema = "Pais"
    
    @ID(key: .id)
    var id:UUID?
    
    @Field(key: "nome")
    var nome: String

    init() {  }

    init(nome: String) {
        self.id = UUID()
        self.nome = nome
    }
    
}

