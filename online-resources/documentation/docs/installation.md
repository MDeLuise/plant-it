# Install

## Prerequisite
Before installing Plant-it, make sure you have the following prerequisites:

* `docker` version 3 or above
* `docker-compose`

## Quickstart
Installing Plant-it is pretty straight forward, in order to do so follow these steps:

* Create a folder where you want to place all Plant-it related files.
* Inside that folder, create a file named `docker-compose.yml` with this content:
```yaml
version: "3"
name: plant-it
services:
  server:
    image: msdeluise/plant-it-server:latest
    env_file: server.env
    depends_on:
      - db
      - cache
    restart: unless-stopped
    volumes:
      - "./upload-dir:/upload-dir"
      - "./certs:/certificates"
    ports:
      - "8080:8080"
      - "3000:3000"

  db:
    image: mysql:8.0
    restart: always
    env_file: server.env
    volumes:
      - "./db:/var/lib/mysql"

  cache:
    image: redis:7.2.1
    restart: always
```

* Inside that folder, create a file named `server.env` with this content:
```properties
#
# DB
#
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_USERNAME=root
MYSQL_PSW=root
MYSQL_DATABASE=bootdb
MYSQL_ROOT_PASSWORD=root

#
# JWT
#
JWT_SECRET=putTheSecretHere
JWT_EXP=1

#
# Server config
#
USERS_LIMIT=-1
UPLOAD_DIR=/upload-dir
API_PORT=8080
TREFLE_KEY=
LOG_LEVEL=DEBUG
ALLOWED_ORIGINS=*

#
# Cache
#
CACHE_TTL=86400
CACHE_HOST=cache
CACHE_PORT=6379

#
# SSL
#
SSL_ENABLED=false
CERTIFICATE_PATH=/certificates/
```

* Run the docker compose file (`docker compose -f docker-compose.yml up -d`), then the service will be available at `localhost:3000`, while the REST API will be available at `localhost:8080/api` (`localhost:8080/api/swagger-ui/index.html` for the documentation of them).

## Configuration
The `server.env` file is used to pass configurations to the server. An example of properties and descriptions is the following:
```properties
#
# DB
#
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_USERNAME=root
MYSQL_PSW=root
MYSQL_DATABASE=bootdb
MYSQL_ROOT_PASSWORD=root

#
# JWT
#
JWT_SECRET=putTheSecretHere
JWT_EXP=1

#
# Server config
#
USERS_LIMIT=-1 # less then 0 means no limit
UPLOAD_DIR=/upload-dir # path to the directory used to store uploaded images, if on docker deployment leave as it is and change the volume binding in the docker-compose file if needed
API_PORT=8080
TREFLE_KEY=
ALLOWED_ORIGINS=* # CORS allowed origins (comma separated list)
LOG_LEVEL=DEBUG # could be: DEBUG, INFO, WARN, ERROR
UPDATE_EXISTING=false # update missing fields using Trefle service, useful on system version update if new fields are introduced
CONTACT_MAIL=foo@bar.com # address used as "contact" for template email
REMINDER_NOTIFY_CHECK=0 30 7 * * * # 6-values crontab expression to set the check time for reminders

#
# SSL
#
SSL_ENABLED=false
CERTIFICATE_PATH=/certificates/ # path to files to use for ssl. If on docker deployment leave as it is and change the volume binding in the docker-compose file if needed

#
# Cache
#
CACHE_TTL=86400
CACHE_HOST=cache
CACHE_PORT=6379

#
# SMTP
#
SMTP_HOST=
SMTP_PORT=
SMTP_EMAIL=
SMTP_PASSWORD=
SMTP_AUTH=
SMTP_START_TTL=
```

### Change ports binding
#### Backend
If you don't want to use the default port `8080`, you can do the following:

* change the port binding in the `docker-compose.yml` file, e.g. `9090:8080` to setup the port `9090` for the backend service,

#### Frontend
If you don't want to use the default port `3000`, you can do the following:

* change the port binding in the `docker-compose.yml` file, e.g. `4040:3000` to setup the port `4040` for the frontend service

#### Complete example
Let's say that you want to run Plant-it on a server with IP `http://192.168.1.103` and want to have:

