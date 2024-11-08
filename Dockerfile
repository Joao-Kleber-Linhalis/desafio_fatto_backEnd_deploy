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

# Copiar o script de inicialização do banco
COPY init-db.sh /init-db.sh
RUN chmod +x /init-db.sh

# Copiar o arquivo JAR compilado da fase de build
COPY --from=build /target/back-end.desafio-0.0.1-SNAPSHOT.jar /app.jar

# Comando para iniciar o PostgreSQL e depois a aplicação
CMD ["sh", "-c", "/init-db.sh && java -jar /app.jar"]