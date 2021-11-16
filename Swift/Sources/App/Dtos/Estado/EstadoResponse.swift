import Vapor
struct EstadoResponse : Content{
    var id : UUID
    var nome : String
    var pais : UUID

    init(estado: Estado) {
        self.id = estado.id!
        self.nome = estado.nome
        self.pais = estado.pais
    }
}
