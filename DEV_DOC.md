# DEV_DOC.md — Developer Documentation

## Prerequisites

- A Virtual Machine running Linux (Debian/Ubuntu recommended).
- Docker Engine ≥ 20.10 and Docker Compose ≥ 1.29 installed.
- `make` installed.
- The domain `ymouchta.42.fr` must resolve to `127.0.0.1`. Add to `/etc/hosts`:
  ```
  127.0.0.1   ymouchta.42.fr
  ```

---

## Repository Structure

```
.
├── Makefile
├── secrets/
│   ├── db_password.txt
│   ├── db_root_password.txt
│   ├── wp_password.txt
│   ├── wp_admin_password.txt
│   ├── redis_password.txt
│   └── ftp_password.txt
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/default.conf      # NGINX virtual hosts (443 + 5000)
        │   └── tools/certs.sh         # Generates self-signed TLS cert, starts nginx
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/99-inception.cnf  # bind-address = 0.0.0.0
        │   └── tools/script.sh        # DB init script, then exec mysqld
        ├── wordpress/
        │   ├── Dockerfile
        │   └── tools/script.sh        # WP-CLI setup, Redis activation, exec php-fpm
        └── bonus/
            ├── redis/
            ├── adminer/
            ├── ftp/
            ├── portainer/
            └── static_website/
```

---

## Setting Up from Scratch

### 1. Create the secrets files

Each file must contain only the secret value (no trailing newline is fine):

```bash
echo -n "your_db_password"       > secrets/db_password.txt
echo -n "your_db_root_password"  > secrets/db_root_password.txt
echo -n "your_wp_user_password"  > secrets/wp_password.txt
echo -n "your_wp_admin_password" > secrets/wp_admin_password.txt
echo -n "your_redis_password"    > secrets/redis_password.txt
echo -n "your_ftp_password"      > secrets/ftp_password.txt
```

> **Important:** The `secrets/` directory must be listed in `.gitignore`. Never commit these files.

### 2. Review `srcs/.env`

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

Adjust these values as needed. Passwords are **not** stored here — only in `secrets/`.

---

## Building and Launching

```bash
# Build all images and start containers (detached)
make

# Build images only (no start)
make build

# Start previously built containers
make start

# Stop running containers (data preserved)
make stop

# Full teardown: stop containers, remove volumes and networks
make down

# Remove data directories and restart fresh
make restart

# Stream logs from all containers
make logs

# Show running containers
make status
```

> `make up` (called by `make all`) also creates the local data directories `./wordpress_data`, `./mariadb_data`, and `./portainer_data` before launching Compose.

---

## Container and Volume Management

### Useful Docker commands

```bash
# Enter a running container
docker exec -it wordpress bash
docker exec -it mariadb bash
docker exec -it nginx bash

# View logs for a single container
docker logs -f wordpress
docker logs -f mariadb

# Inspect a container's environment
docker inspect wordpress

# List all volumes
docker volume ls

# Remove a specific volume
docker volume rm <volume_name>
```

### Rebuilding a single service

```bash
cd srcs
docker-compose -f docker-compose.yml build wordpress
docker-compose -f docker-compose.yml up -d --no-deps wordpress
```

---

## Data Persistence

| Volume | Host Path | Container Path | Contains |
|---|---|---|---|
| `wordpress_data` | `./wordpress_data` | `/var/www/html` | WordPress core files, themes, plugins, uploads |
| `mariadb_data` | `./mariadb_data` | `/var/lib/mysql` | MariaDB databases |
| `portainer_data` | `./portainer_data` | `/data` | Portainer configuration and state |

All paths are relative to the project root (where `Makefile` lives). The `Makefile` creates these directories with `mkdir -p` before Compose starts.

The NGINX and FTP containers also mount `wordpress_data` at `/var/www/html` to serve and access the same WordPress files.

**Volumes survive `make stop` and `make start`.** They are only removed by `make down` (which passes `--volumes` to Compose) or by explicit `docker volume rm`.

---

## How Each Service Initialises

### MariaDB (`tools/script.sh`)
1. Starts `mariadb` in the background temporarily.
2. Waits for `mariadb-admin ping` to succeed.
3. Creates the database, user, and sets the root password from secrets.
4. Kills the temporary process, then re-runs `mysqld` as PID 1 (`exec mysqld`).

### WordPress (`tools/script.sh`)
1. Downloads WordPress core with WP-CLI if `wp-config.php` doesn't exist.
2. Waits for MariaDB to be reachable.
3. Installs WordPress (site title, admin user, admin password from secrets).
4. Creates the regular author user if not already present.
5. Installs and enables the `redis-cache` plugin; configures `WP_REDIS_HOST`, `WP_REDIS_PASSWORD`, `WP_REDIS_PORT` in `wp-config.php`.
6. Adjusts php-fpm to listen on port `9000`.
7. Runs `php-fpm -F` as PID 1 (`exec`).

### NGINX (`tools/certs.sh`)
1. Generates a self-signed RSA-2048 certificate and key for `ymouchta.42.fr`.
2. Runs `nginx -g "daemon off;"` as PID 1.

### Redis (`tools/start.sh`)
1. Reads the password from `/run/secrets/redis_password`.
2. Runs `redis-server` with the config file and `--requirepass` as PID 1 (`exec`).

### Adminer (`tools/script.sh`)
1. Downloads `adminer.php` from adminer.org at runtime.
2. Serves it with PHP's built-in server on port `8080`.

### FTP (`tools/start.sh`)
1. Creates the FTP user with the password from secrets.
2. Adds the user to the vsftpd userlist.
3. Runs `vsftpd` in the foreground as PID 1 (`exec`).

---

## Network

All services are connected to the `inception` bridge network. Containers reference each other by service name (e.g., `mariadb`, `redis`, `wordpress`, `adminer`). Only the ports explicitly published in `docker-compose.yml` are accessible from outside the Docker network:

| Published Port | Service | Protocol |
|---|---|---|
| `443` | nginx | HTTPS |
| `2000` → `5000` | nginx (static site) | HTTPS |
| `21`, `30000–30009` | ftp | FTP (passive) |
| `6379` | redis | TCP |
| `9443` | portainer | HTTPS |
| `40` → `2000` | static_website | HTTP |

`network: host` and `--link` are not used, as required by the subject.
