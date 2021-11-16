import FluentKit

struct CreatePaisTable: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Pais.schema)
            .id()
            .field("nome", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Pais.schema).delete()
    }
}