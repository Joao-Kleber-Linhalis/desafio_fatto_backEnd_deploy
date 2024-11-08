# Fase de build para compilar a aplicação
FROM ubuntu:latest AS build

RUN apt-get update
RUN apt-get install openjdk-21-jdk -y
RUN apt-get install maven -y
COPY . .

RUN mvn clean install -DskipTests

# Fase de execução com PostgreSQL e aplicação
FROM ubuntu:latest

# Instalar PostgreSQL
RUN apt-get update && apt-get install -y postgresql postgresql-contrib

# Expor as portas necessárias
EXPOSE 8080 5432

# Variáveis de ambiente para o PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=123
ENV POSTGRES_DB=desafio-fatto-db

# Iniciar o PostgreSQL e criar o banco de dados
RUN /etc/init.d/postgresql start && \
    sudo -u postgres psql -c "CREATE DATABASE desafio_fatto_db"

# Copiar o arquivo JAR compilado da fase de build
COPY --from=build /target/back-end.desafio-0.0.1-SNAPSHOT.jar /app.jar

# Comando para iniciar o PostgreSQL e depois a aplicação
CMD service postgresql start && java -jar /app.jar