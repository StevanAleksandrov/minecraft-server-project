FROM eclipse-temurin:25-jre-jammy

WORKDIR /data

ARG MINECRAFT_SERVER_URL="https://piston-data.mojang.com/v1/objects/97ccd4c0ed3f81bbb7bfacddd1090b0c56f9bc51/server.jar"

ENV MEMORY_MIN="1G"
ENV MEMORY_MAX="2G"
ENV SERVER_JAR="/opt/minecraft/server.jar"

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && mkdir -p /opt/minecraft /data \
    && curl -L -o ${SERVER_JAR} ${MINECRAFT_SERVER_URL} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 25565

CMD ["sh", "-c", "echo \"eula=true\" > /data/eula.txt && exec java -Xms${MEMORY_MIN} -Xmx${MEMORY_MAX} -jar ${SERVER_JAR} nogui"]