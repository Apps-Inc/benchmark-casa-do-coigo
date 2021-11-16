
import Fluent
import Vapor

final class EstadoController {

    static func cadastrarNovoEstado(_ req: Request) async throws -> some AsyncResponseEncodable {
        try EstadoRequest.validate(content: req)
        let newEstado = (try req.content.decode(EstadoRequest.self)).castToEstado()

        let pais = try await buscarPais(pais: newEstado.pais, db: req.db)
        if pais == nil {
            throw Abort(.badRequest, reason: "Categoria \"\(newEstado.pais)\" não cadastrada")
        }

        _ = try await newEstado.create(on: req.db)
        return EstadoResponse(estado: newEstado)
    }    

    private static func buscarPais(pais: UUID, db: Database) async throws -> Pais? {
        return try await db
            .query(Pais.self)
            .filter(\.$id, .equal, pais)
            .first()
    }
}
