# User Documentation

This document explains how to use the Inception stack as an end user or administrator.

## Services Provided
- Nginx: HTTPS reverse proxy and public entry point.
- WordPress: main website (PHP-FPM).
- MariaDB: database for WordPress.
- Redis: object cache for WordPress.
- Adminer: database web UI.
- FTP: file access to WordPress content.
- Portainer: Docker management dashboard.
- Static website: overview page for the stack.

## Start and Stop the Project
From the project root:

```
make up
```

To stop everything:

```
make down
```

Other useful commands:

```
make start
make stop
make restart
make status
```

## Access the Website and Admin Panels
- WordPress (HTTPS): https://<DOMAIN_NAME>
  - The domain is defined in [srcs/.env](srcs/.env).
  - WordPress admin: https://<DOMAIN_NAME>/wp-admin
- Static website: http://localhost:40
- Portainer: https://localhost:9443
- FTP: connect to localhost:21 with passive ports 30000-30009

Adminer is exposed internally on port 8080 and is proxied by Nginx. If your Nginx config includes an Adminer location, access it via HTTPS on the same domain (e.g., https://<DOMAIN_NAME>/adminer).

## Credentials (Secrets)
Credentials are stored in text files under [secrets/](secrets/):
- db_password.txt
- db_root_password.txt
- wp_password.txt
- wp_admin_password.txt
- redis_password.txt
- ftp_password.txt

Do not commit or share these files publicly.

## Check That Services Are Running
- Quick check:

```
make status
```

- Detailed check:

```
docker-compose -f ./srcs/docker-compose.yml ps
```

You can also open Portainer to inspect containers and logs.
