# Developer
## Overview  
This page provides a comprehensive guide on setting up, contributing to, and testing the codebase for the Plant-it project. Whether you're working on the backend or the frontend, you'll find all the necessary steps and tools to get started here.

## Requirements  
Before you can run and test the project, ensure you have the following tools installed:

### Backend

- **[OpenJDK](https://openjdk.org/)**: Version 21 or higher is required to compile and run the backend.  

- **[Maven](https://maven.apache.org/)**: A build automation tool for managing project dependencies and building the backend.  

### Frontend  

- **[Flutter](https://flutter.dev/)**: Ensure you have Flutter installed to build and run the frontend. You can follow the [official installation guide](https://flutter.dev/docs/get-started/install) for your operating system.

## CLI
### Backend
To compile and run the backend:  

1. Navigate to the `backend` folder:  
   ```bash  
   cd backend
   ```

2.	Compile the backend by running:
    ```bash  
    mvn clean install
    ```

3.	Start the backend server with the development profile:
    ```bash
    mvn spring-boot:run -Dspring-boot.run.profiles=dev
    ```

4.	Open your browser and navigate to [http://localhost:8085/api/swagger-ui/index.html](http://localhost:8085/api/swagger-ui/index.html). Here, you can view the API's Swagger documentation and test the endpoints.

### Frontend
To run the frontend:

1.	Navigate to the frontend folder:
    ```bash
    cd frontend
    ```

2.	Start the frontend on a web server by running:
    ```bash
    flutter run -d web-server --web-port=56134
    ```

3.	Open your browser and navigate to [http://localhost:56134](http://localhost:56134). This will display the Plant-it application.

## IDE
### Backend
For backend development, we recommend using [IntelliJ IDEA](https://www.jetbrains.com/idea/):

1.	Download and install IntelliJ IDEA (Community or Ultimate edition).

2.	Open the IDE.

3.	Navigate to File > Open and select the backend folder.

4.	Wait for IntelliJ to index the project and download dependencies.

5.	Use the built-in Run/Debug Configuration for managing and running your Spring Boot application.

### Frontend
For frontend development, we recommend using [Visual Studio Code](https://code.visualstudio.com/):

1.	Download and install Visual Studio Code.

2. Download and install [Chrome Browser](https://www.google.com/chrome/) (required for web development)

2.	Open the IDE.

3.	Navigate to File > Open Folder and select the frontend folder.

4.	Install the [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) and [Dart](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code) extensions from the Extensions Marketplace for enhanced development support.

6. In the bottom-right corner of the IDE, select `Chrome (web-javascript)` as the device.

5.	Open the `lib/main.dart` file and click on Run.

## Workflow

### Backend
In order to test changes for the backend:

1. Made the changes

2. Compile and test the project by running: `mvn clean install`

3. If the compilation and tests pass, start the project: `mvn spring-boot:run -Dspring-boot.run.profiles=dev`

4. Connect the frontend or navigate to [http://localhost:8085/api/swagger-ui/index.html](http://localhost:8085/api/swagger-ui/index.html) to test the API.

### Frontend
In order to test changes for the frontend:

1. Make your changes in the codebase.

2. Test the project by running: `flutter test`

3. If the tests are ok, then run the project `flutter run -d web-server --web-port=56134`

4. Connect to the frontend at [http://localhost:56134](http://localhost:56134) to verify the changes.

### Docker  

Testing the system as a whole is crucial to ensure that changes do not introduce unexpected issues. To achieve this, you can build and test the Docker image of the project.  

#### Steps  

1. **Build the Docker Image**  
   From the root of the project, execute the following command to build the Docker image:  
   ```bash  
   deployment/create-images.sh --versions latest  
   ```

2. **Run the Docker Image**
    After building the image, follow the steps in the [Quickstart Guide](https://docs.plant-it.org/latest/server-installation/#quickstart) to run the Docker image and test the system.

By running the project in a Dockerized environment, you can verify that all components integrate seamlessly and perform as expected in a production-like setup.

## Additional Resources

*	[Flutter Documentation](https://docs.flutter.dev/): Learn about Flutter development and troubleshooting.

*	[Spring Boot Documentation](https://spring.io/quickstart): Reference material for Spring Boot.

*	[Maven Documentation](https://maven.apache.org/index.html): Guides for working with Maven.
