# Minecraft Server

A containerized Minecraft Java server setup built with a custom Docker image and Docker Compose.

The project does not use a prebuilt Minecraft Docker image. Instead, the Dockerfile uses a Java runtime base image, downloads the official Minecraft server JAR during the build process, and runs the server with persistent data storage.

## Table of Contents

- [Repository Description](#repository-description)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Quickstart](#quickstart)
- [Usage](#usage)
- [Operations](#operations)
- [Testing](#testing)
- [Security Notes](#security-notes)


## Repository Description

This repository provides a Docker-based setup for running a Minecraft Java server.

Main components:

- Custom Dockerfile based on a Java runtime image
- Official Minecraft server JAR downloaded during image build
- Docker Compose service named `mc-server`
- Host port `8888` mapped to container port `25565`
- Persistent Docker volume for server data
- Restart policy for automatic container recovery

## Repository Structure

```text
.
├── docs/
│   └── cloud-minecraft-server-checklist.pdf
├── .gitignore
├── .dockerignore
├── Dockerfile
├── docker-compose.yaml
├── entrypoint.sh
├── example.env
└── README.md
```

Repository files:

- `Dockerfile` - builds the custom Minecraft server image
- `docker-compose.yaml` - defines the service configuration, port mapping, volume, restart policy, and environment file usage
- `entrypoint.sh` - prepares `eula.txt`, updates selected `server.properties` values, and starts the Minecraft server
- `example.env` - provides default environment values for local configuration
- `.gitignore` - excludes local files, secrets, and temporary development files
- `.dockerignore` - excludes unnecessary local files from the Docker build context
- `README.md` - documents setup, configuration, operation, and testing

## Prerequisites

Make sure the following tools are available before running the project:

- Git
- SSH access to GitHub
- Docker
- Docker Compose

## Quickstart

1. Clone the repository:

```bash
git clone git@github.com:StevanAleksandrov/minecraft-server-project.git
```

2. Change into the project directory:

```bash
cd minecraft-server-project
```

3. Create the environment file from the template:

```bash
cp example.env .env
```
The template contains the default configuration values, including the official Minecraft server JAR download URL used during the Docker image build.

4. Build and start the Minecraft server:

```bash
docker compose up -d --build
```

## Usage

The Minecraft server service is configured through `docker-compose.yaml` and an `.env` file.

By starting the container, the Minecraft EULA is accepted automatically through the generated `eula.txt` file. Only run the server if you agree to the Minecraft EULA.

### Access and Operation

With the default `HOST_PORT` value, the server is available locally at:

```text
localhost:8888
```

On a cloud VM, the server is available at:

```text
<server-ip>:8888
```

Check the service status:

```bash
docker compose ps
```

Follow the server logs:

```bash
docker compose logs -f mc-server
```

### Environment Configuration

The project uses an `.env` file for runtime configuration.

Create the local `.env` file from the provided template:

```bash
cp example.env .env
```

The `.env` file is ignored by Git and should not be committed. The `example.env` file is committed as a template with default values.

Available configuration values:

- `MEMORY_MIN` - minimum Java heap size
- `MEMORY_MAX` - maximum Java heap size
- `HOST_PORT` - host port mapped to the Minecraft server port
- `MAX_PLAYERS` - maximum number of players allowed on the server
- `MOTD` - server message of the day
- `MINECRAFT_SERVER_URL` - official Minecraft server JAR download URL

### Memory Settings

Memory settings are configured in the `.env` file:

```env
MEMORY_MIN=1G
MEMORY_MAX=2G
```

These values can be adjusted based on available resources and expected player count.

### Port Mapping

The external host port is configured through the `HOST_PORT` value in the `.env` file:

```env
HOST_PORT=8888
```

In `docker-compose.yaml`, this value is mapped to the internal Minecraft server port `25565`:

```yaml
ports:
  - "${HOST_PORT}:25565"
```

### Player Limit

The maximum number of players can be configured through the `.env` file:

```env
MAX_PLAYERS=10
```

During container startup, this value is written to `/data/server.properties`.

### Message of the Day

The server message of the day can be configured through the `.env` file:

```env
MOTD=DevSecOps Minecraft Server
```

During container startup, this value is written to `/data/server.properties`.

### Persistent Data Volume

```yaml
volumes:
  - mc_data:/data
```

The Dockerfile stores the Minecraft server application under `/opt/minecraft` and uses `/data` for runtime data such as world files, logs, generated libraries, and server configuration.

### Server Version

The Minecraft server download URL is configured through the `MINECRAFT_SERVER_URL` value in the `.env` file and passed as a build argument to the Dockerfile.

The template already contains the default official Minecraft server JAR URL. To use another version, update the `MINECRAFT_SERVER_URL` value in `.env`.

The official Minecraft Java server download page is:

```text
https://www.minecraft.net/de-de/download
```

To update the server version:

1. Locate the new official Minecraft server JAR URL
2. Update the `MINECRAFT_SERVER_URL` value in `.env`
3. Rebuild the image with `docker compose up -d --build`

## Operations

### Start the server:

```bash
docker compose up -d
```

### Stop the server:

```bash
docker compose down
```

### Rebuild the image and start the server:

```bash
docker compose up -d --build
```

### Restart only the Minecraft service:

```bash
docker compose restart mc-server
```

### View server logs:

```bash
docker compose logs -f mc-server
```

### Open a shell inside the running container:

```bash
docker exec -it minecraft-server sh
```

## Testing

### Check if the container is running

```bash
docker compose ps
```

Expected port mapping with the default configuration:

```text
0.0.0.0:8888->25565/tcp
```

### Check environment-based server configuration

```bash
docker exec -it minecraft-server sh -c "grep -E '^(max-players|motd)=' /data/server.properties"
```

Expected output:

```text
max-players=10
motd=DevSecOps Minecraft Server
```

### Check the server logs

```bash
docker compose logs -f mc-server
```

A successful startup includes a message similar to:

```text
Done (...)! For help, type "help"
```

### Check generated server data:

```bash
docker exec -it minecraft-server sh
ls -la /data
```

Expected files and directories include:

- `eula.txt`
- `server.properties`
- `logs/`
- `world/`
- `libraries/`

### Test persistence after restart:

```bash
docker compose down
docker compose up -d
docker exec -it minecraft-server ls -la /data
```

The previously generated server files should still exist.

### ⚠️ Data Deletion Warning

**Do not use the following command unless the persisted server data should be deleted intentionally:**

```bash
docker compose down -v
```

The `-v` option removes the Docker volume and permanently deletes all persisted Minecraft data.

### Optional Client Connection Test

- **Local testing:** Connect with a Minecraft Java client to `localhost:8888`
- **Cloud VM:** Connect to `<server-ip>:8888`

Optional protocol test with `mcstatus` can also be used from outside the container.

## Security Notes

- No SSH keys, passwords, tokens, usernames, or private credentials are stored in this repository
- No real server IP addresses are documented in the repository
- Use `<server-ip>:8888` as a placeholder for deployment documentation
- Local environment files, logs, secrets, keys, and temporary development files are excluded through `.gitignore`


