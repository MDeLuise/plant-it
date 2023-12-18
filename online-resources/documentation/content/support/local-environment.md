+++
title = "Local environment"
weight = 3
chapter = false
+++

In order to make some changes and test them locally you have to follow this guide.

#### Requirements
You need to install:
* [JDK 20+](https://openjdk.org/)
* [MySQL](https://www.mysql.com/)
* [ReactJS](https://reactjs.org/)

#### Run the services
1. Be sure to have the `mysql` database up and running
1. Run the following command in the terminal inside the `backend` folder
  `./mvnw spring-boot:run`
1. Run the following command in the terminal inside the `frontend` folder
  `npm run dev`

Then, the frontend of the system will be available at `http://localhost:3000`, and the backend at `http://localhost:8080/api`.

##### Dev profile
You can use the "dev" profile for the backend part.
Running `./mvnw spring-boot:run -Dspring-boot.run.profiles=dev -DcopyFiles` enables the `dev` profile, which uses an embedded `h2` database instead of one external `mysql` instance, and creates a user with username `user` and password `user` with a predefined plant's collection. Also a dummy user uploaded image is copied under `/tmp/plant-it/` directory.

Consider that this profile speed up the developing process, but the app should be tested (at least for new big features) even without the `dev` backend profile and with a local docker deployment.

##### Change configuration parameters
If you want to change the configuration parameters while testing or making changes:
* for the backend side run `./mvnw spring-boot:run -Dspring-boot.run.profiles=dev -DcopyFiles -Dspring-boot.run.arguments="--<param_name_1>=<param_value_1> --<param_name_2>=<param_value_2>"`
* for the frontend `<param-name>=<param-value> npm run dev`

#### Change port binding
If you don't want to use the default ports (`3000` for the frontend and `8080` for the backend), you can change the `API_PORT`, `PORT`, and `API_URL` parameters:
* for the backend: `./mvnw spring-boot:run -Dspring-boot.run.profiles=dev -DcopyFiles -Dspring-boot.run.arguments="--API_PORT=<new-port>"`
* for the frontend: `PORT=<param-value> API_URL=<param-value> npm run dev`