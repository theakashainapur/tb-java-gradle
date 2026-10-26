FROM gradle:8-jdk17 AS builder
WORKDIR /app
COPY . .
RUN gradle build -x test --no-daemon
RUN sh -c 'ls build/libs/*.jar | grep -v plain | head -n 1 | xargs -I{} cp {} /app/app.jar'

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/app.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
