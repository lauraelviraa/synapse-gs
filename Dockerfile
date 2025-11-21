# Build stage: use official Maven image to build the Quarkus app
FROM maven:3.8.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copy project files and build
COPY . .
# Ensure the local lib (ojdbc) is present; we don't need install-file here
RUN mvn -B -DskipTests clean package

# Run stage: smaller JRE image with the built artifact
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app

# Copy app jar and lib from build stage
COPY --from=build /app/target/quarkus-app /app/target/quarkus-app
# If you have lib/ojdbc8.jar in repo, copy it too
COPY lib/ojdbc8.jar /app/lib/ojdbc8.jar

EXPOSE 8080

# Run with ojdbc on the classpath
CMD ["sh", "-c", "java -cp /app/lib/ojdbc8.jar:/app/target/quarkus-app/quarkus-run.jar io.quarkus.bootstrap.runner.QuarkusEntryPoint"]
