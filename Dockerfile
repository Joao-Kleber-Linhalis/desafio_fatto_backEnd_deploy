FROM openjdk:21-jdk-slim AS BUILD
WORKDIR /app
COPY . /app
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean;
RUN mvn clean package -X -DskipTests
RUN mvn spring-boot:run
EXPOSE 8080