#!/bin/bash

NGINX_CERTIFICATE_PATH="/etc/nginx";
WAIT_INTERVAL_SECONDS=5;
MAX_WAIT_TIME_SECONDS=300;


# Check if certificates exist
check_certificates_exist() {
  [ -f "${CERTIFICATE_PATH}/app.crt" ] && [ -f "${CERTIFICATE_PATH}/app.key" ]
}

# Wait for certificates to be available
elapsed_time=0;
while [ $elapsed_time -lt $MAX_WAIT_TIME_SECONDS ]; do
  if check_certificates_exist; then
    echo -n "Certificates found. Copying...";
    cp "${CERTIFICATE_PATH}/app.crt" "${NGINX_CERTIFICATE_PATH}/app.crt";
    cp "${CERTIFICATE_PATH}/app.key" "${NGINX_CERTIFICATE_PATH}/app.key";
    echo "DONE";
    echo "SSL enabled: $SSL_ENABLED";
    exit 0;
  else
    echo "Certificates not found. Sleeping for $WAIT_INTERVAL_SECONDS seconds...";
    sleep $WAIT_INTERVAL_SECONDS;
    elapsed_time=$((elapsed_time + WAIT_INTERVAL_SECONDS));
  fi
done

# If the script reaches here, it means certificates were not found within the maximum wait time
echo "Timeout: Certificates not found within the specified time.";
exit 1;
