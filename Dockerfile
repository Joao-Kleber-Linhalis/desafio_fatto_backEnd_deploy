# Fase de build para compilar a aplicação
FROM ubuntu:latest AS build

RUN apt-get update

RUN apt-get update && apt-get install openjdk-21-jdk -y
COPY . .

RUN apt-get install maven -y

RUN mvn clean install -DskipTests

# Fase de execução com PostgreSQL e aplicação
FROM library/postgres:latest

# Expor as portas necessárias
EXPOSE 8080 5432

# Configurações do PostgreSQL (se necessário)
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD 123
ENV POSTGRES_DB desafio_fatto_db

FROM openjdk:21-jdk-slim

# Copiar o arquivo JAR compilado da fase de build
COPY --from=build /target/back-end.desafio-0.0.1-SNAPSHOT.jar /app.jar

# Comando para iniciar o PostgreSQL e depois a aplicação
CMD ["sh", "-c", "docker-entrypoint.sh postgres & sleep 10 && java -jar /app.jar"]
