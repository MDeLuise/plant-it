#!/bin/bash

CERTIFICATE_PATH_DESTINATION="/opt/app";


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
