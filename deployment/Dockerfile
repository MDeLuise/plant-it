FROM ubuntu:24.04

# Determine architecture and set Java download URL accordingly
ARG TARGETPLATFORM
ARG JAVATARGET

RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then \
        JAVATARGET=linux-x64; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        JAVATARGET=linux-aarch64; \
    fi && \
    apt-get update && \
    apt-get install -y bash openssl tar wget python3 && \
    wget "https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_${JAVATARGET}_bin.tar.gz" -O java.tar.gz && \
    tar xvf java.tar.gz && \
    rm java.tar.gz && \
    echo 'JAVA_HOME=/jdk-21.0.2/bin/java' >> /root/.bashrc && \
    echo 'export PATH="/jdk-21.0.2/bin:$PATH"' >> /root/.bashrc;

# Setup environment
ENV PATH="jdk-21.0.2/bin/:${PATH}"

# Create environment
RUN mkdir /opt/app

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
