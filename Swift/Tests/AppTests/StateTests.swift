@testable

import App
import XCTVapor

final class StateTests: XCTestCase {
    let app: Application = Application(.testing)

    override func setUpWithError() throws {
        try configure(app)
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }

    func testNewState() throws {

        let pais = Pais(nome: "Brazil")
        _ = pais.create(on: app.db)

        try app.test(.POST, "state/new", beforeRequest: { req in
            try req.content.encode(EstadoRequest(nome: "São Paulo", pais: pais.id!))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
             let newEstado = try res.content.decode(EstadoResponse.self)

            let estado = try app.db.query(Estado.self)
                    .filter(\.$id, .equal, newEstado.id)
                    .first()
                    .wait()

            print(estado ?? "nmul" )

            XCTAssertEqual(res.status, .ok)
            XCTAssertNotNil(estado)
            if let resultSafe = estado {
                XCTAssertEqual(resultSafe.nome, "São Paulo")
            }
        })
    }
}