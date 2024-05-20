<p align="center">
  <img width="150px" src="images/plant-it-logo.png" title="Plant-it">
</p>

<h1 align="center">Plant-it</h1>

<p align="center"><i><b>[Project under "active" development, some features may be unstable or change in the future. A first release version is planned to be packed soon].</b></i></p>
<p align="center">Plant-it is a <b>self-hosted gardening companion app.</b><br>Useful for keeping track of plant care, receiving notifications about when to water plants, uploading plant images, and more.</p>

<p align="center"><a href="https://docs.plant-it.org/latest/">Explore the documentation</a></p>

<p align="center"><a href="https://github.com/MDeLuise/plant-it/#why">Why?</a> • <a href="https://github.com/MDeLuise/plant-it/#features-highlight">Features highlights</a> • <a href="https://github.com/MDeLuise/plant-it/#quickstart">Quickstart</a> • <a href="https://github.com/MDeLuise/plant-it/#support-the-project">Support</a> • <a href="https://github.com/MDeLuise/plant-it/#contribute">Contribute</a></p>

<p align="center">
  <img src="/images/banner.png" width="100%" />
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
* Set reminder for some actions on your plants (e.g. notify if not watered every 4 days)

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

<a href="https://docs.plant-it.org/latest/installation/#configuration">Take a look at the documentation</a> in order to understand the available configurations.

## Support the project
If you find this project helpful and would like to supporting it, consider [buying me a coffee](https://www.buymeacoffee.com/mdeluise). Your generosity helps keep this project alive and ensures its continued development and improvement.
<p align="center">
  <a href="https://www.buymeacoffee.com/mdeluise" target="_blank"><img width="150px" src="images/bmc-button.png"></a>
</p>

## Contribute
Feel free to contribute and help improve the repo.

### Contributing Translations to the Project
If you're interested in contributing transactions to enhance the app, you can get started by following the guide provided [here](https://github.com/MDeLuise/plant-it/discussions/148). Your support and contributions are greatly appreciated.
| Language | Filename | Translation |
|----------|----------|-------------|
| English | app_en.arb | 100% |
| Italian | app_it.arb | 100% |
| Spanish Castilian | app_es.arb | 98% |
| Ukrainian | app_uk.arb | 97% |

### Bug Report, Feature Request and Question
You can submit any of this in the [issues](https://github.com/MDeLuise/plant-it/issues/new/choose) section of the repository. Chose the right template and then fill the required info.

### Feature development
Let's discuss first possible solutions for the development before start working on that, please open a [feature request issue](https://github.com/MDeLuise/plant-it/issues/new?assignees=&labels=feature+request&projects=&template=feature_request.yml).

### How to contribute
If you want to make some changes and test them locally <a href="https://docs.plant-it.org/latest/support/#contributing">take a look at the documentation</a>.
