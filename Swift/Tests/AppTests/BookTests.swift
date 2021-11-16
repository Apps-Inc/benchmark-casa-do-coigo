@testable

import App
import XCTVapor

final class BookTests: XCTestCase {

    let app = Application(.testing)

    override func setUpWithError() throws {
        try configure(app)
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }

    func testNewBook() throws {

        try app.test(.POST, "book/new", beforeRequest: { req in
            try req.content.encode(NovoLivroRequest(
                titulo: "",
                resumo: "",
                sumario: "",
                preco: 0,
                numPaginas: 0,
                ISBN: "",
                dataPublicacao: Date(),
                categoria: UUID(),
                autor: UUID()
            ))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })

        try Categoria(nome: "fantasia").create(on: app.db).wait()
        let newCategory = try app.db.query(Categoria.self)
            .filter(\.$nome, .equal, "fantasia")
            .first()
            .wait()!

        try Author(
            nome: "Philip Pullman",
            email: "mail@pullman.com",
            descricao: "His Dark Material Themes"
        ).create(on: app.db).wait()
        let newAuthor = try app.db.query(Author.self)
            .filter(\.$email, .equal, "mail@pullman.com")
            .first()
            .wait()!

        try app.test(.POST, "book/new", beforeRequest: { req in
            try req.content.encode(NovoLivroRequest(
                titulo: "The Secret Commonwealth",
                resumo: "alskdjlaksjdlkasd",
                sumario: "Return to the world of His Dark Materials",
                preco: 100.61,
                numPaginas: 656,
                ISBN: "‎978-0553510669",
                dataPublicacao: Calendar.current.date(
                    byAdding: DateComponents(year: 2),
                    to: Date()
                )!,
                categoria: newCategory.id!,
                autor: newAuthor.id!
            ))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)

            let newBook = try res.content.decode(NovoLivroResponse.self)
            XCTAssertEqual(newBook.titulo, "The Secret Commonwealth")
            XCTAssertEqual(newBook.ISBN, "‎978-0553510669")
        })
    }

    func testNewBookDate() throws {

        try Categoria(nome: "fantasia").create(on: app.db).wait()
        let newCategory = try app.db.query(Categoria.self)
            .filter(\.$nome, .equal, "fantasia")
            .first()
            .wait()!

        try Author(
            nome: "Philip Pullman",
            email: "mail@pullman.com",
            descricao: "His Dark Material Themes"
        ).create(on: app.db).wait()
        let newAuthor = try app.db.query(Author.self)
            .filter(\.$email, .equal, "mail@pullman.com")
            .first()
            .wait()!

        var 📚 = NovoLivroRequest(
            titulo: "The Secret Commonwealth",
            resumo: "alskdjlaksjdlkasd",
            sumario: "Return to the world of His Dark Materials",
            preco: 100.61,
            numPaginas: 656,
            ISBN: "‎978-0553510669",
            dataPublicacao: Calendar.current.date(
                byAdding: DateComponents(year: -2),
                to: Date()
            )!,
            categoria: newCategory.id!,
            autor: newAuthor.id!
        )

        try app.test(.POST, "book/new", beforeRequest: { req in
            try req.content.encode(📚)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })

        📚.dataPublicacao = Calendar.current.date(
            byAdding: DateComponents(year: 2),
            to: Date()
        )!

        try app.test(.POST, "book/new", beforeRequest: { req in
            try req.content.encode(📚)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
    }

    func testDuplicatedBook() throws {

        try Categoria(nome: "fantasia").create(on: app.db).wait()
        let newCategory = try app.db.query(Categoria.self)
            .filter(\.$nome, .equal, "fantasia")
            .first()
            .wait()!

        try Author(
            nome: "Philip Pullman",
            email: "mail@pullman.com",
            descricao: "His Dark Material Themes"
        ).create(on: app.db).wait()
        let newAuthor = try app.db.query(Author.self)
            .filter(\.$email, .equal, "mail@pullman.com")
            .first()
            .wait()!

        let newBook = NovoLivroRequest(
            titulo: "The Secret Commonwealth",
            resumo: "alskdjlaksjdlkasd",
            sumario: "Return to the world of His Dark Materials",
            preco: 100.61,
            numPaginas: 656,
            ISBN: "‎978-0553510669",
            dataPublicacao: Calendar.current.date(
                byAdding: DateComponents(year: 2),
                to: Date()
            )!,
            categoria: newCategory.id!,
            autor: newAuthor.id!
        )

        try app.test(.POST, "book/new", beforeRequest: { req in
            try req.content.encode(newBook)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })

        try app.test(.POST, "book/new", beforeRequest: { req in
            try req.content.encode(newBook)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }

    func testBookList() throws {

        let autor = Author(nome: "Uncle Bob", email: "bob@gmail.com", descricao: "-")
        _ = autor.create(on: app.db)
        let categoria = Categoria(.init(nome: "Go Horse"))
        _ = categoria.create(on: app.db)

        let livrosSalvos: [Livro] = [
            Livro(.init(titulo: "Clean code", resumo: "Como vc deveria estar fazendo", sumario: "👀", preco: 99.99, numPaginas: 200, ISBN: "‎978-0553510669", dataPublicacao: Date(), categoria: categoria.id!, autor: autor.id!)),
            Livro(.init(titulo: "XP in pratice", resumo: "XP", sumario: "⏩⏩⏩", preco: 99.99, numPaginas: 200, ISBN: "‎978-0553510669", dataPublicacao: Date(), categoria: categoria.id!, autor: autor.id!))
        ]
        livrosSalvos.forEach{ let _ = $0.create(on: app.db) }

        try app.test(.GET, "book/list", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)

            let livros = try res.content.decode(Array<NovoLivroResponse>.self)
            XCTAssertEqual(livros.count, livrosSalvos.count)

            livrosSalvos.forEach { livroSalvo in
                XCTAssertTrue(livros.contains {$0.id == livroSalvo.id!})
            }
        })
    }

    func testDetailsBook() throws{

        try app.test(.POST, "book/new", beforeRequest: { req in
            try req.content.encode(NovoLivroRequest(
                titulo: "",
                resumo: "",
                sumario: "",
                preco: 0,
                numPaginas: 0,
                ISBN: "",
                dataPublicacao: Date(),
                categoria: UUID(),
                autor: UUID()
            ))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })

        try Categoria(nome: "fantasia").create(on: app.db).wait()
        let newCategory = try app.db.query(Categoria.self)
            .filter(\.$nome, .equal, "fantasia")
            .first()
            .wait()!

        try Author(
            nome: "Philip Pullman",
            email: "mail@pullman.com",
            descricao: "His Dark Material Themes"
        ).create(on: app.db).wait()
        let newAuthor = try app.db.query(Author.self)
            .filter(\.$email, .equal, "mail@pullman.com")
            .first()
            .wait()!

        try Livro(.init(
                titulo: "The Secret Commonwealth",
                resumo: "alskdjlaksjdlkasd",
                sumario: "Return to the world of His Dark Materials",
                preco: 100.61,
                numPaginas: 656,
                ISBN: "‎978-0553510669",
                dataPublicacao: Date(),
                categoria: newCategory.id!,
                autor: newAuthor.id!)
            ).create(on: app.db).wait()


            let newBook = try app.db.query(Livro.self)
            .filter(\.$titulo, .equal, "The Secret Commonwealth")
            .first()
            .wait()!


        try app.test(.GET, "book/details/\(newBook.id!)", afterResponse: { res in
            XCTAssertEqual(res.status, .ok)

            let detalhes = try res.content.decode(LivroDetalhesResponse.self)
            XCTAssertNotNil(detalhes)
            XCTAssertEqual(detalhes.titulo,  "The Secret Commonwealth")
        })


    }
}
