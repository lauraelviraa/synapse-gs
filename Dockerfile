# --- Build stage (usa imagem maven oficial para compilar) ---
FROM maven:3.8.8-openjdk-17 AS build

WORKDIR /app

# Copia o jar do driver Oracle para instalar no repositório local do maven
# (coloque o ojdbc8.jar em ./lib/ dentro do repositório antes do commit)
COPY lib/ojdbc8.jar lib/ojdbc8.jar

# Instala o driver no repositório maven local dentro do container
RUN mvn -B install:install-file \
    -Dfile=lib/ojdbc8.jar \
    -DgroupId=com.oracle \
    -DartifactId=ojdbc8 \
    -Dversion=19.3.0.0 \
    -Dpackaging=jar

# Copia todo o projeto
COPY . .

# Compila o projeto (gera o jar)
RUN mvn -B -DskipTests clean package

# --- Run stage (imagem menor para executar) ---
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copia o jar gerado pela fase de build (ajuste o caminho se seu jar estiver em target/<nome>.jar)
COPY --from=build /app/target/*-runner.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
