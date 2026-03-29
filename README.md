# Inception

Docker-based WordPress stack with Nginx, MariaDB, and bonus services (Redis, Adminer, FTP, Portainer, static website) orchestrated by Docker Compose.

## Features
- HTTPS entry point with Nginx reverse proxy
- WordPress + PHP-FPM backed by MariaDB
- Redis object cache for WordPress
- Adminer database UI (proxied)
- FTP access to WordPress files
- Portainer for Docker management
- Static site describing the stack
- Docker Secrets for credentials

## Architecture
Main flow: Browser -> Nginx (TLS) -> WordPress (FastCGI) -> MariaDB.

Bonus services (same bridge network): Redis, Adminer, FTP, Portainer, Static Site.

## Services and Ports
- Nginx: 443 (HTTPS), 2000->5000 (static site proxy)
- WordPress: 9000 (internal FastCGI)
- MariaDB: 3306 (internal)
- Redis: 6379
- Adminer: 8080 (internal, proxied)
- FTP: 21 and 30000-30009
- Portainer: 9443
- Static website: 40->2000

See [srcs/docker-compose.yml](srcs/docker-compose.yml) for the full setup.

## Data and Volumes
Bind mounts are stored in project root for easy portability:
- ./wordpress_data
- ./mariadb_data
- ./portainer_data

These are created automatically by `make up`.

## Secrets
Credentials are stored in text files under [secrets/](secrets/):
- db_password.txt
- db_root_password.txt
- wp_password.txt
- wp_admin_password.txt
- redis_password.txt
- ftp_password.txt

## Usage
From the project root:

```
make up
```

Other targets:

```
make down
make stop
make start
make restart
make build
make clean
make status
```

Targets are defined in [Makefile](Makefile).

## Configuration
Environment variables are in [srcs/.env](srcs/.env).

## Project Structure
- [srcs/docker-compose.yml](srcs/docker-compose.yml) - service definitions
- [srcs/requirements/](srcs/requirements/) - Dockerfiles and configs
- [secrets/](secrets/) - Docker Secrets values

## Notes
- The stack uses a single bridge network named `inception`.
- WordPress files are shared between Nginx and FTP via the same volume.
