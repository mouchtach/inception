*This project has been created as part of the 42 curriculum by ymouchta.*

# Inception

## 📌 About the Project

Inception is a system administration project from 42 where you learn how to use Docker by building a small web infrastructure.

The goal is simple: create multiple services (WordPress, database, web server, etc.) that work together inside containers using Docker Compose.

Everything is built manually using **Debian Bullseye**, without pulling ready-made images.

---

## ⚙️ What’s Inside

This project runs a complete website with:

- **NGINX** → handles HTTPS and acts as a reverse proxy  
- **WordPress** → the website  
- **MariaDB** → the database  

### Bonus services:
- **Redis** → improves WordPress performance (cache)  
- **Adminer** → manage the database from browser  
- **FTP** → access WordPress files  
- **Static website** → small portfolio page  
- **Portainer** → manage Docker containers visually  

---

## 🚀 How to Run

### 1. Setup domain
Add this to your `/etc/hosts`:
127.0.0.1 ymouchta.42.fr

### 2. Add secrets
Create files inside `secrets/` (passwords, etc.)

### 3. Start the project
make

Other useful commands:
make down    # stop everything
make logs    # show logs
make status  # show containers

Open in browser:
https://ymouchta.42.fr

---

## 🧠 How It Works (Simple)

- Each service runs in its **own container**
- Containers talk through a **private Docker network**
- Only **NGINX is exposed** to the outside
- HTTPS is enabled using a **self-signed certificate**
- Data is saved using **Docker volumes**
- Passwords are stored securely using **Docker secrets**

---

## ⚖️ Quick Concepts

- **Docker vs VM**  
  Docker is faster and lighter. VM is heavier but more isolated.

- **Secrets vs .env**  
  Secrets = safe for passwords  
  `.env` = for normal config

- **Bridge Network**  
  Containers communicate safely using names like `mariadb`, `redis`

---

## 📚 Resources

- Docker docs  
- NGINX, MariaDB, Redis docs  
- WP-CLI  

---

## 🤖 AI Usage

AI was used to:
- Help write documentation  
- Debug some issues  
- Explain concepts  

Everything was tested and verified before use.
