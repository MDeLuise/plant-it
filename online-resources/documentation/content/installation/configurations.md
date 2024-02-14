+++
title = "Configurations"
weight = 4
chapter = false
+++

There are 2 configuration files available:
* `backend.env`: file containing the configuration for the backend. An example of content is the following:
    ```properties
    #
    # DB
    #
    MYSQL_HOST=db
    MYSQL_PORT=3306
    MYSQL_USERNAME=root
    MYSQL_PSW=root
    MYSQL_ROOT_PASSWORD=root
    MYSQL_DATABASE=bootdb

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
* `frontend.env`: file containing the configuration for the frontend. An example of content is the following:
    ```properties
    PORT=3000 # port that will serve the frontend, if on docker deployment leave as it is and change the port binding in the docker-compose file if needed
    API_URL=http://localhost:8080/api
    WAIT_TIMEOUT=5000 # timeout for backend responses (in milliseconds)
    CACHE_TTL_DAYS=7 # days before cache will be deleted

    PAGE_SIZE=25

    BROWSER=none
    ```

#### Run on a remote host
Please notice that running the docker-compose file on a machine and connect to the system from another machine change the way to connect to the server.
For example, if you run the docker-compose on the machine with the local IP `192.168.1.100` then you have to change the backend url in the `API_URL` (`frontend.env` file) parameter to `http://192.168.1.100:8080/api`. In this case, the frontend of the system will be available at `http://192.168.1.100:3000`, and the backend will be available at `http://192.168.1.100:8080/api`.

#### Change ports binding
##### Backend
If you don't want to use the default port `8080`, you can follow these steps:
* change the port binding in the `docker-compose.yml` file, e.g. `9090:8080` to setup the port `9090` for the backend service,
* update the `API_URL` (`frontend.env` file) variable in order to points to the correct backend address.
##### Frontend
If you don't want to use the default port `3000`, you can follow these steps:
* change the port binding in the `docker-compose.yml` file, e.g. `4040:3000` to setup the port `4040` for the frontend service

#### Complete example
Let's say that you want to run Plant-it on a server with IP `http://192.168.1.103` and want to have:
* the backend on port `8089`,
* the frontend on port `3009`.

Then this will be you configuration:
* `docker-compose.yml`:
    ```yaml
    version: "3"
    name: plant-it
    services:
      backend:
        image: msdeluise/plant-it-backend:latest
        env_file: backend.env
        depends_on:
          - db
          - cache
        restart: unless-stopped
        volumes:
          - "./upload-dir:/upload-dir"
        ports:
          - "8089:8080"
      db:
        image: mysql:8.0
        restart: always
        env_file: backend.env
        volumes:
          - "./db:/var/lib/mysql"
      cache:
        image: redis:7.2.1
        restart: always
      frontend:
        image: msdeluise/plant-it-frontend:latest
        env_file: frontend.env
        links:
          - backend
        ports:
          - "3009:3000"
    ```
* `frontend.env`:
    ```properties
    PORT=3000
    API_URL=http://192.168.1.103:8089/api
    WAIT_TIMEOUT=5000
    PAGE_SIZE=25
    BROWSER=none
    ```
* `backend.env`:
    ```properties
    #
    # DB
    #
    MYSQL_HOST=db
    MYSQL_PORT=3306
    MYSQL_USERNAME=root
    MYSQL_PSW=root
    MYSQL_ROOT_PASSWORD=root
    MYSQL_DATABASE=bootdb
    
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
    ```

