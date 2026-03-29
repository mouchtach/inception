# Developer Documentation

This document explains how to set up, build, and manage the Inception stack.

## Prerequisites
- Docker Desktop or Docker Engine
- Docker Compose
- GNU Make

## Initial Setup
1) Clone the repository.
2) Create the secrets files under [secrets/](secrets/):
   - db_password.txt
   - db_root_password.txt
   - wp_password.txt
   - wp_admin_password.txt
   - redis_password.txt
   - ftp_password.txt
3) Configure environment variables in [srcs/.env](srcs/.env).

## Build and Launch
From the project root:

```
make up
```

This will:
- Create local data directories (bind mounts).
- Build and start all containers in detached mode.

To build images only:

```
make build
```

## Manage Containers and Volumes
Stop containers:

```
make stop
```

Start containers:

```
make start
```

Restart everything (including cleanup):

```
make restart
```

Stop and remove containers and volumes:

```
make down
```

Remove local data directories:

```
make clean
```

## Data Storage and Persistence
Bind mount directories are created in the project root:
- ./wordpress_data (WordPress files)
- ./mariadb_data (MariaDB data)
- ./portainer_data (Portainer data)

These persist across container restarts and rebuilds. Removing them will wipe data.

## Service Definitions
- Docker Compose file: [srcs/docker-compose.yml](srcs/docker-compose.yml)
- Dockerfiles and configs: [srcs/requirements/](srcs/requirements/)
- Secrets: [secrets/](secrets/)

## Useful Commands
- Show running containers:

```
make status
```

- View logs for a service:

```
docker-compose -f ./srcs/docker-compose.yml logs -f <service>
```

- Execute a shell in a container:

```
docker-compose -f ./srcs/docker-compose.yml exec <service> /bin/sh
```
