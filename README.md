*This project has been created as part of the 42 curriculum by ymouchta.*

# Inception

## Description

Inception is a system administration project that deepens your understanding of Docker and container orchestration. The goal is to build a small but complete web infrastructure — entirely from custom-written Dockerfiles — composed of multiple services communicating through a private Docker network, all orchestrated via Docker Compose.

The stack hosts a functional WordPress website backed by a MariaDB database, served through an NGINX reverse proxy with TLS encryption. Several bonus services extend the infrastructure with caching, FTP access, database management, a static portfolio site, and container management via Portainer.

All images are built from **Debian Bullseye** (penultimate stable release). No pre-built application images are pulled from Docker Hub. Secrets are managed through Docker secrets (mounted as files in `/run/secrets/`), and configuration values are stored in a `.env` file.

### Services Overview

| Service | Role | Port(s) |
|---|---|---|
| **nginx** | Reverse proxy + TLS termination | 443 (HTTPS), 2000→5000 (static site) |
| **wordpress** | WordPress + php-fpm | 9000 (internal, FastCGI) |
| **mariadb** | MySQL-compatible database | 3306 (internal) |
| **redis** *(bonus)* | Object cache for WordPress | 6379 (internal) |
| **adminer** *(bonus)* | Web-based DB management UI | 8080 (internal, proxied via NGINX at `/adminer`) |
| **ftp** *(bonus)* | FTP access to WordPress files | 21, 30000–30009 (passive) |
| **static_website** *(bonus)* | Static portfolio/showcase site | 40→2000 |
| **portainer** *(bonus)* | Docker container management UI | 9443 |

---

## Instructions

### Prerequisites

- Docker Engine and Docker Compose installed on the host.
- A virtual machine is required (as per the 42 subject).
- Add the domain to `/etc/hosts`:
  ```
  127.0.0.1   ymouchta.42.fr
  ```

### Setup

1. Clone the repository.
2. Populate the secrets files (see [DEV_DOC.md](./DEV_DOC.md) for details):
   ```
   secrets/db_password.txt
   secrets/db_root_password.txt
   secrets/wp_password.txt
   secrets/wp_admin_password.txt
   secrets/redis_password.txt
   secrets/ftp_password.txt
   ```
3. Review and adjust `srcs/.env` if needed.

### Running the project

```bash
# Build images and start all containers in detached mode
make

# Or explicitly:
make up

# Stop and remove containers + volumes
make down

# View live logs
make logs

# Check running containers
make status
```

The WordPress site will be available at `https://ymouchta.42.fr`.

---

## Project Description

### Design Choices

Each service runs in its own dedicated container, communicating through the custom `inception` bridge network. The NGINX container is the sole public entry point, listening only on port 443 with TLSv1.2/1.3. All other services are either unexposed or accessed via NGINX proxying.

A self-signed TLS certificate is generated at container startup by `certs.sh` using `openssl`.

WordPress is configured with WP-CLI at startup: it downloads WordPress core, creates the database configuration, installs WordPress, creates users, installs and enables the Redis object cache plugin, and finally starts php-fpm as PID 1.

MariaDB initialises by starting temporarily, creating the database and users from secrets, then re-launching `mysqld` as PID 1.

Redis uses password authentication, configured via Docker secrets, and is limited to 256 MB with an LRU eviction policy.

---

### Comparisons

#### Virtual Machines vs Docker

A Virtual Machine emulates complete hardware and runs its own full OS kernel, which makes it isolated but heavyweight (GBs of disk, minutes to start). Docker containers share the host kernel but isolate processes via namespaces and cgroups — they are lightweight (MBs), start in seconds, and are reproducible across environments. The trade-off is that containers provide weaker isolation than VMs: a kernel exploit can affect all containers on the host.

This project uses Docker within a VM to combine both: the VM provides strong hardware isolation, while Docker enables modular, reproducible service definitions.

#### Secrets vs Environment Variables

Environment variables are convenient but inherently insecure for sensitive data — they can be leaked through process listings, logs, child processes, or `docker inspect`. Docker secrets, by contrast, are mounted as in-memory `tmpfs` files at `/run/secrets/<name>` inside the container, are never written to the image layers, and are only accessible to services that explicitly declare them. This project uses Docker secrets for all passwords and credentials, reserving `.env` for non-sensitive configuration (domain name, usernames, etc.).

#### Docker Network vs Host Network

With `network: host`, a container shares the host's network stack — no isolation, and ports are exposed directly on the host interface. With a custom Docker bridge network (`driver: bridge`), each container gets its own IP within the virtual network, and inter-container communication happens by service name (DNS resolution). External access is only possible through explicitly published ports. This project uses a named bridge network (`inception`) so that services can reach each other by name (e.g., `mariadb`, `redis`) while remaining inaccessible from outside unless exposed.

#### Docker Volumes vs Bind Mounts

Bind mounts map a specific host path directly into the container — simple and transparent, but tightly coupled to the host filesystem layout. Docker named volumes are managed by Docker: their storage location on the host is determined by Docker (or overridden with `driver_opts`), they are portable in Docker tooling, and they persist independently of the container lifecycle. This project uses named volumes (`wordpress_data`, `mariadb_data`) for data persistence. The volumes are configured with `driver_opts` to store data at a known path (`./wordpress_data`, `./mariadb_data`) relative to the project root, satisfying the subject's requirement of a specific host directory.

---

## Resources

### Docker & System Administration

- [Docker official documentation](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/compose-file/)
- [Dockerfile best practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [PID 1 and signal handling in containers](https://cloud.google.com/architecture/best-practices-for-building-containers#signal-handling)
- [Docker secrets documentation](https://docs.docker.com/engine/swarm/secrets/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [WP-CLI documentation](https://developer.wordpress.org/cli/commands/)
- [Redis documentation](https://redis.io/docs/)
- [vsftpd documentation](https://security.appspot.com/vsftpd.html)
- [Portainer documentation](https://docs.portainer.io/)
- [Adminer documentation](https://www.adminer.org/)
- [TLS/SSL with OpenSSL](https://www.openssl.org/docs/)

### AI Usage

AI (Claude) was used in this project for the following tasks:

- **Documentation**: Generating and refining `README.md`, `USER_DOC.md`, and `DEV_DOC.md` based on the subject requirements and the actual codebase structure.
- **Debugging assistance**: Asking targeted questions about php-fpm configuration, WP-CLI flags, and vsftpd passive mode settings to troubleshoot specific issues.
- **Concept clarification**: Getting concise explanations of PID 1 behavior, Docker secrets internals, and TLS handshake flow to inform implementation decisions.

All AI-generated content was reviewed, tested, and validated before inclusion in the project.