##### Example of traefik deployment
[This](https://github.com/MDeLuise/plant-it/discussions/119) is an example of deployment provider by @filcuk using [traefik](https://traefik.io/traefik/):
```
  plantit-fe:
    image: msdeluise/plant-it-frontend:latest
    container_name: plantit-fe
    restart: unless-stopped
    networks:
      reverse_proxy:
      internal:
        # ipv4_address: ${PLANTIT_FE_IP}
    # ports:
    #   - 3000:3000
    environment:
      - PORT=3000
      - API_URL=https://plantit.${DOMAINNAME0}/api
      - WAIT_TIMEOUT=10000 # backend response timeout in ms
      - PAGE_SIZE=25
      - BROWSER=none
    labels:
      # Traefik
      - "traefik.enable=true"
      ## HTTP Routers
      - "traefik.http.routers.plantit-rtr.entrypoints=https"
      - "traefik.http.routers.plantit-rtr.rule=Host(`plantit.${DOMAINNAME0}`)"
      ## Middlewares
      - "traefik.http.routers.plantit-rtr.middlewares=chain-authelia@file"
      ## HTTP Services
      - "traefik.http.routers.plantit-rtr.service=plantit-svc"
      - "traefik.http.services.plantit-svc.loadbalancer.server.port=3000"

  plantit-be:
    image: msdeluise/plant-it-backend:latest
    container_name: plantit-be
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
    environment:
      - MYSQL_HOST=plantit-db
      - MYSQL_PORT=3306
      - MYSQL_DATABASE=${PLANTIT_DB_NAME}
      - MYSQL_USERNAME=${PLANTIT_DB_USER}
      - MYSQL_PSW=${PLANTIT_DB_ROOT}
      - MYSQL_ROOT_PASSWORD=${PLANTIT_DB_ROOT}
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
    environment:
      - MYSQL_ROOT_PASSWORD=${PLANTIT_DB_ROOT}

  plantit-cache:
    image: redis:7.2.1
    container_name: plantit-cache
    restart: unless-stopped
    networks:
      - internal
```

#### SMTP Configuration for Email Notifications
An SMTP server can be used to send notifications to users, such as password reset emails. To configure the usage of an SMTP server, the following properties need to be set in the `backend.env` file:
- **SMTP_HOST**: The host of the SMTP server.
- **SMTP_PORT**: The port of the SMTP server.
- **SMTP_EMAIL**: The email address used to send notifications.
- **SMTP_PASSWORD**: The password of the email account used for authentication.
- **SMTP_AUTH**: This parameter enables or disables authentication for the SMTP server.
- **SMTP_START_TLS**: This parameter enables or disables the use of STARTTLS for secure communication with the SMTP server.

Please note that some providers, such as Gmail, may require the use of an [application-specific password](https://support.google.com/mail/answer/185833?hl=en) for authentication.

##### Example Gmail Configuration

```properties
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_EMAIL=your-email@gmail.com
SMTP_PASSWORD=your-application-password
SMTP_AUTH=true
SMTP_START_TTL=true
```

#### DNS and CORS
##### DNS
If you are asking yourself why it's not possibile to simply use `backend` and `frontend` hostnames instead of the IPs in the `API_URL` and in the `ALLOWED_ORIGINS` parameters, here's the problem.

When the JavaScript runs in a browser (outside of Docker) you can not use service hostnames because they are only available inside the Docker network (via the embedded DNS server) [[1]](https://stackoverflow.com/questions/46080290/reactjs-browser-app-cannot-see-things-in-the-docker-compose-network) [[2]](https://stackoverflow.com/questions/70770619/dockerized-react-app-axios-req-to-backend-doesnt-work?rq=3).

In a more practical way:
* The browser you're using to access the app have no knowledge of what `backend` is. This leads to the error `ERR_NAME_NOT_RESOLVED` if trying to use `http://backend:8080` as value for the property `API_URL` (`frontend.env` file).
* The backend will not receives request from the `frontend` service (the container), it will receive them from the browser you're using (the client). So if you try to use `http://frontend:3000` as value for the property `ALLOWED_ORIGINS` (`backend.env` file) it will not works.
* The use of `localhost` hostname also does not fix the problem in those cases where you access the app from another device (e.g. the system is deployed on a server and you access it via mobile)

##### CORS
Given the above, you can change the value of the `ALLOWED_ORIGINS` parameter (`backend.env` file) in order to be more strict than the default `*`. However, keep in mind that there you have to put the IPs from which you will access the system (i.e. the client/browser you're using and the REST API client if any).
