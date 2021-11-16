
import Fluent
import Foundation

final class Compra: Model {

    static let schema = "Compra"

    @ID(key: .id)
    var id:UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "nome")
    var nome: String

    @Field(key: "sobrenome")
    var sobrenome: String

    @Field(key: "documento")
    var documento: String

    @Field(key: "endereco")
    var endereco: String

    @Field(key: "complemento")
    var complemento: String

    @Field(key: "cidade")
    var cidade: String

    @Field(key: "estado")
    var estado: UUID?

    @Field(key: "pais")
    var pais: UUID

    @Field(key: "telefone")
    var telefone: String

    @Field(key: "cep")
    var cep: String

    init() { }

    init(
        email: String, nome: String, sobrenome: String, documento: String,
        endereco: String, complemento: String, cidade: String, estado: UUID? = nil,
        pais: UUID, telefone: String, cep: String
    ) {
        self.id = UUID()
        self.email = email
        self.nome = nome
        self.sobrenome = sobrenome
        self.documento = documento
        self.endereco = endereco
        self.complemento = complemento
        self.cidade = cidade
        self.estado = estado
        self.pais = pais
        self.telefone = telefone
        self.cep = cep
    }
}
