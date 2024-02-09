+++
title = "Installation steps"
weight = 3
chapter = false
+++

Installing Plant-it is pretty straight forward, in order to do so follow these steps:
1. Create a folder where you want to place all Plant-it related files.
1. Inside that folder, create the following files:
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
                - "8080:8080"

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
                - "3000:3000"
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
    JWT_SECRET=putTheSecretHere
    JWT_EXP=1

    #
    # Server config
    #
    USERS_LIMIT=-1 # less then 0 means no limit
    UPLOAD_DIR=/upload-dir # path to the directory used to store uploaded images, if on docker deployment leave as it is and change the volume binding in the docker-compose file if needed
    API_PORT=8080 # port that will serve the backend, if on docker deployment leave as it is and change the port binding in the docker-compose file if needed
    TREFLE_KEY= # put you key here, otherwise the "search" feature will include only user generated species
    LOG_LEVEL=DEBUG # could be: DEBUG, INFO, WARN, ERROR
    ALLOWED_ORIGINS=* # CORS allowed origins (comma separated list)

    #
    # Cache
    #
    CACHE_TTL=86400
    CACHE_HOST=cache
    CACHE_PORT=6379
    ```
    * `frontend.env`:
    ```properties
    PORT=3000 # port that will serve the frontend, if on docker deployment leave as it is and change the port binding in the docker-compose file if needed
    API_URL=http://localhost:8080/api
    WAIT_TIMEOUT=10000 # timeout for backend responses (in milliseconds)

    PAGE_SIZE=25

    BROWSER=none
    ```
1. Run the docker compose file (`docker compose -f docker-compose.yml up -d`), then the service will be available at `localhost:3000`, while the REST API will be available at `localhost:8080/api` (`localhost:8080/api/swagger-ui/index.html` for the documentation of them).


{{% notice note %}}
With the configurations above, the app will be available only on the server that run it.
If you want to run the system on a server, and access it from another device (for example from a mobile) see the next section (Configurations).
{{% /notice %}}
