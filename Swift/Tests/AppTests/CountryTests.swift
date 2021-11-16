@testable

import App
import XCTVapor

final class CountryTests: XCTestCase {
    let app: Application = Application(.testing)

    override func setUpWithError() throws {
        try configure(app)
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }

    func testNewCountry() throws {

        try app.test(.POST, "country/new", beforeRequest: { req in
            try req.content.encode(["nome": "Brazil"])
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)

            let cadastrarNovoPais = try res.content.decode(PaisResponse.self)
            XCTAssertEqual(cadastrarNovoPais.nome, "Brazil")

            let query = app.db.query(Pais.self)
                    .filter(\.$id, .equal, cadastrarNovoPais.id)
                    .first()

            XCTAssertEqual(res.status, .ok)
            Task {
                let result = try await query.get()
                XCTAssertNotNil(result)
                if let resultSafe = result {
                    XCTAssertEqual(resultSafe.nome, "Brazil")
                }
            }
        })
    }
}