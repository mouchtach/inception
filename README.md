*This project has been created as part of the 42 curriculum by ymouchta.*

# Inception

## Description
Inception is a system administration project where a complete web stack is deployed with Docker and Docker Compose. The objective is to run isolated services that communicate correctly, persist data, and keep credentials secure.

This stack includes:
- Nginx (TLS reverse proxy)
- WordPress (PHP-FPM)
- MariaDB
- Redis
- Adminer
- FTP server
- Portainer
- Static website

Project sources are organized as follows:
- `srcs/docker-compose.yml`: service orchestration
- `srcs/requirements/`: Dockerfiles, configs, and startup scripts
- `secrets/`: secret files mounted at runtime
- `Makefile`: common lifecycle commands

### Project Design Choices
- One process-oriented container per service for clearer separation.
- Bridge Docker network (`inception`) for service discovery by container name.
- Secret material stored in `secrets/*.txt` and passed as Docker secrets.
- Persistent data stored in project data directories (`wordpress_data`, `mariadb_data`, `portainer_data`).

### Required Comparisons

#### Virtual Machines vs Docker
- Virtual Machines bundle a full guest OS, are heavier, and boot slower.
- Docker containers share the host kernel, are lighter, and start faster.
- This project uses Docker for reproducibility and operational simplicity.

#### Secrets vs Environment Variables
- Environment variables are easy to use but can be exposed in process output and inspect results.
- Docker secrets are mounted as files and reduce accidental exposure of credentials.
- This project keeps passwords in `secrets/*.txt` and reads them at runtime.

#### Docker Network vs Host Network
- Host networking removes network isolation and can increase port conflict risk.
- Bridge networking isolates traffic and keeps clean service-to-service naming.
- This project uses a custom bridge network for safer inter-service communication.

#### Docker Volumes vs Bind Mounts
- Docker volumes are Docker-managed persistent storage.
- Bind mounts map explicit host paths to containers.
- This project persists data in repository-level host directories configured in compose.

## Instructions

### Prerequisites
- Docker installed and running
- Docker Compose command available (`docker-compose` used by the Makefile)

### Build and Run
1. Start stack: `make`
2. Check running containers: `make status`
3. Tail logs: `make logs`

### Stop and Clean
- Stop stack: `make down`
- Remove persisted project data: `make clean`
- Full cleanup (containers/images/volumes/orphans): `make fclean`

### Access
- Website: `https://localhost`
- WordPress admin panel: `https://localhost/wp-admin`
- Portainer: `https://localhost:9443`
- Static website: `http://localhost:40`

### Quick Validation
- HTTPS check: `curl -kI https://localhost`
- MariaDB query:
  `docker compose -f srcs/docker-compose.yml exec mariadb mariadb -u"${DB_USER}" -p"$(cat secrets/db_password.txt)" -e "SELECT 1;"`
- Redis check:
  `docker compose -f srcs/docker-compose.yml exec redis redis-cli -a "$(cat secrets/redis_password.txt)" PING`

## Resources

### References
- Docker docs: https://docs.docker.com/
- Docker Compose docs: https://docs.docker.com/compose/
- Nginx docs: https://nginx.org/en/docs/
- MariaDB docs: https://mariadb.com/kb/en/documentation/
- WordPress docs: https://wordpress.org/documentation/
- Redis docs: https://redis.io/docs/

### AI Usage
AI was used for:
- writing and restructuring documentation files
- clarifying command descriptions and test steps
- refining troubleshooting wording in English

AI was not used as a substitute for local runtime checks; commands and service behavior were validated against the project environment.

## Additional Documentation
- End-user documentation: `USER_DOC.md`
- Developer documentation: `DEV_DOC.md`
- Service test guide: `TEST_GUIDE.md`
