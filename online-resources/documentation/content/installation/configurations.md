+++
title = "Configurations"
weight = 4
chapter = false
+++

There are 2 configuration files available:
* `backend.env`: file containing the configuration for the backend. An example of content is the following:
    ```properties
    MYSQL_HOST=db
    MYSQL_PORT=3306
    MYSQL_USERNAME=root
    MYSQL_PSW=root
    MYSQL_ROOT_PASSWORD=root
    MYSQL_DATABASE=bootdb

    JWT_SECRET=putTheSecretHere
    JWT_EXP=1

    USERS_LIMIT=-1 # less then 0 means no limit
    UPLOAD_DIR=/upload-dir # path to the directory used to store uploaded images, if on docker deployment leave as it is and change the volume binding in the docker-compose file if needed
    API_PORT=8080

    CACHE_TTL=86400
    CACHE_HOST=cache
    CACHE_PORT=6379

    TREFLE_KEY=

    ALLOWED_ORIGINS=* # CORS allowed origins (comma separated list)

    LOG_LEVEL=DEBUG # could be: DEBUG, INFO, WARN, ERROR
    UPDATE_EXISTING=false # update missing fields using Trefle service, useful on system version update if new fields are introduced
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
    MYSQL_HOST=db
    MYSQL_PORT=3306
    MYSQL_USERNAME=root
    MYSQL_PSW=root
    MYSQL_ROOT_PASSWORD=root
    MYSQL_DATABASE=bootdb
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
