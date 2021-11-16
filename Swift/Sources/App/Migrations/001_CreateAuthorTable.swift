import Fluent

struct CreateAuthorTable: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Author.schema)
        .id()
        .field("email", .string, .required)
        .field("nome", .string, .required)
        .field("dataCriacao", .date , .required)
        .field("descricao", .string , .required)
      .create()
  }
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema(Author.schema).delete()
  }
}