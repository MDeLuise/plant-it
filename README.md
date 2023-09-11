<p align="center">
  <img width="200px" src="images/plant-it-logo.png" title="Plant-it">
</p>
<p align="center">
  <img src="https://img.shields.io/github/checks-status/MDeLuise/plant-it/main?style=for-the-badge&label=build&color=%2228B22" />
<img src="https://img.shields.io/github/v/release/MDeLuise/plant-it?style=for-the-badge&color=%2228B22" />
</p>

<p align="center"><i><b>[Still under "initial" development, some features may be unstable or change in the future, although database schemas should be stable. A first release version is planned to be packed soon].</b></i></p>
<p align="center">Plant-it is a <b>self-hosted gardening companion app.</b><br>Useful for keeping track of plant care, receiving notifications about when to water plants, uploading plant images, and more.</p>

<p align="center"><a href="https://github.com/MDeLuise/plant-it/#why">Why?</a> • <a href="https://github.com/MDeLuise/plant-it/#features-highlight">Features highlights</a> • <a href="https://github.com/MDeLuise/plant-it/#getting-started">Getting started</a> • <a href="https://github.com/MDeLuise/plant-it/#configuration">Configuration</a> • <a href="https://github.com/MDeLuise/plant-it/#contribute">Contribute</a></p>

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
* 🔜 Share plants with other users
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
For the sake of simplicity, the provided `docker-compose.yml` file is reported here:
```
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

Run the docker compose file (`docker compose -f <file> up -d`), then the service will be available at `localhost:3000`, while the REST API will be available at `localhost:8080/api` (`localhost:8080/api/swagger-ui/index.html` for the documentation of them).


> ℹ️ *Run on a remote host (_e.g. run the system in a server and access it from mobile_)*
>
> Please notice that running the `docker-compose` file on a machine and connect to the system from another machine change the way to connect to the server.
>  
>  For example, if you run the `docker-compose` on the machine with the local IP `192.168.1.100` then you have to change the backend url in the [API_URL](#configuration) (`frontend.env` file) parameter to `http://192.168.1.100:8080/api`. In this case, the frontend of the system will be available at `http://192.168.1.100:3000`, and the backend will be available at `http://192.168.1.100:8080/api`.
>
>  Why this mandatory changes? [See here](#dns-and-cors).


#### Change port binding
##### Backend
If you don't want to use the default port `8080`, you can follow these steps:
* change the port binding in the `docker-compose.yml` file, e.g. `9090:8080` to setup the port `9090` for the backend service
* update the [API_URL](#configuration) (`frontend.env` file) variable in order to points to the correct backend address
##### Frontend
If you don't want to use the default port `3000`, you can follow these steps:
* change the port binding in the `docker-compose.yml` file, e.g. `4040:3000` to setup the port `4040` for the frontend service

#### DNS and CORS
##### DNS
If you are asking yourself why it's not possibile to simply use `backend` and `frontend` hostnames instead of the IPs in the [API_URL](#configuration) and in the [ALLOWED_ORIGINS](#configuration) variables, here's the problem.

When the JavaScript runs in a browser (outside of Docker) you can not use service hostnames because they are only available inside the Docker network (via the embedded DNS server) [<sup>[1]</sup>](https://stackoverflow.com/questions/46080290/reactjs-browser-app-cannot-see-things-in-the-docker-compose-network) [<sup>[2]</sup>](https://stackoverflow.com/questions/70770619/dockerized-react-app-axios-req-to-backend-doesnt-work?rq=3).

In a more practical way:
* The browser you're using to access the app have no knowledge of what `backend` is. This leads to the error `ERR_NAME_NOT_RESOLVED` if trying to use `http://backend:8080` as value for the property `API_URL` (`frontend.env` file).
* The backend will not receives request from the `frontend` service (the container), it will receive them from the browser you're using (the client). So if you try to use `http://frontend:3000` as value for the property `ALLOWED_ORIGINS` (`backend.env` file) it will not works.
* The use of `localhost` hostname also does not fix the problem in those cases where you access the app from another device (e.g. the system is deployed on a server and you access it via mobile)

##### CORS
Given the above, you can change the value of the `ALLOWED_ORIGINS` parameter (`backend.env` file) in order to be more strict than the default `*`. However, keep in mind that there you have to put the IPs from which you will access the system (i.e. the client/browser you're using and the REST API client if any).

### Setup without docker
The application was developed with being used with Docker in mind, thus this method is not preferred.

#### Requirements
* [JDK 20+](https://openjdk.org/)
* [MySQL](https://www.mysql.com/)
* [ReactJS](https://reactjs.org/)

#### Run
1. Be sure to have the `mysql` database up and running
1. Run the following command in the terminal inside the `backend` folder
  `./mvnw spring-boot:run`
1. Run the following command in the terminal inside the `frontend` folder
  `npm start`

Then, the frontend of the system will be available at `http://localhost:3000`, and the backend at `http://localhost:8080/api`.


#### Change port binding
If you don't want to use the default ports (`3000` for the frontend and `8080` for the backend), you can modify the following [configuration properties](#configuration):
* in the `backend.env` file:
  * `API_PORT`: port to serve the backend
* in the `frontend.env` file:
  * `PORT`: port to serve the frontend
  * `API_URL`: address of the API, e.g. `http//localhost:<API_PORT>/api`


## Configuration
There are 2 configuration file available:
* `deployment/backend.env`: file containing the configuration for the backend. An example of content is the following:
  ```
  MYSQL_HOST=db
  MYSQL_PORT=3306
  MYSQL_USERNAME=root
  MYSQL_PSW=root
  MYSQL_ROOT_PASSWORD=root
  MYSQL_DATABASE=bootdb
  
  JWT_SECRET=putTheSecretHere
  JWT_EXP=1
  
  USERS_LIMIT=-1 # including the admin account, so <= 0 if undefined, >= 2 if defined
  UPLOAD_DIR=/upload-dir # path to the directory used to store uploaded images, if on docker deployment leave as it is and change the volume binding in the docker-compose file if needed
  API_PORT=8080
  
  CACHE_TTL=86400
  CACHE_HOST=cache
  CACHE_PORT=6379
  
  TRAFLE_KEY= # put you key here, otherwise the "search" feature will include only user generated species

  ALLOWED_ORIGINS=* # CORS allowed origins (comma separated list)
  ```
  Change the properties values according to your system.

* `deployment/frontend.env`: file containing the configuration for the frontend. An example of content is the following:
  ```
  PORT=3000 # port that will serve the frontend, if on docker deployment leave as it is and change the port binding in the docker-compose file if needed
  API_URL=http://localhost:8080/api
  WAIT_TIMEOUT=5000 # timeout for backend responses (in milliseconds)
  
  PAGE_SIZE=25
  
  BROWSER=none
  ```
  Change the properties values according to your system.

## Contribute
Feel free to contribute and help improve the repo.

### Bug Report, Feature Request and Question
You can submit any of this in the [issues](https://github.com/MDeLuise/plant-it/issues/new/choose) section of the repository. Chose the right template and then fill the required info.

### Bug fix
If you fix a bug, please follow the [contribution guideline](https://github.com/MDeLuise/plant-it#how-to-contribute) in order to merge the fix in the repository.

### Feature development
Let's discuss first possible solutions for the development before start working on that, please open a [feature request issue](https://github.com/MDeLuise/plant-it/issues/new?assignees=&labels=&projects=&template=fr.yml).

### How to contribute
To fix a bug or create a feature, follow these steps:
1. Fork the repo
1. Create a new branch (`git checkout -b awesome-feature`)
1. Make changes or add new changes.
1. Commit your changes (`git add -A; git commit -m 'Awesome new feature'`)
1. Push to the branch (`git push origin awesome-feature`)
1. Create a Pull Request

#### Conventions
* Commits should follow the [semantic commit](https://www.conventionalcommits.org/en/v1.0.0/) specification, although not mandatory.

#### Local environment
If you want to test some changes in the project, you can use the following commands:
* in order to run the frontend: `cd frontend`, then `npm run dev` (available at `localhost:3000` by default).
* in order to run the backend: `cd backend`, then `./mvnw spring-boot:run -Dspring-boot.run.profiles=dev -DcopyFiles` (available at `localhost:8085` by default). This enables the `dev` profile, which uses an embedded h2 database instead of one external mysql instance, and creates a user with username `user` and password `user` with a predefined plant's collection. Also a dummy user uploaded image is copied under `/tmp/plant-it/` directory.

Consider that this environment speed up the developing process, but the app should be tested (at least for new big features) even without the `dev` backend profile and with a local docker deployment.
