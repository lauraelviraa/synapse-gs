# Build stage: use an official Maven image that exists on Docker Hub
FROM maven:3.8.8-openjdk-17 AS build
WORKDIR /app

# Copy project files and build
COPY . .
RUN mvn -B -DskipTests clean package

# Run stage: smaller JRE image for runtime
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Copy built quarkus-app from build stage
COPY --from=build /app/target/quarkus-app /app/target/quarkus-app

# Copy Oracle driver (must exist in repo at lib/ojdbc8.jar)
COPY lib/ojdbc8.jar /app/lib/ojdbc8.jar

EXPOSE 8080

# Run with ojdbc on the classpath
CMD ["sh", "-c", "java -cp /app/lib/ojdbc8.jar:/app/target/quarkus-app/quarkus-run.jar io.quarkus.bootstrap.runner.QuarkusEntryPoint"]
