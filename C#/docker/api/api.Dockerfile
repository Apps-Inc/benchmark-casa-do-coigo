# Argumentos usados durante a construção dessa imagem.
#
# Ao contrário de ENV, cada ARG só dura até o final do escopo dele, então em
# cada etapa é necessário renová-los. O valor padrão, contudo, só precisa ser
# escrito uma vez.

# Debug ou Release
ARG BUILD_TYPE=Debug
ARG HOSTING_ENV=Development

# O nome do projeto a ser construído.
ARG PROJECT_NAME

# A porta HTTP a ser exposta por esse container.
ARG EXPOSED_PORT_HTTP

# O arquivo de projeto associado ao $PROJECT_NAME.
ARG PROJECT_FILE="${PROJECT_NAME}/${PROJECT_NAME}.csproj"

# Pastas dentro dos containers para diversos passos.
ARG SRC_DIR=/app/src
ARG TESTS_DIR=/app/tests
ARG BUILD_DIR=/app/build
ARG PUBLISH_DIR=/app/publish
ARG RUN_DIR=/app/run

# Primeira etapa: restaurar e construir o projeto.
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS api_builder

ARG BUILD_TYPE
ARG PROJECT_FILE
ARG SRC_DIR
ARG TESTS_DIR
ARG BUILD_DIR

WORKDIR $SRC_DIR
COPY ./src $SRC_DIR
COPY ./tests $TESTS_DIR
RUN dotnet restore $PROJECT_FILE
RUN dotnet build $PROJECT_FILE -c $BUILD_TYPE -o $BUILD_DIR

# Segunda etapa: publicar o projeto (copiar os arquivos contruídos e as
# dependências para um mesmo lugar).
FROM api_builder AS api_publisher

ARG BUILD_TYPE
ARG PROJECT_FILE
ARG PUBLISH_DIR

RUN dotnet publish $PROJECT_FILE -c $BUILD_TYPE -o $PUBLISH_DIR

# Terceira etapa: rodar o projeto.
FROM mcr.microsoft.com/dotnet/aspnet:5.0

ARG PROJECT_NAME
ARG RUN_DIR
ARG PUBLISH_DIR
ARG HOSTING_ENV
ARG EXPOSED_PORT_HTTP

ENV ASPNETCORE_URLS http://+:${EXPOSED_PORT_HTTP}
ENV ASPNETCORE_ENVIRONMENT ${HOSTING_ENV}

WORKDIR $RUN_DIR
EXPOSE ${EXPOSED_PORT_HTTP}

# Criar um novo grupo e um novo usuário pertencente a esse grupo.
RUN groupadd api && useradd -g api api

# The saga of Eu Realmente Quero Uma Dockerfile Genérica.

# ENTRYPOINT não expande ARGs, mas RUN sim. Assim, criar um script com o
# comando a ser executado.
#
# Esse script será criado como root pois o novo usuário não tem permissão de
# escrita nessa pasta. Seria inútil se o usuário não pudesse rodar esse
# arquivo, então trocar de dono logo em seguida.
RUN printf "#!/bin/sh\ndotnet ${PROJECT_NAME}.dll\n" > init.sh
RUN chown api:api init.sh

# Copiar os arquivos gerados no passo anterior já trocando de dono para o
# usuário.
COPY --from=api_publisher --chown=api:api $PUBLISH_DIR $RUN_DIR

# A partir daqui o root não é mais necessário.
USER api
ENTRYPOINT [ "sh", "init.sh" ]