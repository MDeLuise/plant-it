#!/bin/bash

#######################
# Manage certificates #
#######################
CERTIFICATE_PATH_DESTINATION="/opt/app";

if [ "$SSL_ENABLED" = "true" ]; then
  echo "WARNING: SSL_ENABLED property is deprecated and will be removed in a future release."
  echo "If you need to use SSL, consider using an app proxy like Traefik or Nginx."
fi

generate_certificates() {
  echo -n "Generating self-signed certificate...";
  openssl req -x509 -newkey rsa:4096 -keyout "$CERTIFICATE_PATH/app.key" \
    -out "$CERTIFICATE_PATH/app.crt" -days 365 -nodes -subj "/CN=localhost";
  echo "DONE";
  generate_keystore;
}


generate_keystore() {
  echo -n "Creating the PKCS12 keystore...";
  openssl pkcs12 -export -out "$CERTIFICATE_PATH/keystore.p12" \
    -inkey "$CERTIFICATE_PATH/app.key" -in "$CERTIFICATE_PATH/app.crt" \
    -name server -password pass:
  echo "DONE";
}


# If certificates does not exist in source, then generate them
if [ ! -f "${CERTIFICATE_PATH}/app.crt" ] || [ ! -f "${CERTIFICATE_PATH}/app.key" ]; then
  generate_certificates;
fi

# If keystore do not exist in source, then generate it
if [ ! -f "${CERTIFICATE_PATH}/keystore.p12" ]; then
  generate_keystore;
fi

# Copy source files if not updated in the destination
if ! cmp -s "${CERTIFICATE_PATH_DESTINATION}/app.crt" "${CERTIFICATE_PATH}/app.crt" || \
  ! cmp -s "${CERTIFICATE_PATH_DESTINATION}/app.key" "${CERTIFICATE_PATH}/app.key"; then
    echo -n "Certificate files are not up-to-date. Copying them...";
    cp "${CERTIFICATE_PATH}/app.crt" "${CERTIFICATE_PATH_DESTINATION}/app.crt";
    cp "${CERTIFICATE_PATH}/app.key" "${CERTIFICATE_PATH_DESTINATION}/app.key";
    cp "${CERTIFICATE_PATH}/keystore.p12" "${CERTIFICATE_PATH_DESTINATION}/keystore.p12";
    echo "DONE";
else
  echo "Certificate files are up-to-date.";
fi

echo "SSL enabled: $SSL_ENABLED";


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
