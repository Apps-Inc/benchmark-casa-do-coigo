import Fluent
import Foundation

final class Livro: Model {
    static let schema = "Livro"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "titulo")
    var titulo: String

    @Field(key: "resumo")
    var resumo: String

    @Field(key: "sumario")
    var sumario: String

    @Field(key: "preco")
    var preco: Double

    @Field(key: "numPaginas")
    var numPaginas: Int

    @Field(key: "ISBN")
    var ISBN: String

    @Field(key: "dataPublicacao")
    var dataPublicacao: Date

    @Field(key: "categoria")
    var categoria: UUID

    @Field(key: "autor")
    var autor: UUID

    init() { }

    init(_ newBook: NovoLivroRequest) {
        self.id = UUID()

        self.titulo = newBook.titulo
        self.resumo = newBook.resumo
        self.sumario = newBook.sumario
        self.preco = newBook.preco
        self.numPaginas = newBook.numPaginas
        self.ISBN = newBook.ISBN
        self.dataPublicacao = newBook.dataPublicacao

        self.categoria = newBook.categoria
        self.autor = newBook.autor
    }
}