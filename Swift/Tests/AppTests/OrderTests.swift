@testable

import App
import XCTVapor

final class OrderTests: XCTestCase {
    let app: Application = Application(.testing)

    override func setUpWithError() throws {
        try configure(app)
    }

    override func tearDownWithError() throws {
        app.shutdown()
    }

    func testNewOrder() throws {

        let pais = Pais(nome: "Brazil")
        _ = pais.create(on: app.db)

        try app.test(.POST, "order/new", beforeRequest: { req in
            try req.content.encode(CompraRequest(
                email: "string@asd.com",
                nome: "String",
                sobrenome: "String",
                documento: "73.986.866/0001-97",
                endereco: "String",
                complemento: "String",
                cidade: "String",
                pais: pais.id!,
                telefone: "46 91234-1234",
                cep: "65444344"
            ))
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let novaCompra = try res.content.decode(CompraResponse.self)

            XCTAssertNotNil(novaCompra)
            let compra = try app.db.query(Compra.self)
                        .filter(\.$id, .equal, novaCompra.id)
                        .first()
                        .wait()

            XCTAssertNotNil(compra)
        })
    }
}