# Java Application Dockerfiles

This repository contains Dockerfiles for running Java applications using
Java 17 and Java 21.

The Dockerfiles include lightweight JRE images, Distroless images, and
multi-stage Maven builds.

## Dockerfiles

| Dockerfile | Java Version | Build Method | Runtime Image |
|---|---|---|---|
| Dockerfile.java17 | Java 17 | Existing JAR | Eclipse Temurin JRE Alpine |
| Dockerfile.java21 | Java 21 | Existing JAR | Eclipse Temurin JRE Alpine |
| Dockerfile.java17-distroless | Java 17 | Existing JAR | Distroless |
| Dockerfile.java21-distroless | Java 21 | Existing JAR | Distroless |
| Dockerfile.maven-java17 | Java 17 | Maven inside Docker | Eclipse Temurin JRE Alpine |
| Dockerfile.maven-java21 | Java 21 | Maven inside Docker | Eclipse Temurin JRE Alpine |

---

# Prerequisites

For the Dockerfiles that use an existing JAR:

- Java 17 or Java 21
- Maven
- Docker

For the multi-stage Maven Dockerfiles:

- Docker is required
- Maven and Java are provided inside the Docker build image

---

# Project Structure

The Java project should look similar to:

    my-java-app/
    │
    ├── Dockerfile.java17
    ├── Dockerfile.java21
    ├── Dockerfile.java17-distroless
    ├── Dockerfile.java21-distroless
    ├── Dockerfile.maven-java17
    ├── Dockerfile.maven-java21
    ├── pom.xml
    ├── src/
    │   └── ...
    └── target/
        └── application.jar

---

# 1. Java 17 Lightweight JRE

## Build the application

    mvn clean package

This creates the JAR inside the `target` directory.

## Build Docker image

    docker build -f Dockerfile.java17 -t java-app:17 .

## Run container

    docker run -d -p 8080:8080 --name java-app java-app:17

Application:

    http://localhost:8080

---

# 2. Java 21 Lightweight JRE

## Build the application

    mvn clean package

## Build Docker image

    docker build -f Dockerfile.java21 -t java-app:21 .

## Run container

    docker run -d -p 8080:8080 --name java-app java-app:21

Application:

    http://localhost:8080

---

# 3. Java 17 Distroless

Distroless images contain only the required runtime components
and do not provide a normal shell.

## Build Docker image

    docker build -f Dockerfile.java17-distroless -t java-app:17-distroless .

## Run container

    docker run -d -p 8080:8080 --name java-app java-app:17-distroless

---

# 4. Java 21 Distroless

## Build Docker image

    docker build -f Dockerfile.java21-distroless -t java-app:21-distroless .

## Run container

    docker run -d -p 8080:8080 --name java-app java-app:21-distroless

---

# 5. Maven Build Inside Docker - Java 17

This Dockerfile uses a multi-stage build.

The first stage contains Maven and JDK and builds the application.

The second stage contains only the Java runtime and application JAR.

## Build Docker image

    docker build -f Dockerfile.maven-java17 -t java-app:maven-java17 .

## Run container

    docker run -d -p 8080:8080 --name java-app java-app:maven-java17

---

# 6. Maven Build Inside Docker - Java 21

## Build Docker image

    docker build -f Dockerfile.maven-java21 -t java-app:maven-java21 .

## Run container

    docker run -d -p 8080:8080 --name java-app java-app:maven-java21

---

# Multi-stage Docker Build

The Maven Dockerfiles use two stages.

## Build Stage

The build stage contains:

- Maven
- JDK
- Source code
- Dependencies

Maven builds the application JAR.

## Runtime Stage

The runtime stage contains:

- JRE
- Application JAR

Maven, source code and JDK are not included in the final image.

This helps reduce the final image size and attack surface.

---

# Check Docker Images

    docker images

Example:

    java-app    17
    java-app    21
    java-app    17-distroless
    java-app    21-distroless

---

# Check Running Containers

    docker ps

---

# Stop Container

    docker stop java-app

---

# Remove Container

    docker rm java-app

---

# Recommended Approach

For a CI/CD pipeline such as:

    Git
      ↓
    Jenkins
      ↓
    Maven Build
      ↓
    Docker Build
      ↓
    Container Registry
      ↓
    Kubernetes

Use a lightweight JRE or Distroless runtime image.

For example:

    Maven
      ↓
    application.jar
      ↓
    eclipse-temurin:17-jre-alpine
      ↓
    Docker Image
      ↓
    Kubernetes

For production environments where shell/debugging inside the container
is not required, a Distroless image can be considered.

