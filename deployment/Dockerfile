FROM alpine:3.20.2

# Download dependencies
RUN apk update && \
    apk add bash wget nginx

# Create environment
RUN mkdir -p /opt/app

# Copy project files
COPY deployment/start.sh /opt/app/start.sh
COPY frontend/build/web /opt/app/frontend/build/web
COPY deployment/nginx.conf /etc/nginx/nginx.conf

# Set working directory
WORKDIR /opt/app/frontend

# Expose ports
EXPOSE 3000

# Run
CMD ["/bin/sh", "-c", "/opt/app/start.sh"]
