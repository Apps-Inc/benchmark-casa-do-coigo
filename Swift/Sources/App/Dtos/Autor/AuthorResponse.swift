import Vapor
struct AuthorResponse : Content{
    var id : UUID
    var descricao : String
    var email: String
    var dataCriacao: Date
}
