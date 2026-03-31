# DEV_DOC

## 1. Prerequisites and Setup From Scratch

### Prerequisites
- Docker Engine
- Docker Compose (`docker-compose` command)
- GNU Make

### Project Configuration
- Core orchestration: `srcs/docker-compose.yml`
- Environment values: `srcs/.env`
- Secrets source files: `secrets/*.txt`
- Build/run helper: `Makefile`

### Setup Steps
1. Clone repository.
2. Ensure secret files exist in `secrets/`.
3. Review `srcs/.env` for usernames/domain/title.
4. Build and start stack with `make`.

## 2. Build and Launch With Makefile and Compose

### Make Targets
- `make` or `make up`: create data dirs and start containers in background
- `make build`: build all service images
- `make down`: stop and remove containers
- `make stop`: stop containers without removing
- `make start`: start previously created containers
- `make logs`: follow logs for all services
- `make status`: show running containers
- `make clean`: remove persisted data directories
- `make fclean`: full cleanup (down -v, remove images/orphans, prune)

### Direct Compose Commands
- Start stack: `docker-compose -f ./srcs/docker-compose.yml up -d`
- Show logs: `docker-compose -f ./srcs/docker-compose.yml logs -f`
- Exec into service: `docker-compose -f ./srcs/docker-compose.yml exec <service> sh`

## 3. Manage Containers and Volumes
- List containers: `docker ps`
- Inspect a container: `docker inspect <container_name>`
- Follow one service log: `docker-compose -f ./srcs/docker-compose.yml logs -f <service>`
- Remove stack resources: `docker-compose -f ./srcs/docker-compose.yml down -v --remove-orphans`

## 4. Data Persistence
Project data is persisted in host directories at repository root:
- `wordpress_data/` mapped to WordPress data path
- `mariadb_data/` mapped to MariaDB data path
- `portainer_data/` mapped to Portainer data path

Persistence configuration is defined in `srcs/docker-compose.yml` under `volumes:` with `driver_opts` and bind paths.

## 5. Service Development Notes
- Service build contexts are under `srcs/requirements/`.
- Entry scripts are in each service `tools/` folder.
- Main configs are in each service `conf/` folder.
- Secrets are read from `/run/secrets/*` inside containers where configured.
