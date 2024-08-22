#!/bin/bash

#######################
#     Wait for DB     #
#######################
if [ "$SQLITE" = "true" ]; then
  export SPRING_PROFILES_ACTIVE=sqlite
elif [ "$DEV" = "true" ]; then
  export SPRING_PROFILES_ACTIVE=dev
else
  /opt/app/wait-for-it.sh $MYSQL_HOST:$MYSQL_PORT -t 120 --;
  if [ $? -ne 0 ]; then
    echo "DB (service name: $MYSQL_HOST, port: $MYSQL_PORT) not available, exiting.";
    exit 1;
  fi
fi


#######################
#     Run backend     #
#######################
java -jar /opt/app/backend/app.jar &


#######################
#     Run frontend    #
#######################
nginx -g 'daemon off;';
