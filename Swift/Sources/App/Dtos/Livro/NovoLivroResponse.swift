import Vapor

struct NovoLivroResponse: Content {
    var id : UUID
    var titulo: String
    var resumo: String
    var ISBN: String

    init(_ newBook: Livro) {
        self.id = newBook.id!
        self.titulo = newBook.titulo
        self.resumo = newBook.resumo
        self.ISBN = newBook.ISBN
    }
}