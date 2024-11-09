FROM maven:3.9.9-openjdk-21 AS BUILD
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM openjdk:21-jdk-slim

WORKDIR /app

COPY --from=build /target/back-end.desafio-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
EXPOSE 5432

ENTRYPOINT ["java", "-jar", "app.jar"]