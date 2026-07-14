FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /build
COPY src/pom.xml .
COPY src/src src
RUN mvn -q -DskipTests package

FROM eclipse-temurin:17-jre-alpine AS runtime
WORKDIR /app
COPY --from=builder /build/target/*.jar /app/app.jar
RUN addgroup -S app && adduser -S app -G app
USER app
ENV JAVA_TOOL_OPTIONS="-Xmx256m" SPRING_PROFILES_ACTIVE=h2
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
