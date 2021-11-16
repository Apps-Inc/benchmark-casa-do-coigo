import Vapor

final class BookController {
    static func cadastrarNovoLivro(req: Request) async throws -> some AsyncResponseEncodable {
        try NovoLivroRequest.validate(content: req)

        let newBook = Livro(try req.content.decode(NovoLivroRequest.self))

        let duplicatedBookQuery = try await req.db
            .query(Livro.self)
            .filter(\.$titulo, .equal, newBook.titulo)
            .first()
        if nil != duplicatedBookQuery {
            throw Abort(.badRequest, reason: "Livro \"\(newBook.titulo)\" já cadastrado")
        }

        let categoryNotRegistered = try await req.db
            .query(Categoria.self)
            .filter(\.$id, .equal, newBook.categoria)
            .first() == nil
        if categoryNotRegistered {
            throw Abort(.badRequest, reason: "Categoria \"\(newBook.categoria)\" não cadastrada")
        }

        let authorNotRegistered = try await req.db
            .query(Author.self)
            .filter(\.$id, .equal, newBook.autor)
            .first() == nil
        if authorNotRegistered {
            throw Abort(.badRequest, reason: "Autor \"\(newBook.autor)\" não cadastrado")
        }

        _ = try await newBook.create(on: req.db)
        return NovoLivroResponse(newBook)
    }



    static func detalhesLivro(req: Request) async throws -> some AsyncResponseEncodable {
        let idDoLivro = UUID(req.parameters.get("id")!)!
        let detailsBook = try await req.db
            .query(Livro.self)
            .filter(\.$id, .equal, idDoLivro)
            .first()
        

        guard let livro = detailsBook else {
            throw Abort(.notFound, reason: "Livro \"\(idDoLivro)\" não encontrado.")
        }

        let categoria = try await req.db
            .query(Categoria.self)
            .filter(\.$id, .equal, livro.categoria)
            .first()

        let autor = try await req.db
            .query(Author.self)
            .filter(\.$id, .equal, livro.autor)
            .first()

        return LivroDetalhesResponse(titulo: livro.titulo, resumo: livro.resumo,
                                     sumario: livro.sumario, preco: livro.preco,
                                     dataPublicacao: livro.dataPublicacao,
                                     ISBN: livro.ISBN, autor: autor!, categoria: categoria!,
                                     numPaginas: livro.numPaginas)


    }

    static func buscarLivros(req: Request) async throws -> some AsyncResponseEncodable {
        return try await Livro.query(on: req.db).all().map(NovoLivroResponse.init)

    }
}