* the backend on port `8089`,
* the frontend on port `3009`.

Then this will be you configuration for the `docker-compose.yml` file:
```yaml
version: "3"
name: plant-it
services:
  server:
    image: msdeluise/plant-it-server:latest
    env_file: server.env
    depends_on:
      - db
      - cache
    restart: unless-stopped
    volumes:
      - "./upload-dir:/upload-dir"
      - "./certs:/certificates"
    ports:
      - "8089:8080"
      - "3009:3000"
  db:
    image: mysql:8.0
    restart: always
    env_file: server.env
    volumes:
      - "./db:/var/lib/mysql"
  cache:
    image: redis:7.2.1
    restart: always
```
And this will be you configuration for the `server.env` file:
```properties
#
# DB
#
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_USERNAME=root
MYSQL_PSW=root
MYSQL_DATABASE=bootdb
MYSQL_ROOT_PASSWORD=root

#
# JWT
#
JWT_SECRET=32characterscomplicatedsecret
JWT_EXP=1

#
# Server config
#
USERS_LIMIT=2
UPLOAD_DIR=/upload-dir
API_PORT=8080
TRAFLE_KEY=
ALLOWED_ORIGINS=*

#
# Cache
#
CACHE_TTL=86400
CACHE_HOST=cache
CACHE_PORT=6379

#
# SSL
#
SSL_ENABLED=false
CERTIFICATE_PATH=/certificates/
```

