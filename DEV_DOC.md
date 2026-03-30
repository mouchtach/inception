# DEV_DOC.md — Developer Documentation

## Prerequisites

Before anything else, you need Docker and Docker Compose on your machine.

**Install Docker:**
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

**Install Docker Compose:**
```bash
sudo apt-get install -y docker-compose-plugin
# verify both work
docker --version
docker compose version
```

You also need `make`:
```bash
sudo apt-get install -y make
```

Finally, add the project domain to your `/etc/hosts`:
```bash
echo "127.0.0.1   ymouchta.42.fr" | sudo tee -a /etc/hosts
```

---

## Project Structure

```
.
├── Makefile
├── secrets/              ← passwords go here (never commit this!)
├── srcs/
│   ├── .env              ← non-sensitive config (usernames, domain...)
│   ├── docker-compose.yml
│   └── requirements/
│       ├── nginx/
│       ├── mariadb/
│       ├── wordpress/
│       └── bonus/
│           ├── redis/
│           ├── adminer/
│           ├── ftp/
│           ├── portainer/
│           └── static_website/
```

---

## First-Time Setup

### 1. Create the secrets files

Each file should contain only the password, nothing else:

```bash
echo -n "a_strong_db_password"    > secrets/db_password.txt
echo -n "a_strong_root_password"  > secrets/db_root_password.txt
echo -n "a_strong_wp_password"    > secrets/wp_password.txt
echo -n "a_strong_admin_password" > secrets/wp_admin_password.txt
echo -n "a_strong_redis_password" > secrets/redis_password.txt
echo -n "a_strong_ftp_password"   > secrets/ftp_password.txt
```

### 2. Check `srcs/.env`

```dotenv
DB_NAME=wordpress
DB_USER=wpuser
DB_HOST=mariadb
DOMAIN_NAME=ymouchta.42.fr
WP_TITLE=Inception
WP_ADMIN_USR=ymouchta
WP_ADMIN_EMAIL=ymouchta@student.42.fr
WP_USR=user42
WP_EMAIL=user42@example.com
FTP_USER=youssef
```

Change any of these to match your setup.

---

## Running the Project

```bash
make          # build images + start everything
make stop     # pause containers (data stays)
make down     # full teardown (removes volumes too)
make restart  # clean slate restart
make build    # rebuild images without starting
make logs     # follow logs from all containers
make status   # quick overview of running containers
```

> First run takes a few minutes — Docker is building all images from scratch.

---

## Useful Commands

```bash
# Get a shell inside a container
docker exec -it wordpress bash
docker exec -it mariadb bash

# Watch one container's logs
docker logs -f wordpress

# Rebuild and restart just one service
docker compose -f srcs/docker-compose.yml build wordpress
docker compose -f srcs/docker-compose.yml up -d --no-deps wordpress
```

---

## Where Data Lives

| Volume | Stored at (host) | What's inside |
|---|---|---|
| `wordpress_data` | `./wordpress_data` | WP files, themes, uploads |
| `mariadb_data` | `./mariadb_data` | Database files |
| `portainer_data` | `./portainer_data` | Portainer state |

Data survives `make stop`. It's only wiped by `make down` or manually removing these folders.

---

## How Services Boot Up

- **MariaDB** — starts temporarily, creates the DB and users from secrets, then restarts as PID 1.
- **WordPress** — waits for MariaDB, runs WP-CLI to install WordPress and create users, sets up Redis cache, then runs php-fpm as PID 1.
- **NGINX** — generates a self-signed TLS cert, then starts nginx in the foreground.
- **Redis** — reads password from secrets, starts with auth required.
- **Adminer** — downloads `adminer.php` at runtime, serves it on port 8080.
- **FTP** — creates the FTP user from secrets, starts vsftpd.

---

## Network

All containers talk to each other over the `inception` bridge network using their service names (e.g. `mariadb`, `redis`). Only these ports are exposed outside:

| Port | Service |
|---|---|
| `443` | NGINX (HTTPS) |
| `2000` | NGINX → static site |
| `21`, `30000–30009` | FTP |
| `9443` | Portainer |
| `40` | Static website |
