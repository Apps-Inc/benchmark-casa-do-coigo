import Vapor

struct NovaCategoriaResponse: Content {
    var nome: String

    init(_ newCategory: Categoria) {
        self.nome = newCategory.nome
    }
}