#### Example of traefik deployment
[This](https://github.com/MDeLuise/plant-it/discussions/119) is an example of deployment provider by @filcuk user using [traefik](https://traefik.io/traefik/):
```
version: "3"
name: plant-it
services:
  plantit-se:
    image: msdeluise/plant-it-server:latest
    container_name: plantit-se
    restart: unless-stopped
    depends_on:
      - plantit-db
      - plantit-cache
    networks:
      reverse_proxy:
      internal:
        # ipv4_address: ${PLANTIT_BE_IP}
    # ports:
    #   - 8080:8080
    volumes:
      - $DOCKERDIR/appdata/plantit/upload-dir:/upload-dir
      - ./certs:/certificates
    environment:
      - MYSQL_HOST=plantit-db
      - MYSQL_PORT=3306
      - MYSQL_DATABASE=${PLANTIT_DB_NAME}
      - MYSQL_USERNAME=${PLANTIT_DB_USER}
      - MYSQL_PSW=${PLANTIT_DB_ROOT}
      - MYSQL_ROOT_PASSWORD=${PLANTIT_DB_ROOT_PSW}
      - CACHE_HOST=plantit-cache
      - CACHE_TTL=86400
      - CACHE_PORT=6379
      - API_PORT=8080
      - JWT_SECRET=<redacted>
      - JWT_EXP=1
      - USERS_LIMIT=-1 # less then 0 means no limit
      - UPLOAD_DIR=/upload-dir
      - TREFLE_KEY=<redacted>
      # - ALLOWED_ORIGINS=http://${PLANTIT_FE_IP}:3000
      - ALLOWED_ORIGINS=https://plantit.${DOMAINNAME0}:3000
      - LOG_LEVEL=INFO # DEBUG, INFO, WARN, ERROR
      - CERTIFICATE_PATH=/certificates/
    labels:
      # Traefik
      - "traefik.enable=true"
      ## HTTP Routers
      - "traefik.http.routers.plantit-api-rtr.entrypoints=https"
      - "traefik.http.routers.plantit-api-rtr.rule=Host(`plantit.$DOMAINNAME0`) && (PathPrefix(`/api`))"
      ## Middlewares
      - "traefik.http.routers.plantit-api-rtr.middlewares=plantit-cors@docker,chain-no-auth@file"
      ## HTTP Services
      - "traefik.http.routers.plantit-api-rtr.service=plantit-api-svc"
      - "traefik.http.services.plantit-api-svc.loadbalancer.server.port=8080"
      - "traefik.http.services.plantit-svc.loadbalancer.server.port=3000"
      ## CORS
      - "traefik.http.middlewares.plantit-cors.headers.customResponseHeaders.Access-Control-Allow-Origin=https://plantit.${DOMAINNAME0}"

  plantit-db:
    image: mysql:8.0
    container_name: plantit-db
    restart: unless-stopped
    networks:
      - internal
    volumes:
      - $DOCKERDIR/appdata/plantit-db:/var/lib/mysql

  plantit-cache:
    image: redis:7.2.1
    container_name: plantit-cache
    restart: unless-stopped
    networks:
      - internal
```

#### SMTP Configuration for Email Notifications
An SMTP server can be used to send notifications to users, such as password reset emails. To configure the usage of an SMTP server, the following properties need to be set in the `server.env` file:

- **SMTP_HOST**: The host of the SMTP server.
- **SMTP_PORT**: The port of the SMTP server.
- **SMTP_EMAIL**: The email address used to send notifications.
- **SMTP_PASSWORD**: The password of the email account used for authentication.
- **SMTP_AUTH**: This parameter enables or disables authentication for the SMTP server.
- **SMTP_START_TLS**: This parameter enables or disables the use of STARTTLS for secure communication with the SMTP server.
- **CONTACT_MAIL**: contact address to use in the email templates if a user want to contact the administrator

!!! info "Email credentials"

    Please note that some providers, such as Gmail, may require the use of an [application-specific password](https://support.google.com/mail/answer/185833?hl=en) for authentication.

##### Example Gmail Configuration
```properties
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_EMAIL=your-email@gmail.com
SMTP_PASSWORD=your-application-password
SMTP_AUTH=true
SMTP_START_TTL=true
CONTACT_MAIL=your-email@gmail.com
```

#### Enable SSL
To enable SSL for your Plant-it deployment, follow these steps:

1. **Set SSL Enabled Property**: Ensure that SSL is enabled by adding the property `SSL_ENABLED=true` to the `server.env` file.
1. **Create Volume Binding**: Add a volume binding `"./certs:/certificates"` to the `server.env` services in your `docker-compose.yml` file. This allows the services to access SSL certificates stored in the `./certs` directory.

##### Complete Example
Let's say that you want to run Plant-it on a server with IP `https://192.168.1.103` and want to have:

* the backend on port `8089`,
* the frontend on port `3009`.

`docker-compose.yml`:
```yaml
version: "3"
name: plant-it
services:
  server:
    image: msdeluise/plant-it-server:latest
    env_file: server.env
    depends_on:
      - db
      - cache
    restart: unless-stopped
    volumes:
      - "./upload-dir:/upload-dir"
      - "certs:/certificates"
    ports:
      - "8089:8080"
      - "3009:3000"
  db:
    image: mysql:8.0
    restart: always
    env_file: server.env
    volumes:
      - "./db:/var/lib/mysql"
  cache:
    image: redis:7.2.1
    restart: always
```

`server.env`:
```properties
MYSQL_HOST=db
MYSQL_PORT=3306
MYSQL_USERNAME=root
MYSQL_PSW=root
MYSQL_DATABASE=bootdb
MYSQL_ROOT_PASSWORD=root
JWT_SECRET=32characterscomplicatedsecret
JWT_EXP=1
USERS_LIMIT=2
UPLOAD_DIR=/upload-dir
API_PORT=8080
CACHE_TTL=86400
CACHE_HOST=cache
CACHE_PORT=6379
TRAFLE_KEY=
ALLOWED_ORIGINS=*
SSL_ENABLED=true
CERTIFICATE_PATH=/certificates/ 
```

This setup creates a self-hosted certificate for both the backend and frontend services.

!!! info "Accept certificates"

    In some cases, certain browsers may require explicit acceptance of certificates from both the frontend and backend of the application, even if they share the same certificate. This scenario typically arises when encountering a "Cannot connect to the backend" error message and SSL is enabled.
    To resolve this issue, users may need to navigate to both the frontend and backend URLs of the application and manually accept the certificate presented by each. By acknowledging the certificates, users can establish a trusted connection between their browser and the application's frontend and backend servers, thereby resolving connectivity issues.

##### Provide Custom Certificate
If you prefer to use your own certificate, simply place the `app.key` and `app.crt` files inside the `CERTIFICATE_PATH` folder.