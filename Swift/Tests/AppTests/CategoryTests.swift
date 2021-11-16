@testable

import App
import XCTVapor

final class CategoryTests: XCTestCase {

    let app = Application(.testing)

    override func setUpWithError() throws {
        try configure(app)
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }

    func testNewCategory() throws {

        try app.test(.POST, "category/new", beforeRequest: { req in
            try req.content.encode(NovaCategoriaRequest(nome: "fantasia"))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)

            let newCategory = try res.content.decode(NovaCategoriaResponse.self)
            XCTAssertEqual(newCategory.nome, "fantasia")
        })
    }

    func testDuplicateCategory() throws {

        let newCat = NovaCategoriaRequest(nome: "fantasia")

        try app.test(.POST, "category/new", beforeRequest: { req in
            try req.content.encode(newCat)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })

        try app.test(.POST, "category/new", beforeRequest: { req in
            try req.content.encode(newCat)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .badRequest)
        })
    }
}
