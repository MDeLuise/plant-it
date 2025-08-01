#!/bin/bash

#######################
#  Parameter parsing  #
#######################
versions="latest";
push="";
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --versions)
        versions="$2"
        shift
        shift
        ;;
        --push)
        push="--push"
        shift
        ;;
        *)
        shift
        ;;
    esac
done

IFS=',' read -r -a versions_array <<< "$versions"; # Split versions by comma
echo "Compiling and preparing images: ${versions_array[@]}"


echo "Build...";
cd ../frontend;
flutter pub get;

echo "Run test...";
flutter test;
if [ $? -ne 0 ]; then
    echo "Error while testing, exiting.";
    exit 2;
fi

echo "Run analysis...";
flutter analyze;
if [ $? -ne 0 ]; then
    echo "Error while analysing, exiting.";
    exit 3;
fi

flutter build web --release;
if [ $? -ne 0 ]; then
    echo "Error while building image, exiting.";
    exit 4;
fi


#######################
#    Docker image     #
#######################
echo "Create docker image...";
cd ..;
for version in "${versions_array[@]}"
do
    # Check if $push variable is empty
    if [ -n "$push" ]; then
        # If $push is not empty, create and push the image
        echo "Creating and pushing image version: $version..."
        docker buildx build $push --platform linux/amd64,linux/arm64 -t msdeluise/plant-it-server:$version -f deployment/Dockerfile . --progress=plain
    else
        # If $push is empty, only create the image
        echo "Creating locally the image version: $version..."
        docker build -t msdeluise/plant-it-server:$version -f deployment/Dockerfile . --progress=plain
    fi
done
if [ $? -ne 0 ]; then
    echo "Error while creating images, exiting.";
    exit 5;
fi

#######################
#    Cleanup files    #
#######################
echo "Cleanup...";
rm -rf frontend/build backend/target;
