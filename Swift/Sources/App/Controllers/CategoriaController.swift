import Vapor

final class CategoriaController {
    static func cadastrarNovaCategoria(req: Request) async throws -> some AsyncResponseEncodable {
        try NovaCategoriaRequest.validate(content: req)

        let newCategory = Categoria(try req.content.decode(NovaCategoriaRequest.self))
        let duplicatedCategoryQuery = try await req.db
            .query(Categoria.self)
            .filter(\.$nome, .equal, newCategory.nome)
            .first()

        if nil != duplicatedCategoryQuery {
            throw Abort(.badRequest, reason: "Categoria \"\(newCategory.nome)\" já cadastrada")
        }

        _ = try await newCategory.create(on: req.db)
        return NovaCategoriaResponse(newCategory)
    }
}