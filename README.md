# Minecraft Server

A containerized Minecraft Java server setup built with a custom Docker image and Docker Compose.

The project does not use a prebuilt Minecraft Docker image. Instead, the Dockerfile uses a Java runtime base image, downloads the official Minecraft server JAR during the build process, and runs the server with persistent data storage.

## Table of Contents

- [Repository Description](#repository-description)
- [Repository Structure](#repository-structure)
- [Requirements](#requirements)
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
├── .gitignore
├── Dockerfile
├── docker-compose.yaml
└── README.md
```

Repository files:

- `Dockerfile` - builds the custom Minecraft server image
- `docker-compose.yaml` - defines service configuration, ports, environment variables, volume, and restart policy
- `.gitignore` - excludes local files, secrets, and temporary development files
- `README.md` - documents setup, configuration, operation, and testing

## Requirements

Make sure Git, Docker, and Docker Compose are installed before running the quickstart commands.

- Git
- Docker
- Docker Compose

## Quickstart

1. Clone the repository:

```bash
git clone https://github.com/StevanAleksandrov/minecraft-server-project.git
```

2. Change into the project directory:

```bash
cd minecraft-server-project
```

3. Build and start the Minecraft server:

```bash
docker compose up -d --build
```

4. Check the service status:

```bash
docker compose ps
```

5. Follow the server logs:

```bash
docker compose logs -f mc-server
```

The server is available locally on `localhost:8888`.

On a cloud VM, the server is available on `<server-ip>:8888`.

## Usage

The Minecraft server service is configured in `docker-compose.yaml`.

By starting the container, the Minecraft EULA is accepted automatically through the generated `eula.txt` file. Only run the server if you agree to the Minecraft EULA.

### Memory Settings

```yaml
environment:
  MEMORY_MIN: "1G"
  MEMORY_MAX: "2G"
```

These values can be adjusted based on available resources and expected player count.

### Port Mapping

```yaml
ports:
  - "8888:25565"
```

This maps the public host or VM port `8888` to the internal Minecraft server port `25565` inside the container.

To use a different external port, modify the first value (e.g., `9999:25565`) and restart the service.

### Persistent Data Volume

```yaml
volumes:
  - mc_data:/data
```

The Dockerfile stores the Minecraft server application under `/opt/minecraft` and uses `/data` for runtime data such as world files, logs, generated libraries, and server configuration.

### Server Version

The Minecraft server download URL is configured as a build argument in the Dockerfile.

The server JAR should be downloaded from the official Minecraft Java server download page:

```text
https://www.minecraft.net/de-de/download
```

To update the server version:

1. Locate the new Minecraft server JAR URL from official sources
2. Update the `MINECRAFT_SERVER_URL` build argument in the Dockerfile
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

### Check if the container is running:

```bash
docker compose ps
```

Expected port mapping:

`0.0.0.0:8888->25565/tcp`

### Check the server logs:

```bash
docker compose logs -f mc-server
```

A successful startup includes a message similar to:

`Done (...)! For help, type "help"`

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


