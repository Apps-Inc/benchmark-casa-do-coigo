import Vapor
import FluentSQLiteDriver

public func configure(_ app: Application) throws {
    switch app.environment {
    case .testing:
        app.databases.use(.sqlite(.memory), as: .sqlite)

    default:
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }

    app.migrations.add(CreateBookTable(), to: .sqlite)
    app.migrations.add(CreateAuthorTable(), to: .sqlite)
    app.migrations.add(CreateCategoryTable(), to: .sqlite)
    app.migrations.add(CreatePaisTable(), to: .sqlite)
    app.migrations.add(CreateEstadoTable(), to: .sqlite)
    app.migrations.add(CreateCompraTable(), to: .sqlite)

    try app.autoMigrate().wait()
    try routes(app)
}
