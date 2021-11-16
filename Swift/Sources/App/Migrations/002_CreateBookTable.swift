import FluentKit

struct CreateBookTable: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Livro.schema)
            .id()

            .field("titulo", .string, .required)
            .field("resumo", .string, .required)
            .field("sumario", .string, .required)
            .field("preco", .double, .required)
            .field("numPaginas", .int, .required)
            .field("ISBN", .string, .required)
            .field("dataPublicacao", .date, .required)

            .field("categoria", .uuid, .required, .references("categoria", "id"))
            .field("autor", .uuid, .required, .references("author", "id"))

            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Livro.schema).delete()
    }
}