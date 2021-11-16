@testable

import App
import XCTVapor

final class AuthorTests: XCTestCase {
    let app: Application = Application(.testing)

    override func setUpWithError() throws {
        try configure(app)
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }

    func testNewAuthor() throws {

        try app.test(.POST, "author/new", beforeRequest: { req in
            try req.content.encode(AuthorRequest(
                nome: "",
                email: "Thomas@gmail.com",
                descricao: "tumadre"
            ))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })

        try app.test(.POST, "author/new", beforeRequest: { req in
            try req.content.encode(AuthorRequest(
                nome: "Thomas",
                email: "Thomas@gmail.com",
                descricao: "tumadre"
            ))
        }, afterResponse: { res in
            let response = try res.content.decode(AuthorResponse.self)
            let authorQuery = app.db.query(Author.self)
                    .filter(\.$id, .equal, response.id)
                    .first()

            XCTAssertEqual(res.status, .ok)
            Task {
                let result = try await authorQuery.get()
                XCTAssertNotNil(result)
            }
        })
    }

    func testDuplicateAuthorEmail() throws {

        let email = "Thomas@gmail.com"

        try app.test(.POST, "author/new", beforeRequest: { req in
            try req.content.encode(AuthorRequest(
                nome: "Thomas",
                email: email,
                descricao: "tumadre"
            ))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })

        try app.test(.POST, "author/new", beforeRequest: { req in
            try req.content.encode(AuthorRequest(
                nome: "Le Guin",
                email: email,
                descricao: "Mostly Earthsea"
            ))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
}