#!/bin/bash

# Recreate config file
rm -rf ./env-config.js
touch ./env-config.js

# Add assignment 
echo "window._env_ = {" >> ./env-config.js

# Read each line in .env file
# Each line represents key=value pairs
while read -r line || [[ -n "$line" ]];
do
  # Split env variables by character `=`
  if printf '%s\n' "$line" | grep -q -e '='; then
    varName=$(printf '%s\n' "$line" | sed -e 's/=.*//')
    varValue=$(printf '%s\n' "$line" | sed -e 's/^[^=]*=//')
  fi

  echo "config $varName value..."
  # Read value of current variable if exists as Environment variable
  globalVarValue=$(printf '%s\n' "${!varName}")
  if [ ! -z $globalVarValue ]; then
    varValue=$globalVarValue;
    echo "found value of $varName in global vars ($varValue)";
  else
    echo "value for $varName not found in global vars, using default provided in .env ($varValue)";
  fi;

  # Append configuration property to JS file
  echo "  $varName: \"$varValue\"," >> ./env-config.js
done < .env

echo "}" >> ./env-config.js