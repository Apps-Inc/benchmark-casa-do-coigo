import Fluent
import Vapor

final class AuthorController {
    static func cadastrarNovoAutor(_ req: Request) async throws -> some AsyncResponseEncodable {
        try AuthorRequest.validate(content: req)
        
        let newAuthor = (try req.content.decode(AuthorRequest.self)).castToAutor()
        let duplicatedEmailQuery = try await req.db
            .query(Author.self)
            .filter(\.$email, .equal, newAuthor.email)
            .first()

        if nil != duplicatedEmailQuery {
            throw Abort(.badRequest, reason: "Email \"\(newAuthor.email)\" já cadastrado")
        }

        _ = try await newAuthor.create(on: req.db)
        return AuthorResponse(
            id: newAuthor.id!, 
            descricao: newAuthor.descricao, 
            email: newAuthor.descricao, 
            dataCriacao: newAuthor.dataCriacao
        )        
    }    
}
