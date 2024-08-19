#!/bin/bash

#######################
#     Wait for DB     #
#######################
# Check if DEV is not set or is set to "false"
if [ -z "$DEV" ] || [ "$DEV" = "false" ]; then
  /opt/app/wait-for-it.sh $MYSQL_HOST:$MYSQL_PORT -t 120 --;
  if [ $? -ne 0 ]; then
      echo "DB (service name: $MYSQL_HOST, port: $MYSQL_PORT) not available, exiting.";
      exit 1;
  fi
else
    export SPRING_PROFILES_ACTIVE=dev
fi

#######################
#     Run backend     #
#######################
java -jar /opt/app/backend/app.jar &


#######################
#     Run frontend    #
#######################
cd /opt/app/frontend/build/web;
python3 -m http.server 3000;
