<p align="center">
  <img width="200px" src="images/plant-it-logo.png" title="Plant-it">
</p>
<p align="center">
  <img src="https://img.shields.io/github/checks-status/MDeLuise/plant-it/main?style=for-the-badge&label=build&color=%2228B22" />
<img src="https://img.shields.io/github/v/release/MDeLuise/plant-it?style=for-the-badge&color=%2228B22" />
</p>

<p align="center"><i><b>[Still under "initial" development, some features may be unstable or change in the future, although database schemas should be stable. A first release version is planned to be packed soon].</b></i></p>
<p align="center">Plant-it is a <b>self-hosted gardening companion app.</b><br>Useful for keeping track of plant care, receiving notifications about when to water plants, uploading plant images, and more.</p>

<p align="center"><a href="https://github.com/MDeLuise/plant-it/#why">Why?</a> • <a href="https://github.com/MDeLuise/plant-it/#features-highlight">Features highlights</a> • <a href="https://github.com/MDeLuise/plant-it/#getting-started">Getting started</a> • <a href="https://github.com/MDeLuise/plant-it/#configuration">Configuration</a></p>

<p align="center">
  <img src="/images/screenshot-1.png" width="45%" />
  <img src="/images/screenshot-2.png" width="45%" /> 
  <img src="/images/screenshot-3.png" width="45%" />
  <img src="/images/screenshot-4.png" width="45%" /> 
</p>

## Why?
Plant-it is a gardening companion app that helps you take care of your plants.

It does not recommend you about which action to take, instead it is designed to logs the activity you are doing.
This is on purpose, I strongly believe that the only one in charge of know when to water your plants, when to fertilize them, etc. is you (with the help of multiple online sources).

Plant-it helps you remember the last time you did a treatment of your plants, which plants you have, collects photos of your plants, and notify you about time passed since last action on them.


## Features highlight
* Add existing plants using [Trefle API](https://trefle.io/) or user created plants to your collection
* Log events like watering, fertilizing, biostimulating, etc. for your plants
* View all the logged events, filtering by plant and event type
* Upload photos of your plants
* 🔜 Set reminder for some actions on your plants (e.g. notify if not watered every 4 days)
* 🔜 Dark/Light mode

## Getting started
Plant-it provides multiple ways of installing it on your server.
* [Setup with Docker](https://www.plant-it.org/docs/v1/setup/setup-with-docker/) (_recommended_)
* [Setup without Docker](https://www.plant-it.org/docs/v1/setup/setup-without-docker/)

### Setup with docker
Working with Docker is pretty straight forward. To make things easier, a [docker compose file](https://github.com/MDeLuise/plant-it/blob/main/deployment/docker-compose.yml) is provided in the repository which contain all needed services, configured to just run the application right away.

There are two different images for the service:
* `msdeluise/plant-it-backend`
* `msdeluise/plant-it-frontend`

This images can be use indipendently, or they can be use in a docker-compose file.
For the sake of simplicity, the provided docker-compose.yml file is reported here:
```
version: "3"
name: plant-it
services:
  backend:
    image: msdeluise/plant-it-backend:latest
    env_file: backend.env
    depends_on:
      - db
    restart: unless-stopped
    volumes:
      - "./upload-dir:/upload-dir"

  db:
    image: mysql:8.0
    restart: always
    env_file: backend.env

  frontend:
    image: msdeluise/plant-it-frontend:latest
    env_file: frontend.env
    links:
      - backend

  reverse-proxy:
    image: nginx:stable-alpine
    ports:
      - "8080:80"
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf
    links:
      - backend
      - frontend
```

Run the docker compose file (`docker compose -f <file> up -d`), then the service will be available at `localhost:8080`, while the REST API will be available at `localhost:8080/api` (`localhost:8080/api/swagger-ui/index.html` for the documentation of them).

<details>

  <summary>Run on a remote host</summary>

  Please notice that running the `docker-compose` file from another machine change the way to connect to the server. For example, if you run the `docker-compose` on the machine with the local IP `192.168.1.100` then you have to change the backend url in the [API_URL](#configuration) variable to `http://192.168.1.100:8080/api`. In this case, the frontend of the system will be available at `http://192.168.1.100:8080`, and the backend will be available at `http://192.168.1.100:8080/api`.
</details>

### Setup without docker
The application was developed with being used with Docker in mind, thus this method is not preferred.

#### Requirements
* [JDK 19+](https://openjdk.org/)
* [MySQL](https://www.mysql.com/)
* [React](https://reactjs.org/)

#### Run
1. Be sure to have the `mysql` database up and running
1. Run the following command in the terminal inside the `backend` folder
  `./mvnw spring-boot:run`
1. Run the following command in the terminal inside the `frontend` folder
  `npm start`

Then, the frontend of the system will be available at `http://localhost:3000`, and the backend at `http://localhost:8085/api`.


## Configuration

There are 2 configuration file available:
* `deployment/backend.env`: file containing the configuration for the backend. An example of content is the following:
  ```
  MYSQL_HOST=db
  MYSQL_PORT=3306
  MYSQL_USERNAME=root
  MYSQL_PSW=root
  JWT_SECRET=putTheSecretHere
  JWT_EXP=1
  MYSQL_ROOT_PASSWORD=root
  MYSQL_DATABASE=bootdb
  USERS_LIMIT=-1 # including the admin account, so <= 0 if undefined, >= 2 if defined
  CACHE_TTL=86400
  CACHE_HOST=cache
  CACHE_PORT=6379
  TRAFLE_KEY= # put you key here, otherwise the "search" feature will include only user generated species
  UPLOAD_DIR= # path to the directory used to store uploaded images, if on docker deployment leave as it is and change the volume binding if needed
  ```
  Change the properties values according to your system.

* `deployment/frontend.env`: file containing the configuration for the frontend. An example of content is the following:
  ```
  API_URL=http://localhost:8080/api
  BROWSER=none
  PAGE_SIZE=25
  ```
  Change the properties values according to your system.

