#!/bin/bash

#######################
#  Parameter parsing  #
#######################
version="latest";
push="";
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --version)
        version="$2"
        shift
        shift
        ;;
        --push)
        push="--push"
        shift
        shift
        ;;
        *)
        shift
        ;;
    esac
done


#######################
#       Backend       #
#######################
echo "Build backend...";
cd backend;
mvn package;
if [ $? -ne 0 ]; then
    echo "Error while compiling backend, exiting.";
    exit 1;
fi

#######################
#      Frontend       #
#######################
echo "Build frontend...";
cd ../frontend;
flutter pub get;
flutter build web --release;
if [ $? -ne 0 ]; then
    echo "Error while building frontend, exiting.";
    exit 2;
fi


#######################
#    Docker image     #
#######################
echo "Create docker image...";
cd ..;
docker buildx build $push --platform linux/amd64,linux/arm64 -t msdeluise/plant-it-server -f deployment/Dockerfile . --progress=plain;
if [ $? -ne 0 ]; then
    echo "Error while creating images, exiting.";
    exit 3;
fi

#######################
#    Cleanup files    #
#######################
echo "Cleanup...";
rm -rf frontend/build backend/target;
