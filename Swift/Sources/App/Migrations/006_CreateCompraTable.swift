import FluentKit

struct CreateCompraTable: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Compra.schema)
            .id()
            .field("email", .string, .required)
            .field("nome", .string, .required)
            .field("sobrenome", .string, .required)
            .field("documento", .string, .required)
            .field("endereco", .string, .required)
            .field("complemento", .string, .required)
            .field("cidade", .string, .required)
            .field("estado", .uuid, .references("estado", "id"))
            .field("pais", .uuid, .required, .references("pais", "id"))
            .field("telefone", .string, .required)
            .field("cep", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Compra.schema).delete()
    }
}