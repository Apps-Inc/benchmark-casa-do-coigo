
import Fluent
import Vapor



final class PaisController {

    static func cadastrarNovoPais(_ req: Request) throws -> some ResponseEncodable {
        try PaisRequest.validate(content: req)
        
        let dto = try req.content.decode(PaisRequest.self)
        let pais = dto.castToPais()

        _ = pais.create(on: req.db)
        return PaisResponse(pais: pais)
    }    
}
