import Vapor

func routes(_ app: Application) throws {
    app.post("author", "new", use: AuthorController.cadastrarNovoAutor)

    app.post("category", "new", use: CategoriaController.cadastrarNovaCategoria)

    app.post("book", "new", use: BookController.cadastrarNovoLivro)


    app.get("book", "details",":id", use: BookController.detalhesLivro)

    app.get("book", "list", use: BookController.buscarLivros)

    app.post("state", "new", use: EstadoController.cadastrarNovoEstado)

    app.post("country", "new", use: PaisController.cadastrarNovoPais)

    app.post("order", "new", use: CompraController.cadastrarNovaCompra)
}
