import Fluent
import Foundation

final class Categoria: Model {
    static let schema = "Categoria"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "nome")
    var nome: String

    init() { }

    init(nome: String) {
        self.id = UUID()
        self.nome = nome
    }

    init(_ newCategory: NovaCategoriaRequest) {
        self.id = UUID()
        self.nome = newCategory.nome
    }
}