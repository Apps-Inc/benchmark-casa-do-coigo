# Desafio 1: Casa do Código

## Setup do Projeto

- Linguagem de programação: [C#](https://docs.microsoft.com/en-us/dotnet/csharp/)
- Tecnologias: [.NET5](https://dotnet.microsoft.com/download/dotnet/5.0)
- Gerenciador de dependência: [NuGet](https://docs.microsoft.com/en-us/nuget/what-is-nuget)

### Minhas configurações

- IDE: JetBrains Rider
- Cliente git: CLI
- Banco de dados: PostgreSQL

## Roadmap

- [x] Cadastro de um novo autor
    - [x] Classe autor contendo:
        - [x] Email (válido e com menos de 50 caracteres)
        - [x] Nome (no máximo 50 caracteres)
        - [x] Descrição (no máximo 400 caracteres)
        - [x] Instante em que foi registrado (não pode ser nulo)
    - [x] Banco de dados
        - [x] Criação da tabela de autores
    - [x] Inserção no banco de dados
- [x] Email autor único
  - [x] Procurar no banco pelo email antes da criação
- [x] Cadastro de uma categoria
- [x] Criação de um validador genérico
- [x] Criar um novo livro
- [x] Exibir lista de livros
- [x] Implementação da página de detalhes do livro
- [ ] Cadastro de país e estado do país
- [ ] Começo do fluxo de pagamento
