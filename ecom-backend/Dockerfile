# Stage 1: Build
FROM maven:3.9.4-eclipse-temurin-21 AS builder
WORKDIR /app
COPY ecom-backend/pom.xml ./pom.xml
COPY ecom-backend/src ./src

# Cache Maven dependencies
RUN mvn -B dependency:go-offline

# Build the application
RUN mvn -B clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy JAR from builder
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:5000/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
