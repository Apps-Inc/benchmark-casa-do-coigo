
import Fluent
import Foundation
final class Author: Model {
        
    static let schema = "Author"
    
    @ID(key: .id)
    var id:UUID?
    
    @Field(key: "nome")
    var nome: String

    @Field(key: "email")
    var email: String
    
    
   @Field(key: "dataCriacao")
   var dataCriacao: Date
    
    @Field(key: "descricao")
    var descricao: String
    
    init() {  }

    init(nome: String ,email: String, descricao: String) {
        self.id = UUID()
        self.nome = nome
        self.email = email
        self.descricao = descricao
        self.dataCriacao = Date()
    }
    
}

