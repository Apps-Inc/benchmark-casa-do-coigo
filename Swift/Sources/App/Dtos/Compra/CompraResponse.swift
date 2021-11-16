import Vapor

struct CompraResponse : Content{
    var id : UUID

    init(compra: Compra) {
        self.id = compra.id!
    }
}
