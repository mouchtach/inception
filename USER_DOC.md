# USER_DOC

## 1. Services Provided
This stack provides:
- A WordPress website behind Nginx with HTTPS
- MariaDB database for WordPress
- Redis cache service
- Adminer database management UI (internal service)
- FTP access to WordPress files
- Portainer container management UI
- A separate static website service

## 2. Start and Stop the Project
- Start all services: `make`
- Stop all services: `make down`
- Show container status: `make status`
- Stream logs: `make logs`

## 3. Access Website and Admin Panel
- Main website: `https://localhost`
- WordPress admin panel: `https://localhost/wp-admin`

Use your browser and accept the self-signed certificate warning for local testing.

## 4. Locate and Manage Credentials
- Usernames and non-secret settings: `srcs/.env`
- Password files:
  - `secrets/db_password.txt`
  - `secrets/db_root_password.txt`
  - `secrets/wp_password.txt`
  - `secrets/wp_admin_password.txt`
  - `secrets/redis_password.txt`
  - `secrets/ftp_password.txt`

To change credentials, edit the corresponding file in `secrets/`, then recreate services:
1. `make down`
2. `make`

## 5. Basic Service Health Checks
- Website responds:
  `curl -kI https://localhost`
- MariaDB responds:
  `docker compose -f srcs/docker-compose.yml exec mariadb mariadb-admin ping`
- Redis responds:
  `docker compose -f srcs/docker-compose.yml exec redis redis-cli -a "$(cat secrets/redis_password.txt)" PING`
- Portainer responds:
  `curl -kI https://localhost:9443`
- Static website responds:
  `curl -I http://localhost:40`

## 6. Data Reset
- Remove persisted project data directories: `make clean`
- Full cleanup including images/volumes: `make fclean`

Warning: `make clean` and `make fclean` remove persisted data.
