import Vapor


struct LivroDetalhesResponse: Content {
    var titulo: String
    var resumo: String
    var sumario: String
    var preco: Double
    var dataPublicacao: Date
    var ISBN: String
    var autor: Author
    var categoria: Categoria
    var numPaginas: Int

    
}
