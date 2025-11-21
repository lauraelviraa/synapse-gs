# Use the Eclipse Temurin JDK (alpine)
FROM eclipse-temurin:21-jdk-alpine

# Create and change to the app directory.
WORKDIR /app

# Copy the whole project into the image
COPY . .

# Make the Maven wrapper executable
RUN chmod +x mvnw

# Build the app using the Maven wrapper (no need for a global 'mvn')
# - skip tests to speed up the build (remove -DskipTests if you want to run tests)
RUN ./mvnw -DoutputFile=target/mvn-dependency-list.log -B -DskipTests clean package

# Ensure ojdbc is available in /app/lib (we copy it as part of the repo)
# At runtime we add it to the classpath together with the Quarkus runner jar.
EXPOSE 8080

# Run Quarkus with the Oracle driver on the classpath.
# Quarkus runner entrypoint class is io.quarkus.bootstrap.runner.QuarkusEntryPoint
CMD ["sh", "-c", "java -cp /app/lib/ojdbc8.jar:target/quarkus-app/quarkus-run.jar io.quarkus.bootstrap.runner.QuarkusEntryPoint"]
