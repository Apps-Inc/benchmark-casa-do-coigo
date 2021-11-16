import FluentKit

struct CreateCategoryTable: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Categoria.schema)
            .id()
            .field("nome", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Categoria.schema).delete()
    }
}