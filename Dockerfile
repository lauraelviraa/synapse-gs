# Use the Eclipse temurin alpine official image
# https://hub.docker.com/_/eclipse-temurin
FROM eclipse-temurin:21-jdk-alpine

# Create and change to the app directory.
WORKDIR /app

# Copy local code to the container image.
COPY . .

# Copy Oracle JDBC driver and install into local maven repo during build
COPY lib/ojdbc8.jar lib/ojdbc8.jar
RUN mvn install:install-file -Dfile=lib/ojdbc8.jar -DgroupId=com.oracle -DartifactId=ojdbc8 -Dversion=19.3.0.0 -Dpackaging=jar


# Build the app.
RUN chmod +x mvnw
RUN ./mvnw -DoutputFile=target/mvn-dependency-list.log -B -DskipTests clean dependency:list install

# Run the quarkus app
CMD ["sh", "-c", "java -jar target/quarkus-app/quarkus-run.jar"]
