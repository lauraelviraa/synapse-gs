# Build stage: usa imagem maven para compilar e instalar ojdbc localmente
FROM maven:3.8.6-jdk-11 AS build
WORKDIR /app

# Copia o driver primeiro (para poder instalar no repo local)
COPY lib/ojdbc8.jar lib/ojdbc8.jar

# Instala o driver Oracle no repositório local do maven dentro do container
RUN mvn -B install:install-file \
    -Dfile=lib/ojdbc8.jar \
    -DgroupId=com.oracle \
    -DartifactId=ojdbc8 \
    -Dversion=19.3.0.0 \
    -Dpackaging=jar

# Agora copia o resto do projeto e constrói
COPY . .
RUN mvn -B -DskipTests clean package

# Runtime stage (imagem leve)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Ajuste o caminho de cópia conforme seu build; aqui assumimos quarkus-app
COPY --from=build /app/target/quarkus-app /app/target/quarkus-app
COPY lib/ojdbc8.jar /app/lib/ojdbc8.jar

EXPOSE 8080
CMD ["sh", "-c", "java -cp /app/lib/ojdbc8.jar:/app/target/quarkus-app/quarkus-run.jar io.quarkus.bootstrap.runner.QuarkusEntryPoint"]
