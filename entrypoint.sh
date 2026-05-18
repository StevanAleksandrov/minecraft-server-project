#!/bin/sh
set -eu

SERVER_PROPERTIES="/data/server.properties"

echo "eula=true" > /data/eula.txt
touch "$SERVER_PROPERTIES"

set_property() {
  KEY="$1"
  VALUE="$2"

  if grep -q "^${KEY}=" "$SERVER_PROPERTIES"; then
    sed -i "s|^${KEY}=.*|${KEY}=${VALUE}|" "$SERVER_PROPERTIES"
  else
    echo "${KEY}=${VALUE}" >> "$SERVER_PROPERTIES"
  fi
}

set_property "max-players" "${MAX_PLAYERS:-10}"
set_property "motd" "${MOTD:-DevSecOps Minecraft Server}"

exec java -Xms"${MEMORY_MIN:-1G}" -Xmx"${MEMORY_MAX:-2G}" -jar "${SERVER_JAR:-/opt/minecraft/server.jar}" nogui