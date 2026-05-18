FROM eclipse-temurin:25-jre-jammy

WORKDIR /data

ARG MINECRAFT_SERVER_URL="https://piston-data.mojang.com/v1/objects/97ccd4c0ed3f81bbb7bfacddd1090b0c56f9bc51/server.jar"

ENV MEMORY_MIN="1G"
ENV MEMORY_MAX="2G"
ENV SERVER_JAR="/opt/minecraft/server.jar"
ENV MAX_PLAYERS="10"
ENV MOTD="DevSecOps Minecraft Server"

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && mkdir -p /opt/minecraft /data \
    && curl -L -o ${SERVER_JAR} ${MINECRAFT_SERVER_URL} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Ensure Unix line endings and executable permissions for the entrypoint script
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 25565

CMD ["sh", "/usr/local/bin/entrypoint.sh"]