# USER_DOC.md — User Documentation

## What Services Are Provided?

The Inception stack runs the following services:

| Service | What it does | How to access |
|---|---|---|
| **WordPress** | The main website and CMS | `https://ymouchta.42.fr` |
| **MariaDB** | Database backend (internal) | Not directly accessible |
| **NGINX** | HTTPS entry point and reverse proxy | Port 443 |
| **Redis** | WordPress object cache (internal) | Not directly accessible |
| **Adminer** | Web-based database management | `https://ymouchta.42.fr/adminer` |
| **FTP** | File access to the WordPress volume | Port 21 (passive: 30000–30009) |
| **Static Website** | Portfolio/showcase page | `http://ymouchta.42.fr:40` |
| **Portainer** | Docker container management | `https://ymouchta.42.fr:9443` |

---

## Starting and Stopping the Project

Open a terminal at the root of the project directory.

**Start everything:**
```bash
make
```
This builds all images (if not already built) and starts all containers in the background.

**Stop all containers (keep data):**
```bash
make stop
```

**Stop and remove containers + volumes (full teardown):**
```bash
make down
```

**Restart from a clean state:**
```bash
make restart
```

---

## Accessing the Website and Administration Panel

### WordPress Site
Open your browser and navigate to:
```
https://ymouchta.42.fr
```
> The certificate is self-signed. Your browser will show a security warning — click **Advanced → Accept the risk and continue** (or equivalent) to proceed.

### WordPress Admin Panel
```
https://ymouchta.42.fr/wp-admin
```
Log in with the administrator credentials (see **Credentials** section below).

### Adminer (Database UI)
```
https://ymouchta.42.fr/adminer
```
Select **MySQL** as the system, enter `mariadb` as the server, and use the database credentials.

### Static Website
```
http://ymouchta.42.fr:40
```

### Portainer (Container Management)
```
https://ymouchta.42.fr:9443
```
On first access, Portainer will prompt you to create an admin account.

---

## Credentials

All credentials are stored in the `secrets/` folder at the project root. **This folder must never be committed to Git.**

| Secret File | Purpose |
|---|---|
| `secrets/wp_admin_password.txt` | WordPress administrator password |
| `secrets/wp_password.txt` | WordPress regular user password (also used for FTP) |
| `secrets/db_password.txt` | MariaDB user (`wpuser`) password |
| `secrets/db_root_password.txt` | MariaDB root password |
| `secrets/redis_password.txt` | Redis authentication password |
| `secrets/ftp_password.txt` | FTP user password |

Non-sensitive configuration (usernames, domain, etc.) is in `srcs/.env`:

| Variable | Value |
|---|---|
| `DOMAIN_NAME` | `ymouchta.42.fr` |
| `WP_ADMIN_USR` | `ymouchta` |
| `WP_USR` | `user42` |
| `FTP_USER` | `youssef` |
| `DB_USER` | `wpuser` |
| `DB_NAME` | `wordpress` |

---

## Checking That Services Are Running

**List all running containers:**
```bash
make status
# or
docker ps
```

All containers should show `Up` status. You should see: `nginx`, `wordpress`, `mariadb`, `redis`, `adminer`, `ftp`, `static_website`, `portainer`.

**View live logs for all services:**
```bash
make logs
```

**View logs for a specific service:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Check NGINX is responding:**
```bash
curl -k https://ymouchta.42.fr
```
A `200 OK` or a WordPress HTML response confirms NGINX and WordPress are working.

**Check the database is reachable (from within the WordPress container):**
```bash
docker exec -it wordpress mysqladmin ping -h mariadb -u wpuser -p
```
