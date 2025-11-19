# ===============================
# Etapa 1 - Build da aplicação
# ===============================
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copia todo o projeto para dentro da imagem
COPY . .

# Build em modo produção, sem rodar testes
RUN mvn clean package -DskipTests

# ===============================
# Etapa 2 - Runtime (imagem leve)
# ===============================
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copia os artefatos gerados pelo Quarkus (modo fast-jar)
COPY --from=build /app/target/quarkus-app /app/

# Porta padrão interna do Quarkus (Render faz o mapeamento)
EXPOSE 8080

# Sobe a aplicação
CMD ["java", "-jar", "/app/quarkus-run.jar"]
