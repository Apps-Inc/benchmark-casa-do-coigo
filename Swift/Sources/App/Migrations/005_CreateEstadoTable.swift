import FluentKit

struct CreateEstadoTable: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Estado.schema)
            .id()
            .field("nome", .string, .required)
            .field("pais", .uuid, .required, .references("pais", "id"))
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Estado.schema).delete()
    }
}