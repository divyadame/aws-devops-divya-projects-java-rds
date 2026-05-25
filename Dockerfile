FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS build

RUN dnf --setopt=install_weak_deps=False install -q -y \
    java-17-amazon-corretto-headless \
    maven \
    which \
    tar \
    gzip \
    && \
    dnf clean all

VOLUME /tmp
WORKDIR /

COPY pom.xml .
COPY .mvn .mvn
COPY mvnw .

RUN --mount=type=cache,target=/root/.m2 \
     ./mvnw dependency:resolve-plugins dependency:resolve -B -q

COPY ./src ./src

ARG MAVEN_OPTS="-Xmx2048m"
ENV MAVEN_OPTS=$MAVEN_OPTS
RUN --mount=type=cache,target=/root/.m2 \
     ./mvnw -DskipTests clean package -B -T 1C && \
    mv target/*.jar /app.jar

#Package stage

FROM public.ecr.aws/amazonlinux/amazonlinux:2023

RUN dnf --setopt=install_weak_deps=False install -q -y \
    java-17-amazon-corretto-headless \
    shadow-utils \
    && \
    dnf clean all

RUN dnf -q -y swap libcurl-minimal libcurl-full \
    && dnf -q -y swap curl-minimal curl-full


ENV appuser=appuser
ENV UID=1000
ENV GID=1000

RUN groupadd -g ${GID} ${appuser} && \
useradd -u ${UID} -g ${GID} -m -d /home/appuser -s /sbin/nologin ${appuser}

ENV JAVATOOLOPTIONS=
ENV SPRING_PROFILES_ACTIVE=Prod

WORKDIR /app
USER ${appuser}

COPY --chown=${appuser}:${appuser} --from=build /app.jar /app/app.jar

EXPOSE 8080

ENTRYPOINT [ "java", "-jar", "/app/app.jar" ]






