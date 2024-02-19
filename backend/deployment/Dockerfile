FROM eclipse-temurin:21

# Download needed packages
RUN apt-get update && apt-get install -y bash openssl wget

# Create environment
RUN mkdir /opt/app

# Download dependencies
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /opt/app/wait-for-it.sh

# Copy project files
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} /opt/app/app.jar
COPY deployment/manageCertificates.sh /opt/app/manageCertificates.sh

# Fix permissions
RUN chmod +x /opt/app/manageCertificates.sh /opt/app/wait-for-it.sh

CMD ["/bin/sh", "-c", "/opt/app/manageCertificates.sh && /opt/app/wait-for-it.sh db:3306 -t 120 -- java -jar /opt/app/app.jar"]
