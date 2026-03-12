COMPOSE_DIR = ./srcs

.DEFAULT_GOAL := up

.PHONY: up down

up:
	mkdir -p wordpress_data
	mkdir -p mariadb_data
	cd $(COMPOSE_DIR) && docker compose up --build

down:
	cd $(COMPOSE_DIR) && docker compose down -v
	rm -rf wordpress_data
	rm -rf mariadb_data

