import Vapor
struct PaisResponse : Content{
    var id : UUID
    var nome : String

    init(pais: Pais) {
        self.id = pais.id!
        self.nome = pais.nome
    }
}
