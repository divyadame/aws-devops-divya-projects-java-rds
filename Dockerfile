FROM eclipse-temurin:17-jre-jammy

ENV JAVA_TOOL_OPTIONS="-XX:+ExitOnOutOfMemoryError"
ENV SPRING_PROFILES_ACTIVE=Prod

# FIX 1: Use Ubuntu-compatible commands to create a system group and user
RUN groupadd -r petclinic && useradd -r -g petclinic petclinic

WORKDIR /app

ARG JAR_FILE=target/*.jar

# FIX 2: Copy files and change ownership while still running as root
COPY --chown=petclinic:petclinic ${JAR_FILE} /app/app.jar

# FIX 3: Switch to the non-root user AFTER setup is complete
USER petclinic

EXPOSE 8080

VOLUME /tmp

ENTRYPOINT ["sh", "-c", "exec java ${JAVA_OPTS} -jar app.jar"]
