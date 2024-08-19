FROM alpine:3.20.2

# Determine architecture and set Java download URL accordingly
ARG TARGETPLATFORM
ARG JAVATARGET
ARG JAVA_VERSION=21

RUN apk update && \
    apk add bash openssl tar wget python3 openjdk${JAVA_VERSION}-jre

# Create environment
RUN mkdir -p /opt/app

# Download dependencies
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /opt/app/wait-for-it.sh

# Copy project files
ARG JAR_FILE=backend/target/*.jar
COPY ${JAR_FILE} /opt/app/backend/app.jar
COPY deployment/start.sh /opt/app/start.sh
COPY frontend/build/web /opt/app/frontend/build/web

# Fix permissions
RUN chmod +x /opt/app/start.sh /opt/app/wait-for-it.sh

# Set working directory
WORKDIR /opt/app/frontend

# Expose ports
EXPOSE 8080
EXPOSE 3000

CMD ["/bin/sh", "-c", "/opt/app/start.sh"]
