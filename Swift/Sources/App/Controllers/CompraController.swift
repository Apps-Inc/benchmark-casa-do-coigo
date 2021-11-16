import Fluent
import Vapor

final class CompraController {
    static func cadastrarNovaCompra(req: Request) async throws -> some AsyncResponseEncodable {
        try CompraRequest.validate(content: req)
        let newCompra = (try req.content.decode(CompraRequest.self)).castToCompra()

        if newCompra.estado != nil {
            if try await buscarEstado(estado: newCompra.estado!, on: req.db) == nil {
                throw Abort(.badRequest, reason: "Estado \(newCompra.estado!) não cadastrado")
            }
        }

        if (try await buscarPais(pais: newCompra.pais, on: req.db)) == nil {
            throw Abort(.badRequest, reason: "país \(newCompra.pais) não cadastrado")
        }

        _ = try await newCompra.create(on: req.db)
        return CompraResponse(compra: newCompra)
    }

    static func buscarEstado(estado: UUID, on db: Database) async throws -> Estado? {
        return try await db
            .query(Estado.self)
            .filter(\.$id, .equal, estado)
            .first()
    }

    private static func buscarPais(pais: UUID, on db: Database) async throws -> Pais? {
        return try await db
            .query(Pais.self)
            .filter(\.$id, .equal, pais)
            .first()
    }
}
